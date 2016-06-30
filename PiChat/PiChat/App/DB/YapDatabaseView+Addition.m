//
//  YapDatabaseView+Addition.m
//  PiChat
//
//  Created by pi on 16/7/1.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "YapDatabaseView+Addition.h"
#import <AVObject.h>

@implementation YapDatabaseView (Addition)
+(NSString*)viewNameForModel:(Class)clazz{
    return [NSStringFromClass(clazz) stringByAppendingString:@"View"];
}
@end

@implementation YapDatabaseReadTransaction (Addition)

-(YapDatabaseViewTransaction *)viewTransactionForModel:(Class)clazz{
    return (YapDatabaseViewTransaction*)[self extension:[YapDatabaseView viewNameForModel:clazz]];
}

@end

@implementation YapDatabaseReadWriteTransaction (Addition)

-(void)setObjectAutomatic:(AVObject*)object{
    NSString *className= NSStringFromClass([object class]);
    NSString *collectionName=[className stringByAppendingString:@"collection"];
    [self setObject:object forKey:[object objectId] inCollection:collectionName];
}

@end