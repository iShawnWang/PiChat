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
static char const * const kUnReadCountKey = "kUnReadCountKey";
@implementation AVIMConversation (Addition)


-(AVIMTypedMessage *)lastMessage{
    return objc_getAssociatedObject(self, kLastMessageKey);
}

-(void)setLastMessage:(AVIMTypedMessage *)lastMessage{
    objc_setAssociatedObject(self, kLastMessageKey, lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger)unReadCount{
    NSNumber *count=objc_getAssociatedObject(self, kUnReadCountKey);
    return count ? [count integerValue] : 0;
}

-(void)setUnReadCount:(NSInteger)unReadCount{
    objc_setAssociatedObject(self, kUnReadCountKey, @(unReadCount), OBJC_ASSOCIATION_ASSIGN);
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
