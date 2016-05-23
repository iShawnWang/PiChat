//
//  AVFile+ImageThumbnailUrl.h
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVFile.h"

/**
 *  AVFile 存储的数据都在七牛云存储上用这个 Category 生成相应的 Url, 来获取不同大小的图片,原图,缩略图等..
 */
@interface AVFile (ImageThumbnailUrl)
/**
 *  默认大小 屏幕宽度 1/3 的缩略图
 *
 *  @return 
 */
-(NSString*)defaultThumbnailUrl;

/**
 *  根据 传入的Size,获取相应大小的缩略图
 *
 *  @param size
 *
 *  @return 
 */
-(NSString*)thumbnailUrlWithSize:(CGSize)size;
@end
