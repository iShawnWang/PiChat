//
//  Followee.h
//  PiChat
//
//  Created by pi on 16/3/6.
//  Copyright © 2016年 pi. All rights reserved.
//
//  AVCloud followeequery 返回的数组应该是 User 数组,但现在是 _Followee 对象数组,
//  官网查询无果,用此办法...

#import <Foundation/Foundation.h>

@interface Followee : NSObject
+(NSArray*)followeeArrayToUserArray:(NSArray*)followeeArray;
@end
