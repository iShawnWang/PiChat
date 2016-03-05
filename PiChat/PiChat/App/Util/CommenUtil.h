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
#import "MBProgressHUD+Addition.h"

@interface CommenUtil : NSObject
+(NSString*) uuid;
/**
 *  同步,阻塞线程
 *
 *  @param file
 *
 *  @return 
 */
+(NSString*)saveFileToDocument:(NSURL*)file;

/**
 *  同步,阻塞线程
 *
 *  @param file
 *
 *  @return
 */
+(NSString*)saveFileToDocument:(NSURL *)file fileName:(NSString*)fileName;

+(NSString*)saveDataToDocument:(NSData *)data fileName:(NSString*)fileName;
@end

#pragma mark - NSString
@interface NSString (Util)
-(NSString*)trim;
@end
