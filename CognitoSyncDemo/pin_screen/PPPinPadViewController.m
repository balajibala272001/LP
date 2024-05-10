
//
//  VTPinPadViewController.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinPadViewController.h"
#import "PPPinCircleView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SiteViewController.h"
#import "KeychainItemWrapper.h"
#import "CognitoHomeViewController.h"
#import "ServerUtility.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"
#import "Reachability.h"
#import "User.h"
#import <CoreLocation/CoreLocation.h>
#import "LanguageManager.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
  settingMewPinStateFisrt   = 0,
  settingMewPinStateConfirm = 1
};
@interface PPPinPadViewController () {
  NSInteger _shakes;
  NSInteger _direction;
    double lat_app;
    double longi_app;
    double radius_app;
    AZCAppDelegate *delegateVC;

}
@property (nonatomic) settingNewPinState  newPinState;
@property (nonatomic,strong) NSString *fisrtPassCode;
@property (weak, nonatomic) IBOutlet UILabel *laInstructionsLabel;
@end

static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;
@implementation PPPinPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //Location
  locationManager = [[CLLocationManager alloc]init];
  locationManager.delegate = self;
  [locationManager startUpdatingLocation];
  [self geolocation];
  
  _userDetails.hidden = false;
  self.AppVersion = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"appVersion"];
  self.DeviceModel = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"DeviceModel"];
  self.UDID = [[NSUserDefaults standardUserDefaults]
          stringForKey:@"identifier"];
  self.OS = [[NSUserDefaults standardUserDefaults]
        stringForKey:@"OS"];
  self.OsVersion = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"OSVersion"];
  self.DeviceName = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"DeviceName"];

  NSLog(@" username is :%@",_userName);
  
  
  
  self.userDetails.text=[_userName uppercaseString];
  _userDetails.numberOfLines = 0;
  CGSize maximumLabelSize = CGSizeMake(200, 9999);
  CGSize expectedLabelSize = [_userName sizeWithFont:_userDetails.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
  CGRect newFrame = _userDetails.frame;
  NSString *AppVersion1 = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"appVersion"];
  NSString *DeviceModel1 = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"DeviceModel"];
  NSString *UDID1 = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"identifier"];
  NSString *OS1 = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"OS"];
  NSString *OsVersion1 = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"OSVersion"];
  NSLog(@"OSVersion %@",OsVersion1);
  NSLog(@"appVersion %@",AppVersion1);
  NSLog(@"DeviceModel %@",DeviceModel1);
  NSLog(@"identifier %@",UDID1);
  NSLog(@"OS %@",OS1);
  // resizing the frame to calculated size
  newFrame.size.height = expectedLabelSize.height;
  
  // put calculated frame into UILabel frame
  _userDetails.frame = newFrame;

  _userDetails.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
  pinLabel.text = self.pinTitle ? :NSLocalizedString(@"Enter PIN",@"");
  pinErrorLabel.text = self.errorTitle ? : NSLocalizedString(@"Passcode is not correct",@" ");
  cancelButton.hidden = self.cancelButtonHidden;
  if (self.backgroundImage) {
      backgroundImageView.hidden = NO;
      backgroundImageView.image = self.backgroundImage;
  }

}
//location
-(void)allowLocationAccess
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox addButton: NSLocalizedString(@"Settings", @" ") target:self selector:@selector(setting:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Turn ON Location Permission to Continue...", @" ") closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)setting:(id)sender{
  [self.alertbox hideView];

  UIApplication *application = [UIApplication sharedApplication];
  NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
  [application openURL:URL options:@{} completionHandler:^(BOOL success) {if (success) {NSLog(@"Opened url");}
  }];
}
-(void)geolocation{
  ceo = [[CLGeocoder alloc]init];
  [locationManager requestWhenInUseAuthorization];
  
  CLLocationCoordinate2D coordinate;

  coordinate.latitude=locationManager.location.coordinate.latitude;
  coordinate.longitude=locationManager.location.coordinate.longitude;
  NSLog(@"coordinate.longitude:%f",coordinate.longitude);
  NSLog(@"coordinate.latitude:%f",coordinate.latitude);
    lat_app = coordinate.latitude;
    longi_app = coordinate.longitude;
      [locationManager stopUpdatingLocation];
  
}
//Location


#pragma mark - ATAppUpdater Delegate

- (void)appUpdaterDidShowUpdateDialog
{
  NSLog(@"appUpdaterDidShowUpdateDialog");
}

- (void)appUpdaterUserDidLaunchAppStore
{
  NSLog(@"appUpdaterUserDidLaunchAppStore");
}

- (void)appUpdaterUserDidCancel
{
  NSLog(@"appUpdaterUserDidCancel");
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)tintSubviewsWithColor: (UIColor *)color
{
  for (PPCircleButton *number  in _numberButtons) {
      [number setTintColor:color];
  }
}

- (void) setCancelButtonHidden:(BOOL)cancelButtonHidden{
  _cancelButtonHidden = cancelButtonHidden;
  cancelButton.hidden = cancelButtonHidden;
}

- (void) setErrorTitle:(NSString *)errorTitle{
  _errorTitle = errorTitle;
  pinErrorLabel.text = errorTitle;
}

- (void) setPinTitle:(NSString *)pinTitle{
  _pinTitle = pinTitle;
  pinLabel.text = pinTitle;
}


- (void)dismissPinPad {
  if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadWillHide)])
  {
  [self.delegate pinPadWillHide];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
  _errorView.hidden = hidden;
  if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")) {
      [self setNeedsStatusBarAppearanceUpdate];
  }
  
  
}
-(void)viewWillAppear:(BOOL)animated{
    
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"PinVC";
    //updater
    [[ATAppUpdater sharedUpdater] setDelegate:self]; // Optional
    [[ATAppUpdater sharedUpdater] updateController:self];
    [[ATAppUpdater sharedUpdater] showUpdateWithConfirmation];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
    _userDetails.hidden = false;
     [self addCircles];    
}

-(BOOL)prefersStatusBarHidden
{
  return !_errorView.hidden;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}
-(void)setIsSettingPinCode:(BOOL)isSettingPinCode{
  _isSettingPinCode = isSettingPinCode;
  if (isSettingPinCode) {
      self.newPinState = settingMewPinStateFisrt;
  }
}
#pragma mark Actions

- (IBAction)cancelClick:(id)sender {

  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)resetClick:(id)sender {
    
  [self addCircles];
  self.laInstructionsLabel.text = NSLocalizedString(@"Enter PIN", @"");
  _inputPin = [NSMutableString string];
  self.newPinState = settingMewPinStateFisrt;
}


- (IBAction)numberButtonClick:(id)sender {
  if(!_inputPin) {
      _inputPin = [NSMutableString new];
  }
  if(!_errorView.hidden) {
      [self changeStatusBarHidden:YES];
  }
  [_inputPin appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
  NSLog(@"%lu",(unsigned long)_inputPin.length);
  [self fillingCircle:_inputPin.length - 1];
  NSLog(@"%lu",(unsigned long)_inputPin.length);

  if (self.isSettingPinCode){
      if ([self pinLenght] == _inputPin.length){
          if (self.newPinState == settingMewPinStateFisrt) {
              self.fisrtPassCode  = _inputPin;
              // reset and prepare for confirmation stage
              [self resetClick:Nil];
              self.newPinState    = settingMewPinStateConfirm;
              // update instruction label
              self.laInstructionsLabel.text = NSLocalizedString(@"Confirm PassCode", @"");
          }else{
              // we are at confirmation stage check this pin with original one
              if ([self.fisrtPassCode isEqualToString:_inputPin]) {
                  // every thing is ok
                  if ([self.delegate respondsToSelector:@selector(userPassCode:)]) {
                      [self.delegate userPassCode:self.fisrtPassCode];
                  }
                  [self dismissPinPad];
              }else{
                  // reset to first stage
                  self.laInstructionsLabel.text = NSLocalizedString(@"Enter PIN", @"");
                  _direction = 1;
                  _shakes = 0;
                 // [self shakeCircles:_pinCirclesView];
                  [self changeStatusBarHidden:NO];
                  [self resetClick:Nil];
              }
          }
      }
  }else{
      
      CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
      if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
          NSLog(@"allowed");
      if ([self pinLenght] == _inputPin.length) {
          if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
              [self validatePin];
              [self geolocation];

          }else{
              bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];

              if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"] != nil && boolToRestrict  == FALSE){
                  [self checkForOffline];
              }else{
                  _direction = 1;
                  _shakes = 0;
                  [self shakeCircles:_pinCirclesView];
                  [self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing.",@" ") duration:2.0 position:CSToastPositionCenter];
                  
              }
          }
      }
      }else if(status == kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted ) {
          NSLog(@"Denied");
          _direction = 1;
          _shakes = 0;
          [self shakeCircles:_pinCirclesView];
          [self allowLocationAccess];

      }
  }
}

-(void) validatePin{
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
  __weak typeof(self) weakSelf = self;
  
    NSString *appver = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
    bool dt =[[NSUserDefaults standardUserDefaults] boolForKey:@"DeviceTrackerAccess"];
    bool crp =[[NSUserDefaults standardUserDefaults] boolForKey:@"CorporateLevel"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
        boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolvalue:%d",boolvalue);
    }
    NSLog(@"Cor pin :%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"CorporateLevel"]);
    NSLog(@"AppV :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"]);
    NSLog(@"DT pin :%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"DeviceTrackerAccess"]);

    [ServerUtility getUserNameAndUserPin:self.userName withUserPin:_inputPin withOs_name:self.OS withOs_version:self.OsVersion withDevice_name:self.DeviceName withDevice_model:self.DeviceModel withImei:self.UDID withAppversion:self.AppVersion withAppaccessversion:appver withDevicetracker:dt withcorporate:crp withBoolvalue:boolvalue andCompletion:^(NSError *error, id data,float dummy){
        
      AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
      delegate.isMaintenance=NO;
      if (!error) {
          
          if(delegate!= nil)
              delegate.isEnterForegroundCamera = YES;
          delegate.isEnterForegroundVideo = YES;
          NSLog(@" PinScreen data:%@",data);
          NSString *strResType = [data objectForKey:@"res_type"];
          NSString *strMsg = [data objectForKey:@"msg"];
          NSString *str = [data objectForKey:@"user_profile"];
          NSLog(@"user_profile : %@",str);

          NSString *default_language = [data objectForKey:@"default_language"];
          [[NSUserDefaults standardUserDefaults] setObject:default_language forKey:@"default_language"];
          [LanguageManager setupCurrentLanguage];
          [[NSUserDefaults standardUserDefaults] synchronize];


          if ([strResType.lowercaseString isEqualToString:@"error"])
          {
              _direction = 1;
              _shakes = 0;
              [self shakeCircles:_pinCirclesView];
              [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
          }else  {
              NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
              if ([strResType.lowercaseString isEqualToString:@"success"]){
                  [[ATAppUpdater sharedUpdater] stopTimer];

                  bool corporateLevelplan = YES;
                  NSString *AppAccessVersion = @"";
                  bool DeviceTrackerAccess = NO;
                  int TrackId = 0;
                  int ProfileId;
                  //newly_added_api
                  if([data valueForKey:@"corporate_level_plan"] != NULL ){
                      corporateLevelplan = [[data objectForKey:@"corporate_level_plan"]intValue];
                  }
                  if([data valueForKey:@"app_access_version"] != NULL ){
                      AppAccessVersion = [data objectForKey:@"app_access_version"];
                  }
                  if([data valueForKey:@"device_track_access"] != NULL ){
                      DeviceTrackerAccess = [[data objectForKey:@"device_track_access"]intValue];
                  }
                  if([data valueForKey:@"tracker_device_id"] != NULL ){
                      TrackId = [[data objectForKey:@"tracker_device_id"]intValue];
                  }
                  if([data valueForKey:@"profile_guide_id"] != NULL ){
                      ProfileId = [[data objectForKey:@"profile_guide_id"]intValue];
                      NSLog(@"Profile_Id :%d",ProfileId);
                  }
                  bool boolToRestrict = ![AppAccessVersion isEqual: @"v1"] && !DeviceTrackerAccess && !corporateLevelplan;
                  
                  
                  NSLog(@"Cor pinApi :%d",corporateLevelplan);
                  //NSLog(@"AppAccessVersion pinApi :%@",AppAccessVersion);
                  NSLog(@"DT pinApi :%d",DeviceTrackerAccess);

                  [[NSUserDefaults standardUserDefaults] setBool:corporateLevelplan forKey:@"CorporateLevel"];
                  [[NSUserDefaults standardUserDefaults] setObject:AppAccessVersion forKey:@"AppAccessVersion"];
                  [[NSUserDefaults standardUserDefaults] setBool: DeviceTrackerAccess forKey:@"DeviceTrackerAccess"];
                  [[NSUserDefaults standardUserDefaults] setInteger: TrackId forKey:@"TrackId"];
                  [[NSUserDefaults standardUserDefaults] setInteger: ProfileId forKey:@"ProfileId"];

                  [[NSUserDefaults standardUserDefaults] setBool:boolToRestrict forKey:@"boolToRestrict"];

                  [[NSUserDefaults standardUserDefaults] synchronize];

                  NSLog(@"PinScreen boolToRestrict:%d",boolToRestrict);
                  
                  if ([data valueForKey:@"refer"])
                  {
                      NSString *strRefer = [data objectForKey:@"refer"];
                      [[NSUserDefaults standardUserDefaults]setValue: strRefer forKey:@"refer"];
                  }
                  if([data valueForKey:@"lat"] && [data valueForKey:@"long"] && [data valueForKey:@"radius"])
                  {
                      bool boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
                      if (boolvalue == TRUE){
                          [DictData addEntriesFromDictionary:data];
                          NSLog(@" my dict:%@",DictData);
                          [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"userName"];
                          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                          [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                          [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
                          [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"OfflineData"];
                          [[NSUserDefaults standardUserDefaults]synchronize];
                          [self getProfile:(DictData)];
                      }else if([[data objectForKey:@"lat"]  isEqual: @""] || [[data objectForKey:@"long"]  isEqual: @""] || [[data objectForKey:@"radius"]  isEqual: @""])
                      {
                       [DictData addEntriesFromDictionary:data];
                       NSLog(@" my dict:%@",DictData);
                       [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"user_name"];
                       
                       [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                       [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
                       [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                       
                       [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"OfflineData"];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       [self getProfile:(DictData)];
                   }else{
                  NSString * lat = [data objectForKey:@"lat"];
                  NSString * longi = [data objectForKey:@"long"];
                  NSString * radius = [data objectForKey:@"radius"];
                      double lat_api = [lat doubleValue];
                      double longi_api = [longi doubleValue];
                      NSLog(@"lat_api:%f",lat_api);
                      double radius_api = [radius doubleValue];
                      CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat_app longitude:longi_app];
                          CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:lat_api longitude:longi_api];
                          CLLocationDistance distanceInMeters = [loc1 distanceFromLocation:loc2];
                          NSLog(@"distanceInMeters:%f",distanceInMeters);
                      double radius_app = (distanceInMeters * 0.000621371);
                      NSLog(@"radius_app:%f",radius_app);
                       double difference = radius_app - radius_api;
                  NSLog(@"difference:%f",difference);
                    if ((radius_api == radius_app) || (difference < radius_api)){
                       [DictData addEntriesFromDictionary:data];
                       NSLog(@" my dict:%@",DictData);
                       [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"user_name"];
                       
                       [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                       [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
                       [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                       
                       [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"OfflineData"];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       [self getProfile:(DictData)];
                       }else{
                           self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                           [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
                           [self.alertbox showSuccess:NSLocalizedString(@"Warning !",@"") subTitle:NSLocalizedString(@"Please Login from Authorised Location.",@"") closeButtonTitle:nil duration:1.0f ];
                       }
                   }
                  }else{
                      [DictData addEntriesFromDictionary:data];
                      NSLog(@" my dict:%@",DictData);
                      [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"user_name"];
                      
                      [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                      [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
                      [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                      
                      [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"OfflineData"];
                      [[NSUserDefaults standardUserDefaults]synchronize];
                      [self getProfile:(DictData)];
                  }
              }else if ([strResType.lowercaseString isEqualToString:@"maintenance"] ){
                  bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
                  delegate.isMaintenance=YES;
                  if(boolToRestrict  == FALSE){
                  [self checkForOffline];
                  }else{
                      [self.view makeToast:NSLocalizedString(@"Server Under Maintenance.",@" ") duration:2.0 position:CSToastPositionCenter];
                      _direction = 1;
                      _shakes = 0;
                      [self shakeCircles:_pinCirclesView];
                  }
              }else{
                  if([data valueForKey:@"multi_device"]){
                      self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                      [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
                      [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"]closeButtonTitle:nil duration:1.0f ];
                  }else{
                  [self.view makeToast:NSLocalizedString(@"Try Again",@"") duration:2.0 position:CSToastPositionCenter];
                  _direction = 1;
                  _shakes = 0;
                  [self shakeCircles:_pinCirclesView];
                  }
              }
          }
      }
      
      else
      {
          _direction = 1;
          _shakes = 0;
          [self shakeCircles:_pinCirclesView];
          [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
          
      }
      
      [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
      
  }];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void) checkForOffline {
  
  NSString *strMsg;
  AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"] !=nil &&
     [[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineUser"] !=nil &&
     [[NSUserDefaults standardUserDefaults] objectForKey:@"OfflinePin"] !=nil){
      
      if([[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineUser"] isEqualToString:self.userName ] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflinePin"] isEqualToString:_inputPin ]){
          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
          NSDictionary *offlineDict=[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"];
          
          [DictData addEntriesFromDictionary:offlineDict];
          
          NSLog(@" my dict:%@",DictData);
          if (delegate.isMaintenance== YES) {
              strMsg= NSLocalizedString(@"Server under maintenance.!\nEnabling offline mode",@"");
          }else{
            //  strMsg=@"Network is offline.!\nEnabling offline mode";
          }
          
          [self getProfile:DictData];
          
      }else{
          strMsg=NSLocalizedString(@"Incorrect PIN.",@"");
          _direction = 1;
          _shakes = 0;
          [self shakeCircles:_pinCirclesView];
      }
  }else{
      if (delegate.isMaintenance== YES) {
          //strMsg=@"Server Under maintenance.!\nOffline data not available";
      }else{
          //strMsg=@"Network is offline.!\nOffline data not available";
      }
  }
  
  [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
  
  
}

- (void) getCustomCategory{
  AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
  if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
      
      //mythiCategory
      NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
      NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
      [ServerUtility getCid:cid
                    withUid:uid andCompletion:^(NSError * error ,id data,float dummy){

          if (!error) {
              NSString *res_type = [data objectForKey:@"res_type"];
              NSString *msg = [data objectForKey:@"msg"];
              if (res_type.boolValue==true && [msg isEqual:@"success"]) {
                  NSLog(@"Addon5 Response\n %@",[data objectForKey:@"data"]);
                  
                  [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"OfflineCustomCategory"];
                  [[NSUserDefaults standardUserDefaults]synchronize];
                  for(NSDictionary *dict in [data objectForKey:@"data"]){
                      NSMutableArray *categoryarray=nil;
                      NSArray *categoryArray= [dict objectForKey:@"category_data"];
                      int s_id= [[dict objectForKey:@"s_id"]intValue];
                    //  NSLog(@"CategoryArray :%@",categoryArray);
                      for (int j=0; j<categoryArray.count; j++) {
                          NSDictionary *categorydict= [categoryArray[j]mutableCopy];
                      //for (NSDictionary *categorydict in categoryArray ) {
                          CategoryData *categoryData=[[CategoryData alloc] initWithDictionary:categorydict];
                          if (!categoryarray) {
                              categoryarray= [NSMutableArray array];
                          }
                              [categoryarray addObject:categoryData];
                      }
  //                                    NSLog(@"CategoryData: %d",categoryData.categoryId);
  //                                    NSLog(@"CategoryData: %@",categoryData.categoryName);
                          for (int i=0; i<delegate.userProfiels.arrSites.count; i++) {
                              SiteData *site=delegate.userProfiels.arrSites[i];
                              if(site.siteId == s_id){
                                  site.customCategory =categoryarray;
                                  delegate.userProfiels.arrSites[i]=site;
                                  break;
                              }
                          
                          }
                      

                  }
                  
                  UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationBar"];

                  [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
                  [UIApplication sharedApplication].keyWindow.rootViewController = controller;
              }else{
                  NSLog(@"%@",msg);
                  [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                  UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationBar"];

                  [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
                  [UIApplication sharedApplication].keyWindow.rootViewController = controller;
              }



          }else{

              [self.view makeToast:error.localizedFailureReason];
              
              UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationBar"];

              [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
              [UIApplication sharedApplication].keyWindow.rootViewController = controller;
          }
      }];
  }else{
      if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineCustomCategory"] !=nil){
          NSDictionary *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineCustomCategory"];
          for(NSDictionary *dict in [data objectForKey:@"data"]){
              NSMutableArray *categoryarray=nil;
              NSArray *categoryArray= [dict objectForKey:@"category_data"];
              int s_id= [[dict objectForKey:@"s_id"]intValue];
            //  NSLog(@"CategoryArray :%@",categoryArray);
              for (int j=0; j<categoryArray.count; j++) {
                  NSDictionary *categorydict= [categoryArray[j]mutableCopy];
              //for (NSDictionary *categorydict in categoryArray ) {
                  CategoryData *categoryData=[[CategoryData alloc] initWithDictionary:categorydict];
                  if (!categoryarray) {
                      categoryarray= [NSMutableArray array];
                  }
                      [categoryarray addObject:categoryData];
              }
//                                    NSLog(@"CategoryData: %d",categoryData.categoryId);
//                                    NSLog(@"CategoryData: %@",categoryData.categoryName);
                  for (int i=0; i<delegate.userProfiels.arrSites.count; i++) {
                      SiteData *site=delegate.userProfiels.arrSites[i];
                      if(site.siteId == s_id){
                          site.customCategory =categoryarray;
                          delegate.userProfiels.arrSites[i]=site;
                          break;
                      }
                  }
          }
      }
      UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationBar"];

      [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
      [UIApplication sharedApplication].keyWindow.rootViewController = controller;
  }
  
}


-(void) getProfile:(NSMutableDictionary *) DictData {
      //getting the user profile data
  NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
  
      //iterating user profile data
  NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
  
  User *userData = [[User alloc] initWithDictionary:userProfileData];
  
  AZCAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  delegate.userProfiels = userData;
  
  [self getCustomCategory];

}


#pragma mark Delegate & methods


- (BOOL)checkPin:(NSString *)pinString
{
  if(self.delegate && [self.delegate respondsToSelector:@selector(checkPin:)])
  {
      return [self.delegate checkPin:pinString];
  }
  return NO;
}

- (NSInteger)pinLenght
{
  if([self.delegate respondsToSelector:@selector(pinLenght)])
  {
      return [self.delegate pinLenght];
  }
  return 4;
}

#pragma mark Circles


- (void)addCircles {
  if([self isViewLoaded] && self.delegate) {
      [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
      [_circleViewList removeAllObjects];
      _circleViewList = [NSMutableArray array];
      
      CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
      CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +2);
      CGFloat indent= 1.5* shiftBetweenCircle;
      if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f) {
          shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
          indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
       
      }
      NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setFloat:shiftBetweenCircle forKey:@"XValue"];
      [userDefaults setFloat:indent forKey:@"indent"];
      [userDefaults synchronize];
      for(int i=0; i < [self pinLenght]; i++) {
          PPPinCircleView * circleView = [PPPinCircleView circleView:kVTPinPadViewControllerCircleRadius];
          CGRect circleFrame = circleView.frame;
          circleFrame.origin.x = indent + i * kVTPinPadViewControllerCircleRadius + i*shiftBetweenCircle;
          circleFrame.origin.y = (CGRectGetHeight(_pinCirclesView.frame) - kVTPinPadViewControllerCircleRadius)/2.0f;
          circleView.frame = circleFrame;
          [_pinCirclesView addSubview:circleView];
          [_circleViewList addObject:circleView];
      }
  }
}

- (void)fillingCircle:(NSInteger)symbolIndex {
  
 // [self changeStatusBarHidden:YES];
  
  NSLog(@"%ld",(long)symbolIndex);
  
  
  if(symbolIndex>=_circleViewList.count)
      return;
  PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
  
 //circleView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
  circleView.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
  
  //circleView.backgroundColor = [UIColor blackColor];
  
  
}


-(void)shakeCircles:(UIView *)theOneYouWannaShake
{
  [UIView animateWithDuration:0.03 animations:^
   {
       theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
   }
                   completion:^(BOOL finished)
   {
       if(_shakes >= 15)
       {
           theOneYouWannaShake.transform = CGAffineTransformIdentity;
           [self resetClick:nil];
           return;
       }
       _shakes++;
       _direction = _direction * -1;
       [self shakeCircles:theOneYouWannaShake];
   }];
}



@end
