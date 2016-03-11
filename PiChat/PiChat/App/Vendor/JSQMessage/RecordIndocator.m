//
//  RecordIndocator.m
//  PiChat
//
//  Created by pi on 16/3/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "RecordIndocator.h"
#import <Masonry.h>

@interface RecordIndocator ()
@property (strong,nonatomic) NSMutableArray *images;
@property (strong,nonatomic) UIImageView *levelImg;
@end

@implementation RecordIndocator
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.images=[NSMutableArray arrayWithCapacity:10];
        for (int i=1; i<10; i++) {
            NSString *imgName=[NSString stringWithFormat:@"record_animate_0%d",i];
            UIImage *img= [UIImage imageNamed:imgName];
            [self.images addObject:img];
        }
        self.backgroundColor=[UIColor colorWithWhite:0.75 alpha:1];
        
        self.levelImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"record_animate_01"]];
        
        self.layer.cornerRadius=10;
        self.clipsToBounds=YES;
        
        UIVisualEffectView *blurView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [self addSubview:blurView];
        
        [self addSubview:self.levelImg];
        
        [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(20,20,20,20));
        }];
    }
    return self;
}

-(void)updateSoundLevel:(CGFloat)level{
    NSInteger i=1;
    if (level > -20) {
        i=8;
    } else if(level> -25)  {
        i=7;
    }else if (level > -30) {
        i=6;
    } else if (level > -35) {
        i=5;
    } else if (level > -40) {
        i=4;
    } else if (level > -45) {
        i=3;
    } else if (level > -50) {
        i=2;
    } else if (level > -55) {
        i=1;
    } else if (level > -60) {
        i=0;
    }
    self.levelImg.image=self.images[i];
}
@end
