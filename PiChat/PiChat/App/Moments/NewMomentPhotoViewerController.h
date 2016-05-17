//
//  NewMomentPhotoViewerController.h
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewMomentPhotoViewerController;

typedef NS_ENUM(NSUInteger, PhotoViewerState) {
    PhotoViewerStateNormal,
    PhotoViewerStateDelete
};

typedef NS_ENUM(NSUInteger, PhotoViewerType) {
    PhotoViewerTypeView,
    PhotoViewerTypePick
};

FOUNDATION_EXPORT NSString *const kNewMomentPhotoViewerControllerID;


@protocol PhotoViewerControllerDelegate <NSObject>

-(void)photoViewerController:(NewMomentPhotoViewerController*)controller didPhotoCellClick:(UICollectionViewCell*)cell;

@end

@interface NewMomentPhotoViewerController : UICollectionViewController
@property (assign,nonatomic) PhotoViewerState currentState;
@property (strong,nonatomic) NSMutableArray *photoUrls; //赋值 图片数组或者图片 的Url数组 其一
@property (strong,nonatomic) NSMutableArray *photos;
@property (assign,nonatomic) PhotoViewerType photoViewerType;
@property(nonatomic,weak) IBOutlet id<PhotoViewerControllerDelegate> photoViewerDelegate;
@end
