//
//  SiteViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/19/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "SiteViewController.h"
#import "SiteTableViewCell.h"
#import "CameraViewController.h"
#import "StaticHelper.h"
#import "AZCAppDelegate.h"
#import "SiteData.h"
#import "Constants.h"
#import "Reachability.h"
#import "LoadSelectionViewController.h"
#import "UIView+Toast.h"
#import "SCLAlertView.h"
#import "Add_on.h"
#import "ServerUtility.h"
#import <CoreLocation/CoreLocation.h>
#import "CaptureScreenViewController.h"
#import "GalleryViewController.h"
#import "Looping_Camera_ViewController.h"
#import "Add_on_8.h"
#import "GalleryLoopViewController.h"
#import "CategoryViewController.h"
<<<<<<< HEAD
=======
#import <QuartzCore/QuartzCore.h>
>>>>>>> main

@interface SiteViewController ()<UIPopoverControllerDelegate>{
    
    CaptureScreenViewController *capture;
    GalleryViewController *galleryVC;
    AZCAppDelegate *delegateVC;
    ServerUtility * imge;
    bool isLogin;
    bool hasAddon8;
    bool hasCustomCategory;
    bool isImgeAvailableAllsteps;
<<<<<<< HEAD
=======
    NSInteger limitCount;
    UILabel *titleLabel;
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
@end

@implementation SiteViewController
    @synthesize btn;
    @synthesize simple_tbleView;
    @synthesize i;
<<<<<<< HEAD
    
- (void)viewDidLoad {
    @try{
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        }

        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.instructData = delegate.userProfiels.instruct.instructData;
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"]){
            self.currentTappiCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"]intValue];
            self.instruction_number = [[[NSUserDefaults standardUserDefaults]valueForKey:@"img_instruction_number"]intValue];
        }
        NSLog(@"Arr1:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]);
        self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
        if(![[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]){
            [[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"ArrCount"];
            NSLog(@"Arr2:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]);
        }
        
        [super viewDidLoad];
        [self geolocation];
        
        isLogin = false;
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(sitesArr:) name:@"sites" object:nil];
        
        self.sitesNameArr = delegate.userProfiels.arrSites;
        [self.simple_tbleView reloadData];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationItem.title = NSLocalizedString(@"Site Selection",@"");
        //self.navigationItem.hidesBackButton = YES;
        
        self.sub_view.layer.cornerRadius = 10;
        self.sub_view.layer.borderWidth = 1;
        self.sub_view.layer.borderColor = Blue.CGColor;
        self.simple_tbleView.layer.borderWidth = 1.0;
        self.simple_tbleView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
        
        self.btn.layer.cornerRadius=8;
        simple_tbleView.layer.cornerRadius=8;
        // NSLog(@" the sites are:%@",self.sitesNameArr);
        // Do any additional setup after loading the view.
        
        UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [logout setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
        if (self.movetolc) {
            [self moveToLoadSelection];
        }
        if(self.movetoCp){
            [self moveToCaptureScreen];
        }
        if(!isLogin){
            NSIndexPath *ip = 0;
            if (self.sitesNameArr.count == 1) {
                [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
            }
        }
    }@catch (NSException *exception) {
       // [self.view makeToast:NSLocalizedString(@"exception.description",@"") duration:2.0 position:CSToastPositionCenter style:nil];

        NSLog(@"%@",exception.description);
    }
}


-(void)geolocation{
    
    ceo = [[CLGeocoder alloc]init];
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc]init];
    }
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    self.latitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    [locationManager stopUpdatingLocation];
    NSLog(@"latlong h %@", self.latitude);
    NSLog(@"latlong h %@", self.longitude);
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
       // [self handleTimer];
}


-(void)handleTimer {
    
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(0,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(190,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(190,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Site Selection",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
    //internet_indicator
    bool isOrange = false;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        isOrange = false;
        [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
            //RGBA ( 0 , 174 , 7 , 100 )
        NSLog(@"Network Connection available");
    }else{
        isOrange = true;
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
    }
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [cloud_indicator setBackgroundImage: [UIImage imageNamed:@"orangecloud.png"] forState:UIControlStateNormal];
    }else if([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable && !isOrange){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greencloud.png"]  forState:UIControlStateNormal];
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greycloud.png"]  forState:UIControlStateNormal];
    }
    
=======
    
- (void)viewDidLoad {
    @try{
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            limitCount = 20;
        }else {
            limitCount = 15;
        }
        
        if (@available(iOS 13.0, *)) {
            UIView *statusBarBackgroundView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
            statusBarBackgroundView.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
            [[UIApplication sharedApplication].keyWindow addSubview:statusBarBackgroundView];
        }

        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.instructData = delegate.userProfiels.instruct.instructData;
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"]){
            self.currentTappiCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"]intValue];
            self.instruction_number = [[[NSUserDefaults standardUserDefaults]valueForKey:@"img_instruction_number"]intValue];
        }
        NSLog(@"Arr1:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]);
        self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
        if(![[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]){
            [[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"ArrCount"];
            NSLog(@"Arr2:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]);
        }
        
        [super viewDidLoad];
        [self geolocation];
        [self fontSize];
        
       // Load the selected font size from UserDefaults
        fontPosition = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFontSizePosition"];
        
        isLogin = false;
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(sitesArr:) name:@"sites" object:nil];
        
        self.sitesNameArr = delegate.userProfiels.arrSites;
        [self.simple_tbleView reloadData];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationItem.title = NSLocalizedString(@"Site Selection",@"");
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];



        //self.navigationItem.hidesBackButton = YES;
        
        //self.sub_view.layer.cornerRadius = 10;
        //self.sub_view.layer.borderWidth = 1;
        //self.sub_view.layer.borderColor = Blue.CGColor;
        //self.simple_tbleView.layer.borderWidth = 1.0;
        //self.simple_tbleView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
        //self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
        
        self.btn.layer.cornerRadius=8;
        simple_tbleView.layer.cornerRadius=8;
        // NSLog(@" the sites are:%@",self.sitesNameArr);
        // Do any additional setup after loading the view.
        
        UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [logout setBackgroundImage:[UIImage imageNamed:@"logout_new.png"] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
        
        if (self.movetolc) {
            [self moveToLoadSelection];
        }
        if(self.movetoCp){
            [self moveToCaptureScreen];
        }
        if(!isLogin){
            NSIndexPath *ip = 0;
            if (self.sitesNameArr.count == 1) {
                [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
            }
        }
        UIColor *color = [self colorFromHexString:@"#f8f8f8"];

        self.simple_tbleView.backgroundColor = color;
        
        self.view.backgroundColor = color;
        [self.simple_tbleView reloadData];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(self.sitesNameArr.count >= 20){
                self.simple_tbleView.backgroundColor =[UIColor whiteColor];
                self.simple_tbleView.layer.cornerRadius = 20.0;
            }
        }else {
            if(self.sitesNameArr.count >= 15){
                self.simple_tbleView.backgroundColor =[UIColor whiteColor];
                self.simple_tbleView.layer.cornerRadius = 20.0;
            }
        }
        
    }@catch (NSException *exception) {
       // [self.view makeToast:NSLocalizedString(@"exception.description",@"") duration:2.0 position:CSToastPositionCenter style:nil];

        NSLog(@"%@",exception.description);
    }
}


-(void)geolocation{
    
    ceo = [[CLGeocoder alloc]init];
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc]init];
    }
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    self.latitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    [locationManager stopUpdatingLocation];
    NSLog(@"latlong h %@", self.latitude);
    NSLog(@"latlong h %@", self.longitude);
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
       // [self handleTimer];
}

-(void)fontSize
{
    //font size for title
    if (fontPosition == 0){
         titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }else if (fontPosition == 1){
         titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }else {
         titleLabel.font = [UIFont boldSystemFontOfSize:19.0];
    }
}

-(void)handleTimer {
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 130,10,20,20)];
        }else {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,10,15,15)];
        }
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 10.0;
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 100,8,25,25)];
        }else {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 100,8,20,20)];
        }
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw/2 - 160,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Site Selection",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, sw, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
    //internet_indicator
    bool isOrange = false;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        isOrange = false;
        [networkStater setBackgroundImage:[UIImage imageNamed:@"internet_on_new.png"]  forState:UIControlStateNormal];
        //networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.082 green: 0.721 blue: 0.305 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
        //networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
            //RGBA ( 0 , 174 , 7 , 100 )
        NSLog(@"Network Connection available");
    }else{
        isOrange = true;
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"internet_off_new.png"]  forState:UIControlStateNormal];
        //networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
        //networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
    }
    networkStater.layer.borderColor = [UIColor colorWithRed: 1.00 green: 1.0 blue: 1.0 alpha: 1.00].CGColor;
    networkStater.layer.borderWidth = 1.0;
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [cloud_indicator setBackgroundImage: [UIImage imageNamed:@"cloud_orange_new.png"] forState:UIControlStateNormal];
    }else if([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable && !isOrange){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"cloud_green_new.png"]  forState:UIControlStateNormal];
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"cloud_gray_new.png"]  forState:UIControlStateNormal];
    }

>>>>>>> main
    //cloud_indicator
    [cloud_indicator addTarget:self action:@selector(cloud_poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cloud_indicator];
    
    //internet_indicator
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    self.navigationItem.titleView = view;
<<<<<<< HEAD
}

=======
  
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
   
   //zoomView
   zoomView = [[UIView alloc]initWithFrame:CGRectMake(30,screenHeight - 100,0,80)];
   zoomView.layer.cornerRadius = 15.0;
   zoomView.layer.masksToBounds = YES;
   zoomView.layer.borderWidth = 1.0;
   zoomView.layer.borderColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
   zoomView.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:zoomView];
   
 // zoomButton
   zoombutton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 80,screenHeight - 80,50,50)];
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
       
       // Save the selected font size and label circle to UserDefaults
       [[NSUserDefaults standardUserDefaults] setInteger:fontPosition forKey:@"selectedFontSizePosition"];
       [[NSUserDefaults standardUserDefaults] synchronize];
   }
   [self fontSize];
   [self.simple_tbleView reloadData];
  
}

- (void)zoomButtonTapped:(id)sender {
   CGFloat zoomButtonWidth = 50;

   if (self->zoomView.frame.size.width == 0) {
       {
           [UIView animateWithDuration:0.3 animations:^{
               self->zoomView.frame = CGRectMake(self->screenWidth - (zoomButtonWidth) - 300, self->screenHeight - 100,300, 80);
           }];
       }
       // Change the button image when tapped
       [zoombutton setBackgroundImage:[UIImage imageNamed:@"zoom_in_new.png"] forState:UIControlStateNormal];
       // Display progress line and circles inside zoomView
       [self addProgressLineAndCirclesInView:self->zoomView];
   }
       else{
           [UIView animateWithDuration:0.3 animations:^{
               self->zoomView.frame = CGRectMake(self->screenWidth - (zoomButtonWidth), self->screenHeight - 100, 0, 80);
           }];
       // Change the button image back to original
       [zoombutton setBackgroundImage:[UIImage imageNamed:@"zoom_new.png"] forState:UIControlStateNormal];
   }
}


>>>>>>> main
-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Offline, proceed with Parkloads.",@"");
    }else if ([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Online, proceed with the uploads.",@"");
    }else{
        stat= NSLocalizedString(@"Network Not Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
         stat= NSLocalizedString(@"Network Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}
<<<<<<< HEAD

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


=======

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


>>>>>>> main
-(IBAction)logout:(id)sender {
    
   self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
   if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
        [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
    }else{
        [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
<<<<<<< HEAD
    [self.simple_tbleView reloadData];
=======
    // Set corner radius
    self.simple_tbleView.layer.cornerRadius = 20.0; // Adjust the value to your preference
    self.simple_tbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Add shadow
    // Set shadow properties
    self.simple_tbleView.layer.shadowColor = [UIColor blackColor].CGColor; // Shadow color
    self.simple_tbleView.layer.shadowOpacity = 0.5; // Shadow opacity
    self.simple_tbleView.layer.shadowOffset = CGSizeMake(0, 2); // Shadow offset
    self.simple_tbleView.layer.shadowRadius = 4; // Shadow radius

    // Optionally, if you want to add a shadow path for performance optimization
    self.simple_tbleView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.simple_tbleView.bounds].CGPath;
    [self.simple_tbleView reloadData];
   // [self.simple_tbleView sizeToFit];

>>>>>>> main
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"SiteVC";
    
    //Calling Api_SiteMaintenance
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self handleTimer];
        [ServerUtility websiteMaintenance:^(NSError * error ,id data,float dummy){
            if (!error) {
                //Printing the data received from the server
                bool maintenance = [[data objectForKey:@"maintenance"]boolValue];
                int levelInt  = [[data objectForKey:@"level"]intValue];
                NSString *level = [NSString stringWithFormat:@"%d",levelInt];
                if(maintenance == TRUE){
                    if([level isEqualToString: @"1"] || [level isEqualToString: @"1.0"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                    }else if([level isEqualToString: @"2"] || [level isEqualToString: @"2.0"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True2" forKey:@"maintenance_stage"];
                    }else{
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                }
            }else{
                NSString *str_error = error.localizedDescription;
                if([str_error containsString:@"404"]){
                    [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                }
            }
            [self handleTimer];
        }];
    }else{
        [self handleTimer];
    }
<<<<<<< HEAD
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
}

=======
    //self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // skip the #
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0
                           alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
}

>>>>>>> main
-(IBAction)signout:(id)sender {
    
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ismaster"];
    NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
    NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
    NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
        boolvalue = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolvalue:%d",boolvalue);
    }
    NSLog(@"trackerId:%@",trackerId);
    NSLog(@"uid:%@",uid);
    NSLog(@"cid:%@",cid);
    NSLog(@"_latitude:%@",_latitude);
    NSLog(@"_longitude:%@",_longitude);
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
        [self.view makeToast:NSLocalizedString( @"Server Under Maintenance",@"") duration:4.0 position:CSToastPositionCenter];

    }else {
        NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
        NSMutableDictionary *dictionary = [[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTracker"] mutableCopy];
        NSMutableArray* deviceData = [dictionary valueForKey:@"device_offline_details"];
        if(dictionary != nil && trackerId != nil && ![trackerId isEqual:@"0"] && ![trackerId isEqual:@"0.0"]){
            [ServerUtility getdevice_tracker:(NSString *)trackerId withOfflinedata:(NSArray *) deviceData withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)_latitude withlongi:(NSString *)_longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                
                if (!error) {
                    NSLog(@"Logout data:%@",@"done");
                }
            }];
        }
            [ServerUtility getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)_latitude withlongi:(NSString *)_longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                
                if (!error) {
                    NSLog(@"Logout data:%@",data);
                    NSString *strResType = [data objectForKey:@"res_type"];
                    if ([strResType.lowercaseString isEqualToString:@"success"]){
                        
                        [self.alertbox hideView];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"deviceTracker"];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_name"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"timeZoneLat"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"timeZoneLon"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"timeZoneName"];
                        
                        UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
                        [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                        [[AZCAppDelegate sharedInstance] clearAllLoads];
                    }
                }
            }];
    }
}


-(void) checkForPendingUpload {
    
    NSLog(@"navigationController %lu",(unsigned long)self.navigationController.viewControllers.count);
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (self.navigationController.viewControllers.count == 1 ) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]) {
            int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
            SiteData *site;
            if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                if (filteredArray.count == 1) {
                    site = [filteredArray objectAtIndex:0];
                    if(site!=NULL){
                        [[NSUserDefaults standardUserDefaults] setObject:site.image_quality forKey:@"image_quality"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
            if([[AZCAppDelegate sharedInstance] hasCurrentLoad]){
                UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
                UploadVC.uploadDelegate = self;
                UploadVC.image_quality=site.image_quality;
                UploadVC.siteData=site;
                UploadVC.sitename = site.siteName;
                [self.navigationController pushViewController:UploadVC animated:YES];
            }else if([[AZCAppDelegate sharedInstance]                 hasParkedLoad:delegate.userProfiels.instruct.instructData != nil && delegate.userProfiels.instruct.instructData.count >0]) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
                    SiteData *site;
                    if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                        NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                        if (filteredArray.count == 1) {
                            site = [filteredArray objectAtIndex:0];
                        }
                    }
                    if (site != nil) {
                        int loadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
                        if (loadnumber>-1) {
                            NSMutableArray *loadArray= [[NSMutableArray alloc] init];
                            loadArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy ];
                            if (loadArray.count>0) {
                                CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
                                NSMutableArray *arr = [[NSMutableArray alloc]init];
                                arr = [loadArray objectAtIndex:loadnumber];
                                NSLog(@"dLoadNumber:%d",loadnumber);
                        
                                SiteData *site;
                                int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
        
                                if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                                    NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                            
                                    if (filteredArray.count == 1) {
                                        site = [filteredArray objectAtIndex:0];
                                    }
                                }
                        
                                if (site==nil) {
                                    [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }else{
                                    //Checking_add0n8
                                    hasAddon8 = FALSE;
                                    for (int index=0; index<site.categoryAddon.count; index++) {
                                        Add_on * dict = [site.categoryAddon objectAtIndex:index];
                                        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
                                            hasAddon8 = TRUE;
                                        }
                                    }
                                    //checking_AddOn5
                                    hasCustomCategory=false;
                                    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
                                        Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
                                        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
                                            hasCustomCategory=true;
                                            break;
                                        }
                                    }
                                    NSMutableArray * array = [[NSMutableArray alloc]init];
                                    array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
                                    NSMutableDictionary *parkload = [[NSMutableDictionary alloc] init];
                                    NSLog(@"loadnumber:%d",loadnumber);
                                    parkload = [[array objectAtIndex:loadnumber]mutableCopy];
                                    bool isAddon7Custom = [[parkload objectForKey:@"isAddon7Custom"]boolValue];
                                    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
                                    if(isAddon7Custom){
                                        NSMutableArray* newarr= [[parkload objectForKey:@"img"]mutableCopy];
                                        bool isAddon7CustomGpcc = [[parkload objectForKey:@"isAddon7CustomGpcc"]boolValue];
                                        if(isAddon7CustomGpcc){
                                            GalleryViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
                                            galleryVC.imageArray = newarr;
                                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                            for(int i=0; i<galleryVC.imageArray.count; i++){
                                                dict = [galleryVC.imageArray objectAtIndex:i];
                                                if([[dict valueForKey: @"imageName"] isEqual: @""]){
                                                    break;
                                                }
                                            }
                                            NSLog(@"CurrentVC:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"]);
                                            //fetching_parkload
                                            NSArray *img = [parkload valueForKey:@"img"];
                                            NSArray *str = [parkload valueForKey:@"instructData"];
                                            for(int i = 0; i<str.count; i++){
                                                int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                                                int picCount = [[[str valueForKey:@"count_for_step_pics"]objectAtIndex:i]intValue];

                                                NSLog(@"value:%d",value);
                                                NSMutableArray *newarrr = [[NSMutableArray alloc]init];
                                                isImgeAvailableAllsteps = TRUE;
                                                
                                                for(int j=0;j<img.count;j++){
                                                    NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                                                    int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                                                    NSLog(@"valuee:%@",valuee);
                                                    if(newvalue == value){
                                                        [newarrr addObject:valuee];
                                                        NSLog(@"newarr:%@",newarrr);
                                                        break;
                                                    }
                                                }
                                                if(newarrr.count == 0){
                                                    isImgeAvailableAllsteps = FALSE;
                                                    break;
                                                }else if(newarrr.count != picCount){
                                                    isImgeAvailableAllsteps = FALSE;
                                                    break;
                                                }
                                            }
                                            NSString*stry =[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"];
                                            NSLog(@"PicViewVC:%@",stry);
                                            if([[dict valueForKey: @"imageName"] isEqual: @""] || [stry isEqualToString:@"PicViewVC"] || ([parkload valueForKey:@"category"] && isImgeAvailableAllsteps)){
                                                //next_screen
                                                //imge.picslist = galleryVC.imageArray;
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                delegate.siteDatas =  site;
                                                galleryVC.siteData = site;
                                                galleryVC.sitename = site.siteName;
                                                galleryVC.pathToImageFolder = [[delegate getUserDocumentDir]    stringByAppendingPathComponent:LoadImagesFolder];
                                                galleryVC.instructData =[parkload valueForKey:@"instructData"];
                                                
                                                [self.navigationController pushViewController:galleryVC animated:YES];
                                            }else{
                                                CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                                                delegate.siteDatas =  site;
                                                CaptureVC.siteData = site;
                                                CaptureVC.siteName = site.siteName;
                                                CaptureVC.tapCount = delegate.ImageTapcount;
                                                CaptureVC.isEdit = YES;
                                                CaptureVC.instructData =[parkload valueForKey:@"instructData"];
                                                NSMutableArray * array = [[NSMutableArray alloc]init];
                                                array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
                                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                                NSLog(@"loadnumber:%d",loadnumber);
                                                dict = [[array objectAtIndex:loadnumber]mutableCopy];
                                                NSMutableArray* newarr=[[NSMutableArray alloc]init];
                                                newarr=[[dict objectForKey:@"img"]mutableCopy];
                                                CaptureVC.ArrayofstepPhoto = newarr;
                                                int total_photo = 0 ,wholeStepsCount = 0;
                                                NSArray *newArrr = [parkload valueForKey:@"instructData"];
                                                for(int i=0; i<newArrr.count;i++){
                                                    NSLog(@"i:%d",i);
                                                    NSMutableDictionary *dict = [[newArrr objectAtIndex:i] mutableCopy];
                                                    int countt = [[dict objectForKey:@"count_for_step_pics"]intValue];
                                                    int instNumb_InstData = [[dict objectForKey:@"instruct_number"]intValue];

                                                    total_photo = total_photo + countt;
                                                    int current_step_imgCount = 0;
                                                    for(int j=0; j<newarr.count;j++){
                                                        NSMutableDictionary *dictt = [[newarr objectAtIndex:i] mutableCopy];
                                                        NSString *imgStr = [dictt objectForKey:@"imageName"];
                                                         int instNumb_img = [dictt objectForKey:@"InstructNumber"];
                                                        if(instNumb_img==instNumb_InstData && ![imgStr isEqual: @""]){
                                                            current_step_imgCount++;
                                                        }
                                                    }
                                                    if( current_step_imgCount== 0){
                                                        NSLog(@"wholeStepsCount:%d",wholeStepsCount);
                                                        break;
                                                    }else if(current_step_imgCount >= total_photo){
                                                        if(newArrr.count > i+1 ){
                                                            wholeStepsCount++;
                                                        }
                                                    }
                                                }
                                                CaptureVC.wholeStepsCount = wholeStepsCount;
                                                NSLog(@" load number :%d",loadnumber);
                                                [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                CaptureVC.load_number = loadnumber;
                                                [self.navigationController pushViewController:CaptureVC animated:YES];
                                            }
                                        }else{
                                            if([parkload valueForKey:@"category"] == nil){
                                                CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
                                                Category.siteData = site;
                                                Category.sitename = site.siteName;
                                                Category.image_quality = site.image_quality;
                                                delegate.ImageTapcount = 0;
                                                delegate.isNoEdit = YES;
                                                
                                                [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey: @"CurrentLoadNumber"];
                                                [parkload setValue:@"true" forKey:@"isAddon7Custom"];
                                                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"ParkLoadArray"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                [self.navigationController pushViewController:Category animated:YES];
                                            }else{
                                                delegate.siteDatas = site;
                                                CameraVC.siteData = site;
                                                CameraVC.siteName = site.siteName;
                                                CameraVC.tapCount = delegate.ImageTapcount;
                                                CameraVC.isEdit = YES;
                                                NSLog(@" load number :%d",loadnumber);
                                                [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                CameraVC.load_number = loadnumber;
                                                [self.navigationController pushViewController:CameraVC animated:YES];
                                            }
                                        }
                                    }else if (delegate.userProfiels.instruct.instructData != nil && delegate.userProfiels.instruct.instructData.count >0 && self.IsiteId == site.siteId) {
                                      
                                        NSMutableArray* newarr= [[parkload objectForKey:@"img"]mutableCopy];
                                        GalleryViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
                                        galleryVC.imageArray = newarr;
                                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                        for(int i=0; i<galleryVC.imageArray.count; i++){
                                            dict = [galleryVC.imageArray objectAtIndex:i];
                                            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                                                break;
                                            }
                                        }
                                        NSLog(@"CurrentVC:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"]);
                                        //fetching_parkload
                                        NSArray *img = [parkload valueForKey:@"img"];
                                        NSArray *str = [parkload valueForKey:@"instructData"];
                                        for(int i = 0; i<str.count; i++){
                                            int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                                            int picCount = [[[str valueForKey:@"count_for_step_pics"]objectAtIndex:i]intValue];

                                            NSLog(@"value:%d",value);
                                            NSMutableArray *newarrr = [[NSMutableArray alloc]init];
                                            isImgeAvailableAllsteps = TRUE;
                                            
                                            for(int j=0;j<img.count;j++){
                                                NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                                                int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                                                NSLog(@"valuee:%@",valuee);
                                                if(newvalue == value){
                                                    [newarrr addObject:valuee];
                                                    NSLog(@"newarr:%@",newarrr);
                                                    break;
                                                }
                                            }
                                            if(newarrr.count == 0){
                                                isImgeAvailableAllsteps = FALSE;
                                                break;
                                            }else if(newarrr.count != picCount){
                                                isImgeAvailableAllsteps = FALSE;
                                                break;
                                            }
                                        }
                                        NSString*stry =[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"];
                                        NSLog(@"PicViewVC:%@",stry);
                                        if([[dict valueForKey: @"imageName"] isEqual: @""] || [stry isEqualToString:@"PicViewVC"] || ([parkload valueForKey:@"category"] && isImgeAvailableAllsteps)){
                                            //next_screen
                                            //imge.picslist = galleryVC.imageArray;
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            delegate.siteDatas =  site;
                                            galleryVC.siteData = site;
                                            galleryVC.sitename = site.siteName;
                                            galleryVC.pathToImageFolder = [[delegate getUserDocumentDir]    stringByAppendingPathComponent:LoadImagesFolder];
                                            galleryVC.instructData =[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];

                                            [self.navigationController pushViewController:galleryVC animated:YES];
                                        }else{
                                            CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                                            delegate.siteDatas =  site;
                                            CaptureVC.siteData = site;
                                            CaptureVC.siteName = site.siteName;
                                            CaptureVC.tapCount = delegate.ImageTapcount;
                                            CaptureVC.isEdit = YES;
                                            CaptureVC.instructData =[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
                                            NSMutableArray * array = [[NSMutableArray alloc]init];
                                            array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
                                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                            NSLog(@"loadnumber:%d",loadnumber);
                                            dict = [[array objectAtIndex:loadnumber]mutableCopy];
                                            NSMutableArray* newarr= [[dict objectForKey:@"img"]mutableCopy];
                                            CaptureVC.ArrayofstepPhoto = newarr;
                                            int total_photo = 0 ,wholeStepsCount = 0;
                                            NSArray *newArrr = [parkload valueForKey:@"instructData"];
                                            for(int i=0; i<newArrr.count;i++){
                                                NSLog(@"i:%d",i);
                                                NSMutableDictionary *dict = [[newArrr objectAtIndex:i] mutableCopy];
                                                int countt = [[dict objectForKey:@"count_for_step_pics"]intValue];
                                                int instNumb_InstData = [[dict objectForKey:@"instruct_number"]intValue];

                                                total_photo = total_photo + countt;
                                                int current_step_imgCount = 0;
                                                for(int j=0; j<newarr.count;j++){
                                                    NSMutableDictionary *dictt = [[newarr objectAtIndex:i] mutableCopy];
                                                    NSString *imgStr = [dictt objectForKey:@"imageName"];
                                                     int instNumb_img = [dictt objectForKey:@"InstructNumber"];
                                                    if(instNumb_img==instNumb_InstData && ![imgStr isEqual: @""]){
                                                        current_step_imgCount++;
                                                    }

                                                }
                                                    
                                                if( current_step_imgCount== 0){
                                                    NSLog(@"wholeStepsCount:%d",wholeStepsCount);
                                                    break;
                                                }else if(current_step_imgCount >= total_photo){
                                                    if(newArrr.count > i+1 ){
                                                        wholeStepsCount++;
                                                    }
                                                }
                                                
                                            }
                                            CaptureVC.wholeStepsCount = wholeStepsCount;
                                            NSLog(@" load number :%d",loadnumber);
                                            [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            CaptureVC.load_number = loadnumber;
                                            [self.navigationController pushViewController:CaptureVC animated:YES];
                                        }
                                    }else if(hasAddon8 && !hasCustomCategory){
                                        NSMutableArray * array = [[NSMutableArray alloc]init];
                                        array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
                                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                        NSLog(@"loadnumber:%d",loadnumber);
                                        dict = [[array objectAtIndex:loadnumber]mutableCopy];
                                        NSMutableArray* newarr= [[dict objectForKey:@"img"]mutableCopy];
                                        GalleryLoopViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
                                        galleryVC.imageArray = newarr;
                                        for(int i=0; i<galleryVC.imageArray.count; i++){
                                            dict = [galleryVC.imageArray objectAtIndex:i];
                                            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                                                break;
                                            }
                                        }
                                        NSLog(@"CurrentVC:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"]);
                                        if([[dict valueForKey: @"imageName"] isEqual: @""] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"PicViewVC"]){
                                            
                                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_instruction_number"];
                                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.currentTappiCount] forKey:@"current_Looping_Count"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            delegate.siteDatas =  site;
                                            galleryVC.siteData = site;
                                            galleryVC.sitename = site.siteName;
                                            galleryVC.pathToImageFolder = [[delegate getUserDocumentDir]    stringByAppendingPathComponent:LoadImagesFolder];

                                            [self.navigationController pushViewController:galleryVC animated:YES];
                                        }else{
                                            Looping_Camera_ViewController * CameraLoopVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CameraLoopVC"];
                                           
                                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_instruction_number"];
                                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.currentTappiCount] forKey:@"current_Looping_Count"];
                                            delegate.siteDatas =  site;
                                            CameraLoopVC.siteData = site;
                                            CameraLoopVC.siteName = site.siteName;
                                            CameraLoopVC.tapCount = delegate.ImageTapcount;
                                            CameraLoopVC.isEdit = YES;
                                            NSLog(@" load number :%d",loadnumber);
                                            [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            CameraLoopVC.load_number = loadnumber;
                                            [self.navigationController pushViewController:CameraLoopVC animated:YES];
                                        }
                                    }else{
                                        delegate.siteDatas = site;
                                        CameraVC.siteData = site;
                                        CameraVC.siteName = site.siteName;
                                        CameraVC.tapCount = delegate.ImageTapcount;
                                        CameraVC.isEdit = YES;
                                        NSLog(@" load number :%d",loadnumber);
                                        [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        CameraVC.load_number = loadnumber;
                                        [self.navigationController pushViewController:CameraVC animated:YES];
                                    }
                                }
                            }
                        }else{
                            NSMutableArray * parkloadarray = [[NSMutableArray alloc]init];
                            parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                            if(parkloadarray.count>0 || (self.sitesNameArr.count == 1)){
                                LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
                                [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
                                [[NSUserDefaults standardUserDefaults] setObject:site.image_quality forKey:@"image_quality"];
                                [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                LoadSelectionVC.siteName = site.siteName;
                                LoadSelectionVC.siteData = site;
                                delegate.siteDatas =  site;
                                delegate.count = 0;
                                LoadSelectionVC.count = delegate.count;
                                NSLog(@"Netid1 :%d",site.networkId);
                                [self.navigationController pushViewController:LoadSelectionVC animated:YES];
                            }
                        }
                    }
                }
        }else{
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            NSIndexPath *ip = 0;
            if (self.sitesNameArr.count == 1) {
                [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
            }
        }
    }
}

-(void)uploadFinishCheckParkLoad{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SiteViewController class]])
        {
            [self.navigationController popToViewController:controller animated:true];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]){
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
        SiteData *site;
        if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
            NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
            
            if (filteredArray.count == 1) {
                site = [filteredArray objectAtIndex:0];
            }
        }
        
        if (site != nil) {
            LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
            [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            LoadSelectionVC.siteName = site.siteName;
            LoadSelectionVC.siteData = site;
            delegate.siteDatas =  site;
            delegate.count = 0;
            LoadSelectionVC.count = delegate.count;
            NSLog(@"Netid2 :%d",site.networkId);
            [self.navigationController pushViewController:LoadSelectionVC animated:false];
        }
    }
}
-(void)moveToCaptureScreen{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
    SiteData *site;
    if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
        NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
        if (filteredArray.count == 1) {
            site = [filteredArray objectAtIndex:0];
        }
    }
    
    
    if (site != nil) {
        _instructData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
        LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
        
        [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"currentSiteType"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoadSelectionVC.siteName = site.siteName;
        LoadSelectionVC.siteData = site;
        delegate.siteDatas =  site;
        delegate.count = 0;
        LoadSelectionVC.count = delegate.count;
        NSLog(@"Netid3 :%d",site.networkId);
        [LoadSelectionVC Load_btn_action:capture.view];
    }
}

-(void)moveToLoadSelection{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
    SiteData *site;
    if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
        NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
        if (filteredArray.count == 1) {
            site = [filteredArray objectAtIndex:0];
        }
    }
    
    
    if (site != nil) {
            LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
            [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"currentSiteType"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            LoadSelectionVC.siteName = site.siteName;
            LoadSelectionVC.siteData = site;
            delegate.siteDatas =  site;
            delegate.count = 0;
            LoadSelectionVC.count = delegate.count;
            NSLog(@"Netid3 :%d",site.networkId);
            [self.navigationController pushViewController:LoadSelectionVC animated:false];
    }
}

-(void)restartedUploadFinished{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SiteViewController class]])
        {
            [self.navigationController popToViewController:controller animated:true];
        }
    }
    [self moveToLoadSelection];
}


-(void)sitesArr:(NSNotification *)notification
{
    self.sitesNameArr = [ notification object];
    [self.simple_tbleView reloadData];
    isLogin = true;
    [self checkForPendingUpload];
}


-(void)startLocating:(NSNotification *)notification {
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.sitesNameArr = delegate.userProfiels.arrSites;
}


-(void)receiveNotofication:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"received"]) {
        self.sitesNameArr = notification.userInfo;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sitesNameArr count];
    
}

- (CGFloat)tableViewHeightOfTable:(UITableView *)table
{
   [table layoutIfNeeded];
   return [table contentSize].height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Site";
    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
    }
    
    // Set up the cell...
<<<<<<< HEAD
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    }else{
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    }
    
=======
     if (fontPosition == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    } else if (fontPosition == 1) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19];
    }
    // Set up the cell...
//   NSString *model=[UIDevice currentDevice].model;
//    if ([model isEqualToString:@"iPad"]) {
//        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
//    }else{
//        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
//    }
//    

>>>>>>> main
    SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [site.siteName stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.adjustsFontSizeToFitWidth = YES; // As alternative you can also make it multi-line.
    cell.textLabel.minimumScaleFactor = 0.1;
    cell.textLabel.numberOfLines = 2;
<<<<<<< HEAD
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor purpleColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.tintColor = [UIColor purpleColor];
    [self.simple_tbleView setSeparatorColor:[UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0]];
=======
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tintColor = [UIColor blackColor];
    // Add a custom image as the accessory view
    UIImage *customImage = [UIImage imageNamed:@"next_new.png"];
    UIImageView *customImageView = [[UIImageView alloc] initWithImage:customImage];
    customImageView.frame = CGRectMake(0, 0, 10.0, 15.0);
    cell.accessoryView = customImageView;
    
    if(self.sitesNameArr.count < limitCount){
        if(indexPath.row == self.sitesNameArr.count - 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = self.simple_tbleView.bounds;
                // Create a CAShapeLayer with a rounded bottom
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                               byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                     cornerRadii:CGSizeMake(20.0, 20.0)];
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
            });
        }
    }
>>>>>>> main
    
    return cell;
}

- (void)viewDidLayoutSubviews{
    //self.tblViewHeight.constant = self.simple_tbleView.contentSize.height;
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.movetolc == NO) {
        FieldData *fieldData;
        SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
        NSLog(@"site:%@",site);
        
        //checkingForAddon5
        bool hasCustomCategory=false;
        for (int index=0; index<site.categoryAddon.count; index++) {
            Add_on *add_on = [site.categoryAddon objectAtIndex:index];
            if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
                hasCustomCategory=true;
                break;
            }
        }
        //checkingForAddon8
        hasAddon8 = FALSE;
        for (int index=0; index<site.categoryAddon.count; index++) {
            Add_on * dict = [site.categoryAddon objectAtIndex:index];
            if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
                hasAddon8 = TRUE;
                Add_on_8 *dictt = site.looping_data[0];
                self.looping_metaDataArray =  dictt.loopingMetaData;
                self.base_metaDataArray =  dictt.baseMetaData;
            }
        }
        //Checking_customerId_fielddata
        //    bool isCustomIdMetadataConf = TRUE;
        //    if(!hasAddon8){
        //        int isTrue = 0;
        //        if(site.arrFieldData.count == 1){
        //            fieldData = site.arrFieldData [0];
        //            BOOL customer_id = fieldData.isCustomerId;
        //            NSMutableArray *site_list_id = fieldData.siteListId;
        //            if(customer_id == YES){
        //                for(int i = 0; i<site_list_id.count; i++){
        //                    int siteListValue = [[site_list_id objectAtIndex:i]intValue];
        //                    NSLog(@"site_list_id[i]:%@",site_list_id[i]);
        //                    if(site.siteId == siteListValue){
        //                        NSLog(@"True");
        //                        isTrue++;
        //                    }
        //                }
        //            }else{
        //                isCustomIdMetadataConf = FALSE;
        //            }
        //            if(isTrue>0 ){
        //                isCustomIdMetadataConf = FALSE;
        //            }
        //        }else{
        //            isCustomIdMetadataConf = FALSE;
        //        }
        //    }
        bool isBaseMetadataConf = TRUE;
        bool isLoopMetadataConf = TRUE;
        if(self.looping_metaDataArray != nil && self.looping_metaDataArray.count >0){
            int intNew = 0;
            //int isTrue = 0;
            for(int i = 0; i<self.looping_metaDataArray.count; i++){
                fieldData = self.looping_metaDataArray [i];
                BOOL active = fieldData.shouldActive;
                if(active == TRUE){
                    intNew++;
                }
                //            BOOL customer_id = fieldData.isCustomerId;
                //            NSMutableArray *site_list_id = fieldData.siteListId;
                //            if(customer_id == YES){
                //                for(int i = 0; i<site_list_id.count; i++){
                //                    //SiteData *site = self.siteData;
                //                    int siteListValue = [[site_list_id objectAtIndex:i]intValue];
                //                    NSLog(@"site_list_id[i]:%@",site_list_id[i]);
                //                    if(site.siteId == siteListValue){
                //                        NSLog(@"True");
                //                        isTrue++;
                //                    }
                //                }
                //            }
            }
            if(intNew>0 ){
                isLoopMetadataConf = FALSE;
            }
            //        if(isTrue>0 ){
            //            isCustomIdMetadataConf = FALSE;
            //        }
        }
        if(self.base_metaDataArray != nil && self.base_metaDataArray.count >0){
            int intNew = 0;
            //int isTrue = 0;
            for(int i = 0; i<self.base_metaDataArray.count; i++){
                fieldData = self.base_metaDataArray [i];
                BOOL active = fieldData.shouldActive;
                if(active == TRUE){
                    intNew++;
                }
                //            BOOL customer_id = fieldData.isCustomerId;
                //            NSMutableArray *site_list_id = fieldData.siteListId;
                //            if(customer_id == YES){
                //                for(int i = 0; i<site_list_id.count; i++){
                //                   // SiteData *site = self.siteData;
                //                    int siteListValue = [[site_list_id objectAtIndex:i]intValue];
                //                    NSLog(@"site_list_id[i]:%@",site_list_id[i]);
                //                    if(site.siteId == siteListValue){
                //                        NSLog(@"True");
                //                        isTrue++;
                //                    }
                //                }
                //            }
            }
            if(intNew>0 ){
                isBaseMetadataConf = FALSE;
            }
            //        if(isTrue>0 ){
            //            isCustomIdMetadataConf = FALSE;
            //        }
        }
        //    if(isCustomIdMetadataConf){
        //        [self.view makeToast:NSLocalizedString(@"CustomerId setup is Not Configured for this Site. Add atleast 1 field to proceed.",@"") duration:4.0 position:CSToastPositionCenter style:nil];
        //    }else
        if ( hasCustomCategory && (site.customCategory.count == 0) ){
            [self.view makeToast:NSLocalizedString(@"Custom Category is Not Configured for this Site.\nPlease Contact Network Admin to Configure.",@"") duration:4.0 position:CSToastPositionCenter style:nil];
        }else if(hasAddon8 && !hasCustomCategory && (self.base_metaDataArray == nil || isBaseMetadataConf == TRUE )){
            [self.view makeToast:NSLocalizedString(@"Base MetaData is Not Configured for this Site. Add atleast 1 field to proceed.",@"") duration:4.0 position:CSToastPositionCenter style:nil];
        }else if(hasAddon8 && !hasCustomCategory && (self.looping_metaDataArray == nil || isLoopMetadataConf == TRUE )){
            [self.view makeToast:NSLocalizedString(@"Looping MetaData is Not Configured for this Site. Add atleast 1 field to proceed.",@"") duration:4.0 position:CSToastPositionCenter style:nil];
        }else{
           
            [self deviceTracker:site];
            LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
            
            [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"currentSiteType"];
            [[NSUserDefaults standardUserDefaults] setInteger:site.siteId forKey:@"siteID"];
            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"SiteId %d",site.siteId);
            NSLog(@"SiteName %@",site.siteName);
            LoadSelectionVC.siteName = site.siteName;
            LoadSelectionVC.siteData = site;
            
            AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            delegate.siteDatas =  site;
            delegate.count = 0;
            LoadSelectionVC.count = delegate.count;
            NSLog(@"Netid4 :%d",site.networkId);
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:LoadSelectionVC animated:YES];
            
        }
        
    }
}

-(void)deviceTracker:(SiteData *)site {
    @try{
        NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
        NSMutableDictionary *dictionary = [[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTracker"] mutableCopy];

        NSMutableArray* deviceDetails;
        NSMutableArray* siteDetails;
        int trackId = 0;
        if(dictionary == nil){
            dictionary = [[NSMutableDictionary alloc] init];
        }
        if(trackerId != nil){
            
            if(dictionary != nil && [dictionary objectForKey:@"device_offline_details"]){
                deviceDetails = [[dictionary valueForKey:@"device_offline_details"]mutableCopy];
            }else {
                deviceDetails = [[NSMutableArray alloc] init];
                NSMutableDictionary * deviceDetail = [[NSMutableDictionary alloc] init];
                if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
                {
                    [deviceDetail setValue:trackerId forKey:@"online_device_tracker_id"];
                    [deviceDetail setValue:@"" forKey:@"offline_device_tracker_id"];
                } else {
                    int dtId = [trackerId intValue] + 1;
                    [deviceDetail setValue:@(dtId).stringValue forKey:@"offline_device_tracker_id"];
                    [deviceDetail setValue:@"" forKey:@"online_device_tracker_id"];
                }
                [deviceDetail setValue:@"" forKey:@"offline_in_time"];
                [deviceDetail setValue:@"" forKey:@"offline_out_time"];
                [deviceDetails addObject:deviceDetail];
                [dictionary setValue:deviceDetails forKey:@"device_offline_details"];
            }
                NSUInteger deviceCount;
                NSMutableDictionary* dict;
                NSMutableArray* arr;
                    deviceCount = [deviceDetails count] - 1;
                    dict = [deviceDetails[deviceCount] mutableCopy];
                    arr = [[dict valueForKey:@"site_details"]mutableCopy];
                    if(arr == nil){
                        //                    siteDetails = arr;
                        //                }else {
                        arr = [[NSMutableArray alloc] init];
                    }
                BOOL isAlreadyFound = false;
                if(arr.count > 0){
                    for(int i =0;i < arr.count; i++){
                        NSDictionary* di = arr[i];
                        NSMutableString* sid = [di valueForKey:@"site_id"];
                        if([sid isEqual:@(site.siteId).stringValue]){
                            isAlreadyFound = true;
                        }
                    }
                }
            if(!isAlreadyFound){
                NSDate *currentDate = [[NSDate alloc] init];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
                NSString *localDateString = [dateFormatter stringFromDate:currentDate];
                NSMutableDictionary * siteDetail = [[NSMutableDictionary alloc] init];
                [siteDetail setValue:@(site.siteId).stringValue forKey:@"site_id"];
                [siteDetail setValue:localDateString forKey:@"site_clicked_time"];
                [arr addObject:siteDetail];
                [dict setObject:arr forKey:@"site_details"];
                [deviceDetails replaceObjectAtIndex:deviceCount withObject:dict];
                
                [dictionary setValue:deviceDetails forKey:@"device_offline_details"];
                [dictionary setValue:@(delegateVC.userProfiels.cId).stringValue forKey:@"c_id"];
                [dictionary setValue:@(delegateVC.userProfiels.userId).stringValue forKey:@"u_id"];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"deviceTracker"];
            }
        }
    }@catch(NSException * ex){
        NSLog(@"ddd", @"aaa");
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.btn=nil;
    self.simple_tbleView=nil;
    self.i=nil;
    [super viewDidUnload];
}

@end

