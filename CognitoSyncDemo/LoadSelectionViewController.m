//
//  LoadSelectionViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 2/15/17.
//  Copyright © 2017 Behroozi, David. All rights reserved.
//

#import "LoadSelectionViewController.h"
#import "CameraViewController.h"
#import "CaptureScreenViewController.h"
#import "Constants.h"
#import "StaticHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "AZCAppDelegate.h"
#import "UploadViewController.h"
#import "UIView+Toast.h"
#import "LoadSelectionTableViewCell.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "ServerUtility.h"
#import "Add_on.h"
#import "ImageCacheViewController.h"
#import "Add_on_8.h"
#import "Looping_Camera_ViewController.h"
#import "CategoryViewController.h"
<<<<<<< HEAD
=======
#import "HorizontalDottedLineView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
>>>>>>> main

#define kOpinionzSeparatorColor [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]
#define kOpinionzDefaultHeaderColor [UIColor colorWithRed:0.8 green:0.13 blue:0.15 alpha:1]

@interface LoadSelectionViewController ()<UIPopoverControllerDelegate>{
    Checkbox *cbox;
    Checkbox *selectAll;
<<<<<<< HEAD
=======
    UIButton *selectAllIcon;
    UIButton *boyImg;
    UILabel *clicktoStartLabel;
>>>>>>> main
    int loadIndex;
    NSMutableArray *parkloadarray;
    NSInteger currentloadnumber;
    NSMutableDictionary * parkload;
    bool hasCustomCategory;
    AZCAppDelegate *delegateVC;
    ImageCacheViewController *imgVC;
    bool hasAddon8;
    NSString* pathToImageFolder;
    bool isImgeAvailableAllsteps;
    bool isImgeAvailableAllLoop;
    bool isLoopingField_missing;
    NSTimer *timer;
<<<<<<< HEAD
=======
    UILabel* titleLabel;
    NSInteger fontPosition;
    UIView *zoomView;
    UIButton *zoombutton;
    UIProgressView *progressLineView;
    NSMutableArray *circleButtons;
    UILabel *label,*label1,*label2;
    CGFloat screenHeight,screenWidth;
    NSInteger *selectedIndex;
    FLAnimatedImageView *gifImageView;
>>>>>>> main
}
@end

@implementation LoadSelectionViewController

-(void) checkAction{
<<<<<<< HEAD
=======
    if (selectAll.isChecked == true){
        [selectAll setChecked:false];
        [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
    }else {
        [selectAll setChecked:true];
        [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"tick_new.png"] forState:UIControlStateNormal];
    }
>>>>>>> main
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    Add_on *add_on;
    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    for (int i=0;i<parkloadarray.count;i++) {
        NSMutableDictionary *load=[[NSMutableDictionary alloc]init];
        load=[[parkloadarray objectAtIndex:i] mutableCopy];
        NSMutableArray *count=[[NSMutableArray alloc] init];
        count=[load objectForKey:@"img"];
        bool isAddon7Custom = [load objectForKey:@"isAddon7Custom"];
        bool isAddon7CustomGpcc =[load objectForKey:@"isAddon7CustomGpcc"];
        NSMutableArray* instArr = [load objectForKey:@"instructData"];
        bool isImgeAvailableAllsteps_custom = TRUE;
        bool isLoopingField_missing = TRUE;
        if(hasAddon8 && !hasCustomCategory ){
            //fetching_parkload
            parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
            NSLog(@"parkloadarray_fetch:%@",parkloadarray);
            self.parkLoad = [[parkloadarray objectAtIndex:i] mutableCopy];
            NSArray *img = [self.parkLoad valueForKey:@"img"];
            isImgeAvailableAllLoop = TRUE;
            NSMutableArray *loopingMetadata = [self.parkLoad valueForKey:@"loopingfields"];
            int str = [[self.parkLoad valueForKey:@"tappi_count"] intValue];
            for(int i = 0; i<str; i++){
                int value = i;
                NSLog(@"value:%d",value);
                NSMutableArray *newarr = [[NSMutableArray alloc]init];
                for(int j=0;j<img.count;j++){
                    NSString* valuee = [[img valueForKey:@"img_numb"]objectAtIndex:j];
                    int newvalue = [[[img valueForKey:@"img_numb"]objectAtIndex:j]intValue];
                    NSLog(@"valuee:%@",valuee);
                    if(newvalue == value){
                        [newarr addObject:valuee];
                        NSLog(@"newarr:%@",newarr);
                        break;
                    }
                }
                if(newarr.count == 0){
                    self.tappi_missing = i;
                    isImgeAvailableAllLoop = FALSE;
                    break;
                }
                if(loopingMetadata.count < str){
                    isLoopingField_missing = FALSE;
                }
            }
        }
        if((!isAddon7CustomGpcc)&& (self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
            //fetching_parkload
            parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
            self.parkLoad = [[parkloadarray objectAtIndex:i] mutableCopy];
            NSArray *img = [self.parkLoad valueForKey:@"img"];
            NSArray *str = [self.parkLoad valueForKey:@"instructData"];
            bool isImgeAvailableAllsteps;

            for(int i = 0; i<str.count; i++){
                int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                NSLog(@"value:%d",value);
                NSMutableArray *newarr = [[NSMutableArray alloc]init];
                isImgeAvailableAllsteps = TRUE;

                for(int j=0;j<img.count;j++){
                    NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                    int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                    NSLog(@"valuee:%@",valuee);
                    if(newvalue == value){
                        [newarr addObject:valuee];
                        NSLog(@"newarr:%@",newarr);
                        break;
                    }
                }
                if(newarr.count == 0){
                    isImgeAvailableAllsteps = FALSE;
                    break;
                }
            }
        }
        if((isAddon7Custom) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
            //fetching_parkload

            for(int i = 0; i<instArr.count; i++){
                int value = [[[instArr valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                NSLog(@"value:%d",value);
                NSMutableArray *newarr = [[NSMutableArray alloc]init];
                isImgeAvailableAllsteps_custom = TRUE;
                
                for(int j=0;j<count.count;j++){
                    NSString* valuee = [[count valueForKey:@"InstructNumber"]objectAtIndex:j];
                    int newvalue = [[[count valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                    NSLog(@"valuee:%@",valuee);
                    if(newvalue == value){
                        [newarr addObject:valuee];
                        NSLog(@"newarr:%@",newarr);
                        break;
                    }
                }
                if(newarr.count == 0){
                    isImgeAvailableAllsteps_custom = FALSE;
                    break;
                }
            }
        }
        if (selectAll.isChecked == true){
            if(hasAddon8 && !hasCustomCategory && (!isImgeAvailableAllLoop)){
                
                [load setValue:@"0" forKey:@"isAutoUpload"];
                
            }else if(isAddon7Custom && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue && (!isImgeAvailableAllsteps_custom)){
                
                [load setValue:@"0" forKey:@"isAutoUpload"];
                
            }else if((!isAddon7Custom) && (self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue && (!isImgeAvailableAllsteps)){
                    
                    [load setValue:@"0" forKey:@"isAutoUpload"];
                    
            }else if( count.count>0 && [load valueForKey:@"category"] != nil && [load valueForKey:@"fields"] != nil) {
                
                self.label.text = NSLocalizedString(@"Upload",@"");
                [load setValue:@"1" forKey:@"isAutoUpload"];
                
            }else if( count.count>0 && [load valueForKey:@"category"] != nil && [load valueForKey:@"basefields"] != nil && isLoopingField_missing) {
                
                self.label.text = NSLocalizedString(@"Upload",@"");
                [load setValue:@"1" forKey:@"isAutoUpload"];
                
            }else{
                self.label.text = NSLocalizedString(@"Click to Start a New Load",@"");
                [load setValue:@"0" forKey:@"isAutoUpload"];
            }
        }else{
            self.label.text =NSLocalizedString(@"Click to Start a New Load",@"");
            [load setValue:@"0" forKey:@"isAutoUpload"];
            if (selectAll.isChecked == true) {
                [selectAll setChecked:false];
<<<<<<< HEAD
=======
                [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
>>>>>>> main
            }
        }
        [parkloadarray replaceObjectAtIndex:i withObject:load];
        [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.load_Table_View reloadData];
    [self button_status];
}



-(void) button_status{
    //int limit=5;

    int limit=100;//5;
    if([self.siteData.planname isEqualToString:@"Gold"]){
        limit=100;//20;
    }else if([self.siteData.planname isEqualToString:@"Platinum"]){
        limit=100;//50;
    }
    if (limit>parkloadarray.count) {
<<<<<<< HEAD
        self.Load_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1];
=======
        self.Load_btn.backgroundColor = [UIColor colorWithRed:25/255.0 green:179.0/255.0 blue:214/255.0 alpha:1];
>>>>>>> main
    }else if(parkloadarray.count==limit){
        for (int i=0;i<parkloadarray.count;i++) {
            NSMutableDictionary *load=[[NSMutableDictionary alloc]init];
            load=[[parkloadarray objectAtIndex:i] mutableCopy];
            if([[load objectForKey:@"isAutoUpload"]  isEqual: @"1"]){
                //self.Load_btn.alpha=0.5;
<<<<<<< HEAD
                self.Load_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1];
=======
                self.Load_btn.backgroundColor = [UIColor colorWithRed:25/255.0 green:179.0/255.0 blue:214/255.0 alpha:1];
>>>>>>> main
                break;
            }else{
                self.Load_btn.alpha=1;
                self.Load_btn.backgroundColor = [UIColor colorWithRed: 0.54 green: 0.49 blue: 0.88 alpha: 0.5];
            }
        }
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    [self geolocation];
<<<<<<< HEAD
=======
    
    // Load the selected font size from UserDefaults
    fontPosition = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedFontSizePosition"];
>>>>>>> main
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //set cache for clear
    pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:100 diskCapacity:100 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    //self.selected_siteData = [[NSMutableDictionary alloc]init];
   // self.selected_siteData =self.siteData;
    bool isAddon7Enabled = false;
    bool isAddon5Enabled = false;
    
    if(self.siteData.categoryAddon != nil){
        for (int index=0; index<self.siteData.categoryAddon.count; index++) {
            Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];

            if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
                isAddon5Enabled = true;
            }
            if ([add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue) {
                isAddon7Enabled = true;
            }
        }
    }
<<<<<<< HEAD
    self.subView.layer.cornerRadius = 10;
    self.subView.layer.borderWidth = 1;
    self.subView.layer.borderColor = Blue.CGColor;
=======
    //self.subView.layer.cornerRadius = 10;
    //self.subView.layer.borderWidth = 1;
    //self.subView.layer.borderColor = Blue.CGColor;
>>>>>>> main
    
    NSString *model=[UIDevice currentDevice].model;
    
    if ([model isEqualToString:@"iPad"]) {
        self.Load_btn.layer.cornerRadius = 45;
    }else{
        self.Load_btn.layer.cornerRadius = self.view.frame.size.width/10;
    }
<<<<<<< HEAD
    self.Load_btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.Load_btn.layer.borderWidth = 0.5;
    [self.Load_btn.layer setShadowOffset:CGSizeMake(3, 3)];
    [self.Load_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.Load_btn.layer setShadowOpacity:0.5];
    self.Load_btn.layer.shadowRadius = 5.0;
=======
    //self.Load_btn.layer.borderColor = [UIColor blackColor].CGColor;
    //self.Load_btn.layer.borderWidth = 0.5;
    //[self.Load_btn.layer setShadowOffset:CGSizeMake(3, 3)];
    //[self.Load_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    //[self.Load_btn.layer setShadowOpacity:0.5];
    //self.Load_btn.layer.shadowRadius = 5.0;
>>>>>>> main
    self.Load_btn.backgroundColor = Blue;
    self.siteName = [[NSUserDefaults standardUserDefaults] stringForKey:@"siteName"];
    NSLog(@"width : %f, Radius : %f",self.view.frame.size.width ,self.Load_btn.layer.cornerRadius);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
    self.dict = [[NSMutableDictionary alloc]init];
    self.sitesNameArr = delegate.userProfiels.arrSites;
    if (self.sitesNameArr.count == 1)
    {
        UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
<<<<<<< HEAD
        [logout setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
=======
        [logout setBackgroundImage:[UIImage imageNamed:@"logout_new.png"] forState:UIControlStateNormal];
>>>>>>> main
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    }else{
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
<<<<<<< HEAD
        [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
=======
        [back setBackgroundImage:[UIImage imageNamed:@"back_new.png"] forState:UIControlStateNormal];
>>>>>>> main
        [back addTarget:self action:@selector(back_button:)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    }
    self.navigationItem.hidesBackButton = NO;
<<<<<<< HEAD
=======
    //self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
>>>>>>> main
    
    //Checking_add0n8
    hasAddon8 = FALSE;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            hasAddon8 = TRUE;
        }
    }
    
<<<<<<< HEAD
    //cache_btn
    UIButton *cache_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [cache_btn setBackgroundImage:[UIImage imageNamed:@"cache.png"] forState:UIControlStateNormal];
    [cache_btn addTarget:self action:@selector(cache_clear:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cache_btn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
=======
   
>>>>>>> main
    //notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(park:) name:@"park" object:nil];
    self.imageArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"uploaded" object:nil];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        _siteName_Lbl.textAlignment = NSTextAlignmentRight;
        _siteNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.sitename_lable_stackview setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];

    }

    _siteName_Lbl.text = _siteName;
//    NSLog(@"lenghtoff %@", @(_siteName.length).stringValue);
<<<<<<< HEAD
    _siteName_Lbl.textColor = [UIColor purpleColor];
=======
    //_siteName_Lbl.textColor = [UIColor purpleColor];
>>>>>>> main
    long labelCount = NSLocalizedString(@"SITE NAME :  ",@"").length;
    if(_siteName.length > 23){
        self.sitenameconstraint.constant = 90;
    }else if(_siteName.length > 13){
        self.sitenameconstraint.constant = 60;
    }else{
        self.sitenameconstraint.constant = 40;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
<<<<<<< HEAD

    if(width < 400){
        if(labelCount > 23){
            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 13]];
            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 13]];
        }else if(labelCount > 13){
            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 14]];
            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 14]];
        }else{
            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 17]];
            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 17]];
        }
    }
    _lowStorageLabel.backgroundColor=[UIColor whiteColor];
    self.lowStorageLabel.numberOfLines = 3;
    self.lowStorageLabel.adjustsFontSizeToFitWidth = YES;
    //textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
     int x,y1,Y,y2,y3,y;
    //x=(self.view.frame.size.width - self.Load_btn.frame.size.width)/2+15;
    x= self.load_Table_View.frame.origin.x;
    y1=self.load_Table_View.frame.origin.y+10;
    y2=_lowStorageLabel.frame.origin.y+2;
    y3=_lowStorageLabel.frame.size.height;
    y=_Load_btn.frame.origin.y +_Load_btn.frame.size.height;
    Y=(y2+y3)+((y1-(y2+y3))/2)+10;
    //selectall
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        int width = 0;
        if ([model isEqualToString:@"iPad"]) {
            width = (self.view.frame.size.width/8)*7.3;
        }else{
            width = (self.view.frame.size.width/8)*7;
        }
        selectAll = [[Checkbox alloc] initWithFrame:CGRectMake(width-15,0, 110, 25)];
    }else{
        selectAll = [[Checkbox alloc] initWithFrame:CGRectMake(10,0, 110, 25)];
    }
    self.lowStorageLabel.hidden = YES;
    [selectAll addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
=======
    [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 17]];
    _siteName_Lbl.font = [UIFont boldSystemFontOfSize:24.0f];
    
//    if(width < 400){
//        if(labelCount > 23){
//            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 13]];
//            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 13]];
//        }else if(labelCount > 13){
//            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 14]];
//            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 14]];
//        }else{
//            [_siteName_Lbl setFont: [_siteName_Lbl.font fontWithSize: 17]];
//            [_siteNameLabel setFont: [_siteName_Lbl.font fontWithSize: 17]];
//        }
//    }
    _lowStorageLabel.backgroundColor=[UIColor whiteColor];
    self.lowStorageLabel.numberOfLines = 3;
    self.lowStorageLabel.adjustsFontSizeToFitWidth = YES;
    //textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
     int x,y1,Y,y2,y3,y;
    //x=(self.view.frame.size.width - self.Load_btn.frame.size.width)/2+15;
    x= self.load_Table_View.frame.origin.x;
    y1=self.load_Table_View.frame.origin.y+10;
    y2=_lowStorageLabel.frame.origin.y+2;
    y3=_lowStorageLabel.frame.size.height;
    y=_Load_btn.frame.origin.y +_Load_btn.frame.size.height;
    Y=(y2+y3)+((y1-(y2+y3))/2)+10;
    //selectall
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        int width = 0;
        if ([model isEqualToString:@"iPad"]) {
            width = (self.view.frame.size.width/8)*7.3;
        }else{
            width = (self.view.frame.size.width/8)*7;
        }
        selectAll = [[Checkbox alloc] initWithFrame:CGRectMake(width-15,0, 110, 24)];
    }else{
        selectAll = [[Checkbox alloc] initWithFrame:CGRectMake(10,0, 110, 24)];
    }
    selectAll.labelTextColor = [UIColor blackColor];
    selectAllIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
    selectAllIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
    [selectAll addSubview:selectAllIcon];
    
    //boy loading image
    boyImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 70, 200, self.view.frame.size.height / 2)];
    [boyImg setBackgroundImage:[UIImage imageNamed:@"boy_loading.png"] forState:UIControlStateNormal];
    //[self.view addSubview:boyImg];
    clicktoStartLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 + 10, self.view.frame.size.width, 100)];
    clicktoStartLabel.text = NSLocalizedString(@"Start a New Load",@"");
    clicktoStartLabel.textColor = [UIColor colorWithRed:25/255.0 green:179.0/255.0 blue:214/255.0 alpha:1];
    clicktoStartLabel.textAlignment = NSTextAlignmentCenter;
    clicktoStartLabel.font =  [UIFont boldSystemFontOfSize:19.0];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"gif_parkload" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    gifImageView = [[FLAnimatedImageView alloc] init];
    gifImageView.animatedImage = image;
    gifImageView.frame = CGRectMake(0.0, self.view.frame.size.height / 2 - 184, 330, 184);
    CGPoint centerImageView = gifImageView.center;
    centerImageView.x = self.view.center.x;
    gifImageView.center = centerImageView;
    [self.view addSubview:gifImageView];
    [self.view addSubview:clicktoStartLabel];

    self.lowStorageLabel.hidden = YES;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont boldSystemFontOfSize:25.0];
    [selectAllIcon addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> main
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
       // _lowStorageLabel.priority = 250;
        [self.select_all_view addSubview:selectAll];
        //[self.lowStorageLabel bringSubviewToFront:selectAll];
        selectAll.userInteractionEnabled = YES;
    }
<<<<<<< HEAD
=======
    self.Load_btn.layer.cornerRadius = 10.0;
>>>>>>> main
    
    [self button_status];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeId"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
<<<<<<< HEAD
    NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
    if (deviceModel.length > 0 && [[deviceModel substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"iPad"]) {
        //This is iPad
         [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
    } else {
        [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    }
=======
    self.load_Table_View.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self fontSize];
  //  NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
   // if (deviceModel.length > 0 && [[deviceModel substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"iPad"]) {
        //This is iPad
       //  [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
  //  } else {
      //  [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
   // }
>>>>>>> main
//    NSString *slat =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
//    NSString *slan =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
//    NSString *timeZone =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneName"];
//    if(slat != nil){
//        if(timeZone != nil){
//            NSLog(@"%@", timeZone);
//        }else {
//            [self getTimeZone:[slat doubleValue] withsecond:[slan doubleValue]];
//        }
//    }
 
}

-(void)geolocation{
    ceo = [[CLGeocoder alloc]init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    self.latitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
        [locationManager stopUpdatingLocation];
}

-(IBAction)logout:(id)sender {
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    if (parkloadarray.count > 0){
        [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
    }
    else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
        [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
    }
    else{
        [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
}


-(IBAction)signout:(id)sender {
    
    //AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ismaster"];
    NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
    NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
    NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
        boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolvalue:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolvalue:%d",boolvalue);
    }  NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
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
        [ServerUtility getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)self.latitude withlongi:(NSString *)self.longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
            
            if (!error) {
                NSLog(@"Logout data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"]){
                    [self.alertbox hideView];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
                    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
                    [[NSUserDefaults standardUserDefaults]  setBool:NO forKey:@"isLoggedIn"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_name"];
                    UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"timeZoneName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
                    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                    [[AZCAppDelegate sharedInstance] clearAllLoads];
                }
            }
        }];
    }
}



-(IBAction)cache_clear:(id)sender {
//    @[][1];
    //cache_alertbox
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Close",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox addButton:NSLocalizedString(@"Clear",@"") target:self selector:@selector(clear_now:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Clear Cache",@"") subTitle:NSLocalizedString(@"Clicking 'Clear' button will clear all caches.",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)clear_now:(id)sender {
<<<<<<< HEAD
    
    //Clear_GIF
    if(imgVC == nil){
        imgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"imgVC"];
    }
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        imgVC.preferredContentSize = CGSizeMake(420, 400);
    }else{
        imgVC.preferredContentSize = CGSizeMake(320, 300);
    }
    imgVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pop = imgVC.popoverPresentationController;
    pop.permittedArrowDirections = UIPopoverArrowDirectionUp;
    pop.delegate = self;
    pop.sourceView = self.view;
    pop.sourceRect = CGRectMake(self.view.center.x - 50.0, self.view.center.y - 450.0, 100.0, 100.0);

    //clears_All_cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];

    NSError *error;
    NSArray *directoryItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error];
    NSLog(@"directoryItems:%@", directoryItems);
    if(directoryItems.count != 0){
        NSFileManager *fileMgr = [NSFileManager defaultManager];

        for (NSString *filename in directoryItems)  {

            [fileMgr removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        //Clear All Cookies
        for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        [self presentViewController:imgVC animated:YES completion:nil ];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
        
        //clearing_imagePath
        if(parkloadarray.count == 0){
            NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:LoadImagesFolder];
            [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        }
    }else{
        [self.view makeToast: NSLocalizedString(@"No Caches to clear",@"") duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
    }

}


-(void) handleTimer:(NSTimer *)timer {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view makeToast:NSLocalizedString(@"Cache cleared",@"") duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
  return UIModalPresentationNone;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:selectAll]) {
        return NO;
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self site_maintenance_api];
  
   timer =  [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(site_maintenance_api) userInfo:
             nil repeats:YES];
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSLog(@"parkloadarray:%@",parkloadarray);
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"LoadVC";
    hasCustomCategory=false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on *add_on=[self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    
    if ([self.siteData.planname isEqual:@"FreeTier"]) {
        _tblTopConstraint.priority = 250; //Lbl Show
        self.lowStorageLabel.hidden = NO;
        self.lowStorageLabel.text=[NSString stringWithFormat: NSLocalizedString(@"Only %d images and %d videos can be captured. Please contact admin to increase storage limit for this site",@""),self.siteData.RemainingImagecount,self.siteData.RemainingVideocount];
    }else if ([self.siteData.LowStorage isEqual:@"1"] ) {
        _tblTopConstraint.priority = 250; //Lbl Show
        self.lowStorageLabel.hidden = NO;
        self.lowStorageLabel.text=[NSString stringWithFormat: NSLocalizedString(@"Only %.2f percent storage left. Please contact admin to increase storage limit for this site",@""),self.siteData.RemainingSpacePercentage];
    }else{
        self.lowStorageLabel.text=@"";
        _tblTopConstraint.priority = 250;
    }
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
        selectAll.userInteractionEnabled = YES;
        
        if(self.siteData.storage_msg != nil && ![self.siteData.storage_msg isEqual:@""]){
            if([self.siteData.max_storage doubleValue] < [self.siteData.percent doubleValue]){
                _tblTopConstraint.priority = 250; //Lbl Show
                self.lowStorageLabel.hidden = NO;
                self.lowStorageLabel.text= [NSString stringWithFormat:self.siteData.storage_msg, self.siteData.RemainingImagecount,self.siteData.RemainingVideocount];
                self.lowStorageLabel.textColor = UIColor.redColor;
            }
            self.lowStorageLabel.hidden = NO;
        }else {
            self.lowStorageLabel.hidden = YES;
        }
    }else {
        if(self.siteData.storage_msg != nil && ![self.siteData.storage_msg isEqual:@""]){
            if([self.siteData.max_storage doubleValue] < [self.siteData.percent doubleValue]){
                    NSString *msg = self.siteData.free_trial_msg;
                    NSString *msg1 = self.siteData.storage_msg;
                    NSArray *lines = @[msg, msg1];
                    NSString *storage = [lines componentsJoinedByString:@"\n\n"];
                    self.lowStorageLabel.text = storage;
                    self.lowStorageLabel.hidden = NO;
                self.lowStorageLabel.textColor = UIColor.redColor;
                }else {
                    if(self.siteData.free_trial_msg != nil){
                        self.lowStorageLabel.text = self.siteData.free_trial_msg;
                        self.lowStorageLabel.textColor = UIColor.blackColor;
                    }
                    self.lowStorageLabel.hidden = NO;
                }
            }else {
                if(self.siteData.free_trial_msg != nil){
                    self.lowStorageLabel.text = self.siteData.free_trial_msg;
                    self.lowStorageLabel.textColor = UIColor.blackColor;
                }else {
                    self.lowStorageLabel.hidden = YES;
                }
            }
    }
    
    
    if (currentloadnumber!=-1) {
        
        parkload=[parkloadarray objectAtIndex:currentloadnumber];
    }
    if ( parkloadarray.count>0 ) {
        selectAll.text =  NSLocalizedString(@"Select All",@"");
        selectAll.showTextLabel = YES;
        selectAll.labelFont = [UIFont systemFontOfSize:16];
        selectAll.hidden=NO;
    }else{
        selectAll.hidden=YES;
=======
    
    //Clear_GIF
    if(imgVC == nil){
        imgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"imgVC"];
    }
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        imgVC.preferredContentSize = CGSizeMake(420, 400);
    }else{
        imgVC.preferredContentSize = CGSizeMake(320, 300);
    }
    imgVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pop = imgVC.popoverPresentationController;
    pop.permittedArrowDirections = UIPopoverArrowDirectionUp;
    pop.delegate = self;
    pop.sourceView = self.view;
    pop.sourceRect = CGRectMake(self.view.center.x - 50.0, self.view.center.y - 450.0, 100.0, 100.0);

    //clears_All_cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];

    NSError *error;
    NSArray *directoryItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error];
    NSLog(@"directoryItems:%@", directoryItems);
    if(directoryItems.count != 0){
        NSFileManager *fileMgr = [NSFileManager defaultManager];

        for (NSString *filename in directoryItems)  {

            [fileMgr removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        //Clear All Cookies
        for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        [self presentViewController:imgVC animated:YES completion:nil ];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
        
        //clearing_imagePath
        if(parkloadarray.count == 0){
            NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:LoadImagesFolder];
            [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        }
    }else{
        [self.view makeToast: NSLocalizedString(@"No Caches to clear",@"") duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
    }

}


-(void) handleTimer:(NSTimer *)timer {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view makeToast:NSLocalizedString(@"Cache cleared",@"") duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
  return UIModalPresentationNone;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:selectAll]) {
        return NO;
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self site_maintenance_api];
    
    
   timer =  [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(site_maintenance_api) userInfo:
             nil repeats:YES];
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSLog(@"parkloadarray:%@",parkloadarray);
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"LoadVC";
    hasCustomCategory=false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on *add_on=[self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    
    if ([self.siteData.planname isEqual:@"FreeTier"]) {
        _tblTopConstraint.priority = 250; //Lbl Show
        self.lowStorageLabel.hidden = NO;
        self.lowStorageLabel.text=[NSString stringWithFormat: NSLocalizedString(@"Only %d images and %d videos can be captured. Please contact admin to increase storage limit for this site",@""),self.siteData.RemainingImagecount,self.siteData.RemainingVideocount];
    }else if ([self.siteData.LowStorage isEqual:@"1"] ) {
        _tblTopConstraint.priority = 250; //Lbl Show
        self.lowStorageLabel.hidden = NO;
        self.lowStorageLabel.text=[NSString stringWithFormat: NSLocalizedString(@"Only %.2f percent storage left. Please contact admin to increase storage limit for this site",@""),self.siteData.RemainingSpacePercentage];
    }else{
        self.lowStorageLabel.text=@"";
        _tblTopConstraint.priority = 250;
    }
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
        selectAll.userInteractionEnabled = YES;
        selectAllIcon.userInteractionEnabled = YES;
        [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
        if(self.siteData.storage_msg != nil && ![self.siteData.storage_msg isEqual:@""]){
            if([self.siteData.max_storage doubleValue] < [self.siteData.percent doubleValue]){
                _tblTopConstraint.priority = 250; //Lbl Show
                self.lowStorageLabel.hidden = NO;
                self.lowStorageLabel.text= [NSString stringWithFormat:self.siteData.storage_msg, self.siteData.RemainingImagecount,self.siteData.RemainingVideocount];
                self.lowStorageLabel.textColor = UIColor.redColor;
            }
            self.lowStorageLabel.hidden = NO;
        }else {
            self.lowStorageLabel.hidden = YES;
        }
    }else {
        if(self.siteData.storage_msg != nil && ![self.siteData.storage_msg isEqual:@""]){
            if([self.siteData.max_storage doubleValue] < [self.siteData.percent doubleValue]){
                    NSString *msg = self.siteData.free_trial_msg;
                    NSString *msg1 = self.siteData.storage_msg;
                    NSArray *lines = @[msg, msg1];
                    NSString *storage = [lines componentsJoinedByString:@"\n\n"];
                    self.lowStorageLabel.text = storage;
                    self.lowStorageLabel.hidden = NO;
                self.lowStorageLabel.textColor = UIColor.redColor;
                }else {
                    if(self.siteData.free_trial_msg != nil){
                        self.lowStorageLabel.text = self.siteData.free_trial_msg;
                        self.lowStorageLabel.textColor = UIColor.blackColor;
                    }
                    self.lowStorageLabel.hidden = NO;
                }
            }else {
                if(self.siteData.free_trial_msg != nil){
                    self.lowStorageLabel.text = self.siteData.free_trial_msg;
                    self.lowStorageLabel.textColor = UIColor.blackColor;
                }else {
                    self.lowStorageLabel.hidden = YES;
                }
            }
    }
    
    
    if (currentloadnumber!=-1) {
        
        parkload=[parkloadarray objectAtIndex:currentloadnumber];
    }
    if ( parkloadarray.count>0 ) {
        selectAll.text =  NSLocalizedString(@"Select All",@"");
        selectAll.showTextLabel = YES;
        selectAll.labelTextColor = [UIColor blackColor];
        selectAll.labelFont = [UIFont systemFontOfSize:17];
        selectAll.hidden = NO;
        gifImageView.hidden = YES;
        clicktoStartLabel.hidden = YES;
    }else{
        selectAll.hidden = YES;
        gifImageView.hidden = NO;
        clicktoStartLabel.hidden = NO;
>>>>>>> main
    }
    [self checkforUpload];
    [self.load_Table_View reloadData];
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];

    if (self.sitesNameArr.count == 1)
    {
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        } else {
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    } else {
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        } else {
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
<<<<<<< HEAD
=======
    //self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
>>>>>>> main
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        _siteName_Lbl.textAlignment = NSTextAlignmentRight;
        _siteNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.sitename_lable_stackview setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    } else {
        _siteName_Lbl.textAlignment = NSTextAlignmentLeft;
        _siteNameLabel.textAlignment = NSTextAlignmentRight;
        [self.sitename_lable_stackview setSemanticContentAttribute: UISemanticContentAttributeForceLeftToRight];
    }
    _siteNameLabel.text = NSLocalizedString(@"SITE NAME :  ",@"");
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
                NSString *r = [timeZone stringByAppendingString:name];
                [self.view makeToast:name duration:2.0 position:CSToastPositionCenter];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"timeZoneName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
    [timer invalidate]; timer = nil;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Load_btn_action:(id)sender {
 
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    int counter=0;
    for (int i=0; i<parkloadarray.count; i++) {
        NSMutableDictionary *dict=[parkloadarray objectAtIndex:i];
        NSLog(@"Delegate value sub: %d %@",i,dict);
        if ([[dict objectForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            counter++;
        }
    }
    if (counter>0) {
        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
        bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
        
        if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Down",@"") subTitle:NSLocalizedString(@"Continue with the parkload option. Once the Loadproof cloud is Up, we will notify you to proceed with the uploads.\n 100 loads can be parked per user.",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:1.0f ];
        }else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            
            UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
            self.isupload = TRUE;
            self.label.text = NSLocalizedString(@"Upload",@"");
            UploadVC.siteData = self.siteData;
            UploadVC.isupload = self.isupload;
            UploadVC.sitename = self.siteData.siteName;
            UploadVC.image_quality = self.siteData.image_quality;
            UploadVC.isEdit = NO;
            [self.navigationController pushViewController:UploadVC animated:YES];
            
        }else{
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:NSLocalizedString(@"No Internet!",@"") subTitle:NSLocalizedString(@"Internet Connectivity Missing!.\nConnect with Network to Upload the Loads.",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:1.0f ];
            //[self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing!.\nConnect with Network to Upload the Loads.",@" ") duration:2.0 position:CSToastPositionCenter];
        }
    }else{
        
        NSMutableDictionary *parkload = [[NSMutableDictionary alloc]init];
        NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *parkedTime = [outputFormatter stringFromDate:now];
        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];

        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.cId] forKey:@"c_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.userId] forKey:@"u_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d", self.siteData.siteId] forKey:@"s_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.Device_id] forKey:@"device_id"];
        [parkload setValue:parkedTime forKey:@"parked_time"];
        [parkload setValue:epochTime forKey:@"park_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",self.siteData.networkId]  forKey:@"n_id"];
        [parkload setValue:@"0" forKey:@"isAutoUpload"];
        NSMutableArray *parkLoad = [[NSMutableArray alloc] init];
        [parkload setValue:parkLoad forKey:@"img"];
        if(hasAddon8 && !hasCustomCategory){
            [parkload setValue:nil forKey:@"basefields"];
        }else{
            [parkload setValue:nil forKey:@"fields"];
        }
        [parkload setValue:nil forKey:@"category"];
        
        [parkload setValue:@"false" forKey:@"isAddon7CustomGpcc"];
        [parkload setValue:@"false" forKey:@"isAddon7Custom"];
        [parkload setValue:nil forKey:@"instructData"];

        if(!delegate.userProfiels.instruct.instructData){
            [parkload setValue:delegate.userProfiels.instruct.instructData forKey:@"instructData"];
        }
        bool isAddon7Enabled = false;
        bool isAddon5Enabled = false;
        bool isLoopLoad = false;
        bool isPcp_Site = false;
        
        for (int index=0; index<self.siteData.categoryAddon.count; index++) {
            Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
            if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
                isLoopLoad = false;
                break;
            }
            if ([add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue) {
                isLoopLoad = false;
                break;
            }
            if ([add_on.addonName isEqual:@"addon_8"] && add_on.addonStatus.boolValue) {
                isLoopLoad = true;
            }
        }
        if(self.siteData.pcp_flag.boolValue == YES){
            isPcp_Site = true;
        }
        if(!isLoopLoad){
            for (int index=0; index<self.siteData.categoryAddon.count; index++) {
                Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
                if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
                    isAddon5Enabled = true;
                }
                if ([add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue) {
                    isAddon7Enabled = true;
                }
            }
        }
     
        int loadcount=100;//5;
        if([self.siteData.planname isEqualToString:@"Gold"]){
            loadcount=100;//20;
        }else if([self.siteData.planname isEqualToString:@"Platinum"]){
            loadcount=100;//50;
        }
        if (parkLoadArray == nil) {
            parkLoadArray= [[NSMutableArray alloc]init];
        }
        if (loadcount > parkLoadArray.count) {
            [parkLoadArray addObject:parkload];
            currentloadnumber=(int)parkLoadArray.count;
            Add_on *add_on;
            self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
            for (int index=0; index<self.siteData.categoryAddon.count; index++) {
                Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
                if([dict.addonName isEqual:@"addon_7"]){
                    add_on =[self.siteData.categoryAddon objectAtIndex:index];
                }
            }
            NSLog(@"addOn.addo nStatus %@",add_on.addonStatus);
            NSLog(@"instruct.sitee_Id %d",self.IsiteId);
            NSLog(@"self.siteData.siteId %d",self.siteData.siteId);
            NSLog(@"addOn.addonName %@",add_on.addonName);
            if(self.siteData.pcp_flag.boolValue == YES && isAddon5Enabled && isAddon7Enabled){
                
                CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
                Category.siteData = self.siteData;
                Category.sitename = self.siteName;
                Category.image_quality = self.siteData.image_quality;
                delegate.ImageTapcount = 0;
                delegate.isNoEdit = YES;
                
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber-1 forKey: @"CurrentLoadNumber"];
                [parkload setValue:@"true" forKey:@"isAddon7Custom"];
                [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController pushViewController:Category animated:YES];
                
            }else if (self.IsiteId == self.siteData.siteId && delegate.userProfiels.instruct.instructData != nil && delegate.userProfiels.instruct.instructData.count >0)
            {
                
                CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                
                CaptureVC.siteData = self.siteData;
                CaptureVC.siteName = self.siteName;
                delegate.ImageTapcount = 0;
                delegate.isNoEdit = YES;
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber-1 forKey: @"CurrentLoadNumber"];
                [parkload setObject:delegate.userProfiels.instruct.instructData forKey:@"instructData"];
                [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];

                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CaptureVC animated:YES];
                
            }else if(hasAddon8 && !hasCustomCategory){
                
                Looping_Camera_ViewController * CameraLoopVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CameraLoopVC"];
                
                //initial_load
                self.instruction_number = 0;
                self.currentTappiCount = 0;
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_instruction_number"];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.currentTappiCount] forKey:@"current_Looping_Count"];
                
                CameraLoopVC.siteData = self.siteData;
                CameraLoopVC.siteName = self.siteName;
                delegate.ImageTapcount = 0;
                delegate.isNoEdit = YES;
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber-1 forKey: @"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CameraLoopVC animated:YES];
                
            }else{
                
                CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];

                CameraVC.siteData = self.siteData;
                CameraVC.siteName = self.siteName;
                delegate.ImageTapcount = 0;
                delegate.isNoEdit = YES;
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber-1 forKey: @"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CameraVC animated:YES];
            }
        }else{
            [self.view makeToast:[NSString stringWithFormat: NSLocalizedString(@"You can't Create More than %d Loads",@""),loadcount] duration:2.0 position:CSToastPositionCenter];
            [self button_status];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        //Handle Alert 1
        if (buttonIndex == 0) {
        }
    }
    else if(alertView.tag == 102)
    {
        if (buttonIndex == 0) {
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            [parkloadarray removeObjectAtIndex:self.tag];
            int count = delegate.count;
            count -- ;
            delegate.count = count;
            [self.load_Table_View reloadData];
        }
    }
}


- (void)back_button:(id)sender {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];

    if (parkloadarray.count > 0) {
        
        [self.view makeToast: NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:2.0 position:CSToastPositionCenter];
    }else{
        
        //[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"siteID"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        SiteViewController *sitevc= [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        //sitevc.movetolc=YES;
        [navigationArray removeAllObjects];
        [navigationArray addObject:sitevc];
        self.navigationController.viewControllers = navigationArray;
        [self.navigationController popToViewController:sitevc animated:true];
    }
}

-(void)park:(NSNotification *)notification{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[LoadSelectionViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}


<<<<<<< HEAD
-(void)handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    //internet_indicator
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    UIButton *networkStater;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
=======
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
    //siteName label
    if (fontPosition == 0){
        [_siteNameLabel setFont:[UIFont systemFontOfSize:17.0]];
    }else if (fontPosition == 1){
        [_siteNameLabel setFont:[UIFont systemFontOfSize:19.0]];
    }else {
        [_siteNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    }
    //siteName lbl
    if (fontPosition == 0){
        [_siteName_Lbl setFont:[UIFont systemFontOfSize:17.0]];
    }else if (fontPosition == 1){
        [_siteName_Lbl setFont:[UIFont systemFontOfSize:19.0]];
    }else {
        [_siteName_Lbl setFont:[UIFont systemFontOfSize:21.0]];
    }
    //Low storage lbl
    if (fontPosition == 0){
        [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    }else if (fontPosition == 1){
        [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    }else {
        [self.lowStorageLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
    }
    // label
   if (fontPosition == 0){
       self.label.font = [UIFont boldSystemFontOfSize:18.0];
   }else if (fontPosition == 1){
       self.label.font = [UIFont boldSystemFontOfSize:20.0];
   }else {
       self.label.font = [UIFont boldSystemFontOfSize:22.0];
   }
    //load_btn
    if (fontPosition == 0){
        self.Load_btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }else if (fontPosition == 1){
        self.Load_btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    else{
        self.Load_btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
    }
    //select all
    if(fontPosition == 0){
        selectAll.labelFont = [UIFont systemFontOfSize:17];
    }
    else if (fontPosition == 1){
        selectAll.labelFont = [UIFont systemFontOfSize:19];
    }
    else{
        selectAll.labelFont = [UIFont systemFontOfSize:20];
    }
    
}

-(void)handleTimer {
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    //cache_btn
    UIButton *cache_btn;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cache_btn = [[UIButton alloc]initWithFrame:CGRectMake(60, 8, 25, 25)];
    }else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cache_btn = [[UIButton alloc] initWithFrame:CGRectMake(sw - 160,8,25,25)];
        }else {
            cache_btn = [[UIButton alloc] initWithFrame:CGRectMake(sw - 160,8,20,20)];
        }
    }
    [cache_btn setBackgroundImage:[UIImage imageNamed:@"caches_new.png"] forState:UIControlStateNormal];
    [cache_btn addTarget:self action:@selector(cache_clear:) forControlEvents:UIControlEventTouchUpInside];
    cache_btn.layer.masksToBounds = YES;
    //UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cache_btn];
    //self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
//        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    }
    
    //internet_indicator
    UIButton *networkStater;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(30,12,16,16)];
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,10,20,20)];
        }else {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,12,15,15)];
        }
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 10.0;
>>>>>>> main
    
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(195,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 200, 40)];
=======
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 95,8,25,25)];
        }else {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 95,8,20,20)];
        }
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
     titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw/2 - 160,0, 200, 40)];
>>>>>>> main
    titleLabel.text = NSLocalizedString(@"Load Selection",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
<<<<<<< HEAD
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 245, 40)];
=======
    titleLabel.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, sw, 40)];
>>>>>>> main
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
    //internet_indicator
    bool isOrange = false;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        isOrange = false;
<<<<<<< HEAD
        [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
=======
        [networkStater setBackgroundImage:[UIImage imageNamed:@"internet_on_new.png"]  forState:UIControlStateNormal];
        //networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.082 green: 0.721 blue: 0.305 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
        //networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
>>>>>>> main
            //RGBA ( 0 , 174 , 7 , 100 )
        NSLog(@"Network Connection available");
    }else{
        isOrange = true;
        NSLog(@"Network Connection not available");
        [networkStater
<<<<<<< HEAD
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
=======
         setBackgroundImage:[UIImage imageNamed:@"internet_off_new.png"]  forState:UIControlStateNormal];
        //networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
        //networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
    }
    //cloud_indicator
    NSString* maintenance_stage = [[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode = [[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [cloud_indicator setBackgroundImage: [UIImage imageNamed:@"cloud_orange_new.png"] forState:UIControlStateNormal];
    }else if([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable && !isOrange){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"cloud_green_new.png"]  forState:UIControlStateNormal];
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"cloud_gray_new.png"]  forState:UIControlStateNormal];
>>>>>>> main
    }
    
    //cloud_indicator
    [cloud_indicator addTarget:self action:@selector(cloud_poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cloud_indicator];
<<<<<<< HEAD
    
    //internet_indicator
=======
    [view addSubview:cache_btn];
    
    //internet_indicator
    networkStater.layer.borderColor = [UIColor colorWithRed: 1.00 green: 1.0 blue: 1.0 alpha: 1.00].CGColor;
>>>>>>> main
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
<<<<<<< HEAD
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
=======
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 195,8,25,25)];
        }else {
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 195,8,20,20)];
        }
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_new.png"]  forState:UIControlStateNormal];
>>>>>>> main
    parkloadIcon.layer.masksToBounds = YES;
    parkloadIcon.userInteractionEnabled = YES;
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [parkloadIcon setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    if(parkloadarray != nil && parkloadarray.count > 0){
        parkloadIcon.hidden = NO;
    }else {
        parkloadIcon.hidden = YES;
    }
<<<<<<< HEAD
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
        // Save the selected font size to UserDefaults
        [[NSUserDefaults standardUserDefaults] setInteger:fontPosition forKey:@"selectedFontSizePosition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self fontSize];
    [self.load_Table_View reloadData];
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
>>>>>>> main
}

-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)) && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
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
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(void) parkload_poper{

     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
     [self.alertbox setHorizontalButtons:YES];
     
     NSString *stat = @(parkloadarray.count).stringValue;
     NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
     
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox setHideTitle:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
 }


-(IBAction)dummy:(id)sender
{
    [self.alertbox hideView];
}

#pragma -mark Tableview Methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.sitesNameArr count];
   return parkloadarray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Load";
    LoadSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    }
    // Set up the cell...
     if (fontPosition == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    } else if (fontPosition == 1) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19];
    }
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dict = [parkloadarray objectAtIndex:indexPath.row];
    int count = delegate.count;
    
    //Getting field label
    SiteData *sitess = self.siteData;
    if (hasCustomCategory) {
        for (int index=0; index<self.siteData.customCategory.count; index++) {
            CategoryData *cat= [self.siteData.customCategory objectAtIndex:index];
            if ([cat.categoryName isEqual:[self.dict objectForKey:@"category"]]) {
                //self.metaData=cat.categoryMetaArray;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for(int i = 0; i < cat.categoryMetaArray.count; i++){
                    FieldData *fieldData = cat.categoryMetaArray [i];
                    if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox)){
                        if(fieldData.fieldOptions.count > 0){
                            [arr addObject:fieldData];
                        }
                    }else {
                        [arr addObject:fieldData];
                    }
                }
                self.metaData = arr;
                break;
            }
        }
    }else if (hasAddon8 && !hasCustomCategory) {
        for (int i=0; i<self.siteData.looping_data.count; i++) {
            Add_on_8 *dict = self.siteData.looping_data[i];
            self.metaData =  dict.baseMetaData;
            NSLog(@"dict.base_meta[i]:%@",dict.baseMetaData);
        }
    }else{
        self.metaData = sitess.arrFieldData;
    }
    //iterating the fielddata array
    int fieldId1 = 0;
    int fieldId2 = 0;
    
    NSString *field_label1;
    NSString *field_label2;
    
    NSMutableDictionary *DictFields1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *DictFields2 = [[NSMutableDictionary alloc]init];
    
    int old_field_id1 = 0;
    int old_field_id2 = 0;
    FieldData *fieldData1;
    FieldData *fieldData2;
    //BOOL customer_id = fieldData1.isCustomerId;
    //NSMutableArray *site_list_id = fieldData1.siteListId;
    NSMutableArray *fields = [[NSMutableArray alloc]init];
    if(self.metaData.count > 1){
        fieldData1 = [self.metaData objectAtIndex:0];
        fieldData2 = [self.metaData objectAtIndex:1];
    }else if (self.metaData.count == 1){
        fieldData1 = [self.metaData objectAtIndex:0];
    }
    //getting image count
    self.imageArray =[[NSMutableArray alloc]init];
    self.imageArray =[self.dict objectForKey:@"img"];
    int image_count = (int)[self.imageArray count];
    NSString *str_image_count = [NSString stringWithFormat: @"%ld", (long)image_count];
    //Getting time
    NSString *parkedTime=[self.dict objectForKey:@"parked_time"];
    NSLog(@"LOAD:%@",self.dict);
    if(hasAddon8 && !hasCustomCategory){
        fields = [self.dict objectForKey:@"basefields"];
    }else{
        fields = [self.dict objectForKey:@"fields"];
    }
    NSLog(@"fields:%@",fields);
    NSString * fieldvalue2 = @"";//3842 1810   4410 1812
    NSString * fieldvalue1 = @"";
    if (fields.count >1 ) {
        DictFields1 =[fields objectAtIndex:0];
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        if (fieldId1 == old_field_id1) {
            NSString *fieldval1;
            if ([[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
                NSArray *array= [DictFields1 objectForKey:@"field_value"];
                if(array.count !=0){
                    fieldval1 =@"[ ";
                }
                for (int i=0; i<array.count; i++) {
                    fieldval1 = [fieldval1 stringByAppendingString:[array objectAtIndex:i]];
                    if (i!=array.count-1) {
                        fieldval1=[fieldval1 stringByAppendingString:@" , "];
                    }else{
                        fieldval1=[fieldval1 stringByAppendingString:@" ]"];
                    }
                }
                self.field_label1 =field_label1;
                fieldvalue1 = fieldval1.length>2?fieldval1:@"";
            }else{
                fieldval1 = [DictFields1 objectForKey:@"field_value"];
            }
            self.field_label1 =field_label1;
            fieldvalue1 = fieldval1;
        }
        DictFields2 = [fields objectAtIndex:1];
        fieldId2 = fieldData2.fieldId;
        field_label2 =fieldData2.strFieldLabel;
        old_field_id2 =[[DictFields2 objectForKey:@"field_id"] intValue];
        if (fieldId2 == old_field_id2 && fieldId2 != 0) {
            NSString *fieldval2;
            
            if ([[DictFields2 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields2 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
                NSArray *array= [DictFields2 objectForKey:@"field_value"];
                if(array.count !=0){
                    fieldval2 =@"[ ";
                }
                for (int i=0; i<array.count; i++) {
                    fieldval2 = [fieldval2 stringByAppendingString:[array objectAtIndex:i]];
                    if (i!=array.count-1) {
                        fieldval2=[fieldval2 stringByAppendingString:@" , "];
                    }else{
                        fieldval2=[fieldval2 stringByAppendingString:@" ]"];
                    }
                }
                fieldval2 = fieldval2.length>2?fieldval2:@"";
                fieldvalue2 = fieldval2;
            }else{
                fieldvalue2 = [DictFields2 objectForKey:@"field_value"];
            }
            self.field_label2 = field_label2;
            NSLog(@"fieldval2%@",fieldval2);
            NSLog(@"field_value2%@",fieldvalue2);
        }
    }else if(fields.count == 1){
        
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        if(hasAddon8 && !hasCustomCategory){
            fields = [self.dict objectForKey:@"basefields"];
        }else{
            fields = [self.dict objectForKey:@"fields"];
        }
        DictFields1 =[fields objectAtIndex:0];
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        if (fieldId1 == old_field_id1 ) {
            NSString *fieldval1=@" [ ";
            if ([[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
                NSArray *array= [DictFields1 objectForKey:@"field_value"];
                for (int i=0; i<array.count; i++) {
                    fieldval1 = [fieldval1 stringByAppendingString:[array objectAtIndex:i]];
                    if (i!=array.count-1) {
                        fieldval1=[fieldval1 stringByAppendingString:@" , "];
                    }else{
                        fieldval1=[fieldval1 stringByAppendingString:@" ]"];
                    }
                }
            }else{
                fieldval1 = [DictFields1 objectForKey:@"field_value"];
            }
            self.field_label1 =field_label1;
            fieldvalue1 = fieldval1;
        }
    }
    NSLog(@"field_value2%@",fieldvalue2);
    NSString *model=[UIDevice currentDevice].model;
    int x,width;
    
    x= self.view.frame.size.width /40 ;
    if ([model isEqualToString:@"iPad"]) {
        width = (self.view.frame.size.width/8)*7.3;
    }else{
        width = (self.view.frame.size.width/8)*7;
    }
    int y = 10;
<<<<<<< HEAD
    int height = 130;
=======
    int height = 150;
>>>>>>> main
    
    self.loadBtn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
    self.loadBtn.tag = 1;
    self.loadBtn.adjustsImageWhenHighlighted=YES;
    NSDictionary *dict=[parkloadarray objectAtIndex:indexPath.row];
<<<<<<< HEAD
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.layer.borderWidth = 2;
    self.loadBtn.layer.borderColor = Blue.CGColor;
=======
    self.loadBtn.layer.cornerRadius = 20;
       //self.loadBtn.layer.borderWidth = 2;
    //self.loadBtn.layer.borderColor = Blue.CGColor;
>>>>>>> main
    [self.loadBtn addTarget:self action:@selector(Loads:) forControlEvents:UIControlEventTouchUpInside];
    [self.loadBtn setTag:indexPath.row];
    bool isMandate=false,hasMandate=false;
    NSMutableArray *field_count=[[NSMutableArray alloc]init];
    bool isAddon7Custom = [dict valueForKey:@"isAddon7Custom"];
    bool isAddon7CustomGpcc =[dict valueForKey:@"isAddon7CustomGpcc"];
    //NSMutableArray* instArr = [dict valueForKey:@"instructData"];
    if(hasAddon8 && !hasCustomCategory){
        field_count=[dict objectForKey:@"basefields"];
    }else{
        field_count=[dict objectForKey:@"fields"];
    }
    for (int index=0; index<field_count.count; index++) {
        NSDictionary *d=[field_count objectAtIndex:index];
        if ([[d objectForKey:@"field_mandatory"] isEqual:@"1"] ) {
            hasMandate=true;
            if ([[d objectForKey:@"field_attribute"]isEqual: @"Checkbox"]|| [[d objectForKey:@"field_attribute"]isEqual: @"Radio"]) {
                NSArray *arr=[d objectForKey:@"field_value"];
                isMandate= arr.count>0;
            }else{
                NSString *str=[d objectForKey:@"field_value"];
                isMandate= str.length>0;
            }
            if (!isMandate) {
                break;
            }
        }
    }
    NSMutableArray *img_count=[[NSMutableArray alloc]init];
    img_count=[dict objectForKey:@"img"];
    Add_on *add_on;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
    
    if ([dict valueForKey:@"load_id"] != nil) {
        self.loadBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:236.0/255.0 blue:134.0/255.0 alpha:1.0];
    }else if(hasAddon8 && !hasCustomCategory){
        
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSLog(@"parkloadarray_fetch:%@",parkloadarray);
        self.parkLoad = [[parkloadarray objectAtIndex:indexPath.row] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        isImgeAvailableAllLoop = TRUE;
        isLoopingField_missing = TRUE;
        
        NSMutableArray *loopingMetadata = [self.parkLoad valueForKey:@"loopingfields"];
        int str = [[self.parkLoad valueForKey:@"tappi_count"] intValue];
        for(int i = 0; i<str; i++){
            int value = i;
            NSLog(@"value:%d",value);
            NSMutableArray *newarr = [[NSMutableArray alloc]init];
            
            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"img_numb"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"img_numb"]objectAtIndex:j]intValue];
                NSLog(@"valuee:%@",valuee);
                if(newvalue == value){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                isImgeAvailableAllLoop = FALSE;
                break;
            }
            if(loopingMetadata.count < str){
                isLoopingField_missing = FALSE;
            }
<<<<<<< HEAD
        }
        if(!isImgeAvailableAllLoop){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else if(!isLoopingField_missing){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            self.loadBtn.backgroundColor = [UIColor whiteColor];
        }
    }else if((!isAddon7Custom) && (self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        self.parkLoad = [[parkloadarray objectAtIndex:indexPath.row] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        NSArray *str = [self.parkLoad valueForKey:@"instructData"];
        bool isImgeAvailableAllsteps;
        for(int i = 0; i<str.count; i++){
            int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
            NSLog(@"value:%d",value);
            NSMutableArray *newarr = [[NSMutableArray alloc]init];
            isImgeAvailableAllsteps = TRUE;
            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                NSLog(@"valuee:%@",valuee);
                if(newvalue == value){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                isImgeAvailableAllsteps = FALSE;
                break;
            }
        }
        if(!isImgeAvailableAllsteps){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            self.loadBtn.backgroundColor = [UIColor whiteColor];
=======
>>>>>>> main
        }
        if(!isImgeAvailableAllLoop){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else if(!isLoopingField_missing){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            //self.loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:242/255.0 blue:246/255.0 alpha:1.0];
        }
    }else if((!isAddon7Custom) && (self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        
<<<<<<< HEAD
    }else if(isAddon7Custom && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSMutableDictionary* parkLoad = [[parkloadarray objectAtIndex:indexPath.row] mutableCopy];
        NSMutableArray *img = [parkLoad valueForKey:@"img"];
        NSMutableArray *str = [parkLoad valueForKey:@"instructData"];
        bool isImgeAvailableAllsteps_custom = true;
        
        if(isAddon7CustomGpcc && str !=nil && str.count >0){
            
            for(int i = 0; i<str.count; i++){
                int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                NSLog(@"value:%d",value);
                NSMutableArray *newarr = [[NSMutableArray alloc]init];
                isImgeAvailableAllsteps_custom = TRUE;
                
                for(int j=0;j<img.count;j++){
                    NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                    int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                    NSLog(@"valuee:%@",valuee);
                    if(newvalue == value){
                        [newarr addObject:valuee];
                        NSLog(@"newarr:%@",newarr);
                        break;
                    }
                }
                if(newarr.count == 0){
                    isImgeAvailableAllsteps_custom = FALSE;
                    break;
                }
            }
        }else{
            if(img.count == 0){
                isImgeAvailableAllsteps_custom = FALSE;
            }
        }
        if(!isImgeAvailableAllsteps_custom){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            self.loadBtn.backgroundColor = [UIColor whiteColor];
        }
    }else{
        if (img_count.count>0 &&[dict valueForKey:@"category"] != nil && [dict valueForKey:@"fields"] != nil&& (!hasMandate|| isMandate)){
            self.loadBtn.backgroundColor = [UIColor whiteColor];
        }else{
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }
    }
    
    //checkbox
    int cboxX, cboxY,cboxH,cboxW;
    cboxX = 5;
    cboxY = self.loadBtn.frame.size.height/2 - 10;
    cboxH = self.loadBtn.frame.size.height/6;
    cboxW = self.loadBtn.frame.size.height/6;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cbox = [[Checkbox alloc] initWithFrame:CGRectMake(width - 30, cboxY, cboxH, cboxW)];
    }else{
        cbox = [[Checkbox alloc] initWithFrame:CGRectMake(cboxX, cboxY, cboxH, cboxW)];
    }
    NSMutableDictionary *dummy= [parkloadarray objectAtIndex:indexPath.row];
    bool checked=[[dummy objectForKey:@"isAutoUpload"] isEqualToString:@"1"];
    [cbox addTarget:self action:@selector(selectload:) forControlEvents:UIControlEventTouchUpInside];
    [cbox setTag:indexPath.row];
    NSMutableArray *co=[dummy objectForKey:@"img"];
    if (co.count >0 ) {
        if (checked) {
            [cbox setChecked:true];
        }else{
            [cbox setChecked:false];
        }
    }else{
        [cbox setChecked:false];
    }
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
        [self.loadBtn addSubview:cbox];
    }
    
    
    //Creating a Button -Delete Button
    UIButton *delete_button;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        delete_button =[[UIButton alloc]initWithFrame:CGRectMake(cboxX, 4, 30, 30)];
    }else{
        delete_button =[[UIButton alloc]initWithFrame:CGRectMake(width - 35, 4, 30, 30)];
    }
    [delete_button setBackgroundImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
    [delete_button addTarget:self action:@selector(deleteLoad:) forControlEvents:UIControlEventTouchUpInside];
    [delete_button setTag:indexPath.row];
    
    
    
    //Cretaing a label1-Meta Data1
    int meta_x=0;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        meta_x = delete_button.frame.size.width + delete_button.frame.origin.x + 5;
    }else{
        meta_x = cbox.frame.size.width + cbox.frame.origin.x + 5;
    }
    
    UILabel *meta_Data1;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.7, 40)];
        }
        meta_Data1.layer.borderWidth = 1;
        meta_Data1.layer.borderColor = [UIColor blackColor].CGColor;
        meta_Data1.layer.cornerRadius = 10;
        meta_Data1.layer.backgroundColor = Blue.CGColor;
        meta_Data1.text = self.field_label1;
        if (fields.count == 0) {
            meta_Data1.text = NSLocalizedString(@" ",@"");
        }
        meta_Data1.textColor = [UIColor whiteColor];
        [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data1.textAlignment = NSTextAlignmentCenter;
        meta_Data1.minimumScaleFactor=0.5;
=======
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        self.parkLoad = [[parkloadarray objectAtIndex:indexPath.row] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        NSArray *str = [self.parkLoad valueForKey:@"instructData"];
        bool isImgeAvailableAllsteps;
        for(int i = 0; i<str.count; i++){
            int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
            NSLog(@"value:%d",value);
            NSMutableArray *newarr = [[NSMutableArray alloc]init];
            isImgeAvailableAllsteps = TRUE;
            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                NSLog(@"valuee:%@",valuee);
                if(newvalue == value){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                isImgeAvailableAllsteps = FALSE;
                break;
            }
        }
        if(!isImgeAvailableAllsteps){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            //self.loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:242/255.0 blue:246/255.0 alpha:1.0];
        }
        
    }else if(isAddon7Custom && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSMutableDictionary* parkLoad = [[parkloadarray objectAtIndex:indexPath.row] mutableCopy];
        NSMutableArray *img = [parkLoad valueForKey:@"img"];
        NSMutableArray *str = [parkLoad valueForKey:@"instructData"];
        bool isImgeAvailableAllsteps_custom = true;
        
        if(isAddon7CustomGpcc && str !=nil && str.count >0){
            
            for(int i = 0; i<str.count; i++){
                int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
                NSLog(@"value:%d",value);
                NSMutableArray *newarr = [[NSMutableArray alloc]init];
                isImgeAvailableAllsteps_custom = TRUE;
                
                for(int j=0;j<img.count;j++){
                    NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                    int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                    NSLog(@"valuee:%@",valuee);
                    if(newvalue == value){
                        [newarr addObject:valuee];
                        NSLog(@"newarr:%@",newarr);
                        break;
                    }
                }
                if(newarr.count == 0){
                    isImgeAvailableAllsteps_custom = FALSE;
                    break;
                }
            }
        }else{
            if(img.count == 0){
                isImgeAvailableAllsteps_custom = FALSE;
            }
        }
        if(!isImgeAvailableAllsteps_custom){
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }else{
            //self.loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:242/255.0 blue:246/255.0 alpha:1.0];
        }
    }else{
        if (img_count.count>0 &&[dict valueForKey:@"category"] != nil && [dict valueForKey:@"fields"] != nil&& (!hasMandate|| isMandate)){
            //self.loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:242/255.0 blue:246/255.0 alpha:1.0];
        }else{
            //loadBtn.backgroundColor = [UIColor whiteColor];
            self.loadBtn.backgroundColor = [UIColor colorWithRed: 0.91 green: 0.27 blue: 0.27 alpha: 1.00];
        }
>>>>>>> main
    }
   
    
<<<<<<< HEAD
    
    //field1_value
    UILabel *meta_Data_value1;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){

        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.6, 40)];
            
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, self.loadBtn.frame.size.width/2.6, 40)];
            
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    meta_Data_value1.layer.borderWidth = 1;
    meta_Data_value1.layer.borderColor = [UIColor blackColor].CGColor;
    meta_Data_value1.layer.cornerRadius = 10;
    meta_Data_value1.text = fieldvalue1;
    if (fields.count == 0) {
        meta_Data_value1.text = @"";
    }
    meta_Data_value1.textColor = Blue;
    [meta_Data_value1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data_value1.textAlignment = NSTextAlignmentCenter;
    meta_Data_value1.minimumScaleFactor=0.5;
    
    
    //creating metadata1 field for arabic
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5 ,10, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5,10, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5,10, self.loadBtn.frame.size.width/2.7, 40)];
        }
        meta_Data1.layer.borderWidth = 1;
        meta_Data1.layer.borderColor = [UIColor blackColor].CGColor;
        meta_Data1.layer.cornerRadius = 10;
        meta_Data1.layer.backgroundColor = Blue.CGColor;
        meta_Data1.text = self.field_label1;
        if (fields.count == 0) {
            meta_Data1.text = NSLocalizedString(@" ",@"");
        }
        meta_Data1.textColor = [UIColor whiteColor];
        [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data1.textAlignment = NSTextAlignmentCenter;
        meta_Data1.minimumScaleFactor=0.5;
    }
    
    
    //Creating a Label1-Meta Data2
    UILabel* meta_Data2;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    meta_Data2.layer.backgroundColor = Blue.CGColor;
    meta_Data2.layer.borderWidth = 1;
    meta_Data2.layer.borderColor = [UIColor blackColor].CGColor;
    meta_Data2.layer.cornerRadius = 10;
    if (fields.count >1) {
        if(fieldvalue2.length == 0){
                meta_Data2.text = NSLocalizedString(@" ",@"");
        }else {
            meta_Data2.text = self.field_label2;
        }
    }else if (fields.count < 2) {
        meta_Data2.text = NSLocalizedString(@" ",@"");
    }
    meta_Data2.textColor = [UIColor whiteColor];
    [meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data2.textAlignment = NSTextAlignmentCenter;
    meta_Data2.minimumScaleFactor=0.5;
    
    //field2_value
    UILabel* meta_Data_value2;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]){
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]){
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    meta_Data_value2.layer.borderWidth = 1;
    meta_Data_value2.layer.borderColor = [UIColor blackColor].CGColor;
    meta_Data_value2.layer.cornerRadius = 10;
    if (fields.count >1) {
        meta_Data_value2.text = fieldvalue2;
    }else if (fields.count < 2) {
        meta_Data_value2.text = @"";
    }
    meta_Data_value2.textColor = Blue;
    [meta_Data_value2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data_value2.textAlignment = NSTextAlignmentCenter;
    meta_Data_value2.minimumScaleFactor=0.5;
=======
    //checkbox
    int cboxX, cboxY,cboxH,cboxW;
    cboxX = 5;
    cboxY = self.loadBtn.frame.size.height/2 - 10;
    cboxH = 20;
    cboxW = 20;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    
    //Creating a Button -Delete Button
    UIButton *delete_button;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        delete_button =[[UIButton alloc]initWithFrame:CGRectMake(cboxX, 15, 30, 30)];
    }else{
        delete_button =[[UIButton alloc]initWithFrame:CGRectMake(width - 45, 15, 30, 30)];
    }
    [delete_button setBackgroundImage:[UIImage imageNamed:@"delete_new.png"] forState:UIControlStateNormal];
    [delete_button addTarget:self action:@selector(deleteLoad:) forControlEvents:UIControlEventTouchUpInside];
    [delete_button setTag:indexPath.row];
    
    //Cretaing a label1-Meta Data1
    int meta_x = 20;
//    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
//        meta_x = delete_button.frame.size.width + delete_button.frame.origin.x + 5;
//    }else{
//        meta_x = cbox.frame.size.width + cbox.frame.origin.x + 5;
//    }
>>>>>>> main
    
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cbox = [[Checkbox alloc] initWithFrame:CGRectMake(meta_x, 15, cboxH, cboxW)];
    }else{
        cbox = [[Checkbox alloc] initWithFrame:CGRectMake(meta_x, 15, cboxH, cboxW)];
    }
    UIButton *checkboxIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cboxH, cboxW)];
    
    NSMutableDictionary *dummy= [parkloadarray objectAtIndex:indexPath.row];
    bool checked = [[dummy objectForKey:@"isAutoUpload"] isEqualToString:@"1"];
    [checkboxIcon addTarget:self action:@selector(selectload:) forControlEvents:UIControlEventTouchUpInside];
    [cbox setTag:indexPath.row];
    [checkboxIcon setTag:indexPath.row];
    NSMutableArray *co=[dummy objectForKey:@"img"];
   
    if (co.count > 0) {
        if (checked) {
            [checkboxIcon setBackgroundImage:[UIImage imageNamed:@"tick_new.png"] forState:UIControlStateNormal];
            [cbox setChecked:true];
        }else{
            [checkboxIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
            [cbox setChecked:false];
        }
    }else{
        [checkboxIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
        [cbox setChecked:false];
    }
    [cbox addSubview:checkboxIcon];
    
<<<<<<< HEAD
    //creating label for diaplaying image count
    int meta_y = meta_Data1.frame.size.height + meta_Data_value1.frame.size.height+ 15;
    UILabel *image_Count;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data2.frame.origin.x,meta_y,meta_Data1.frame.size.width, 30)];
    }else{
        image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data_value1.frame.origin.x,meta_y,meta_Data1.frame.size.width, 30)];
    }
    image_Count.text =[NSString stringWithFormat:NSLocalizedString(@"%@ Media files",@""),str_image_count];
    image_Count.adjustsFontSizeToFitWidth = YES;
    [image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    image_Count.textAlignment =  NSTextAlignmentCenter;
    image_Count.textColor = [UIColor blackColor];


    
    
    //Cretaing label for displaying the time
    UILabel *parked_time;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data_value1.frame.origin.x, meta_y,meta_Data1.frame.size.width, 30)];
    }else{
        parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data1.frame.origin.x, meta_y,meta_Data1.frame.size.width, 30)];
    }
    parked_time.adjustsFontSizeToFitWidth = YES;
    parked_time.text = [NSString stringWithFormat:NSLocalizedString(@"Parked at %@",@""),parkedTime];
    [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    parked_time.textAlignment =  NSTextAlignmentCenter;
    parked_time.textColor = [UIColor blackColor];
    
    
    //adding all in view
    [self.loadBtn addSubview:parked_time];
    [self.loadBtn addSubview:image_Count];
    [self.loadBtn addSubview:delete_button];
    [self.loadBtn addSubview:meta_Data1];
    [self.loadBtn addSubview:meta_Data_value1];
    [self.loadBtn addSubview:meta_Data2];
    [self.loadBtn addSubview:meta_Data_value2];
    [cell addSubview:self.loadBtn];
    [cell setTag:indexPath.row];
    NSLog(@"loadbtn %@",self.loadBtn);

    return cell;
}



-(void)alert{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Upload",@"") target:self selector:@selector(upload:) backgroundColor:Green];
    [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"This load can't be edited because it was interrupted while uploading.\nClick 'Upload' to resume upload.",@"") closeButtonTitle:nil duration:1.0f ];
}
    
-(IBAction)upload:(id)sender
{
    //self.customAlertView.hidden = YES;
    [self.alertbox hideView];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
        
        UploadVC.sitename = self.siteData.siteName;
        UploadVC.siteData=self.siteData;
        UploadVC.image_quality=self.siteData.image_quality;
        UploadVC.isEdit =NO;
        [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:UploadVC animated:YES];
    }else{
        [self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing!.\nConnect with Network to Upload the Loads.",@" ") duration:2.0 position:CSToastPositionCenter];
    }
=======
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
        [self.loadBtn addSubview:cbox];
    }
    
    //Creating a Label1-Meta Data2
    UILabel* meta_Data2;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    //meta_Data2.layer.backgroundColor = Blue.CGColor;
    //meta_Data2.layer.borderWidth = 1;
    //meta_Data2.layer.borderColor = [UIColor blackColor].CGColor;
    //meta_Data2.layer.cornerRadius = 10;
    if (fields.count >1) {
        if(fieldvalue2.length == 0){
                meta_Data2.text = NSLocalizedString(@" ",@"");
        }else {
            meta_Data2.text = self.field_label1;
        }
    }else if (fields.count < 2) {
        meta_Data2.text = NSLocalizedString(@" ",@"");
    }
    meta_Data2.textColor = [UIColor blackColor];
    meta_Data2.textAlignment = NSTextAlignmentLeft;
    meta_Data2.minimumScaleFactor=0.5;
    
    if(fontPosition == 0){
        //[meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        meta_Data2.font = [UIFont boldSystemFontOfSize:13.0];
    }
    else if(fontPosition == 1){
//        [meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data2.font = [UIFont boldSystemFontOfSize:14.0];
    }
    else{
//        [meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        meta_Data2.font = [UIFont boldSystemFontOfSize:15.0];
    }
    
    //field1_value
    UILabel *meta_Data_value1;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){

        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.6, 40)];
            
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x, cboxH + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data2.frame.size.width, cboxH + 15, self.loadBtn.frame.size.width/2.6, 40)];
            
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data2.frame.size.width, cboxH + 15, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data2.frame.size.width, cboxH + 15, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    //meta_Data_value1.layer.borderWidth = 1;
    //meta_Data_value1.layer.borderColor = [UIColor blackColor].CGColor;
    //meta_Data_value1.layer.cornerRadius = 10;
    meta_Data_value1.text = self.field_label2;
    if (fields.count == 0) {
        meta_Data_value1.text = @"";
    }
    meta_Data_value1.textColor = [UIColor blackColor];
    meta_Data_value1.textAlignment = NSTextAlignmentLeft;
    meta_Data_value1.minimumScaleFactor=0.5;
    
     if(fontPosition == 0){
         //[meta_Data_value1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
         meta_Data_value1.font = [UIFont boldSystemFontOfSize:13.0];
     }
     else if(fontPosition == 1){
//         [meta_Data_value1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
         meta_Data_value1.font = [UIFont boldSystemFontOfSize:14.0];
     }
     else{
//         [meta_Data_value1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
         meta_Data_value1.font = [UIFont boldSystemFontOfSize:15.0];
     }
    
    UILabel *meta_Data1;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.7, 40)];
        }
        //meta_Data1.layer.borderWidth = 1;
        //meta_Data1.layer.borderColor = [UIColor blackColor].CGColor;
        //meta_Data1.layer.cornerRadius = 10;
        //meta_Data1.layer.backgroundColor = Blue.CGColor;
        meta_Data1.text = fieldvalue1;
        if (fields.count == 0) {
            meta_Data1.text = NSLocalizedString(@" ",@"");
        }
        meta_Data1.textColor = [UIColor blackColor];
        meta_Data1.textAlignment = NSTextAlignmentLeft;
        meta_Data1.minimumScaleFactor=0.5;
       
        if(fontPosition == 0){
//            [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:15.0];
        }
        else if(fontPosition == 1){
//            [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:16.0];
        }
        else{
//            [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:19]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:17.0];
        }
    }
   
    //creating metadata1 field for arabic
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5 , meta_Data1.frame.size.height + 20, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]) {
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5, meta_Data1.frame.size.height + 20, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data_value1.frame.size.width + 5, meta_Data1.frame.size.height + 20, self.loadBtn.frame.size.width/2.7, 40)];
        }
        //meta_Data1.layer.borderWidth = 1;
        //meta_Data1.layer.borderColor = [UIColor blackColor].CGColor;
        //meta_Data1.layer.cornerRadius = 10;
        //meta_Data1.layer.backgroundColor = Blue.CGColor;
        meta_Data1.text = fieldvalue1;
        if (fields.count == 0) {
            meta_Data1.text = NSLocalizedString(@" ",@"");
        }
        meta_Data1.textColor = [UIColor blackColor];
        //[meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data1.textAlignment = NSTextAlignmentLeft;
        meta_Data1.minimumScaleFactor=0.5;
        if(fontPosition == 0){
            //[meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:15.0];
        }
        else if(fontPosition == 1){
//            [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:16.0];
        }
        else{
//            [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
            meta_Data1.font = [UIFont boldSystemFontOfSize:17.0];
        }
    }
    
    
    //field2_value
    UILabel* meta_Data_value2;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]){
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }else{
        if ([model isEqualToString:@"iPhone"]) {
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.6, 40)];
        }else if ([model isEqualToString:@"iPad"]){
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.3, 40)];
        }else{
            meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width,meta_Data2.frame.size.height + 20, self.loadBtn.frame.size.width/2.7, 40)];
        }
    }
    //meta_Data_value2.layer.borderWidth = 1;
    //meta_Data_value2.layer.borderColor = [UIColor blackColor].CGColor;
    //meta_Data_value2.layer.cornerRadius = 10;
    if (fields.count >1) {
        meta_Data_value2.text = fieldvalue2;
    }else if (fields.count < 2) {
        meta_Data_value2.text = @"";
    }
    meta_Data_value2.textColor = [UIColor blackColor];
    meta_Data_value2.textAlignment = NSTextAlignmentLeft;
    meta_Data_value2.minimumScaleFactor=0.5;
    
    if(fontPosition == 0){
//        [meta_Data_value2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        meta_Data_value2.font = [UIFont boldSystemFontOfSize:15.0];
    }
    else if(fontPosition == 1){
//        [meta_Data_value2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
        meta_Data_value2.font = [UIFont boldSystemFontOfSize:16.0];
    }
    else{
//        [meta_Data_value2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:19]];
        meta_Data_value2.font = [UIFont boldSystemFontOfSize:17.0];
    }
    
    //creating label for diaplaying image count
    int meta_y = meta_Data1.frame.size.height + meta_Data_value1.frame.size.height+ 15;
    UILabel *image_Count;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data_value2.frame.origin.x, meta_y + 20, meta_Data1.frame.size.width + 35, 30)];
    }else{
        image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data2.frame.origin.x, meta_y + 20, meta_Data1.frame.size.width + 35, 30)];
    }
    image_Count.text =[NSString stringWithFormat:NSLocalizedString(@"%@ Media files",@""),str_image_count];
    image_Count.adjustsFontSizeToFitWidth = YES;
    //[image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    image_Count.textAlignment =  NSTextAlignmentLeft;
    image_Count.textColor = [UIColor blackColor];

    if (fontPosition == 0) {
        //[image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];
        image_Count.font = [UIFont boldSystemFontOfSize:12.0];
    }
      else if (fontPosition == 1) {
//        [image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
          image_Count.font = [UIFont boldSystemFontOfSize:13.0];
    }
      else{
//            [image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
          image_Count.font = [UIFont boldSystemFontOfSize:14.0];
      }
    
    
    //Cretaing label for displaying the time
    UILabel *parked_time;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data1.frame.origin.x, meta_y + 20, meta_Data1.frame.size.width, 30)];
    }else{
        parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data_value1.frame.origin.x, meta_y + 20, meta_Data1.frame.size.width, 30)];
    }
    parked_time.adjustsFontSizeToFitWidth = YES;
    parked_time.text = [NSString stringWithFormat:NSLocalizedString(@"Parked at %@",@""),parkedTime];
    //[parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    parked_time.textAlignment =  NSTextAlignmentLeft;
    parked_time.textColor = [UIColor blackColor];
    
    if (fontPosition == 0) {
//        [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];
        parked_time.font = [UIFont boldSystemFontOfSize:12.0];
    }
      else if (fontPosition == 1) {
//        [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
          parked_time.font = [UIFont boldSystemFontOfSize:13.0];
    }
      else{
//            [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
          parked_time.font = [UIFont boldSystemFontOfSize:14.0];
      }
    
    CGFloat lineThickness = 2;
    HorizontalDottedLineView *horizontalLine = [[HorizontalDottedLineView alloc] initWithFrame:CGRectMake(25, meta_y + 10, self.loadBtn.frame.size.width - 50, lineThickness)];
    horizontalLine.backgroundColor = [UIColor clearColor]; // Set background color to clear
    horizontalLine.lineColor =  [UIColor colorWithRed: 212/255.0 green: 210/255.0 blue: 210/255.0 alpha: 1.00];
    horizontalLine.lineWidth = lineThickness; // Set line thickness
    horizontalLine.dotSpacing = 3; // Set dot spacing
    [self.loadBtn addSubview:horizontalLine];

    //adding all in view
    [self.loadBtn addSubview:image_Count];
    [self.loadBtn addSubview:parked_time];
    [self.loadBtn addSubview:delete_button];
    [self.loadBtn addSubview:meta_Data1];
    [self.loadBtn addSubview:meta_Data_value1];
    [self.loadBtn addSubview:meta_Data2];
    [self.loadBtn addSubview:meta_Data_value2];
    [cell addSubview:self.loadBtn];
    [cell setTag:indexPath.row];
    NSLog(@"loadbtn %@",self.loadBtn);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}



-(void)alert{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Upload",@"") target:self selector:@selector(upload:) backgroundColor:Green];
    [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"This load can't be edited because it was interrupted while uploading.\nClick 'Upload' to resume upload.",@"") closeButtonTitle:nil duration:1.0f ];
}
    
-(IBAction)upload:(id)sender
{
    //self.customAlertView.hidden = YES;
    [self.alertbox hideView];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
        
        UploadVC.sitename = self.siteData.siteName;
        UploadVC.siteData=self.siteData;
        UploadVC.image_quality=self.siteData.image_quality;
        UploadVC.isEdit =NO;
        [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:UploadVC animated:YES];
    }else{
        [self.view makeToast:NSLocalizedString(@"Internet Connectivity Missing!.\nConnect with Network to Upload the Loads.",@" ") duration:2.0 position:CSToastPositionCenter];
    }
>>>>>>> main
}

-(IBAction)closealert:(id)sender
{
    self.customAlertView.hidden=YES;
}


- (IBAction)selectload:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    Add_on *add_on;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
    NSMutableDictionary *_oldDict = [[parkloadarray objectAtIndex:btn.tag ] mutableCopy];
    NSMutableArray *count=[[NSMutableArray alloc]init];
    NSMutableArray *field_count=[[NSMutableArray alloc]init];
    count=[_oldDict objectForKey:@"img"];
    bool isAddon7Custom = [_oldDict valueForKey:@"isAddon7Custom"];
    bool isAddon7CustomGpcc =[_oldDict valueForKey:@"isAddon7CustomGpcc"];
    NSMutableArray* instArr = [_oldDict valueForKey:@"instructData"];
    bool isImgeAvailableAllsteps_custom = TRUE;

    if(hasAddon8 && !hasCustomCategory){
        field_count=[_oldDict objectForKey:@"basefields"];
    }else{
        field_count=[_oldDict objectForKey:@"fields"];
    }
    bool isMandate=false,hasMandate=false;
    for (int index=0; index<field_count.count; index++) {
        NSDictionary *d=[field_count objectAtIndex:index];
        if ([[d objectForKey:@"field_mandatory"] isEqual:@"1"] ) {
            hasMandate=true;
            if ([[d objectForKey:@"field_attribute"]isEqual: @"Checkbox"]|| [[d objectForKey:@"field_attribute"]isEqual: @"Radio"]) {
                NSArray *arr=[d objectForKey:@"field_value"];
                isMandate= arr.count>0;
            }else{
                NSString *str=[d objectForKey:@"field_value"];
                isMandate= str.length>0;
<<<<<<< HEAD
            }
            if (!isMandate) {
                break;
            }
=======
            }
            if (!isMandate) {
                break;
            }
>>>>>>> main
        }
    }
    
    if(hasAddon8 && !hasCustomCategory){
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSLog(@"parkloadarray_fetch:%@",parkloadarray);
        self.parkLoad = [[parkloadarray objectAtIndex:btn.tag] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        isImgeAvailableAllLoop = TRUE;
        int str = [[self.parkLoad valueForKey:@"tappi_count"] intValue];
        NSMutableArray *loopingMetadata = [self.parkLoad valueForKey:@"loopingfields"];
        int tappi_count =[[self.parkLoad valueForKey:@"tappi_count"]intValue];
        for(int i = 0; i<str; i++){
            int value = i;
            NSLog(@"value:%d",value);
            NSMutableArray *newarr = [[NSMutableArray alloc]init];

            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"img_numb"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"img_numb"]objectAtIndex:j]intValue];
                NSLog(@"valuee:%@",valuee);
                if(newvalue == value){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                self.tappi_missing = i;
                isImgeAvailableAllLoop = FALSE;
                break;
            }
//            if(loopingMetadata.count < tappi_count){
//
//            }
        }
        if(!isImgeAvailableAllLoop){
            [cbox setChecked:false];
            NSString *str = [NSString stringWithFormat:NSLocalizedString(@"This parkload has zero mediafile in 'Tappi %d'. Please capture atleast one image to proceed",@""),self.tappi_missing+1];
            [self.view makeToast:str duration:3.0 position:CSToastPositionCenter];
            [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
        }else if (count.count>0 &&[_oldDict valueForKey:@"category"] != nil  && [_oldDict valueForKey:@"basefields"] != nil && (!(loopingMetadata.count < tappi_count)) &&(!hasMandate|| isMandate)) {
            
            if ([[_oldDict objectForKey:@"isAutoUpload"] isEqualToString:@"0"]) {
                [_oldDict setValue:@"1" forKey:@"isAutoUpload"];
            }else{
                [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
            }
            NSInteger index=btn.tag;
            [parkloadarray replaceObjectAtIndex:index withObject:_oldDict];
            [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"old_value_sub : %@",parkloadarray);
            [self checkforUpload];
        }else{
           if(count.count==0){
                [self.view makeToast:NSLocalizedString(@"This Parked Load has Zero Mediafile, Kindly Capture atleast One Mediafile to Upload ",@"") duration:3.0 position:CSToastPositionCenter];
            }else if(!hasMandate||isMandate){
                if ([_oldDict valueForKey:@"basefields"] == nil ){
                    [self.view makeToast:NSLocalizedString(@"Empty Mandatory MetaData field, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
                }else{
                    [self.view makeToast:NSLocalizedString(@"Empty MetaData fields, Kindly Enter Tappi MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:NSLocalizedString(@"Category Not Selected, Kindly Select Category and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }
        }
    }else if(!isAddon7Custom && self.IsiteId == self.siteData.siteId && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        self.parkLoad = [[parkloadarray objectAtIndex:btn.tag] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        NSArray *str = [self.parkLoad valueForKey:@"instructData"];
        NSString *nameStr = @"";
        for(int i = 0; i<str.count; i++){
            int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
            NSLog(@"value:%d",value);
            nameStr = [[str valueForKey:@"instruction_name"]objectAtIndex:i];
            NSMutableArray *newarr = [[NSMutableArray alloc]init];
            isImgeAvailableAllsteps = TRUE;

            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                NSLog(@"valuee:%@",valuee);
                NSString *imgName = [[img valueForKey:@"imageName"]objectAtIndex:j];
                if(newvalue == value && ![imgName isEqual: @""]){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                isImgeAvailableAllsteps = FALSE;
                break;
            }
        }
        if(!(isImgeAvailableAllsteps)){
            [cbox setChecked:false];
            NSString *toaststr = [NSString stringWithFormat:NSLocalizedString(@"This parkload has zero mediafile in '%@'. Please capture atleast one image to proceed",@""),nameStr];

            [self.view makeToast:toaststr duration:3.0 position:CSToastPositionCenter];
            [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
        }else if (count.count>0 &&[_oldDict valueForKey:@"category"] != nil  && [_oldDict valueForKey:@"fields"] != nil &&(!hasMandate|| isMandate)) {
            
            if ([[_oldDict objectForKey:@"isAutoUpload"] isEqualToString:@"0"]) {
                [_oldDict setValue:@"1" forKey:@"isAutoUpload"];
            }else{
                [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
            }
            NSInteger index=btn.tag;
            [parkloadarray replaceObjectAtIndex:index withObject:_oldDict];
            [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"old_value_sub : %@",parkloadarray);
            [self checkforUpload];
        }else{
           if(count.count==0){
                [self.view makeToast:NSLocalizedString(@"This Parked Load has Zero Mediafile, Kindly Capture atleast One Mediafile to Upload ",@"") duration:3.0 position:CSToastPositionCenter];
               
            }else if(!hasMandate||isMandate){
                [self.view makeToast:NSLocalizedString(@"Empty Mandatory MetaData field, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else if ([_oldDict valueForKey:@"fields"] == nil){
                
                 [self.view makeToast:NSLocalizedString(@"Empty MetaData fields, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:NSLocalizedString(@"Category Not Selected, Kindly Select Category and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }
        }
        
    }else if(isAddon7Custom && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        //fetching_parkload
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        self.parkLoad = [[parkloadarray objectAtIndex:btn.tag] mutableCopy];
        NSArray *img = [self.parkLoad valueForKey:@"img"];
        NSArray *str = [self.parkLoad valueForKey:@"instructData"];
        NSString* nameStr = @"";
        for(int i = 0; i<str.count; i++){
            int value = [[[str valueForKey:@"instruction_number"]objectAtIndex:i]intValue];
            NSLog(@"value:%d",value);
            NSMutableArray *newarr = [[NSMutableArray alloc]init];
            isImgeAvailableAllsteps_custom = TRUE;
            nameStr = [[str valueForKey:@"instruction_name"]objectAtIndex:i];

            for(int j=0;j<img.count;j++){
                NSString* valuee = [[img valueForKey:@"InstructNumber"]objectAtIndex:j];
                int newvalue = [[[img valueForKey:@"InstructNumber"]objectAtIndex:j]intValue];
                NSString *imgName = [[img valueForKey:@"imageName"]objectAtIndex:j];
                NSLog(@"valuee:%@",valuee);
                if(newvalue == value && ![imgName isEqual: @""]){
                    [newarr addObject:valuee];
                    NSLog(@"newarr:%@",newarr);
                    break;
                }
            }
            if(newarr.count == 0){
                isImgeAvailableAllsteps_custom = FALSE;
                break;
            }
        }
        if(!(isImgeAvailableAllsteps_custom)){
            [cbox setChecked:false];
            NSString *toaststr = [NSString stringWithFormat:NSLocalizedString(@"This parkload has zero mediafile in '%@'. Please capture atleast one image to proceed",@""),nameStr];
            [self.view makeToast:toaststr duration:3.0 position:CSToastPositionCenter];
            [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
        }else if (count.count>0 &&[_oldDict valueForKey:@"category"] != nil  && [_oldDict valueForKey:@"fields"] != nil &&(!hasMandate|| isMandate)) {
            
            if ([[_oldDict objectForKey:@"isAutoUpload"] isEqualToString:@"0"]) {
                [_oldDict setValue:@"1" forKey:@"isAutoUpload"];
            }else{
                [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
            }
            NSInteger index=btn.tag;
            [parkloadarray replaceObjectAtIndex:index withObject:_oldDict];
            [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"old_value_sub : %@",parkloadarray);
            [self checkforUpload];
        }else{
            if(count.count==0){
                [self.view makeToast:NSLocalizedString(@"This Parked Load has Zero Mediafile, Kindly Capture atleast One Mediafile to Upload ",@"") duration:3.0 position:CSToastPositionCenter];
                
            }else if(!hasMandate||isMandate){
                [self.view makeToast:NSLocalizedString(@"Empty Mandatory MetaData field, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else if ([_oldDict valueForKey:@"fields"] == nil){
                
                [self.view makeToast:NSLocalizedString(@"Empty MetaData fields, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:NSLocalizedString(@"Category Not Selected, Kindly Select Category and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }
        }
    }else{
        if (count.count>0 &&[_oldDict valueForKey:@"category"] != nil  && [_oldDict valueForKey:@"fields"] != nil&&(!hasMandate|| isMandate)) {
            
            if ([[_oldDict objectForKey:@"isAutoUpload"] isEqualToString:@"0"]) {
                [_oldDict setValue:@"1" forKey:@"isAutoUpload"];
            }
            else{
                [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
            }
            NSInteger index=btn.tag;
            [parkloadarray replaceObjectAtIndex:index withObject:_oldDict];
            [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"old_value_sub : %@",parkloadarray);
            [self checkforUpload];
        }else{
           if(count.count==0){
                [self.view makeToast:NSLocalizedString(@"This Parked Load has Zero Mediafile, Kindly Capture atleast One Mediafile to Upload ",@"") duration:3.0 position:CSToastPositionCenter];
               
            }else if(!hasMandate||isMandate){
                [self.view makeToast:NSLocalizedString(@"Empty Mandatory MetaData field, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else if ([_oldDict valueForKey:@"fields"] == nil){
                
                 [self.view makeToast:NSLocalizedString(@"Empty MetaData fields, Kindly Enter MetaData and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:NSLocalizedString(@"Category Not Selected, Kindly Select Category and Then Try to Upload.",@"") duration:3.0 position:CSToastPositionCenter];
            }
        }
    }
    [self button_status];
    [self.load_Table_View reloadData];
}


-(void) checkforUpload{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    BOOL isSelectall=NO;

    int counter=0;
    for (int i=0; i<parkloadarray.count; i++) {
        
        NSMutableDictionary *dict = [[parkloadarray objectAtIndex:i ] mutableCopy];
        if ([[dict valueForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            counter++;
            isSelectall=YES;
            //[self.Load_btn setTitle:@"Upload" forState:UIControlStateNormal];
            
            self.label.text=NSLocalizedString(@"Upload",@"");
<<<<<<< HEAD
=======
            [self.Load_btn setTitle:NSLocalizedString(@"Upload",@"") forState:UIControlStateNormal];
>>>>>>> main
        }
    }
    if (!isSelectall) {
       // [self.Load_btn setTitle:@"Click to Start a New Load" forState:UIControlStateNormal];

        self.label.text = NSLocalizedString(@"Click to Start a New Load",@"");
<<<<<<< HEAD
=======
        [self.Load_btn setTitle:NSLocalizedString(@"Click to Start a New Load",@"") forState:UIControlStateNormal];
>>>>>>> main
        // [selectAll setChecked:false];

    }
    
    if (counter==parkloadarray.count) {
        if (parkloadarray.count==0) {
            selectAll.hidden=YES;
<<<<<<< HEAD
            
        }else{
            selectAll.hidden=NO;
            [selectAll setChecked:true];
        }
    }else {
        [selectAll setChecked:false];
=======
            gifImageView.hidden = NO;
            clicktoStartLabel.hidden = NO;
        }else{
            selectAll.hidden=NO;
            gifImageView.hidden = YES;
            clicktoStartLabel.hidden = YES;
            [selectAll setChecked:true];
            [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"tick_new.png"] forState:UIControlStateNormal];
        }
    }else {
        [selectAll setChecked:false];
        [selectAllIcon setBackgroundImage:[UIImage imageNamed:@"untick_new.png"] forState:UIControlStateNormal];
>>>>>>> main
    }

    [self button_status];
   // [self.load_Table_View reloadData];

}

-(IBAction)deleteLoad:(id)sender
{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    UIButton *btn = (UIButton *)sender;
    
    loadIndex = btn.tag;
        
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(delete:) backgroundColor:Red];
    
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Deleting the load will delete all the pictures in the load, continue?",@"") closeButtonTitle:nil duration:1.0f ];
   
}


-(IBAction)delete:(id)sender{
    [self.alertbox hideView];
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    Add_on *add_on;
    self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_7"]){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
        }
    }
    NSDictionary *_oldDict = [parkloadarray objectAtIndex:loadIndex];
    
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    
    if (parkloadarray == nil) {
        parkloadarray = [[NSMutableArray alloc] init];
    }
    
    if ((self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
        [self.Load_btn setEnabled:YES];
    }
    
    if (parkloadarray.count>loadIndex) {
        [parkloadarray removeObjectAtIndex:loadIndex];
    }
    [self.view makeToast:NSLocalizedString(@"Load Deleted Sucessfully",@"") duration:2.0 position:CSToastPositionCenter];
    [delegate clearCurrentLoad];

    if (parkloadarray.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    int count = delegate.count;
    count -- ;
    delegate.count = count;
    [self.load_Table_View reloadData];
    
    
    if (parkloadarray == nil || parkloadarray.count == 0) {
        [[AZCAppDelegate sharedInstance] clearAllLoads];
    }
    
    [self checkforUpload];
    [self button_status];
    [self handleTimer];
    
}
-(BOOL) isBatchUpload{
    
    for (int i=0; i<parkloadarray.count; i++) {
        NSMutableDictionary *dict=[parkloadarray objectAtIndex:i];
        NSLog(@"Delegate value sub: %d %@",i,dict);
        if ([[dict objectForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            return true;
        }
    }
    return false;
}


-(IBAction)Loads:(id)sender{
    @try{
        if ([self isBatchUpload]){
            [self.view makeToast:NSLocalizedString(@"Un-Select All 'Quick Upload' Checkbox to Access the Parked Loads.",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            
            UIButton *btn = (UIButton *)sender;
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];

            NSMutableDictionary *arr = [[parkloadarray objectAtIndex:btn.tag]mutableCopy];
            currentloadnumber =(int) btn.tag;
            delegate.isNoEdit = NO;
            bool isAddon7Custom = [[arr objectForKey:@"isAddon7Custom"]boolValue];
            NSLog(@"dLoadNumber:%ld",(long)currentloadnumber);
            Add_on *add_on;
            self.IsiteId = delegate.userProfiels.instruct.sitee_Id;
            for (int index=0; index<self.siteData.categoryAddon.count; index++) {
                Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
                if([dict.addonName isEqual:@"addon_7"]){
                    add_on =[self.siteData.categoryAddon objectAtIndex:index];
                }
            }
            if ([arr valueForKey:@"load_id"] != nil){
                [self alert];
            }else if(hasAddon8 && !hasCustomCategory){
                Looping_Camera_ViewController * CameraLoopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraLoopVC"];
                CameraLoopVC.siteData = self.siteData;
                CameraLoopVC.siteName = self.siteName;
                CameraLoopVC.tapCount = delegate.ImageTapcount;
                CameraLoopVC.isEdit = YES;
                CameraLoopVC.load_number = self.loadNumber;
                
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CameraLoopVC animated:YES];
                
            }else if(isAddon7Custom && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
                
                    CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
                    Category.siteData = self.siteData;
                    Category.sitename = self.siteName;
                    Category.image_quality = self.siteData.image_quality;
                    delegate.ImageTapcount = 0;
                    delegate.isNoEdit = YES;
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey: @"CurrentLoadNumber"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController pushViewController:Category animated:YES];
                
            }else if((self.IsiteId == self.siteData.siteId) && [add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue){
                
                CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                CaptureVC.siteData = self.siteData;
                CaptureVC.siteName = self.siteName;
                CaptureVC.tapCount = delegate.ImageTapcount;
                CaptureVC.isEdit = YES;
                CaptureVC.load_number = self.loadNumber;
                
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CaptureVC animated:YES];
                
            }else{
                
                CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
                CameraVC.siteData = self.siteData;
                CameraVC.siteName = self.siteName;
                CameraVC.tapCount = delegate.ImageTapcount;
                CameraVC.isEdit = YES;
                CameraVC.load_number = self.loadNumber;
                
                [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:CameraVC animated:YES];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

-(void)remove:(NSNotification *)notification{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[LoadSelectionViewController class]])
        {
//            [self.navigationController popToViewController:controller animated:YES];
            // [self.myimagearray removeAllObjects];
            //[self.collection_View reloadData];
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            if (parkloadarray.count > 0) {
                if (delegate.isEdit) {
                    [parkloadarray removeObjectAtIndex:currentloadnumber];
                    int count = 0;
                    count = delegate.count;
                    count --;
                    delegate.count = count;
                    // break;
                }
                [self.load_Table_View reloadData];
            }
            else{
                delegate.count = 0;
                [self.load_Table_View reloadData];
            }
        }
    }
}



@end
