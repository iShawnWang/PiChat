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
    AVFile *f=[AVFile fileWithData:UIImagePNGRepresentation(img)];
    [self.uploadingFile addObject:f];
    [f saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //TODO Notification download
    } progressBlock:^(NSInteger percentDone) {
        //TODO Notification progress
    }];
}

-(void)uploadVideoAtUrl:(NSURL*)url forIndexPath:(NSIndexPath*)indexPath{
    [CommenUtil saveFileToDocument:url];
    AVFile *video=[AVFile fileWithData :[NSData dataWithContentsOfURL:url]];
    [self.uploadingFile addObject:video];
    [video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSDictionary *userInfo=@{kUploadedFile:video,kUpdateIndexPath:indexPath};
        [[NSNotificationCenter defaultCenter]postNotificationName:kUploadMediaComplete object:video userInfo:userInfo];
        [self.uploadingFile removeObject:video];
    } progressBlock:^(NSInteger percentDone) {
        
    }];
}
@end
