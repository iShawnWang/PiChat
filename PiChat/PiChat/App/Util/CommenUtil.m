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

+(NSString*)saveDataToDocument:(NSData *)data fileName:(NSString*)fileName{
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path=[documentPath stringByAppendingPathComponent:fileName];
    [data writeToFile:path atomically:YES];
    return path;
}

+(NSString*)saveFileToDocument:(NSURL *)file fileName:(NSString*)fileName{
    NSData *data= [NSData dataWithContentsOfURL:file];
    return [self saveDataToDocument:data fileName:fileName];
}

+(NSString*)saveFileToDocument:(NSURL*)file{
    return [self saveFileToDocument:file fileName:[file lastPathComponent]];
}
@end



#pragma mark - NSString
@implementation NSString (Util)
-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end