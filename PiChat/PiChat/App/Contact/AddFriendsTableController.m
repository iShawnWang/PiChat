//
//  AddFriendsTableController.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AddFriendsTableController.h"
#import "UserManager.h"
#import "CommenUtil.h"

@interface AddFriendsTableController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *friends;
@end

@implementation AddFriendsTableController


#pragma mark - Getter Setter

#pragma mark - Private
-(void)searchFriends:(NSString *)name{
    [UserManager findUsersByPartname:[name trim] withBlock:^(NSArray *objects, NSError *error) {
        self.friends=objects;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *friendCell=[tableView dequeueReusableCellWithIdentifier:@"addFriendCell"];
    User *u=self.friends[indexPath.row];
    friendCell.textLabel.text=u.username;
    return friendCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *u=self.friends[indexPath.row];
    [UserManager addFriend:u callback:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD showMsg:@"添加好友成功" forSeconds:1.5];
    }];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchFriends:self.searchBar.text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchFriends:self.searchBar.text];
}

@end
