//
//  AnimBtn.h
//  PiChat
//
//  Created by pi on 16/5/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimBtn : UIButton
@property (assign,nonatomic) BOOL isAnimating;

-(void)startAnimting:(void (^)(void))completion;

-(void)stopAnimating:(void (^)(void))completion;

-(void)toogleAnim;
@end
