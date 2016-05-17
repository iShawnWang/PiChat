//
//  UIColor+Addition.m
//  UsefulDefine
//
//  Created by pi on 16/3/3.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIColor+Addition.h"


@implementation UIColor (Addition)

#pragma mark - Color from Hex

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [self UIColorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1.0];
}

+(UIColor *)UIColorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a{
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)];
}

#pragma mark - Hex from Color
- (NSString *)hexString
{
    NSArray *colorArray	= [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

-(NSArray *)rgbaArray{
    CGFloat r=0,g=0,b=0,a=0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    r = components[0];
    g = components[1];
    b = components[2];
    a = components[3];
    
    return @[@(r),
             @(g),
             @(b),
             @(a)];
}

#pragma mark - 
+(UIColor *)globalTintColor{
    return [UIColor colorFromHexString:@"06BEBD"];
}

+(UIColor *)lightGrayDividerColor{
    return [UIColor colorFromHexString:@"DEDEDE"];
}
@end
