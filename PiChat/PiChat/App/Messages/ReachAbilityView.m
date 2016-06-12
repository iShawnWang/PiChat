//
//  ReachAbilityView.m
//  PiChat
//
//  Created by pi on 16/6/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ReachAbilityView.h"
#import "UIView+PiAdditions.h"
#import <RealReachability.h>

@implementation ReachAbilityView
+(instancetype)loadViewFroNib{
    UIView *v= [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(ReachAbilityView.class) owner:nil options:nil].firstObject;
    return (ReachAbilityView*)v;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.width=self.superview.width;
    [self layoutIfNeeded];
}

-(void)showUnReachableInTableView:(UITableView*)tableView{
    if(tableView.tableHeaderView){
        return;
    }
    tableView.tableHeaderView=[ReachAbilityView loadViewFroNib];
    tableView.tableHeaderView.height=0;
    [UIView animateWithDuration:0.225 animations:^{
        tableView.tableHeaderView.height=44;
        [tableView layoutIfNeeded];
    }];
}

-(void)hideForTableView:(UITableView*)tableView{
    if(!tableView.tableHeaderView){
        return;
    }
    CGFloat originalOffsetY=tableView.contentOffset.y;
    CGFloat animOffsetY=originalOffsetY +44;
    [UIView animateWithDuration:0.225 animations:^{
        tableView.tableHeaderView.height=0;
        tableView.contentOffset=CGPointMake(0, animOffsetY);
        [tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
        tableView.tableHeaderView=nil;
        tableView.contentOffset=CGPointMake(0, originalOffsetY);
    }];
    
}

@end
