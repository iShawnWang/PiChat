//
//  RegexUtil.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "RegexUtil.h"

#define EmailRegex @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
@implementation RegexUtil
+(BOOL)isEmail:(NSString*)str{
    NSRange range= [str rangeOfString:EmailRegex options:NSRegularExpressionSearch];
    return range.location==NSNotFound;
}
@end
