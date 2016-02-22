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

@import CoreImage;

@interface PrivateChatController ()<AVIMClientDelegate,UIActionSheetDelegate>
@property (strong,nonatomic) NSMutableArray *msgs;
@property (strong,nonatomic) BubbleImgFactory *bubbleImgFactory;
@property (strong,nonatomic) AVIMConversation *conversation;
@property (strong,nonatomic) ConversationManager *manager;
@property (strong,nonatomic) MediaPicker *mediaPicker;
@property (strong,nonatomic) FileUpLoader *fileUpLoader;
@end

@implementation PrivateChatController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:kUploadMediaComplete object:nil];
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
            [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addTypedMessage:obj];
            }];
            [self.collectionView reloadData];
        }];
    }];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTyperMessage:) name:kDidReceiveTypedMessageNotification object:nil];
}

-(void)didReceiveTyperMessage:(NSNotification*)notification{
    AVIMTypedMessage *typedMsg= notification.userInfo[kTypedMessage];
    [self addTypedMessage:typedMsg];
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
    }
}

#pragma mark - 

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    AVIMTypedMessage *msg=[AVIMTextMessage messageWithText:text attributes:nil];
    [self sendMessage:msg];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0://照片
            [self sendPhoto];
            break;
        case 1://位置
            [self sendLocation];
            break;
        case 2://视频
            [self sendVideo];
            break;
        default:
            break;
    }
    
}

-(void)sendPhoto{
//    [self.mediaPicker showImagePickerIn:self withCallback:^(NSURL *url, NSError *error) {
//        AVIMImageMessage *imgMsg=[AVIMImageMessage messageWithText:@"图片上传中......" file:nil attributes:nil];
//        [self addTypedMessage:imgMsg];
//        [self.fileUpLoader uploadMediaAtUrl:url ];
//    }];
}

-(void)sendVideo{
    [self.mediaPicker showVideoPickerIn:self withCallback:^(NSURL *url, NSError *error) {
        User *currentUser=[UserManager sharedUserManager].currentUser;
        JSQVideoMediaItem *videoItem=[[JSQVideoMediaItem alloc]initWithMaskAsOutgoing:YES];
        JSQMessage *msg=[JSQMessage messageWithSenderId:currentUser.clientID displayName:currentUser.displayName media:videoItem];
        [self addMediaMsgPlaceHolderJSQMessage:msg];
        
        [self.fileUpLoader uploadVideoAtUrl:url forIndexPath:[NSIndexPath indexPathForItem:self.msgs.count-1 inSection:0] ];
    }];
}



-(void)testNotification:(NSNotification*)noti{
    NSLog(@"%@",noti);
    NSIndexPath *indexPath= noti.userInfo[kUpdateIndexPath];
    AVFile *file= noti.userInfo[kUploadedFile];
    User *u= [UserManager sharedUserManager].currentUser;
    JSQVideoMediaItem *item=[[JSQVideoMediaItem alloc]initWithFileURL:[NSURL URLWithString:file.url] isReadyToPlay:YES];
    JSQMessage *msg=[JSQMessage messageWithSenderId:u.clientID displayName:u.displayName media:item];
    self.msgs[indexPath.item]=msg;
    [self.collectionView reloadData];
}


-(void)sendLocation{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    AVIMLocationMessage *locationMsg=[AVIMLocationMessage messageWithText:@"location" latitude:ferryBuildingInSF.coordinate.latitude longitude:ferryBuildingInSF.coordinate.longitude attributes:nil];
    [self sendMessage:locationMsg];
}


-(void)sendMessage:(AVIMTypedMessage*)msg{
    [self.conversation sendMessage:msg callback:^(BOOL succeeded, NSError *error) {
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

-(void)addMediaMsgPlaceHolderJSQMessage:(JSQMessage*)msg{
    [self.msgs addObject:msg];
    [self.collectionView reloadData];
}

-(void)addTypedMessage:(AVIMTypedMessage*)msgToAdd {
//    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    [msgToAdd toJsqMessageWithCallback:^(JSQMessage *msg) {
        [self.msgs addObject:msg];
        //TODO 只刷新一个 cell 用 nsoperation Queue 保证 message 按顺序添加...
//        NSIndexPath *path=[NSIndexPath indexPathForItem:self.msgs.count-1 inSection:0];
//        [self.collectionView insertItemsAtIndexPaths:@[path]];
        [self.collectionView reloadData];
        [self finishReceivingMessageAnimated:YES];
    }];
}

@end
