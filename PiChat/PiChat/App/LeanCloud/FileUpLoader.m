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

-(void)uploadImage:(UIImage*)img {
    AVFile *photo=[AVFile fileWithData:UIImagePNGRepresentation(img)];
    [self.uploadingFile addObject:photo];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self postUploadMediaCompleteNotification:photo type:kUploadedMediaTypePhoto];
        }else{
            [self postUploadMediaFailedNotification:error];
        }
        [self.uploadingFile removeObject:photo];
    } progressBlock:^(NSInteger percentDone) {
        [self postUploadMediaProgressNotification:percentDone];
    }];
}

-(void)uploadVideoAtUrl:(NSURL*)url {
    [CommenUtil saveFileToDocument:url];
    AVFile *video=[AVFile fileWithData :[NSData dataWithContentsOfURL:url]];
    [self.uploadingFile addObject:video];
    [video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self postUploadMediaCompleteNotification:video type:kUploadedMediaTypeVideo];
        }else{
            [self postUploadMediaFailedNotification:error];
        }
        [self.uploadingFile removeObject:video];
    } progressBlock:^(NSInteger percentDone) {
        [self postUploadMediaProgressNotification:percentDone];
    }];
}

-(void)postUploadMediaCompleteNotification:(AVFile*)media type:(NSString*)mediaType{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateComplete),kUploadedFile:media,kUploadedMediaType:mediaType};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
    [self.uploadingFile removeObject:media];
}

-(void)postUploadMediaProgressNotification:(NSInteger)percentDone{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateProgress),kUploadingProgress:@(percentDone/100.0)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
}

-(void)postUploadMediaFailedNotification:(NSError *)error{
    NSDictionary *userInfo=@{kUploadState:@(UploadStateFailed),kUploadingError:error};
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaNotification object:self userInfo:userInfo];
}

@end
