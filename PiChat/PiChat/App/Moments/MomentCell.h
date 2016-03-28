//
//  MomentCell.h
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Moment;
@class NewMomentPhotoViewerController;
@interface MomentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifyTimeLabel;
//
@property (strong,nonatomic) NewMomentPhotoViewerController *photoViewerController;
-(void)configWithMoment:(Moment*)moment;
@end
