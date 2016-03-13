//
//  GlobalConstant.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#ifndef GlobalConstant_h
#define GlobalConstant_h


@class JSQMessage;
@class UIImage;
@class CLLocation;
@class User;
@class AVFile;
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


static NSString *const kUserUpdateNotification=@"kUserUpdateNotification";
static NSString *const kUpdatedUser=@"kUpdatedUser";

#pragma mark - 收到消息通知
static NSString *const kDidReceiveTypedMessageNotification =@"didReceiveTypedMessageNotification";
static NSString *const kTypedMessage =@"kTypedMessage";

#pragma mark - 上传媒体文件通知
static NSString *const kUploadMediaNotification=@"kUploadMediaNotification";

static NSString *const kUploadState=@"kUploadState";
typedef enum : NSUInteger {
    UploadStateComplete,
    UploadStateProgress,
    UploadStateFailed,
} UploadState;

static NSString *const kUploadedFile=@"kUploadedFile";
static NSString *const kUploadingProgress=@"kUploadingProgress";
static NSString *const kUploadingError=@"kUploadingError";

static NSString *const kUploadedMediaType=@"kUploadedMediaType";
typedef enum : NSUInteger {
    UploadedMediaTypePhoto,
    UploadedMediaTypeVideo,
    UploadedMediaTypeAduio,
    UploadedMediaTypeFile,
} UploadedMediaType;


#pragma mark - 图片缓存
static NSString *const kDownloadImageCompleteNotification=@"kDownloadImageCompleteNotification";
static NSString *const kDownloadedImage=@"kDownloadedImage";
static NSString *const kDownloadedImageUrl=@"kDownloadedImageUrl";

//给 JSQLocationCell 设置位置是异步的,它会先创建 MapView 然后截取 snapShot ,需要 用Notification刷新 Cell
static NSString *const kLocationCellNeedUpdateNotification=@"kLocationCellNeedUpdateNotification";

#pragma mark - 

#endif /* GlobalConstant_h */
