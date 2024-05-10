#define FONT_SIZE 16
#define FONT_HELVETICA @"Helvetica"
#import "CognitoHomeViewController.h"
#import "PasscodeViewController.h"
#import "PicViewController.h"
#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "KeychainItemWrapper.h"
#import "PPPinPadViewController.h"
#import "AboutViewController.h"
#import "ServerUtility.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"
#import "utils.h"
#import "Reachability.h"
#import "StaticHelper.h"
#import "SiteViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface CognitoHomeViewController ()<UIPopoverPresentationControllerDelegate> {
    popViewController *popoverViewController;
    NSArray *array01;
    double lat_app;
    double longi_app;
}
@end


@implementation CognitoHomeViewController

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [self geolocation];

    
    self.UserName_txt.delegate = self;
    self.UserName_txt.keyboardType = bold;
    
    self.UserName_txt.layer.cornerRadius =10;
    self.UserName_txt.layer.borderWidth = 1;
    self.UserName_txt.layer.borderColor = [UIColor blackColor].CGColor;
    self.Login_ok_pressed.layer.cornerRadius =10;
    self.Login_ok_pressed.layer.borderWidth =1;
    self.Login_ok_pressed.layer.borderColor = [UIColor blackColor].CGColor;
   
    self.Background_View.layer.cornerRadius = 10;
    self.Background_View.layer.borderWidth = 1;
    self.Background_View.layer.borderColor = [UIColor blackColor].CGColor;
    self.UserName_txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *strVersionString = [NSString stringWithFormat:@"v%@(%@)",appVersionString,appBuildString];
    
    NSString*myNSString = @"By Logging in you agree to the Terms & Conditions & Privacy Policy with Smart Gladiator";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = FONT_SIZE/3;
    UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
   // UIColor * labelColor = [UIColor colorWithWhite:1 alpha:1];
    NSShadow *shadow = [[NSShadow alloc] init];
  //  [shadow setShadowColor : BLACK_SHADOW];
    [shadow setShadowOffset : CGSizeMake (1.0, 1.0)];
    [shadow setShadowBlurRadius : 1];
    
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString : myNSString
            attributes : @{
            NSParagraphStyleAttributeName : paragraphStyle,
            NSFontAttributeName : labelFont}];
    NSURL *URL1 = [NSURL URLWithString: @"https://loadproof.com/terms-conditions/"];
    NSURL *URL2 = [NSURL URLWithString: @"https://loadproof.com/privacy-policy/"];
    
    [labelText addAttribute: NSLinkAttributeName value:URL1 range: NSMakeRange(31, 19)];
    [labelText addAttribute: NSLinkAttributeName value:URL2 range: NSMakeRange(52, 14)];
    [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0] range:NSMakeRange(31, 19)];
    [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0] range:NSMakeRange(52, 14)];
    _linkTextView.linkTextAttributes =                                @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
    NSForegroundColorAttributeName:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0]};
    _linkTextView.attributedText = labelText;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NSString *str;
    
    str = [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"];
    NSLog(@"strrr%@:",str);
}

//location
-(void)allowLocationAccess
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox addButton:@"Settings" target:self selector:@selector(setting:) backgroundColor:Green];
    [self.alertbox showSuccess:@"Warning!" subTitle:@"Turn ON Location Permission to Continue..." closeButtonTitle:nil duration:1.0f ];
}
-(IBAction)setting:(id)sender{
    [self.alertbox hideView];

    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {if (success) {NSLog(@"Opened url");}
    }];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
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




- (IBAction)logoTap:(UIButton *)sender
{
        [self.view makeToast:@"Long click" duration:1.0 position:CSToastPositionCenter];
    
        if(popoverViewController == nil)
        {
            popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"popover"];
        }

        popoverViewController.preferredContentSize = CGSizeMake(320, 300);
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popoverController = popoverViewController.popoverPresentationController;
        popoverController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
        popoverController.delegate = self;
        popoverController.sourceView = self.view;
        popoverController.sourceRect = [sender frame];

        [self presentViewController:popoverViewController animated:YES completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}



//****************************************************
#pragma mark - Action Methods
//****************************************************

- (IBAction)login_ok:(UIButton *)sender
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self geolocation];
    [self.UserName_txt resignFirstResponder];
    NSString *strUsername = self.UserName_txt.text;
    NSString *trimmedString = [strUsername stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"username: %@",trimmedString);
    if (trimmedString.length == 0) {
        [self.view makeToast:@"Username is Empty" duration:1.0 position:CSToastPositionCenter];
    }else{
        [self checkForOffline: (trimmedString)];
    }
    }else if(status == kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted ) {
        NSLog(@"denied");
        [self allowLocationAccess];
    }
}

#pragma delegate methods for next vc

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
}

- (NSInteger)pinLenght {
    return 4;
}

//****************************************************
#pragma mark - UITextFieldDelegate Methods
//****************************************************

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    NSString *strUsername = self.UserName_txt.text;
    NSString *trimmedString = [strUsername stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0) {
        [self.view makeToast:@"Username is Empty" duration:1.0 position:CSToastPositionCenter];}
    else{
        
        NSString *string = self.UserName_txt.text;
        
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        if (trimmedString.length == 0) {
            
            [StaticHelper showAlertWithTitle:nil message:@"Invalid Username" onViewController:self];
        }
        else{
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                [self geolocation];
            [self checkForOffline: (trimmedString)];
            } else if(status == kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted ) {
                    NSLog(@"denied");
                    [self allowLocationAccess];
                }
        }
    }
    return YES;
}

-(void)checkForOffline: (NSString *) strUsername{
    
    //if([utils isNetworkAvailable] ==YES){
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self callApi:(strUsername)];
    }else{
        NSString *temp_User=[[NSUserDefaults standardUserDefaults]
                             stringForKey:@"OfflineUser"];
        if (temp_User != nil || temp_User.length>0) {
            
            if ([temp_User isEqualToString: strUsername]) {
                PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                pinViewController.self.userName = strUsername;
                pinViewController.delegate = self;
                pinViewController.pinTitle = @"Enter PIN";
                pinViewController.errorTitle = @"Passcode is not correct";
                pinViewController.cancelButtonHidden = NO; //default is False
                pinViewController.backgroundImage = [UIImage imageNamed:@""];
                    // [pinViewController setTintColor:[UIColor redColor]];
                [self.navigationController pushViewController:pinViewController
                                                     animated:YES];
            }else{
                [self.view makeToast:@"Internet Connectivity Missing.\nOffline mode works only with previously used username." duration:1.0 position:CSToastPositionCenter];
            }
        }else if(temp_User.length==0){
            [self.view makeToast:@"Network is Offline!\n No Offline data available." duration:1.0 position:CSToastPositionCenter];
        }
    }
}
-(void)callApi: (NSString *)strUsername {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf =self;
    [[NSUserDefaults standardUserDefaults]setObject:NULL forKey:@"TokenID"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL forKey:@"TokenValue"];
    [ServerUtility getUserName:strUsername andCompletion:^(NSError * error ,id data,float dummy){
        AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
        delegate.isMaintenance=NO;
        if (!error) {
                //Printing the data received from the server
            NSLog(@" the data are:%@",data);
            
           
            NSString *strResType = [data objectForKey:@"res_type"];
            if ([strResType.lowercaseString isEqualToString:@"error"])
            {
                NSString *strMsg = [data objectForKey:@"msg"];
                [self.view makeToast:strMsg duration:1.0 position:CSToastPositionCenter];
            }else {
                PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"token_id"] forKey:@"TokenID"];
                    [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"token_value"] forKey:@"TokenValue"];
                    [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"app_access_version"] forKey:@"AppAccessVersion"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"AppAccessVersion :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"]);

                    NSLog(@"msg:%@",[data objectForKey:@"msg"]);
                    if([data valueForKey:@"lat"] && [data valueForKey:@"long"] && [data valueForKey:@"radius"]){
                        bool boolvalue = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLocation"];
                        NSLog(@"boolvalue home:%d",boolvalue);
                        if (boolvalue == TRUE){
                            pinViewController.self.userName = strUsername;
                            pinViewController.delegate = self;
                            pinViewController.pinTitle = @"Enter PIN";
                            pinViewController.errorTitle = @"Passcode is not correct";
                            pinViewController.cancelButtonHidden = NO; //default is False
                            pinViewController.backgroundImage = [UIImage imageNamed:@""];
                            [self.navigationController pushViewController:pinViewController
                                                                 animated:YES];
                        }
                   else if([[data objectForKey:@"lat"]  isEqual: @""] || [[data objectForKey:@"long"]  isEqual: @""] || [[data objectForKey:@"radius"]  isEqual: @""]){
                
                    pinViewController.self.userName = strUsername;
                    pinViewController.delegate = self;
                    pinViewController.pinTitle = @"Enter PIN";
                    pinViewController.errorTitle = @"Passcode is not correct";
                    pinViewController.cancelButtonHidden = NO; //default is False
                    pinViewController.backgroundImage = [UIImage imageNamed:@""];
                    [self.navigationController pushViewController:pinViewController
                                                         animated:YES];
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
                    pinViewController.self.userName = strUsername;
                    pinViewController.delegate = self;
                    pinViewController.pinTitle = @"Enter PIN";
                    pinViewController.errorTitle = @"Passcode is not correct";
                    pinViewController.cancelButtonHidden = NO; //default is False
                    pinViewController.backgroundImage = [UIImage imageNamed:@""];
                    [self.navigationController pushViewController:pinViewController animated:YES];
                }else{
                    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
                     [self.alertbox showSuccess:@"Warning!" subTitle:@"Please login from authorized location." closeButtonTitle:nil duration:1.0f ];
                    }
                    }
                    }else{
                    pinViewController.self.userName = strUsername;
                    pinViewController.delegate = self;
                    pinViewController.pinTitle = @"Enter PIN";
                    pinViewController.errorTitle = @"Passcode is not correct";
                    pinViewController.cancelButtonHidden = NO; //default is False
                    pinViewController.backgroundImage = [UIImage imageNamed:@""];
                    [self.navigationController pushViewController:pinViewController
                                                         animated:YES];
                    }
                }else if ([strResType.lowercaseString isEqualToString:@"maintenance"]){
                    delegate.isMaintenance=YES;
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineUser"] !=nil){
                        NSString *userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineUser"];
                        
                        if ([userName isEqualToString:strUsername]) {
                            pinViewController.self.userName = strUsername;
                            pinViewController.delegate = self;
                            pinViewController.pinTitle = @"Enter PIN";
                            pinViewController.errorTitle = @"Passcode is not correct";
                            pinViewController.cancelButtonHidden = NO; //default is False
                            pinViewController.backgroundImage = [UIImage imageNamed:@""];
                                // [pinViewController setTintColor:[UIColor redColor]];
                            [self.navigationController pushViewController:pinViewController
                                                                 animated:YES];
                        }else{
                            [self.view makeToast:@"Internet Connectivity Missing.\nOffline mode works only with previously used username." duration:1.0 position:CSToastPositionCenter];
                        }
                    }else{
                        [self.view makeToast:@"Internet Connectivity Missing." duration:1.0 position:CSToastPositionCenter];
                    }
                }
            }
        }
        else{
            [self.view makeToast:@"Error" duration:1.0 position:CSToastPositionCenter];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}


@end
