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


@end
