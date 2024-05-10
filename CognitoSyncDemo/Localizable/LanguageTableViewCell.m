//
//  LanguageTableViewCell.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 29/06/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//
#import "LanguageTableViewCell.h"


@interface LanguageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *languageNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tickImage;

@end

@implementation LanguageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLanguageName:(NSString *)name andIsSelected:(BOOL)selected {
    self.languageNameLabel.text = name;
    [self.tickImage setHidden:!selected];
}

@end
