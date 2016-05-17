//
//  MomentCell.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentCell.h"
#import "Moment.h"
#import "ImageCache.h"
#import "User.h"
#import "UserManager.h"
#import <DateTools.h>
#import "NewMomentPhotoViewerController.h"
#import "CommenUtil.h"
#import <Masonry.h>
#import "StoryBoardHelper.h"
#import "TTTAttributedLabel.h"
#import "AVFile+ImageThumbnailUrl.h"


@interface MomentCell ()<UICollectionViewDelegateFlowLayout,PhotoViewerControllerDelegate>
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

-(void)awakeFromNib{
    
    self.isCommentMenuShown=NO;
    self.isCommentMenuAnimating=NO;
    self.commentMenuWidthConstraint.constant=0; //隐藏右下角评论菜单
    
    [self.commentsTablePlaceHolderView addSubview:self.commentsController.view];
    [self.commentsController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commentsTablePlaceHolderView);
    }];
    
    [self.photoViewerPlaceholderView addSubview:self.photoViewerController.view];
    [self.photoViewerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoViewerPlaceholderView);
    }];
    
    self.photoViewerHeightConstraint.constant=0;
    self.commentsTableHeightConstraint.constant=0;
    
}

-(void)configWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView{
    
    self.photoViewerController.photoUrls=nil;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, collectionView.bounds.size.width, self.frame.size.height);
    
    [self updateConstraintsIfNeeded];
    
    User *u=[[UserManager sharedUserManager]findUserFromCacheElseNetworkByObjectID:moment.postUser.clientID];
    
    self.displayNameLabel.text=u.displayName;
    self.avatarImageView.image = [[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];;
    self.contentLabel.text=moment.texts;
    self.lastModifyTimeLabel.text=[NSDate timeAgoSinceDate:moment.createdAt];
    
    //Comments
    self.commentsController.moment=moment;
    self.commentsController.superCell=self;
    
    //Images Viewer
    if(moment.images && moment.images.count>0){
        NSMutableArray *photoUrls=[NSMutableArray array];
        [moment.images enumerateObjectsUsingBlock:^(AVFile * imageFile, NSUInteger idx, BOOL * _Nonnull stop) {
            [photoUrls addObject:[NSURL URLWithString:[imageFile defaultThumbnailUrl]]];
        }];
        
        self.photoViewerController.photoUrls=photoUrls;
        self.photoViewerController.photoViewerDelegate=self;
    }
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    //图片 Collectionview size
    CGSize photoViewerSize= self.photoViewerController.collectionView.collectionViewLayout.collectionViewContentSize;
    self.photoViewerHeightConstraint.constant=photoViewerSize.height;
    
//    NSLog(@"%f",photoViewerSize.height);
    //喜欢和评论的 Tableview
    CGSize commentsTableSize= self.commentsController.tableView.contentSize;
    self.commentsTableHeightConstraint.constant=commentsTableSize.height;

    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


// 迷之动态计算 cell 高度 已经解决 666 ~
-(CGSize)calcSizeWithMoment:(Moment*)moment collectionView:(UICollectionView*)collectionView{
    
    [self configWithMoment:moment collectionView:collectionView];
    
    NSInteger collectionViewWidth=CGRectGetWidth(collectionView.bounds);
    //Label 自适应
    CGFloat labelMaxWidth=collectionViewWidth - self.avatarImageView.frame.size.width-8-8;
    self.contentLabel.preferredMaxLayoutWidth=labelMaxWidth;
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    CGSize cellSize= [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    CGFloat commentsTableHeight=self.commentsTableHeightConstraint.constant;
//    CGFloat photoViewerHeight=self.photoViewerHeightConstraint.constant;
    
    CGSize finalSize= CGSizeMake(collectionViewWidth, cellSize.height);
    
    return finalSize;
}


#pragma mark - Getter Setter

-(NewMomentPhotoViewerController *)photoViewerController{
    if(!_photoViewerController){
        _photoViewerController=(NewMomentPhotoViewerController*)[StoryBoardHelper inititialVC:kNewMomentPhotoViewerControllerID fromSB:kMomentsSB];
    }
    return _photoViewerController;
}

-(CommentsTableController *)commentsController{
    if(!_commentsController){
        _commentsController=(CommentsTableController*)[StoryBoardHelper inititialVC:kCommentsTableController fromSB:kMomentsSB];
    }
    return _commentsController;
}

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
    if(!force){
        if(self.isCommentMenuAnimating) return;
    }
    if(show){
        [self.delegate momentEditMenuWillShowForCell:self likeBtn:self.likeBtn commentBtn:self.commentBtn];
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

#pragma mark - Navigation
/**
 *  获取 Container View 里的 ViewController
 *
 *  @param segue
 *  @param sender
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kNewMomentPhotoViewerControllerID]){
        self.photoViewerController=segue.destinationViewController;
        CALayer *layer= self.photoViewerController.view.layer;
        layer.borderColor=[UIColor lightGrayDividerColor].CGColor;
        layer.borderWidth=1;
    }
}

#pragma mark - PhotoViewerControllerDelegate
-(void)photoViewerController:(NewMomentPhotoViewerController *)controller didPhotoCellClick:(UICollectionViewCell *)cell{
    [self.delegate momentCell:self didPhotoViewController:controller photoCellClick:cell];
}


@end
