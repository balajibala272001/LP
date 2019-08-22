//
//  PasscodeButton.m
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "PasscodeButton.h"
#import <QuartzCore/QuartzCore.h>

#define animationLength 0.15
@interface PasscodeButton()

@property (nonatomic, strong) UIView *selectedView;

- (void)setDefaultStyles;
- (void)prepareApperance;
- (void)performLayout;

@end

@implementation PasscodeButton

#pragma mark -
#pragma mark - Init Methods
- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaultStyles];
        
        self.accessibilityValue = [NSString stringWithFormat:@"PinButton%ld", (long)number];
        self.tag = number;
        self.layer.borderWidth = 1.5f;
        _numberLabel = ({
            UILabel *label = [self standardLabel];
            label.text = [NSString stringWithFormat:@"%ld", (long)number];
            label.font = _numberLabelFont;
            label;
        });
        _lettersLabel = ({
            UILabel *label = [self standardLabel];
            //label.attributedText = [[NSAttributedString alloc] initWithString:letters ? letters : @"" attributes:@{NSFontAttributeName: _letterLabelFont, NSKernAttributeName: @2}];
            label;
        });
        
        _selectedView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.alpha = 0.0f;
            view.backgroundColor = _selectedColor;
            view;
        });
    }
    return self;
}

#pragma mark -
#pragma mark - Lifecycle Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self prepareApperance];
    [self performLayout];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self prepareApperance];
}

#pragma mark -
#pragma mark - Helper Methods
- (void)setDefaultStyles
{
    _borderColor = [UIColor whiteColor];
    _selectedColor = [UIColor lightGrayColor];
    _textColor = [UIColor whiteColor];
    _hightlightedTextColor = [UIColor whiteColor];
    
    static NSString* fontName = @"HelveticaNeue-Thin";
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
        {
            fontName = @"HelveticaNeue";
        }
    });
    
    _numberLabelFont = [UIFont fontWithName:fontName size:20];
    _letterLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:10];
}

- (void)prepareApperance
{
    self.selectedView.backgroundColor = self.selectedColor;
    self.layer.borderColor = [self.borderColor CGColor];
    self.numberLabel.textColor = [UIColor whiteColor];
    //self.numberLabel.backgroundColor = [UIColor redColor];
    [self.numberLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;

    self.numberLabel.highlightedTextColor = self.hightlightedTextColor;
  //  self.numberLabel.font = self.numberLabelFont;
    self.lettersLabel.textColor = self.textColor;
    self.lettersLabel.backgroundColor = [UIColor greenColor];
    
    
    
    self.lettersLabel.highlightedTextColor = self.hightlightedTextColor;
    self.lettersLabel.font = self.letterLabelFont;
}

- (void)performLayout
{
    self.selectedView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.selectedView];
    
    self.numberLabel.frame = CGRectMake(0, self.frame.size.height / 5, self.frame.size.width, self.frame.size.height/2.5);
    self.numberLabel.frame = CGRectMake(0, 112,self.frame.size.width , self.frame.size.height/2.5);
    [self addSubview:self.numberLabel];
    
    
    CGPoint center = self.numberLabel.center;
         center.y = self.bounds.size.height / 2 - 1;
            self.numberLabel.center = center;

//    if(self.tag == 0)
//    {
//        CGPoint center = self.numberLabel.center;
//        center.y = self.bounds.size.height / 2 - 1;
//        self.numberLabel.center = center;
//    }
    
    //self.lettersLabel.frame = CGRectMake(0, self.numberLabel.frame.origin.y + self.numberLabel.frame.size.height + 3, self.frame.size.width, 10);
    
    
    [self addSubview:self.lettersLabel];
}

#pragma mark -
#pragma mark - Button Overides
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    __weak PasscodeButton *weakSelf = self;
    [UIView animateWithDuration:animationLength delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.selectedView.alpha = 1.0f;
        [weakSelf setHighlighted:YES];
    } completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    __weak PasscodeButton *weakSelf = self;
    [UIView animateWithDuration:animationLength
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         weakSelf.selectedView.alpha = 0.0f;
                         [weakSelf setHighlighted:NO];
                     } completion:nil];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.numberLabel.highlighted = highlighted;
    self.lettersLabel.highlighted = highlighted;
}

#pragma mark -
#pragma mark - Default View Methods
- (UILabel *)standardLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 1.0;
    
    return label;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
CGFloat const PasscodeButtonHeight = 75;
CGFloat const PasscodeButtonWidth = 75;