//
//  MomentHeaderView.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentHeaderView.h"
#import "User.h"
#import "ImageCache.h"

@implementation MomentHeaderView
-(void)configWithUser:(User*)u{
    self.backgroundImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath];
    self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath];
    self.displayNameLabel.text=u.displayName;
}

+(NSInteger)calcHeightWithWidth:(NSInteger)width{
    return width+42;
}
@end
