//
//  GalleryCollectionViewCell.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 18/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GalleryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *notesImageView;
@property (weak, nonatomic) IBOutlet UILabel *number_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *videoicon;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet UIButton *blur_img;
@property (weak, nonatomic) IBOutlet UIButton *low_light;
@property (weak, nonatomic) IBOutlet UIButton *Takephoto;
@property (weak, nonatomic) IBOutlet UIButton *crop_but;

@end

NS_ASSUME_NONNULL_END
