//
//  CameraLoopCollectionViewCell.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 26/09/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraLoopCollectionViewCell : UICollectionViewCell
{
    BOOL checked;
    BOOL setSelected;
}
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet UIButton *blur_img;
@property (weak, nonatomic) IBOutlet UIButton *low_light;
@property (weak, nonatomic) IBOutlet UILabel *waterMark_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *videoicon;
@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (nonatomic, strong) NSMutableArray *selectedImageArray;

@end

NS_ASSUME_NONNULL_END
