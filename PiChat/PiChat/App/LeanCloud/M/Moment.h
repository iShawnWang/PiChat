//
//  Moment.h
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVStatus.h"
#import <AVOSCloud.h>

@class User;

static NSString *const kPostUser=@"postUser";
static NSString *const kPostImages=@"images";
static NSString *const kPostContent=@"texts";

@interface Moment : AVObject<AVSubclassing>
@property (strong,nonatomic) User *postUser;
@property (strong,nonatomic) NSArray *images;
@property (copy,nonatomic) NSString *texts;
@end
