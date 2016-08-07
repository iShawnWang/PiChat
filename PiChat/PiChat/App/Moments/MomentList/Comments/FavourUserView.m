//
//  FavourUserView.m
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "FavourUserView.h"
#import "TTTAttributedLabel.h"
#import "User.h"


@interface FavourUserView ()
@end

@implementation FavourUserView

+(instancetype)loadViewFromBundle{
    return [[[NSBundle mainBundle]loadNibNamed:@"FavourUserView" owner:nil options:nil]firstObject];
}

-(void)configWithFavourUsers:(NSArray*)favourUsers{
    __block NSMutableString *favourUsersStr=[NSMutableString string];
    NSMutableAttributedString *favorUsersAttrStr;
    
    [favourUsers enumerateObjectsUsingBlock:^(User * user, NSUInteger idx, BOOL * _Nonnull stop) {
        [favourUsersStr appendString:user.displayName];
        [favourUsersStr appendString:@","];
        
        if(favourUsersStr.length<1){
            return;
        }
        [favourUsersStr deleteCharactersInRange:NSMakeRange(favourUsersStr.length-1, 1)];
    }];
    
    favorUsersAttrStr=[[NSMutableAttributedString alloc]initWithString:favourUsersStr];
    
    self.favoursLabel.text=favorUsersAttrStr;
}
@end
