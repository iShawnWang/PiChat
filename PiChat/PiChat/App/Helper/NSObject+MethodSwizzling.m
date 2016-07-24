//
//  NSObject+MethodSwizzling.m
//
//  Created by pi on 16/5/26.
//  Copyright © 2016年 pi. All rights reserved.
//  Modified : https://github.com/rentzsch/jrswizzle/blob/feature/add-arc-and-ns-to-1.x/JRSwizzle.m

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIViewController.h>

@implementation NSObject (MethodSwizzling)
#ifdef DEBUG
+(void)load{
    //检测 ViewController 正确销毁...
    NSError *error;
    [UIViewController swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(swizzled_dealloc) error:&error];
}

-(void)swizzled_dealloc{
    
    NSArray* stack =[NSThread callStackSymbols];
    NSLog(@"%@",stack[2]); // [XXXViewController dealloc]
    [self swizzled_dealloc];
}
#endif

#pragma mark -
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error {
    
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        NSString *errorMsg=[NSString stringWithFormat:@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]];
        *error=[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        NSString *errorMsg=[NSString stringWithFormat:@"alternate method %@ not found for class %@", NSStringFromSelector(origSel), [self class]];
        *error=[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error {
    return [object_getClass((id)self) swizzleMethod:origSel withMethod:altSel error:error];
}
@end
