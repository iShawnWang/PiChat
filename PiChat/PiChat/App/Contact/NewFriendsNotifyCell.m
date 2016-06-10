//
//  NewFriendsNotifyCell.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NewFriendsNotifyCell.h"
#import "UIView+Badge.h"

@implementation NewFriendsNotifyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initPrivate];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate{
    self.imageView.image=[UIImage imageNamed:@"plugins_FriendNotify"];
    self.textLabel.text=@"新的朋友";
}

-(void)configWithBedgeCount:(NSInteger)count{
    if(count>0){
        [self.imageView showBadgeWithCount:count];
    }else{
        [self.imageView removeBadge];
    }
}
@end
