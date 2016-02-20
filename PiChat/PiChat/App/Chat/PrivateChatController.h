//
//  PrivateChatController.h
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@class User;
@interface PrivateChatController : JSQMessagesViewController
@property (strong,nonatomic) User *chatToUser;
@end
