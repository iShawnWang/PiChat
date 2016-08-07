//
//  FavourUserView.h
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTAttributedLabel;

@interface FavourUserView : UIView
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *favoursLabel;

+(instancetype)loadViewFromBundle;
-(void)configWithFavourUsers:(NSArray*)favourUsers;
@end
