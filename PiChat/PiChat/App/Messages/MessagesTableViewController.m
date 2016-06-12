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
#import "NSNotification+ReceiveMessage.h"
#import <Masonry.h>
#import "ReachAbilityView.h"
#import "Reachability.h"

NSString *const kMessageCellID=@"MessageCell";

@interface MessagesTableViewController ()
@property (strong,nonatomic) ConversationManager *manager;
@property (strong,nonatomic) NSMutableArray *recentConversations;
@property (strong,nonatomic) ImageCache *imageCache;
@property (strong,nonatomic) ReachAbilityView *reachAbilityView;
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessageNotification:) name:kDidReceiveTypedMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarDownloadCompleteNotification:) name:kDownloadImageCompleteNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
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

-(ReachAbilityView *)reachAbilityView{
    if(!_reachAbilityView){
        _reachAbilityView=[ReachAbilityView loadViewFroNib];
    }
    return _reachAbilityView;
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
        User *u= [[UserManager sharedUserManager]findUserFromCacheElseNetworkByObjectID:[conversation chatToUserId]];
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
        MessageCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:chatVC animated:YES];
        [cell removeBadgeForCell];
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

#pragma mark - 
-(void)receiveMessageNotification:(NSNotification*)noti{
    [self.recentConversations enumerateObjectsUsingBlock:^(AVIMConversation *conv, NSUInteger idx, BOOL * _Nonnull stop) {
        if([conv.conversationId isEqualToString:noti.message.conversationId]){
            *stop=YES;
            conv.lastMessage=noti.message;
            conv.unReadCount=conv.unReadCount+1; //显示 bedge 红点...
            NSIndexPath *indexPath= [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

#pragma mark - 网络状态改变
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case RealStatusUnknown: {
            break;
        }
        case RealStatusNotReachable: {
            [self.reachAbilityView showUnReachableInTableView:self.tableView];
            break;
        }
        case RealStatusViaWWAN:
        case RealStatusViaWiFi:{
            [self.reachAbilityView hideForTableView:self.tableView];
            break;
        }
    }
}

@end
