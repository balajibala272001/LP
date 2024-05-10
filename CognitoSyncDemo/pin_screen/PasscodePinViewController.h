//
//  PasscodePinViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/26/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteViewController.h"
#import "ATAppUpdater.h"
#import "SCLAlertView.h"
#import "SCLTextView.h"
#import <CoreLocation/CoreLocation.h>

@interface PasscodePinViewController : UIViewController <ATAppUpdaterDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>

{
    __weak IBOutlet UIView *_pinCirclesView;
    __weak IBOutlet UIView *_errorView;
    __weak IBOutlet UILabel *pinLabel;
    __weak IBOutlet UILabel *pinErrorLabel;
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *cancelButton;
    NSMutableString *_inputPin;
    NSMutableArray *_circleViewList;
    BOOL isbackground;
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
}

//@property (nonatomic,assign) id<> delegate;

@property (nonatomic,strong)NSString *errorTitle;
@property (nonatomic,strong)NSString *pinTitle;
@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (strong,nonatomic)NSString *AppVersion;
@property (strong,nonatomic)NSString *DeviceModel;
@property (strong,nonatomic)NSString *UDID;
@property (strong,nonatomic)NSString *OS;
@property (strong,nonatomic)NSString *OsVersion;
@property (strong,nonatomic)NSString *DeviceName;
@property (strong,nonatomic)NSString *userName;
@property (nonatomic,strong)NSString *struserName;
@property (nonatomic,strong)NSMutableArray *sites;
@property (nonatomic, strong) NSMutableArray *arrSites;

@property (weak, nonatomic) IBOutlet UILabel *userDetails;
@property (strong, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UIView *InnerView;
@property (nonatomic,strong)SiteViewController *SiteVC2;
@property(nonatomic,strong) SCLTextView *textField ;
@property(nonatomic,strong) SCLAlertView *alertbox ;@property (nonatomic) BOOL isSettingPinCode;
@property (nonatomic,assign) BOOL cancelButtonHidden;

@property (strong, nonatomic) UIButton *Logout;
- (IBAction)Logout:(id)sender;

@end
