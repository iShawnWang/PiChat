//
//  Followee.m
//  PiChat
//
//  Created by pi on 16/3/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Followee.h"
#import <AVOSCloud.h>
#import <AVOSCloudIM.h>
#import "User.h"

@implementation Followee
+(NSMutableArray *)followeeArrayToUserArray:(NSArray *)followeeArray{
    NSMutableArray *array=[NSMutableArray array];
    for (AVObject *followee in followeeArray) {
        User *u;
        if([followee isKindOfClass:[AVUser class]]){
            u=(User*)followee;
        }else{
            NSDictionary *dict= [followee valueForKey:@"localData"];
            u=dict[@"followee"];
        }
        
        [array addObject:u];
    }
    return array;
}
@end
