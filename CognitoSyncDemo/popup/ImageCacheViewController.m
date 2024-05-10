//
//  ImageCropViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 30/03/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import "ImageCropViewController.h"

@interface ImageCropViewController ()

@end

@implementation ImageCropViewController

- (void)viewDidLoad {
    
    _imgView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"crash.gif"], nil];
    _imgView.animationDuration = 1.0f;
    _imgView.animationRepeatCount = 0;
    [_imgView startAnimating];
    [self.view addSubview: _imgView];
    
}


@end
