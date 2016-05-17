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
#import "ImageCache.h"
#import "CommenUtil.h"


@interface AddFriendCell ()
@property (strong,nonatomic) User *user;
@end

@implementation AddFriendCell
-(void)configWithUser:(User*)user{
    self.textLabel.text=user.displayName;
    self.detailTextLabel.text=@"";
    if([user.avatarPath isEmptyString]){
        [[UserManager sharedUserManager] findUserByObjectID:user.objectId callback:^(User *user, NSError *error) {
            if (![user.objectId isEqualToString:self.user.objectId]) {
                return ;
            }
            self.imageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:user.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
        }];
    }else{
        self.imageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:user.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
    }
}
@end
