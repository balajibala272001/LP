//
//  PasscodeButton.h
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number;

@property (nonatomic, strong, readonly) UILabel *numberLabel;
@property (nonatomic, strong, readonly) UILabel *lettersLabel;

@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *hightlightedTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *numberLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *letterLabelFont UI_APPEARANCE_SELECTOR;
@end
