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
#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
    settingMewPinStateFisrt   = 0,
    settingMewPinStateConfirm = 1
};


@interface PasscodePinViewController (){
    NSInteger _shakes;
    NSInteger _direction;
}
@property (nonatomic)                   settingNewPinState  newPinState;
@property (nonatomic,strong)            NSString            *fisrtPassCode;
@property (weak, nonatomic) IBOutlet    UILabel             *laInstructionsLabel;

@end
static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;

@implementation PasscodePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCircles];
    
    
    self.SiteVC2 = [[SiteViewController alloc]init];
    
    
    pinLabel.text = self.pinTitle ? :@"Enter PIN";
    pinErrorLabel.text = self.errorTitle ? : @"PIN number is not correct";
    cancelButton.hidden = self.cancelButtonHidden;
    if (self.backgroundImage) {
        backgroundImageView.hidden = NO;
        backgroundImageView.image = self.backgroundImage;
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.newPinState    = settingMewPinStateFisrt;
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
        if ([self pinLenght] == _inputPin.length) {
            NSString *strUserName = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak typeof(self) weakSelf = self;
            [ServerUtility getUserNameAndUserPin:strUserName withUserPin:_inputPin andCompletion:^(NSError *error,id data)
             {
                 if (!error) {
                     NSLog(@"The second time login page%@",data);
                     NSString *strRestype = [data objectForKey:@"res_type"];
                     if ([strRestype.lowercaseString isEqualToString:@"success"]) {
                         NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                         [DictData addEntriesFromDictionary:data];
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
                         AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
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
                         // int oldnetworkid =  delegate.netId;
                         int old_site_id = sites.siteId;
                         BOOL networkMatched = NO;
                         BOOL siteMatched =  NO;
                         int newnetworkid ;
                         int oldcount = (int)oldArray.count;
                         if(arr != nil) {
                             NSMutableDictionary *newfieldsdata ;
                             NSMutableArray *newfieldsdataArray;
                             for (int j = 0; j<newnetwork.count; j++) {
                                 newfieldsdata = newnetwork [j];
                                 newfieldsdataArray = [newfieldsdata objectForKey:@"field_data"];
                                 newcount = (int) newfieldsdataArray.count;
                                 newnetworkid = [[newfieldsdata objectForKey:@"n_id"]intValue];
                                 NSLog(@" Old netid:%d",oldnetworkid);
                                 NSLog(@" New netid:%d",newnetworkid);
                                 if (oldnetworkid  == newnetworkid) {
                                     networkMatched = YES;
                                     break;
                                 }
                             }
                             if (networkMatched) {
                                 NSMutableArray *siteArray = [newfieldsdata objectForKey:@"site_data"];
                                 NSDictionary *newsiteArrayDict;
                                 for (int k =0;k<siteArray.count; k++) {
                                     newsiteArrayDict = siteArray[k];
                                     // [newsiteArrayDict setObject:[NSNumber numberWithInt:newnetworkid] forKey:@"n_id"];
                                     [newsiteArrayDict setValue:[NSNumber numberWithInt:newnetworkid] forKey:@"n_id"];
                                     int new_site_id =[[newsiteArrayDict objectForKey:@"s_id"]intValue];
                                     NSLog(@"old site id: %d",old_site_id);
                                     NSLog(@" new site id :%d",new_site_id);
                                     if (old_site_id == new_site_id) {
                                         siteMatched = YES;
                                         break;
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
                                                 //data doesnot matched
                                                 //updating the userprofiels in app delegate class
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                                                 message:@"Metadata fields are changed, refreshing the screen" delegate:self
                                                                                       cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                                 alert.tag = 0;
                                                 [alert show];
                                                 NSLog(@"Data not Matched");
                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshing" object:nil];
                                                 User *userData = [[User alloc]initWithDictionary:userProfileData];
                                                 //    SiteData *sitess = [[SiteData alloc]initWithDictionary:newfieldsdata];
                                                 //changes
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
                                                         [arrFieldsData addObject:fieldData];
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
                                                 //    int netowrkid = sitess.networkId;
                                                 //   NSLog(@" updated network id in site class:%d",netowrkid);
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
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                                         message:@"Metadata fields are changed, refreshing the screen" delegate:self
                                                                               cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                         alert.tag = 1;
                                         [alert show];
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
                                                 [arrFieldsData addObject:fieldData];
                                                 
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
                                         //  SiteData *sitess = [[SiteData alloc]initWithDictionary:newfieldsdata];
                                         AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                                         delegate.userProfiels = userData;
                                         delegate.siteDatas = siteData;
                                         NSLog(@"NO");
                                     }
                                     AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                     [self dismissViewControllerAnimated:YES completion:^{
                                         self.sites = delegate.userProfiels.arrSites;
                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
                                         
                                     }];
                                 } else {
                                     NSLog(@" first ");
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                                     message:@"This network/site no longer exist, please contact admin" delegate:self
                                                                           cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                     alert.tag = 3;
                                     [alert show];
                                 }
                             } else {
                                 NSLog(@"second");
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                                 message:@"This network/site no longer exist, please contact admin" delegate:self
                                                                       cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                 alert.tag = 2;
                                 [alert show];
                                 //networkMatched = NO;
                                 NSLog(@"network id not matched");
                                 ///TODO:move to the login screen
                             }
                         } else {
                             //array is null
                             NSLog(@"networkid is nulll while killing the app");
                             [self dismissViewControllerAnimated:YES completion:^{
                                 User *userData = [[User alloc]initWithDictionary:userProfileData];
                                 AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                 delegate.userProfiels = userData;
                                 self.sites = delegate.userProfiels.arrSites;
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"sites" object:self.sites];
                                 //   here you can create a code for presetn C viewcontroller
                             }];
                         }
                     } else if ([strRestype.lowercaseString isEqualToString:@"error"]) {
                         _direction = 1;
                         _shakes = 0;
                         [self shakeCircles:_pinCirclesView];
                         NSString *strMsg = [data objectForKey:@"msg"];
                         [self.view makeToast:strMsg duration:1.0 position:CSToastPositionCenter];
                     }
                 } else {
                     _direction = 1;
                     _shakes = 0;
                     [self shakeCircles:_pinCirclesView];
                     [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
                 }
                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             }];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
    }
    else if (alertView.tag == 1)
        
    {
        
    }
    else if (alertView.tag == 2)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                           instantiateViewControllerWithIdentifier: @"StartNavigation"];
            
            [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        }];
        
        
    }
    else if (alertView.tag == 3)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
            UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                           instantiateViewControllerWithIdentifier: @"StartNavigation"];
            
            [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
        }];
        
        
    }
    
    
}


#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
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

-(NSInteger)pinLenght {
    return 4;
}

#pragma mark Circles

- (void)addCircles {
    if([self isViewLoaded]) {
        [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_circleViewList removeAllObjects];
        _circleViewList = [NSMutableArray array];
        
        // _inputPin= @"";
        
        
        CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
        CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +2);
        CGFloat indent= 1.5* shiftBetweenCircle;
        if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f) {
            shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
            indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
        }
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
    if(symbolIndex>=_circleViewList.count)
        return;
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
    
    //small inner circle filling color
    
    //circleView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
    circleView.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    
}

- (IBAction)Logout:(id)sender {
    
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [delegate.DisplayOldValues removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
    
    
    
    UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                   instantiateViewControllerWithIdentifier: @"StartNavigation"];
    
    //  [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
    [[AZCAppDelegate sharedInstance] clearAllLoads];
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
