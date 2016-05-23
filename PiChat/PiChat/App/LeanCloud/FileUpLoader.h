//
//  FileUpLoader.h
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "NSNotification+UploadMedia.h"
@class AVFile;

/**
 *  上传媒体文件,用 Leancloud 的文件存储.上传时和完成时会发送通知.
 */
@interface FileUpLoader : NSObject
+(instancetype)sharedFileUpLoader;
-(void)uploadImage:(UIImage*)img;

-(void)uploadVideoAtUrl:(NSURL *)url;

-(void)uploadFileAtUrl:(NSURL *)url;

-(void)uploadAudioAtUrl:(NSURL*)url;

-(void)uploadTypedFileAtUrl:(NSURL *)url type:(UploadedMediaType)type;

-(void)uploadAVFileAtUrl:(AVFile*)file type:(UploadedMediaType)type;

@end
