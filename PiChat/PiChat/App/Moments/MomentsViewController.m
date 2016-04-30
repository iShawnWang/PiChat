//
//  MomentsViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentsViewController.h"
#import "MomentCell.h"
#import "MomentHeaderView.h"
#import "ImageCache.h"
#import "User.h"
#import "Moment.h"
#import "MomentsManager.h"
#import "NSNotification+UserUpdate.h"
#import "NewMomentPhotoViewerController.h"
#import "ReplyInputView.h"
#import <Masonry.h>
#import "CommenUtil.h"
#import "ModelSizeCache.h"
@import UIKit;

NSString *const kMomentCell=@"MomentCell";
NSString *const kMomentHeaderView=@"MomentHeaderView";

@interface MomentsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,MomentCellDelegate,CommentsTableControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *moments;
@property (strong, nonatomic) MomentCell *momentProtypeCell;
@property (strong,nonatomic) ReplyInputView *replyInputView;
@property (strong,nonatomic) ModelSizeCache *modelSizeCache;
@end

@implementation MomentsViewController

#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"朋友圈";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_discover"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_discoverHL"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadImageCompleteNotification:) name:kDownloadImageCompleteNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [self.replyInputView unobserveKeyboardDisplay];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MomentCell" bundle:nil] forCellWithReuseIdentifier:kMomentCell];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Getter Setter

-(MomentCell *)momentProtypeCell{
    if(!_momentProtypeCell){
        _momentProtypeCell=[[[NSBundle mainBundle]loadNibNamed:@"MomentCell" owner:nil options:nil]firstObject];
    }
    return _momentProtypeCell;
}

-(NSMutableArray *)moments{
    if(!_moments){
        _moments=[NSMutableArray array];
    }
    return _moments;
}

-(ReplyInputView *)replyInputView{
    if(!_replyInputView){
        _replyInputView=[ReplyInputView loadViewFromXib];
        [_replyInputView observeKeyboardDisplay];
    }
    return _replyInputView;
}

-(ModelSizeCache *)modelSizeCache{
    if(!_modelSizeCache){
        _modelSizeCache=[ModelSizeCache new];
    }
    return _modelSizeCache;
}

#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MomentsManager getCurrentUserMoments:^(NSArray *objects, NSError *error) {
        self.moments =[objects mutableCopy];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    Moment *m=self.moments[indexPath.row];
    
    __weak typeof(self) weakSelf=self;
    CGSize cellSize= [self.modelSizeCache getSizeForModel:m withView:collectionView orCalc:^CGSize(NSObject *model, UIView *collectionOrTableView) {
        return [weakSelf.momentProtypeCell calcSizeWithMoment:(Moment*)model collectionView:(UICollectionView*)collectionOrTableView];
    }];
    
    return cellSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, [MomentHeaderView calcHeightWithWidth:self.view.bounds.size.width]);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(MomentCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell forceDismissCommentMeun];
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moments.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MomentCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:kMomentCell forIndexPath:indexPath];
    Moment *m=self.moments[indexPath.row];
    [cell configWithMoment:m collectionView:collectionView];
    cell.delegate=self;
    cell.commentsController.delegate=self;
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MomentHeaderView *header= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMomentHeaderView forIndexPath:indexPath];
    [header configWithUser:[User currentUser]];
    return header;
}

#pragma mark - Notification
-(void)downloadImageCompleteNotification:(NSNotification *)noti{
    [self.collectionView reloadData];
}

-(void)userUpdateNotification:(NSNotification*)noti{
    [self.collectionView reloadData];
}

#pragma mark - MomentCellDelegate //每个朋友圈的右下角菜单
-(void)momentCellDidLikeBtnClick:(MomentCell *)cell{
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *moment= self.moments[indexPath.item];
    
    [cell forceDismissCommentMeun];
    
    [moment addOrRemoveFavourUser:[User currentUser]];
    
    [moment saveInBackgroundThenFetch:^(Moment *moment, NSError *error) {
        if(error){
            return ;
        }
        self.moments[indexPath.item]=moment;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

-(void)momentCellDidCommentBtnClick:(MomentCell *)cell{
    [cell forceDismissCommentMeun];
    
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *m= self.moments[indexPath.item];
    
    __weak typeof(self) weakSelf=self;
    self.replyInputView.replyCommentCallback=^(NSString *reply,NSError *error){
        weakSelf.replyInputView.textField.text=@"";
        [weakSelf.replyInputView.textField resignFirstResponder];
        [weakSelf postNewCommentForMoment:m commentContent:reply replyTo:nil andReloadCellAtIndexPath:indexPath];
    };
    
    [self.replyInputView showInViewAtBottom:self.view];
}

-(void)momentEditMenuWillShowForCell:(MomentCell *)cell likeBtn:(UIButton *)likeBtn commentBtn:(UIButton *)commentBtn{
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *m= self.moments[indexPath.item];
    BOOL isFavoured= [m.favourUsers containsObject:[User currentUser]];//当前用户已经赞过
    NSString *likeBtnTitle=isFavoured ? @"取消" : @"赞";
    [likeBtn setTitle:likeBtnTitle forState:UIControlStateNormal];
}

#pragma mark - CommentsTableControllerDelegate //点击下面的评论列表,回复某人的评论

-(void)commentsTableController:(CommentsTableController *)controller didCommentClick:(Comment *)comment withCell:(UICollectionViewCell *)cell moment:(Moment *)moment{
    __weak typeof(self) weakSelf=self;
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    self.replyInputView.replyCommentCallback=^(NSString *reply,NSError *error){
        weakSelf.replyInputView.textField.text=@"";
        [weakSelf.replyInputView.textField resignFirstResponder];
        [weakSelf postNewCommentForMoment:moment commentContent:reply replyTo:comment.commentUser andReloadCellAtIndexPath:indexPath];
    };
    
    self.replyInputView.textField.placeholder=[NSString stringWithFormat:@"回复 %@ :",comment.commentUserName];
    [self.replyInputView showInViewAtBottom:self.view];
}


#pragma mark - Private

/**
 *  为某个朋友圈发送新评论
 */
-(void)postNewCommentForMoment:(Moment*)m commentContent:(NSString*)reply replyTo:(User*)replyTo andReloadCellAtIndexPath:(NSIndexPath*)indexPath{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Comment *newComment= [Comment commentWithCommentUser:[User currentUser] commentContent:reply replayTo:replyTo];
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [m addNewComment:newComment];
            [m saveInBackgroundThenFetch:^(Moment *moment, NSError *error) {
                self.moments[indexPath.item]=moment;
                [self.collectionView performSelectorOnMainThread:@selector(reloadItemsAtIndexPaths:) withObject:@[indexPath] waitUntilDone:NO];
            }];
        }];
    });
}
@end
