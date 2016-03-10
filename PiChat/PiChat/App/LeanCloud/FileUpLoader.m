//
//  FileUpLoader.m
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "FileUpLoader.h"
#import <AVOSCloud.h>
#import "CommenUtil.h"

@import UIKit;
@interface FileUpLoader ()
@property (strong,nonatomic) NSMutableArray *uploadingFile;
@end

@implementation FileUpLoader
+(instancetype)sharedFileUpLoader{
    static id _fileUpLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fileUpLoader=[FileUpLoader new];
    });
    return _fileUpLoader;
}

-(NSMutableArray *)uploadingFile{
    if(!_uploadingFile){
        _uploadingFile=[NSMutableArray array];
    }
    return _uploadingFile;
}

#pragma mark - Upload AVFile
-(void)uploadImage:(UIImage*)img {
    AVFile *photo=[AVFile fileWithData:UIImagePNGRepresentation(img)];
    [self uploadAVFileAtUrl:photo type:UploadedMediaTypePhoto];
}

-(void)uploadVideoAtUrl:(NSURL *)url{
     [self uploadTypedFileAtUrl:url type:UploadedMediaTypeVideo];
}

-(void)uploadFileAtUrl:(NSURL *)url{
     [self uploadTypedFileAtUrl:url type:UploadedMediaTypeFile];
}

-(void)uploadAudioAtUrl:(NSURL*)url{
    [self uploadTypedFileAtUrl:url type:UploadedMediaTypeAduio];
}

-(void)uploadTypedFileAtUrl:(NSURL *)url type:(UploadedMediaType)type{
    NSString *cachePath= [CommenUtil saveFileToCache:url];
    AVFile *file=[AVFile fileWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cachePath]]];
    [self uploadAVFileAtUrl:file type:type];
}

/**
 *  upload Video Audio all other file
 *
 *  @param url
 */
-(void)uploadAVFileAtUrl:(AVFile*)file type:(UploadedMediaType)type{
    [self.uploadingFile addObject:file];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self postUploadMediaCompleteNotification:file type:type];
        }else{
            [self postUploadMediaFailedNotification:error];
        }
        [self.uploadingFile removeObject:file];
    } progressBlock:^(NSInteger percentDone) {
        [self postUploadMediaProgressNotification:percentDone];
    }];
}

/**
 *  Notify Upload Complete
 *
 *  @param media
 *  @param mediaType
 */
-(void)postUploadMediaCompleteNotification:(AVFile*)media type:(UploadedMediaType)mediaType{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateComplete),kUploadedFile:media,kUploadedMediaType:@(mediaType)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
    [self.uploadingFile removeObject:media];
}

/**
 *  Notify upload Progress
 *
 *  @param percentDone integer progress
 */
-(void)postUploadMediaProgressNotification:(NSInteger)percentDone{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateProgress),kUploadingProgress:@(percentDone/100.0)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
}

/**
 *  Notify upload failed
 *
 *  @param error
 */
-(void)postUploadMediaFailedNotification:(NSError *)error{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateFailed),kUploadingError:error};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
}

@end
