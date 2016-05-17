//
//  AddFriendRequestCell.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AddFriendRequestCell.h"
#import "AddFriendRequest.h"
#import "ImageCache.h"
#import "User.h"
#import "UserManager.h"
#import "MBProgressHUD+Addition.h"

@interface AddFriendRequestCell ()
@property (strong,nonatomic) AddFriendRequest *request;
@end

@implementation AddFriendRequestCell

-(void)prepareForReuse{
    [super prepareForReuse];
    self.verifyMsgLabel.text=@"";
    self.displayNameLabel.text=@"";
    self.statusMessageLabel.text=@"";
    self.statusMessageLabel.hidden=YES;
    self.denyBtn.hidden=NO;
    self.acceptBtn.hidden=NO;
}

-(void)configWithAddRequest:(AddFriendRequest*)request{
    self.request=request;
    User *fromUser= request.fromUser;
    if(fromUser.displayName && fromUser.avatarPath){
        [self configWithFromUser:fromUser];
    }else{
        self.avatarImageView.image=nil;
        self.displayNameLabel.text=@"";
        [[UserManager sharedUserManager]findUserFromNetworkByObjectID:fromUser.objectId callback:^(User *user, NSError *error) {
            [self configWithFromUser:user];
        }];
    }
    
    self.verifyMsgLabel.text=request.verifyMessage;
    switch (request.status) {
        case AddFriendRequestStatusWait:
            self.statusMessageLabel.text=@"";
            self.statusMessageLabel.hidden=YES;
            self.denyBtn.hidden=NO;
            self.acceptBtn.hidden=NO;
            break;
        case AddFriendRequestStatusAccept:
            self.statusMessageLabel.text=@"已通过";
            self.statusMessageLabel.hidden=NO;
            self.denyBtn.hidden=YES;
            self.acceptBtn.hidden=YES;
            break;
        case AddFriendRequestStatusDeny:
            self.statusMessageLabel.text=@"已拒绝";
            self.statusMessageLabel.hidden=NO;
            self.denyBtn.hidden=YES;
            self.acceptBtn.hidden=YES;
            break;
    }
}

-(void)configWithFromUser:(User*)fromUser{
    self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:fromUser.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
    self.displayNameLabel.text=fromUser.displayName;
}

- (IBAction)acceptAddFriend:(id)sender {
    self.request.status=AddFriendRequestStatusAccept;
    [self.request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[UserManager sharedUserManager]addFriend:self.request.fromUser callback:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD showMsg:@"添加好友成功" forSeconds:1.5];
            [self configWithAddRequest:self.request];
        }];
    }];
}

- (IBAction)denyAddFriend:(id)sender {
    self.request.status=AddFriendRequestStatusAccept;
    [self.request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self configWithAddRequest:self.request];
    }];
}

@end
