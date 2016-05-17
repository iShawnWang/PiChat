//
//  ContactCell.m
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ContactCell.h"
#import "User.h"
#import "ImageCache.h"


NSString *const kContactCellID=@"ContactCell";
@interface ContactCell ()

@end

@implementation ContactCell

-(void)configWithUser:(User*)u{
    self.nameLabel.text=u.displayName;
    self.detailLabel.text=@"";
    self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
}
@end
