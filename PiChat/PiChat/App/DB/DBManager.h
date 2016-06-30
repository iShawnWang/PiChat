//
//  DBManager.h
//  PiChat
//
//  Created by pi on 16/6/25.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YapDatabase.h>
#import "YapDatabaseView+Addition.h"
@class YapDatabaseView;
@class YapDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
@property (strong,nonatomic)  YapDatabase *db;

+(instancetype)sharedDBManager;
+(void)registerView:(nonnull YapDatabaseView*)view withName:(nonnull NSString*)name;
@end

NS_ASSUME_NONNULL_END