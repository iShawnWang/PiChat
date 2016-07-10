//
//  TouchDismissView.m
//  PiChat
//
//  Created by pi on 16/7/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "TouchDismissView.h"

@implementation TouchDismissView
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(self.hitTestBlock){
        return self.hitTestBlock(point,event);
    }else{
        return [super hitTest:point withEvent:event];
    }
}
@end
