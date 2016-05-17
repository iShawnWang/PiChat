//
//  AddFriendsTableController.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AddFriendsTableController.h"
#import "CommenUtil.h"
#import "AddFriendCell.h"
#import "NSNotification+DownloadImage.h"
#import "UserManager.h"

@interface AddFriendsTableController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *friends;
@end

@implementation AddFriendsTableController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadImageCompleteNotification:) name:kDownloadImageCompleteNotification object:nil];
    }
    return self;
}

#pragma mark - Getter Setter

#pragma mark - LifeCycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.rowHeight=88;
}

#pragma mark - Private
-(void)searchFriends:(NSString *)name{
    [MBProgressHUD showInView:self.view];
    [[UserManager sharedUserManager] findUsersByPartname:[name trim] withBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hide];
        self.friends=objects;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFriendCell *friendCell=[tableView dequeueReusableCellWithIdentifier:@"addFriendCell"];
    User *u=self.friends[indexPath.row];
    [friendCell configWithUser:u];
    return friendCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *u=self.friends[indexPath.row];
    //判断是否已经是我的朋友了
    [[UserManager sharedUserManager] isMyFriend:u callback:^(BOOL isMyFriend, NSError *error) {
        if(isMyFriend){
            [MBProgressHUD showMsg:@"已经是好友了 ~" forSeconds:1.5];
        }else{
            //不是就发送好友请求
            [[UserManager sharedUserManager] postAddFriendRequestTo:u verifyMessage:@"" callBack:^(BOOL succeeded, NSError *error) {
                [MBProgressHUD showMsg:@"发送好友请求成功" forSeconds:1.5];
            }];
        }
    }];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchFriends:self.searchBar.text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchFriends:self.searchBar.text];
}

#pragma mark - Notification
-(void)downloadImageCompleteNotification:(NSNotification*)noti{
    [self.tableView reloadData];
}
@end
