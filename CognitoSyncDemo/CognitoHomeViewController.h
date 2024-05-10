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

#import <Foundation/Foundation.h>
#import "popViewController.h"
#import "PPPinPadViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"

@interface CognitoHomeViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,PinPadPasswordProtocol,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
}

@property (weak, nonatomic) IBOutlet UITextView *linkTextView;
@property (weak, nonatomic) IBOutlet UITextField *UserName_txt;
@property (weak, nonatomic) IBOutlet UIView *Background_View;
@property (weak, nonatomic) IBOutlet UILabel *Login_lbl;
@property (weak, nonatomic) IBOutlet UILabel *version_lbl;
@property (weak, nonatomic) IBOutlet UIButton *Login_ok_pressed;
@property (weak,atomic) IBOutlet UIButton *about_pressed;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Width;
@property(nonatomic,strong) SCLAlertView *alertbox ;

- (IBAction)login_ok:(UIButton *)sender;
- (IBAction)logoTap:(UIButton *)sender;

@end

