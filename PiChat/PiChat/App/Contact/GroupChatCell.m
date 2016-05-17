//
//  GroupChatCell.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "GroupChatCell.h"

@implementation GroupChatCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initPrivate];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate{
    self.imageView.image=[UIImage imageNamed:@"add_friend_icon_addgroup"];
    self.textLabel.text=@"群组";
}
@end
