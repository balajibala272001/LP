//
//  CollectionViewCell.h
//  sgpcapp
//
//  Created by SmartGladiator on 07/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
{
    BOOL checked;
    BOOL setSelected;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *checked;




@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (nonatomic, strong) NSMutableArray *selectedImageArray;
//- (IBAction)checkButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *waterMark_lbl;

@property (weak, nonatomic) IBOutlet UIImageView *delete_Image_View;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;



@end
