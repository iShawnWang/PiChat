//
//  AVIMTypedMessage+ToJsqMessage.m
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMTypedMessage+ToJsqMessage.h"
#import <JSQMessages.h>
#import <AVOSCloud.h>
#import "UserManager.h"
#import <AVOSCloudIM.h>
#import "JSQAudioMediaItem.h"
#import "JSQMessage+MessageID.h"
#import "CommenUtil.h"
#import "JSQVideoMediaItem+Thumbnail.h"
#import "NSNotification+LocationCellUpdate.h"
#import "JSQPhotoMediaItem+ThumbnailImageUrl.h"


@implementation AVIMTypedMessage (ToJsqMessage)

/**
 *  接收到的Media Message 转为 JSQMessage 显示
 *  同步方法,保证消息的顺序不乱
 *
 *  @param callback 
 */
-(void)toJsqMessageWithCallback:(JsqMsgBlock)callback{
    
    AVIMMessageMediaType msgType = self.mediaType;
    __block JSQMessage *message;
    NSDate* timestamp=[NSDate dateWithTimeIntervalSince1970:self.sendTimestamp/1000];
    NSString *senderId=self.clientId;
    NSString *senderDisplayName=self.clientId;
    
    
    BOOL outgoing=[[UserManager sharedUserManager].currentUser.clientID isEqualToString:self.clientId];
    switch (msgType) {
        case kAVIMMessageMediaTypeText: {
            AVIMTextMessage *receiveTextMessage = (AVIMTextMessage *)self;
            message=[[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp text:receiveTextMessage.text];
            
            break;
        }
        case kAVIMMessageMediaTypeImage: {
            AVIMImageMessage *imageMessage = (AVIMImageMessage *)self;
            
            JSQPhotoMediaItem *photoItem=[[JSQPhotoMediaItem alloc]init];
            
            //缩略图图片显示大小
            NSValue *mediaViewDisplaySizeValue= [photoItem valueForKey:@"mediaViewDisplaySize"];
            CGSize mediaViewDisplaySize=[mediaViewDisplaySizeValue CGSizeValue];
//            if(CGSizeEqualToSize(mediaViewDisplaySize, CGSizeZero)){
//                //获取不到缩略图图片显示大小就缩放为屏幕 1/3 宽度
//                CGFloat screenWidth_3= CGRectGetWidth([UIScreen mainScreen].bounds)/3.0;
//                mediaViewDisplaySize=CGSizeMake(screenWidth_3, screenWidth_3/1.4);
//            }
            
            if(!photoItem.thumbnailImageUrl){
                //类似: http://ac-RD1BgVPw.clouddn.com/epDUHFCO2uxQPAYm3CYvCnD?imageView/1/w/315/h/225/q/100
                photoItem.thumbnailImageUrl =[imageMessage.file getThumbnailURLWithScaleToFit:NO width:mediaViewDisplaySize.width height:mediaViewDisplaySize.height];
            }
            if(!photoItem.originalImageUrl){
                //类似: http://ac-RD1BgVPw.clouddn.com/epDUHFCO2uxQPAYm3CYvCnD
                photoItem.originalImageUrl=imageMessage.file.url;
            }
            
            photoItem.appliesMediaViewMaskAsOutgoing=outgoing;
            message=[[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:photoItem];
            break;
        }
        case kAVIMMessageMediaTypeVideo:{
            AVIMVideoMessage* videoMessage=(AVIMVideoMessage*)self;
            
            NSString *videoPath=videoMessage.file.localPath;
            
            if(!videoPath){
                NSError *error;
                
                videoPath=[[CommenUtil cacheDirectoryStr] stringByAppendingPathComponent:videoMessage.messageId];
                if(![[NSFileManager defaultManager]fileExistsAtPath:videoPath]){
                    NSData *videoData= [videoMessage.file getData:&error];
                    //这个多次调用会缓存,但只能得到 Data ,只好我们自己存到 Cache 目录.
                    [videoData writeToFile:videoPath atomically:YES];
                }
            }
            
            NSURL *videoURL= [NSURL fileURLWithPath:videoPath];
            
            JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
            videoItem.appliesMediaViewMaskAsOutgoing=outgoing;
            message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:videoItem];
            break;
        }
        case kAVIMMessageMediaTypeLocation:{
            AVIMLocationMessage *locationMessage=(AVIMLocationMessage*)self;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:locationMessage.location.latitude longitude:locationMessage.location.longitude];
            JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
            locationItem.appliesMediaViewMaskAsOutgoing=outgoing;
            message=[[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:locationItem];
            [locationItem setLocation:location withCompletionHandler:^{
                [NSNotification postLocationCellNeedUpdateNotification:message];
            }];
            break;
        }
        case kAVIMMessageMediaTypeAudio:{
            AVIMAudioMessage *audioMsg=(AVIMAudioMessage*)self;
            NSError *error;
            NSData *audioData= [audioMsg.file getData:&error];
            JSQAudioMediaItem *audioItem=[[JSQAudioMediaItem alloc]initWithData:audioData];
            message=[JSQMessage messageWithSenderId:senderId displayName:senderDisplayName media:audioItem];

        }
            break;
    }
    
    message.timeStamp=self.sendTimestamp;
    message.messageID=self.messageId;
    callback(message);
}
@end
