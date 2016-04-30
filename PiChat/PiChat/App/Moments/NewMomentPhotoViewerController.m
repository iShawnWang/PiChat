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
#import "MediaViewerController.h"
#import "CommenUtil.h"
#import "ImageCache.h"


static NSString * const kNewMomentPhotoCellID = @"NewMomentPhotoCell";
static NSString * const kNewMomentAddCellID = @"NewMomentAddCell";
static NSString * const kNewMomentDeleteCellID = @"NewMomentDeleteCell";

NSInteger const kMaxPickAllowedCount=9 ; //最多能选9张照片
NSInteger const kCellCountPerLine=3; //每行最多3个照片
NSInteger const kCellBoraderWidth=1; //灰色边框宽度

@interface NewMomentPhotoViewerController ()<UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UIColor *cellBorderColor;
@property (strong,nonatomic) MediaPicker *mediaPicker;
@end

@implementation NewMomentPhotoViewerController

#pragma mark - Life Cycle
@synthesize photoUrls=_photoUrls;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentState=PhotoViewerStateNormal;
    self.cellBorderColor=[UIColor colorFromHexString:@"DEDEDE"];
    ((UICollectionViewFlowLayout*)self.collectionViewLayout).minimumLineSpacing=5;
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

-(MediaPicker *)mediaPicker{
    if(!_mediaPicker){
        _mediaPicker=[[MediaPicker alloc]init];
    }
    return _mediaPicker;
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.photoViewerType==PhotoViewerTypePick){
        if(self.photoUrls.count>=1){ //至少有一张照片
            return self.photoUrls.count+2; //显示+和-按钮
        }else{
            return self.photoUrls.count+1; //只显示+按钮
        }
    }else{
        return self.photoUrls.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    NSInteger photoCount=self.photoUrls.count;
    
    if(indexPath.item<photoCount){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentPhotoCellID forIndexPath:indexPath];
        NewMomentPhotoCell *photoCell=(NewMomentPhotoCell*)cell;
        NSURL *imgUrl=self.photoUrls[indexPath.item];
        
        UIImage *img;
        if(self.photoViewerType==PhotoViewerTypePick){
            img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]]; //本地 url
        }else if(self.photoViewerType==PhotoViewerTypeView){
            img=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:imgUrl.absoluteString]; //网络 url
        }
        photoCell.imageView.image=img;
        photoCell.deleteImage.hidden=(self.currentState==PhotoViewerStateNormal);
        
    }else if(indexPath.item==photoCount){
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentAddCellID forIndexPath:indexPath];
        if(photoCount==kMaxPickAllowedCount || self.currentState==PhotoViewerStateDelete){
            cell.hidden=YES;
        }else {
            cell.hidden=NO;
        }
    }else if(indexPath.item==photoCount+kCellBoraderWidth){
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentDeleteCellID forIndexPath:indexPath];
        if(self.currentState==PhotoViewerStateDelete || photoCount==0){
            cell.hidden=YES;
        }else{
            cell.hidden=NO;
        }
    }
    cell.contentView.layer.borderColor=self.cellBorderColor.CGColor;
    cell.contentView.layer.borderWidth=kCellBoraderWidth;
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
        [self.collectionView reloadData];
        
    }else if([cell.reuseIdentifier isEqualToString:kNewMomentPhotoCellID]){
        if(self.currentState==PhotoViewerStateDelete){
            [self.photoUrls removeObjectAtIndex:indexPath.item];
            if(self.photoUrls.count==0){
                self.currentState=PhotoViewerStateNormal;
            }
            [self.collectionView reloadData];
        }else{
            
            NSURL *imgUrl=self.photoUrls[indexPath.item];
            [MediaViewerController showIn:self withImage:[UIImage imageWithContentsOfFile:imgUrl.path]];
        }
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout=(UICollectionViewFlowLayout*)collectionViewLayout;
    NSInteger itemSize= (self.view.width-kCellCountPerLine*flowLayout.minimumLineSpacing)/kCellCountPerLine;
    return CGSizeMake(itemSize-2, itemSize-2);
}


@end
