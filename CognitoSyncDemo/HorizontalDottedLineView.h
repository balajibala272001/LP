//
//  HorizontalDottedLineView.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 08/05/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

// HorizontalDottedLineView.h
#import <UIKit/UIKit.h>

@interface HorizontalDottedLineView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat dotSpacing;

@end

// HorizontalDottedLineView.m
#import "HorizontalDottedLineView.h"

@implementation HorizontalDottedLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGFloat lengths[] = {self.dotSpacing, self.dotSpacing};
    CGContextSetLineDash(context, 0, lengths, 2); // Apply the dash pattern
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
    CGContextStrokePath(context);
}

@end
