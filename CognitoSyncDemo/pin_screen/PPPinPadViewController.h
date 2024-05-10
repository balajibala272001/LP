//
//  VTPinPadViewController.h
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCircleButton.h"
#import "User.h"
#import "FieldData.h"
#import "SiteData.h"
#import "ATAppUpdater.h"
#import "SCLAlertView.h"
#import <CoreLocation/CoreLocation.h>

@protocol PinPadPasswordProtocol <NSObject>

@required
- (BOOL)checkPin:(NSString *)pin;
- (NSInteger)pinLenght;
@optional
- (void)pinPadSuccessPin;
- (void)pinPadWillHide;
- (void)pinPadDidHide;
- (void)userPassCode:(NSString *)newPassCode;
@end


@interface PPPinPadViewController : UIViewController<CLLocationManagerDelegate> {
    __weak IBOutlet UIView *_pinCirclesView;
    __weak IBOutlet UIView *_errorView;
    __weak IBOutlet UILabel *pinLabel;
    __weak IBOutlet UILabel *pinErrorLabel;
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *cancelButton;
    NSMutableString *_inputPin;
    NSMutableArray *_circleViewList;
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
}

@property (nonatomic,assign) id<PinPadPasswordProtocol,ATAppUpdaterDelegate> delegate;

@property (nonatomic, strong) NSString *errorTitle;
@property (nonatomic, strong) NSString *pinTitle;
@property (nonatomic, assign) BOOL cancelButtonHidden;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) BOOL isSettingPinCode;

@property (strong, nonatomic) IBOutlet UIView *sub_view;
@property (nonatomic, weak) UIColor *tintColor;

@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property(nonatomic,strong) SCLAlertView *alertbox ;

@property (strong,nonatomic)NSString *userName;
@property (strong,nonatomic)NSString *AppVersion;
@property (strong,nonatomic)NSString *DeviceModel;
@property (strong,nonatomic)NSString *UDID;
@property (strong,nonatomic)NSString *OS;
@property (strong,nonatomic)NSString *OsVersion;
@property (strong,nonatomic)NSString *DeviceName;


@property (weak, nonatomic) IBOutlet PPCircleButton *btn1;

@property (weak,nonatomic) IBOutletCollection(PPCircleButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UILabel *userDetails;


@property (weak, nonatomic) IBOutlet UIView *Inner_View;


@property (strong,nonatomic)User *user;

@property (strong ,nonatomic)SiteData *siteData;
@end
