//
//  AddFriendCell.m
//  PiChat
//
//  Created by pi on 16/5/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AddFriendCell.h"
#import "User.h"
#import "UserManager.h"
#import "CommenUtil.h"
#import "ImageCacheManager.h"


@interface AddFriendCell ()
@end

@implementation AddFriendCell
-(void)configWithUser:(User*)u{
    self.textLabel.text=u.displayName;
    self.detailTextLabel.text=@"";
    if([u.avatarPath isEmptyString]){
        [[UserManager sharedUserManager] findUserByObjectID:u.objectId callback:^(User *user, NSError *error) {
            if (![u.objectId isEqualToString:user.objectId]) {
                return ;
            }
            [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:user withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if(entity==u){
                    self.imageView.image=image;
                }
            }];
        }];
    }else{
        [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            if(entity==u){
                self.imageView.image=image;
            }
        }];
    }
}
@end
