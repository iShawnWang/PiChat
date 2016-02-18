//
//  CommenUtil.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexUtil.h"
#import "StoryBoardHelper.h"

@interface CommenUtil : NSObject
+(NSString*) uuid;
@end

#pragma mark - NSString
@interface NSString (Util)
-(NSString*)trim;
@end
