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
<<<<<<< HEAD
=======
    NSInteger fontPosition;
    UIView *zoomView;
    UIButton *zoombutton;
    UIProgressView *progressLineView;
    NSMutableArray *circleButtons;
    UILabel *label,*label1,*label2;
    CGFloat screenHeight, screenWidth;
    NSInteger selectedIndex;
>>>>>>> main
}
@property (nonatomic)settingNewPinState newPinState;
@property (nonatomic,strong)NSString *fisrtPassCode;
@property (weak, nonatomic) IBOutlet UILabel*laInstructionsLabel;
@end

static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;

@implementation PasscodePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
=======
    [self handleTimer];
    // Load the selected font size from UserDefaults
    fontPosition  = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFontSizePosition"];
    
    // Set border color and width
    _pinCirclesView.layer.borderColor = [UIColor colorWithRed:35/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0].CGColor;
    _pinCirclesView.layer.borderWidth = 1.0;
    _pinCirclesView.layer.cornerRadius = 10.0;
    
>>>>>>> main
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }

    [self.fullpinview setSemanticContentAttribute: UISemanticContentAttributeForceLeftToRight];
<<<<<<< HEAD
=======
    self.fullpinview.backgroundColor = [UIColor colorWithRed:229/255.0 green:231/255.0 blue:233/255.0 alpha:1.0];
>>>>>>> main
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        //Calling Api_SiteMaintenance
        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
        [ServerUtility websiteMaintenance:^(NSError * error ,id data,float dummy){
            if (!error) {
                //Printing the data received from the server
                NSLog(@"PinSCreenData_siteMaintenance:%@",data);
                bool maintenance = [[data objectForKey:@"maintenance"]boolValue];
                int levelInt  = [[data objectForKey:@"level"]intValue];
                NSString *level = [NSString stringWithFormat:@"%d",levelInt];
                if(maintenance == TRUE){
                    if([level isEqualToString: @"1"] || [level isEqualToString: @"1.0"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                    }else if([level isEqualToString: @"2"] || [level isEqualToString: @"2.0"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True2" forKey:@"maintenance_stage"];
                    }else{
                        if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                            [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                            [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                        }
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                }else{
                    if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                        [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                }
            }else{
                NSString *str_error = error.localizedDescription;
                if([str_error containsString:@"404"]){
                    [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                }else{
                    if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                        [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                }
            }
        }];
    }
     //Location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    lat_app = 0.0;
    [self geolocation];
<<<<<<< HEAD
    
=======
    [self fontSize];
>>>>>>> main
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
    self.userName = user;
    self.userDetails.text = [ user uppercaseString];
    _userDetails.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    CGSize expectedLabelSize = [_userDetails.text sizeWithFont:_userDetails.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame = _userDetails.frame;
    // resizing the frame to calculated size
    newFrame.size.height = expectedLabelSize.height;
    
    // put calculated frame into UILabel frame
    _userDetails.frame = newFrame;
<<<<<<< HEAD
    _userDetails.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];

    pinLabel.text = self.pinTitle ? :NSLocalizedString(@"Enter PIN",@"");
=======
    _userDetails.backgroundColor = [UIColor whiteColor];

    pinLabel.text = self.pinTitle ? :NSLocalizedString(@"Enter Pin",@"");
>>>>>>> main
    pinErrorLabel.text = self.errorTitle ? : NSLocalizedString(@"Passcode is not correct",@" ");
    cancelButton.hidden = self.cancelButtonHidden;
    if (self.backgroundImage) {
        backgroundImageView.hidden = NO;
        backgroundImageView.image = self.backgroundImage;
    }
}

<<<<<<< HEAD
=======
-(void)fontSize{
  
    //userDetails
    if (fontPosition == 0){
        _userDetails.font = [UIFont systemFontOfSize:15.0];
    }else if (fontPosition == 1){
        _userDetails.font = [UIFont systemFontOfSize:20.0];
    }else {
        _userDetails.font = [UIFont systemFontOfSize:25.0];
    }
    
    
    //pinLabel
    if (fontPosition == 0){
        pinLabel.font = [UIFont systemFontOfSize:15.0];
    }else if (fontPosition == 1){
        pinLabel.font = [UIFont systemFontOfSize:20.0];
    }else {
        pinLabel.font = [UIFont systemFontOfSize:25.0];
    }
    
    
    //pinerrorLabel
    if (fontPosition == 0){
        pinErrorLabel.font = [UIFont systemFontOfSize:15.0];
    }else if (fontPosition == 1){
        pinErrorLabel.font = [UIFont systemFontOfSize:20.0];
    }else {
        pinErrorLabel.font = [UIFont systemFontOfSize:25.0];
    }
    
    
    //Cancel
    CGFloat fontSize = 15.0; // Default font size
    if (fontPosition == 0) {
        fontSize = 15.0;
    } else if (fontPosition == 1) {
        fontSize = 20.0;
    } else  {
        fontSize = 25.0;
    }
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"Logout" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize] }];
    [_Logout setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    
    //Clear
    if (fontPosition == 0) {
        fontSize = 15.0;
    } else if (fontPosition == 1) {
        fontSize = 20.0;
    } else {
        fontSize = 25.0;
    }
    NSAttributedString *attributedTitle2 = [[NSAttributedString alloc] initWithString:@"Clear" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize] }];
    [resetButton setAttributedTitle:attributedTitle2 forState:UIControlStateNormal];

    //number button 1
     if (fontPosition == 0){
         self.Button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
     }else if (fontPosition == 1){
         self.Button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
     }else {
         self.Button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
     }
    //number button 2
    if (fontPosition == 0){
        self.Button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 3
    if (fontPosition == 0){
        self.Button3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 4
    if (fontPosition == 0){
        self.Button4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 5
    if (fontPosition == 0){
        self.Button5.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button5.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button5.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 6
    if (fontPosition == 0){
        self.Button6.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button6.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button6.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 7
    if (fontPosition == 0){
        self.Button7.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button7.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button7.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 8
    if (fontPosition == 0){
        self.Button8.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button8.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button8.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 9
    if (fontPosition == 0){
        self.Button9.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button9.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button9.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
    //number button 0
    if (fontPosition == 0){
        self.Button0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    }else if (fontPosition == 1){
        self.Button0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:27];
    }else {
        self.Button0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:29];
    }
}

-(void)handleTimer {
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    //zoomView
    self->zoomView = [[UIView alloc]initWithFrame:CGRectMake(30,screenHeight - 85,0,50)];
    self->zoomView.layer.cornerRadius = 15.0;
    self->zoomView.layer.masksToBounds = YES;
    self->zoomView.layer.borderWidth = 1.0;
    self->zoomView.layer.borderColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    self->zoomView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self->zoomView];
    
  // zoomButton
    zoombutton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 80,screenHeight - 60,50,50)];
    [zoombutton setBackgroundImage:[UIImage imageNamed:@"zoom_new.png"] forState:UIControlStateNormal];
    [zoombutton addTarget:self action:@selector(zoomButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoombutton];
    
    // Create labels for zoom percentage
    label = [self createLabelWithText:@"0%" frame:CGRectMake(30, 50, 40, 30)];
    label1 = [self createLabelWithText:@"25%" frame:CGRectMake(130, 50, 40, 30)];
    label2 = [self createLabelWithText:@"50%" frame:CGRectMake(230 , 50, 40, 30)];

    if(fontPosition == 0){
        label.textColor =[UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
    }
   else if(fontPosition == 1){
        label1.textColor =[UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
    }
   else if(fontPosition == 2) {

    label2.textColor =[UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
   }
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomLabelTapped:)]];
    [label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomLabelTapped:)]];
    [label2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomLabelTapped:)]];
    
        // Add labels to zoomView
        [self->zoomView addSubview:label];
        [self->zoomView addSubview:label1];
        [self->zoomView addSubview:label2];
    
}

- (void)addProgressLineAndCirclesInView:(UIView *)view {
    CGFloat progressLineHeight = 2.0;
    CGFloat circleDiameter = 10.0;
    
    // Add progress line
    UIView *progressLine = [[UIView alloc] initWithFrame:CGRectMake(30 + 40 / 2, 30, 230 - 30, progressLineHeight)];
    progressLine.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
    [view addSubview:progressLine];
    
    // Add circles for each label
    NSArray *circleXPositions = @[@25, @125, @225];
    circleButtons = [NSMutableArray array];
    for (NSNumber *xPosition in circleXPositions) {
        UIButton *circleButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosition.floatValue + 40 / 2 - circleDiameter / 2, 25, circleDiameter, circleDiameter)];
        circleButton.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
        circleButton.layer.cornerRadius = circleDiameter / 2;
        circleButton.layer.masksToBounds = YES;
        [circleButton setBackgroundImage:[UIImage imageNamed:@"zoomCircle_fill_new.png"] forState:UIControlStateNormal];
        
        [view addSubview:circleButton];
        [circleButtons addObject:circleButton];
    }
    if(fontPosition == 0){
        [self->circleButtons[0] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
    }
   else if(fontPosition == 1){
       [self->circleButtons[1] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
   }
   else if(fontPosition == 2) {

       [self->circleButtons[2] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
   }
}


- (UILabel *)createLabelWithText:(NSString *)text frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = NSLocalizedString(text, @"");
    label.userInteractionEnabled = YES;
    return label;
}

- (void)zoomLabelTapped:(UITapGestureRecognizer *)sender {
    UILabel *tappedLabel = (UILabel *)sender.view;
     selectedIndex = -1;
    
    for (int i = 0; i < self->circleButtons.count; i++) {
        UIButton *circleButton = self->circleButtons[i];
        [circleButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        if ([tappedLabel.text isEqualToString:@"0%"] && i == 0) {
            selectedIndex = 0;
            tappedLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
            [self->circleButtons[0] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
        } else if ([tappedLabel.text isEqualToString:@"25%"] && i == 1) {
            selectedIndex = 1;
            tappedLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
            [self->circleButtons[1] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
        } else if ([tappedLabel.text isEqualToString:@"50%"] && i == 2) {
            selectedIndex = 2;
            tappedLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
            [self->circleButtons[2] setBackgroundImage:[UIImage imageNamed:@"zoom_circle_new.png"] forState:UIControlStateNormal];
        }
    }
    
    if (selectedIndex != -1) {
        if ([tappedLabel.text isEqualToString:@"0%"]) {
            fontPosition = 0;
            self->progressLineView.progress = 0.0;
     
        } else if ([tappedLabel.text isEqualToString:@"25%"]) {
            fontPosition = 1;
            self->progressLineView.progress = 0.25;
         
        } else {
            fontPosition = 2;
            self->progressLineView.progress = 0.50;
          
        }
    }
       [self fontSize];
    // Save the selected font size to UserDefaults
    [[NSUserDefaults standardUserDefaults] setInteger:fontPosition forKey:@"selectedFontSizePosition"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)zoomButtonTapped:(id)sender {
    CGFloat zoomButtonWidth = 50;

    if (self->zoomView.frame.size.width == 0) {
        {
            [UIView animateWithDuration:0.3 animations:^{
                self->zoomView.frame = CGRectMake(self->screenWidth - (zoomButtonWidth) - 300, self->screenHeight - 85,300, 80);
            }];
        }
        // Change the button image when tapped
        [zoombutton setBackgroundImage:[UIImage imageNamed:@"zoom_in_new.png"] forState:UIControlStateNormal];
        // Display progress line and circles inside zoomView
        [self addProgressLineAndCirclesInView:self->zoomView];
    }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                self->zoomView.frame = CGRectMake(self->screenWidth - (zoomButtonWidth), self->screenHeight - 85, 0, 80);
            }];
        // Change the button image back to original
        [zoombutton setBackgroundImage:[UIImage imageNamed:@"zoom_new.png"] forState:UIControlStateNormal];
    }
}

>>>>>>> main
-(void)getTimeZone:(double)latitude withsecond:(double)longitude {
    NSString *lat = [NSString stringWithFormat:@"%.8lf", latitude];
    NSString *lon = [NSString stringWithFormat:@"%.8lf", longitude];
    [[NSUserDefaults standardUserDefaults] setObject:lat forKey:@"timeZoneLat"];
    [[NSUserDefaults standardUserDefaults] setObject:lon forKey:@"timeZoneLon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ServerUtility getTimeZoneAPiLat:lat lon:lon andCompletion :^(NSError * error ,id data,float dummy){
        if (!error) {
            NSArray *result = [data objectForKey:@"results"];
            if(result != nil && result.count > 0){
                NSDictionary *obj = [result objectAtIndex:0];
                NSDictionary *timeZoneObj = [obj objectForKey:@"timezone"];
                NSString *name =  [timeZoneObj objectForKey:@"name"];
                NSString *timeZone =  [timeZoneObj objectForKey:@"abbreviation_STD"];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"timeZoneName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
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
    NSLog(@"latlong p :%f",coordinate.longitude);
    NSLog(@"latlong p :%f",coordinate.latitude);
    lat_app = coordinate.latitude;
    longi_app = coordinate.longitude;
    
        [locationManager stopUpdatingLocation];
    
}//Location

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

- (void) receiveNotification:(NSNotification *) notification{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"ApplicationEnterBackGround"]){
       [self viewDidAppear:YES];
        isbackground = YES;
    }
    NSLog (@"Successfully received the test notification!");
}


-(void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    _userDetails.hidden = false;
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
                parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                @try{
                    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable
                        //&& (parkloadarray.count <= 0)
                        ){
                        [self validatePin];
                        [self geolocation];
                    }else{
                        
                        bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
                        if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"] !=nil){// && boolToRestrict  == FALSE){
                            NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
                            bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
                            if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
                                AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
                                delegate.isMaintenance=YES;
                                //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                                [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(continuee:)  backgroundColor:Green];
                                [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Down",@"") subTitle:NSLocalizedString(@"Continue with the parkload option. Once the Loadproof cloud is Up, we will notify you to proceed with the uploads.\n 100 loads can be parked per user.",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:1.0f ];

                            }else{
                                [self checkForOffline];
                            }
                        }else if(parkloadarray.count > 0){//&& boolToRestrict  == TRUE){
                            [self checkForOffline];
                        }else{
                            _direction = 1;
                            _shakes = 0;
                            [self shakeCircles:_pinCirclesView];
                            [self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing.",@" ") duration:2.0 position:CSToastPositionCenter];
                        }
                    }
                }@catch (NSException *exception) {
                    NSLog(@"%@",exception.description);
                    [self.view makeToast:@"catch" duration:2.0 position:CSToastPositionCenter];
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

<<<<<<< HEAD


=======
- (IBAction)deletePin:(id)sender {
    if (_inputPin.length > 0) {
        [_inputPin deleteCharactersInRange:NSMakeRange(_inputPin.length - 1, 1)];
        //iterate each number in circleViewList array
        NSInteger pinLength = _inputPin.length;
          for (NSInteger i = 0; i < _circleViewList.count; i++) {
              PPPinCircleView *circleView = _circleViewList[i];
              if (i < pinLength) {
                  circleView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
              } else {
                  circleView.backgroundColor = [UIColor clearColor];
              }
          }
    }
}
>>>>>>> main

-(void) validatePin{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    NSString *appver = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
    bool dt =[[NSUserDefaults standardUserDefaults] boolForKey:@"DeviceTrackerAccess"];
    bool crp =[[NSUserDefaults standardUserDefaults] boolForKey:@"CorporateLevel"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"] && lat_app != 0.0){
        boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolvalue:%d",boolvalue);
    }
    NSString* lat_str = [NSString stringWithFormat:@"%f",lat_app];
    NSString* long_str = [NSString stringWithFormat:@"%f",longi_app];
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
        [ServerUtility getUserNameAndUserPin:self.userName withUserPin:_inputPin withOs_name:self.OS withOs_version:self.OsVersion withDevice_name:self.DeviceName withDevice_model:self.DeviceModel withImei:self.UDID withAppversion:self.AppVersion withAppaccessversion:appver withDevicetracker:dt withcorporate:crp withlat:lat_str withlong:long_str withBoolvalue:boolvalue andCompletion:^(NSError *error, id data,float dummy){
            
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.isMaintenance=NO;
           
            if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineData"] !=nil &&
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineUser"] !=nil &&
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"OfflinePin"] !=nil){
                    delegate.isMaintenance=YES;
                    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(continuee:)  backgroundColor:Green];
                    [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Down",@"") subTitle:NSLocalizedString(@"Continue with the parkload option. Once the Loadproof cloud is Up, we will notify you to proceed with the uploads.\n 100 loads can be parked per user.",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:1.0f ];
                }else{
                    [self.view makeToast:NSLocalizedString(@"WebSite Under Maintenance. Offline mode works only with previously used username.",@"") duration:2.0 position:CSToastPositionCenter];
                }
            }else{
                
                if (!error) {
                    NSString *slat =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
                    NSString *slan =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
                    if(slat != nil){
                        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:[slat doubleValue] longitude:[slan doubleValue]];
                        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:self->lat_app longitude:self->longi_app];
                        CLLocationDistance distanceInMeters = [loc1 distanceFromLocation:loc2];
                        if (distanceInMeters > 1000){
                            if(lat_app > 0){
                                [self getTimeZone:self->lat_app withsecond:self->longi_app];
                            }
                        }
                    }else {
                        if(lat_app > 0){
                            [self getTimeZone:self->lat_app withsecond:self->longi_app];
                        }
                    }
                    NSLog(@"The second time login page%@",data);
                    NSString *strResType = [data objectForKey:@"res_type"];
                    NSString *strMsg = [data objectForKey:@"msg"];
                    if ([strResType.lowercaseString isEqualToString:@"error"]) {
                        
                        self->_direction = 1;
                        self->_shakes = 0;
                        [self shakeCircles:self->_pinCirclesView];
                        if ([strMsg isEqualToString:@"Incorrect userpin"]) {
                            strMsg = NSLocalizedString(@"Incorrect userpin", @" ");
                            [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
                        }else{
                            [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
                        }
                        NSLog(@"strMsg:%@",strMsg);
                    }else{
                        NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                        if ([strResType.lowercaseString isEqualToString:@"success"]){
                            @try {
                            if(self->parkloadarray.count <= 0){

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
                                    
                                }else if([[data objectForKey:@"lat"]  isEqual: @""] || [[data objectForKey:@"long"]  isEqual: @""] || [[data objectForKey:@"radius"]  isEqual: @""]){
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
                                        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(resetClick:) backgroundColor:Green];
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
                              }else {
                                [self checkForOffline];
                            }
                            } @catch (NSException *exception) {
                                NSLog(@"dddd");
                            }
                        }else if ([strResType.lowercaseString isEqualToString:@"maintenance"] ){
                            bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
                            delegate.isMaintenance=YES;
                            //if(boolToRestrict  == FALSE){
                                [self checkForOffline];
                        }else{
                            if([data valueForKey:@"multi_device"]){
                                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                                [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                                NSString *str = [data objectForKey:@"msg"];
                                if([str isEqualToString:@"Incorrect PIN"]){
                                    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Incorrect PIN",@"") closeButtonTitle:nil duration:1.0f ];
                                }else{
                                    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:str closeButtonTitle:nil duration:1.0f ];
                                }
                            }else{
                                [self.view makeToast:NSLocalizedString(@"Try Again",@"") duration:2.0 position:CSToastPositionCenter];
                                _direction = 1;
                                _shakes = 0;
                                [self shakeCircles:_pinCirclesView];
                            }
                        }
                            
                    }
                }else{
                    _direction = 1;
                    _shakes = 0;
                    [self shakeCircles:_pinCirclesView];
                    [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
                }
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}

-(IBAction)continuee:(id)sender {
    [self.alertbox hideView];
    delegateVC.isMaintenance=YES;
    [self checkForOffline];
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
            [self getProfile:DictData];
        }else{
            strMsg= NSLocalizedString(@"Incorrect PIN",@"");
            _direction = 1;
            _shakes = 0;
            [self shakeCircles:_pinCirclesView];
        }
    }
    if ([strMsg isEqualToString:@"Incorrect userpin"]) {
        strMsg = NSLocalizedString(@"Incorrect userpin", @"");
        [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
    }else{
        [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
    }
}


-(void) getProfile:(NSMutableDictionary *) DictData{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //getting the user profile data
    NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
        //iterating user profile data
    NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
        //changes
    //getting new data
    NSMutableArray *newnetwork = [userProfileData objectForKey:@"network-data"];

        //declaring variables for new data
    int newfieldlength = 0;
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
//                        if ( [oldfieldlabel isEqualToString:newfieldlabel] && oldfieldid == newfieldid && oldfieldlength == newfieldlength &&oldfieldactive == newfieldactive && oldfieldmandatary == newfieldmandatary) {
                            if ( [oldfieldlabel isEqualToString:[self htmlEntityDecode:newfieldlabel]] && oldfieldid == newfieldid && oldfieldlength == newfieldlength &&oldfieldactive == newfieldactive && oldfieldmandatary == newfieldmandatary) {
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
                }else{
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
                        }
                    }
                    //array size not matched
                    User *userData = [[User alloc]initWithDictionary:userProfileData];
                    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                    delegate.userProfiels = userData;
                    NSLog(@"NO");
                }
                [self getCustomCategory];

            } else {
                NSLog(@" first ");
        
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"This Network is No Longer Exist, Kindly Contact Admin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
               // alert.tag = 3;
               // [alert show];
            }
        } else {
            NSLog(@"second");
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"This Network is No Longer Exist, Kindly Contact Admin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           // alert.tag = 2;
           // [alert show];
                //networkMatched = NO;
            NSLog(@"network id not matched");
                ///TODO:move to the login screen
        }
    }else{
            //array is null
        NSLog(@"networkid is null while killing the app");
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
        [self getCustomCategory];
    }
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0){
        
    }else if (alertView.tag == 1){
        
    }else if (alertView.tag == 2){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            
            [[AZCAppDelegate sharedInstance] clearCurrentLoad];
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            
            UINavigationController *controller = (UINavigationController*)[self.storyboard
            instantiateViewControllerWithIdentifier: @"StartNavigation"];
            
            [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        }];
    }else if (alertView.tag == 3){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            [[AZCAppDelegate sharedInstance] clearCurrentLoad];
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
            [[[UIApplication sharedApplication].delegate window]setRootViewController:controller];
        }];
    }
}


#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")){
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


-(BOOL)prefersStatusBarHidden{
    return !_errorView.hidden;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)setIsSettingPinCode:(BOOL)isSettingPinCode{
    
    _isSettingPinCode = isSettingPinCode;
    if (isSettingPinCode){
        self.newPinState = settingMewPinStateFisrt;
    }
}


-(NSString *)htmlEntityDecode:(NSString *)string
    {
        string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"

        return string;
}

-(NSInteger)pinLenght{
    return 4;
}


#pragma mark Circles
<<<<<<< HEAD

=======
>>>>>>> main
- (void)addCircles{
    
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
<<<<<<< HEAD
    circleView.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
=======
    circleView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];

>>>>>>> main
    
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
                 }else{
                     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                     [self.alertbox setHorizontalButtons:YES];
                     [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                     [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                     [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
                 }
             }else if(currentLotRelatedData!=nil)
             {
                 [self.view makeToast:NSLocalizedString(@"Please Wait, Uploading On Progress.",@"") duration:2.0 position:CSToastPositionCenter];
             }else
             {
                 [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
                 return;
             }
             
         }else if(delegate.ImageTapcount>0){
             
            NSMutableArray *dictionary=[parkloadarray valueForKey:@"img"];
                //   if(dictionary==nil && dictionary.count>0){
            [self.view makeToast:NSLocalizedString(@"A Load is Parked Currently, Kindly Upload or Delete the parked Load to Proceed",@"") duration:4.0 position:CSToastPositionCenter];
               
        }else
        {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
            [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
        }
    }else
    {
        [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

-(IBAction)signout:(id)sender {

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
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
        [self.view makeToast:NSLocalizedString( @"Server Under Maintenance",@"") duration:4.0 position:CSToastPositionCenter];

    }else {
        NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
        NSMutableDictionary *dictionary = [[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTracker"] mutableCopy];
        NSMutableArray* deviceData = [dictionary valueForKey:@"device_offline_details"];
        if(dictionary != nil && trackerId != nil && ![trackerId isEqual:@"0"] && ![trackerId isEqual:@"0.0"]){
            [ServerUtility getdevice_tracker:(NSString *)trackerId withOfflinedata:(NSArray *) deviceData withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                
                if (!error) {
                    NSLog(@"Logout data:%@",@"done");
                }
            }];
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
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"timeZoneName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    UINavigationController *controller =(UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                    
                    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                    [[AZCAppDelegate sharedInstance] clearAllLoads];
                }
            }
        }];
    }
}

-(void)shakeCircles:(UIView *)theOneYouWannaShake{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
     }completion:^(BOOL finished){
         if(_shakes >= 15){
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
    parkloadarray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];

    if(parkloadarray.count <=0){
        
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
            bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
            if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
                [self offlineCustomCat];
            }else{
                //mythiCategory
                NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
                NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
                [ServerUtility getCid:cid withUid:uid andCompletion:^(NSError * error ,id data,float dummy){
                    
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
                            [self saveDeviceLastSeen];
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
            }
        }else{
            [self offlineCustomCat];
        }
    }else{
        [self offlineCustomCat];
    }
}

-(void)offlineCustomCat{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
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

-(void)addGestureRecognizers:(UIButton *)btn{
    //longpress
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longpress.delegate = self;
    [_Logout addGestureRecognizer:longpress];
}

- (void)longPressed:(UILongPressGestureRecognizer *)longpress{
    
    if((self.alertbox == nil) || (![self.alertbox isVisible])){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        self.textField = [self.alertbox addTextField:nil];
        self.textField.secureTextEntry = YES;
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@" ") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(passcheck:) backgroundColor:Green];
        NSLog(@"Text value: %@", self.textField.text);
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@" ") subTitle:NSLocalizedString(@"Enter Keycode to Force Logout",@"") closeButtonTitle:nil duration:0.0f];
    }
}

-(void)saveDeviceLastSeen{
    //one time entry only happen from this VC, 20 Sec once entry call from appdelegate
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
        NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
        NSString * accessVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
        NSString * corpid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CorporateLevel"];
        bool boolvalue;
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
            boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
            NSLog(@"boolSingle:%d",boolvalue);
        }else{
            boolvalue = FALSE;
            NSLog(@"boolSingle:%d",boolvalue);
        }
        [ServerUtility deviceLastseenWithCid:cid withUid:uid withcorpid:corpid withaccessVersion:accessVersion withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
            AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
            delegate.isMaintenance=NO;
            if (!error)
            {
                NSLog(@"App delegate data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    NSLog(@"currentVC:%@",delegate.CurrentVC);
                    NSLog(@"newDateString2:%@",strResType);
                }
//                else{
//                    if([data valueForKey:@"multi_device"]){
//                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
//                        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
//                        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"] subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:-100 ];
//                    }else{
//                        NSLog(@"Error:%@",error);
//                    }
//                }
            }
        }];
    }
}



-(void)passcheck:(id)sender
{
    if([self.textField.text  isEqual: @"Smart"]){
        
        NSLog(@"correct Password");
        [parkloadarray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
        [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        [[AZCAppDelegate sharedInstance] clearAllLoads];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Incorrect PIN",@"") closeButtonTitle:nil duration:0.0f];

        NSLog(@"Incorrect PIN");
    }
}
@end
