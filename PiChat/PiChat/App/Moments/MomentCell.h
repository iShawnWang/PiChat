//
//  MomentCell.h
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsTableController.h"
@class Moment;
@class NewMomentPhotoViewerController;
@class MomentCell;

@protocol MomentCellDelegate <NSObject>
-(void)momentEditMenuWillShowForCell:(MomentCell*)cell likeBtn:(UIButton*)likeBtn commentBtn:(UIButton*)commentBtn;
-(void)momentCellDidLikeBtnClick:(MomentCell*)cell;
-(void)momentCellDidCommentBtnClick:(MomentCell*)cell;

-(void)momentCell:(MomentCell *)cell didPhotoViewController:(NewMomentPhotoViewerController*)controller photoCellClick:(UICollectionViewCell*)photoCell;

@end

@interface MomentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifyTimeLabel;
@property (strong,nonatomic) CommentsTableController *commentsController;
@property(nonatomic,weak) IBOutlet id<MomentCellDelegate> delegate;
//
@property (strong,nonatomic) NewMomentPhotoViewerController *photoViewerController;
-(void)configWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView;
-(CGSize)calcSizeWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView;
//
-(void)forceDismissCommentMeun;
@end
