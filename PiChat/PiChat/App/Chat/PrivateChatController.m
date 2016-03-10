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

@import CoreImage;

@interface PrivateChatController ()<AVIMClientDelegate,UIActionSheetDelegate,AudioRecorderDelegate,InputAttachmentViewDelegate,LocationViewerDelegate>
@property (strong,nonatomic) NSMutableArray *msgs;
@property (strong,nonatomic) BubbleImgFactory *bubbleImgFactory;
@property (strong,nonatomic) AVIMConversation *conversation;
@property (strong,nonatomic) ConversationManager *manager;
@property (strong,nonatomic) MediaPicker *mediaPicker;
@property (strong,nonatomic) FileUpLoader *fileUpLoader;
@property (strong,nonatomic) AudioRecorderController *recorder;
@end

@implementation PrivateChatController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
        self.currentUser=[UserManager sharedUserManager].currentUser;
    }
    return self;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    //自定义下面的输入 inputToolBar
    InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
    [inputView decorateView];
    inputView.inputAttachmentView.delegate=self;
    inputView.recordBlock=^(BOOL isRecord){
        if(isRecord){
            [self.recorder startRecord];
        }else{
            [self.recorder endRecord];
        }
    };
    //
    self.recorder.delegate=self;
    //
    self.bubbleImgFactory=[BubbleImgFactory sharedBubbleImgFactory];
    //
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.manager=[ConversationManager sharedConversationManager];
    self.senderId=self.manager.currentUser.clientID;
    self.senderDisplayName=self.manager.currentUser.displayName;
    //开始对话
    [self.manager chatToUser:self.chatToUser callback:^(AVIMConversation *conversation, NSError *error) {
        self.conversation=conversation;
        [self.manager fetchConversationMessages:conversation callback:^(NSArray *objects, NSError *error) {
            //异步解析 typed messages
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self addTypedMessage:obj];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
        }];
    }];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTyperMessage:) name:kDidReceiveTypedMessageNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadingMediaNotification:) name:kUploadMediaNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(updateLocationCellNotification:) name:kLocationCellNeedUpdate object:nil];
}

-(void)didReceiveTyperMessage:(NSNotification*)notification{
    AVIMTypedMessage *typedMsg= notification.userInfo[kTypedMessage];
    [self addTypedMessage:typedMsg];
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
}

#pragma mark - JSQMessagesCollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.msgs.count;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *msg= self.msgs[indexPath.item];
    return msg;
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = [self.msgs objectAtIndex:indexPath.item];
    return [self.bubbleImgFactory bubbleImgForMessage:message];
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = [self.msgs objectAtIndex:indexPath.item];
    return [UserManager avatarForClientID:message.senderId];
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

//
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *msg= self.msgs[indexPath.item];
    id<JSQMessageMediaData> media= msg.media;
    if([media isMemberOfClass:[JSQPhotoMediaItem class]]){
        UIImage *img= ((JSQPhotoMediaItem*)media).image;
        [MediaViewerController showIn:self withImage:img];
    }else if([media isMemberOfClass:[JSQVideoMediaItem class]]){
        NSURL *videoUrl= ((JSQVideoMediaItem*)media).fileURL;
        [MediaViewerController showIn:self withVideoUrl:videoUrl];
    }else if([media isMemberOfClass:[JSQLocationMediaItem class]]){
        [MediaViewerController showIn:self withLocation:((JSQLocationMediaItem*)msg.media).location];
    }
}

#pragma mark - 

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    AVIMTypedMessage *msg=[AVIMTextMessage messageWithText:text attributes:nil];
    self.inputToolbar.contentView.textView.text=@"";
    [self sendMessage:msg];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
    [inputView toggleAttachmentKeyBoard];
}



#pragma mark - Send Messages

-(void)uploadingMediaNotification:(NSNotification*)noti{
    UploadState uploadState= [noti.userInfo[kUploadState] integerValue];
    switch (uploadState) {
        case UploadStateComplete:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AVFile *media=noti.userInfo[kUploadedFile];
            UploadedMediaType mediaType= [noti.userInfo[kUploadedMediaType] integerValue];
            AVIMTypedMessage *msg;
            switch (mediaType) {
                case UploadedMediaTypeVideo:
                    msg=[AVIMVideoMessage messageWithText:@"" file:media attributes:nil];
                    break;
                case UploadedMediaTypeAduio:
                    msg=[AVIMAudioMessage messageWithText:@"" file:media attributes:nil];
                    break;
                case UploadedMediaTypePhoto:
                    msg=[AVIMImageMessage messageWithText:@"" file:media attributes:nil];
                    break;
                case UploadedMediaTypeFile:
                    
                    break;

            }
            
            [self sendMessage:msg];
        }
        break;
        case UploadStateProgress:{
            NSNumber *progress= noti.userInfo[kUploadingProgress];
            [MBProgressHUD HUDForView:self.view].progress=[progress floatValue];
        }
        break;
        case UploadStateFailed:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *error=noti.userInfo[kUploadingError];
            NSLog(@"上传失败 : %@",error);
        }
        break;
    }
}

-(void)sendPhoto{
    [self.mediaPicker showImagePickerIn:self withCallback:^(NSURL *url, NSError *error) {
        [self.fileUpLoader uploadImage:[UIImage imageWithContentsOfFile:url.path]];
        [MBProgressHUD showProgressInView:self.view];
    }];
}

-(void)sendVideo{
    [self.mediaPicker showVideoPickerIn:self withCallback:^(NSURL *url, NSError *error) {
        [self.fileUpLoader uploadFileAtUrl:url];
        [MBProgressHUD showProgressInView:self.view];
    }];
}

-(void)sendLocation{
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
    for(int i=0;i<self.msgs.count;i++){
        JSQMessage *msg=self.msgs[i];
        if([msg.media isKindOfClass:[JSQLocationMediaItem class]]){
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

-(void)sendMessage:(AVIMTypedMessage*)msg{
    [self.conversation sendMessage:msg callback:^(BOOL succeeded, NSError *error) {
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self addTypedMessage:msg];
    }];
}

-(void)sendMessage:(AVIMTypedMessage*)msg addToLocal:(BOOL)addToLocal{
    [self.conversation sendMessage:msg callback:^(BOOL succeeded, NSError *error) {
        if(addToLocal){
            [self addTypedMessage:msg];
        }
    }];
}

-(void)addTypedMessage:(AVIMTypedMessage*)msgToAdd {
    //同步方法,阻塞,为了保证消息顺序不乱
    [msgToAdd toJsqMessageWithCallback:^(JSQMessage *msg) {
        [self.msgs addObject:msg];
        
        if([NSThread isMainThread]){
            [self.collectionView reloadData];
            [self finishReceivingMessageAnimated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self finishReceivingMessageAnimated:YES];
            });
        }
    }];
}

#pragma mark - AudioRecorderDelegate

-(void)audioRecorder:(AudioRecorderController *)recorder didEndRecord:(NSURL *)audio{
    if(audio){
        [MBProgressHUD showProgressInView:self.view];
        NSString *cachePath= [CommenUtil saveFileToCache:audio];
        [self.fileUpLoader uploadAudioAtUrl:[NSURL URLWithString:cachePath]];
    }
}

#pragma mark - LocationViewerDelegate
-(void)locationViewerController:(LocationViewerController *)viewer didPickLocation:(CLLocation *)location{
    //发送我的位置信息
    AVIMLocationMessage *locationMsg=[AVIMLocationMessage messageWithText:@"" latitude:location.coordinate.latitude longitude:location.coordinate.longitude attributes:nil];
    [self sendMessage:locationMsg];
}

#pragma mark - InputAttachmentViewDelegate
-(void)inputAttachmentView:(InputAttachmentView *)v didClickInputView:(InputType)type{
    //TODO 发送位置等信息
    switch (type) {
        case InputTypeEmoji:{
            InputContentView *inputView=(InputContentView*)self.inputToolbar.contentView;
            [inputView toggleEmojiKeyBoard];
        }
            break;
        case InputTypeVideo:{
            [self sendVideo];
        }
            break;
        case InputTypeImage:{
            [self sendPhoto];
        }
            break;
        case InputTypeLocation:{
            [self sendLocation];
        }
            break;
    }
}
@end
