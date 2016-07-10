//
//  MomentHeaderView.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentHeaderView.h"
#import "User.h"
#import "GlobalConstant.h"
#import "ImageCacheManager.h"

@implementation MomentHeaderView
-(void)configWithUser:(User*)u{
    
    [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        if(entity==u){
            self.avatarImageView.image=image;
        }
    }];
    [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarBlurFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        if(entity==u){
            self.backgroundImageView.image=image;
        }
    }];
    
    self.displayNameLabel.text=u.displayName;
}

+(NSInteger)calcHeightWithWidth:(NSInteger)width{
    return width+44;
}
@end
