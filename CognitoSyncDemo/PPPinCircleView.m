//
//  VTPinCircleImageView.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/16/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinCircleView.h"

@implementation PPPinCircleView

+ (instancetype)circleView:(CGFloat)radius {
    
    PPPinCircleView * circleView = [[PPPinCircleView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, radius*2.0f, radius*2.0f)];

    //pin entering small circle
   circleView.layer.cornerRadius = radius;

  //  circleView.layer.cornerRadius = 3;
  
    
    //passswprd filling outer circle --small 
      circleView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
    
    
   // circleView.layer.borderColor = [UIColor colorWithRed:20/255.0 green:126.0/255.0 blue:132.0/255.0 alpha:1.0].CGColor;
    
  //  circleView.layer.borderColor = [UIColor greenColor].CGColor;
    
    circleView.layer.borderWidth = 2.0f;
    return circleView;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
