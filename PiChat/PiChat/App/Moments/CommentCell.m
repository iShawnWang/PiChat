//
//  CommentCell.m
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CommentCell.h"
#import "TTTAttributedLabel.h"
#import "Comment.h"

@interface CommentCell ()
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentLabel;
@end

@implementation CommentCell

-(void)awakeFromNib{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)configWithComment:(Comment *)comment{
    NSMutableAttributedString *attrStr;
    NSString *commentUserName=comment.commentUserName;
    NSString *replayToUserName=comment.replyToUserName;
    NSString *commentContent=comment.commentContent;
    
    if(comment.replyToUser){
        NSString *commentStr= [NSString stringWithFormat:@" %@ 回复 %@ : %@ ",commentUserName,replayToUserName,commentContent];
        attrStr=[[NSMutableAttributedString alloc]initWithString:commentStr];
        self.commentLabel.text=attrStr;
        [self.commentLabel addLinkToURL:[NSURL URLWithString:commentUserName] withRange:[commentStr rangeOfString:commentUserName]];
        [self.commentLabel addLinkToURL:[NSURL URLWithString:replayToUserName] withRange:[commentStr rangeOfString:replayToUserName options:NSBackwardsSearch]];
    }else{
        NSString *commentStr= [NSString stringWithFormat:@" %@ : %@ ",commentUserName,commentContent];
        attrStr=[[NSMutableAttributedString alloc]initWithString:commentStr];
        self.commentLabel.text=attrStr;
        
        [self.commentLabel addLinkToURL:[NSURL URLWithString:commentUserName] withRange:[commentStr rangeOfString:commentUserName]];
    }
}
@end
