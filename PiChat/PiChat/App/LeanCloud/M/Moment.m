//
//  Moment.m
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Moment.h"

@implementation Moment
@dynamic images,texts,postUser;

+(void)load{
    [Moment registerSubclass];
}

+(NSString *)parseClassName{
    return @"Moment";
}
@end
