//
//  MessageCell.m
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MessageCell.h"
#import "User.h"
#import <DateTools.h>
#import "AVIMConversation+Addition.h"
#import "UIView+Badge.h"
#import "ImageCacheManager.h"

@interface MessageCell ()

@end

@implementation MessageCell
-(void)prepareForReuse{
    [self.avatarImageView removeBadge];
}

-(void)configWithUser:(User*)u conv:(AVIMConversation*)conv{
    self.nameLabel.text=@"";
    self.lastMessageLabel.text=@"";
    self.dateLabel.text=@"";
    if(u){
        self.nameLabel.text=u.displayName;
        self.lastMessageLabel.text=conv.lastMessage.text ? : @"";

        [[ImageCacheManager sharedImageCacheManager]retrieveImageForEntity:u withFormatName:kUserAvatarRoundFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            if(entity==u){
                self.avatarImageView.image=image;
            }
        }];
        
        self.dateLabel.text=[conv.lastMessageAt timeAgoSinceNow];
        if(conv.unReadCount>0){
            [self.avatarImageView showBadgeWithCount:conv.unReadCount];
        }
    }
}

-(void)removeBadgeForCell{
    [self.avatarImageView removeBadge];
}
@end
