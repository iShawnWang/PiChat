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
    UIImage *avatarImg=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
    
    self.backgroundImageView.image=avatarImg;
    self.avatarImageView.image=avatarImg;
    self.displayNameLabel.text=u.displayName;
}

+(NSInteger)calcHeightWithWidth:(NSInteger)width{
    return width+44;
}
@end
