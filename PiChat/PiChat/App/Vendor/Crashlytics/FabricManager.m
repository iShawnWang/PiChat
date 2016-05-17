//
//  FabricManager.m
//  PiChat
//
//  Created by pi on 16/5/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "FabricManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "User.h"
#import "CommenUtil.h"
#import "UserManager.h"


@implementation FabricManager
+(void)setup{
    [Fabric with:@[[Crashlytics class]]];
}

+(void)setUserInfo{
    User *user=[User currentUser];
    [CrashlyticsKit setUserIdentifier:user.objectId];
    if([user.displayName isEmptyString]){
        [[UserManager sharedUserManager]findUserByObjectID:user.objectId callback:^(User *user, NSError *error) {
            [CrashlyticsKit setUserName:user.displayName];
            [CrashlyticsKit setUserEmail:user.email];
        }];
    }else{
        [CrashlyticsKit setUserName:user.displayName];
        [CrashlyticsKit setUserEmail:user.email];
    }
}
@end
