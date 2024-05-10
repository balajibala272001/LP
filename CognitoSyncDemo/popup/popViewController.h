//
//  popViewController.h
//  coredata
//
//  Created by mac on 30/07/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//
#import "SCLAlertView.h"
#import <UIKit/UIKit.h>
#import "SCLSwitchView.h"

@interface popViewController : UIViewController

- (IBAction)live:(id)sender;
- (IBAction)pre_prod:(id)sender;

- (IBAction)site:(id)sender;
- (IBAction)info:(id)sender;

- (IBAction)cancel:(id)sender;

//environment_change
@property(nonatomic,strong) SCLAlertView *alertbox;

@property(nonatomic,strong) SCLTextView *textField_live;
@property(nonatomic,strong) SCLTextView *textField_site;
@property(nonatomic,strong) SCLTextView *textField_ppd;
@property(nonatomic,strong) SCLTextView *textField_test;

@property(nonatomic,strong) SCLSwitchView *switch_live;
@property(nonatomic,strong) SCLSwitchView *switch_site;
@property(nonatomic,strong) SCLSwitchView *switch_ppd;
@property(nonatomic,strong) SCLSwitchView *switch_test;

@property  BOOL isMaintenance;

@end
