//
//  GlobalConstant.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#ifndef GlobalConstant_h
#define GlobalConstant_h
#import "EXTScope.h" //https://github.com/jspahrsummers/libextobjc 为了使用RAC 的 @strongify 和 @weakify


@class JSQMessage;
@class UIImage;
@class CLLocation;
@class User;
@class AVFile;
@class Moment;

typedef void(^JsqMsgBlock)(JSQMessage* msg);
typedef void (^VoidBlock)();
typedef void (^BooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^IntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^DictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^SetResultBlock)(NSSet *objs, NSError *error);
typedef void (^ImageResultBlock)(UIImage *image, NSError *error);
typedef void (^UrlResultBlock)(NSURL *url, NSError *error);
typedef void (^StringResultBlock)(NSString *string, NSError *error);
typedef void (^IdResultBlock)(id object, NSError *error);
typedef void (^LocationResultBlock)(CLLocation *location, NSError *error);
typedef void (^UserResultBlock)(User *user, NSError *error);
typedef void (^FileResultBlock)(AVFile * file, NSError *error);
typedef void (^MomentResultBlock)(Moment * moment, NSError *error);


#pragma mark - Leancloud
static NSString *const kUsernameKey=@"username";
static NSString *const kObjectIdKey=@"objectId";
static NSString *const kUpdatedAt=@"updatedAt";
static NSString *const kCreatedAt=@"createdAt";

#endif /* GlobalConstant_h */
