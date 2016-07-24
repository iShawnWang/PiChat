//
//  AVFile+ImageThumbnailUrl.m
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVFile+ImageThumbnailUrl.h"
#import "CommenUtil.h"


NSString *const kPiAVFileMimeType = @"kPiAVFileMimeType";
@implementation AVFile (ImageThumbnailUrl)
-(NSString *)pi_mimeType{
    return [self.metaData valueForKey:kPiAVFileMimeType];
}
-(void)setPi_mimeType:(NSString *)pi_mimeType{
    if([pi_mimeType isEmptyString]){
        pi_mimeType=@"";
    }
    [self.metaData setObject:pi_mimeType forKey:kPiAVFileMimeType];
}

-(NSString*)defaultThumbnailUrl{
    CGFloat screenWidth_3= CGRectGetWidth([UIScreen mainScreen].bounds)/3.0;
    return [self thumbnailUrlWithSize:CGSizeMake(screenWidth_3, screenWidth_3)];
}

-(NSString*)thumbnailUrlWithSize:(CGSize)size{
    return [self getThumbnailURLWithScaleToFit:NO width:size.width height:size.height];
}
@end
