//
//  CommentsTableController.h
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Moment;
@class CommentsTableController;
@class Comment;

static NSString *const kCommentsTableController=@"CommentsTableController";

@protocol CommentsTableControllerDelegate <NSObject>

-(void)commentsTableController:(CommentsTableController*)controller didCommentClick:(Comment*)comment withCell:(UICollectionViewCell*)cell moment:(Moment*)moment;

@end

@interface CommentsTableController : UITableViewController
@property (strong,nonatomic) Moment *moment;
@property (weak, nonatomic) UICollectionViewCell *superCell;
@property(nonatomic,weak) IBOutlet id<CommentsTableControllerDelegate> delegate;
@end
