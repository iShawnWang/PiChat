//
//  CommentCell.h
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;
FOUNDATION_EXPORT NSString *const kCommentCell;

@interface CommentCell : UITableViewCell
-(void)configWithComment:(Comment*)comment;
@end
