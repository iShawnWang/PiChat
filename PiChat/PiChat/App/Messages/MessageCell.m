//
//  MessageCell.m
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MessageCell.h"
#import "User.h"
#import "ImageCache.h"
#import <DateTools.h>
#import "AVIMConversation+Addition.h"
#import "UIView+Badge.h"

@interface MessageCell ()

@end

@implementation MessageCell
-(void)prepareForReuse{
    [self.avatarImageView removeBadge];
}

-(void)configWithUser:(User*)u conv:(AVIMConversation*)conv{
    if(u){
        self.nameLabel.text=u.displayName;
        self.lastMessageLabel.text=conv.lastMessage.text ? : @"";
        self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
        self.dateLabel.text=[conv.lastMessageAt timeAgoSinceNow];
        if(conv.unReadCount>0){
            [self.avatarImageView showBadgeWithCount:conv.unReadCount];
        }
    }else{
        self.nameLabel.text=@"";
        self.lastMessageLabel.text=@"";
        self.dateLabel.text=@"";
    }
}

-(void)removeBadgeForCell{
    [self.avatarImageView removeBadge];
}
@end
