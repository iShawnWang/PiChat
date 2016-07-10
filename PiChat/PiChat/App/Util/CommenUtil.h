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

/**
 *  异步获取某个文件夹及里面的所有文件的大小
 *
 *  @param size
 *  @param directoryURL
 *  @param error
 *
 *  @return
 */
+ (void)asynCalculateDirectorySizeWithPath:(NSString*)directoryPath completionBlock:(CalcDirectorySizeBlock)completionBlock;

#pragma mark - 视频缩略图
/**
 *  获取 Video 的某一帧作为缩略图
 *
 *  @param contentURL
 *
 *  @return
 */
+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL ;

#pragma mark -
/**
 *  绘制文字生成图片
 *
 *  @param text
 *  @param size
 *
 *  @return
 */
+(UIImage*)textToImage:(NSString*)text size:(CGSize)size;

#pragma mark - Alert
+(void)showSettingAlertIn:(UIViewController*)vc;

/**
 *  UIAlertController
 *
 *  @param message
 *  @param vc
 */
+(void)showMessage :(NSString*)message inVC:(UIViewController*)vc;
@end

#pragma mark - NSString
@interface NSString (Util)
-(BOOL)isEmptyString;
-(NSString*)trim;

/**
 *  移除 'file://' 前缀
 *
 *  @return
 */
-(NSString*)removeFilePrefix;
@end
