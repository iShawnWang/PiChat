//
//  NewMomentPhotoViewerController.m
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NewMomentPhotoViewerController.h"
#import "NewMomentPhotoCell.h"
#import "MediaPicker.h"
#import "CommenUtil.h"
#import "UIColor+Addition.h"
#import "AVFile+FICEntity.h"
#import "ImageCacheManager.h"
#import "TouchDismissView.h"
#import "GlobalConstant.h"


NSString * const kNewMomentPhotoCellID = @"NewMomentPhotoCell";
NSString * const kNewMomentAddCellID = @"NewMomentAddCell";
NSString * const kNewMomentDeleteCellID = @"NewMomentDeleteCell";
NSString *const kNewMomentPhotoViewerControllerID=@"NewMomentPhotoViewerController";

NSInteger const kMaxPickAllowedCount=9 ; //最多能选9张照片
NSInteger const kCellCountPerLine=3; //每行最多3个照片
NSInteger const kCellBoraderWidth=1; //灰色边框宽度

@interface NewMomentPhotoViewerController ()<UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UIColor *cellBorderColor;
@property (strong,nonatomic) MediaPicker *mediaPicker;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;

//
@property (strong,nonatomic) TouchDismissView *touchDismissView;
@end

@implementation NewMomentPhotoViewerController

#pragma mark - Life Cycle
@synthesize photoUrls=_photoUrls;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentState=PhotoViewerStateNormal;
    self.cellBorderColor=[UIColor lightGrayDividerColor];
    self.flowLayout= (UICollectionViewFlowLayout*)self.collectionViewLayout;
    self.flowLayout.minimumLineSpacing=0;
    self.flowLayout.minimumInteritemSpacing=0;
    self.flowLayout.sectionInset=UIEdgeInsetsZero;
    
    //minimunLineSpacing :
    //同一行的 cell 之间是 2 * minimunLineSpacing
    //同一列的 cell 之间是 minimunLineSpacing
    //cell 和边界的距离是 0
    // 坑 !!!
}

#pragma mark - Getter Setter
-(NSMutableArray *)photoUrls{
    if(!_photoUrls){
        _photoUrls=[NSMutableArray array];
    }
    return _photoUrls;
}

-(void)setPhotoUrls:(NSMutableArray *)photoUrls{
    _photoUrls=photoUrls;
    [self.collectionView reloadData];
}

-(void)setAvFilePhotos:(NSArray<AVFile *> *)avFilePhotos{
    _avFilePhotos=avFilePhotos;
    [self.collectionView reloadData];
}

-(MediaPicker *)mediaPicker{
    if(!_mediaPicker){
        _mediaPicker=[[MediaPicker alloc]init];
    }
    return _mediaPicker;
}

-(UIView *)touchDismissView{
    if(!_touchDismissView){
        _touchDismissView=[TouchDismissView new];
        _touchDismissView.backgroundColor=[UIColor clearColor];
        
        @weakify(self);
        _touchDismissView.hitTestBlock=^UIView*(CGPoint point ,UIEvent *event){
            @strongify(self);
            CGRect collectionViewFrameInWindow= [self.collectionView convertRect:self.collectionView.bounds toView:nil];
            if(!CGRectContainsPoint(collectionViewFrameInWindow, point)){
                self.currentState=PhotoViewerStateNormal;
                [self.touchDismissView removeFromSuperview];
                [self.collectionView reloadData];
            }
            return nil;
        };
    }
    CGRect windowBounds= [[UIApplication sharedApplication]keyWindow].bounds;
    _touchDismissView.frame=windowBounds;
    return _touchDismissView;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.photoViewerType==PhotoViewerTypePick){
        NSInteger photoCount=self.photoUrls.count;
        if(photoCount==0){
            //只显示 + 按钮
            return 1;
        } else if(photoCount >0 && photoCount <kMaxPickAllowedCount){
            //显示 + 和 - 按钮
            return self.photoUrls.count+2;
        }else if(photoCount >= kMaxPickAllowedCount){
            //只显示 - 按钮
            return self.photoUrls.count+1;
        }else{
            return -1; //不可能 ~
        }
    }else{
        return self.avFilePhotos.count ? :0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    if(self.photoViewerType==PhotoViewerTypePick){ //图片选择控件
        NSInteger photoCount=self.photoUrls.count;
        
        if(indexPath.item<photoCount){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentPhotoCellID forIndexPath:indexPath];
            NewMomentPhotoCell *photoCell=(NewMomentPhotoCell*)cell;
            NSURL *imgUrl=self.photoUrls[indexPath.item];
            
            //从本地加载图片,防止图片错位.
            executeAsyncInGlobalQueue(^{
                NSURL *localImageUrl=imgUrl;
                UIImage *localImage= [UIImage imageWithData: [NSData dataWithContentsOfURL:imgUrl]];
                executeAsyncInMainQueueIfNeed(^{
                    if(imgUrl==localImageUrl){ //防止图片错位,
                        photoCell.imageView.image=localImage;
                    }
                });
            });
        }else{
            if(indexPath.item==photoCount+1 || photoCount==9){ // -
                cell= [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentDeleteCellID forIndexPath:indexPath];
                if(self.currentState==PhotoViewerStateDelete || photoCount==0){
                    cell.hidden=YES;
                }else{
                    cell.hidden=NO;
                }
            }else{
                cell= [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentAddCellID forIndexPath:indexPath];
                if(photoCount==kMaxPickAllowedCount || self.currentState==PhotoViewerStateDelete){
                    cell.hidden=YES;
                }else {
                    cell.hidden=NO;
                }
            }
        }
    }else if(self.photoViewerType==PhotoViewerTypeView){ //图片浏览控件
        NewMomentPhotoCell *photoCell=[collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentPhotoCellID forIndexPath:indexPath];
        cell=photoCell;
        
        AVFile *photoFile=self.avFilePhotos[indexPath.row];
        [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:photoFile withFormatName:kMomentThumbnailFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            if([[entity FIC_UUID] isEqualToString:[photoFile FIC_UUID]]){
                photoCell.imageView.image=image;
            }
        }];
    }
    if([cell isKindOfClass:[NewMomentPhotoCell class]]){
        NewMomentPhotoCell *photoCell=(NewMomentPhotoCell*)cell;
        photoCell.imageView.layer.borderWidth=kCellBoraderWidth;
        photoCell.imageView.layer.borderColor=self.cellBorderColor.CGColor;
        photoCell.deleteImage.hidden=(self.currentState==PhotoViewerStateNormal);
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell= [collectionView cellForItemAtIndexPath:indexPath];
    
    if([cell.reuseIdentifier isEqualToString:kNewMomentAddCellID]){

        NSInteger allowSelectCount=kMaxPickAllowedCount- self.photoUrls.count;
        [self.mediaPicker showImagePickerIn:self multipleSelectionCount:allowSelectCount imgUrlsCallback:^(NSArray *objects, NSError *error) {
            [objects enumerateObjectsUsingBlock:^(NSURL *imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
                if(![self.photoUrls containsObject:imgUrl]){
                    [self.photoUrls addObject:imgUrl];
                }
            }];
            [self.collectionView reloadData];
        }];
    }else if([cell.reuseIdentifier isEqualToString:kNewMomentDeleteCellID]){
        self.currentState=PhotoViewerStateDelete;
        
        //
        [self.view.superview.superview addSubview:self.touchDismissView];
        //
        [self.collectionView reloadData];
        
    }else if([cell.reuseIdentifier isEqualToString:kNewMomentPhotoCellID]){
        if(self.currentState==PhotoViewerStateDelete){
            [self.photoUrls removeObjectAtIndex:indexPath.item];
            if(self.photoUrls.count==0){
                self.currentState=PhotoViewerStateNormal;
            }
            [self.collectionView reloadData];
        }else{
            [self.photoViewerDelegate photoViewerController:self didPhotoCellClick:cell];
        }
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemSize= CGRectGetWidth(collectionView.bounds)/kCellCountPerLine;
    return CGSizeMake(itemSize, itemSize);
}
@end
