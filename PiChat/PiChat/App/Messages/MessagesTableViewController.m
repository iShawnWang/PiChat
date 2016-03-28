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
#import "ImageCache.h"
#import "NSNotification+UserUpdate.h"
#import "NSNotification+DownloadImage.h"
#import "MessageCell.h"
#import "TextPathRefreshControl.h"

NSString *const kMessageCellID=@"MessageCell";

@interface MessagesTableViewController ()
@property (strong,nonatomic) ConversationManager *manager;
@property (strong,nonatomic) NSMutableArray *recentConversations;
@property (strong,nonatomic) ImageCache *imageCache;
@end

@implementation MessagesTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"消息";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_mainframeHL"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_mainframe"];
        self.hidesBottomBarWhenPushed=NO;
        self.manager=[ConversationManager sharedConversationManager];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarDownloadCompleteNotification:) name:kDownloadImageCompleteNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter
-(NSMutableArray *)recentConversations{
    if(!_recentConversations){
        _recentConversations=[NSMutableArray array];
    }
    return _recentConversations;
}

-(ImageCache *)imageCache{
    if(!_imageCache){
        _imageCache=[ImageCache sharedImageCache];
    }
    return _imageCache;
}

#pragma mark - Life Cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight=88;
    self.tableView.mj_header=[TextPathRefreshControl headerWithRefreshingBlock:^{
        [self.manager fetchReventConversations:^(NSArray *objects, NSError *error) {
            [self.recentConversations removeAllObjects];
            [self.recentConversations addObjectsFromArray:objects];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.manager fetchReventConversations:^(NSArray *objects, NSError *error) {
        [self.recentConversations removeAllObjects];
        [self.recentConversations addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentConversations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:kMessageCellID];
    
    AVIMConversation *conversation= self.recentConversations[indexPath.row];
    if(conversation.transient){//群聊
        
    }else{//单聊
        User *u= [[UserManager sharedUserManager]findUserFromCacheElseNetworkByClientID:[conversation chatToUserId]];
        [cell configWithUser:u conv:conversation];
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

#pragma mark - 用户更新,刷新 tableview
-(void)userUpdateNotification:(NSNotification*)noti{
    [self.tableView reloadData]; 
}

#pragma mark - 下载完用户头像,刷新 tableview
-(void)avatarDownloadCompleteNotification:(NSNotification*)noti{
    [self.tableView reloadData];
}

@end
