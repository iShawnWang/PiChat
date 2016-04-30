//
//  JSQPhotoMediaItem+ThubmnailImageUrl.h
//  PiChat
//
//  Created by pi on 16/4/30.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <JSQPhotoMediaItem.h>

@interface JSQPhotoMediaItem (ThumbnailImageUrl)
@property (copy,nonatomic) NSString *thumbnailImageUrl;
@property (copy,nonatomic) NSString *originalImageUrl;
@end
