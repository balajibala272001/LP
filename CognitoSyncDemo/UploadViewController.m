//
//  UploadViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//


#import "UploadViewController.h"
#import "StaticHelper.h"
#import "ServerUtility.h"
#import "UIView+Toast.h"
#import "CustomIOSAlertView.h"
#import "UserCategoryViewController.h"
#import "ProjectDetailsViewController.h"
#import "PicViewController.h"
#import "LoadSelectionViewController.h"
#import <OpinionzAlertView.h>
#import "Reachability.h"
#import "networkpopViewController.h"
#import "MRCircularProgressView.h"
#import "AZCAppDelegate.h"
#import "PPPinCircleView.h"
#import "Add_on.h"


//#import "FCAlertView/Classes/FCAlertView.h"

#define kOpinionzSeparatorColor      [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]

#define kOpinionzDefaultHeaderColor  [UIColor colorWithRed:0.8 green:0.13 blue:0.15 alpha:1]
@interface UploadViewController () {
NSMutableDictionary* currentLotRelatedData;
NSMutableArray *parkloadArray;
NSInteger currentloadnumber;
NSMutableDictionary * parkload;
BOOL isUploadingPreviousLot, hasCustomCategory;
NSMutableDictionary *parkLoadRelatedData;
}

@end

@interface UploadViewController ()<UIPopoverControllerDelegate>{
networkpopViewController *popover;
}
@end

@implementation UploadViewController

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
    NSLog(@"PLOAD %d: %@",i,pload);
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
self.UserCategory=[pload objectForKey:@"category"];
self.Category_Value_Label.text=self.UserCategory;
self.arrayWithImages=[pload objectForKey:@"img"];
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
arrFieldValues=[pload objectForKey:@"fields"];
[dictMetaData setObject:arrFieldValues forKey:@"fields"];

self.dictMetaData=dictMetaData;
self.pic_count=self.currentIndex<0?0:self.currentIndex;
ServerUtility * imge = [[ServerUtility alloc] init];
imge.picslist = self.arrayWithImages ;
[imge picslist];
}





-(void)viewDidLoad {
    [super viewDidLoad];
    self.upload_lbl.text = @"Start Uploading";
    hasCustomCategory=false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
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
//        [self.Ad_holder addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.circle_view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//        [self.Ad_holder addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.circle_view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

        
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
        circle_txt.text =[NSString stringWithFormat:@"Earn\n$ %@",self.str];
        circle_txt.textColor=[UIColor whiteColor];
        circle_txt.numberOfLines= 0;
        circle_txt.textAlignment=NSTextAlignmentCenter;
        circle_txt.lineBreakMode= NSLineBreakByWordWrapping;
        circle_txt.clipsToBounds = YES;
      
        [self.circle_view addSubview:circle_txt];
        [self.circle_view bringSubviewToFront:circle_txt];
        
//        self.Ad_holder.hidden = NO;
    }
    //else
        self.Ad_holder.hidden = YES;

    
    
    parkloadArray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"] mutableCopy];



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
    
    self.totalBatchloads.text=@"1";
    self.current_load.text = @"1/1";
    self.arrayWithImages=[parkload objectForKey:@"img"];
    currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    parkload=[parkloadArray objectAtIndex:currentloadnumber];
    self.arrayWithImages= [parkload objectForKey:@"img"];
    self.UserCategory=[parkload objectForKey:@"category"];
    self.Category_Value_Label.text = self.UserCategory;
    self.progressLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];
    self.image_progress.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];

}
self.upload_btn.layer.cornerRadius = 20;
self.upload_lbl.text = @"Start Uploading";

    //self.Category_Value_Label.text = self.UserCategory;
self.current_load.hidden = YES;
self.progressView.hidden = YES;
self.image_progress.hidden = YES;
self.circularProgressView.hidden = YES;

self.progressView.progress = 0.0;

self.SiteName_Value_Label.text = self.siteData.siteName;

self.SiteName_Value_Label.minimumScaleFactor = 0.5;
self.SiteName_Value_Label.numberOfLines = 2;

self.Category_Value_Label.minimumScaleFactor = 0.6;
self.Category_Value_Label.numberOfLines = 2;


int count  = self.arrayWithImages.count;
self.progressLabel.text = [NSString stringWithFormat:@"%d",count];
self.image_progress.text = [NSString stringWithFormat:@"%d",count];





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
    self.upload_btn.layer.borderWidth = 1;

self.park_btn.layer.cornerRadius = self.view.frame.size.width/15;
self.park_btn.layer.borderColor = [UIColor blackColor].CGColor;
self.park_btn.layer.borderWidth = 1;

self.upload_btn.titleLabel.textAlignment = NSTextAlignmentCenter;

self.park_btn.titleLabel.textAlignment = NSTextAlignmentCenter;


self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    //[uploadButton release];
    // Do any additional setup after loading the view.


}

-(void)viewWillAppear:(BOOL)animated
{

if (isUploadingPreviousLot) {
    [self upload_btn_action:nil];
}
[self handleTimer];
}


-(IBAction)back:(id)sender
{
[self.navigationController popViewControllerAnimated:YES];

}


-(void )handleTimer {

AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
networkStater.layer.masksToBounds = YES;
networkStater.layer.cornerRadius = 8.0;
UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
titleLabel.text = @"Upload";
titleLabel.textAlignment = NSTextAlignmentCenter;
titleLabel.highlighted=YES;
    //titleLabel.backgroundColor = [UIColor blackColor];


UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
[view addSubview:titleLabel];

view.center = self.view.center;


if (delegate.isMaintenance) {
    [networkStater
     setBackgroundImage:[UIImage imageNamed:@"yellow_nw.png"]  forState:UIControlStateNormal];
    networkStater.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.921 blue: 0.243 alpha: 1.00].CGColor;
    
        //RGBA ( 255 , 235 , 62 , 100 )
    
    networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
    
        //RGBA ( 213 , 191 , 0 , 100 )
    popover.labelvalue.text =@"Server maintenance";
    
    NSLog(@"Server Under maintenance");
    
}else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
    [networkStater
     setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
    popover.labelvalue.text =@"Network Connected";
    
    networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
    
        //RGBA ( 0 , 229 , 8 , 100)
    
    networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
    
        //RGBA ( 0 , 174 , 7 , 100 )
    
    NSLog(@"Network Connection available");
} else {
    NSLog(@"Network Connection not available");
    [networkStater
     setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
    popover.labelvalue.text =@"Network Not Connected";
    networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
    
        //RGBA ( 248 , 181 , 82 , 80 )
    
    networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
    
        //RGBA ( 253 , 133 , 8 , 100 )
    
    
}
networkStater.layer.borderWidth = 1.0;

[networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
[view addSubview:networkStater];
self.navigationItem.titleView = view;

}

-(IBAction)poper:(id)sender {
[self handleTimer];
/* if(popover == nil)
 {
 popover = [self.storyboard instantiateViewControllerWithIdentifier:@"netpop"];
 }
 
 popover.preferredContentSize = CGSizeMake(180, 30);
 popover.modalPresentationStyle = UIModalPresentationPopover;
 UIPopoverPresentationController *popoverController = popover.popoverPresentationController;
 popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
 popoverController.delegate = self;
 popoverController.sourceView = self.view;
 popoverController.sourceRect = [sender frame];
 //popoverController.backgroundColor =[UIColor blueColor];
 
 [self presentViewController:popover animated:YES completion:nil];*/
self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
[self.alertbox setHorizontalButtons:YES];

NSString *stat=@"Network Not Connected";
if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
    stat=@"Network Connected";
}

[self.alertbox setHorizontalButtons:YES];
[self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
[self.alertbox showSuccess:@"Status" subTitle:stat closeButtonTitle:nil duration:1.0f ];
}
-(IBAction)dummy:(id)sender{
[self.alertbox hideView];
}


-(IBAction)upload:(id)sender {
[self preUploadLot];
//self.view.userInteractionEnabled = NO;
[self.Upload setEnabled:NO];
self.image_progress.text = [NSString stringWithFormat:@"0/%d",(int)self.arrayWithImages.count];
self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
[self uploadingImage];
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

self.siteData.planname = [currentLotRelatedData objectForKey:@"PlanName"];

}

-(void) preUploadLot {
    // Folder -> Current Lot

if (isUploadingPreviousLot) {
    return; // no need to save it, its already saved in there.
}

    // check if Folder exists
    // if folde exists, do not save the photos and just return
    // else
    // create Folder in document directory
    // 1. save all images to Folder, with name <Array Index>.png // PENDING
    //// save all the UPLOAD RELATED DATA into user defaults
    // 2. save self.dictMetaData
    // 3. save self.currentIndex
    // 4. save self.UserCategory
    // 5. save self.load_id
    // 6. save self.pic_count






int Lnumber;
if (self.isBatchUpload)
    Lnumber = [self checkForBatchUpload];
else
    Lnumber=currentloadnumber;


NSMutableDictionary *dictMetaData = [NSMutableDictionary dictionary];
NSMutableDictionary *pload=[parkloadArray objectAtIndex:Lnumber];
[dictMetaData setObject:[pload objectForKey:@"c_id"] forKey:@"c_id"];
[dictMetaData setObject:[pload objectForKey:@"device_id"] forKey:@"device_id"];
[dictMetaData setObject:[pload objectForKey:@"n_id"] forKey:@"n_id"];
NSLog(@"Netid :%d",self.siteData.networkId);
[dictMetaData setObject:[pload objectForKey:@"s_id"] forKey:@"s_id"];

[dictMetaData setObject:[pload objectForKey:@"u_id"] forKey:@"u_id"];
NSMutableDictionary *arrFieldValues = [[NSMutableDictionary alloc]init];
arrFieldValues=[pload objectForKey:@"fields"];
[dictMetaData setObject:arrFieldValues forKey:@"fields"];
    
    
    
self.dictMetaData=dictMetaData;

self.arrayWithImages= [pload objectForKey:@"img"];
self.UserCategory=[pload objectForKey:@"category"];
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

NSMutableArray *dictor= [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
if (dictor.count >Lnumber) {
        //tempdict=[delegate.DisplayOldValues objectAtIndex:Lnumber] ;
    tempdict=[dictor objectAtIndex:Lnumber];
}

if (tempdict!=nil && [tempdict objectForKey:@"currentIndex"] !=nil) {
    self.currentIndex=[[tempdict objectForKey:@"currentIndex"] intValue];
}
[currentLotRelatedData setObject:@(self.currentIndex) forKey:@"self.currentIndex"]; // 3
[currentLotRelatedData setObject:self.UserCategory forKey:@"self.UserCategory"]; // 4
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
                                                                        //[currentLotRelatedData setObject:self.siteData.siteName forKey:@"self.sitename"]; // 6
[currentLotRelatedData setObject:self.siteData.planname forKey:@"PlanName"];

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

[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
[[NSUserDefaults standardUserDefaults] synchronize];
[self moveToLoadVC];
}

-(void)enablebuttons{
self.park_btn.hidden=NO;
[self.alertbox hideView];
self.image_progress.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];

self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
self.view.userInteractionEnabled = YES;
//[self.back_btn setEnabled:YES];
    //[self disableUploadButton];
[self enableUploadButton];
[self enableParkButton];
}



-(void)uploadingImage{
    [self.circularProgressView setProgress:0.0 animated:YES];

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
        self.upload_lbl.text = @"Uploading...";
        self.currentIndex = self.currentIndex + 1;
        int indexCount = self.currentIndex;
        self.image_progress.text = [NSString stringWithFormat:@"%d/%lu",indexCount,(unsigned long)self.arrayWithImages.count];

        self.progressLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayWithImages.count];
        int index = self.currentIndex;
        int count  =(int) self.arrayWithImages.count;
        self.progressView.progress = (index > 0) ? ((float)indexCount/count):0;
        self.current_load.hidden = NO;
        self.circularProgressView.hidden = NO;
        self.progressView.hidden = NO;
        self.image_progress.hidden = NO;
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
            
            NSLog(@"Image Quality (upload):%@",self.image_quality);
            if([self.siteData.image_quality isEqual:@"1"]) {
                sampleData = UIImageJPEGRepresentation(sample, 0.93);
                NSLog(@"compress ratio : %f",0.93);
            }else if([self.siteData.image_quality isEqual:@"2"]) {
                sampleData = UIImageJPEGRepresentation(sample, 0.85);
                NSLog(@"compress ratio : %f",0.85);
            }else if([self.siteData.image_quality isEqual:@"3"]){
                sampleData = UIImageJPEGRepresentation(sample, 0.9942);
                NSLog(@"compress ratio : %f",0.994);
            }
            
        }
        
        
            // NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((sample), 0.5)];
        
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
        if (hasCustomCategory) {
            CategoryData *category;
            for (int index=0; index<self.siteData.customCategory.count; index++) {
                category= self.siteData.customCategory[index];
                if ([category.categoryName isEqual: userCategory]) {
                    [FinalDict setObject:[NSString stringWithFormat:@"%d", category.categoryId ] forKey:@"custom_category_id"];
                    break;
                }
            }
        }
        [FinalDict setObject:ImageTime forKey:@"created_Epoch_Time"];
        [FinalDict setObject:userCategory forKey:@"category"];
                // "latitude":13.0935653,"longitude":80.2191081,"plan":"Platinum","note":""
        [FinalDict setObject:load_tookout_type forKey:@"load_tookout_type"];
        [FinalDict setObject:latitude forKey:@"latitude"];
        [FinalDict setObject:longitude forKey:@"longitude"];
        [FinalDict setObject:self.siteData.planname forKey:@"plan"];
        NSString * AppAccessVersion =  [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
        NSLog(@"AppAccessVersion :%@",AppAccessVersion);
        [FinalDict setObject:AppAccessVersion forKey:@"app_access_version"];
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
            //    else{
            //       [FinalDict setObject:[NSNumber numberWithInt:0] forKey:@"load_id"];
            //    }
        
        
        
        if (self.pic_count > 0) {
            [FinalDict setObject:[NSNumber numberWithInt:self.pic_count] forKey:@"pic_count"];
        }
            //GalleryMode
        if(self.siteData.addon_gallery_mode!=nil){
            [FinalDict setValue:self.siteData.addon_gallery_mode forKey:@"addon_gallery_mode"];
        }
            //            if(count >0){
            //                [FinalDict setObject:[NSNumber numberWithInt:count] forKey:@"total_pic_count"];
            //            }
            //    else{
            //        [FinalDict setObject:[NSNumber numberWithInt:0] forKey:@"pic_count"];
            //    }
        NSLog(@"START REQUEST %@",FinalDict);
        NSLog(@"Request FinalDict index num %d : %@",_currentIndex,FinalDict);
        NSLog(@"END REQUEST");
        
        [ServerUtility uploadImageWithAllDetails:FinalDict noteResource:sampleData andCompletion:^(NSError *error,id data, float percentage)
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
                    [self handleTimer];
                    [self.view makeToast:@"Server Under Maintenance!\nPark the Load and Try again later." duration:1.0 position:CSToastPositionCenter];
                    [self enablebuttons];
                }else if ([strResType.lowercaseString isEqualToString:@"success"]) {
                    if (self.load_id == 0) {
                        self.load_id  = [[data objectForKey:@"load_id"]intValue];
                        [currentLotRelatedData setObject:@(self.load_id) forKey:@"self.load_id"]; // 5
                        [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    NSString *email =[data objectForKey:@"nau_email"];
                        //NSString *email =@"suresh.smartgladiator@gmail.com";
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
                    NSLog(@"SiteData :%@",self.siteData);
                    if([self.siteData.planname isEqualToString:@"FreeTier"]){
                        if([data valueForKey:@"RemainingImagecount"] && [data valueForKey:@"RemainingVideocount"]){
                            self.siteData.RemainingVideocount= [[data objectForKey:@"RemainingVideocount"] intValue] ;
                            self.siteData.RemainingImagecount= [[data objectForKey:@"RemainingImagecount"] intValue];
                            
                            if (self.siteData.RemainingImagecount < 50) {
                                if (self.siteData.RemainingImagecount > 0) {
                                    self.siteData.uploadCount = self.siteData.RemainingVideocount  + self.siteData.RemainingImagecount ;
                                }else if (self.siteData.RemainingVideocount > 0){
                                    self.siteData.uploadCount= self.siteData.RemainingVideocount ;
                                }else{
                                    self.siteData.uploadCount=0;
                                }
                            }
                            
                        }
                    }else{
                        if([data valueForKey:@"RemainingSpacePercentage"]){
                            
                            self.siteData.RemainingSpacePercentage=[[data objectForKey:@"RemainingSpacePercentage"] doubleValue];
                        }
                    }
                    
                    if (index < self.arrayWithImages.count) {
                        [self updateCurrentIndexInUserDefaults];
                        [self uploadingImage];
                    }
                    else {
                            //                     AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
                        
                        self.upload_lbl.text = @"Uploaded";
                        
                        [self.back_btn setEnabled:NO];
                            // [self.Upload setEnabled:NO];
                        
                        
                        [self disableUploadButton];
                            // self.view.userInteractionEnabled = YES;
                        [delegate.window makeToast:@"Uploaded Successfully" duration:1.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
                        NSString *user = delegate.userProfiels.userType;
                        NSString *FirstName = delegate.userProfiels.firstName;
                        NSString *LastName = delegate.userProfiels.lastName;
                        NSString *corp_name = delegate.userProfiels.corporateEntity;
                        NSString *SiteName = self.siteData.siteName;
                        
                        NSString *Siteid = [NSString stringWithFormat:@"%d",self.siteData.siteId];
                        NSString *Corpid = [NSString stringWithFormat:@"%d",delegate.userProfiels.cId];
                        NSString *Load_id_no = [NSString stringWithFormat:@"%d",self.load_id];
                        NSString *message = @"Quality Issue";
                        NSLog(@"message:%@",message);
                        NSLog(@"self.message:%@",self.message);
                        NSLog(@"loadidno:%@",Load_id_no);
                        
                        
                        [details setObject:user forKey:@"user_type"];
                        [details setObject:corp_name forKey:@"corp_name"];
                            //[details setObject:self.siteData.addOnMail forKey:@"email_id"];
                        
                        [details setObject:FirstName forKey:@"first_name_load"];
                        [details setObject:LastName forKey:@"last_name_load"];
                        [details setObject:SiteName forKey:@"site_name"];
                        [details setObject:Load_id_no forKey:@"last_insert_load_id"];
                        
                        
                        if(self.siteData.addOn && self.siteData.addOnMail !=NULL){
                            [ServerUtility sendAddOnMail:user withEmail:self.siteData.addOnMail withFirstName:FirstName withLastName:LastName withSiteName:SiteName withSiteId:Siteid withCropId:Corpid withLoadId:Load_id_no withCorpName:corp_name andCompletion:^(NSError *error,id data,float dummy)
                             
                             {
                                if (!error) {
                                    NSLog(@"AddOnMail API:%@",data);
                                } else {
                                    self.ErrorLocal = error.localizedDescription;
                                    NSLog(@"AddOnMail:%@",error.localizedDescription);
                                    [self errorAlert];
                                }
                            }];
                        }
                        if ([self.UserCategory isEqualToString:message]) {
                            [details setObject:email forKey:@"email_id"];
                                //[details setObject:@"suresh.smargladiator@gmail.com" forKey:@"email_id"];
                            [ServerUtility SendAllDetails:user withEmail:email withFirstName:FirstName withLastName:LastName withSiteName:SiteName withCorpId:Corpid withSiteId:Siteid withLoadId:Load_id_no andCompletion:^(NSError *error,id data,float dummy)
                             
                             //[ServerUtility sendGMFData:details toServerWithBaseUrl:BASE_URL andCompletion:^(NSError *error,id data)
                             //  [ServerUtility SendInfo:details andCompletion:^(NSError *error,id data)
                             //            [ServerUtility SendInfo:user details:email details:FirstName details:LastName details:self.sitename details:Load_id_no andCompletion:^(NSError *error,id data)
                             {
                                if (!error) {
                                    NSLog(@"LAST API:%@",data);
                                } else {
                                    self.ErrorLocal = error.localizedDescription;
                                    NSLog(@"ERR:%@",error.localizedDescription);
                                    [self errorAlert];
                                }
                            }];
                            
                        }
                        
                        NSLog(@"details:%@",details);
                            //ending if
                        
                            //                     AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                        
                        delegate.ImageTapcount=0;
                        BOOL isParkLoadAvailable = false;
                        if (_isEdit && parkloadArray.count > 0) {
                                // [self.view makeToast:@"Saithan" duration:1.0 position:CSToastPositionCenter];
                            
                            
                            int  loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
                            
                            
                            
                            
                            [parkloadArray removeObjectAtIndex:loadNUmber];
                            
                            
                            [[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"ParkLoadArray"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            parkloadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                            if (parkloadArray == nil || parkloadArray.count == 0) {
                                [delegate clearAllLoads];
                            }
                            if (!delegate.isNoEdit) {
                                if (parkloadArray.count > 0) {
                                    [parkloadArray removeObjectAtIndex:loadNUmber];
                                }
                            }
                            
                            if (parkloadArray.count>0) {
                                    //             if (_uploadDelegate) {
                                
                                    // 1. save all images to Folder, with name <Array Index>.png // PENDING
                                    //// save all the UPLOAD RELATED DATA into user defaults
                                    // 2. save self.dictMetaData
                                    // 3. save self.currentIndex
                                    // 4. save self.UserCategory
                                    // 5. save self.load_id
                                    // 6. save self.pic_count
                                    // 7. save self.isEdit
                                    // 8. save self.sitename
                                    // 9. save delegate.PlanName
                                    // 10. save latitude
                                    // 11. save longitude
                                
                                
                                
                                AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                
                                
                                NSLog(@"LoadNumber :%d",loadNUmber);
                                
                                if([self checkForBatchUpload] !=-1) {
                                    
                                    self.currentIndex = -1;
                                    [self setupBatchUplaod ];
                                    self.Category_Value_Label.text=self.UserCategory;
                                    self.load_id=0;
                                    
                                    isUploadingPreviousLot = false;
                                    
                                    [self uploader];
                                    
                                }
                            }else{
                                double delayInSeconds = .5;
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploaded" object:parkloadArray];});
                                
                                    //                                    if (isParkLoadAvailable) {
                                    //
                                    //                                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
                                    //                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                    //                                    }else{
                                    //                                        [self postUploadLot];
                                    //                                    }
                            }
                        }else {
                            int  loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
                            if (!delegate.isEdit &&parkloadArray.count>loadNUmber ) {
                                if (parkloadArray.count > 0) {
                                        //new
                                    NSLog(@"load n:%d",loadNUmber);
                                    [parkloadArray removeObjectAtIndex:loadNUmber];
                                }
                                
                                
                                
                                [[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"ParkLoadArray"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                                
                                
                                if (parkLoadArray == nil) {
                                    parkLoadArray = [[NSMutableArray alloc] init];
                                }
                                
                                    //                                    if (!delegate.isNoEdit) {
                                    //                                        if (delegate.DisplayOldValues.count > 0) {
                                    //                                            [delegate.DisplayOldValues removeObjectAtIndex:loadNUmber];
                                    //                                        }
                                    //                                    }
                                
                                if (parkLoadArray.count >0) {
                                        //             if (_uploadDelegate) {
                                    
                                        // 1. save all images to Folder, with name <Array Index>.png // PENDING
                                        //// save all the UPLOAD RELATED DATA into user defaults
                                        // 2. save self.dictMetaData
                                        // 3. save self.currentIndex
                                        // 4. save self.UserCategory
                                        // 5. save self.load_id
                                        // 6. save self.pic_count
                                        // 7. save self.isEdit
                                        // 8. save self.sitename
                                        // 9. save delegate.PlanName
                                        // 10. save latitude
                                        // 11. save longitude
                                    
                                    
                                    
                                    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                                    
                                    
                                    NSLog(@"LoadNumber :%d",loadNUmber);
                                    
                                    if([self checkForBatchUpload] !=-1) {
                                        
                                        self.currentIndex = -1;
                                        [self setupBatchUplaod ];
                                        self.Category_Value_Label.text=self.UserCategory;
                                        self.load_id=0;
                                        isParkLoadAvailable=YES;
                                        isUploadingPreviousLot = false;
                                        
                                        [self uploader];
                                        
                                    }else{
                                        isParkLoadAvailable=NO;
                                    }
                                }else{
                                        //  [self.view makeToast:@"pei" duration:1.0 position:CSToastPositionCenter];
                                }
                                    //                                }else{
                                    //                                    [self.view makeToast:@"Pisasu" duration:1.0 position:CSToastPositionCenter];
                            }
                        }
                        
                        
                        
                        if (isParkLoadAvailable) {
                                //       [self.view makeToast:@"Mundam" duration:1.0 position:CSToastPositionCenter];
                                //                                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
                                //                                [[NSUserDefaults standardUserDefaults] synchronize];
                        }else{
                                //       [self.view makeToast:@"Thandam" duration:1.0 position:CSToastPositionCenter];
                                //                                double delayInSeconds = .5;
                                //                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                //
                                //                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                //                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploaded" object:delegate.DisplayOldValues];
                                //                                        //code to be executed on the main queue after delay
                                //                                });
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
                    [self.back_btn setEnabled:NO];
                        // [self.Upload setEnabled:NO];
                    [self disableUploadButton];
                    self.serverError= [data objectForKey:@"msg"];
                    self.serverError = [self.serverError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    
                    NSString *loadid = @"";
                    if([data objectForKey:@"load_id"]!= nil)
                    {
                        loadid = [data objectForKey:@"load_id"];
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
                [self.back_btn setEnabled:NO];
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
    }
}else{
        //[self enablebuttons];
    
    [self networkerrorAlert];
        //  [self.view makeToast:@"NetWork not Available.\n Enable NetWork (or) Park the Load." duration:1.0 position:CSToastPositionCenter];
}
}

-(void)networkerrorAlert{

[self.back_btn setEnabled:NO];
self.progressView.hidden = YES;
self.current_load.hidden = YES;
self.image_progress.hidden = YES;
self.circularProgressView.hidden = YES;
self.view.userInteractionEnabled = YES;
self.alertbox = [[SCLAlertView alloc] initWithNewWindow];


[self.alertbox setHorizontalButtons:YES];
[self.alertbox addButton:@"Ok" target:self selector:@selector(enablebuttons:) backgroundColor:Green];
[self.alertbox addButton:@"Retry" target:self selector:@selector(retry:) backgroundColor:Green];


[self.alertbox showSuccess:@"Alert" subTitle:@"Network not available.\n Enable Network (or) Park the load." closeButtonTitle:nil duration:1.0f ];
}

-(void)errorAlert
{

[self.back_btn setEnabled:NO];

self.view.userInteractionEnabled = NO;
NSString *context;
if (self.serverError.length > 0) {
    context =self.serverError;
} else {
    context =self.localerror;
}
self.alertbox = [[SCLAlertView alloc] initWithNewWindow];


[self.alertbox setHorizontalButtons:YES];

if ([context isEqualToString:@"The storage space for this site is full, please contact admin."]) {
    [self.alertbox addButton:@"Ok" target:self selector:@selector(retryWithOk:) backgroundColor:Green];
}else if([context isEqualToString:@"Category is no longer exist"]){
    [self.alertbox addButton:@"Ok" target:self selector:@selector(retryWithOk:) backgroundColor:Green];
}else if([context isEqualToString:@"Customized metadata is changed or no longer exist"]){
    [self.alertbox addButton:@"Ok" target:self selector:@selector(retryWithOk:) backgroundColor:Green];
}else if([context isEqualToString:@"Metadata is changed or no longer exist"]){
    
    [self.alertbox addButton:@"Ok" target:self selector:@selector(retryWithlogin:) backgroundColor:Green];
}else{
    [self.alertbox addButton:@"Retry" target:self selector:@selector(retry:) backgroundColor:Green];
}
[self.alertbox showSuccess:@"Warning" subTitle:context closeButtonTitle:nil duration:1.0f ];

}


-(void)startTimerToMove {
self.progressView.progress = 0.0;
self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
}

-(IBAction)move:(id)sender {
[[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
}

-(void)alertView{
self.current_load.hidden = YES;
self.circularProgressView.hidden = YES;
self.progressView.hidden = YES;
self.progressLabel.hidden = YES;
self.image_progress.hidden = YES;

self.navigationItem.hidesBackButton = YES;

self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

[self.alertbox setHorizontalButtons:YES];

[self.alertbox addButton:@"Retry" target:self selector:@selector(retry:) backgroundColor:Green];

[self.alertbox showSuccess:@"Retry" subTitle:self.localerror closeButtonTitle:nil duration:1.0f ];
}



-(IBAction)enablebuttons:(id)sender
{
    //    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    //
    //    int loadNUmber;
    //    if (self.isBatchUpload)
    //        loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
    //    else
    //        loadNUmber=delegate.LoadNumber;
    //
    //    NSMutableDictionary *load=nil;
    //    if(delegate.DisplayOldValues.count>loadNUmber){
    //        load= [delegate.DisplayOldValues objectAtIndex:loadNUmber];
    //    }
    //
    //    if (load!=nil) {
    //
    //        [load setObject:[NSString stringWithFormat:@"%d",(int)self.currentIndex] forKey:@"currentIndex"];
    //        [load setObject:[NSString stringWithFormat:@"%d",(int)self.pic_count] forKey:@"pic_count"];
    //        [load setObject:[NSString stringWithFormat:@"%d",(int)self.load_id] forKey:@"load_id"];
    //
    //        [delegate.DisplayOldValues replaceObjectAtIndex:loadNUmber withObject:load];
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //         currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];
    //        NSLog(@"Mythi  %@",currentLotRelatedData);
    //        isUploadingPreviousLot=false;
    //        [[NSUserDefaults standardUserDefaults] setObject:delegate.DisplayOldValues forKey:@"ParkLoadArray"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }


[self enablebuttons];
}
-(IBAction)retry:(id)sender
{



NSLog(@"Retry Clicked.");
[self.alertbox hideView];

if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
    self.upload_lbl.hidden = NO;
    self.progressLabel.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    [self uploadingImage];
}else{
    [self networkerrorAlert];
}

}
-(IBAction)retryWithlogin:(id)sender
{
    [self.alertbox hideView];
    
    self.upload_lbl.hidden = YES;
    self.upload_lbl.text = @"Uploading Failed...";
    
    //[self.back_btn setEnabled:YES];
        // [self.Upload setEnabled:YES];
    
        //[self enableUploadButton];
        //[self enableParkButton];
    [self enablebuttons];
    self.circularProgressView.hidden=YES;
    self.progressLabel.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    
    
        // [self uploadingImage];
    
    
    self.view.userInteractionEnabled = YES;
    
    //[parkloadArray replaceObjectAtIndex: withObject:];
    
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
self.upload_lbl.text = @"Uploading Failed...";

//[self.back_btn setEnabled:YES];
    // [self.Upload setEnabled:YES];

//[self enableUploadButton];
//[self enableParkButton];
    [self enablebuttons];
    self.circularProgressView.hidden=YES;
self.progressLabel.hidden = YES;
self.navigationItem.hidesBackButton = NO;


    // [self uploadingImage];


self.view.userInteractionEnabled = YES;


}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/




- (void)back_button:(id)sender {

[self.navigationController popViewControllerAnimated:YES];

}



-(void)moveToLoadVC {
NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
[[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
[[NSUserDefaults standardUserDefaults] synchronize];
for(NSUInteger i = array.count - 1; i>=0 ; i--) {
    if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
        NSLog(@"testing %lu", (unsigned long)i);
        [self.navigationController popToViewController:array[i] animated:true];
        break;
    } else if ([array[i] isKindOfClass:SiteViewController.class]){
        
        if (self.uploadDelegate != nil) {
            [self.uploadDelegate restartedUploadFinished];
        }else {
            SiteViewController *sitevc= [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            
            sitevc.movetolc=YES;
            [navigationArray removeAllObjects];
            [navigationArray addObject:sitevc];
            self.navigationController.viewControllers = navigationArray;
            
            [self.navigationController popToViewController:sitevc animated:true];
        }
        
        break;
    }
}
}



- (IBAction)upload_btn_action:(id)sender {
[self uploader];

}



-(void)uploader{

[self preUploadLot];
//self.view.userInteractionEnabled = NO;


[self disableUploadButton];

[self disbleParkButton];

if(self.isBatchUpload){
        // self.counter = [self totalBatchloadscount];
    [self setupBatchUplaod ];
}else{
    self.totalBatchloads.text=@"1";
    self.current_load.text = @"1/1";
    
    NSMutableDictionary *pload=[parkloadArray objectAtIndex:currentloadnumber];
    NSString *str=[pload objectForKey:@"category"];
    self.UserCategory=str;
    self.arrayWithImages=[pload objectForKey:@"img"];
}
    //[self.Upload setEnabled:NO];
self.Category_Value_Label.text=self.UserCategory;
self.image_progress.text = [NSString stringWithFormat:@"1/%d",(int)self.arrayWithImages.count];

self.progressLabel.text = [NSString stringWithFormat:@"%d",(int)self.arrayWithImages.count];
    [self uploadingImage];
}

-(void)disableUploadButton{
    if (![self.str isEqualToString:@""] && self.str != nil)
    {
    self.Ad_holder.hidden = NO;
    }
    [self.upload_btn setBackgroundColor:[UIColor colorWithRed: 0.54 green: 0.49 blue: 0.88 alpha: 1.00]];
    [self.upload_btn setEnabled:NO];
}
-(void)enableUploadButton{
    if (![self.str isEqualToString:@""] && self.str != nil)
    {
    self.Ad_holder.hidden = YES;
    }
    [self.upload_btn setBackgroundColor:Blue];
    [self.upload_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.upload_btn setEnabled:YES];
}

-(void)disbleParkButton{
    
    [self.park_btn setBackgroundColor:[UIColor colorWithRed: 0.54 green: 0.49 blue: 0.88 alpha: 1.00]];
    [self.park_btn setEnabled:NO];
}

-(void)enableParkButton{
    
    
    [self.park_btn setBackgroundColor:Blue];
    [self.park_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.park_btn setEnabled:YES];
}


-(void) park{
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!_isEdit ) {
        int ccount = delegate.count;
        ccount ++;
        delegate.count = ccount;
    }
    
        //old values
    self.currentIndex = self.currentIndex + 1;
    NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
    NSString *notes = [dict objectForKey:@"string"];
        //ss
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
    
    parkloadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    
        //    if (_isEdit ) {
        //        [ replaceObjectAtIndex:delegate.LoadNumber withObject:dictSavedOldValues];
        //    }
        //    else {
        //        [delegate.DisplayOldValues addObject:dictSavedOldValues];
        //    }
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"park" object:self.arraySavedOldValues];
    [self postUploadLot];
}
- (IBAction)park_action_btn:(id)sender {

    [self park];


}

-(void)saveParkedLoad:(NSMutableDictionary *)parkLoadDict{


NSLog(@"Parkload");
    //    NSMutableArray* newArray = [NSMutableArray array];
    //    for (NSInteger index = 0; index < self.arrayWithImages.count; index++) {
    //        NSMutableDictionary *imageDic = [self.arrayWithImages[index] mutableCopy];
    //        [newArray addObject:imageDic];
    //    }
    //
    //    [parkLoadDict setObject:newArray forKey:@"img"]; // 1
    //    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    //    int  loadNUmber ;
    //
    //    if (self.isBatchUpload)
    //        loadNUmber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UploadingParkLoadNumber"] intValue];
    //    else
    //        loadNUmber=currentloadnumber;
    //
    //    NSDictionary *_oldDict;
    //
    //    if (parkloadArray.count>loadNUmber ) {
    //        _oldDict = [parkloadArray objectAtIndex: loadNUmber];
    //
    //    }else{
    //        _oldDict=self.oldDict;
    //    }
    //
    //
    //
    //
    //    if (_oldDict != nil) {
    //        NSNumber *OldEpochTime = [_oldDict valueForKey:@"park_id"];
    //        for (NSDictionary *dict in parkloadArray) {
    //            if ([dict valueForKey:@"park_id"] == OldEpochTime) {
    //
    //                [parkLoadDict setValue:[dict objectForKey:@"isAutoUpload"] forKeyPath:@"isAutoUpload"];
    //                [parkloadArray replaceObjectAtIndex:[parkLoadArray indexOfObject:dict] withObject:parkLoadDict];
    //                break;
    //            }
    //        }
    //    }else{
    //        [parkloadArray addObject:parkLoadDict];
    //    }
[parkloadArray replaceObjectAtIndex:currentloadnumber withObject:parkLoadDict];
[[NSUserDefaults standardUserDefaults] setObject:parkloadArray forKey:@"ParkLoadArray"];
[[NSUserDefaults standardUserDefaults] synchronize];

}


- (void)viewWillDisappear:(BOOL)animated{
[self.alertbox hideView];
}

@end
