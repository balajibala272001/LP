//
//  ScanController.h
//  BarcodeScanner
//
//  Created by Vijay Subrahmanian on 09/05/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScannedDelegate <NSObject>

-(void)sentTextViewController:(NSString *) string;


@end

@interface ScanController : UIViewController


@property(nonatomic,weak)id<ScannedDelegate>delegate;

@end
