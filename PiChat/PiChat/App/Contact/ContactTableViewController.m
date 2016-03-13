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

@interface ContactTableViewController ()
@property (strong,nonatomic) NSArray *contacts;
@end

@implementation ContactTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"联系人";
        self.tabBarItem.image=[UIImage imageNamed:@"menu"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserManager sharedUserManager] fetchFriendsWithCallback:^(NSArray *objects, NSError *error) {
        self.contacts=objects;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    User *u=self.contacts[indexPath.row];
    cell.textLabel.text=u.displayName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *u=self.contacts[indexPath.row];
    PrivateChatController *chatVC= [PrivateChatController new];
    chatVC.chatToUserID=u.clientID;
    [self.navigationController pushViewController:chatVC animated:YES];
}
@end
