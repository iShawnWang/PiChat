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

#pragma mark - 同步,阻塞线程

+(NSString*)saveDataToDocument:(NSData *)data fileName:(NSString*)fileName;

+(NSString*)saveFileToCache:(NSURL *)file fileName:(NSString*)fileName;

+(NSString*)saveFileToCache:(NSURL*)file;

+(NSString*)saveFileToDocument:(NSURL *)file fileName:(NSString*)fileName;

+(NSString*)saveFileToDocument:(NSURL*)file;

+(NSString*)saveDataToCache:(NSData *)data fileName:(NSString*)fileName;

+(NSString*)saveData:(NSData*)data toDirectory:(NSString*)directory fileName:(NSString*)fileName;
#pragma mark -

+(UIImage*)textToImage:(NSString*)text size:(CGSize)size;
#pragma mark - 
+(void)showSettingAlertIn:(UIViewController*)vc;
@end

#pragma mark - NSString
@interface NSString (Util)
-(NSString*)trim;
@end
