//
//  ContactHeaderCell.h
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kContactHeaderCellID=@"ContactHeaderCell";

@interface ContactHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
