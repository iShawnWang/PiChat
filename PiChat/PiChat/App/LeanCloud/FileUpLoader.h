//
//  FileUpLoader.h
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"

@class AVFile;

@interface FileUpLoader : NSObject
+(instancetype)sharedFileUpLoader;
-(void)uploadImage:(UIImage*)img;

-(void)uploadVideoAtUrl:(NSURL *)url;

-(void)uploadFileAtUrl:(NSURL *)url;

-(void)uploadAudioAtUrl:(NSURL*)url;

-(void)uploadTypedFileAtUrl:(NSURL *)url type:(UploadedMediaType)type;

-(void)uploadAVFileAtUrl:(AVFile*)file type:(UploadedMediaType)type;
@end
