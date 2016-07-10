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
#import "User.h"
#import "Moment.h"
#import "MomentsManager.h"
#import "NSNotification+UserUpdate.h"
#import "NewMomentPhotoViewerController.h"
#import "ReplyInputView.h"
#import <Masonry.h>
#import "CommenUtil.h"
#import "UICollectionView+PendingReloadData.h"
#import "MediaViewerController.h"
#import "DBManager.h"
#import "NSNotification+DownloadImage.h"
@import UIKit;

NSString *const kMomentCell=@"MomentCell";
NSString *const kMomentHeaderView=@"MomentHeaderView";

@interface MomentsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,MomentCellDelegate,CommentsTableControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) MomentCell *momentPrototypeCell;
@property (strong,nonatomic) ReplyInputView *replyInputView;
@property (strong,nonatomic) ModelSizeCache *modelSizeCache;
@property (strong,nonatomic) DBManager *dbManager;
@property (strong,nonatomic) YapDatabaseConnection *readConnection;
@property (strong,nonatomic) YapDatabaseViewMappings *mapping;
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
    [self.readConnection beginLongLivedReadTransaction];
    [self.readConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        [self.mapping updateWithTransaction:transaction];
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MomentCell" bundle:nil] forCellWithReuseIdentifier:kMomentCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yapDatabaseModified:)
                                                 name:YapDatabaseModifiedNotification
                                               object:self.readConnection.database];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MomentsManager getCurrentUserMoments:^(NSArray *objects, NSError *error) {
        [[self.dbManager.db newConnection]asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
            [objects enumerateObjectsUsingBlock:^(Moment *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [transaction setObjectAutomatic:obj];
            }];
        }];
    }];
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

-(MomentCell *)momentPrototypeCell{
    if(!_momentPrototypeCell){
        _momentPrototypeCell=[[[NSBundle mainBundle]loadNibNamed:@"MomentCell" owner:nil options:nil]firstObject];
    }
    return _momentPrototypeCell;
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

-(DBManager *)dbManager{
    if(!_dbManager){
        _dbManager=[DBManager sharedDBManager];
    }
    return _dbManager;
}

-(YapDatabaseConnection *)readConnection{
    if(!_readConnection){
        _readConnection=[self.dbManager.db newConnection];
    }
    return _readConnection;
}

-(YapDatabaseViewMappings *)mapping{
    if(!_mapping){
         _mapping=[YapDatabaseViewMappings mappingsWithGroups:@[@"Moment"] view:[YapDatabaseView viewNameForModel:[Moment class]]];
    }
    return _mapping;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __block Moment *m;
    [self.readConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        YapDatabaseViewTransaction *viewTransaction= [transaction viewTransactionForModel:[Moment class]];
        m=[viewTransaction objectAtIndexPath:indexPath withMappings:self.mapping];
    }];
    //根据 Model 缓存行高
    __weak typeof(self) weakSelf=self;
    CGSize cellSize= [self.modelSizeCache getSizeForModel:m withCollectionView:collectionView orCalc:^CGSize(id model, UICollectionView *collectionView) {
        return [weakSelf.momentPrototypeCell calcSizeWithMoment:(Moment*)model collectionView:(UICollectionView*)collectionView];
    }];
    
    return cellSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSInteger collectionViewWidth= CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(collectionViewWidth, [MomentHeaderView calcHeightWithWidth:collectionViewWidth]);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(MomentCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell forceDismissCommentMeun];
    }];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger section= [self.mapping numberOfSections];
    return section;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=[self.mapping numberOfItemsInSection:section];
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MomentCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:kMomentCell forIndexPath:indexPath];
    
    Moment *m= [Moment momentFromDBWithConnection:self.readConnection indexPath:indexPath mapping:self.mapping];

    [cell configWithMoment:m collectionView:collectionView];
    cell.delegate=self;
    cell.commentsController.delegate=self;
    //    在下面的 willDisplayCell 方法中为 Cell 设置 Model 会报错...!
    //http://southpeak.github.io/blog/2015/12/20/perfect-smooth-scrolling-in-uitableviews/
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MomentHeaderView *header= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMomentHeaderView forIndexPath:indexPath];
    [header configWithUser:[User currentUser]];
    return header;
}

#pragma mark - Notification
-(void)downloadImageCompleteNotification:(NSNotification *)noti{
    [self.collectionView pendingReloadData];
}

-(void)userUpdateNotification:(NSNotification*)noti{
    [self.collectionView pendingReloadData];
}

#pragma mark - MomentCellDelegate //每个朋友圈的右下角菜单
-(void)momentCellDidLikeBtnClick:(MomentCell *)cell{
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *moment= [Moment momentFromDBWithConnection:self.readConnection indexPath:indexPath mapping:self.mapping];
    
    [cell forceDismissCommentMeun];
    [self.modelSizeCache invalidateCacheForModel:moment];
    [moment addOrRemoveFavourUser:[User currentUser]];
    [moment saveOrUpdateInBackground:^(BOOL succeeded, NSError *error) {
        //no more reload,when we modify YapDatabase,YapDatabaseModifiedNotification will be post
        //so the `yapDatabaseModified:` method will be called,and reload will be fired
        //make my life easier ,like Core Data ,LOL
        //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

-(void)momentCellDidCommentBtnClick:(MomentCell *)cell{
    [cell forceDismissCommentMeun];
    
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *m= [Moment momentFromDBWithConnection:self.readConnection indexPath:indexPath mapping:self.mapping];
    
    __weak typeof(self) weakSelf=self;
    self.replyInputView.replyCommentCallback=^(NSString *reply,NSError *error){
        weakSelf.replyInputView.textField.text=@"";
        [weakSelf.replyInputView.textField resignFirstResponder];
        [weakSelf postNewCommentForMoment:m commentContent:reply replyTo:nil];
    };
    
    [self.replyInputView showInViewAtBottom:self.view];
}

-(void)momentCell:(MomentCell *)cell didPhotoViewController:(NewMomentPhotoViewerController *)controller photoCellClick:(UICollectionViewCell *)photoCell{
    NSIndexPath *cellIndexPath=[self.collectionView indexPathForCell:cell];
    Moment *m= [Moment momentFromDBWithConnection:self.readConnection indexPath:cellIndexPath mapping:self.mapping];
    
    NSIndexPath *photoCellIndexPath= [controller.collectionView indexPathForCell:photoCell];
    AVFile *image= m.images[photoCellIndexPath.row];
    
    [MediaViewerController showIn:self withImageUrl:[NSURL URLWithString:image.url]];
}

-(void)momentEditMenuWillShowForCell:(MomentCell *)cell likeBtn:(UIButton *)likeBtn commentBtn:(UIButton *)commentBtn{
    NSIndexPath *indexPath= [self.collectionView indexPathForCell:cell];
    Moment *m= [Moment momentFromDBWithConnection:self.readConnection indexPath:indexPath mapping:self.mapping];
    BOOL isFavoured= [m.favourUsers containsObject:[User currentUser]];//当前用户已经赞过
    NSString *likeBtnTitle=isFavoured ? @"取消" : @"赞";
    [likeBtn setTitle:likeBtnTitle forState:UIControlStateNormal];
}

#pragma mark - CommentsTableControllerDelegate //点击下面的评论列表,回复某人的评论

-(void)commentsTableController:(CommentsTableController *)controller didCommentClick:(Comment *)comment withCell:(UICollectionViewCell *)cell moment:(Moment *)moment{
    __weak typeof(self) weakSelf=self;
    self.replyInputView.replyCommentCallback=^(NSString *reply,NSError *error){
        weakSelf.replyInputView.textField.text=@"";
        [weakSelf.replyInputView.textField resignFirstResponder];
        [weakSelf postNewCommentForMoment:moment commentContent:reply replyTo:comment.commentUser];
    };
    
    self.replyInputView.textField.placeholder=[NSString stringWithFormat:@"回复 %@ :",comment.commentUserName];
    [self.replyInputView showInViewAtBottom:self.view];
}


#pragma mark - Private

/**
 *  为某个朋友圈发送新评论
 */
-(void)postNewCommentForMoment:(Moment*)m commentContent:(NSString*)reply replyTo:(User*)replyTo{
    
    [self.modelSizeCache invalidateCacheForModel:m];
    executeAsyncInGlobalQueue(^{
        Comment *newComment= [Comment commentWithCommentUser:[User currentUser] commentContent:reply replayTo:replyTo];
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [m addNewComment:newComment];
            [m saveOrUpdateInBackground:^(BOOL succeeded, NSError *error) {
                
            }];
        }];
    });
}

#pragma mark - DB
-(void)yapDatabaseModified:(NSNotification*)noti{
    // Jump to the most recent commit.
    // End & Re-Begin the long-lived transaction atomically.
    // Also grab all the notifications for all the commits that I jump.
    // If the UI is a bit backed up, I may jump multiple commits.
    
    NSArray *notifications = [self.readConnection beginLongLivedReadTransaction];
    
    // Process the notification(s),
    // and get the change-set(s) as applies to my view and mappings configuration.
    
    NSArray *sectionChanges = nil;
    NSArray *rowChanges = nil;
    
    [[self.readConnection ext:[YapDatabaseView viewNameForModel:[Moment class]]]
                                            getSectionChanges:&sectionChanges
                                                  rowChanges:&rowChanges
                                            forNotifications:notifications
                                                withMappings:self.mapping];
    
    // No need to update mappings.
    // The above method did it automatically.
    
    if ([sectionChanges count] == 0 & [rowChanges count] == 0)
    {
        // Nothing has changed that affects our tableView
        return;
    }
    
    [self.collectionView reloadData];
}
@end
