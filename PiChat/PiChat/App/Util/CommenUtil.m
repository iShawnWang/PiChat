//
//  CommenUtil.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CommenUtil.h"
#import "GlobalConstant.h"
@import AVFoundation;

@implementation CommenUtil
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - Save File

+(NSString*)saveFileToCache:(NSURL *)file fileName:(NSString*)fileName{
    NSData *data=[NSData dataWithContentsOfURL:file];
    return [self saveDataToCache:data fileName:fileName];
}

+(NSString*)saveFileToCache:(NSURL*)file{
    return [self saveFileToCache:file fileName:[file lastPathComponent]];
}

+(NSString*)saveFileToDocument:(NSURL *)file fileName:(NSString*)fileName{
    NSData *data= [NSData dataWithContentsOfURL:file];
    return [self saveDataToDocument:data fileName:fileName];
}

+(NSString*)saveFileToDocument:(NSURL*)file{
    return [self saveFileToDocument:file fileName:[file lastPathComponent]];
}

+(NSString*)saveDataToCache:(NSData *)data fileName:(NSString*)fileName{
    NSString *cachePath= [CommenUtil cacheDirectoryStr];
    return [self saveData:data toDirectory:cachePath fileName:fileName];
}

+(NSString*)saveDataToDocument:(NSData *)data fileName:(NSString*)fileName{
    NSString *documentPath= [CommenUtil documentDirectoryStr];
    return [self saveData:data toDirectory:documentPath fileName:fileName];
}

//designated method
+(NSString*)saveData:(NSData*)data toDirectory:(NSString*)directory fileName:(NSString*)fileName{
    NSString *filePath= [directory stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

+(UIImage*)textToImage:(NSString*)text size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:nil];
    UIImage *img= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(NSString*)documentDirectoryStr{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
}

+(NSString*)defaultCacheDirectoryStr{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

/**
 *  默认的 cache 文件夹
 *
 *  @return
 */
+(NSString*)cacheDirectoryStr{
    NSString *cacheDir= [self defaultCacheDirectoryStr];
    NSString *bundleID=[NSBundle mainBundle].bundleIdentifier;
    bundleID=[bundleID stringByAppendingString:@".TmpFiles"]; //在沙盒下创建\Library\Caches\BigPi.PiChat.TmpFiles 文件夹
    cacheDir=[cacheDir stringByAppendingPathComponent:bundleID];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:cacheDir isDirectory:NULL]){
        NSError *error;
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return cacheDir;
}

/**
 *  唯一的 string 类似 uuid,适合作为缓存的文件名
 *
 *  @return
 */
+(NSString*)randomFileName{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

+(void)clearCacheDirectoryWithCallback:(VoidBlock)callback{
    executeAsyncInGlobalQueue(^{
        NSError *error;
        NSFileManager *manager=[NSFileManager defaultManager];
        NSArray *contents= [manager contentsOfDirectoryAtPath:[CommenUtil cacheDirectoryStr] error:&error];
        
        [contents enumerateObjectsUsingBlock:^(NSString *contentPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            [manager removeItemAtPath:contentPath error:&error];
        }];
        executeAsyncInMainQueueIfNeed(^{
            if(callback){
                callback();
            }
        });
    });
    
}

/**
 *  搬运自 StackOverflow 和 Github
 *
 *  @param size
 *  @param directoryURL
 *  @param error
 *
 *  @return 
 */
+ (BOOL)getAllocatedSize:(unsigned long long *)size ofDirectoryAtURL:(NSURL *)directoryURL error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(size != NULL);
    NSParameterAssert(directoryURL != nil);
    
    // We'll sum up content size here:
    unsigned long long accumulatedSize = 0;
    
    // prefetching some properties during traversal will speed up things a bit.
    NSArray *prefetchedProperties = @[
                                      NSURLIsRegularFileKey,
                                      NSURLFileAllocatedSizeKey,
                                      NSURLTotalFileAllocatedSizeKey,
                                      ];
    
    // The error handler simply signals errors to outside code.
    __block BOOL errorDidOccur = NO;
    BOOL (^errorHandler)(NSURL *, NSError *) = ^(NSURL *url, NSError *localError) {
        if (error != NULL)
            *error = localError;
        errorDidOccur = YES;
        return NO;
    };
    
    // We have to enumerate all directory contents, including subdirectories.
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL
                                                             includingPropertiesForKeys:prefetchedProperties
                                                                                options:(NSDirectoryEnumerationOptions)0
                                                                           errorHandler:errorHandler];
    
    // Start the traversal:
    for (NSURL *contentItemURL in enumerator) {
        
        // Bail out on errors from the errorHandler.
        if (errorDidOccur)
            return NO;
        
        // Get the type of this item, making sure we only sum up sizes of regular files.
        NSNumber *isRegularFile;
        if (! [contentItemURL getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:error])
            return NO;
        if (! [isRegularFile boolValue])
            continue; // Ignore anything except regular files.
        
        // To get the file's size we first try the most comprehensive value in terms of what the file may use on disk.
        // This includes metadata, compression (on file system level) and block size.
        NSNumber *fileSize;
        if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:error])
            return NO;
        
        // In case the value is unavailable we use the fallback value (excluding meta data and compression)
        // This value should always be available.
        if (fileSize == nil) {
            if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:error])
                return NO;
            
            NSAssert(fileSize != nil, @"huh? NSURLFileAllocatedSizeKey should always return a value");
        }
        
        // We're good, add up the value.
        accumulatedSize += [fileSize unsignedLongLongValue];
    }
    
//    // Bail out on errors from the errorHandler.
//    if (errorDidOccur)
//        return NO;
    
    // We finally got it.
    *size = accumulatedSize;
    return YES;
}

#pragma mark - 视频缩略图
+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL {
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(5,60);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    
    return theImage;
}


#pragma mark - 
+(void)showSettingAlertIn:(UIViewController*)vc{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"不能定位了" message:@"请在设置中允许获取位置 :) ~" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"转到设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}

+(void)showMessage :(NSString*)message inVC:(UIViewController*)vc{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"出错了 ~" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了 ~" style:UIAlertActionStyleCancel handler:nil]];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end

#pragma mark - NSString
@implementation NSString (Util)

-(BOOL)isEmptyString{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self trim].length==0) {
        return YES;
    }
    if ([self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)removeLineBreak{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

-(NSString *)removeFilePrefix{
    if([self hasPrefix:@"file://"]){
        NSRange rangeToRemove= [self rangeOfString:@"file://"];
        return [self stringByReplacingCharactersInRange:rangeToRemove withString:@""];
    }
    return self;
}
@end