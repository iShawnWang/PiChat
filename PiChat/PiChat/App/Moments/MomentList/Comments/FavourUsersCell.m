//
//  FavourUsersCell.m
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "FavourUsersCell.h"
#import "TTTAttributedLabel.h"
#import "User.h"

@interface FavourUsersCell ()
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *favourUsersAttributeLabel;
@end

@implementation FavourUsersCell

-(void)awakeFromNib{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)configCellWithFavourUsers:(NSArray*)favourUsers tableView:(UITableView*)tableView{
    
    self.favourUsersAttributeLabel.preferredMaxLayoutWidth=CGRectGetWidth(tableView.bounds) ;
    
    NSMutableAttributedString *favourUsersAttributeStr=nil;
    if(favourUsers.count>0){
        
        NSMutableString *favourUsersStr=[NSMutableString string];
        [favourUsers enumerateObjectsUsingBlock:^(User *u, NSUInteger idx, BOOL * _Nonnull stop) {
            [favourUsersStr appendString:u.displayName];
            [favourUsersStr appendString:@","];
        }];
        [favourUsersStr deleteCharactersInRange:NSMakeRange(favourUsersStr.length-1, 1)];
        
        favourUsersAttributeStr=[[NSMutableAttributedString alloc] initWithString:favourUsersStr];
    }
    self.favourUsersAttributeLabel.text=favourUsersAttributeStr;
}

@end
