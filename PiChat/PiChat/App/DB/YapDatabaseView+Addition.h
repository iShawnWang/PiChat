//
//  YapDatabaseView+Addition.h
//  PiChat
//
//  Created by pi on 16/7/1.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <YapDatabase/YapDatabase.h>
#import <YapDatabaseView.h>
#import "DBManager.h"
@class AVObject;

@interface YapDatabaseView (Addition)
+(NSString*)viewNameForModel:(Class)clazz;
@end


@interface YapDatabaseReadTransaction (Addition)
-(YapDatabaseViewTransaction*)viewTransactionForModel:(Class)clazz;
@end


@interface YapDatabaseReadWriteTransaction (Addition)
-(void)setObjectAutomatic:(AVObject*)object;
@end