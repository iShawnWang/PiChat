//
//  NewMomentPhotoViewerController.h
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewMomentPhotoViewerController;

//Normal :正常的浏览图片, Delete :可以点击图片来删除它.(编辑模式)
typedef NS_ENUM(NSUInteger, PhotoViewerState) {
    PhotoViewerStateNormal,
    PhotoViewerStateDelete
};

//View: 浏览图片,Pick :显示添加或者删除图片的按钮.
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
 *  赋值 图片数组或者图片 的Url数组 其一
 */
@property (strong,nonatomic) NSMutableArray *photoUrls;
@property (strong,nonatomic) NSMutableArray *photos;
@property (assign,nonatomic) PhotoViewerType photoViewerType;
@property(nonatomic,weak) IBOutlet id<PhotoViewerControllerDelegate> photoViewerDelegate;
@end
