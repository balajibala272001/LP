//
//  AboutViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 10/8/18.
//  Copyright © 2018 Behroozi, David. All rights reserved.
//
#import "AboutViewController.h"
#import "StaticHelper.h"
#import "Constants.h"
#import "AZCAppDelegate.h"
#import "UIView+Toast.h"

@interface AboutViewController ()
{
    AZCAppDelegate *delegateVC;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.img.hidden = NO;
    bool boolvalue = false;
    //unlock_icon
    boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
    if (boolvalue == TRUE){
        self.img.hidden = NO;
    }else{
        self.img.hidden = YES;
    }
    NSLog(@"boolvalue:%d",boolvalue);
    //uuid_assign
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.uuid.adjustsFontSizeToFitWidth = YES;
    self.uuid.text = [NSString stringWithFormat:@" %@  ",str];
    
    //stack_ui
    _stack.layer.cornerRadius = 15;
    _stack.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.stack.layer setShadowOffset:CGSizeMake(3, 3)];
    [self.stack.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.stack.layer setShadowOpacity:0.5];
    self.stack.layer.shadowRadius = 5.0;
    //longpress_in_logo
    [self addGestureRecognizers:_logoimg];
    
    // set version and build fields from bundle
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // display in your own labels
    NSString * versionDetails =[NSString stringWithFormat: @"%@ %@",NSLocalizedString(@"Version",@" "),version];
    
    self.VersionLbl.text = versionDetails;
    NSString *AppVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"appVersion"];
    NSString *DeviceModel = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceModel"];
    NSString *UDID = [[NSUserDefaults standardUserDefaults] stringForKey:@"identifier"];
    NSString *OS = [[NSUserDefaults standardUserDefaults] stringForKey:@"OS"];
    NSString *OsVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"OSVersion"];
    NSString *DeviceName = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceName"];
   // DeviceName
    NSLog(@"DeviceName %@",DeviceName);
    NSLog(@"OSVersion %@",OsVersion);
    NSLog(@"appVersion %@",AppVersion);
    NSLog(@"DeviceModel %@",DeviceModel);
    NSLog(@"identifier %@",UDID);
    NSLog(@"OS %@",OS);
   
 // select needed color
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"GDPR Privacy Policy",@"")] ;
    self.lbl.linkTextAttributes =                                @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
    NSForegroundColorAttributeName:Blue};
    [attributedString addAttribute: NSLinkAttributeName value: @"https://privacypolicies.com/privacy/view/f5904d8b8bf9b0064592688552be71bc" range: NSMakeRange(0, attributedString.length) ];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    self.lbl.attributedText = attributedString;
    [self.lbl setFont:[UIFont boldSystemFontOfSize:17]];

    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"IOSVersion %@",iOSVersion);

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"AboutVC";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back_action_btn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addGestureRecognizers:(UIImageView *)img
{
    //longpress
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longpress.delegate = self;
    [_logoimg addGestureRecognizer:longpress];
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
    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Enter Master Access Keycode",@"") closeButtonTitle:nil duration:0.0f];
    }
}
-(void)passcheck:(id)sender
{
    if([self.textField.text  isEqualToString: @"Smart"])
    {
       [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLocation"];
        bool boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
        self.img.hidden = NO;
    }else if(self.textField.text.length == 0)
    {
        [self.view makeToast:NSLocalizedString(@"Password is Empty",@"") duration:2.0 position:CSToastPositionCenter];
    }else{
        [self.view makeToast:NSLocalizedString(@"Incorrect Password",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}
@end
