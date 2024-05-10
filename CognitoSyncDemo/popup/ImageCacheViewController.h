//
//  ImageCropViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 30/03/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCacheViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)cancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
