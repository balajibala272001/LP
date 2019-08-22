//
//  VTCircleButton.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/16/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPCircleButton.h"
static const CGFloat LSNContextSetLineWidth = 0.8f;


@implementation PPCircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
   [self.layer setCornerRadius:CGRectGetHeight(rect)/2.0];

   //[self.layer setCornerRadius:CGRectGetHeight(rect)/3.0];
    
  // [self.layer setContentsRect:CGRectGetHeight()];
    
   //self.layer.cornerRadius = 2;
    
    
    self.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
                              
    self.layer.borderWidth = 2.0f;
    
    
    // Drawing code
    CGFloat height = CGRectGetHeight(rect);
    CGRect  inset  = CGRectInset(CGRectMake(0, 0, height, height), 1, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef colorRef  = [self tintColor].CGColor;

    UIControlState state = [self state];
    
    CGContextSetLineWidth(context, LSNContextSetLineWidth);
    if (state == UIControlStateHighlighted) {
  
        
    
     // self.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
        
        self.layer.borderColor = [UIColor colorWithRed:20/255.0 green:126/255.0 blue:132/255.0 alpha:1.0].CGColor;
        
        
        
CGContextSetFillColorWithColor(context, colorRef);
        CGContextFillEllipseInRect (context, inset);
        CGContextFillPath(context);
    }
    else {
        CGContextSetStrokeColorWithColor(context, colorRef);
        CGContextAddEllipseInRect(context, inset);
        CGContextStrokePath(context);
    }

}

- (void)setHighlighted:(BOOL)highlighted {
    if (super.highlighted != highlighted) {
       // self.layer.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
        
        
        super.highlighted = highlighted;
        
        [self setNeedsDisplay];
    }
    
    
    
    
}


  //self.layer.borderColor = [UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0].CGColor;
@end
