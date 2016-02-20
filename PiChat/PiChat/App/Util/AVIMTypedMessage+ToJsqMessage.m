//
//  AVIMTypedMessage+ToJsqMessage.m
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMTypedMessage+ToJsqMessage.h"
#import "GlobalConstant.h"
#import <AVOSCloud.h>
#import "UserManager.h"
#import <AVOSCloudIM.h>
#import <JSQMessagesViewController/JSQMessages.h>

@implementation AVIMTypedMessage (ToJsqMessage)

/**
 *  接收到的Media Message 转为 JSQMessage 显示
 *
 *  @param callback 
 */
-(void)toJsqMessageWithCallback:(JsqMsgBlock)callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVIMMessageMediaType msgType = self.mediaType;
        JSQMessage *message;
        NSDate* timestamp=[NSDate dateWithTimeIntervalSince1970:self.sendTimestamp/1000];
        NSString *senderId=self.clientId;
        NSString *senderDisplayName=self.clientId;
        
        BOOL outgoing=[[UserManager sharedUserManager].currentUser.clientID isEqualToString:self.clientId];
        switch (msgType) {
            case kAVIMMessageMediaTypeText: {
                AVIMTextMessage *receiveTextMessage = (AVIMTextMessage *)self;
                message=[[JSQMessage alloc] initWithSenderId:self.clientId senderDisplayName:senderDisplayName date:timestamp text:receiveTextMessage.text];
                
                break;
            }
            case kAVIMMessageMediaTypeImage: {
                AVIMImageMessage *imageMessage = (AVIMImageMessage *)self;
                NSError *error;
                NSData *data=[imageMessage.file getData:&error];
                UIImage *image=[UIImage imageWithData:data];
                JSQPhotoMediaItem *photoItem=[[JSQPhotoMediaItem alloc] initWithImage:image];
                photoItem.appliesMediaViewMaskAsOutgoing=outgoing;
                message=[[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:photoItem];
                break;
            }
            case kAVIMMessageMediaTypeVideo:{
                AVIMVideoMessage* receiveVideoMessage=(AVIMVideoMessage*)self;
                NSString* format=receiveVideoMessage.format;
                NSError* error;
                NSString* path=[self fetchDataOfMessageFile:self.file fileName:[NSString stringWithFormat:@"%@.%@",self.messageId,format] error:&error];
                NSURL *videoURL = [NSURL fileURLWithPath:path];
                JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
                videoItem.appliesMediaViewMaskAsOutgoing=outgoing;
                message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:videoItem];
                break;
            }
            case kAVIMMessageMediaTypeLocation:{
                AVIMLocationMessage *locationMessage=(AVIMLocationMessage*)self;
                CLLocation *location = [[CLLocation alloc] initWithLatitude:locationMessage.location.latitude longitude:locationMessage.location.longitude];
                JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
                [locationItem setLocation:location];
                locationItem.appliesMediaViewMaskAsOutgoing=outgoing;
                message=[[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:timestamp media:locationItem];
            }
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(message);
        });
    });
}

//把接收到的 媒体文件存到 Document 目录
-(NSString*)fetchDataOfMessageFile:(AVFile*)file fileName:(NSString*)fileName error:(NSError**)error{
    NSString* path=[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:fileName];
    NSData* data=[file getData:error];
    if(*error==nil){
        [data writeToFile:path atomically:YES];
    }
    return path;
}
@end
