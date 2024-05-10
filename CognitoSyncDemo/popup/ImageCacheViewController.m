//
//  ImageCropViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 30/03/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import "ImageCacheViewController.h"

@interface ImageCacheViewController ()

@end

@implementation ImageCacheViewController

- (void)viewDidLoad {
    
    _imgView.animationImages = [NSArray arrayWithObjects:
            [UIImage imageNamed:@"crash-0.jpg"],
            [UIImage imageNamed:@"crash-4.jpg"],
            [UIImage imageNamed:@"crash-10.jpg"],
            [UIImage imageNamed:@"crash-16.jpg"],
            [UIImage imageNamed:@"crash-20.jpg"],
            [UIImage imageNamed:@"crash-28.jpg"],
            [UIImage imageNamed:@"crash-34.jpg"],
            [UIImage imageNamed:@"crash-41.jpg"],
            [UIImage imageNamed:@"crash-49.jpg"],
            [UIImage imageNamed:@"crash-59.jpg"],
            [UIImage imageNamed:@"crash-66.jpg"],
            [UIImage imageNamed:@"crash-73.jpg"],
            [UIImage imageNamed:@"crash-82.jpg"],
            [UIImage imageNamed:@"crash-114.jpg"],
            [UIImage imageNamed:@"crash-120.jpg"],
            [UIImage imageNamed:@"crash-122.jpg"],
            [UIImage imageNamed:@"crash-127.jpg"],
            nil];
    _imgView.animationDuration = 1.0f;
    _imgView.animationRepeatCount = 0;
    [_imgView startAnimating];
    [self.view addSubview: _imgView];
    
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
