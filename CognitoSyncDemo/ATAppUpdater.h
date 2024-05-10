//
//  ATAppUpdater.h
//  versionupdate
//
//  Created by mac on 23/06/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import <SystemConfiguration/SystemConfiguration.h>

@protocol ATAppUpdaterDelegate <NSObject>
@optional
- (void)appUpdaterDidShowUpdateDialog;
- (void)appUpdaterUserDidLaunchAppStore;
- (void)appUpdaterUserDidCancel;
@end

@interface ATAppUpdater : NSObject

@property (nonatomic, weak) id <ATAppUpdaterDelegate> delegate;

@property (nonatomic, weak) NSString *alertTitle;
@property (nonatomic, weak) NSString *alertMessage;
@property (nonatomic, weak) NSString *alertUpdateButtonTitle;
@property (nonatomic, weak) NSString *alertCancelButtonTitle;
@property (nonatomic,strong) SCLAlertView *alertbox ;
@property (nonatomic,weak) UIViewController *controller;

+ (id)sharedUpdater;

- (void)showUpdateWithForce;
-(void) stopTimer;
- (void)showUpdateWithConfirmation;

- (void)showUpdateWithConfirmationOnce;

- (void)updateController:(UIViewController *)u_controller;

@end
