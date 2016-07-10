//
//  JSQMessage+FICEntity.h
//  PiChat
//
//  Created by pi on 16/7/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "FICEntity.h"
#import <JSQMessage.h>

FOUNDATION_EXPORT NSString *const kJSQMessageFamily;
FOUNDATION_EXPORT NSString *const kJSQMessagePhotoItemFormatName;

FOUNDATION_EXPORT const CGSize kJSQMessagePhotoItemImageSizePhone;
FOUNDATION_EXPORT const CGSize kJSQMessagePhotoItemImageSizePad;

@interface JSQMessage (FICEntity)<FICEntity>

@end
