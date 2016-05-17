//
//  NewFriendsNotifyTableController.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NewFriendsNotifyTableController.h"
#import "UserManager.h"
#import "AddFriendRequestCell.h"

@interface NewFriendsNotifyTableController ()
@property (strong,nonatomic) NSMutableArray *newFriendsNotifies;
@end
@implementation NewFriendsNotifyTableController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight=76;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserManager sharedUserManager]findAddFriendRequestAboutUser:[User currentUser] callback:^(NSArray *objects, NSError *error) {
        [self.newFriendsNotifies removeAllObjects];
        [objects enumerateObjectsUsingBlock:^(AddFriendRequest *request, NSUInteger idx, BOOL * _Nonnull stop) {
            request.isRead=YES;
        }];
        [AddFriendRequest saveAllInBackground:objects];
        [self.newFriendsNotifies addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

-(NSMutableArray *)newFriendsNotifies{
    if(!_newFriendsNotifies){
        _newFriendsNotifies=[NSMutableArray array];
    }
    return _newFriendsNotifies;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newFriendsNotifies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFriendRequestCell *requestCell= [tableView dequeueReusableCellWithIdentifier:kAddFriendRequestCell];
    AddFriendRequest *request= self.newFriendsNotifies[indexPath.row];
    [requestCell configWithAddRequest:request];
    return requestCell;
}

@end
