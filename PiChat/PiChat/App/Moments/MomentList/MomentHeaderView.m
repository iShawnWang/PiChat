//
//  MomentHeaderView.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentHeaderView.h"
#import "User.h"
#import "ImageCache.h"
#import "GlobalConstant.h"
#import "UIImage+GaussianBlur.h"

@implementation MomentHeaderView
-(void)configWithUser:(User*)u{
    __block UIImage *avatarImg=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
    executeAsyncInGlobalQueue(^{
        if(!avatarImg){
            return ;
        }
        NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((avatarImg), 0.5)];
        if(imgData.length < 1){
            //图片为空
            return ;
        }
        avatarImg=[UIImage imageWithData:UIImageJPEGRepresentation(avatarImg, 1.0)]; //remove alpha channel
        avatarImg=[avatarImg vImageBlurWithNumber:0.2];
        executeAsyncInMainQueue(^{
            self.backgroundImageView.image=avatarImg;
        });
    });
    self.avatarImageView.image=avatarImg;
    self.displayNameLabel.text=u.displayName;
}

+(NSInteger)calcHeightWithWidth:(NSInteger)width{
    return width+44;
}
@end
