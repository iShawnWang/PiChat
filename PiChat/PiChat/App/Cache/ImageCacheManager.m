//
//  ImageCacheManager.m
//  PiChat
//
//  Created by pi on 16/7/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ImageCacheManager.h"
#import "GlobalConstant.h"
#import <SDWebImageManager.h>
#import "Moment.h"
#import "FICImageTable.h"
#import "NSNotification+DownloadImage.h"

#pragma mark -
NSInteger const kMaxImageCount=666;
FICImageFormatProtectionMode const kProtectionModeNone=FICImageFormatProtectionModeNone;
FICImageFormatDevices const kDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
FICImageFormatStyle const kStyle= FICImageFormatStyle32BitBGRA;

@interface ImageCacheManager ()<FICImageCacheDelegate>
@property (strong,nonatomic) FICImageCache *imageCache;
@property (strong,nonatomic) SDWebImageManager *downloadManager;
@property (strong,nonatomic) UIImage *blankImage;
@end

@implementation ImageCacheManager

+(instancetype)sharedImageCacheManager{
    static id _imageCacheManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCacheManager=[ImageCacheManager new];
    });
    return _imageCacheManager;
}

-(SDWebImageManager *)downloadManager{
    if(!_downloadManager){
        _downloadManager=[SDWebImageManager sharedManager];
    }
    return _downloadManager;
}

-(UIImage *)blankImage{
    if(!_blankImage){
        _blankImage=[UIImage new];
    }
    return _blankImage;
}

#pragma mark - Public

-(void)setupImageCache{
    
    NSMutableArray *formats=[NSMutableArray arrayWithCapacity:10];
    
    FICImageFormat *userAvatarOriginalFormat=[self formatWithName:kUserAvatarOriginalFormatName family:kUserAvatarFamily size:kUserAvatarOriginalImageSize];
    [formats addObject:userAvatarOriginalFormat];
    
    FICImageFormat *userAvatarBlurFormat=[self formatWithName:kUserAvatarBlurFormatName family:kUserAvatarFamily size:kUserAvatarBlurImageSize];
    [formats addObject:userAvatarBlurFormat];
    
    FICImageFormat *userAvatarRoundFormat=[self formatWithName:kUserAvatarRoundFormatName family:kUserAvatarFamily size:kUserAvatarRoundImageSize];
    [formats addObject: userAvatarRoundFormat];
    //
    FICImageFormat *momentThumbnailFormat=[self formatWithName:kMomentThumbnailFormatName family:kMomentFamily size:kMomentThumbnailImageSize];
    [formats addObject: momentThumbnailFormat];
    
    //
    CGSize jsqPhotoItemSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        jsqPhotoItemSize=kJSQMessagePhotoItemImageSizePad;
    }else{
        jsqPhotoItemSize=kJSQMessagePhotoItemImageSizePhone;
    }
    
    FICImageFormat *jsqPhotoItemFormat=[self formatWithName:kJSQMessagePhotoItemFormatName family:kJSQMessageFamily size:jsqPhotoItemSize];
    [formats addObject: jsqPhotoItemFormat];
    
    //
    self.imageCache=[FICImageCache sharedImageCache];
    self.imageCache.delegate=self;
    [self.imageCache setFormats:formats];

}

- (BOOL)retrieveImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock {
    //缓存中没有图片,就让 FastImageCache 的代理去下载,然后发送下载完成的通知
    if(![self.imageCache imageExistsForEntity:entity withFormatName:formatName]){
        //立即回调一个空图片,
        completionBlock(entity,formatName,[self.blankImage copy]);
        //
        [self.imageCache retrieveImageForEntity:entity withFormatName:formatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            [NSNotification postDownloadImageNotification:self image:image url:[entity FIC_sourceImageURLWithFormatName:formatName]];
        }];
        return NO;
    }else{
        //缓存中有图片,同步返回图片.
        return [self.imageCache asynchronouslyRetrieveImageForEntity:entity withFormatName:formatName completionBlock:completionBlock];
    }
}


#pragma mark - Private

-(FICImageFormat *)formatWithName:(NSString*)name family:(NSString*)family size:(CGSize)size{
    return [FICImageFormat formatWithName:name family:family imageSize:size style:kStyle maximumCount:kMaxImageCount devices:kDevices protectionMode:kProtectionModeNone];
}

#pragma mark - FICImageCacheDelegate
-(void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock{
//    FICImageFormat *format= [self.imageCache formatWithName:formatName];
//    NSString *family= format.family;
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[entity FIC_sourceImageURLWithFormatName:formatName] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(!finished){
            return ;
        }
        if(error || !image){
            DDLogError(@"SDW下载图片 : %@",error);
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    }];
}

-(void)imageCache:(FICImageCache *)imageCache cancelImageLoadingForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName{
    // SDW 下载模块没有取消的功能... 
}

-(void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage{
    DDLogError(@"FastImageCache Error:%@",errorMessage);
}
@end
