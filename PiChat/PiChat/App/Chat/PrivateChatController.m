//
//  PrivateChatController.m
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "PrivateChatController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "ConversationManager.h"
#import "MediaViewerController.h"
#import "AVIMTypedMessage+ToJsqMessage.h"
#import "BubbleImgFactory.h"
#import "UserManager.h"
#import "MediaPicker.h"
#import "CommenUtil.h"
#import "FileUpLoader.h"
#import "AudioRecorderController.h"
#import "InputContentView.h"
#import <Masonry.h>
#import "LocationViewerController.h"
#import "RecordIndocator.h"
#import "JSQMessage+MessageID.h"
#import "JSQVideoMediaItem+Thumbnail.h"
#import "JSQPhotoMediaItem+ThumbnailImageUrl.h"
#import "NSNotification+UserUpdate.h"
#import "NSNotification+DownloadImage.h"
#import "NSNotification+ReceiveMessage.h"
#import "NSNotification+LocationCellUpdate.h"
#import "TextPathRefreshControl.h"
#import "CommenUtil.h"
#import "ImageCache.h"
#import <MJRefresh.h>
#import <IQKeyboardManager.h>
#import "UICollectionView+PendingReloadData.h"


@import CoreImage;

@interface PrivateChatController ()<AVIMClientDelegate,UIActionSheetDelegate,AudioRecorderDelegate,InputAttachmentViewDelegate,LocationViewerDelegate>
@property (strong,nonatomic) User *chatToUser;
@property (strong,nonatomic) NSMutableArray *msgs;
@property (strong,nonatomic) BubbleImgFactory *bubbleImgFactory;
@property (strong,nonatomic) AVIMConversation *conversation;
@property (strong,nonatomic) ConversationManager *conversationManager;
@property (strong,nonatomic) MediaPicker *mediaPicker;
@property (strong,nonatomic) FileUpLoader *fileUpLoader;
@property (strong,nonatomic) AudioRecorderController *recorder;
@property (strong,nonatomic) RecordIndocator *indocator;
@property (strong,nonatomic) UserManager *userManager;
@end

@implementation PrivateChatController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed=YES;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTyperMessage:) name:kDidReceiveTypedMessageNotification object:nil];
        //
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadingMediaNotification:) name:kUploadMediaNotification object:nil];
        //
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLocationCellNotification:) name:kLocationCellNeedUpdateNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadImageNotification:) name:kDownloadImageCompleteNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [self.collectionView removePendingReload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter
-(User *)currentUser{
    return [User currentUser];
}

-(NSMutableArray *)msgs{
    if(!_msgs){
        _msgs=[NSMutableArray array];
    }
    return _msgs;
}

-(MediaPicker *)mediaPicker{
    if(!_mediaPicker){
        _mediaPicker=[MediaPicker new];
    }
    return _mediaPicker;
}

-(FileUpLoader *)fileUpLoader{
    if(!_fileUpLoader){
        _fileUpLoader=[FileUpLoader sharedFileUpLoader];
    }
    return _fileUpLoader;
}

-(AudioRecorderController *)recorder{
    if(!_recorder){
        _recorder=[[AudioRecorderController alloc]init];
    }
    return _recorder;
}

-(UserManager *)userManager{
    if(!_userManager){
        _userManager=[UserManager sharedUserManager];
    }
    return _userManager;
}

-(RecordIndocator *)indocator{
    if(!_indocator){
        _indocator=[[RecordIndocator alloc]init];
        [self.view addSubview:_indocator];
        _indocator.hidden=YES;
        [_indocator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.2);
            make.height.equalTo(self.view).multipliedBy(0.15);
        }];
    }
    return _indocator;
}

#pragma mark - Life Cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyScrollsToMostRecentMessage=NO;
    
    //下拉刷新
    self.collectionView.mj_header=[TextPathRefreshControl headerWithRefreshingTarget:self refreshingAction:@selector(loadHistoryMsg:)];
    //自定义下面的输入 inputToolBar
    InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
    [inputView decorateView];
    inputView.inputAttachmentView.delegate=self;
    inputView.recordBlock=^(BOOL isRecord){
        if(isRecord){
            [self.recorder startRecord];
            self.indocator.hidden=NO;
        }else{
            self.indocator.hidden=YES;
            [self.recorder endRecord];
        }
    };
    //
    self.recorder.delegate=self;
    //
    self.bubbleImgFactory=[BubbleImgFactory sharedBubbleImgFactory];
    //
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.conversationManager=[ConversationManager sharedConversationManager];
    self.senderId=self.conversationManager.currentUser.clientID;
    self.senderDisplayName=self.conversationManager.currentUser.displayName;
    //
    self.inputToolbar.contentView.rightBarButtonItem.enabled=NO; //禁用发送按钮
    //
    [self.userManager findUserByClientID:self.chatToUserID callback:^(User *user, NSError *error) {
        self.chatToUser=user;
        
        [self.collectionView pendingReloadData];
    }];
    
    //初始化对话
    [self.conversationManager chatToUser:self.chatToUserID callback:^(AVIMConversation *conversation, NSError *error) {
        self.conversation=conversation;
        self.inputToolbar.contentView.rightBarButtonItem.enabled=YES;
        [self.conversationManager fetchConversationMessages:conversation callback:^(NSArray *objects, NSError *error) {
            //异步解析 typed messages
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self addTypedMessage:obj toArrayHead:NO reloadData:NO];
                }];
                [self performSelectorOnMainThread:@selector(finishReceivingMessage) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(scrollToBottomAnimated:) withObject:@(YES) waitUntilDone:NO];
            });
        }];
        
    }];
    
}

#pragma mark - 收到新消息

-(void)didReceiveTyperMessage:(NSNotification*)noti{
    AVIMTypedMessage *typedMsg= noti.message;
    [self addTypedMessage:typedMsg];
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
}

#pragma mark - JSQMessagesCollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.msgs.count;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *msg= self.msgs[indexPath.item];
    if([msg.media isKindOfClass:[JSQPhotoMediaItem class]]){
        JSQPhotoMediaItem *mediaItem=(JSQPhotoMediaItem*)msg.media;
        mediaItem.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:mediaItem.thumbnailImageUrl];
    }
    return msg;
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = [self.msgs objectAtIndex:indexPath.item];
    return [self.bubbleImgFactory bubbleImgForMessage:message];
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = [self.msgs objectAtIndex:indexPath.item];
    return [self.userManager avatarForClientID:message.senderId];
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self needShowCellTopLabelForIndexPath:indexPath]){
        JSQMessage *msg=self.msgs[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:msg.date];
    }
    return nil;
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self needShowCellTopLabelForIndexPath:indexPath]){
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

-(BOOL)needShowCellTopLabelForIndexPath:(NSIndexPath*)indexPath{
    if(indexPath.item-1>0){
        JSQMessage *msg=self.msgs[indexPath.item];
        JSQMessage *lastMsg=self.msgs[indexPath.item-1];
        NSTimeInterval timeInterval= [msg.date timeIntervalSinceDate:lastMsg.date];
        if(timeInterval>3*60){//3分钟
            return YES;
        }
    }
    return NO;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    //可以 Custome Cell
    //FIXME Temp Bug : 横屏 ipad 开启 App,Cell 的 width = 1016;
    return cell;
}

/**
 *  点击 cell
 *
 *  @param collectionView
 *  @param indexPath      
 */
-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *msg= self.msgs[indexPath.item];
    id<JSQMessageMediaData> media= msg.media;
    if([media isMemberOfClass:[JSQPhotoMediaItem class]]){
        NSString *originalImgUrlStr= ((JSQPhotoMediaItem*)media).originalImageUrl;
        NSURL *imgUrl= [NSURL URLWithString:originalImgUrlStr];
        [MediaViewerController showIn:self withImageUrl:imgUrl];
    }else if([media isMemberOfClass:[JSQVideoMediaItem class]]){
        NSURL *videoUrl= ((JSQVideoMediaItem*)media).fileURL;
        [MediaViewerController showIn:self withVideoUrl:videoUrl];
    }else if([media isMemberOfClass:[JSQLocationMediaItem class]]){
        [MediaViewerController showIn:self withLocation:((JSQLocationMediaItem*)msg.media).location];
    }
    
}

#pragma mark JSQMessagesViewController Delegate

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    if(!text && text.length==0){ //没有文字内容
        return;
    }
    [self sendTextMsg:text];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
    [inputView toggleAttachmentKeyBoard];
}

#pragma mark - 更新上传媒体文件进度,上传完成发送消息

-(void)uploadingMediaNotification:(NSNotification*)noti{
    UploadState uploadState= noti.uploadState;
    
    switch (uploadState) {
        case UploadStateComplete:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AVFile *media=noti.uploadedFile;
            UploadedMediaType mediaType= noti.mediaType;
            AVIMTypedMessage *msg;
            switch (mediaType) {
                case UploadedMediaTypeVideo:
                    //TODO 我们需要 videoFormat 么?
                    msg=[AVIMVideoMessage messageWithText:nil file:media attributes:@{kVideoFormat:media.url.pathExtension}];
                    break;
                case UploadedMediaTypeAduio:
                    break;
                case UploadedMediaTypePhoto:
                    msg=[AVIMImageMessage messageWithText:nil file:media attributes:nil];
                    break;
                case UploadedMediaTypeFile:
                    break;

            }
            
            [self sendMessage:msg];
        }
        break;
        case UploadStateProgress:{
            [MBProgressHUD HUDForView:self.view].progress=noti.progress;
        }
        break;
        case UploadStateFailed:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [CommenUtil showMessage:[NSString stringWithFormat:@"上传失败 : %@",noti.error] inVC:self];
        }
        break;
    }
}

#pragma mark - 下载完用户头像,聊天发送的图片,刷新 collectionView
-(void)downloadImageNotification:(NSNotification *)noti{
    [self.collectionView pendingReloadData];
}

#pragma mark - 用户更新完毕,更新这个 Viewcontroller 的 User
-(void)userUpdateNotification:(NSNotification*)noti{
    User *u= noti.user;
    if([u.clientID isEqualToString:self.chatToUserID]){
        self.chatToUser=u;
        [self.collectionView pendingReloadData];
    }else if(self.currentUser.clientID){
        self.senderDisplayName=self.currentUser.displayName;
        [self.collectionView pendingReloadData];
    }
}

#pragma mark - 发送消息

-(void)showPhotoPicker{
    [self.mediaPicker showImagePickerIn:self multipleSelectionCount:1 callback:^(NSArray *objects, NSError *error) {
        [self.fileUpLoader uploadImage:[objects firstObject]];
        [MBProgressHUD showProgressInView:self.view];
    }];
}

-(void)showVideoPicker{
    [self.mediaPicker showVideoPickerIn:self callback:^(NSURL *url, NSError *error) {
        [self.fileUpLoader uploadVideoAtUrl:url];
        [MBProgressHUD showProgressInView:self.view];
    }];
}

-(void)showLocationPicker{
    LocationViewerController *locationViewer=[[LocationViewerController alloc]init];
    locationViewer.action=LocationViewerActionPickLocation;
    locationViewer.delegate=self;
    [self presentViewController:locationViewer animated:YES completion:nil];
}

/**
 *  location cell 需要创建 mapview 然后截图,是异步的,要刷新一下 ~
 *
 *  @param noti
 */
-(void)updateLocationCellNotification:(NSNotification*)noti{
    JSQMessage *jsqMessageThatNeedUpdate= noti.jsqMessageThatNeedUpdate;
    [self.msgs enumerateObjectsUsingBlock:^(JSQMessage *msg, NSUInteger idx, BOOL * _Nonnull stop) {
        if(jsqMessageThatNeedUpdate == msg){
            *stop=YES;
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:idx inSection:0];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }];
}

-(void)sendTextMsg:(NSString*)text{
    AVIMTypedMessage *msg=[AVIMTextMessage messageWithText:text attributes:nil];
    self.inputToolbar.contentView.textView.text=@"";
    [self sendMessage:msg];
}

-(void)sendLocationMsg:(CLLocation*)location{
    //发送我的位置信息
    AVIMLocationMessage *locationMsg=[AVIMLocationMessage messageWithText:@"" latitude:location.coordinate.latitude longitude:location.coordinate.longitude attributes:nil];
    [self sendMessage:locationMsg];
}

-(void)sendAudioMsg:(NSURL*)audioUrl{
    AVIMAudioMessage *audioMsg=[AVIMAudioMessage messageWithText:nil attachedFilePath:[audioUrl.absoluteString removeFilePrefix] attributes:nil];
    [self sendMessage:audioMsg];
}



-(void)sendMessage:(AVIMTypedMessage*)msg{
    [self.conversation sendMessage:msg callback:^(BOOL succeeded, NSError *error) {
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self addTypedMessage:msg];
    }];
    
    //TODO 重构用这个方法 ~! 555
//    self.conversation sendMessage:<#(AVIMMessage *)#> options:<#(AVIMMessageSendOption)#> progressBlock:<#^(NSInteger percentDone)progressBlock#> callback:<#^(BOOL succeeded, NSError *error)callback#>
}

#pragma mark - 将 AVIMTypedMessage 转为 JSQMessage 加到聊天列表中,刷新 view

-(void)addTypedMessage:(AVIMTypedMessage*)msgToAdd {
    [self addTypedMessage:msgToAdd toArrayHead:NO reloadData:YES];
}

-(void)addTypedMessage:(AVIMTypedMessage*)msgToAdd toArrayHead:(BOOL)toArrayHead reloadData:(BOOL)reloadData{
    //同步方法,阻塞,为了保证消息顺序不乱
    [msgToAdd toJsqMessageWithCallback:^(JSQMessage *msg) {
        if(toArrayHead){
            [self.msgs insertObject:msg atIndex:0];
        }else{
            [self.msgs addObject:msg];
        }
        
        if(!reloadData) return;
        
        if([NSThread isMainThread]){
            [self finishReceivingMessageAnimated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self finishReceivingMessageAnimated:YES];
            });
        }
    }];
}

#pragma mark - 下拉刷新 加载更多数据 
-(void)loadHistoryMsg:(UIRefreshControl*)refreshControl{
    JSQMessage *msg=[self.msgs firstObject];
    self.automaticallyScrollsToMostRecentMessage=NO;
    [self.conversationManager fetchMessages:self.conversation beforeTime:msg.timeStamp callback:^(NSArray *objects, NSError *error) {
        //异步解析 typed messages
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *historyMessages=[objects reverseObjectEnumerator].allObjects; //反转数组;
            [historyMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addTypedMessage:obj toArrayHead:YES reloadData:NO];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(historyMessages.count>0){
                    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                }
                [self.collectionView.mj_header endRefreshing];
                [self finishReceivingMessage];
            });
        });
    }];
    
    //SDK Bug 用上面的时间戳方法 OK
//    [self.manager fetchMessages:self.conversation before:msg.messageID callback:^(NSArray *objects, NSError *error) {
//        //异步解析 typed messages
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self addTypedMessage:obj toArrayHead:YES reloadData:NO];
//            }];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.refreshControl endRefreshing];
//                [self finishReceivingMessageAnimated:YES];
//            });
//        });
//    }];
}

#pragma mark - AudioRecorderDelegate
-(void)audioRecorder:(AudioRecorderController *)recorder didEndRecord:(NSURL *)audio{

    NSTimeInterval audioDuration= [AudioRecorderController durationForAudioFile:audio];
    
    if(audioDuration>1.2f){
        [self sendAudioMsg:audio];
    }else{
        [MBProgressHUD showMsg:@"录音太短 ~ " forSeconds:1.2];
    }
}

-(void)audioRecorder:(AudioRecorderController *)recorder updateSoundLevel:(CGFloat)level{
    [self.indocator updateWithLevel:[self.indocator normalizedPowerLevelFromDecibels:level]];
}

#pragma mark - LocationViewerDelegate
-(void)locationViewerController:(LocationViewerController *)viewer didPickLocation:(CLLocation *)location{
    [self sendLocationMsg:location];
}

#pragma mark - InputAttachmentViewDelegate
-(void)inputAttachmentView:(InputAttachmentView *)v didClickInputView:(InputType)type{
    switch (type) {
        case InputTypeEmoji:{
            InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
            [inputView toggleEmojiKeyBoard];
        }
            break;
        case InputTypeVideo:{
            [self showVideoPicker];
        }
            break;
        case InputTypeImage:{
            [self showPhotoPicker];
        }
            break;
        case InputTypeLocation:{
            [self showLocationPicker];
        }
            break;
    }
}
@end
