//
//  UsernameViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/17/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABPadLockScreenViewController.h"
#import "ABPadLockScreenSetupViewController.h"

@interface UsernameViewController : UIViewController<ABPadLockScreenViewControllerDelegate,ABPadLockScreenSetupViewControllerDelegate>

- (IBAction)btn_pin:(id)sender;

@end
