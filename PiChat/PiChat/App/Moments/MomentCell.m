//
//  MomentCell.m
//  PiChat
//
//  Created by pi on 16/3/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentCell.h"
#import "Moment.h"
#import "ImageCache.h"
#import "User.h"
#import "UserManager.h"
#import <DateTools.h>
#import "NewMomentPhotoViewerController.h"
#import "CommenUtil.h"
#import <Masonry.h>
#import "StoryBoardHelper.h"

@interface MomentCell ()

@property (weak, nonatomic) IBOutlet UIView *photoViewerPlaceholderView;
@end

@implementation MomentCell

-(void)awakeFromNib{
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
}
-(void)configWithMoment:(Moment*)moment {
    
    User *u=[[UserManager sharedUserManager]findUserFromCacheElseNetworkByClientID:moment.postUser.clientID];
    
    self.displayNameLabel.text=u.displayName;
    self.avatarImageView.image = [[ImageCache sharedImageCache ]findOrFetchImageFormUrl:u.avatarPath];
    self.contentLabel.text=moment.texts;
    self.lastModifyTimeLabel.text=[NSDate timeAgoSinceDate:moment.updatedAt];
    
    if(moment.images && moment.images.count>0){
        NSMutableArray *photoUrls=[NSMutableArray array];
        [moment.images enumerateObjectsUsingBlock:^(AVFile * imageFile, NSUInteger idx, BOOL * _Nonnull stop) {
            [photoUrls addObject:[NSURL URLWithString:imageFile.url]];
        }];
        self.photoViewerController.photoUrls=photoUrls;
        
        [self.photoViewerPlaceholderView addSubview:self.photoViewerController.view];
        [self.photoViewerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.photoViewerPlaceholderView);
        }];
    }
}


-(NewMomentPhotoViewerController *)photoViewerController{
    if(!_photoViewerController){
        _photoViewerController=(NewMomentPhotoViewerController*)[StoryBoardHelper inititialVC:kNewMomentPhotoViewerControllerID fromSB:kMomentsSB];
    }
    return _photoViewerController;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kNewMomentPhotoViewerControllerID]){
        self.photoViewerController=segue.destinationViewController;
        CALayer *layer= self.photoViewerController.view.layer;
        layer.borderColor=[UIColor colorFromHexString:@"DEDEDE"].CGColor;
        layer.borderWidth=1;
        
    }
}
@end
