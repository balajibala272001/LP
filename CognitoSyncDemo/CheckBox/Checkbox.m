//
//  Checkbox.m
//  CustomCheckBox
//
//  Created by kelley.ricker on 1/11/16.
//  Copyright © 2016 GrapeCity. All rights reserved.
//

#import "Checkbox.h"
IB_DESIGNABLE
@implementation Checkbox{
    UILabel *label;
    BOOL textIsSet;
}
@synthesize text = _text;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initInternals];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initInternals];
    }
    return self;
}
- (void) initInternals{
    _boxFillColor = [UIColor clearColor];
    _boxBorderColor = [UIColor grayColor];
    _checkColor =[UIColor colorWithRed:0.105 green:0.647 blue:0.705 alpha:1];
    _isChecked = YES;
    _isEnabled = YES;
    _showTextLabel = NO;
    textIsSet = NO;
    self.backgroundColor = [UIColor clearColor];
}
-(CGSize)intrinsicContentSize{
    if (_showTextLabel) {
        return CGSizeMake(160, 40);
    }
    else{
        return CGSizeMake(40, 40);
    }
}




- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    [_boxFillColor setFill];
    [_boxBorderColor setStroke];
    
    //User set flag to draw label
    if (_showTextLabel == YES) {
        //check if label has already been created... if not create a new label and set some basic styles
        if (!textIsSet) {
            NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                label = [[UILabel alloc] initWithFrame:CGRectMake(-140, 0, self.frame.size.width*3/4 + 50, self.frame.size.height)];
                label.textAlignment = NSTextAlignmentRight;
            }else{
                label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/4 + 5, 0, self.frame.size.width*3/4 + 50, self.frame.size.height)];
                label.textAlignment = NSTextAlignmentLeft;
            }
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            textIsSet = YES;
        }
        
        //style label
        label.font = _labelFont;
<<<<<<< HEAD
        label.textColor = [UIColor purpleColor];
=======
        label.textColor = [UIColor blackColor];
>>>>>>> main
        label.text = self.text;
        
        //create enclosing box for checkbox
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.frame.size.width/4 - 4, self.frame.size.height - 4) cornerRadius:self.frame.size.width/20];
<<<<<<< HEAD
        boxPath.lineWidth = 3;
=======
        boxPath.lineWidth = 2;
>>>>>>> main
        [boxPath fill];
        [boxPath stroke];
        
        //if control is checked draw checkmark
        if (_isChecked == YES) {
            UIBezierPath *checkPath = [UIBezierPath bezierPath];
<<<<<<< HEAD
            checkPath.lineWidth = 4;
=======
            checkPath.lineWidth = 2;
>>>>>>> main
            [checkPath moveToPoint:CGPointMake(self.frame.size.width * 1/5, self.frame.size.height/5)];
            [checkPath addLineToPoint:CGPointMake(self.frame.size.width/8, self.frame.size.height * 4/5)];
            [checkPath addLineToPoint:CGPointMake(self.frame.size.width/20, self.frame.size.height/2)];
            [_checkColor setStroke];
            [checkPath stroke];
        }
    }
    
    //no text label in this scenario
    else{
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4) cornerRadius:self.frame.size.width/5];
<<<<<<< HEAD
        boxPath.lineWidth = 3;
=======
        boxPath.lineWidth = 2;
>>>>>>> main
        [boxPath fill];
        [boxPath stroke];
        if (_isChecked == YES) {
            UIBezierPath *checkPath = [UIBezierPath bezierPath];
<<<<<<< HEAD
            checkPath.lineWidth = 4;
=======
            checkPath.lineWidth = 2;
>>>>>>> main
            [checkPath moveToPoint:CGPointMake(self.frame.size.width * 4/5, self.frame.size.height/5)];
            [checkPath addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height * 4/5)];
            [checkPath addLineToPoint:CGPointMake(self.frame.size.width/5, self.frame.size.height/2)];
            [_checkColor setStroke];
            [checkPath stroke];
        }
    }
    
    //check if control is enabled...lower alpha if not and disable interaction
    if (_isEnabled == YES) {
        self.alpha = 1.0f;
        self.userInteractionEnabled = YES;
    }
    
    else{
        self.alpha = 0.6f;
        self.userInteractionEnabled = NO;
    }
    
    [self setNeedsDisplay];
    
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setChecked:!_isChecked];
    return true;
}

-(void)setChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    [self setNeedsDisplay];
}
-(void)setEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
    [self setNeedsDisplay];
}
-(void)setText:(NSString *)stringValue{
    _text = stringValue;
    [self setNeedsDisplay];
}
@end
