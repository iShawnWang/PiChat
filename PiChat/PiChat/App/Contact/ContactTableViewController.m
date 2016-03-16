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


@interface ContactTableViewController ()
@property (strong,nonatomic) NSMutableDictionary *sectionedContacts;
@end

@implementation ContactTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"联系人";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_discover"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_discoverHL"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarUpdateNotification:) name:kDownloadImageCompleteNotification object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter
-(NSMutableDictionary *)sectionedContacts{
    if(!_sectionedContacts){
        _sectionedContacts=[NSMutableDictionary dictionary];
    }
    return _sectionedContacts;
}


#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserManager sharedUserManager] fetchFriendsWithCallback:^(NSArray *objects, NSError *error) {
        [self.sectionedContacts removeAllObjects];
        [objects enumerateObjectsUsingBlock:^(User *u, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addUserToSectionedContacts:u];
        }];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionedContacts.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *contacts=self.sectionedContacts.allValues[section];
    return contacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    NSArray *contacts= self.sectionedContacts.allValues[indexPath.section];
    User *u=contacts[indexPath.row];
    cell.textLabel.text=u.displayName;
    cell.imageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *contacts= self.sectionedContacts.allValues[indexPath.section];
    User *u=contacts[indexPath.row];
    PrivateChatController *chatVC= [PrivateChatController new];
    chatVC.chatToUserID=u.clientID;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionedContacts.allKeys[section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionedContacts.allKeys;
}

#pragma mark - Private
/**
 *  模仿 iPhone 联系人界面,按用户首字母分Section
 *
 *  @param user 
 */
-(void)addUserToSectionedContacts:(User*)user{
    __block BOOL firstLetterExistInSectionedContacts=NO;
    NSString *userFirstLetter= [user.displayName substringToIndex:1];
    [self.sectionedContacts enumerateKeysAndObjectsUsingBlock:^(NSString *firstLetter, NSMutableArray *contacts, BOOL * _Nonnull stop) {
        if([userFirstLetter isEqualToString:firstLetter]){
            [contacts addObject:user];
            *stop=YES;
            firstLetterExistInSectionedContacts=YES;
        }
    }];
    
    if(!firstLetterExistInSectionedContacts){
        NSMutableArray *contacts=[NSMutableArray arrayWithObject:user];
        [self.sectionedContacts setObject:contacts forKey:userFirstLetter];
    }
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
