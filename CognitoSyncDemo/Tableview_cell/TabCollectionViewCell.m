//
//  TabCollectionViewCell.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 18/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import "TabCollectionViewCell.h"

@implementation TabCollectionViewCell
  - (void)awakeFromNib {
      [super awakeFromNib];
      self.layer.borderColor = [UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.0f ].CGColor;
  }

@end
