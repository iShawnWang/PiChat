//
//  NSObject+MethodSwizzling.h
//
//  Created by pi on 16/5/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzling)
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error;
+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error;
@end
