//
//  UICollectionView+PendingReloadData.h
//  PiChat
//
//  Created by pi on 16/4/30.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (PendingReloadData)
@property (assign,nonatomic) NSTimeInterval minReloadInterval;

/**
 *  将你所有的 ReloadData()方法调用换成这个.
 *  防止短时间(默认250ms)内多次 ReloadData 调用,导致 UICollectionview 奇怪 Bug,cell 消失,界面闪.
 */
-(void)pendingReloadData;

/**
 *  collectionview dealloc 时调用这个
 */
-(void)removePendingReload;
@end
