//
//  AddFriendRequest.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AddFriendRequest.h"

@implementation AddFriendRequest
@dynamic fromUser,toUser,isRead,status,verifyMessage;

+(instancetype)requestWithUserToAdd:(User*)userToAdd{
    return [self requestWithUserToAdd:userToAdd verifyMsg:@""];
}

+(instancetype)requestWithUserToAdd:(User*)userToAdd verifyMsg:(NSString*)verifyMsg{
    AddFriendRequest *reuqest=[AddFriendRequest object];
    reuqest.fromUser=[User currentUser];
    reuqest.toUser=userToAdd;
    reuqest.isRead=NO;
    reuqest.verifyMessage=verifyMsg;
    reuqest.status=AddFriendRequestStatusWait;
    return reuqest;
}
+(void)load{
    [AddFriendRequest registerSubclass];
}

+(NSString *)parseClassName{
    return @"AddFriendRequest";
}
@end
