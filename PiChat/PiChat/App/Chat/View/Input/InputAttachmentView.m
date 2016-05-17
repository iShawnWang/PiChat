//
//  InputAttachmentView.m
//  PiChat
//
//  Created by pi on 16/3/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "InputAttachmentView.h"

@interface InputAttachmentView ()

@end

@implementation InputAttachmentView
+(instancetype)loadFromNib{
    return [[[NSBundle mainBundle]loadNibNamed:@"InputAttachmentView" owner:self options:nil]firstObject];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216);
}

- (IBAction)emoji:(id)sender {
    [self.delegate inputAttachmentView:self didClickInputView:InputTypeEmoji];
}

- (IBAction)image:(id)sender {
    [self.delegate inputAttachmentView:self didClickInputView:InputTypeImage];
}

- (IBAction)video:(id)sender {
    [self.delegate inputAttachmentView:self didClickInputView:InputTypeVideo];
}

- (IBAction)location:(id)sender {
    [self.delegate inputAttachmentView:self didClickInputView:InputTypeLocation];
}

@end
