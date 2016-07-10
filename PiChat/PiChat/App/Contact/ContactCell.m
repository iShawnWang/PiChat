//
//  ContactCell.m
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ContactCell.h"
#import "User.h"
#import "ImageCacheManager.h"


NSString *const kContactCellID=@"ContactCell";
@interface ContactCell ()

@end

@implementation ContactCell

-(void)configWithUser:(User*)u{
    self.nameLabel.text=u.displayName;
    self.detailLabel.text=@"";
    
    [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        if(entity==u){
            self.avatarImageView.image=image;
        }
    }];
    
}
@end
