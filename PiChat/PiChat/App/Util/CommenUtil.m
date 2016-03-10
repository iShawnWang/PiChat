//
//  CommenUtil.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CommenUtil.h"

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

//
+(NSString*)saveDataToCache:(NSData *)data fileName:(NSString*)fileName{
    return [self saveData:data toDirectory:NSTemporaryDirectory() fileName:fileName];
}

+(NSString*)saveDataToDocument:(NSData *)data fileName:(NSString*)fileName{
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
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

#pragma mark - 
+(void)showSettingAlertIn:(UIViewController*)vc{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"不能定位了" message:@"请在设置中允许获取位置 :) ~" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"转到设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end

#pragma mark - NSString
@implementation NSString (Util)
-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end