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
#import "AVFile+ImageThumbnailUrl.h"

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
    NSString *fileName= [url lastPathComponent]; //xxx.jpg
    NSString *mimeType= fileName.pathExtension; //jpg
    AVFile *file;
    if(fileName){
        file=[AVFile fileWithName:fileName data:[NSData dataWithContentsOfURL:url]];
    }else{
        file=[AVFile fileWithData:[NSData dataWithContentsOfURL:url]];
    }
    file.pi_mimeType=mimeType;
    
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
        [self.uploadingFile removeObject:file];

        executeAsyncInMainQueueIfNeed(^{ //主线程发送通知..
            if(succeeded){
                [NSNotification postUploadMediaCompleteNotification:self media:file type:type];
            }else{
                [NSNotification postUploadMediaFailedNotification:self error:error];
            }
        });
        
    } progressBlock:^(NSInteger percentDone) {
        executeAsyncInMainQueueIfNeed(^{
            [NSNotification postUploadMediaProgressNotification:self percentDone:percentDone];
        });
    }];
}

@end

