//
//  CommentsTableController.m
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CommentsTableController.h"
#import "Moment.h"
#import "User.h"
#import "FavourUsersCell.h"
#import "CommentCell.h"

NSString *const kCommentsTableController=@"CommentsTableController";
NSString *const kFavourUsersCell=@"FavourUsersCell";

@interface CommentsTableController ()
@property (assign,nonatomic) BOOL hasFavourUsers;
@end

@implementation CommentsTableController

-(void)setMoment:(Moment *)moment{
    _moment=moment;
    [self.tableView reloadData];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight=33;
}

#pragma mark - Table view data source

/**
 *  tableview 分为2个 section :
 *
 *  0 - 所有赞(只有一个 cell,所有赞的人放在一个 Label 中), 1 - 所有评论(一个人的评论占一行,一个 cell)
 *
 *  4种情况
 *  0.赞和评论都没有 section=0
 *  1.只有 赞 section=1 ,self.hasFavourUsers=YES
 *  2.只有 评论 section =1 ,self.hasFavourUsers=NO
 *  3.赞和评论都有 section=2 ,self.hasFavourUsers=YES
 *
 *
 *  @param tableView
 *
 *  @return
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSection=0;
    if((self.hasFavourUsers=self.moment.favourUsers.count>0)){
        numberOfSection++;
    }
    if(self.moment.comments.count>0){
        numberOfSection++;
    }
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0 && self.hasFavourUsers){
        return 1;
    }else{
        return self.moment.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0 && self.hasFavourUsers){
        FavourUsersCell *favoursCell=[tableView dequeueReusableCellWithIdentifier:kFavourUsersCell];
        [favoursCell configCellWithFavourUsers:self.moment.favourUsers tableView:tableView];
        return favoursCell;
    }else{
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCell forIndexPath:indexPath];
        Comment *comment= self.moment.comments[indexPath.row];
        [cell configWithComment:comment];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && self.hasFavourUsers){
        return;
    }
    if(self.delegate){
        [self.delegate commentsTableController:self didCommentClick:self.moment.comments[indexPath.row] withCell:self.superCell moment:self.moment];
    }
}

@end
