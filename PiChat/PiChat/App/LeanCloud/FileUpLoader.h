//
//  FileUpLoader.h
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"

@interface FileUpLoader : NSObject
+(instancetype)sharedFileUpLoader;
-(void)uploadVideoAtUrl:(NSURL*)url;
-(void)uploadImage:(UIImage*)img;
@end
