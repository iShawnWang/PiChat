//
//  MomentCell.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentCell.h"
#import "Moment.h"
#import "User.h"
#import "UserManager.h"
#import <DateTools.h>
#import "NewMomentPhotoViewerController.h"
#import "CommenUtil.h"
#import <Masonry.h>
#import "StoryBoardHelper.h"
#import "TTTAttributedLabel.h"
#import "AVFile+ImageThumbnailUrl.h"
#import "ImageCacheManager.h"
#import "MediaViewerController.h"
#import "MomentPhotosView.h"

const NSInteger NameLabelTopPadding =8;
const NSInteger NameLabelHeight=22;
const NSInteger NameLabelRgithPadding =8;

const NSInteger AvatarImageViewSize =66;
const NSInteger AvatarImageViewLeftPadding =8;
const NSInteger AvatarImageViewRightPadding =8;

const NSInteger ContentLabelTopPadding =12;

const NSInteger PhotoViewerPlaceholderViewTopPadding =8;

const NSInteger MenuViewTopPadding =8;
const NSInteger MenuViewHeight =30;

const NSInteger SeparateLineHeight =1;
const NSInteger SeparateLineTopPadding =8;
const NSInteger SeparateLineBottomPadding =8;

@interface MomentCell ()<UICollectionViewDelegateFlowLayout,MomentPhotosViewDelegate>
@property (strong,nonatomic) Moment *moment;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *photoViewerPlaceholderView;
@property (weak, nonatomic) IBOutlet UIView *commentsTablePlaceHolderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentMenuWidthConstraint;
@property (assign,nonatomic) BOOL isCommentMenuShown;
@property (assign,nonatomic) BOOL isCommentMenuAnimating;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsTableHeightConstraint;
@end

@implementation MomentCell
-(void)prepareForReuse{
    self.photoViewerHeightConstraint.constant=0;
    self.commentsTableHeightConstraint.constant=0;
}

-(CommentsView *)commentsView{
    if(!_commentsView){
        _commentsView=[CommentsView new];
    }
    return _commentsView;
}

-(MomentPhotosView *)photosView{
    if(!_photosView){
        _photosView=[MomentPhotosView new];
        _photosView.delegate=self;
    }
    return _photosView;
}

-(void)awakeFromNib{
    
    self.isCommentMenuShown=NO;
    self.isCommentMenuAnimating=NO;
    self.commentMenuWidthConstraint.constant=0; //隐藏右下角评论菜单
    
    [self.commentsTablePlaceHolderView addSubview:self.commentsView];
    [self.commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commentsTablePlaceHolderView);
    }];
    
    [self.photoViewerPlaceholderView addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoViewerPlaceholderView);
    }];
    
    //神奇的解决办法 ~ 666
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.photoViewerHeightConstraint.constant=0;
    self.commentsTableHeightConstraint.constant=0;
}

-(void)configWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView{
    self.moment=moment;
    
    self.bounds=CGRectMake(0, 0, CGRectGetWidth(collectionView.bounds), CGRectGetHeight(self.bounds));
    
    User *u=[[UserManager sharedUserManager]findUserFromCacheElseNetworkByObjectID:moment.postUser.clientID];
    
    self.displayNameLabel.text=u.displayName;
    if(u.avatarPath){
        [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            if(entity==u){
                self.avatarImageView.image=image;
            }
        }];
    }
    
    self.contentLabel.text=moment.texts;
    self.lastModifyTimeLabel.text=[NSDate timeAgoSinceDate:moment.createdAt];
    
    NSInteger commentsImageViewerControllerWidth=CGRectGetWidth(collectionView.bounds)-AvatarImageViewLeftPadding-AvatarImageViewSize-AvatarImageViewRightPadding-NameLabelRgithPadding;

    //Comments
    CGFloat commentsViewHeight= [self.commentsView configWithComments:moment width:commentsImageViewerControllerWidth];
    
    //Images Viewer
    CGFloat photosViewHeight=[self.photosView configWithAVFilePhotos:moment.images width:commentsImageViewerControllerWidth];


    //图片 Collectionview size
    self.photoViewerHeightConstraint.constant=photosViewHeight;
    
    //喜欢和评论的 Tableview
    self.commentsTableHeightConstraint.constant=commentsViewHeight;
    
}

-(CGSize)calcSizeWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView{
    
    [self configWithMoment:moment collectionView:collectionView];
    
    NSInteger collectionViewWidth=CGRectGetWidth(collectionView.bounds);
    CGFloat labelMaxWidth=collectionViewWidth - AvatarImageViewLeftPadding -AvatarImageViewSize -AvatarImageViewRightPadding -NameLabelRgithPadding;
    CGRect contentTextRect= [moment.texts boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil];
    
    CGFloat cellHeight=NameLabelTopPadding+NameLabelHeight+ContentLabelTopPadding+ CGRectGetHeight(contentTextRect) +PhotoViewerPlaceholderViewTopPadding+self.photoViewerHeightConstraint.constant +MenuViewTopPadding+MenuViewHeight+ self.commentsTableHeightConstraint.constant+SeparateLineTopPadding+SeparateLineHeight+SeparateLineBottomPadding;

    CGSize finalSize=CGSizeMake(collectionViewWidth, cellHeight);
    return finalSize;
    
#if 0
    //Label 自适应
    CGFloat labelMaxWidth=collectionViewWidth - self.avatarImageView.frame.size.width-8-8-8;
    self.contentLabel.preferredMaxLayoutWidth=labelMaxWidth;
    self.displayNameLabel.preferredMaxLayoutWidth=labelMaxWidth;
    
    CGSize cellSize= [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGSize finalSize= CGSizeMake(collectionViewWidth, cellSize.height+1);
#endif
    
}

#pragma mark - Getter Setter

#pragma mark - Comment Menu
- (IBAction)likeBtnClick:(id)sender {
    [self.delegate momentCellDidLikeBtnClick:self];
}

- (IBAction)commentBtnClick:(id)sender {
    [self.delegate momentCellDidCommentBtnClick:self];
}

- (IBAction)toggleCommentMenu:(id)sender {
    if(self.isCommentMenuAnimating) return;
    
    self.isCommentMenuShown=!self.isCommentMenuShown;
    [self showCommentMenu:self.isCommentMenuShown force:NO];
}

-(void)forceDismissCommentMeun{
    [self showCommentMenu:NO force:YES];
}

/**
 *  默认情况,如果正在进行动画,直接 return
 *
 *  @param show
 *  @param force 不管是否正在进行动画,dismiss Menu
 */
-(void)showCommentMenu:(BOOL)show force:(BOOL) force{
    if(!force && self.isCommentMenuAnimating){
        return;
    }
    if(show){
        if([self.delegate respondsToSelector:@selector(momentEditMenuWillShowForCell:likeBtn:commentBtn:)]){
        [self.delegate momentEditMenuWillShowForCell:self likeBtn:self.likeBtn commentBtn:self.commentBtn];
        }
    }
    [UIView animateWithDuration:0.225 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.isCommentMenuAnimating=YES;
        self.commentMenuWidthConstraint.constant=show ? 84 : 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isCommentMenuAnimating=NO;
        self.isCommentMenuShown=show;
    }];
}




@end
