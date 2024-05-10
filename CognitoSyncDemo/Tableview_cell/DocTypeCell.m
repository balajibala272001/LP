//
//  DocTypeCell.m
//  CognitoSyncDemo
//
//  Created by smartgladiator on 04/09/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import "DocTypeCell.h"

@implementation DocTypeCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.0f ].CGColor;
}

@end
