//
//  MomentHeaderView.h
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface MomentHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
-(void)configWithUser:(User*)u;
+(NSInteger)calcHeightWithWidth:(NSInteger)width;
@end
