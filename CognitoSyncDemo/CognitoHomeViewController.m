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
#import "LanguageManager.h"
#import "LanguageTableViewCell.h"
#import "DriverCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DriverUploadViewController.h"
#import "DriverData.h"
@import Firebase;


@interface CognitoHomeViewController ()<UIPopoverPresentationControllerDelegate,UITableViewDelegate, UITableViewDataSource>{
    
    popViewController *popoverViewController;
    AZCAppDelegate *delegateVC;
    NSArray *array01;
    double lat_app;
    double longi_app;
    NSArray *language_data;
    LanguageManager *man;
    NSString * username_str;
<<<<<<< HEAD
 
=======
    UILabel *byLog,*terms,*and,*policy,*withSG;
    NSInteger fontPosition;
    UIView *zoomView;
    UIButton *zoombutton;
    UIProgressView *progressLineView;
    NSMutableArray *circleButtons;
    UILabel *label,*label1,*label2;
    CGFloat screenWidth,screenHeight;
    CGFloat zoomButtonWidth;
    NSInteger selectedIndex;
>>>>>>> main
}
@end


@implementation CognitoHomeViewController

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************


- (void)viewDidLoad {

    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    [super viewDidLoad];
    self.lang_table_btn.hidden = YES;
    
    //Location
    [locationManager startUpdatingLocation];
    [self geolocation];

    //Language_setting
    language_data = [LanguageManager languageStrings];

<<<<<<< HEAD
    self.UserName_txt.delegate = self;
    self.UserName_txt.keyboardType = bold;
    self.UserName_txt.layer.cornerRadius = 5;
    self.UserName_txt.layer.borderWidth = 0.5;
    self.UserName_txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.UserName_txt.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.Login_ok_pressed.layer.cornerRadius = 5;
    self.Login_ok_pressed.layer.borderWidth = 0.5;
    [self.Login_ok_pressed.layer setShadowOffset:CGSizeMake(3, 3)];
    [self.Login_ok_pressed.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.Login_ok_pressed.layer setShadowOpacity:0.5];
    self.Login_ok_pressed.layer.shadowRadius = 5.0;
    self.Login_ok_pressed.layer.borderColor = [UIColor blackColor].CGColor;
=======
    // QuickLogin
    self.QuickLogin.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.QuickLogin.titleLabel.text = @"Quick Login";
    
    //LoginText View font
    self.LoginText.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    self.LoginText.textColor = [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:0.7];

   
    //username text
    self.UserName_txt.placeholder = @"User ID";
    self.UserName_txt.delegate = self;
    self.UserName_txt.keyboardType = bold;
    self.UserName_txt.layer.cornerRadius = 5;
    self.UserName_txt.layer.borderWidth = 1.0f;
    self.UserName_txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.UserName_txt.layer.borderColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    
    self.Login_ok_pressed.layer.cornerRadius = 10;
>>>>>>> main

    self.stackView.layer.cornerRadius = 10;

    self.Background_View.layer.cornerRadius = 10;
<<<<<<< HEAD
    [self.Background_View.layer setShadowOffset:CGSizeMake(3, 3)];
    [self.Background_View.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.Background_View.layer setShadowOpacity:0.5];
    self.Background_View.layer.shadowRadius = 5.0;
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strVersionString = [NSString stringWithFormat:@"v%@(%@)",appVersionString,appBuildString];
    self.Bylog.text = NSLocalizedString(@"By Logging in you agree to the", @"");
    self.withSG.text = NSLocalizedString(@"with Smart Gladiator", @"");

    //rstr
    NSString *RString = NSLocalizedString(@"Terms&Conditions", @"");
    NSMutableParagraphStyle *rparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        rparagraphStyle.alignment = NSTextAlignmentLeft;
    }else{
        rparagraphStyle.alignment = NSTextAlignmentRight;
    }
    //rparagraphStyle.lineSpacing = FONT_SIZE/3;
    UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset : CGSizeMake (1.0, 1.0)];
    [shadow setShadowBlurRadius : 1];
    NSMutableAttributedString *rLabelText = [[NSMutableAttributedString alloc] initWithString :RString attributes : @{
        NSParagraphStyleAttributeName : rparagraphStyle,
        NSFontAttributeName : labelFont}];
    NSURL *URL1 = [NSURL URLWithString: @"https://loadproof.com/terms-conditions/"];

    [rLabelText addAttribute: NSLinkAttributeName value:URL1 range: NSMakeRange(0,rLabelText.length)];
    [rLabelText addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0] range:NSMakeRange(0, rLabelText.length)];
    _rightView.linkTextAttributes =                                @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSForegroundColorAttributeName:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0]};
    _rightView.attributedText = rLabelText;
    
    //lstr
    NSString *LString = NSLocalizedString(@"Privacy Policy",@"");
    NSMutableParagraphStyle *lparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        lparagraphStyle.alignment = NSTextAlignmentRight;

    }else{
        lparagraphStyle.alignment = NSTextAlignmentLeft;
    }
    //lparagraphStyle.lineSpacing = FONT_SIZE/2;
    [shadow setShadowOffset : CGSizeMake (1.0, 1.0)];
    [shadow setShadowBlurRadius : 1];
    NSMutableAttributedString *lLabelText = [[NSMutableAttributedString alloc] initWithString :LString attributes : @{
        NSParagraphStyleAttributeName : lparagraphStyle,
        NSFontAttributeName : labelFont}];
    NSURL *URL2 = [NSURL URLWithString: @"https://loadproof.com/privacy-policy/"];
    [lLabelText addAttribute: NSLinkAttributeName value:URL2 range: NSMakeRange(0, lLabelText.length)];

    [lLabelText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0] range:NSMakeRange(0, lLabelText.length)];
    _leftView.linkTextAttributes =                                @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSForegroundColorAttributeName:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0]};
    _leftView.attributedText = lLabelText;
    
    [self.loadproof_extend setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loadproof_extend.titleLabel.font = [UIFont systemFontOfSize:34.0];
           self.loadproof_extend.layer.cornerRadius = 4.0;
           self.loadproof_extend.layer.masksToBounds = YES;
           self.loadproof_extend.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
    [self.loadproof_extend setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0]];
    self.loadproof_extend.layer.shadowRadius = 3.0f;
    self.loadproof_extend.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loadproof_extend.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.loadproof_extend.layer.shadowOpacity = 0.5f;
    self.loadproof_extend.layer.masksToBounds = NO;


    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
//    delegateVC.CurrentVC = @"PassVC";
    NSLog(@"currrrr: %@", delegate.CurrentVC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"myNotificationName" object:nil];
    
//        NSURL *link = [[NSURL alloc] initWithString:@"http://loadproof.us?sitedata=7654"];
//        NSString *dynamicLinksDomainURIPrefix = @"https://loadproofmultiload.page.link";
//        FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
//                                                 initWithLink:link
//                                                       domainURIPrefix:dynamicLinksDomainURIPrefix];
//        linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
//                                         initWithPackageName:@"com.smartgladiator.loadProof.multiloadnew"];
//    linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
//                                 initWithBundleID:@"com.smartgladiator.loadproof"];
//    linkBuilder.iOSParameters.appStoreID = @"1187604176";
//
//        NSLog(@"The long URL is: %@", linkBuilder.url);
//        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
//        [self.view makeToast:countryCode duration:2.0 position:CSToastPositionCenter];
 
    // Create a timer that repeats every 2 seconds
=======
 
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strVersionString = [NSString stringWithFormat:@"v%@(%@)",appVersionString,appBuildString];
    self.Bylog.text = NSLocalizedString(@"By Logging in you agree to the", @"");
    self.withSG.text = NSLocalizedString(@"with Smart Gladiator", @"");

 
  //  [self.loadproof_extend setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loadproof_extend.layer.cornerRadius = 10.0;
    self.loadproof_extend.layer.masksToBounds = YES;
    self.loadproof_extend.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    self.loadproof_extend.layer.borderWidth = 1.0;
    self.loadproof_extend.layer.borderColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0].CGColor;
    self.loadproof_extend.layer.masksToBounds = NO;

    [self handleTimer];
    [self fontSize];
    
    // Load the selected font size from UserDefaults
        fontPosition = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFontSizePosition"];

    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
//    delegateVC.CurrentVC = @"PassVC";
    NSLog(@"currrrr: %@", delegate.CurrentVC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"myNotificationName" object:nil];
    
//        NSURL *link = [[NSURL alloc] initWithString:@"http://loadproof.us?sitedata=7654"];
//        NSString *dynamicLinksDomainURIPrefix = @"https://loadproofmultiload.page.link";
//        FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
//                                                 initWithLink:link
//                                                       domainURIPrefix:dynamicLinksDomainURIPrefix];
//        linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
//                                         initWithPackageName:@"com.smartgladiator.loadProof.multiloadnew"];
//    linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
//                                 initWithBundleID:@"com.smartgladiator.loadproof"];
//    linkBuilder.iOSParameters.appStoreID = @"1187604176";
//
//        NSLog(@"The long URL is: %@", linkBuilder.url);
//        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
//        [self.view makeToast:countryCode duration:2.0 position:CSToastPositionCenter];
 
    // Create a timer that repeats every 2 seconds
}

-(void)fontSize {
    
    // Quick Login
    if (fontPosition == 0){
        NSLog(@"If Block");
        self.QuickLogin.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    }else if (fontPosition == 1){
        self.QuickLogin.titleLabel.font = [UIFont boldSystemFontOfSize:26.0];
    }
    else {
        self.QuickLogin.titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
    }
  
    //TextView
    if (fontPosition == 0){
        self.LoginText.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
        self.LoginText.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    }else {
        self.LoginText.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    }
    
    //username
    if (fontPosition == 0){
        self.UserName_txt.font = [UIFont systemFontOfSize:15.0];
    }else if (fontPosition == 1){
        self.UserName_txt.font = [UIFont systemFontOfSize:17.0];
    }else{
        self.UserName_txt.font = [UIFont systemFontOfSize:19.0];
    }

    //Login Ok
    if (fontPosition == 0){
        self.Login_ok_pressed.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }else if (fontPosition == 1){
        self.Login_ok_pressed.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    else{
        self.Login_ok_pressed.titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    
    //Loadproof extend
    if (fontPosition == 0){
        self.loadproof_extend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }else if (fontPosition == 1){
        self.loadproof_extend.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    else{
        self.loadproof_extend.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    }
    
    // ByLog
    if (fontPosition == 0){
        byLog.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
       byLog.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    else{
        byLog.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    
    //terms
    if (fontPosition == 0){
        terms.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
       terms.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    else{
        terms.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    
    //and
    if (fontPosition == 0){
        and.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
       and.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    else{
        and.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    
    //policy
    if (fontPosition == 0){
        policy.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
       policy.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    else{
        policy.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    
    //withSG
    if (fontPosition == 0){
        withSG.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }else if (fontPosition == 1){
       withSG.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    else{
        withSG.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    
}
-(void)handleTimer {
    
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    
    // Set font and font size for terms and policy Labels
    //UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    
    //BYlog
     byLog = [[UILabel alloc] init];
    // Add label to View1
    [self.view1 addSubview:byLog];
    //  Set the frame of the byLogLabel
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        byLog.font = [UIFont systemFontOfSize:12.0];
        [NSLayoutConstraint activateConstraints:@[
           // Constraints
           [byLog.leadingAnchor constraintEqualToAnchor:self.view1.leadingAnchor constant:0],
           [byLog.topAnchor constraintEqualToAnchor:self.view1.topAnchor constant:0],
        ]];
   }
     else{
         [NSLayoutConstraint activateConstraints:@[
             // Constraints
             [byLog.leadingAnchor constraintEqualToAnchor:self.view1.leadingAnchor],
             [byLog.topAnchor constraintEqualToAnchor:self.view1.topAnchor],
         ]];
     }
  byLog.translatesAutoresizingMaskIntoConstraints = NO;
  byLog.numberOfLines = 0; // Set 0 for unlimited number of lines
  byLog.lineBreakMode = NSLineBreakByWordWrapping;
  byLog.text = NSLocalizedString(@"By Logging in you agree to the", @"");
  byLog.textColor = [UIColor blackColor];
  byLog.font = [UIFont systemFontOfSize:12.0];

  
  //terms
   terms = [[UILabel alloc] init];
  //Add label to View1
  [self.view1 addSubview:terms];
  //  Set the frame of the termsLabel
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
         terms.font = [UIFont systemFontOfSize:12.0];
         // Constraints
         [NSLayoutConstraint activateConstraints:@[
             [terms.leadingAnchor constraintEqualToAnchor:byLog.trailingAnchor constant:5],
             [terms.topAnchor constraintEqualToAnchor:self.view1.topAnchor],
             // Constraint to ensure both labels have the same baseline
             [terms.firstBaselineAnchor constraintEqualToAnchor:byLog.firstBaselineAnchor]
         ]];
        
     }
       else{
           [NSLayoutConstraint activateConstraints:@[
              [terms.leadingAnchor constraintEqualToAnchor:byLog.trailingAnchor constant:5],
              [terms.topAnchor constraintEqualToAnchor:self.view1.topAnchor],
              // Constraint to ensure both labels have the same baseline
              [terms.firstBaselineAnchor constraintEqualToAnchor:byLog.firstBaselineAnchor]
           ]];
         }
  terms.numberOfLines = 0; // Set 0 for unlimited number of lines
  terms.lineBreakMode = NSLineBreakByWordWrapping;
  terms.translatesAutoresizingMaskIntoConstraints = NO;
  terms.text = NSLocalizedString(@"Terms & Conditions", @"");
  terms.textColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
    terms.font = [UIFont systemFontOfSize:12.0];
 
 
  //terms text style
  NSMutableParagraphStyle *rparagraphStyle = [[NSMutableParagraphStyle alloc] init];
  if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
      terms.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
      rparagraphStyle.alignment = NSTextAlignmentLeft;
  }else{
      rparagraphStyle.alignment = NSTextAlignmentRight;
  }
 
  NSShadow *shadow = [[NSShadow alloc] init];
  [shadow setShadowOffset : CGSizeMake (1.0, 1.0)];
  [shadow setShadowBlurRadius : 1];

  terms.userInteractionEnabled = YES;
  // Add tap gesture recognizer
  UITapGestureRecognizer *termsGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  [terms addGestureRecognizer:termsGesture];
  
  //and
   and = [[UILabel alloc] init];
   // add and to View2
     [self.view2 addSubview:and];
  // Set the frame of the andLabel
        [NSLayoutConstraint activateConstraints:@[
            [and.leadingAnchor constraintEqualToAnchor:self.view2.leadingAnchor],
            [and.topAnchor constraintEqualToAnchor:self.view2.topAnchor],
        ]];
     
  and.translatesAutoresizingMaskIntoConstraints = NO;
  and.numberOfLines = 0; // Set 0 for unlimited number of lines
  and.lineBreakMode = NSLineBreakByWordWrapping;
  and.textColor = [UIColor blackColor];
  and.font = [UIFont systemFontOfSize:12.0];
  and.text = NSLocalizedString(@"and", @"");
  
  //Policy
   policy = [[UILabel alloc] init];
   // add policy to View2
     [self.view2 addSubview:policy];
  //  Set the frame of the policyLabel
     [NSLayoutConstraint activateConstraints:@[
           [policy.leadingAnchor constraintEqualToAnchor:and.trailingAnchor constant:5],
           [policy.topAnchor constraintEqualToAnchor:self.view2.topAnchor],
           // Constraint to ensure both labels have the same baseline
           [policy.firstBaselineAnchor constraintEqualToAnchor:and.firstBaselineAnchor]
     ]];
 
  policy.translatesAutoresizingMaskIntoConstraints = NO;
  policy.numberOfLines = 0;
  policy.lineBreakMode = NSLineBreakByWordWrapping;
  policy.font = [UIFont systemFontOfSize:12.0];
  policy.textColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:214.0/255.0 alpha:1.0];
  policy.text = NSLocalizedString(@"Privacy Policy",@"");
  
  //policy text style
  NSMutableParagraphStyle *lparagraphStyle = [[NSMutableParagraphStyle alloc] init];
  if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
      [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
      lparagraphStyle.alignment = NSTextAlignmentRight;

  }else{
      lparagraphStyle.alignment = NSTextAlignmentLeft;
  }
  //lparagraphStyle.lineSpacing = FONT_SIZE/2;
  [shadow setShadowOffset : CGSizeMake (1.0, 1.0)];
  [shadow setShadowBlurRadius : 1];
  policy.userInteractionEnabled = YES;
  UITapGestureRecognizer *PrivacyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  [policy addGestureRecognizer:PrivacyGesture];

  //withSG
   withSG = [[UILabel alloc] init];
     // add withSG to View2
     [self.view2 addSubview:withSG];
     //constraints for withSG label
     [NSLayoutConstraint activateConstraints:@[
           [withSG.leadingAnchor constraintEqualToAnchor:policy.trailingAnchor constant:5],
           [withSG.topAnchor constraintEqualToAnchor:self.view2.topAnchor],
           // Constraint to ensure both labels have the same baseline
           [withSG.firstBaselineAnchor constraintEqualToAnchor:policy.firstBaselineAnchor]
     ]];
 
  withSG.translatesAutoresizingMaskIntoConstraints = NO;
  withSG.numberOfLines = 0; // Set to 0 for unlimited number of lines
  withSG.lineBreakMode = NSLineBreakByWordWrapping;
  withSG.textColor = [UIColor blackColor];
  withSG.font = [UIFont systemFontOfSize:12.0];
  withSG.text = NSLocalizedString(@"with Smart Gladiator.", @"");
 
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


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
        
    // Open terms and conditions page
        NSURL *URL = [NSURL URLWithString:@"https://loadproof.com/terms-conditions/"];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
>>>>>>> main
    
        // Open terms and conditions page
        NSURL *URL = [NSURL URLWithString:@"https://loadproof.com/privacy-policy/"];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

<<<<<<< HEAD
=======

>>>>>>> main
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self geolocation];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"HomeVC";
    [self driverParkload];
    [self.navigationController setNavigationBarHidden:YES];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"];
    NSLog(@"strrr%@:",str);
    //BarCode
    NSString *text=[[NSUserDefaults standardUserDefaults] objectForKey:@"scanData"];
    NSInteger tag=[[NSUserDefaults standardUserDefaults] integerForKey:@"scanDataTag"];
    if (text!=nil && tag>0) {
        NSString *str=TRIM(text);
        if (str.length>0) {
            [self sendStringViewController:text withTag:tag];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    [self geolocation2];
}

-(void) viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
    [self.locationUpdateTimer invalidate];
<<<<<<< HEAD
}


//location
-(void)allowLocationAccess{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox addButton: NSLocalizedString(@"Settings", @"") target:self selector:@selector(setting:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Turn ON Location Permission to Continue...", @" ") closeButtonTitle:nil duration:1.0f ];
}




-(IBAction)setting:(id)sender{
    [self.alertbox hideView];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {if (success) {NSLog(@"Opened url");}
    }];
    //Location
}


-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


-(void)geolocation{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    ceo = [[CLGeocoder alloc]init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    if(locationManager.location.coordinate.latitude > 0){
        lat_app = locationManager.location.coordinate.latitude;
        longi_app = locationManager.location.coordinate.longitude;
    }
    self.latitude = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    NSLog(@"latlong %@", self.latitude);
    NSLog(@"latlong %@", self.longitude);

    [locationManager stopUpdatingLocation];
}//Location

-(void)geolocation2{
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(getLocation)
                                   userInfo:nil
                                    repeats:YES];
=======
>>>>>>> main
}

- (void)getLocation {
    CLLocation *currentLocation = locationManager.location;
    if (currentLocation != nil) {
        lat_app = currentLocation.coordinate.latitude;
        longi_app = currentLocation.coordinate.longitude;
        //[self.view makeToast:[NSString stringWithFormat:@"%.8lf", lat_app] duration:2.0 position:CSToastPositionCenter];
    }
}

//location
-(void)allowLocationAccess{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox addButton: NSLocalizedString(@"Settings", @"") target:self selector:@selector(setting:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Turn ON Location Permission to Continue...", @" ") closeButtonTitle:nil duration:1.0f ];
}

- (IBAction)logoTap:(UIButton *)sender{
    
    // [self.view makeToast:@"Welcome To LoadProof" duration:2.0 position:CSToastPositionCenter];

      if(popoverViewController == nil){
            popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"popover"];
        }
        popoverViewController.preferredContentSize = CGSizeMake(320, 300);
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popoverController = popoverViewController.popoverPresentationController;
        //popoverController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
        popoverController.delegate = self;
        popoverController.sourceView = self.view;
        popoverController.sourceRect = [sender frame];

        [self presentViewController:popoverViewController animated:YES completion:nil];
}


<<<<<<< HEAD
=======
-(IBAction)setting:(id)sender{
    [self.alertbox hideView];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {if (success) {NSLog(@"Opened url");}
    }];
    //Location
}


-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


-(void)geolocation{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    ceo = [[CLGeocoder alloc]init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    if(locationManager.location.coordinate.latitude > 0){
        lat_app = locationManager.location.coordinate.latitude;
        longi_app = locationManager.location.coordinate.longitude;
    }
    self.latitude = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    NSLog(@"latlong %@", self.latitude);
    NSLog(@"latlong %@", self.longitude);

    [locationManager stopUpdatingLocation];
}//Location

-(void)geolocation2{
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(getLocation)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)getLocation {
    CLLocation *currentLocation = locationManager.location;
    if (currentLocation != nil) {
        lat_app = currentLocation.coordinate.latitude;
        longi_app = currentLocation.coordinate.longitude;
        //[self.view makeToast:[NSString stringWithFormat:@"%.8lf", lat_app] duration:2.0 position:CSToastPositionCenter];
    }
}


- (IBAction)logoTap:(UIButton *)sender{
    
    // [self.view makeToast:@"Welcome To LoadProof" duration:2.0 position:CSToastPositionCenter];

      if(popoverViewController == nil){
            popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"popover"];
        }
        popoverViewController.preferredContentSize = CGSizeMake(320, 300);
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popoverController = popoverViewController.popoverPresentationController;
        //popoverController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
        popoverController.delegate = self;
        popoverController.sourceView = self.view;
        popoverController.sourceRect = [sender frame];

        [self presentViewController:popoverViewController animated:YES completion:nil];
}


>>>>>>> main
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}



//****************************************************
#pragma mark - Action Methods
//****************************************************


- (IBAction)loadpoof_entend_click:(id)sender {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted ) {;
        NSLog(@"denied");
        [self allowLocationAccess];
    }else {
        IGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IGVC"];
        IGVC.btnTag = 101;
        
        IGVC.txtTag = 101;
        [IGVC setDelegate:self];
        [self.navigationController pushViewController:IGVC animated:YES];
    }
}

-(void) driverParkload{
    @try{
        NSMutableArray *parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
//        int currentloadnumber = parkloadarray.count - 1;
        if(parkloadarray != NULL && parkloadarray.count > 0){
            NSString *DriverVC = [[NSUserDefaults standardUserDefaults] valueForKey:@"DriverCurrentVC"];
            NSMutableDictionary* currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"default_language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [LanguageManager setupCurrentLanguage];
            if(currentLotRelatedData){
                DriverUploadViewController *driverCam = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverUploadVC"];
                [self.navigationController pushViewController:driverCam animated:YES];
            }else{
//                if([DriverVC  isEqual: @"DriverUpload"]){
//                    DriverUploadViewController *driverCam = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverUploadVC"];
//                    [self.navigationController pushViewController:driverCam animated:YES];
//                }else {
                    DriverCameraViewController *driverCam = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverCameraVC"];
                    [self.navigationController pushViewController:driverCam animated:YES];
               // }
            }
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"Home" forKey:@"DriverCurrentVC"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }@catch (NSException *exception) {
        NSLog(@"trrrrrrr%@", exception.reason);
    }
}

-(void)sendStringViewController:(NSString *) string withTag :(NSInteger) tagNumber
{
   
    NSArray *items = [string componentsSeparatedByString:@"sitedata="];
    if(items.count > 1){
        if([items[1] containsString:@"LP"]){
            NSArray *ids = [items[1] componentsSeparatedByString:@"LP"];
            if(ids.count > 1){
                [self driverSiteValidationApiCall:ids[0] withTag:ids[1]];
            }else {
                [self.view makeToast:items[1] duration:2.0 position:CSToastPositionCenter];
            }
        }else {
            [self.view makeToast:items[1] duration:2.0 position:CSToastPositionCenter];
        }
    }else {
        [self.view makeToast:string duration:2.0 position:CSToastPositionCenter];
    }
    //barcode&ocr
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)handleNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *data = userInfo[@"deeplinkData"];
     NSArray *items = [data componentsSeparatedByString:@"sitedata="];
     if(items.count > 1){
         if([items[1] containsString:@"LP"]){
             NSArray *ids = [items[1] componentsSeparatedByString:@"LP"];
             if(ids.count > 1){
                 [self driverSiteValidationApiCall:ids[0] withTag:ids[1]];
             }else {
                 [self.view makeToast:items[1] duration:2.0 position:CSToastPositionCenter];
             }
         }else {
             [self.view makeToast:items[1] duration:2.0 position:CSToastPositionCenter];
         }
     }else {
         if([data containsString:@"LP"]){
             NSArray *ids = [data componentsSeparatedByString:@"LP"];
             if(ids.count > 1){
                 [self driverSiteValidationApiCall:ids[0] withTag:ids[1]];
             }else {
                 [self.view makeToast:items[1] duration:2.0 position:CSToastPositionCenter];
             }
         }else{
             [self.view makeToast:data duration:2.0 position:CSToastPositionCenter];
         }
     }
    // Use the data in your function
   // [self driverSiteValidationApiCall:@"1590" withTag:@"1127653"];
}

-(void)driverSiteValidationApiCall: (NSString *) s_id withTag :(NSString *) loadId{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSMutableArray *parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
        [[NSUserDefaults standardUserDefaults] setInteger: -1 forKey:@"DriverCurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"DriverParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf =self;
        NSString * accessVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
        [ServerUtility driverLoadValidationCid:s_id withLoadid:loadId andCompletion:^(NSError * error ,id data,float dummy){
            AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
            delegate.isMaintenance=NO;
            if (!error)
            {
                NSLog(@"App delegate data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                    [DictData addEntriesFromDictionary:data];
                    
                    NSLog(@"currentVC:%@",delegate.CurrentVC);
                    [self getProfileForDriver: (DictData) withsecond: s_id  withthird: loadId];
                    //                [self driverValidate: cid];
                }else{
                    if([data valueForKey:@"multi_device"]){
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
                        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"] subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:-100 ];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    }else{
                        NSLog(@"Error:%@",error);
                        [self.view makeToast:[data objectForKey:@"msg"] duration:2.0 position:CSToastPositionCenter];
                    }
                }
            }else {
                [self.view makeToast:@"Invalid QR" duration:2.0 position:CSToastPositionCenter];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    } else {
        [self.view makeToast:NSLocalizedString(@"No Internet!",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

-(void) getProfileForDriver:(NSMutableDictionary *) DictData withsecond:(NSString*) sid withthird:(NSString*) load_id{
<<<<<<< HEAD
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //getting the user profile data
    NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
    NSString * cid = [DictData objectForKey:@"c_id"];
//    NSString * tappiid = [DictData objectForKey:@"tappi_id"];
    NSString * tappiid = @"";
    NSString * pic_count = [DictData objectForKey:@"pic_count"];
    NSString * video_count = [DictData objectForKey:@"video_count"];
    NSString * plan_count = [DictData objectForKey:@"plancount"];
        //iterating user profile data
    NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:userProfileData options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myString);
        //changes
    //getting new data
    NSMutableArray *newnetwork = [userProfileData objectForKey:@"network-data"];
        //declaring variables for new data
//    int newfieldlength = 0;
//    int newfieldid = 0;
//    NSString *newfieldlabel;
//    int newcount = 0 ;
    
    //getting old data from app delegate
//    NSMutableArray *arr = delegate.userProfiels.arrSites;
    self.sites = delegate.userProfiels.arrSites;
    SiteData *sites = delegate.siteDatas;
    NSArray *oldArray = sites.arrFieldData;
//    int oldfieldlength = 0;
//    int oldfieldid = 0;
//    NSString *oldfieldlabel;
//    BOOL oldfieldactive = false;
//    BOOL oldfieldmandatary = false;
//    BOOL newfieldactive = false;
//    BOOL newfieldmandatary = false;
//    int oldnetworkid = sites.networkId;
//    int old_site_id = sites.siteId;
//    BOOL networkMatched = NO;
//    BOOL siteMatched =  NO;
//    int newnetworkid = 0 ;
//    int oldcount = (int)oldArray.count;
    if(userProfileData != nil){
            //array is null
        NSLog(@"networkid is null while killing the app");
        DriverData *userData = [[DriverData alloc]initWithDictionary:userProfileData];
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        delegate.driverSiteProfiles = userData;
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
            NSMutableArray *qrArrFieldsData = nil;
            if ([dictNetworkData objectForKey:@"qr_field_data"]) {
                NSArray *qrarrRawFieldData = [dictNetworkData objectForKey:@"qr_field_data"];
                for (NSDictionary *dictFieldData in qrarrRawFieldData) {
                    if (!qrArrFieldsData) {
                        qrArrFieldsData = [NSMutableArray array];
                    }
                    FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                    if (fieldData.active) {
                        [qrArrFieldsData addObject:fieldData];
                    }
                }
            }
            //Get the raw site data objects
            NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
            for (NSDictionary *dictSiteData in arrRawSiteData) {
                siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                siteData.networkId = NetworkId;
                siteData.arrFieldData = arrFieldsData;
                siteData.qrArrFieldData = qrArrFieldsData;
                if (!self.arrSites) {
                    self.arrSites = [NSMutableArray array];
                }
                [self.arrSites addObject:siteData];
            }
            
        }
        NSInteger p_count = [pic_count integerValue];
        NSInteger v_count = [video_count integerValue];
        NSInteger limit = [plan_count integerValue];
        NSInteger totalCapturedCount = p_count + v_count;
//        if(totalCapturedCount >= )
        delegate.userProfiels = userData;
        if(userData != nil && userData.arrSites != nil){
            if(totalCapturedCount < limit){
                @try{
                    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:userProfileData requiringSecureCoding:NO error:nil];
                    //[[NSUserDefaults standardUserDefaults]setValue: userProfileData forKey:@"DriverSiteData"];
                    [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"DriverSiteData"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self driverValidate: sid withsecond: load_id withthird:cid withfourth:tappiid withfifth: pic_count withsixth: video_count];
                }@catch(NSException * e){
                    NSLog(@"iiii");
                }
            }else {
                [self.view makeToast:@"Media limit reached for this load." duration:2.0 position:CSToastPositionCenter];
            }
        }else {
            [self.view makeToast:@"Invalid" duration:2.0 position:CSToastPositionCenter];
        }
//        [self getCustomCategory];
=======
    @try{
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //getting the user profile data
        NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
        NSString * cid = [DictData objectForKey:@"c_id"];
        //    NSString * tappiid = [DictData objectForKey:@"tappi_id"];
        NSString * tappiid = @"";
        NSString * pic_count = [DictData objectForKey:@"pic_count"];
        NSString * video_count = [DictData objectForKey:@"video_count"];
        NSString * plan_count = [DictData objectForKey:@"plancount"];
        //iterating user profile data
        NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:userProfileData options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@"%@",myString);
        //changes
        //getting new data
        NSMutableArray *newnetwork = [userProfileData objectForKey:@"network-data"];
        //declaring variables for new data
        //    int newfieldlength = 0;
        //    int newfieldid = 0;
        //    NSString *newfieldlabel;
        //    int newcount = 0 ;
        
        //getting old data from app delegate
        //    NSMutableArray *arr = delegate.userProfiels.arrSites;
        self.sites = delegate.userProfiels.arrSites;
        SiteData *sites = delegate.siteDatas;
        NSArray *oldArray = sites.arrFieldData;
        //    int oldfieldlength = 0;
        //    int oldfieldid = 0;
        //    NSString *oldfieldlabel;
        //    BOOL oldfieldactive = false;
        //    BOOL oldfieldmandatary = false;
        //    BOOL newfieldactive = false;
        //    BOOL newfieldmandatary = false;
        //    int oldnetworkid = sites.networkId;
        //    int old_site_id = sites.siteId;
        //    BOOL networkMatched = NO;
        //    BOOL siteMatched =  NO;
        //    int newnetworkid = 0 ;
        //    int oldcount = (int)oldArray.count;
        if(userProfileData != nil){
            //array is null
            NSLog(@"networkid is null while killing the app");
            DriverData *userData = [[DriverData alloc]initWithDictionary:userProfileData];
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.driverSiteProfiles = userData;
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
                NSMutableArray *qrArrFieldsData = nil;
                if ([dictNetworkData objectForKey:@"qr_field_data"]) {
                    NSArray *qrarrRawFieldData = [dictNetworkData objectForKey:@"qr_field_data"];
                    for (NSDictionary *dictFieldData in qrarrRawFieldData) {
                        if (!qrArrFieldsData) {
                            qrArrFieldsData = [NSMutableArray array];
                        }
                        FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                        if (fieldData.active) {
                            [qrArrFieldsData addObject:fieldData];
                        }
                    }
                }
                //Get the raw site data objects
                NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
                for (NSDictionary *dictSiteData in arrRawSiteData) {
                    siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                    siteData.networkId = NetworkId;
                    siteData.arrFieldData = arrFieldsData;
                    siteData.qrArrFieldData = qrArrFieldsData;
                    if (!self.arrSites) {
                        self.arrSites = [NSMutableArray array];
                    }
                    [self.arrSites addObject:siteData];
                }
                
            }
            NSInteger p_count = [pic_count integerValue];
            NSInteger v_count = [video_count integerValue];
            NSInteger limit = [plan_count integerValue];
            NSInteger totalCapturedCount = p_count + v_count;
            //        if(totalCapturedCount >= )
            delegate.userProfiels = userData;
            if(userData != nil && userData.arrSites != nil){
                if(totalCapturedCount < limit){
                    @try{
                        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:userProfileData requiringSecureCoding:NO error:nil];
                        //[[NSUserDefaults standardUserDefaults]setValue: userProfileData forKey:@"DriverSiteData"];
                        [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"DriverSiteData"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [self driverValidate: sid withsecond: load_id withthird:cid withfourth:tappiid withfifth: pic_count withsixth: video_count];
                    }@catch(NSException * e){
                        NSLog(@"iiii");
                    }
                }else {
                    [self.view makeToast:@"Media limit reached for this load." duration:2.0 position:CSToastPositionCenter];
                }
            }else {
                [self.view makeToast:@"Invalid" duration:2.0 position:CSToastPositionCenter];
            }
            //        [self getCustomCategory];
        }
    }@catch(NSException * ep){
        NSLog(@"error");
>>>>>>> main
    }
}

-(void) driverValidate: (NSString *) sid withsecond: (NSString*) loadid withthird: (NSString*) c_id withfourth: (NSString*) tappiid withfifth: (NSString*) imgCount withsixth: (NSString*) videoCount {
    @try{
        delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSString *cvc = delegateVC.CurrentVC;
        if(cvc != @"DriverCameraVC"){
        NSMutableDictionary *parkload = [[NSMutableDictionary alloc]init];
        [parkload setValue:sid forKey:@"s_id"];
        [parkload setValue:loadid forKey:@"load_id"];
        NSMutableArray *parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
       // if (parkloadarray == nil) {
            parkloadarray = [[NSMutableArray alloc]init];
       // }
        [parkloadarray addObject:parkload];
        int currentloadnumber;
        if(parkloadarray == NULL){
            currentloadnumber = 0;
        }else {
            currentloadnumber = (int)parkloadarray.count - 1;
        }
        [[NSUserDefaults standardUserDefaults] setInteger: currentloadnumber forKey:@"DriverCurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"DriverParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] setObject:c_id forKey:@"c_id"];
        //[[NSUserDefaults standardUserDefaults] setObject:tappiid forKey:@"tappi_id"];
            [[NSUserDefaults standardUserDefaults] setObject:imgCount forKey:@"image_count"];
            [[NSUserDefaults standardUserDefaults] setObject:videoCount forKey:@"video_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"default_language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [LanguageManager setupCurrentLanguage];
       
        DriverCameraViewController *driverCam = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverCameraVC"];
            [self.navigationController pushViewController:driverCam animated:YES];
        }
    }@catch (NSException *exception) {
        NSLog(@"trrrrrrr%@", exception.reason);
    }
}

- (IBAction)login_ok:(UIButton *)sender{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self geolocation];
        [self.UserName_txt resignFirstResponder];
        NSString *strUsername = self.UserName_txt.text;
        NSString *trimmedString = [strUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSLog(@"username: %@",trimmedString);
        if (trimmedString.length == 0) {
            [self.view makeToast:NSLocalizedString(@"Username Is Empty", @"") duration:2.0 position:CSToastPositionCenter];
        }else{
            [self checkForOffline: (trimmedString)];
        }
    }else if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted ) {;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    NSString *strUsername = self.UserName_txt.text;
    NSString *trimmedString = [strUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0){
        [self.view makeToast:NSLocalizedString(@"Username Is Empty", @"") duration:2.0 position:CSToastPositionCenter];
    }else{
        NSString *string = self.UserName_txt.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedString.length == 0) {
            [StaticHelper showAlertWithTitle:nil message:NSLocalizedString(@"Invalid UserName", @"") onViewController:self];
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
<<<<<<< HEAD
    }
    return YES;
}

-(void)checkForOffline: (NSString *) strUsername{
    
    //if([utils isNetworkAvailable] ==YES){
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        double latdouble = [self.latitude doubleValue];
        double landouble = [self.longitude doubleValue];
        // Your location from latitude and longitude
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latdouble longitude:landouble];
        // Call the method to find the address
        [self getAddressFromLocation:location completionHandler:^(NSMutableDictionary *d) {
             NSLog(@"address informations : %@", d);
             NSLog(@"CountyCode : %@", [d valueForKey:@"CountyCode"]);
             NSLog(@"ZIP code : %@", [d valueForKey:@"ZIP"]);
            NSString *countryCode = [d valueForKey:@"CountryCode"];
             // etc.
            [self callApi:(strUsername)];
         } failureHandler:^(NSError *error) {
             NSLog(@"Error : %@", error);
             [self callApi:(strUsername)];
         }];
    }else{
        [self offline:strUsername withBool:FALSE withBoolRest:FALSE];
    }
}

-(void)offline:(NSString *)strUsername withBool:(BOOL)isMaintanence withBoolRest:(BOOL)boolToRest{
    
=======
    }
    return YES;
}

-(void)checkForOffline: (NSString *) strUsername{
    
    //if([utils isNetworkAvailable] ==YES){
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        double latdouble = [self.latitude doubleValue];
        double landouble = [self.longitude doubleValue];
        // Your location from latitude and longitude
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latdouble longitude:landouble];
        // Call the method to find the address
        [self getAddressFromLocation:location completionHandler:^(NSMutableDictionary *d) {
             NSLog(@"address informations : %@", d);
             NSLog(@"CountyCode : %@", [d valueForKey:@"CountyCode"]);
             NSLog(@"ZIP code : %@", [d valueForKey:@"ZIP"]);
            NSString *countryCode = [d valueForKey:@"CountryCode"];
             // etc.
            [self callApi:(strUsername)];
         } failureHandler:^(NSError *error) {
             NSLog(@"Error : %@", error);
             [self callApi:(strUsername)];
         }];
    }else{
        [self offline:strUsername withBool:FALSE withBoolRest:FALSE];
    }
}

-(void)offline:(NSString *)strUsername withBool:(BOOL)isMaintanence withBoolRest:(BOOL)boolToRest{
    
>>>>>>> main
    NSString *temp_User=[[NSUserDefaults standardUserDefaults]stringForKey:@"OfflineUser"];
    if (temp_User != nil || temp_User.length>0) {
        
        if ([temp_User isEqualToString: strUsername]) {
            PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
            pinViewController.self.userName = strUsername;
            pinViewController.delegate = self;
            pinViewController.pinTitle = NSLocalizedString(@"Enter PIN", @"");
            pinViewController.errorTitle =  NSLocalizedString(@"Passcode is not correct", @"");
            pinViewController.cancelButtonHidden = NO; //default is False
            pinViewController.backgroundImage = [UIImage imageNamed:@""];
                // [pinViewController setTintColor:[UIColor redColor]];
            [self.navigationController pushViewController:pinViewController animated:YES];
        }else{
            if (isMaintanence ) {
                [self.view makeToast: NSLocalizedString(@"Server Under Maintenance.\nOffline Mode Works Only With Previously Used Username", @"") duration:2.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing.\nOffline Mode Works Only With Previously Used Username",@"") duration:2.0 position:CSToastPositionCenter];
            }
        }
    }else{
        if (isMaintanence) {
            [self.view makeToast: NSLocalizedString(@"Server Under Maintenance.",@" ") duration:2.0 position:CSToastPositionCenter];
        }else{
            [self.view makeToast: NSLocalizedString(@"Network Is Offline!\n No Offline Data Available.",@" ") duration:2.0 position:CSToastPositionCenter];
        }
    }
}


- (void)getAddressFromLocation:(CLLocation *)location completionHandler:(void (^)(NSMutableDictionary *placemark))completionHandler failureHandler:(void (^)(NSError *error))failureHandler
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
         if (failureHandler && (error || placemarks.count == 0)) {
             failureHandler(error);
         } else {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             if(completionHandler) {
                 completionHandler(placemark.addressDictionary);
             }
         }
    }];
}

-(void)callApi: (NSString *)strUsername {
    
    username_str = strUsername;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf =self;
    [[NSUserDefaults standardUserDefaults]setObject:NULL forKey:@"TokenID"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL forKey:@"TokenValue"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
        boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolvalue:%d",boolvalue);
    }
    //NSString * encodedString = [strUsername
      //    stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    
    [ServerUtility getUserName:strUsername withLat:self.latitude withLongi:self.longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
        AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
        delegate.isMaintenance=NO;
        
        
        if (!error) {
            //Printing the data received from the server
            NSLog(@"HomeSCreenData:%@",data);
            
            NSString *strResType = [data objectForKey:@"res_type"];
            if ([strResType.lowercaseString isEqualToString:@"error"])
            {
                NSString *strMsg = [data objectForKey:@"msg"];
                if([strMsg isEqualToString:@"Invalid username"]){
                    [self.view makeToast:NSLocalizedString(@"Invalid UserName", @"") duration:2.0 position:CSToastPositionCenter];
                }else{
                    [self.view makeToast:strMsg duration:2.0 position:CSToastPositionCenter];
                }
                
                NSLog(@"msgg:%@",strMsg);
<<<<<<< HEAD
                
            }else {
                PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                
=======
                
            }else {
                PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                
>>>>>>> main
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    NSLog(@"msg:%@",[data objectForKey:@"msg"]);
                    bool corporateLevelplan = YES;
                    NSString *AppAccessVersion = @"";
                    bool DeviceTrackerAccess = NO;
                    
                    //newly_added_api
                    if([data valueForKey:@"corporate_level_plan"] != NULL ){
                        corporateLevelplan = [[data objectForKey:@"corporate_level_plan"] intValue];
                    }
                    if([data valueForKey:@"app_access_version"] != NULL ){
                        AppAccessVersion = [data objectForKey:@"app_access_version"];
                    }
                    if([data valueForKey:@"device_track_access"] != NULL ){
                        DeviceTrackerAccess = [[data objectForKey:@"device_track_access"] intValue];
                    }
                    bool boolToRestrict = ![AppAccessVersion isEqual: @"v1"] && !DeviceTrackerAccess && !corporateLevelplan;
                    NSLog(@"Cor Home :%d",corporateLevelplan);
                    NSLog(@"AppV :%@",AppAccessVersion);
                    NSLog(@"DT Home :%d",DeviceTrackerAccess);
                    
                    [[NSUserDefaults standardUserDefaults] setBool:corporateLevelplan forKey:@"CorporateLevel"];
                    [[NSUserDefaults standardUserDefaults] setObject:AppAccessVersion forKey:@"AppAccessVersion"];
                    [[NSUserDefaults standardUserDefaults] setBool: DeviceTrackerAccess forKey:@"DeviceTrackerAccess"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"token_id"] forKey:@"TokenID"];
                    [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"token_value"] forKey:@"TokenValue"];
                    [[NSUserDefaults standardUserDefaults] setBool:boolToRestrict forKey:@"boolToRestrict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSLog(@"Home boolToRestrict:%d",boolToRestrict);
                    
                    if([data valueForKey:@"lat"] && [data valueForKey:@"long"] && [data valueForKey:@"radius"]){
                        NSLog(@"boolvalue home:%d",boolvalue);
                        
                        if (boolvalue == TRUE){
                            pinViewController.self.userName = strUsername;
                            pinViewController.delegate = self;
                            pinViewController.pinTitle = NSLocalizedString(@"Enter PIN",@"");
                            pinViewController.errorTitle = NSLocalizedString(@"Passcode is not correct",@" ");
                            pinViewController.cancelButtonHidden = NO; //default is False
                            pinViewController.backgroundImage = [UIImage imageNamed:@""];
                            [self.navigationController pushViewController:pinViewController
                                                                 animated:YES];
                            if(lat_app > 0){
                                [self getTimeZone:self->lat_app withsecond:self->longi_app];
                            }
                        }else if([[data objectForKey:@"lat"]  isEqual: @""] || [[data objectForKey:@"long"]  isEqual: @""] || [[data objectForKey:@"radius"]  isEqual: @""]){
                            
                            pinViewController.self.userName = strUsername;
                            pinViewController.delegate = self;
                            pinViewController.pinTitle = NSLocalizedString(@"Enter PIN",@"");
                            pinViewController.errorTitle = NSLocalizedString(@"Passcode is not correct",@" ");
                            pinViewController.cancelButtonHidden = NO; //default is False
                            pinViewController.backgroundImage = [UIImage imageNamed:@""];
                            [self.navigationController pushViewController:pinViewController animated:YES];
                            if(lat_app > 0){
                                [self getTimeZone:self->lat_app withsecond:self->longi_app];
                            }
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
                            
                            //jstForTesting
                            //                            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                            //                            NSString *str = [NSString stringWithFormat:@"DeviceLat: %f\n DeviceLongi: %f\n ApiLat: %f\n ApiLongi: %f\n Difference: %f\n RadiusAPI:%f",lat_app,longi_app,lat_api,longi_api,distanceInMeters,radius_api];
                            //                            [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
                            //                            [self.alertbox showSuccess:@"Warning!" subTitle:(@"%@",str) closeButtonTitle:nil duration:1.0f ];
                            //jstForTesting
                            
                            if ((radius_api == radius_app) || (difference < radius_api)){
                                if(lat_app > 0){
                                    [self getTimeZone:self->lat_app withsecond:self->longi_app];
                                }
                                pinViewController.self.userName = strUsername;
                                pinViewController.delegate = self;
                                pinViewController.pinTitle = NSLocalizedString(@"Enter PIN",@"");
                                pinViewController.errorTitle = NSLocalizedString(@"Passcode is not correct",@" ");
                                pinViewController.cancelButtonHidden = NO; //default is False
                                pinViewController.backgroundImage = [UIImage imageNamed:@""];
                                [self.navigationController pushViewController:pinViewController animated:YES];
                            }else{
                                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                                [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                                [self.alertbox showSuccess:NSLocalizedString(@"Warning !",@"") subTitle:NSLocalizedString(@"Please Login from Authorised Location.",@"") closeButtonTitle:nil duration:1.0f ];
                            }
                        }
                    }else{
                        pinViewController.self.userName = strUsername;
                        pinViewController.delegate = self;
                        pinViewController.pinTitle = NSLocalizedString(@"Enter PIN",@"");
                        pinViewController.errorTitle = NSLocalizedString(@"Passcode is not correct",@" ");
                        pinViewController.cancelButtonHidden = NO; //default is False
                        pinViewController.backgroundImage = [UIImage imageNamed:@""];
                        [self.navigationController pushViewController:pinViewController
                                                             animated:YES];
                    }
                }else if ([strResType.lowercaseString isEqualToString:@"maintenance"]){
                    delegate.isMaintenance=YES;
                    [self offline:strUsername withBool:TRUE withBoolRest:FALSE];
                }
            }
        }else{
            NSString *str_error = error.localizedDescription;
            if([str_error containsString:@"404"]){
                [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                [self offline:strUsername withBool:TRUE withBoolRest:TRUE];
                
            }else{
                if([data valueForKey:@"multi_device"]){
                    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"]closeButtonTitle:nil duration:1.0f ];
                }else{
                    [self.view makeToast:@"Error" duration:2.0 position:CSToastPositionCenter];
                }
            }
        }
        //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

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

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

- (IBAction)lang_table_btn:(id)sender{
    DriverCameraViewController *DriverCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverCameraVC"];

    //DriverCameraVC.siteData = self.siteData;
    //DriverCameraVC.siteName = @"Driver_Site";
    delegateVC.ImageTapcount = 0;
    delegateVC.isNoEdit = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"CurrentLoadNumber"];
    //[[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:DriverCameraVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"languageCell";
    LanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setLanguageName:language_data[indexPath.row] andIsSelected:indexPath.row == [LanguageManager currentLanguageIndex]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ELanguageCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [LanguageManager saveLanguageByIndex:indexPath.row];
    [self reloadRootViewController];
}

- (void)reloadRootViewController{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}



@end
