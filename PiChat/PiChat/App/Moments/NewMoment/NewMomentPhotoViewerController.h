//
//  NewMomentPhotoViewerController.h
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewMomentPhotoViewerController;
@class AVFile;

//Normal :正常的浏览图片, Delete :可以点击图片来删除它.(编辑模式)
typedef NS_ENUM(NSUInteger, PhotoViewerState) {
    PhotoViewerStateNormal,
    PhotoViewerStateDelete
};

//View: 浏览AVFile 图片,Pick :显示添加或者删除图片的按钮.
typedef NS_ENUM(NSUInteger, PhotoViewerType) {
    PhotoViewerTypeView,
    PhotoViewerTypePick
};

FOUNDATION_EXPORT NSString *const kNewMomentPhotoViewerControllerID;

@protocol PhotoViewerControllerDelegate <NSObject>

-(void)photoViewerController:(NewMomentPhotoViewerController*)controller didPhotoCellClick:(UICollectionViewCell*)cell;

@end

/**
 *  可以用它展示多张图片,类似朋友圈9张图片.也可以设置 PhotoViewerTypePick , 显示编辑按钮,来增加删除图片.
 */
@interface NewMomentPhotoViewerController : UICollectionViewController
@property (assign,nonatomic) PhotoViewerState currentState;

/**
 *  本地图片的 url 数组,
 *  和下面的 NSMutableArray<AVFile*> *avFilePhotos 赋值一个即可
 */
@property (strong,nonatomic) NSMutableArray<NSURL*> *photoUrls;

/**
 *  AVFile 的数组,内部会根据 AVFile 的 url 下载图片,然后显示.
 *  和上面的 NSMutableArray<NSURL*> *photoUrls 赋值一个即可
 */
@property (strong,nonatomic) NSArray<AVFile*> *avFilePhotos;

@property (assign,nonatomic) PhotoViewerType photoViewerType;
@property(nonatomic,weak) IBOutlet id<PhotoViewerControllerDelegate> photoViewerDelegate;
@end
