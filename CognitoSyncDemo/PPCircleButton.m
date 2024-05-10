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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];

    
<<<<<<< HEAD
     // self.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
        
        self.layer.borderColor = [UIColor colorWithRed:20/255.0 green:126/255.0 blue:132/255.0 alpha:1.0].CGColor;
        
        
        
        CGContextSetFillColorWithColor(context, colorRef);
        CGContextFillEllipseInRect (context, inset);
        CGContextFillPath(context);
=======
    if ([self state] == UIControlStateHighlighted) {
       // self.layer.borderColor = [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1.0].CGColor;
>>>>>>> main
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (super.highlighted != highlighted) {
        super.highlighted = highlighted;
        [self setNeedsDisplay];
    }
}

@end

