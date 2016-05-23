//
//  ContactTableViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ContactTableViewController.h"
#import "UserManager.h"
#import "PrivateChatController.h"
#import "NSNotification+UserUpdate.h"
#import "NSNotification+DownloadImage.h"
#import "ImageCache.h"
#import "ContactCell.h"
#import "ContactHeaderCell.h"
#import "SectionedContact.h"
#import "NewFriendsNotifyCell.h"
#import "GroupChatCell.h"

@interface ContactTableViewController ()
@property (strong,nonatomic) SectionedContact *sectionedContact;
@property (assign,nonatomic) NSInteger addFriendBedgeCount;
@end

@implementation ContactTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"联系人";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_contacts"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_contactsHL"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarUpdateNotification:) name:kDownloadImageCompleteNotification object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter
-(SectionedContact *)sectionedContact{
    if(!_sectionedContact){
        _sectionedContact=[SectionedContact new];
    }
    return _sectionedContact;
}

#pragma mark - Life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[GroupChatCell class] forCellReuseIdentifier:kGroupChatCell];
    [self.tableView registerClass:[NewFriendsNotifyCell class] forCellReuseIdentifier:kNewFriendsNotifyCell];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //拉取好友列表
    [[UserManager sharedUserManager] fetchFriendsWithCallback:^(NSArray *objects, NSError *error) {
        [self.sectionedContact clearContacts];
        [objects enumerateObjectsUsingBlock:^(User *u, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.sectionedContact addUser:u];
        }];
        [self.tableView reloadData];
    }];
    //拉取所有添加好友的信息,如果有未读的,就显示小红点, bedge
    [[UserManager sharedUserManager]findAddFriendRequestAboutUser:[User currentUser] callback:^(NSArray *objects, NSError *error) {
        __block NSInteger bedgeCount=0;
        [objects enumerateObjectsUsingBlock:^(AddFriendRequest *request, NSUInteger idx, BOOL * _Nonnull stop) {
            if(!request.isRead){
                bedgeCount++;
            }
        }];
        if(bedgeCount>0){
            self.addFriendBedgeCount=bedgeCount;
        }else{
            self.addFriendBedgeCount=0;
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionedContact numberOfSection]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 2;
    }else{
        return [self.sectionedContact numberOfRowsInSection:section-1];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            NewFriendsNotifyCell *notifyCell=[tableView dequeueReusableCellWithIdentifier:kNewFriendsNotifyCell];
            [notifyCell configWithBedgeCount:self.addFriendBedgeCount];
            return notifyCell;
        }else if(indexPath.row==1){
            return [tableView dequeueReusableCellWithIdentifier:kGroupChatCell];
        }
        return nil;
    }
    ContactCell *cell=[tableView dequeueReusableCellWithIdentifier:kContactCellID];
    User *u= [self.sectionedContact userForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
    [cell configWithUser:u];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){//新的朋友
            [self performSegueWithIdentifier:@"NewFriendsNotifySegue" sender:self];
        }else if(indexPath.row==1){//群组
            [self performSegueWithIdentifier:@"GroupChatListSegue" sender:self];
        }
    }else{
        User *u=[self.sectionedContact userForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
        PrivateChatController *chatVC= [PrivateChatController new];
        chatVC.chatToUserID=u.clientID;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 66;
    }else{
        return 88;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 44;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return nil;
    }else{
        return [self.sectionedContact titleForHeaderInSection:section-1];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        return nil;
    }else{
        ContactHeaderCell *header= [tableView dequeueReusableCellWithIdentifier:kContactHeaderCellID];
        header.titleLabel.text=[self tableView:tableView titleForHeaderInSection:section];
        return header.contentView;
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *titles= [self.sectionedContact sectionIndexTitles];
    NSMutableArray *mutableTitles= [titles mutableCopy];
    [mutableTitles insertObject:@"" atIndex:0];
    return mutableTitles;
}

#pragma mark - 用户信息更新
-(void)userUpdateNotification:(NSNotification*)noti{
    [self.tableView reloadData];
}

#pragma mark - 用户头像更新
-(void)avatarUpdateNotification:(NSNotification*)noti{
    [self.tableView reloadData];
}
@end
