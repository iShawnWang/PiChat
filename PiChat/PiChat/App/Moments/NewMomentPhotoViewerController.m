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

NSInteger const kCellSize=66;
@interface NewMomentPhotoViewerController ()<UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) MediaPicker *mediaPicker;
@end

@implementation NewMomentPhotoViewerController

static NSString * const kNewMomentPhotoCellID = @"NewMomentPhotoCell";
static NSString * const kNewMomentAddCellID = @"NewMomentAddCell";
static NSString * const kNewMomentDeleteCellID = @"NewMomentDeleteCell";

#pragma mark - Life Cycle
@synthesize photoUrls=_photoUrls;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentState=PhotoViewerStateNormal;
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.photoViewerType==PhotoViewerTypePick){
        return self.photoUrls.count+2;
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
        cell.contentView.layer.borderColor=[UIColor colorFromHexString:@"DEDEDE"].CGColor;
        cell.contentView.layer.borderWidth=1;
        if(photoCount==9 || self.currentState==PhotoViewerStateDelete){
            cell.hidden=YES;
        }else {
            cell.hidden=NO;
        }
    }else if(indexPath.item==photoCount+1){
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:kNewMomentDeleteCellID forIndexPath:indexPath];
        cell.contentView.layer.borderColor=[UIColor colorFromHexString:@"DEDEDE"].CGColor;
        cell.contentView.layer.borderWidth=1;
        if(self.currentState==PhotoViewerStateDelete || photoCount==0){
            cell.hidden=YES;
        }else{
            cell.hidden=NO;
        }
    }
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell= [collectionView cellForItemAtIndexPath:indexPath];
    
    
    if([cell.reuseIdentifier isEqualToString:kNewMomentAddCellID]){
        [self.mediaPicker showImagePickerIn:self withCallback:^(NSURL *url, NSError *error) {
            [self.photoUrls addObject:url];
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
    return CGSizeMake(kCellSize, kCellSize);
}


@end
