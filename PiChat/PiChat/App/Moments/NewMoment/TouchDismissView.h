//
//  TouchDismissView.h
//  PiChat
//
//  Created by pi on 16/7/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView* (^HitTestBlock)(CGPoint point ,UIEvent *event);
@interface TouchDismissView : UIView
@property (copy,nonatomic) HitTestBlock hitTestBlock;

@end
