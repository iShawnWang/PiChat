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
    return @"Moment";
}

-(NSUInteger)hash{
    return self.postUser.objectId.hash ^ self.favourUsers.hash ^ self.comments.hash ^ self.comments.hash ^ self.images.hash ^ self.texts.hash;
}

#pragma mark - Public

-(void)addOrRemoveFavourUser:(User *)u{
    NSMutableArray *newFavourUsers=[NSMutableArray arrayWithArray:self.favourUsers];
    if([newFavourUsers containsObject:u]){
        [newFavourUsers removeObject:u];
    }else{
        [newFavourUsers addObject:u];
    }
    self.favourUsers=[newFavourUsers copy];
}

-(void)addNewComment:(Comment*)comment{
    NSMutableArray *comments=[NSMutableArray arrayWithArray:self.comments];
    [comments addObject:comment];
    self.comments=[comments copy];
}

-(void)saveInBackgroundThenFetch:(MomentResultBlock)callback{
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            callback(nil,error);
            return ;
        }
        AVQuery *momentQuery= [AVQuery queryWithClassName:NSStringFromClass([Moment class])];
        [momentQuery whereKey:kObjectIdKey equalTo:self.objectId];
        [momentQuery includeKey:kPostImages];
        [momentQuery includeKey:kFavourUsers];
        [momentQuery includeKey:kComments];
        [momentQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            Moment *m=object ? (Moment*)object : nil;
            callback(m,error);
        }];
    }];
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *objDict= [self dictionaryForObject];
    NSMutableArray *favourUsersEncodedArray=[NSMutableArray arrayWithCapacity:self.favourUsers.count ];
    NSMutableArray *commentsEncodedArray=[NSMutableArray arrayWithCapacity:self.comments.count ];
    //Leancloud 真残疾...
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

@end
