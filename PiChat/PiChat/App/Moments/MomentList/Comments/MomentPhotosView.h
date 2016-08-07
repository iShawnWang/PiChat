//
//  MomentPhotosView.h
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVFile;
@class MomentPhotosView;

@protocol MomentPhotosViewDelegate <NSObject>
@optional
-(void)momentPhotosView:(MomentPhotosView*)photosView didPhotoClickAtIndex:(NSUInteger)index;

@end

@interface MomentPhotosView : UIView
@property(nonatomic,weak) IBOutlet id<MomentPhotosViewDelegate> delegate;
-(CGFloat)configWithAVFilePhotos:(NSArray*)photos width:(CGFloat)width;
@end
