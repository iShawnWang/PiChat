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

NSString *const kMomentCell=@"MomentCell";
NSString *const kMomentHeaderView=@"MomentHeaderView";

@interface MomentsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *moments;
@property (strong,nonatomic) MomentCell *protypeCell; //计算高度
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MomentCell" bundle:nil] forCellWithReuseIdentifier:kMomentCell];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Getter Setter

-(NSMutableArray *)moments{
    if(!_moments){
        _moments=[NSMutableArray array];
    }
    return _moments;
}

-(MomentCell *)protypeCell{
    if(!_protypeCell){
        _protypeCell=[[[NSBundle mainBundle]loadNibNamed:@"MomentCell" owner:nil options:nil] firstObject];
    }
    _protypeCell.frame=CGRectMake(0, 0,self.collectionView.bounds.size.width, 0);
    
    return _protypeCell;
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

//TODO 解决不了...
//动态计算行高...蛋疼死了 ~
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    Moment *m=self.moments[indexPath.row];
    [self.protypeCell configWithMoment:m];
    [self.protypeCell layoutIfNeeded];
    
    //FIXME 动态计算行高
    CGSize cellSize= [self.protypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGSize photoViewerSize= self.protypeCell.photoViewerController.collectionView.collectionViewLayout.collectionViewContentSize;
    
    return CGSizeMake(self.collectionView.bounds.size.width, cellSize.height+photoViewerSize.height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, [MomentHeaderView calcHeightWithWidth:self.view.bounds.size.width]);
    
    //TODO cellHeight systemFit
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moments.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MomentCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:kMomentCell forIndexPath:indexPath];
    Moment *m=self.moments[indexPath.row];
    [cell configWithMoment:m];
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
@end
