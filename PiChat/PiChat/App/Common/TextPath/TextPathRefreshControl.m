//
//  TextPathRefreshControl.m
//  TextPathRefresh
//
//  Created by pi on 16/3/28.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "TextPathRefreshControl.h"
#import "TextPathHelper.h"

NSInteger const kPadding=8;

@interface TextPathRefreshControl ()
@property (strong,nonatomic) CAShapeLayer *textPathLayer;
@property (strong,nonatomic) CABasicAnimation *textPathAnim;
@property (assign,nonatomic) BOOL willBeginRefresh;
@end

@implementation TextPathRefreshControl

-(void)prepare{
    [super prepare];
    self.willBeginRefresh=NO;
    
    self.textPathLayer=[TextPathHelper textLayerWithText:@"PiChat" frame:CGRectZero];
    self.mj_h=self.textPathLayer.bounds.size.height+kPadding*2;
    [self.layer addSublayer:self.textPathLayer];
    //
    self.textPathAnim=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    self.textPathAnim.fromValue=@(0.0);
    self.textPathAnim.toValue=@(1.0);
    self.textPathAnim.duration=1.0;//Convenience
    self.textPathAnim.removedOnCompletion=NO;
    
    self.textPathLayer.speed=0.0;//pause layer
    [self.textPathLayer addAnimation:self.textPathAnim forKey:@"PiChat"];
}

-(void)placeSubviews{
    [super placeSubviews];
    
    //Center Text Path
    NSInteger textPathWdith= self.textPathLayer.frame.size.width;
    self.textPathLayer.frame=CGRectMake(self.center.x-textPathWdith/2.0,kPadding, self.textPathLayer.bounds.size.width, self.bounds.size.height-kPadding);
}

-(void)setState:(MJRefreshState)state{
    [super setState:state];
    switch (state) {
        case MJRefreshStateIdle: {
            self.willBeginRefresh=NO;
            break;
        }
        case MJRefreshStatePulling: {
            
            break;
        }
        case MJRefreshStateRefreshing: {
            self.textPathLayer.timeOffset=1.0;
            self.willBeginRefresh=YES;
            break;
        }
        case MJRefreshStateWillRefresh: {
            
            break;
        }
        case MJRefreshStateNoMoreData: {
            
            break;
        }
    }
}

-(void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    
    if(!self.willBeginRefresh){
        self.textPathLayer.timeOffset=MIN(pullingPercent/1.6, 1.0);
    }
}

@end
