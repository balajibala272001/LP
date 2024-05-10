//
//  PicturesCollectionViewCell.h
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicturesCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *notesImageView;
@property (weak, nonatomic) IBOutlet UILabel *number_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *videoicon;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet UIButton *blur_img;
@property (weak, nonatomic) IBOutlet UIButton *low_light;
@property (weak, nonatomic) IBOutlet UIButton *crop_but;

@end
