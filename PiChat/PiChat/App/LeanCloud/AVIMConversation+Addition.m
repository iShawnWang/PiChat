//
//  AVIMConversation+Addition.m
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMConversation+Addition.h"
#import "User.h"

@implementation AVIMConversation (Addition)
-(NSString*)chatToUserId{
    __block NSString *chatToUserId;
    [self.members enumerateObjectsUsingBlock:^(NSString *clientID, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *currentUserID=[User currentUser].clientID;
        if(![clientID isEqualToString:currentUserID]){
            *stop=YES;
            chatToUserId=clientID;
        }
    }];
    return chatToUserId;
}
@end
