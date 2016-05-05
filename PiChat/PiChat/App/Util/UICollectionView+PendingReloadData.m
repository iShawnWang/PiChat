//
//  UICollectionView+PendingReloadData.m
//  PiChat
//
//  Created by pi on 16/4/30.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UICollectionView+PendingReloadData.h"
#import <objc/runtime.h>
#import <JSQMessages.h>

static char const * const kHasPendingOperationKey = "hasPendingOperationKey";
static char const * const kLastReloadTimeKey = "lastReloadTimeKey";
static char const * const kMinReloadIntervalKey = "minReloadIntervalKey";

@interface UICollectionView ()
@property (assign,nonatomic) BOOL hasPendingOperation; //有等待执行的 ReloadData()方法
@property (strong,nonatomic) NSDate *lastReloadTime; //上次执行 ReloadData() 方法的时间
@end

@implementation UICollectionView (PendingReloadData)

#pragma mark - Getter Setter

-(void)removePendingReload{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
}

-(BOOL)hasPendingOperation{
    
    return [objc_getAssociatedObject(self, kHasPendingOperationKey) boolValue];
}
-(void)setHasPendingOperation:(BOOL)hasPendingOperation{
    objc_setAssociatedObject(self, kHasPendingOperationKey, @(hasPendingOperation), OBJC_ASSOCIATION_ASSIGN);
}

-(NSDate*)lastReloadTime{
    return objc_getAssociatedObject(self, kLastReloadTimeKey) ;
}

-(void)setLastReloadTime:(NSDate*)lastReloadTime{
    objc_setAssociatedObject(self, kLastReloadTimeKey, lastReloadTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)minReloadInterval{
    return [objc_getAssociatedObject(self, kMinReloadIntervalKey) doubleValue];
}

-(void)setMinReloadInterval:(NSTimeInterval)minReloadInterval{
    objc_setAssociatedObject(self, kMinReloadIntervalKey, @(minReloadInterval), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -

/**
 *  防止短时间(默认250ms)内多次 ReloadData 调用,导致 UICollectionview 奇怪 Bug,cell 消失,界面闪.
 */
-(void)pendingReloadData{
//    NSLog(@"pendingReloadData if Need");
    NSDate *now= [NSDate date];
    NSDate *lastReloadTime=self.lastReloadTime;
    NSTimeInterval timeInterval= [lastReloadTime timeIntervalSinceDate:now];
    
    if(self.minReloadInterval<=0){
        self.minReloadInterval=250.0;
    }
    //第一次调用 ReloadData 就随他去吧
    if(lastReloadTime==nil){
//        NSLog(@"第一次 Reload");
        self.lastReloadTime=now;
        [self invokeReloadData];
        return;
    }
    //有等待执行的 ReloadData() 操作,直接返回,因为一会 ReloadData()方法就执行了
    if(self.hasPendingOperation){
//        NSLog(@"有 Pending Reload ,返回");
        return;
    }
    //短时间内多次调用 ReloadData()方法,延迟这次的方法执行
    if(timeInterval<self.minReloadInterval){
        
        self.hasPendingOperation=YES;
        NSTimeInterval delay=self.minReloadInterval-timeInterval;
//        NSLog(@"发送延迟 Reload interval:%lf, delay %lf:",timeInterval,delay);
        self.lastReloadTime=[now dateByAddingTimeInterval:delay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"延迟 Reload 执行完毕");
            
            self.hasPendingOperation=NO;
            [self invokeReloadData];
        });
    }else{
        //NSLog(@"这次 Reload 时间符合要求");
        //ReloadData() 方法调用的时间间隔符合要求
        self.lastReloadTime=now;
        [self invokeReloadData];
    }
}

-(void)invokeReloadData{
    [self performSelector:@selector(reloadData)];
}
@end
