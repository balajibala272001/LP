//
//  PasscodePinViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/26/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "PasscodePinViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PPPinCircleView.h"
#import "KeychainItemWrapper.h"
#import "SiteViewController.h"
#import "ServerUtility.h"
#import "KeychainItemWrapper.h"
#import "Constants.h"
#import "CognitoHomeViewController.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"
#import "fieldclass.h"
#import "utils.h"
#import "Add_on.h"
#import "Reachability.h"
#import "SCLAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "LanguageManager.h"

#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
    settingMewPinStateFisrt   = 0,
    settingMewPinStateConfirm = 1
};


@interface PasscodePinViewController (){
    NSInteger _shakes;
    NSInteger _direction;
    NSMutableArray *parkloadarray;
    double lat_app;
    double longi_app;
    double radius_app;
    AZCAppDelegate *delegateVC;
}
@property (nonatomic)                   settingNewPinState  newPinState;
@property (nonatomic,strong)            NSString            *fisrtPassCode;
@property (weak, nonatomic) IBOutlet    UILabel             *laInstructionsLabel;

@end
static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;

@implementation PasscodePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //Location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [self geolocation];
    
    [self addGestureRecognizers:_Logout];

    
    isbackground = NO;
    [self addCircles];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];
   _userDetails.hidden = false;
    
    self.SiteVC2 = [[SiteViewController alloc]init];
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
   self. DeviceName = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"DeviceName"];
    NSString *user=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_name"];
    if (user.length==0) {
        user=[[NSUserDefaults standardUserDefaults]objectForKey:@"OfflineUser"];
    }
    self.userName=user;
    self.userDetails.text=[ user uppercaseString];
    _userDetails.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    CGSize expectedLabelSize = [_userDetails.text sizeWithFont:_userDetails.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame = _userDetails.frame;
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

-(void)viewWillAppear:(BOOL)animated{
    [self geolocation];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"PassVC";
    // update
    [[ATAppUpdater sharedUpdater] setDelegate:self];
    [[ATAppUpdater sharedUpdater] updateController:self];
    [[ATAppUpdater sharedUpdater] showUpdateWithConfirmation];
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
    [locationManager requestAlwaysAuthorization];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=locationManager.location.coordinate.latitude;
    coordinate.longitude=locationManager.location.coordinate.longitude;
    NSLog(@"coordinate.longitude:%f",coordinate.longitude);
    NSLog(@"coordinate.latitude:%f",coordinate.latitude);
    lat_app = coordinate.latitude;
    longi_app = coordinate.longitude;
    
        [locationManager stopUpdatingLocation];
    
}//Location

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"ApplicationEnterBackGround"])
    {
       [self viewDidAppear:YES];
        isbackground = YES;
    }
    NSLog (@"Successfully received the test notification!");
}
-(void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    _userDetails.hidden = false;
//    if(isbackground == NO)
//    {
//       //[self addCircles];
//    }else{
//       // [self addCircles];
//    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCancelButtonHidden:(BOOL)cancelButtonHidden{
    _cancelButtonHidden = cancelButtonHidden;
    cancelButton.hidden = cancelButtonHidden;
}

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


- (void) setErrorTitle:(NSString *)errorTitle{
    _errorTitle = errorTitle;
    pinErrorLabel.text = errorTitle;
}

- (void) setPinTitle:(NSString *)pinTitle{
    _pinTitle = pinTitle;
    pinLabel.text = pinTitle;
}


- (IBAction)resetClick:(id)sender {
    [self addCircles];
    self.newPinState    = settingMewPinStateFisrt;
    // _inputPin = @"";
    // _circleViewList = @"";
    
    NSLog(@" the value is:%ld",(long)self.newPinState);
    
    
    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
    _inputPin = [NSMutableString string];
    // NSLog(@" the input string is:%@",_inputPin);
    
    [self changeStatusBarHidden:YES];
    
}

-(void)resetClick
{
    [self addCircles];
    self.newPinState = settingMewPinStateFisrt;
    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
    _inputPin = [NSMutableString string];
    [self changeStatusBarHidden:YES];
}

- (IBAction)numberButtonClick:(id)sender {
    if(!_inputPin) {
        _inputPin = [NSMutableString new];
    }
    if(!_errorView.hidden) {
        [self changeStatusBarHidden:YES];
    }
    [_inputPin appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
    [self fillingCircle:_inputPin.length - 1];
    
    
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
                    
                }else{
                    // reset to first stage
                    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
                    _direction = 1;
                    _shakes = 0;
                    [self changeStatusBarHidden:NO];
                    // [self resetClick:Nil];
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

                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"] !=nil && boolToRestrict  == FALSE){
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
            NSLog(@"denied");
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
    [ServerUtility getUserNameAndUserPin:self.userName withUserPin:_inputPin withOs_name:self.OS withOs_version:self.OsVersion withDevice_name:self.DeviceName withDevice_model:self.DeviceModel withImei:self.UDID withAppversion:self.AppVersion withAppaccessversion:appver withDevicetracker:dt withcorporate:crp withBoolvalue:boolvalue andCompletion:^(NSError *error, id data,float dummy){

        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        delegate.isMaintenance=NO;
        if (!error) {
            
            NSLog(@"The second time login page%@",data);
            NSString *strResType = [data objectForKey:@"res_type"];
            NSString *strMsg = [data objectForKey:@"msg"];
            if ([strResType.lowercaseString isEqualToString:@"error"]) {
                
                _direction = 1;
                _shakes = 0;
                [self shakeCircles:_pinCirclesView];
                [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
                
            }else  {
                
                NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                if ([strResType.lowercaseString isEqualToString:@"success"]){
                    
                    bool corporateLevelplan = YES;
                    NSString *AppAccessVersion = @"";
                    bool DeviceTrackerAccess = NO;
                    int TrackId = 0;
                    int ProfileId = NULL;
                    NSString *default_language = [data objectForKey:@"default_language"];
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
                    
                    NSLog(@"Cor passcode:%d",corporateLevelplan);
                    NSLog(@"AppAccessVersion :%@",AppAccessVersion);
                    NSLog(@"DT passcode :%d",DeviceTrackerAccess);

                    [[NSUserDefaults standardUserDefaults] setBool:corporateLevelplan forKey:@"CorporateLevel"];
                    [[NSUserDefaults standardUserDefaults] setObject:AppAccessVersion forKey:@"AppAccessVersion"];
                    [[NSUserDefaults standardUserDefaults] setBool: DeviceTrackerAccess forKey:@"DeviceTrackerAccess"];
                    [[NSUserDefaults standardUserDefaults] setInteger:TrackId forKey:@"TrackId"];
                    [[NSUserDefaults standardUserDefaults] setInteger: ProfileId forKey:@"ProfileId"];
                    [[NSUserDefaults standardUserDefaults] setBool:boolToRestrict forKey:@"boolToRestrict"];
                    [[NSUserDefaults standardUserDefaults] setObject:default_language forKey:@"default_language"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [LanguageManager setupCurrentLanguage];

                    NSLog(@"PasscodeScreen boolToRestrict:%d",boolToRestrict);
                    
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
                         [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"userName"];
                         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                         [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                         [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
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
                                [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"userName"];
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                                [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                                [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
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
                        [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                        [[NSUserDefaults standardUserDefaults]setValue: self.userName forKey:@"OfflineUser"];
                        [[NSUserDefaults standardUserDefaults]setValue: _inputPin forKey:@"OfflinePin"];
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
                            [self.view makeToast:NSLocalizedString(@"Server Under Maintenance.",@" ")  duration:2.0 position:CSToastPositionCenter];
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
               // strMsg=@"Server Under Maintenance.!\nEnabling Offline Mode";
            }else{
                //strMsg=@"NetWork is Offline.!\nEnabling Offline Mode";
            }
            [self getProfile:DictData];
            
        }else{
            strMsg= NSLocalizedString(@"Incorrect PIN.",@"");
            _direction = 1;
            _shakes = 0;
            [self shakeCircles:_pinCirclesView];
        }
    }else{
        if (delegate.isMaintenance== YES) {
            //strMsg=@"Server Under Maintenance.!\nOffline Data Not Available";
        }else{
           // strMsg=@"NetWork is Offline.!\nOffline Data Not Available";
        }
    }
    [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
}

-(void) getProfile:(NSMutableDictionary *) DictData
{
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //getting the user profile data
    NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
        //iterating user profile data
    NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
        //changes
        //getting new data
    NSMutableArray *newnetwork = [userProfileData objectForKey:@"network-data"];
        //declaring variables for new data
    int  newfieldlength = 0;
    int newfieldid = 0;
    NSString *newfieldlabel;
    int newcount = 0 ;
        //getting old data from app delegate
    
    NSMutableArray *arr = delegate.userProfiels.arrSites;
    self.sites = delegate.userProfiels.arrSites;
    SiteData *sites = delegate.siteDatas;
    NSArray *oldArray = sites.arrFieldData;
    int oldfieldlength = 0;
    int oldfieldid = 0;
    NSString *oldfieldlabel;
    BOOL oldfieldactive = false;
    BOOL oldfieldmandatary = false;
    BOOL newfieldactive = false;
    BOOL newfieldmandatary = false;
    int oldnetworkid = sites.networkId;
    int old_site_id = sites.siteId;
    BOOL networkMatched = NO;
    BOOL siteMatched =  NO;
    int newnetworkid = 0 ;
    int oldcount = (int)oldArray.count;
    if(arr != nil) {
        NSMutableDictionary *newfieldsdata ;
        NSMutableArray *newfieldsdataArray;
        if(sites == nil){
            networkMatched = YES;
            siteMatched = YES;
        }
        for (int j = 0; j<newnetwork.count; j++) {
            newfieldsdata = newnetwork [j];
            newfieldsdataArray = [newfieldsdata objectForKey:@"field_data"];

            newcount = (int) newfieldsdataArray.count;
                    
            NSLog(@" Old netid1:%d",oldnetworkid);
            NSLog(@" New netid1:%d",[[newfieldsdata objectForKey:@"n_id"]intValue]);
            if (oldnetworkid  == [[newfieldsdata objectForKey:@"n_id"]intValue] ) {
                newnetworkid = [[newfieldsdata objectForKey:@"n_id"]intValue];
                networkMatched = YES;
                //siteMatched = YES;
                break;
            }
           
        }
        
        
        if (networkMatched) {
            for (int j = 0; j<newnetwork.count; j++) {
                newfieldsdata = newnetwork [j];
                NSMutableArray *siteArray = [newfieldsdata objectForKey:@"site_data"];
                NSDictionary *newsiteArrayDict;
            
                for (int k =0;k<siteArray.count; k++) {
                    newsiteArrayDict = [siteArray[k] mutableCopy];
                    [newsiteArrayDict setValue:[NSNumber numberWithInt:newnetworkid] forKey:@"n_id"];
                    NSLog(@"old site id: %d",old_site_id);
                    NSLog(@" new site id :%d",[[newsiteArrayDict objectForKey:@"s_id"]intValue]);
                    if (old_site_id == [[newsiteArrayDict objectForKey:@"s_id"]intValue]) {
                        //int new_site_id = [[newsiteArrayDict objectForKey:@"s_id"]intValue];
                        siteMatched = YES;
                        break;
                    }

                }
            }
            
            if (siteMatched) {
                if (oldcount == newcount )  {
                    for (int i = 0;i<oldcount;i++) {
                            //old data -saving old values in variables
                        FieldData *fields1 = oldArray [i];
                        oldfieldlength = fields1.fieldLength;
                        oldfieldid = fields1.fieldId;
                        oldfieldlabel = fields1.strFieldLabel;
                        oldfieldactive = fields1.shouldActive;
                        oldfieldmandatary = fields1.isMandatory;
                            //new data=saving new values in variables
                        NSMutableDictionary *newFieldsDict = newfieldsdataArray [i];
                        newfieldlength = [[newFieldsDict objectForKey:@"f_length"]intValue];
                        newfieldid = [[newFieldsDict objectForKey:@"f_id"]intValue];
                        newfieldlabel = [newFieldsDict objectForKey:@"f_label"];
                        newfieldactive = [[newFieldsDict objectForKey:@"f_active"]boolValue];
                        newfieldmandatary = [[newFieldsDict objectForKey:@"f_mandatary"]boolValue];
                        if ( [oldfieldlabel isEqualToString:newfieldlabel] && oldfieldid == newfieldid && oldfieldlength == newfieldlength &&oldfieldactive == newfieldactive && oldfieldmandatary == newfieldmandatary) {
                                //data matched successfully
                            NSLog(@"Data matched ");
                        } else{
                                
                            NSLog(@"Data not Matched");
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshing" object:nil];
                            User *userData = [[User alloc]initWithDictionary:userProfileData];
                                
                                //site changes
                            SiteData *siteData;
                            for (NSDictionary *dictNetworkData  in newnetwork) {
                                int NetworkId =[[dictNetworkData objectForKey:@"n_id"]intValue];
                                    //create the array of field data
                                NSArray *arrRawFieldData = [dictNetworkData objectForKey:@"field_data"];
                                    //iterate the array and create field data objects array
                                NSMutableArray *arrFieldsData = nil;
                                for (NSDictionary *dictFieldData in arrRawFieldData) {
                                    if (!arrFieldsData) {
                                        arrFieldsData = [NSMutableArray array];
                                    }
                                    FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                                    if (fieldData.active) {
                                       [arrFieldsData addObject:fieldData];
                                    }
                                    
                                }
                                    //Get the raw site data objects
                                NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
                                for (NSDictionary *dictSiteData in arrRawSiteData) {
                                    
                                    siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                                    siteData.networkId = NetworkId;
                                    siteData.arrFieldData = arrFieldsData;
                                    
                                    
                                    if (!self.arrSites) {
                                        self.arrSites = [NSMutableArray array];
                                    }
                                        
                                    [self.arrSites addObject:siteData];
                                        
                                }
                                
                            }
                               
                            AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                            delegate.userProfiels = userData;
                            delegate.siteDatas = siteData;
                            
                            int netid = delegate.siteDatas.networkId;
                            
                            NSLog(@"updated netid:%d",netid);
                            
                                //data not matched
                            break;
                        }
                    }
                } else {
                        //changes
                    SiteData *siteData;
                    for (NSDictionary *dictNetworkData  in newnetwork) {
                        int NetworkId =[[dictNetworkData objectForKey:@"n_id"]intValue];
                            //create the array of field data
                        NSArray *arrRawFieldData = [dictNetworkData objectForKey:@"field_data"];
                            //iterate the array and create field data objects array
                        NSMutableArray *arrFieldsData = nil;
                        for (NSDictionary *dictFieldData in arrRawFieldData) {
                            if (!arrFieldsData) {
                                arrFieldsData = [NSMutableArray array];
                            }
                            FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                            if (fieldData.active) {
                                [arrFieldsData addObject:fieldData];
                            }
                            
                        }
                            //Get the raw site data objects
                        NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
                        for (NSDictionary *dictSiteData in arrRawSiteData) {
                            
                            siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                            siteData.networkId = NetworkId;
                            siteData.arrFieldData = arrFieldsData;
                            
                            
                            if (!self.arrSites) {
                                self.arrSites = [NSMutableArray array];
                            }
                            
                        
                            [self.arrSites addObject:siteData];
                                //}
                        }
                    }
                        //array size not matched
                    User *userData = [[User alloc]initWithDictionary:userProfileData];
                        //  SiteData *sitess = [[SiteData alloc]initWithDictionary:newfieldsdata];
                    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                    delegate.userProfiels = userData;
                    //delegate.siteDatas = siteData;
                    NSLog(@"NO");
                }
                
                
                [self getCustomCategory];

            } else {
                NSLog(@" first ");
        
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"This Network is No Longer Exist, Kindly Contact Admin" delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag = 3;
                [alert show];
            }
        } else {
            NSLog(@"second");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:@"This Network is No Longer Exist, Kindly Contact Admin" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
                //networkMatched = NO;
            NSLog(@"network id not matched");
                ///TODO:move to the login screen
        }
    } else {
            //array is null
        NSLog(@"networkid is nulll while killing the app");
        
            User *userData = [[User alloc]initWithDictionary:userProfileData];
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.userProfiels = userData;
            self.sites = delegate.userProfiels.arrSites;
            SiteData *siteData;
            for (NSDictionary *dictNetworkData  in newnetwork) {
                int NetworkId =[[dictNetworkData objectForKey:@"n_id"]intValue];
                    //create the array of field data
                NSArray *arrRawFieldData = [dictNetworkData objectForKey:@"field_data"];
                    //iterate the array and create field data objects array
                NSMutableArray *arrFieldsData = nil;
                for (NSDictionary *dictFieldData in arrRawFieldData) {
                    if (!arrFieldsData) {
                        arrFieldsData = [NSMutableArray array];
                    }
                    FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                    if (fieldData.active) {
                        [arrFieldsData addObject:fieldData];
                    }
                    
                }
                    //Get the raw site data objects
                NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
                for (NSDictionary *dictSiteData in arrRawSiteData) {
                    
                    siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                    siteData.networkId = NetworkId;
                    siteData.arrFieldData = arrFieldsData;
                    
                    
                    if (!self.arrSites) {
                        self.arrSites = [NSMutableArray array];
                    }
                    
                    
                      
                    [self.arrSites addObject:siteData];
                      
                }
            }
            
            delegate.userProfiels = userData;
            //delegate.siteDatas = siteData;
        [self getCustomCategory];
     
    }
    
    
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        
    }
    else if (alertView.tag == 1)
    {
        
    }
    else if (alertView.tag == 2)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            
            [[AZCAppDelegate sharedInstance] clearCurrentLoad];
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            
            UINavigationController *controller = (UINavigationController*)[self.storyboard
            instantiateViewControllerWithIdentifier: @"StartNavigation"];
            
            [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        }];
    }
    else if (alertView.tag == 3)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            [[AZCAppDelegate sharedInstance] clearCurrentLoad];
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                           instantiateViewControllerWithIdentifier: @"StartNavigation"];
            
            [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        }];
        
        
    }
    
    
}


#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9"))
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}



-(BOOL)prefersStatusBarHidden
{
    return !_errorView.hidden;
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)setIsSettingPinCode:(BOOL)isSettingPinCode
{
    _isSettingPinCode = isSettingPinCode;
    if (isSettingPinCode)
    {
        self.newPinState = settingMewPinStateFisrt;
    }
}


-(NSInteger)pinLenght
{
    return 4;
}


#pragma mark Circles

- (void)addCircles
{
    if([self isViewLoaded])
    {
        [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_circleViewList removeAllObjects];
        _circleViewList = [NSMutableArray array];
       
        CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
        CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +2);
        CGFloat indent= 1.5* shiftBetweenCircle;
        if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f)
        {
            shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
            indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
        }
        for(int i=0; i < [self pinLenght]; i++)
        {
            PPPinCircleView * circleView = [PPPinCircleView circleView:kVTPinPadViewControllerCircleRadius];
            CGRect circleFrame = circleView.frame;
          
            float xvalue = [[NSUserDefaults standardUserDefaults]floatForKey:@"XValue"];
          
                if (xvalue != 0.0 )
                {
                    shiftBetweenCircle = xvalue;
                    indent = [[NSUserDefaults standardUserDefaults]floatForKey:@"indent"];
                }
            
            circleFrame.origin.x = indent + i * kVTPinPadViewControllerCircleRadius + i*shiftBetweenCircle;
            
            circleFrame.origin.y = (CGRectGetHeight(_pinCirclesView.frame) - kVTPinPadViewControllerCircleRadius)/2.0f;
            circleView.frame = circleFrame;
            [_pinCirclesView addSubview:circleView];
            [_circleViewList addObject:circleView];
        }
    }
}



- (void)fillingCircle:(NSInteger)symbolIndex
{
    if(symbolIndex>=_circleViewList.count)
        return;
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
    circleView.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    
}


- (IBAction)Logout:(id)sender
{
    NSMutableDictionary *currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];

     if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
     {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        parkloadarray = [[userDefaults valueForKey:@"ParkLoadArray"] mutableCopy];
         if(parkloadarray!=nil && parkloadarray.count>0)
         {
             if(parkloadarray.count==1)
             {
                 NSMutableDictionary *dict= [[parkloadarray objectAtIndex:0] mutableCopy];
                 NSMutableArray *dictionary=[parkloadarray valueForKey:@"img"];
                 NSMutableArray *imgarr = [dict valueForKey:@"img"];
                 if(currentLotRelatedData!=nil)
                 {
                     [self.view makeToast:NSLocalizedString(@"Please Wait, Uploading On Progress.",@"") duration:2.0 position:CSToastPositionCenter];
                 }
                 else if ([dict valueForKey:@"category"] || (imgarr.count > 0))
                 {
                     [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
                     return;
                 }else if(dictionary==nil && dictionary.count>0){
                     [self.view makeToast:NSLocalizedString(@"A Load is Parked Currently, Kindly Upload or Delete the parked Load to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
                     return;
                 }else
                 {
                     NSString* trackId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
                     NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
                     NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
                     NSString *lat= [NSString stringWithFormat:@"%f", lat_app];
                     NSString *longi= [NSString stringWithFormat:@"%f", longi_app];
                     bool boolvalue;
                     if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
                         boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
                         NSLog(@"boolvalue:%d",boolvalue);
                     }else{
                         boolvalue = FALSE;
                         NSLog(@"boolvalue:%d",boolvalue);
                     }
                     [ServerUtility getdevice_tracker_id:(NSString *)trackId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                         
                    if (!error) {
                            NSLog(@"Logout data:%@",data);
                            NSString *strResType = [data objectForKey:@"res_type"];
                    if ([strResType.lowercaseString isEqualToString:@"success"]){
                        
                     [parkloadarray removeAllObjects];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
                     [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];
                    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ismaster"];
                     [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                     [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                     [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     UINavigationController *controller =(UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                     
                     [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                     [[AZCAppDelegate sharedInstance] clearAllLoads];
                             }
                         }
                             }];
                 }
             }
             else if(currentLotRelatedData!=nil)
             {
                 [self.view makeToast:NSLocalizedString(@"Please Wait, Uploading On Progress.",@"") duration:2.0 position:CSToastPositionCenter];
             }else
             {
                 [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
                 return;
             }
             
         }/*else if(currentLotRelatedData!=nil){
            [self.view makeToast:@"Please wait. Uploading in progress." duration:1.0 position:CSToastPositionCenter];
        }*/else if(delegate.ImageTapcount>0)
        {
            NSMutableArray *dictionary=[parkloadarray valueForKey:@"img"];
                //   if(dictionary==nil && dictionary.count>0){
            [self.view makeToast:NSLocalizedString(@"A Load is Parked Currently, Kindly Upload or Delete the parked Load to Proceed",@"") duration:4.0 position:CSToastPositionCenter];
               
        }else
        {
            NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
            NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
            NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
            NSString *lat= [NSString stringWithFormat:@"%f", lat_app];
            NSString *longi= [NSString stringWithFormat:@"%f", longi_app];
            bool boolvalue;
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
                boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
                NSLog(@"boolvalue:%d",boolvalue);
            }else{
                boolvalue = FALSE;
                NSLog(@"boolvalue:%d",boolvalue);
            }
            NSLog(@"trackerId:%@",trackerId);
            NSLog(@"uid:%@",uid);
            NSLog(@"cid:%@",cid);
            NSLog(@"_latitude:%@",lat);
            NSLog(@"_longitude:%@",longi);
            [ServerUtility getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                
               if (!error) {
                       NSLog(@"Logout data:%@",data);
                       NSString *strResType = [data objectForKey:@"res_type"];
                       if ([strResType.lowercaseString isEqualToString:@"success"]){
                           
                        [parkloadarray removeAllObjects];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
                        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                        [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                        [[AZCAppDelegate sharedInstance] clearAllLoads];
                       }
               }
           }];
        }
    }else
    {
        [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter];
    }
}



-(void)shakeCircles:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
     }completion:^(BOOL finished)
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


- (void) getCustomCategory{
     AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //if ([self isupdate]) {
        
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
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            self.sites = delegate.userProfiels.arrSites;
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
                        }];
                    }else{
                        NSLog(@"%@",msg);
                        
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        [self dismissViewControllerAnimated:YES completion:^{
                            self.sites = delegate.userProfiels.arrSites;
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
                        }];
                    }
                }else{
                    [self.view makeToast:error.localizedFailureReason];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.sites = delegate.userProfiels.arrSites;
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
                    }];
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
            [self dismissViewControllerAnimated:YES completion:^{
                self.sites = delegate.userProfiels.arrSites;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
            }];
        }
}
-(void)addGestureRecognizers:(UIButton *)btn
{
    //longpress
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longpress.delegate = self;
    [_Logout addGestureRecognizer:longpress];
    
}
- (void)longPressed:(UILongPressGestureRecognizer *)longpress
{
    if((self.alertbox == nil) || (![self.alertbox isVisible]))
    {
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    self.textField = [self.alertbox addTextField:nil];
    self.textField.secureTextEntry = YES;
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox addButton:@"OK" target:self selector:@selector(passcheck:) backgroundColor:Green];

    NSLog(@"Text value: %@", self.textField.text);
    
    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:@"Enter Keycode to Force Logout" closeButtonTitle:nil duration:0.0f];
    }
}
-(void)passcheck:(id)sender
{
    if([self.textField.text  isEqual: @"Smart"])
    {
        NSLog(@"correct Password");
        [parkloadarray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
        //[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
            //  [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
        [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        [[AZCAppDelegate sharedInstance] clearAllLoads];
    }else
    {
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Incorrect PIN",@"") closeButtonTitle:nil duration:0.0f];

        NSLog(@"Incorrect PIN");
    }
}
@end
