//
//  MomentPhotosView.m
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentPhotosView.h"
#import "AVFile+ImageThumbnailUrl.h"
#import "ImageCacheManager.h"
#import "UIColor+Addition.h"
#import "GlobalConstant.h"
#import <BlocksKit+UIKit.h>

@interface MomentPhotosView ()
@property (strong,nonatomic) NSArray *photos;
@end

@implementation MomentPhotosView
-(CGFloat)configWithAVFilePhotos:(NSArray*)photos width:(CGFloat)width{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.photos=photos;
    
    CGFloat viewHeight=0;
    CGFloat photoSize=width/3.0;
    if(photos==nil || photos.count==0){
        return viewHeight;
    }
    
    for (NSUInteger i=0; i<self.photos.count; i++) {
        AVFile *photoFile=self.photos[i];
        UIImageView *photoImageView=[UIImageView new]; //每次滑动 TabelView都要创建很多 UIImageView  ~
        photoImageView.userInteractionEnabled=YES;
        
        //这里引用循环 ~
        @weakify(self)
        [photoImageView bk_whenTapped:^{
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(momentPhotosView:didPhotoClickAtIndex:)]){
                [self.delegate momentPhotosView:self didPhotoClickAtIndex:i];
            }
        }];
        photoImageView.layer.borderWidth=1;
        photoImageView.layer.borderColor = [UIColor lightGrayDividerColor].CGColor;
        
        CGPoint origin= CGPointMake((i%3) *photoSize, (i/3) *photoSize);
        CGRect frame= CGRectMake(origin.x, origin.y, photoSize, photoSize);
        photoImageView.frame=frame;
        [self addSubview:photoImageView];
        
        [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:photoFile withFormatName:kMomentThumbnailFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            
            //防止图片错位
            NSArray *cuoweiPhotos=photos;
            
            if(cuoweiPhotos==self.photos){
                photoImageView.image=image;
            }
            
        }];
    }
    
    NSInteger numberOfLine= photos.count/3 + (photos.count %3 >0 ? 1 : 0);
    viewHeight=numberOfLine * photoSize;
    return viewHeight;
    
}

@end
