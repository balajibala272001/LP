//
//  DriverUploadViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 10/01/2023.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import "DriverUploadViewController.h"
#import "StaticHelper.h"
#import "ServerUtility.h"
#import "UIView+Toast.h"
#import "CustomIOSAlertView.h"
#import "ProjectDetailsViewController.h"
#import "PicViewController.h"
#import "LoadSelectionViewController.h"
#import <OpinionzAlertView.h>
#import "Reachability.h"
#import "MRCircularProgressView.h"
#import "AZCAppDelegate.h"
#import "PPPinCircleView.h"
#import "Add_on.h"

#define kOpinionzSeparatorColor [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]
#define kOpinionzDefaultHeaderColor [UIColor colorWithRed:0.8 green:0.13 blue:0.15 alpha:1]

@interface DriverUploadViewController (){
    NSMutableDictionary* currentLotRelatedData;
    NSMutableArray *parkloadArray;
    NSInteger currentloadnumber;
    NSMutableDictionary * parkload;
    BOOL isUploadingPreviousLot, hasCustomCategory;
    NSMutableDictionary *parkLoadRelatedData;
    AZCAppDelegate *delegateVC;
    NSString* timeZoneName;
    bool hasAddon8;
    bool hasAddon7;
}

@end

@implementation DriverUploadViewController

-(int) checkForBatchUpload{

    int nextloadnumber=-1;
    for (int i=0; i<parkloadArray.count;i++) {
        NSDictionary *pload=[parkloadArray objectAtIndex:i];
        if ([[pload objectForKey: @"isAutoUpload"] isEqualToString:@"1"]) {
            nextloadnumber=i;
            break;
        }
    }
    return nextloadnumber;
}


-(int) totalBatchloadscount{
    int totloadcount=0;
    for (int i=0; i<parkloadArray.count;i++) {
        NSDictionary *pload=[parkloadArray objectAtIndex:i];
        NSLog(@"UPLOAD %d: %@",i,pload);
        if ([[pload objectForKey: @"isAutoUpload"] isEqualToString:@"1"]) {
            totloadcount++;
        }
    }
    return totloadcount;
}



-(void) setupBatchUplaod
{
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    currentloadnumber=[self checkForBatchUpload];
    self.park_btn.hidden=YES;
        
    NSMutableDictionary *pload=[parkloadArray objectAtIndex:currentloadnumber];
    //checkingAddon7Custom
    bool isAddon7CustomGpcc=[[pload objectForKey:@"isAddon7CustomGpcc"]boolValue];
    NSMutableArray*instData_custom =[pload objectForKey:@"instructData"];
    if(instData_custom != nil && instData_custom.count >0){
        hasAddon7=true;
    }else{
        hasAddon7=false;
    }
    self.UserCategory=[pload objectForKey:@"category"];
    //self.Category_Value_Label.text=self.UserCategory;
    self.Category_Value_Label.text= @"cat";
    self.arrayWithImages = [pload objectForKey:@"img"];
    delegate.ImageTapcount = self.arrayWithImages.count;
    int totalBatchloadscount=[self totalBatchloadscount];
    self.totalBatchloads.text=[NSString stringWithFormat:@"%d",self.counter];
    self.current_load.text = [NSString stringWithFormat:@"%d/%d",self.counter-totalBatchloadscount+1,self.counter];
    NSMutableDictionary *dictMetaData = [NSMutableDictionary dictionary];
    [dictMetaData setObject:[pload objectForKey:@"c_id"] forKey:@"c_id"];
    [dictMetaData setObject:[pload objectForKey:@"device_id"] forKey:@"device_id"];
    [dictMetaData setObject:[pload objectForKey:@"n_id"] forKey:@"n_id"];
    NSLog(@"Netid :%d",self.siteData.networkId);
    [dictMetaData setObject:[pload objectForKey:@"s_id"] forKey:@"s_id"];

    [dictMetaData setObject:[pload objectForKey:@"u_id"] forKey:@"u_id"];
    NSMutableDictionary *arrFieldValues = [[NSMutableDictionary alloc] init];
    if(hasAddon8 && !hasCustomCategory && !hasAddon7){
        arrFieldValues = [pload objectForKey:@"basefields"];
        [dictMetaData setObject:arrFieldValues forKey:@"fields"];
    }else{
        arrFieldValues = [pload objectForKey:@"fields"];
        [dictMetaData setObject:arrFieldValues forKey:@"fields"];
    }
    self.dictMetaData=dictMetaData;
    self.pic_count=self.currentIndex<0?0:self.currentIndex;
    ServerUtility * imge = [[ServerUtility alloc] init];
    imge.picslist = self.arrayWithImages ;
    [imge picslist];
}




-(void)viewDidLoad {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    //NSMutableDictionary *offlineDict=[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverSiteData"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DriverSiteData"];
    NSError* error;
    NSMutableDictionary *offlineDict = [ NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&error];
    DriverData *userData = [[DriverData alloc]initWithDictionary:offlineDict];
    if(userData.arrSites != nil){
        delegate.siteDatas = userData.arrSites[0];
        self.siteData = userData.arrSites[0];
    }
    
    //Calling Api_SiteMaintenance
//    [ServerUtility websiteMaintenance:^(NSError * error ,id data,float dummy){
//        if (!error) {
//            //Printing the data received from the server
//            NSLog(@"HomeSCreenData_siteMaintenance:%@",data);
//            bool maintenance = [[data objectForKey:@"maintenance"]boolValue];
//            int levelInt  = [[data objectForKey:@"level"]intValue];
//            NSString *level = [NSString stringWithFormat:@"%d",levelInt];
//            if(maintenance == TRUE){
//                if([level isEqualToString: @"1"] || [level isEqualToString: @"1.0"]){
//                    [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
//                }else if([level isEqualToString: @"2"] || [level isEqualToString: @"2.0"]){
//                    [[NSUserDefaults standardUserDefaults]setObject:@"True2" forKey:@"maintenance_stage"];
//                }else{
//                    [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
//                }
//            }else{
//                [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
//            }
//        }else{
//            NSString *str_error = error.localizedDescription;
//            if([str_error containsString:@"404"]){
//                [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
//            }else{
//                [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
//            }
//        }
//    }];
    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
    self.view.multipleTouchEnabled = NO;
    self.view.exclusiveTouch = YES;
    for(UIView* v in self.view.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            UIButton* btn = (UIButton*)v;
            [btn setExclusiveTouch:YES];
        }
    }
    
    self.image_progress.textColor = [UIColor blackColor];
    self.upload_lbl.text = NSLocalizedString(@"Start Uploading",@"");
    //checking_AddOn5
    hasCustomCategory=false;
//    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
//        Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
//        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
//            hasCustomCategory=true;
//            break;
//        }
//    }
    //Checking_add0n7
    hasAddon7 = false;
    
    //    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
    //        Add_on *add_on=[self.siteData.categoryAddon objectAtIndex:index];
    //        if ((self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue) {
    //            hasAddon7=true;
    //            break;
    //        }
    //    }
    
    //Checking_add0n8
    hasAddon8 = FALSE;
//    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
//        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
//        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
//            hasAddon8 = TRUE;
//        }
//    }
    //adview
    self.str = [[NSUserDefaults standardUserDefaults]objectForKey:@"refer"];
    if (![self.str isEqualToString:@""] && self.str != nil)
    {
        self.Ad_holder.layer.cornerRadius = 5;
        self.Ad_holder.backgroundColor =[UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha: 0.65];
        
        //circle view
        NSString *model=[UIDevice currentDevice].model;
        UILabel * circleView;
        if ([model isEqualToString:@"iPhone"]) {
            circleView =[[UILabel alloc]initWithFrame:CGRectMake( 5,5,50,50)];
            circleView.layer.cornerRadius =25;
            
        }else if([model isEqualToString:@"iPad"]){
            
            circleView =[[UILabel alloc]initWithFrame:CGRectMake( 5,0,70,70)];
            circleView.layer.cornerRadius =35;
            
        }else{
            circleView =[[UILabel alloc]initWithFrame:CGRectMake( 0,5,50,50)];
            circleView.layer.cornerRadius =25;
        }
        
        circleView.layer.borderColor=[UIColor whiteColor].CGColor;
        circleView.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.34 blue: 0.13 alpha: 1.00].CGColor;
        
        circleView.layer.borderWidth =3;
        //circleView.backgroundColor= [UIColor greenColor];
        //self.circle_view.backgroundColor= [UIColor redColor];
        [self.circle_view addSubview:circleView];
        
        //circle text
        UILabel *circle_txt ;
        if ([model isEqualToString:@"iPhone"]) {
            circle_txt= [[UILabel alloc] initWithFrame:CGRectMake(5,5,circleView.frame.size.width,(circleView.frame.size.height))];
            circle_txt.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        }else if([model isEqualToString:@"iPad"]){
            circle_txt= [[UILabel alloc] initWithFrame:CGRectMake(5,0,circleView.frame.size.width,(circleView.frame.size.height))];
            circle_txt.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        }else{
            circle_txt= [[UILabel alloc] initWithFrame:CGRectMake(0,5,circleView.frame.size.width,(circleView.frame.size.height))];
            circle_txt.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        }
        circle_txt.text =[NSString stringWithFormat:NSLocalizedString(@"Earn\n$ %@",@""),self.str];
        circle_txt.textColor=[UIColor whiteColor];
        circle_txt.numberOfLines= 0;
        circle_txt.textAlignment=NSTextAlignmentCenter;
        circle_txt.lineBreakMode= NSLineBreakByWordWrapping;
        circle_txt.clipsToBounds = YES;
        
        [self.circle_view addSubview:circle_txt];
        [self.circle_view bringSubviewToFront:circle_txt];
        
    }
    //else
    self.Ad_holder.hidden = YES;
    @try{
        parkloadArray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverParkLoadArray"] mutableCopy];
        NSLog(@"parkloadArray:%@",parkloadArray);
        currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];
        NSLog(@"Mythi View did load %@",currentLotRelatedData);
        if (currentLotRelatedData) {
            isUploadingPreviousLot = true;
            [self prepopulateDataFromPrevoiusLot];
        } else {
            isUploadingPreviousLot = false;
            currentLotRelatedData = [NSMutableDictionary dictionary];
            self.currentIndex = -1;
        }
        
        details = [[NSMutableDictionary alloc]init];
        
        savedOldValuesArray = [[NSMutableArray alloc]init];
        
        //bool isBatchUploadAvailable=[self isBatchUploadAvailable];
        self.isBatchUpload= [self checkForBatchUpload]>-1;
        if(self.isBatchUpload){
            self.counter = [self totalBatchloadscount];
            [self setupBatchUplaod];
            
            
        }else{
            
            self.totalBatchloads.text = @"1";
            self.progressLabel.text = @"1/1";
            currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverCurrentLoadNumber"] intValue];
            parkload=[parkloadArray objectAtIndex:currentloadnumber];
            self.arrayWithImages = [parkload objectForKey:@"img"];
            self.UserCategory = [parkload objectForKey:@"category"];
//            self.Category_Value_Label.text = self.UserCategory;
            self.Category_Value_Label.text= @"cat";
            //self.progressLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];
            self.image_progress.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];
            //self.pic_count = @(self.arrayWithImages.count).stringValue;
            
        }
        self.upload_btn.layer.cornerRadius = 20;
        self.upload_lbl.text = NSLocalizedString(@"Start Uploading",@"");
        
        //self.Category_Value_Label.text = self.UserCategory;
        //self.current_load.hidden = YES;
        self.image_progress.hidden = YES;
        self.circularProgressView.hidden = YES;
        self.progressView.hidden = YES;
        self.progressView.progress = 0.0;
        self.gif_img.hidden = YES;
       
        
//        self.SiteName_Value_Label.text = self.siteData.siteName;
        self.SiteName_Value_Label.text = self.siteData.siteName;
        self.SiteName_Value_Label.minimumScaleFactor = 0.5;
        self.SiteName_Value_Label.numberOfLines = 2;
        
        self.Category_Value_Label.minimumScaleFactor = 0.6;
        self.Category_Value_Label.numberOfLines = 2;
        
        int count  = self.arrayWithImages.count;
        //self.progressLabel.text = [NSString stringWithFormat:@"%d",count];
        self.image_progress.text = [NSString stringWithFormat:@"%d",count];
        self.current_load.text = [NSString stringWithFormat:@"%d",count];
        
        self.Sub_View.layer.cornerRadius = 10;
        self.Sub_View.layer.borderWidth = 1;
        self.Sub_View.layer.borderColor = Blue.CGColor;
        // self.navigationItem.title = @"Upload";
        
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
        self.back_btn = [[UIBarButtonItem alloc] initWithCustomView:back];
        self.navigationItem.leftBarButtonItem =self.back_btn;
        self.upload_btn.layer.cornerRadius = self.view.frame.size.width/15;
        self.upload_btn.layer.borderColor = [UIColor blackColor].CGColor;
        self.upload_btn.layer.borderWidth = 0.5;
        [self.upload_btn.layer setShadowOffset:CGSizeMake(3, 3)];
        [self.upload_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.upload_btn.layer setShadowOpacity:0.5];
        self.upload_btn.layer.shadowRadius = 5.0;
        self.upload_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.park_btn.layer.cornerRadius = self.view.frame.size.width/15;
        self.park_btn.layer.borderColor = [UIColor blackColor].CGColor;
        self.park_btn.layer.borderWidth = 0.5;
        [self.park_btn.layer setShadowOffset:CGSizeMake(3, 3)];
        [self.park_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.park_btn.layer setShadowOpacity:0.5];
        self.park_btn.layer.shadowRadius = 5.0;
        self.park_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.park_btn.hidden=YES;
        self.Category_Value_Label.hidden = YES;
        
        
        
        self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
        
        [super viewDidLoad];
        //gif_view
        _gif_img.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"0.png"],
                                    [UIImage imageNamed:@"1.png"],
                                    [UIImage imageNamed:@"2.png"],
                                    [UIImage imageNamed:@"3.png"],
                                    [UIImage imageNamed:@"4.png"],
                                    [UIImage imageNamed:@"5.png"],
                                    [UIImage imageNamed:@"6.png"],
                                    [UIImage imageNamed:@"0.png"],
                                    [UIImage imageNamed:@"1.png"],
                                    [UIImage imageNamed:@"2.png"],
                                    [UIImage imageNamed:@"3.png"],
                                    [UIImage imageNamed:@"4.png"],
                                    [UIImage imageNamed:@"5.png"],
                                    [UIImage imageNamed:@"6.png"],
                                    nil];
        
        _gif_img.animationDuration = 2.0f;
        _gif_img.animationRepeatCount = 0;
        [_gif_img startAnimating];
        //gif_view
        if(self.isupload == TRUE){
            self.isupload = FALSE;
            [self upload_btn_action:self.view];
        }
        
    }@catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"DriverUpload" forKey:@"DriverCurrentVC"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* tappi_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"tappi_id"];
    if(tappi_id != nil && ![tappi_id isEqual:@""]){
        self.tappi_id = (int)[tappi_id integerValue];
    }else {
        self.tappi_id = 0;
    }
    self.park_btn.hidden = YES;
    self.progressLabel.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"DriverUploadVC";
    if (isUploadingPreviousLot) {
        [self upload_btn_action:nil];
        [self handleTimer];
        //}
    }else {
        //(Calling Api_SiteMaintenance
        if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            [ServerUtility websiteMaintenance:^(NSError * error ,id data,float dummy){
                if (!error) {
                    //Printing the data received from the server
                    NSLog(@"uploadscreen_siteMaintenance:%@",data);
                    bool maintenance = [[data objectForKey:@"maintenance"]boolValue];
                    int levelInt  = [[data objectForKey:@"level"]intValue];
                    NSString *level = [NSString stringWithFormat:@"%d",levelInt];
                    if(maintenance == TRUE){
                        if([level isEqualToString: @"1"] || [level isEqualToString: @"1.0"]){
                            [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                            [self.upload_btn setHidden:YES];
                        }else if([level isEqualToString: @"2"] || [level isEqualToString: @"2.0"]){
                            [[NSUserDefaults standardUserDefaults]setObject:@"True2" forKey:@"maintenance_stage"];
                            [self.upload_btn setHidden:YES];
                        }else{
                            //[self enableUploadButton];
                            [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                        }
                    }else{
                        //[self enableUploadButton];
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                }else{
                    NSString *str_error = error.localizedDescription;
                    if([str_error containsString:@"404"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                        [self.upload_btn setHidden:YES];
                    }else{
                        //[self enableUploadButton];
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                }
                [self handleTimer];
                NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
                bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
                if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
                    if((self.alertbox == nil) || (![self.alertbox isVisible]))
                    {
                        [self.view makeToast:@"Server Under Maintenance" duration:2.0 position:CSToastPositionCenter];
                    }
                }
//                else if([maintenance_stage isEqualToString:@"False"]){
//                    if(self.isupload != TRUE && self.isBatchUpload != TRUE && isUploadingPreviousLot != TRUE){
//                        [self enableUploadButton];
//                    }
//                }
            }];
        }else{
            [self handleTimer];
        }
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted ) {
        NSLog(@"denied");
        [self allowLocationAccess];
    }
}

//location
-(void)allowLocationAccess
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox addButton: NSLocalizedString(@"Settings", @" ") target:self selector:@selector(permissionSetting:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Turn ON Location Permission to Continue...", @" ") closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)permissionSetting:(id)sender{
    [self.alertbox hideView];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {if (success) {NSLog(@"Opened url");}
    }];
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)handleTimer {
    @try{
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //internet_indicator
        UIButton *networkStater;
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(140,12,16,16)];
        }else{
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
        }
        networkStater.layer.masksToBounds = YES;
        networkStater.layer.cornerRadius = 8.0;
        //cloud_indicator
        UIButton *cloud_indicator;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(160,3,35,32)];
        }else{
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(10,3,35,32)];
        }
        cloud_indicator.layer.masksToBounds = YES;
        cloud_indicator.layer.cornerRadius = 10.0;
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 40)];
        titleLabel.text = NSLocalizedString(@"Upload",@"");
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
        
        //cloud_indicator
        [cloud_indicator addTarget:self action:@selector(cloud_poper:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cloud_indicator];
        
        //internet_indicator
        networkStater.layer.borderWidth = 1.0;
        [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:networkStater];
        self.navigationItem.titleView = view;
    }@ catch(NSException *exp){
        NSLog(@"%@dataaaa",exp.description);
    }
}

-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Offline.",@"");
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
        
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];

    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }

    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


-(IBAction)upload:(id)sender {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
        bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
        if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
            [self.view makeToast:@"Server Under Maintenance" duration:2.0 position:CSToastPositionCenter];
        } else {
            [self preUploadLot];
            //self.view.userInteractionEnabled = NO;
            [self.Upload setEnabled:NO];
            self.image_progress.text = [NSString stringWithFormat:@"0/%d",(int)self.arrayWithImages.count];
            //self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
           // [self uploadingImage];
        }
    } else {
        [self networkerrorAlert];
    }
}

-(void) prepopulateDataFromPrevoiusLot {
        // prepopulate array
    NSMutableArray* imagesArray = [currentLotRelatedData objectForKey:@"img"];
    NSMutableArray* arrayWithImages = [NSMutableArray array];
    for (NSInteger index = 0; index < imagesArray.count; index++) {
        NSMutableDictionary *imageDic = [imagesArray[index] mutableCopy];
            // we will work on image path now.
        [arrayWithImages addObject:imageDic];
    }
    
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    self.arrayWithImages = arrayWithImages;

    self.dictMetaData = [[currentLotRelatedData objectForKey:@"self.dictMetaData"] mutableCopy];
    self.isEdit = [[currentLotRelatedData objectForKey:@"self.isEdit"] boolValue];
    self.UserCategory = [currentLotRelatedData objectForKey:@"self.UserCategory"];
    self.Device_id = [currentLotRelatedData objectForKey:@"self.Device_id"];
    self.currentIndex = [[currentLotRelatedData objectForKey:@"self.currentIndex"] intValue];
    self.load_id = [[currentLotRelatedData objectForKey:@"self.load_id"] intValue];
    self.pic_count = [[currentLotRelatedData objectForKey:@"self.pic_count"] intValue];
        //self.sitename = [currentLotRelatedData objectForKey:@"self.sitename"];

    if (self.image_quality==nil) {
        self.image_quality = [currentLotRelatedData objectForKey:@"self.image_quality"];
    }
        // self.image_quality = [currentLotRelatedData objectForKey:@"self.image_quality"];

//    self.siteData.planname = [currentLotRelatedData objectForKey:@"PlanName"];

}

-(void) preUploadLot {
    // Folder -> Current Lot

    if (isUploadingPreviousLot) {
        return; // no need to save it, its already saved in there.
    }

    int Lnumber;
    if (self.isBatchUpload)
        Lnumber = [self checkForBatchUpload];
    else
        //currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverCurrentLoadNumber"] intValue];
        Lnumber=currentloadnumber;


    NSMutableDictionary *dictMetaData = [NSMutableDictionary dictionary];
    NSMutableDictionary *pload=[parkloadArray objectAtIndex:Lnumber];
//    [dictMetaData setObject:[pload objectForKey:@"c_id"] forKey:@"c_id"];
//    [dictMetaData setObject:[pload objectForKey:@"device_id"] forKey:@"device_id"];
//    [dictMetaData setObject:[pload objectForKey:@"n_id"] forKey:@"n_id"];
//    NSLog(@"Netid :%d",self.siteData.networkId);
//    [dictMetaData setObject:[pload objectForKey:@"s_id"] forKey:@"s_id"];

//    [dictMetaData setObject:[pload objectForKey:@"u_id"] forKey:@"u_id"];
    NSMutableDictionary *arrFieldValues = [[NSMutableDictionary alloc]init];
//    if(hasAddon8 && !hasCustomCategory && !hasAddon7){
//        arrFieldValues = [pload objectForKey:@"basefields"];
//        [dictMetaData setObject:arrFieldValues forKey:@"fields"];
//    }else{
        arrFieldValues=[pload objectForKey:@"fields"];
        [dictMetaData setObject:arrFieldValues forKey:@"fields"];
//    }
        
    self.dictMetaData=dictMetaData;
    self.arrayWithImages= [pload objectForKey:@"img"];
//    self.UserCategory=[pload objectForKey:@"category"];
    NSMutableArray* newArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.arrayWithImages.count; index++) {
        NSMutableDictionary *imageDic = [self.arrayWithImages[index] mutableCopy];
            // now we will work on image path
        [newArray addObject:imageDic];
    }
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    [currentLotRelatedData setObject:newArray forKey:@"img"]; // 1
    [currentLotRelatedData setObject:self.dictMetaData forKey:@"self.dictMetaData"]; // 2


    NSDictionary *tempdict= nil;

    NSMutableArray *dictor= [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    if (dictor.count >Lnumber) {
            //tempdict=[delegate.DisplayOldValues objectAtIndex:Lnumber] ;
        tempdict=[dictor objectAtIndex:Lnumber];
    }

    if (tempdict!=nil && [tempdict objectForKey:@"currentIndex"] !=nil) {
        self.currentIndex=[[tempdict objectForKey:@"currentIndex"] intValue];
    }
    [currentLotRelatedData setObject:@(self.currentIndex) forKey:@"self.currentIndex"]; // 3
//    [currentLotRelatedData setObject:self.UserCategory forKey:@"self.UserCategory"]; // 4
    [currentLotRelatedData setObject:@(self.Device_id) forKey:@"self.Device_id"]; // 4
    if (tempdict!=nil && [tempdict objectForKey:@"load_id"] !=nil) {
        self.load_id=[[tempdict objectForKey:@"load_id"] intValue];
    }
    [currentLotRelatedData setObject:@(self.load_id) forKey:@"self.load_id"]; // 5
    if (tempdict!=nil && [tempdict objectForKey:@"pic_count"] !=nil) {
        self.pic_count=[[tempdict objectForKey:@"pic_count"] intValue];
    }
    [currentLotRelatedData setObject:@(self.pic_count) forKey:@"self.pic_count"]; // 6
    [currentLotRelatedData setObject:@(self.isEdit) forKey:@"self.isEdit"]; // 6
//    [currentLotRelatedData setObject:self.siteData.planname forKey:@"PlanName"];

    [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
    NSLog(@"Pic Count before uploading and Sync: %@", [currentLotRelatedData valueForKey:@"self.pic_count"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Pic Count before uploading and after sync: %@", [currentLotRelatedData valueForKey:@"self.pic_count"]);
}

-(void) updateCurrentIndexInUserDefaults {
        // update the self.currentIndex in user defaults
    NSLog(@"Saving current index : %d",self.currentIndex);
    [currentLotRelatedData setObject:@(self.currentIndex) forKey:@"self.currentIndex"]; // 2
    [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) postUploadLot {
        // clear the user defaults

    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"tappi_id"];
    [[NSUserDefaults standardUserDefaults] setInteger: -1 forKey:@"DriverCurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"c_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSTimeInterval delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self moveToLoadVC];
    });
}

-(void)enablebuttons{
    Add_on *add_on;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
        add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    NSMutableArray * newparkLoad = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    NSLog(@"self.IsiteId:%d",self.IsiteId);
    NSLog(@"self.addonName:%@",add_on.addonName);
    NSLog(@"self.siteData.siteId:%d",self.siteData.siteId);

//    if (hasAddon7){
//        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable && newparkLoad.count < 2){
//            self.park_btn.hidden=NO;
//            [self.park_btn setEnabled:TRUE];
//            [self.park_btn setTitle:NSLocalizedString(@"Draft  ",@"") forState:UIControlStateNormal];
//        }else{F
//            [self.park_btn setEnabled:FALSE];
//            self.park_btn.hidden=YES;
//        }
//    }else{
        self.park_btn.hidden=YES;
        [self.park_btn setEnabled:TRUE];
        [self.park_btn setTitle:NSLocalizedString(@"Park Load  ",@"") forState:UIControlStateNormal];

    //}
    [self.alertbox hideView];
    self.image_progress.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
    //self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
    self.view.userInteractionEnabled = YES;
    //[self.back_btn setEnabled:YES];
        //[self disableUploadButton];
    [self enableUploadButton];
    [self enableParkButton];
}



-(void)uploadingImage{
    //[self.circularProgressView setProgress:0.0 animated:YES];

    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
    if(self.arrayWithImages != nil && self.currentIndex + 1 < self.arrayWithImages.count)
    {
        
        AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
        
            // if (_isEdit && !isUploadingPreviousLot) {
        [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"UploadingParkLoadNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            //      }
        [self.alertbox hideView];
        [self.back_btn setEnabled:NO];
        self.upload_lbl.text = NSLocalizedString(@"Uploading...",@"");
        self.currentIndex = self.currentIndex + 1;
        int indexCount = self.currentIndex;
        self.image_progress.text = [NSString stringWithFormat:@"%d/%lu",indexCount,(unsigned long)self.arrayWithImages.count];

        //self.progressLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];
        int index = self.currentIndex;
        int count  =(int) self.arrayWithImages.count;
        self.progressView.progress = (index > 0) ? ((float)indexCount/count):0;
        self.progressLabel.hidden = NO;
        self.circularProgressView.hidden = YES;
        self.progressView.hidden = NO;
        self.image_progress.hidden = NO;
        self.gif_img.hidden = NO;
        NSString *userCategory = self.UserCategory;
        int device_id = self.Device_id;
        
        NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
        NSString *notes = [dict objectForKey:@"string"];
        
        NSString* pathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
        NSData *sampleData;
        NSString* imageName = [dict objectForKey:@"imageName"];
        NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
        if([extentionArray[1] isEqualToString:@"mp4"])
        {
            sampleData = [NSData dataWithContentsOfFile:[pathToFolder stringByAppendingPathComponent:imageName]];
        }
        else{
            UIImage* sample = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToFolder stringByAppendingPathComponent:imageName]]];
            //self.siteData.image_quality = @"4";

            //NSLog(@"Image Quality (upload):%@",self.siteData.image_quality);
//            if([self.siteData.image_quality isEqual:@"1"]) {
//                sampleData = UIImageJPEGRepresentation(sample, 0.93);
//                NSLog(@"compress ratio : %f",0.93);
//            }else if([self.siteData.image_quality isEqual:@"2"]) {
//                sampleData = UIImageJPEGRepresentation(sample, 0.85);
//                NSLog(@"compress ratio : %f",0.85);
//            }else if([self.siteData.image_quality isEqual:@"3"]){
                sampleData = UIImageJPEGRepresentation(sample, 0.994);
                NSLog(@"compress ratio : %f",0.994);
//            }else if([self.siteData.image_quality isEqual:@"4"]){
//                sampleData = UIImageJPEGRepresentation(sample, 1.0);
//            }
        }
        // NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((sample), 0.5)];
        NSLog(@"dict:%@",dict);
        
        NSNumber *ImageTime = [dict objectForKey:@"created_Epoch_Time"];
        NSNumber *latitude = [dict objectForKey:@"latitude"];
        NSNumber *longitude = [dict objectForKey:@"longitude"];
        NSNumber *load_tookout_type = [dict objectForKey:@"load_tookout_type"];
            //  NSData *sampleData = UIImageJPEGRepresentation(sample, 1.0);
        NSUInteger imageSize1   = sampleData.length;
        NSLog(@"size of image in KB in upload : %f", imageSize1/1024.0);
            // NSLog(@"%@",sampleData);
        
        FinalDict = [[NSMutableDictionary alloc]init];
            //FinalDict = [self.dictMetaData mutableCopy];
        FinalDict= self.dictMetaData;
//        if (hasCustomCategory) {
//            CategoryData *category;
//            for (int index=0; index<self.siteData.customCategory.count; index++) {
//                category= self.siteData.customCategory[index];
//                if ([category.categoryName isEqual: userCategory]) {
//                    [FinalDict setObject:[NSString stringWithFormat:@"%d", category.categoryId ] forKey:@"custom_category_id"];
//                    break;
//                }
//            }
//        }
   //     NSString *fnameload = delegate.userProfiels.firstName;
//        NSString *lnameload = delegate.userProfiels.lastName;
        NSString *Imei= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString* OsName = @"iOS";
        
//        Add_on *add_on;
//        self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
//        for (int index=0; index<self.siteData.categoryAddon.count; index++) {
//            Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
//            if([dict.addonName isEqual:@"addon_7"]){
//               add_on = [self.siteData.categoryAddon objectAtIndex:index];
//            }
//            NSLog(@"%@",dict.addonName);
//        }
        bool boolvalue;
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
            boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
            NSLog(@"boolvalue:%d",boolvalue);
        }else{
            boolvalue = FALSE;
            NSLog(@"boolvalue:%d",boolvalue);
        }
        NSTimeZone* timeZone = [NSTimeZone localTimeZone];
        NSLog(@"Name: %@", timeZone.name);
//        NSString * AppAccessVersion =  [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
//        NSLog(@"AppAccessVersion :%@",AppAccessVersion);
        
//        if (hasAddon7) {
//            NSString* inst = [dict objectForKey:@"InstructNumber"];
//            [FinalDict setObject:inst forKey:@"instruction_number"];
//
//            NSString * Profile_Id = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileId"];
//            [FinalDict setObject:Profile_Id forKey:@"profile_guide_id"];
//        }
//        if(hasAddon8 && !hasCustomCategory && !hasAddon7){
//            int inst = [[dict objectForKey:@"img_numb"]intValue];
//            NSMutableDictionary *arrtappiFieldValues = [[NSMutableDictionary alloc] init];
//            NSMutableDictionary *pload=[parkloadArray objectAtIndex:currentloadnumber];
//            arrtappiFieldValues = [[pload objectForKey:@"loopingfields"] objectAtIndex:inst];
//            NSLog(@"arrtappiFieldValues:%@",arrtappiFieldValues);
//            //NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
//            //[arr obj arrtappiFieldValues];
//            [FinalDict setObject:arrtappiFieldValues forKey:@"tappi_fields"];
//            inst = inst + 1;
//            [FinalDict setObject:[NSString stringWithFormat:@"%d",inst] forKey:@"tappi_id"];
//        }
        [FinalDict setObject:timeZone.name forKey:@"timeZone"];
//        [FinalDict setObject:@(boolvalue) forKey:@"Master"];
        [FinalDict setObject:Imei forKey:@"Imei"];
        [FinalDict setObject:ImageTime forKey:@"created_Epoch_Time"];
//        [FinalDict setObject:userCategory forKey:@"category"];
        [FinalDict setObject:load_tookout_type forKey:@"load_tookout_type"];
        [FinalDict setObject:latitude forKey:@"latitude"];
        [FinalDict setObject:longitude forKey:@"longitude"];
       // [FinalDict setObject:self.siteData.planname forKey:@"plan"];
        //[FinalDict setObject:fnameload forKey:@"first_name_load"];
        //[FinalDict setObject:lnameload forKey:@"last_name_load"];
        [FinalDict setObject:OsName forKey:@"Os_name"];
//        [FinalDict setObject:AppAccessVersion forKey:@"app_access_version"];
        
        ServerUtility * imge = [[ServerUtility alloc] init];
        imge.picslist = self.arrayWithImages ;
        [imge picslist];
        if(isUploadingPreviousLot){
            
            imge.picsCount = indexCount;
            NSLog(@"Deve ImageName @ Index : %@",[self.arrayWithImages objectAtIndex:indexCount]);
            NSLog(@"Deve Index : %d",indexCount);
            NSLog(@"Deve PicListName @ Index : %@",imge.picslist);
        }
        else{
            imge.picsCount = _pic_count;
            NSLog(@"imge.picsCount:%d",imge.picsCount);
        }

        if (notes.length > 0) {
            
            [FinalDict setObject:notes forKey:@"note"];
            
        }else
        {
            [FinalDict setObject:@"" forKey:@"note"];
        }
        if (self.load_id > 0) {
            [FinalDict setObject:[NSNumber numberWithInt:self.load_id] forKey:@"load_id"];
        }
        if (self.tappi_id > 0) {
            [FinalDict setObject:[NSNumber numberWithInt:self.tappi_id] forKey:@"tappi_id"];
        }else {
            [FinalDict setObject:@"" forKey:@"tappi_id"];
        }
        
        if (self.pic_count > 0) {
            [FinalDict setObject:[NSNumber numberWithInt:self.pic_count] forKey:@"pic_count"];
        }
            //GalleryMode
//        if(self.siteData.addon_gallery_mode!=nil){
//            [FinalDict setValue:self.siteData.addon_gallery_mode forKey:@"addon_gallery_mode"];
//        }
        [FinalDict setObject:@(self.siteData.siteId).stringValue forKey:@"site_id"];
        [FinalDict setObject:@(self.siteData.siteId).stringValue forKey:@"s_id"];
        [FinalDict setObject:@(self.siteData.networkId).stringValue forKey:@"n_id"];
        NSString* c_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"];
        [FinalDict setObject:c_id forKey:@"c_id"];
        NSString* driverName = [parkload valueForKey:@"driver_name"];
        [FinalDict setObject:driverName forKey:@"name"];
        NSString* driverPhone = [parkload valueForKey:@"driver_mobile"];
        [FinalDict setObject:driverPhone forKey:@"phone"];
//        //NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString * DeviceName = [UIDevice currentDevice].model;
        NSString * OSVersion = [UIDevice currentDevice].systemVersion;
     
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        //NSString *Os_name = @"iOS";
        [FinalDict setObject:OSVersion forKey:@"Os_version"];
        [FinalDict setObject:DeviceName forKey:@"Device_name"];
        //[FinalDict setObject:DeviceModel forKey:@"Device_model"];
        [FinalDict setObject:appVersionString forKey:@"Appversion"];
        
        NSLog(@"START REQUEST %@",FinalDict);
        NSLog(@"Request FinalDict index num %d : %@",_currentIndex,FinalDict);
        NSLog(@"END REQUEST");
        NSLog(@"sampleData:%@",sampleData);
        [self.upload_btn setHidden:YES];
//        if(hasAddon8 && !hasCustomCategory && !hasAddon7){

            [ServerUtility driverUploadImageWithAllDetails:FinalDict noteResource:sampleData andCompletion:^(NSError *error,id data, float percentage)
             {
                
                delegate.isMaintenance=NO;
                NSLog(@"PErcentarge :%f",percentage);
                if (error==nil && data==nil && percentage*100>0) {
                    
                    [self.circularProgressView setProgress:percentage animated:YES];
                    
                }else if (!error) {
                    NSLog(@"data:%@",data);
                    NSString *strResType = [data objectForKey:@"res_type"];
                    self.message = [data objectForKey:@"msg"];
                    if ([strResType.lowercaseString isEqualToString:@"maintenance"]){
                        delegate.isMaintenance=YES;
                        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
                        bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
                        //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
                            [self handleTimer];
                        //}
                        [self.view makeToast:NSLocalizedString(@"Server Under Maintenance!\nPark the Load and Try Again Later.",@"") duration:2.0 position:CSToastPositionCenter];
                        [self enablebuttons];
                    }else if ([strResType.lowercaseString isEqualToString:@"success"]) {
                        if (self.load_id == 0) {
                            self.load_id  = [[data objectForKey:@"load_id"]intValue];
                            [currentLotRelatedData setObject:@(self.load_id) forKey:@"self.load_id"]; // 5
                            [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        if (self.tappi_id == 0) {
                            self.tappi_id  = [[data objectForKey:@"tappi_id"]intValue]; // 5
                            [[NSUserDefaults standardUserDefaults] setObject:@(self.tappi_id).stringValue forKey:@"tappi_id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        NSString *email =[data objectForKey:@"nau_email"];
                        NSLog(@"Upload Successfully");
                        int index = self.currentIndex + 1;
                        self.pic_count = index;
                        
                        [currentLotRelatedData setObject:@(self.pic_count) forKey:@"self.pic_count"]; // 6
                        [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        int count  =(int) self.arrayWithImages.count;
                        self.progressView.progress = (index > 0) ? ((float)index/count):0;
                        NSLog(@" the progress value is:%f",self.progressView.progress);
                        
                        //FreeTier-Suresh
//                        NSLog(@"SiteData :%@",self.siteData);
//                        if([self.siteData.planname isEqualToString:@"FreeTier"]){
//                            if([data valueForKey:@"RemainingImagecount"] && [data valueForKey:@"RemainingVideocount"]){
//                                self.siteData.RemainingVideocount= [[data objectForKey:@"RemainingVideocount"] intValue] ;
//                                self.siteData.RemainingImagecount= [[data objectForKey:@"RemainingImagecount"] intValue];
//
//                                if (self.siteData.RemainingImagecount < 50) {
//                                    if (self.siteData.RemainingImagecount > 0) {
//                                        self.siteData.uploadCount = self.siteData.RemainingVideocount  + self.siteData.RemainingImagecount ;
//                                    }else if (self.siteData.RemainingVideocount > 0){
//                                        self.siteData.uploadCount= self.siteData.RemainingVideocount ;
//                                    }else{
//                                        self.siteData.uploadCount=0;
//                                    }
//                                }
//                            }
//                        }else{
//                            if([data valueForKey:@"RemainingSpacePercentage"]){
//
//                                self.siteData.RemainingSpacePercentage=[[data objectForKey:@"RemainingSpacePercentage"] doubleValue];
//                            }
//                        }
                        
                        if (index < self.arrayWithImages.count) {
                            [self updateCurrentIndexInUserDefaults];
                            [self uploadingImage];
                        }
                        else {
                            //AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
                            self.image_progress.text = [NSString stringWithFormat:@"%d/%lu",index,(unsigned long)self.arrayWithImages.count];
                            self.upload_lbl.text = NSLocalizedString(@"Uploaded",@"");
                            [self.back_btn setEnabled:NO];
                            // [self.Upload setEnabled:NO];
                            [self disableUploadButton];
                            // self.view.userInteractionEnabled = YES;
                            [delegate.window makeToast:NSLocalizedString(@"Uploaded Successfully",@"") duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
//                            NSString *user = delegate.userProfiels.userType;
//                            NSString *FirstName = delegate.userProfiels.firstName;
//                            NSString *LastName = delegate.userProfiels.lastName;
//                            NSString *corp_name = delegate.userProfiels.corporateEntity;
//                            NSString *SiteName = self.siteData.siteName;
                            
//                            NSString *Siteid = [NSString stringWithFormat:@"%d",self.siteData.siteId];
//                            NSString *Corpid = [NSString stringWithFormat:@"%d",delegate.userProfiels.cId];
                            NSString *Load_id_no = [NSString stringWithFormat:@"%d",self.load_id];
                            NSString *message = @"Quality Issue";
                            NSLog(@"message:%@",message);
                            NSLog(@"self.message:%@",self.message);
                            NSLog(@"loadidno:%@",Load_id_no);
                            
                            
//                            [details setObject:user forKey:@"user_type"];
//                            [details setObject:corp_name forKey:@"corp_name"];
                            //[details setObject:self.siteData.addOnMail forKey:@"email_id"];
                            
//                            [details setObject:FirstName forKey:@"first_name_load"];
//                            [details setObject:LastName forKey:@"last_name_load"];
//                            [details setObject:SiteName forKey:@"site_name"];
                            [details setObject:Load_id_no forKey:@"last_insert_load_id"];
                            [delegate clearCurrentLoad];
                            
//                            if(self.siteData.addOn && self.siteData.addOnMail !=NULL){
//                                [ServerUtility sendAddOnMail:user withEmail:self.siteData.addOnMail withFirstName:FirstName withLastName:LastName withSiteName:SiteName withSiteId:Siteid withCropId:Corpid withLoadId:Load_id_no withCorpName:corp_name andCompletion:^(NSError *error,id data,float dummy)
//                                 {
//                                    if (!error) {
//                                        NSLog(@"AddOnMail API:%@",data);
//                                    } else {
//                                        self.ErrorLocal = error.localizedDescription;
//                                        NSLog(@"AddOnMail:%@",error.localizedDescription);
//                                        [self errorAlert];
//                                    }
//                                }];
//                            }
//                            if ([self.UserCategory isEqualToString:message]) {
//                                [details setObject:email forKey:@"email_id"];
//                                //[details setObject:@"suresh.smargladiator@gmail.com" forKey:@"email_id"];
//                                [ServerUtility SendAllDetails:user withEmail:email withFirstName:FirstName withLastName:LastName withSiteName:SiteName withCorpId:Corpid withSiteId:Siteid withLoadId:Load_id_no andCompletion:^(NSError *error,id data,float dummy)
//                                 {
//                                    if (!error) {
//                                        NSLog(@"LAST API:%@",data);
//                                    } else {
//                                        self.ErrorLocal = error.localizedDescription;
//                                        NSLog(@"ERR:%@",error.localizedDescription);
//                                        [self errorAlert];
//                                    }
//                                }];
//
//                            }
                            
                            NSLog(@"details:%@",details);
                            //ending if
                            
                            //                     AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                            
                            delegate.ImageTapcount=0;
                            BOOL isParkLoadAvailable = false;
                            
                            if (_isEdit && parkloadArray.count > 0) {
                                
                                int loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
                                
                                [parkloadArray removeObjectAtIndex:loadNUmber];
                                [[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"DriverParkLoadArray"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                parkloadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
                                
                                //                            if (parkloadArray == nil || parkloadArray.count == 0) {
                                //                                [delegate clearAllLoads];
                                //                            }
                                if (!delegate.isNoEdit) {
                                    if (parkloadArray.count > 0) {
                                        [parkloadArray removeObjectAtIndex:loadNUmber];
                                    }
                                }
                                
                                if (parkloadArray.count>0) {
                                    
                                    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                    
                                    
                                    NSLog(@"LoadNumber :%d",loadNUmber);
                                    
                                    if([self checkForBatchUpload] !=-1) {
                                        
                                        self.currentIndex = -1;
                                        [self setupBatchUplaod ];
//                                        self.Category_Value_Label.text=self.UserCategory;
                                        self.Category_Value_Label.text= @"cat";
                                        self.load_id = 0;
                                        self.tappi_id = 0;
                                        
                                        isUploadingPreviousLot = false;
                                        
                                        [self uploader];
                                        
                                    }
                                }else{
                                    double delayInSeconds = .5;
                                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploaded" object:parkloadArray];});
                                    
                                }
                            }else {
                                int  loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
                                if (!delegate.isEdit &&parkloadArray.count>loadNUmber ) {
                                    if (parkloadArray.count > 0) {
                                        //new
                                        NSLog(@"load n:%d",loadNUmber);
                                        [parkloadArray removeObjectAtIndex:loadNUmber];
                                    }
                                    
                                    
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"DriverParkLoadArray"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
                                    
                                    
                                    if (parkLoadArray == nil) {
                                        parkLoadArray = [[NSMutableArray alloc] init];
                                    }
                                    
                                    if (parkLoadArray.count >0) {
                                        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                        
                                        
                                        NSLog(@"LoadNumber :%d",loadNUmber);
                                        
                                        if([self checkForBatchUpload] !=-1) {
                                            
                                            self.currentIndex = -1;
                                            [self setupBatchUplaod ];
//                                            self.Category_Value_Label.text=self.UserCategory;
                                            self.Category_Value_Label.text= @"cat";
                                            self.load_id=0;
                                            self.tappi_id=0;
                                            isParkLoadAvailable=YES;
                                            isUploadingPreviousLot = false;
                                            
                                            [self uploader];
                                            
                                        }else{
                                            isParkLoadAvailable=NO;
                                        }
                                    }else{
                                    }
                                }
                            }
                            
                            if (isParkLoadAvailable) {
                                
                            }else{
                                [self postUploadLot];
                            }
                            
                        }
                    }if ([strResType.lowercaseString isEqualToString:@"error"]){
                        
                        // if(self.currentIndex>-1)
                        //     self.currentIndex = self.currentIndex - 1;
                        if(self.currentIndex>-1){
                            
                            if((self.currentIndex -2)>0){
                                self.currentIndex = self.currentIndex -2;
                            }else{
                                self.currentIndex = 0;
                            }
                        }
                        [self updateCurrentIndexInUserDefaults];
                        //self.back_btn.hidden = YES;
                        [self.back_btn setEnabled:YES];
                        // [self.Upload setEnabled:NO];
                        [self disableUploadButton];
                        self.serverError= [data objectForKey:@"msg"];
                        self.serverError = [self.serverError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        
                        
                        NSString *loadid = @"";
                        if([data objectForKey:@"load_id"]!= nil)
                        {
                            loadid = [data objectForKey:@"load_id"];
                        }
                        NSString *tappiid = @"";
                        if([data objectForKey:@"tappi_id"]!= nil)
                        {
                            tappiid = [data objectForKey:@"tappi_id"];
                        }
                        //if([self.serverError isEqualToString:@"load did not upload successfully"] &&
                        
                        if((loadid!= nil && loadid > 0))
                        {
                            if(self.currentIndex>-1)
                                self.currentIndex-=1;
                            [self errorAlert];
                            self.view.userInteractionEnabled = YES;
                        }
                 
                        else
                        {
                        }
                    }
                } else{
                    
                    if(self.currentIndex>-1)
                        self.currentIndex = self.currentIndex - 1;
                    
                    [self updateCurrentIndexInUserDefaults];
                    NSLog(@" the current index after gettingg error:%d",self.currentIndex);
                    [self.back_btn setEnabled:YES];
                    //   [self.Upload setEnabled:NO];
                    [self disableUploadButton];
                    self.localerror = error.localizedDescription;
                    self.upload_lbl.hidden = YES;
                    [self errorAlert];
                    // [self.back_btn setEnabled:YES];
                    // [self.Upload setEnabled:YES];
                    self.view.userInteractionEnabled = YES;
                }
            }];
        //}
     }
    }else{
        [self networkerrorAlert];
  }
}

-(void)networkerrorAlert
{
    self.upload_lbl.hidden = YES;
    [self.back_btn setEnabled:NO];
    self.progressView.hidden = YES;
    self.gif_img.hidden = YES;
    self.progressLabel.hidden = YES;
    self.image_progress.hidden = YES;
    self.circularProgressView.hidden = YES;
    self.view.userInteractionEnabled = YES;
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
//    [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(enablebuttons:) backgroundColor:Green];
//    [self.alertbox addButton:NSLocalizedString(@"Delete Load",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
    [self.alertbox addButton:NSLocalizedString(@"Retry",@"")  target:self selector:@selector(retry:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:@"Network not available.\n Enable Network. Check your network connection" closeButtonTitle:nil duration:1.0f ];
}

-(void)errorAlert
{
    [self.back_btn setEnabled:NO];
    self.view.userInteractionEnabled = NO;
    
    self.progressView.hidden = YES;
    self.gif_img.hidden = YES;
//    self.current_load.hidden = YES;
    self.image_progress.hidden = YES;
    self.circularProgressView.hidden = YES;
    self.view.userInteractionEnabled = YES;
    
    NSString *context;
    if (self.serverError.length > 0) {
        context =self.serverError;
    } else {
        context =self.localerror;
    }
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    if ([context isEqualToString:NSLocalizedString(@"The storage space for this site is full, please contact admin.",@"")]) {
        [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(retryWithOk:) backgroundColor:Green];
    }else if([context isEqualToString:NSLocalizedString(@"Category is no longer exist",@"")]){
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(retryWithOk:) backgroundColor:Green];
    }else if([context isEqualToString:NSLocalizedString(@"Customized metadata is changed or no longer exist",@"")]){
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(retryWithOk:) backgroundColor:Green];
    }else if([context isEqualToString:NSLocalizedString(@"Metadata is changed or no longer exist",@"")]){
        
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(retryWithlogin:) backgroundColor:Green];
    }else{
        if(![context isEqualToString:@"The Internet connection appears to be offline."]
           && ![context isEqualToString:@"The Connection Lost! Try Again."]){
            [self.alertbox addButton:NSLocalizedString(@"Delete Load",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
        } 
        [self.alertbox addButton:NSLocalizedString(@"Retry",@"") target:self selector:@selector(retry:) backgroundColor:Green];
    }
    if([context isEqualToString:NSLocalizedString(@"The network connection was lost.",@"")]){
        [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"The Connection Lost! Try Again.",@"") closeButtonTitle:nil duration:1.0f ];
    }else{
        [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:context closeButtonTitle:nil duration:1.0f ];
    }
}

-(IBAction)deleteLoad:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"tappi_id"];
    [[NSUserDefaults standardUserDefaults] setInteger: -1 forKey:@"DriverCurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"c_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    isUploadingPreviousLot = false;
    UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
}

-(void)startTimerToMove {
    self.progressView.progress = 0.0;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
}

-(IBAction)move:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
}

-(void)alertView{
    self.progressLabel.hidden = YES;
    self.circularProgressView.hidden = YES;
    self.progressView.hidden = YES;
    self.progressLabel.hidden = YES;
    self.image_progress.hidden = YES;
    self.gif_img.hidden = YES;

    self.navigationItem.hidesBackButton = YES;

    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

    [self.alertbox setHorizontalButtons:YES];

    [self.alertbox addButton:NSLocalizedString(@"Retry",@"")  target:self selector:@selector(retry:) backgroundColor:Green];

    [self.alertbox showSuccess:NSLocalizedString(@"Retry",@"")  subTitle:self.localerror closeButtonTitle:nil duration:1.0f ];
}



-(IBAction)enablebuttons:(id)sender{
    [self enablebuttons];
}


-(IBAction)retry:(id)sender{
    NSLog(@"Retry Clicked.");
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
        [self.view makeToast:NSLocalizedString(@"Server Under Maintenance!. Try Again Later.",@"") duration:2.0 position:CSToastPositionCenter];
    }else {
        [self.alertbox hideView];
        
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            
            NSMutableDictionary *pload=[parkloadArray objectAtIndex:currentloadnumber];
            self.upload_lbl.hidden = YES;
            //        self.upload_lbl.hidden = NO;
            self.progressLabel.hidden = NO;
            self.navigationItem.hidesBackButton = NO;
            if([[pload objectForKey:@"tappi_id"]intValue] >0){
                [self uploadingImage];
            }else{
                [self uploader];
            }
        }else{
            [self networkerrorAlert];
        }
    }
}

-(IBAction)retryWithlogin:(id)sender
{
    [self.alertbox hideView];
    self.upload_lbl.hidden = YES;
    self.upload_lbl.text = NSLocalizedString(@"Uploading Failed...",@"");
    [self enablebuttons];
    self.circularProgressView.hidden=YES;
    self.progressLabel.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    self.view.userInteractionEnabled = YES;
    //[parkloadArray : withObject:];
    [self park];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    PasscodePinViewController *PasscodePinViewController = [delegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
    if (@available(iOS 13.0, *)) {
        [PasscodePinViewController setModalPresentationStyle:UIModalPresentationFullScreen];// = YES
    }
    [delegate.window.rootViewController presentViewController:
     PasscodePinViewController animated:YES completion:nil];
    
}


-(IBAction)retryWithOk:(id)sender
{
    [self.alertbox hideView];
    self.upload_lbl.hidden = YES;
    self.upload_lbl.text = NSLocalizedString(@"Uploading Failed...",@"");
    [self enablebuttons];
    self.circularProgressView.hidden=YES;
    self.progressLabel.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    self.view.userInteractionEnabled = YES;
}

- (void)back_button:(id)sender {
    if(!currentLotRelatedData == nil || currentLotRelatedData.count > 0){
        [[NSUserDefaults standardUserDefaults] setObject:@"DriverCameraVC" forKey:@"DriverUploadVC"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)moveToLoadVC {
    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
    [[NSUserDefaults standardUserDefaults] setInteger: -1 forKey:@"DriverCurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"c_id"];
    [[NSUserDefaults standardUserDefaults] setObject:0 forKey:@"tappi_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    isUploadingPreviousLot = false;
    UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
}



- (IBAction)upload_btn_action:(id)sender {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted ) {
        NSLog(@"denied");
        [self allowLocationAccess];
    }else{
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
            bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
            if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
                [self.view makeToast:NSLocalizedString(@"Server Under Maintenance!. Try Again Later.",@"") duration:2.0 position:CSToastPositionCenter];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"img_instruction_number"];
                [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"current_Looping_Count"];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ImageCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self uploader];
            }
        }
        else{
            [self networkerrorAlert];
        }
    }
}

-(void)uploader{

    [self preUploadLot];
    //self.view.userInteractionEnabled = NO;
    [self disableUploadButton];
    [self disbleParkButton];

    if(self.isBatchUpload){
        [self setupBatchUplaod ];
    }else{
       
        self.totalBatchloads.text=@"1";
        self.progressLabel.text = @"1/1";
        
        NSMutableDictionary *pload=[parkloadArray objectAtIndex:currentloadnumber];
        //checkingAddon7Custom
        bool isAddon7CustomGpcc=[[pload objectForKey:@"isAddon7CustomGpcc"]boolValue];
        NSMutableArray*instData_custom =[pload objectForKey:@"instructData"];
        if(instData_custom != nil && instData_custom.count >0){
            hasAddon7=true;
        }else{
            hasAddon7=false;
        }
        NSString *str=[pload objectForKey:@"category"];
        self.UserCategory=str;
        self.arrayWithImages=[pload objectForKey:@"img"];
    }
        //[self.Upload setEnabled:NO];
//    self.Category_Value_Label.text = self.UserCategory;
    self.Category_Value_Label.text= @"cat";
    self.image_progress.text = [NSString stringWithFormat:@"1/%d",(int)self.arrayWithImages.count];

    //self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
    [self uploadingImage];
}


-(void)disableUploadButton{
    
    [self.upload_btn setHidden:YES];
    [self.upload_btn setBackgroundColor:[UIColor colorWithRed: 0.54 green: 0.49 blue: 0.88 alpha: 1.00]];
    [self.upload_btn setEnabled:NO];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"Driver_Upload_btn_VC";
    
    if (![self.str isEqualToString:@""] && self.str != nil){
        self.Ad_holder.hidden = YES;
    }
}


-(void)enableUploadButton{
    
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"DriverUploadVC";
    
    if (![self.str isEqualToString:@""] && self.str != nil){
        self.Ad_holder.hidden = YES;
    }
    [self.upload_btn setHidden:NO];
    [self.upload_btn setBackgroundColor:Blue];
    [self.upload_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.upload_btn setEnabled:YES];
}

-(void)disbleParkButton{
    
    [self.park_btn setHidden:YES];
    [self.park_btn setBackgroundColor:[UIColor colorWithRed: 0.54 green: 0.49 blue: 0.88 alpha: 1.00]];
    [self.park_btn setEnabled:NO];
}

-(void)enableParkButton{
    
    [self.park_btn setHidden:YES];
    [self.park_btn setBackgroundColor:Blue];
    [self.park_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSMutableArray * newparkLoad = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    Add_on *add_on;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    NSLog(@"self.IsiteId:%d",self.IsiteId);
    NSLog(@"self.addonName:%@",add_on.addonName);
    NSLog(@"self.siteData.siteId:%d",self.siteData.siteId);
    [self.park_btn setEnabled:TRUE];
    [self.park_btn setTitle:NSLocalizedString(@"Park Load  ",@"") forState:UIControlStateNormal];
}


-(void) park{
    
    Add_on *add_on;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    [self disableUploadButton];
    [self disbleParkButton];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!_isEdit ) {
        int ccount = delegate.count;
        ccount ++;
        delegate.count = ccount;
    }
    
    if(self.currentIndex == -1){
        self.currentIndex = self.currentIndex + 1;
    }
    NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
    NSString *notes = [dict objectForKey:@"string"];
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    if (notes.length> 0) {
        [self.savedOldValuesDict setObject:notes forKey:@"string"];
    }
    NSMutableDictionary *dictSavedOldValues = [[parkloadArray objectAtIndex:currentloadnumber]mutableCopy];
    self.arraySavedOldValues = [[NSMutableArray alloc]init];
    
        //saving notes in dictionary
    
    [dictSavedOldValues setValue:newDateString forKey:@"parked_time"];
    
    if (self.load_id>0) {
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",(int)self.load_id] forKey:@"load_id"];
        
        if (self.currentIndex-2 > 0) {
            self.currentIndex=self.currentIndex-2;
        }else if (self.currentIndex-1 > 0) {
            self.currentIndex=self.currentIndex-1;
        }
        
        if (self.pic_count-2 > 0) {
            self.pic_count=self.pic_count-2;
        }else if (self.pic_count-1 > 0) {
            self.pic_count=self.pic_count-1;
        }
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:@"currentIndex"];
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",self.pic_count] forKey:@"pic_count"];
    }
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    
    [dictSavedOldValues setObject:epochTime forKey:@"park_id"];
    [dictSavedOldValues setObject:@"1" forKey:@"isParked"];
    [self saveParkedLoad:[dictSavedOldValues mutableCopy]];
    
    parkloadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    [self enableUploadButton];
    [self enableParkButton];
    [self postUploadLot];
}

-(void)yellowpark{
    [self disableUploadButton];
    [self disbleParkButton];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!_isEdit ) {
        int ccount = delegate.count;
        ccount ++;
        delegate.count = ccount;
    }
    
        //old values
    if(self.currentIndex == -1){
    self.currentIndex = self.currentIndex + 1;
    }
    NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
    NSString *notes = [dict objectForKey:@"string"];
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    
    if (notes.length> 0) {
        [self.savedOldValuesDict setObject:notes forKey:@"string"];
    }
    NSMutableDictionary *dictSavedOldValues = [[parkloadArray objectAtIndex:currentloadnumber]mutableCopy];
    self.arraySavedOldValues = [[NSMutableArray alloc]init];
    
        //saving notes in dictionary
    
    [dictSavedOldValues setValue:newDateString forKey:@"parked_time"];
    
    if (self.load_id>0) {
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",(int)self.load_id] forKey:@"load_id"];
        
        if (self.currentIndex-2 > 0) {
            self.currentIndex=self.currentIndex-2;
        }else if (self.currentIndex-1 > 0) {
            self.currentIndex=self.currentIndex-1;
        }
        
        if (self.pic_count-2 > 0) {
            self.pic_count=self.pic_count-2;
        }else if (self.pic_count-1 > 0) {
            self.pic_count=self.pic_count-1;
        }
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",self.currentIndex] forKey:@"currentIndex"];
        [dictSavedOldValues setValue:[NSString stringWithFormat:@"%d",self.pic_count] forKey:@"pic_count"];
    }
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    
    [dictSavedOldValues setObject:epochTime forKey:@"park_id"];
    [self saveParkedLoad:[dictSavedOldValues mutableCopy]];
    
    parkloadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    [self enableUploadButton];
    [self enableParkButton];
    [self postUploadLot];
}


- (IBAction)park_action_btn:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"img_instruction_number"];
    [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"current_Looping_Count"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ImageCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self park];
}

-(void)saveParkedLoad:(NSMutableDictionary *)parkLoadDict{
    NSLog(@"Parkload");
   // [parkloadArray removeObject:parkLoadDict];
    [parkloadArray replaceObjectAtIndex:currentloadnumber withObject:parkLoadDict];
    [[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
}

-(void)site_maintenance_api{
    
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        //Calling Api_SiteMaintenance
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
}


@end
