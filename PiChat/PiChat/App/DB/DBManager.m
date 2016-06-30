//
//  DBManager.m
//  PiChat
//
//  Created by pi on 16/6/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "DBManager.h"
#import "CommenUtil.h"

@interface DBManager ()

@end

@implementation DBManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbPath=[[CommenUtil documentDirectoryStr]stringByAppendingPathComponent:@"YapDB.db"];
        self.db=[[YapDatabase alloc]initWithPath:dbPath];
    }
    return self;
}

+(instancetype)sharedDBManager{
    static id _DBmanager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DBmanager=[DBManager new];
    });
    return _DBmanager;
}

+(void)registerView:(YapDatabaseView*)view withName:(NSString*)name{
    [[DBManager sharedDBManager].db registerExtension:view withName:name];
}
@end
