//
//  InputAttachmentView.h
//  PiChat
//
//  Created by pi on 16/3/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstant.h"
@class InputAttachmentView;

typedef enum : NSUInteger {
    InputTypeEmoji,
    InputTypeImage,
    InputTypeVideo,
    InputTypeLocation
} InputType;

@protocol InputAttachmentViewDelegate <NSObject>

-(void)inputAttachmentView:(InputAttachmentView*)v didClickInputView:(InputType)type;

@end

typedef void (^InputClickBlock)(InputType type);
@interface InputAttachmentView : UIView
@property(nonatomic,weak) IBOutlet id<InputAttachmentViewDelegate> delegate;
+(instancetype)loadFromNib;
@end
