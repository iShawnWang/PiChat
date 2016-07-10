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
#import "FICUtilities.h"
#import "LogManager.h"

@class JSQMessage;
@class UIImage;
@class CLLocation;
@class User;
@class AVFile;
@class Moment;

#define kBundleID @"BigPi.PiChat"

typedef void(^JsqMsgBlock)(JSQMessage* msg);
typedef void (^VoidBlock)();
typedef void (^BooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^IntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^DataResultBlock)(NSData *data, NSError *error);
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^DictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^SetResultBlock)(NSSet *objs, NSError *error);
typedef void (^ImageResultBlock)(UIImage *image, NSError *error);
typedef void (^ImageAndUrlResultBlock)(UIImage *image,NSURL *url, NSError *error);
typedef void (^UrlResultBlock)(NSURL *url, NSError *error);
typedef void (^StringResultBlock)(NSString *string, NSError *error);
typedef void (^IdResultBlock)(id object, NSError *error);
typedef void (^LocationResultBlock)(CLLocation *location, NSError *error);
typedef void (^UserResultBlock)(User *user, NSError *error);
typedef void (^FileResultBlock)(AVFile * file, NSError *error);
typedef void (^MomentResultBlock)(Moment * moment, NSError *error);
typedef void (^CalcDirectorySizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

#pragma mark GCD 封装
#pragma mark - Get Queue
NS_INLINE dispatch_queue_t getGlobalQueueWithPriority(NSInteger priority){
    return dispatch_get_global_queue(priority, 0);
}

NS_INLINE dispatch_queue_t getGlobalQueue(){
    return getGlobalQueueWithPriority(DISPATCH_QUEUE_PRIORITY_DEFAULT);
}

NS_INLINE dispatch_queue_t getMainQueue(){
    return dispatch_get_main_queue();
}

#pragma mark - Dispatch Async
NS_INLINE void executeAsyncInGlobalQueue(void (^block)()){
    dispatch_async(getGlobalQueue(), block);
};

NS_INLINE void executeAsyncInMainQueue(void (^block)()){
    dispatch_async(getMainQueue(),block);
};

NS_INLINE void executeAsyncInMainQueueIfNeed(void (^block)()){
    if([NSThread isMainThread]){
        block();
    }else{
        executeAsyncInMainQueue(block);
    }
};

#pragma mark - Dispatch Delay
NS_INLINE dispatch_time_t delayTimeInSecond(NSTimeInterval second){
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

NS_INLINE void executeInMainQueueAfter(NSTimeInterval delayInSeconds, void (^block)()){
    dispatch_time_t delay=delayTimeInSecond(delayInSeconds);
    dispatch_queue_t queue=getMainQueue();
    dispatch_after(delay,queue,block);
};

NS_INLINE void executeInGlobalQueueAfter(NSTimeInterval delayInSeconds, void (^block)()){
    dispatch_time_t delay=delayTimeInSecond(delayInSeconds);
    dispatch_queue_t queue=getGlobalQueue();
    dispatch_after(delay,queue, block);
};

#pragma mark - Leancloud
static NSString *const kUsernameKey=@"username";
static NSString *const kObjectIdKey=@"objectId";
static NSString *const kUpdatedAt=@"updatedAt";
static NSString *const kCreatedAt=@"createdAt";

#pragma mark - 

NS_INLINE NSString * MD5HashFromString(NSString* str){
    CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(str);
    return FICStringWithUUIDBytes(UUIDBytes);
}

#endif /* GlobalConstant_h */
