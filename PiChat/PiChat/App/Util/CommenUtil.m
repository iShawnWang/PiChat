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
        NSString *cacheDir=[CommenUtil defaultCacheDirectoryStr];
        NSDirectoryEnumerator *enumerator= [[NSFileManager defaultManager]enumeratorAtPath:cacheDir];
        for (NSString *filepath in enumerator) {
            NSError *error;
            [[NSFileManager defaultManager]removeItemAtPath:[cacheDir stringByAppendingPathComponent:filepath] error:&error];
            if(error){
                DDLogError(@"%@",error);
            }
        }
        executeAsyncInMainQueueIfNeed(^{
            if(callback){
                callback();
            }
        });
    });
}

+ (void)asynCalculateDirectorySizeWithPath:(NSString*)directoryPath completionBlock:(CalcDirectorySizeBlock)completionBlock {
    executeAsyncInGlobalQueue(^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:directoryPath isDirectory:YES];
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        NSFileManager *fileManager= [NSFileManager defaultManager];
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:@[NSFileSize]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        if (completionBlock) {
            executeAsyncInMainQueueIfNeed(^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
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