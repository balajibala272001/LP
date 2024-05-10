/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "popViewController.h"
#import "PPPinPadViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "igViewController.h"
#import "ViewController.h"


@interface CognitoHomeViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,PinPadPasswordProtocol,CLLocationManagerDelegate,ScannedDelegateIGView,UIImagePickerControllerDelegate,ScannedDelegateView,UITextFieldDelegate>{
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
    igViewController *IGVC;
}


@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (weak, nonatomic) IBOutlet UITextView *rightView;
@property (weak, nonatomic) IBOutlet UITextView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *Bylog;
@property (weak, nonatomic) IBOutlet UILabel *withSG;

@property (weak, nonatomic) IBOutlet UITextField *UserName_txt;
@property (weak, nonatomic) IBOutlet UIView *Background_View;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UILabel *Login_lbl;
@property (weak, nonatomic) IBOutlet UILabel *version_lbl;
@property (weak, nonatomic) IBOutlet UIButton *Login_ok_pressed;
@property (weak,atomic) IBOutlet UIButton *about_pressed;
<<<<<<< HEAD
=======
@property (weak, nonatomic) IBOutlet UIButton *QuickLogin;
@property (weak, nonatomic) IBOutlet UITextView *LoginText;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
>>>>>>> main

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Width;
@property(nonatomic,strong) SCLAlertView *alertbox ;

<<<<<<< HEAD
=======
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Width;
@property(nonatomic,strong) SCLAlertView *alertbox;

>>>>>>> main
- (IBAction)logoTap:(UIButton *)sender;
-(IBAction)login_ok:(UIButton *)sender;
- (IBAction)loadpoof_entend_click:(id)sender;

//language_setting
- (IBAction)lang_table_btn:(id)sender;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *lang_table_btn;
@property (weak, nonatomic) IBOutlet UIButton *loadproof_extend;

@property (nonatomic,assign) int senderTag;

@property (nonatomic,strong) NSMutableArray *sites;
@property (nonatomic, strong) NSMutableArray *arrSites;
@property (nonatomic, strong) NSTimer *locationUpdateTimer;


@end

