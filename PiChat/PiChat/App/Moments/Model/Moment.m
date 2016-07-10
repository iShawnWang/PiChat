//
//  Moment.m
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Moment.h"
#import "User.h"
#import "YapDatabaseView+Addition.h"

NSString *const kPostUser=@"postUser";
NSString *const kPostImages=@"images";
NSString *const kPostContent=@"texts";
NSString *const kFavourUsers=@"favourUsers";
NSString *const kComments=@"comments";

NSString *const kMomentCodingKey = @"kMomentCodingKey";

@implementation Moment
@dynamic images,texts,postUser,favourUsers,comments;

#pragma mark - ModelSizeCacheProtocol
-(NSString *)modelID{
    return self.objectId;
}

#pragma mark - DB
+(void)initialize{
    [self setupViews];
}

+(void)setupViews{
    YapDatabaseViewGrouping *grouping= [YapDatabaseViewGrouping withObjectBlock:^NSString * _Nullable(YapDatabaseReadTransaction * _Nonnull transaction, NSString * _Nonnull collection, NSString * _Nonnull key, id  _Nonnull object) {
        if([object isKindOfClass:[Moment class]]){
            return NSStringFromClass([Moment class]);
        }
        return nil;
    }];
    
    YapDatabaseViewSorting *sorting=[YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction * _Nonnull transaction, NSString * _Nonnull group, NSString * _Nonnull collection1, NSString * _Nonnull key1, Moment *object1, NSString * _Nonnull collection2, NSString * _Nonnull key2, Moment *object2) {
        return [object2.createdAt compare: object1.createdAt];
    }];
    
    YapDatabaseView *view=[[YapDatabaseView alloc]initWithGrouping:grouping sorting:sorting];
    [DBManager registerView:view withName:[YapDatabaseView viewNameForModel:[Moment class]]];
}

#pragma mark - AVObject Init

+(void)load{
    [Moment registerSubclass];
}

+(NSString *)parseClassName{
    return NSStringFromClass([self class]);
}

#pragma mark - Public

-(void)addOrRemoveFavourUser:(User *)u{
    
    if([self.favourUsers containsObject:u]){
        [self removeObject:u forKey:kFavourUsers];
    }else{
        [self addUniqueObject:u forKey:kFavourUsers];
    }
}

-(void)addNewComment:(Comment*)comment{
    [self addUniqueObject:comment forKey:kComments];
}

-(void)saveOrUpdateInBackground:(BooleanResultBlock)callback{
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!succeeded){
            callback(NO,error);
            return ;
        }
        [[[DBManager sharedDBManager].db newConnection]asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
            [transaction setObjectAutomatic:self];
        } completionBlock:^{
            callback(YES,nil);
        }];
    }];
}

+(instancetype)momentFromDBWithConnection:(YapDatabaseConnection*)connection indexPath:(NSIndexPath*)indexPath mapping:(YapDatabaseViewMappings*)mapping{
    __block Moment *m;
    [connection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        YapDatabaseViewTransaction *viewTransaction= [transaction viewTransactionForModel:[Moment class]];
        m=[viewTransaction objectAtIndexPath:indexPath withMappings:mapping];
    }];
    return m;
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *objDict= [self dictionaryForObject];
    NSMutableArray *favourUsersEncodedArray=[NSMutableArray arrayWithCapacity:self.favourUsers.count ];
    NSMutableArray *commentsEncodedArray=[NSMutableArray arrayWithCapacity:self.comments.count ];
    //FIXME Leancloud 真残疾...
    [self.favourUsers enumerateObjectsUsingBlock:^(AVObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [favourUsersEncodedArray addObject: [obj dictionaryForObject]];
    }];
    [self.comments enumerateObjectsUsingBlock:^(AVObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [commentsEncodedArray addObject:[obj dictionaryForObject]];
    }];
    NSMutableDictionary *correctedDict=[NSMutableDictionary dictionaryWithDictionary:objDict];
    correctedDict[@"favourUsers"]=favourUsersEncodedArray;
    correctedDict[@"comments"]=commentsEncodedArray;
    [aCoder encodeObject:correctedDict forKey:kMomentCodingKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    NSDictionary *objDict= [coder decodeObjectForKey:kMomentCodingKey];
    return (Moment*)[AVObject objectWithDictionary:objDict];
}

#pragma mark - FICEntity
//-(NSURL *)sourceImageURLWithFormatName:(NSString *)formatName{
//    //只能返回一张图片的 URl,
//    //但我这个朋友圈模型类,有最多9张图片,没整...
//    //官方 issues 建议一个 Entity 对应一张图片,
//    //我想到的办法是
//    //0.创建 MomentPhoto Entity 在放到朋友圈模型类中...  ,Github issues 里也是这个结论.
//    //1.换一个第三方库
//    //2.改 FIC 的源码让他支持返回多个 Image, 或者 Image 数组....目前修改的代码,然后给原仓库提交的 issue 和 PR
//    //https://github.com/path/FastImageCache/issues/16
//}
//
//-(FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName{
//    
//}
@end
