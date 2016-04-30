//
//  NewMomentPhotoViewerController.h
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PhotoViewerState) {
    PhotoViewerStateNormal,
    PhotoViewerStateDelete
};

typedef NS_ENUM(NSUInteger, PhotoViewerType) {
    PhotoViewerTypeView,
    PhotoViewerTypePick
};

static NSString *const kNewMomentPhotoViewerControllerID=@"NewMomentPhotoViewerController";

@interface NewMomentPhotoViewerController : UICollectionViewController
@property (assign,nonatomic) PhotoViewerState currentState;
@property (strong,nonatomic) NSMutableArray *photoUrls; //赋值 图片数组或者图片 的Url数组 其一
@property (strong,nonatomic) NSMutableArray *photos;
@property (assign,nonatomic) PhotoViewerType photoViewerType;
@end
