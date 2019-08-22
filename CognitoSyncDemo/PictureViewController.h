//
//  UploadViewController.h
//  sgpcapp
//
//  Created by SmartGladiator on 13/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewController : UIViewController<UICollectionViewDataSource ,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewToUpload;
@property (strong,nonatomic)NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *selected_CollectionView;



@end
