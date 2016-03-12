//
//  MessagesTableViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "ConversationManager.h"
#import <UIImageView+WebCache.h>
#import <AVOSCloudIM.h>
#import "User.h"
#import "UserManager.h"
#import "PrivateChatController.h"

NSString *const kCellID=@"converstaionCell";

@interface MessagesTableViewController ()
@property (strong,nonatomic) ConversationManager *manager;
@property (strong,nonatomic) NSMutableArray *recentConversations;
@end

@implementation MessagesTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"消息";
        self.tabBarItem.image=[UIImage imageNamed:@"menu"];
        self.hidesBottomBarWhenPushed=NO;
        self.manager=[ConversationManager sharedConversationManager];
    }
    return self;
}

-(NSMutableArray *)recentConversations{
    if(!_recentConversations){
        _recentConversations=[NSMutableArray array];
    }
    return _recentConversations;
}

-(void)viewDidLoad{
    [self.manager fetchReventConversations:^(NSArray *objects, NSError *error) {
        [self.recentConversations addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentConversations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellID];
    AVIMConversation *conversation= self.recentConversations[indexPath.row];
    if(conversation.transient){//群聊
        
    }else{//单聊
        [UserManager findUserByClientID:[conversation chatToUserId] callback:^(User *user, NSError *error) {
            cell.textLabel.text=user.displayName;
            cell.detailTextLabel.text=@"";
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatarPath]];
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateChatController *chatVC= [[PrivateChatController alloc]init];
    AVIMConversation *conversation=self.recentConversations[indexPath.row];
    if(conversation.transient){
        
    }else{
        chatVC.chatToUserID=[conversation chatToUserId];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}
@end
