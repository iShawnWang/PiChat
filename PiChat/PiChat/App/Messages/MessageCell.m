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

@interface MessageCell ()

@end

@implementation MessageCell
-(void)configWithUser:(User*)u conv:(AVIMConversation*)conv{
    if(u){
        self.nameLabel.text=u.displayName;
        self.lastMessageLabel.text=conv.lastMessage.text;
        self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
        self.dateLabel.text=[conv.lastMessageAt timeAgoSinceNow];
    }else{
        self.nameLabel.text=@"";
        self.lastMessageLabel.text=@"";
        self.dateLabel.text=@"";
    }
}
@end
