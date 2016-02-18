//
//  GlobalConstant.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#ifndef GlobalConstant_h
#define GlobalConstant_h

typedef void (^BooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^IntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^DictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^SetResultBlock)(NSSet *objs, NSError *error);
typedef void (^ImageResultBlock)(UIImage * image, NSError *error);
typedef void (^StringResultBlock)(NSString *string, NSError *error);
typedef void (^IdResultBlock)(id object, NSError *error);

#endif /* GlobalConstant_h */
