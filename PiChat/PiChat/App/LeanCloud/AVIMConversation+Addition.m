//
//  AVIMConversation+Addition.m
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMConversation+Addition.h"
#import "User.h"
#import <objc/runtime.h>

static char const * const kLastMessageKey = "kLastMessageKey";
@implementation AVIMConversation (Addition)


-(AVIMTypedMessage *)lastMessage{
    return objc_getAssociatedObject(self, kLastMessageKey);
}

-(void)setLastMessage:(AVIMTypedMessage *)lastMessage{
    objc_setAssociatedObject(self, kLastMessageKey, lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
