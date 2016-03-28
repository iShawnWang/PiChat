//
//  GCPlaceholderTextView.h
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GCPlaceholderTextView : UITextView 

@property(nonatomic, strong) IBInspectable NSString *placeholder;

@property (nonatomic, strong) IBInspectable UIColor *realTextColor ;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor ;

@end
