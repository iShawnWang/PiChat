//
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithWidth:(float)width andFont:(UIFont *)font
{
    return [self textSizeWithConstraintsSize:CGSizeMake(width, CGFLOAT_MAX) font:font];
}

- (CGSize)sizeWithHeight:(float)height andFont:(UIFont *)font
{
    return [self textSizeWithConstraintsSize:CGSizeMake(CGFLOAT_MAX, height) font:font];
}

-(CGSize)textSizeWithConstraintsSize:(CGSize)constraintsSize font:(UIFont*)font{
    CGSize returnSize = CGSizeMake(0, 0);
    CGRect rect = CGRectZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    rect = [self boundingRectWithSize:constraintsSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle }
                              context:nil];
    returnSize.height  = rect.size.height ;
    returnSize.width  = rect.size.width;
    return returnSize;
}

@end
