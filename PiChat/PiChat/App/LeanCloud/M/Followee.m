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
/**
 *  SDK Bug 偶尔返回的不是 User 对象,而是 _Followee 对象 ,需要这个方法保证返回值正确
 *
 *  @param followeeArray
 *
 *  @return
 */
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
