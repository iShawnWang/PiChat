//
//  AnimBtn.m
//  PiChat
//
//  Created by pi on 16/5/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AnimBtn.h"
#import <DGActivityIndicatorView.h>

@interface AnimBtn ()
@property (copy,nonatomic) NSString *originalTitle;
@property (strong,nonatomic) NSLayoutConstraint *defaultWidthConstraint;
@property (strong,nonatomic) NSLayoutConstraint *animatingWidthConstraint;
@property (strong,nonatomic) DGActivityIndicatorView *indicatorView;
@property (assign,nonatomic) CGFloat size;
@end

@implementation AnimBtn
-(void)awakeFromNib{
    [self initPrivate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate{
    self.isAnimating=NO;
    self.size=MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.indicatorView.frame=CGRectMake(0, 0, self.size, self.size);
}

-(DGActivityIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView=[[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor whiteColor] size:self.size-10.0];
        _indicatorView.hidden=YES;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

-(void)startAnimting:(void (^)(void))completion{
    self.isAnimating=YES;
    [self.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.firstItem==self && obj.firstAttribute==NSLayoutAttributeWidth){
            self.defaultWidthConstraint=obj;
            [self.superview removeConstraint:obj];
        }
    }];
    
    self.animatingWidthConstraint= [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.size];
    
    [self.superview addConstraint:self.animatingWidthConstraint];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 1.0;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.repeatCount=INFINITY;
    
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat radius= self.size/2.0;
        self.clipsToBounds=YES;
        self.layer.cornerRadius=radius;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if(self.isAnimating){
            self.indicatorView.hidden=NO;
            [self.indicatorView startAnimating];
        }
        self.originalTitle=[self titleForState:UIControlStateNormal];
        [self setTitle:@"" forState:UIControlStateNormal];
        if(completion){
            completion();
        }
    }];
    
}

-(void)stopAnimating:(void (^)(void))completion{
    
    self.isAnimating=NO;
    [self.superview removeConstraint:self.animatingWidthConstraint];
    [self.superview addConstraint:self.defaultWidthConstraint];
    self.indicatorView.hidden=YES;
    [self.indicatorView stopAnimating];
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.layer.cornerRadius=0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setTitle:self.originalTitle forState:UIControlStateNormal];
        if(completion){
            completion();
        }
    }];
    
}
-(void)toogleAnim{
    self.isAnimating ? [self stopAnimating:nil] : [self startAnimting:nil];
}
@end
