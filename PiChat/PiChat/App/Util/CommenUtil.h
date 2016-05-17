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
#import "UIColor+Addition.h"
#import "UIView+PiAdditions.h"
#import "GlobalConstant.h"

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

+(NSString*)documentDirectoryStr;

+(NSString*)defaultCacheDirectoryStr;

+(NSString*)cacheDirectoryStr;

+(NSString*)randomFileName;

+(void)clearCacheDirectoryWithCallback:(VoidBlock)callback;

+ (BOOL)getAllocatedSize:(unsigned long long *)size ofDirectoryAtURL:(NSURL *)directoryURL error:(NSError * __autoreleasing *)error;

#pragma mark - 视频缩略图
+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL ;

#pragma mark -
+(UIImage*)textToImage:(NSString*)text size:(CGSize)size;

#pragma mark - Alert
+(void)showSettingAlertIn:(UIViewController*)vc;
+(void)showMessage :(NSString*)message inVC:(UIViewController*)vc;
@end

#pragma mark - NSString
@interface NSString (Util)
-(BOOL)isEmptyString;
-(NSString*)trim;
-(NSString*)removeFilePrefix;
@end
