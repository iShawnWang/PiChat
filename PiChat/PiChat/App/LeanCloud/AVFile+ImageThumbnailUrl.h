//
//  AVFile+ImageThumbnailUrl.h
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVFile.h"

@interface AVFile (ImageThumbnailUrl)
-(NSString*)defaultThumbnailUrl;

-(NSString*)thumbnailUrlWithSize:(CGSize)size;
@end
