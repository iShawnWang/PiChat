//
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (Size)

- (CGSize)sizeWithWidth:(float)width andFont:(UIFont *)font;

- (CGSize)sizeWithHeight:(float)height andFont:(UIFont *)font;

@end
