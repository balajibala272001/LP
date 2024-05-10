//
//  CaptureScreenViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 31/08/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

<<<<<<< HEAD
=======

>>>>>>> main
#import "CaptureScreenViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CollectionViewCell.h"
#import "StaticHelper.h"
#import "GalleryViewController.h"
#import "KeychainItemWrapper.h"
#import "UIView+Toast.h"
#import "Constants.h"
#import "AZCAppDelegate.h"
#import "ServerUtility.h"
#import "Reachability.h"
#import "LoadSelectionViewController.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>
#import "CreolePhotoSelection.h"
#import "CategoryViewController.h"
<<<<<<< HEAD
#import "CapturePreviewScreenController.h"
#import "PreviewViewController.h"


@interface CaptureScreenViewController ()<CreolePhotoSelectionDelegate, AVCapturePhotoCaptureDelegate>
=======
#import "PreviewPopController.h"


@interface CaptureScreenViewController ()<CreolePhotoSelectionDelegate, AVCapturePhotoCaptureDelegate,UIPopoverPresentationControllerDelegate>
>>>>>>> main
{
    NSString* pathToImageFolder;
    NSMutableArray *pics;
    NSString *videoName;
    NSString *AudioName;
    NSString *timeZone;
    NSTimer *timer;
    NSTimeInterval totalCountdownInterval;
    NSDate* startDate;
    int timecount;
    NSString  *PlanName;
    NSMutableDictionary *recordSetting;
    NSInteger currentLoadNumber;
    UILabel *flashButton, *flashLabel, *zoomlbl;
    //bool imagepick;
    bool pickimage;
    bool reset;
    AZCAppDelegate *delegateVC;
    bool cameraboolToRestrict;
    int numberofphotoCapturedforsteps;
    int TotalNoOfPhoto;
    ServerUtility * imge;
    NSMutableArray *tempImgarr;
    bool isImgeAvailableAllsteps;
    NSString *checkBlur;
<<<<<<< HEAD
=======
    NSString *gpccTitle;
    int currentIndex;
>>>>>>> main
}

-(UIImage *)generateThumbImage : (NSString *)filepath;

@end

@implementation CaptureScreenViewController

int uploadCount = 325;
int captureOrientation = 0;

BOOL WeAreRecording;

AVCaptureSession *session;
AVAudioSession *audiosession;
AVAudioRecorder *recorder;
AVCaptureMovieFileOutput *MovieFileOutput;
AVCapturePhotoOutput *StillImageOutput;
AVCaptureVideoDataOutput * _captureVideoDataOutput;
NSDate * _lastSequenceCaptureDate;
UIImageOrientation _sequenceCaptureOrientation;
AVCaptureVideoPreviewLayer *previewLayer;
AVCaptureDevice *avCaptureDevice;
<<<<<<< HEAD
=======
NSArray *colorCodes;
>>>>>>> main
//tapCount = 0;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************
- (IBAction)flashToggle:(id)sender{
    [self flash];
}

-(void) flash
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
<<<<<<< HEAD
            if (flashButton.tag == 1) {
                flashButton.tag=0;
                flashButton.text = NSLocalizedString(@"ON",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }else if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text = NSLocalizedString(@"OFF",@"");
=======
            if (self.FlashButton.tag == 1) {
                self.FlashButton.tag=0;
                [self.FlashButton setImage:[UIImage imageNamed:@"flash on.png"] forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }else if(self.FlashButton.tag == 0){
                self.FlashButton.tag=1;
               [self.FlashButton setImage:[UIImage imageNamed:@"flash_new.png"] forState:UIControlStateNormal];
>>>>>>> main
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            [flashLight unlockForConfiguration];
        }
    }
}
<<<<<<< HEAD


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    self.ArrayofstepPhoto = [[NSMutableArray alloc]init];
    self.ArrayofstepPhoto = [[self.parkLoad valueForKey:@"img"]mutableCopy];
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
        if(self.ArrayofstepPhoto.count != 0){
            self.nxt_clicked = [[[NSUserDefaults standardUserDefaults]valueForKey:@"nxtCount"]intValue];
            self.wholeStepsCount = self.nxt_clicked - 1;
=======
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
- (void)viewDidLoad{
    [super viewDidLoad];

        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        }
        AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
         colorCodes = [NSArray array];
        colorCodes = @[@"#237EC2", @"#C32120", @"#C3A622", @"#22C259", @"#DB504A", @"#B2339D", @"#A270FF", @"#6D3E3C", @"#188687", @"#F8812E", @"#01AF7E", @"#97677C", @"#C5D602", @"#4B0082", @"#567C6C", @"#AD9396", @"#C57D52", @"#245923", @"#FF4D00", @"#E9539B", @"#A9484D", @"#1B61B4"];
    
        self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
        self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
        self.ArrayofstepPhoto = [[NSMutableArray alloc]init];
        self.ArrayofstepPhoto = [[self.parkLoad valueForKey:@"img"]mutableCopy];
        if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            if(self.ArrayofstepPhoto.count != 0){
                self.nxt_clicked = [[[NSUserDefaults standardUserDefaults]valueForKey:@"nxtCount"]intValue];
                self.wholeStepsCount = self.nxt_clicked - 1;
            }else{
                self.wholeStepsCount = 0;
                self.nxt_clicked = 1;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
            }
>>>>>>> main
        }else{
            self.wholeStepsCount = 0;
            self.nxt_clicked = 1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
        }
<<<<<<< HEAD
    }else{
        self.wholeStepsCount = 0;
        self.nxt_clicked = 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
    }
    imge = [[ServerUtility alloc] init];
    if([self.parkLoad valueForKey:@"instructData"]!=nil){
        _instructData = [self.parkLoad valueForKey:@"instructData"];
    }
    
    //parkload_empty_img
    self.isTrue = false;
    for(int i = 0; i<self.ArrayofstepPhoto.count;i++){
        NSString* imagename = [[self.ArrayofstepPhoto valueForKey:@"imageName"] objectAtIndex:i];
        if([imagename isEqual: @""]){
            self.isTrue = true;
            break;
        }
    }
    
    cameraboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    NSLog(@"cameraboolToRestrict:%d",cameraboolToRestrict);
    pickimage = false;
    pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];
    uploadCount = self.siteData.uploadCount;
    self.tapCount = 0;
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"IOSVersion %@",iOSVersion);
    
    if(!(self.myimagearray.count > 0)) {
        self.myimagearray = [[NSMutableArray alloc]init];
    }
    self.tapCount = self.myimagearray.count;
    SiteData *sitesssClass = delegate.siteDatas;
    NSLog(@"the selected site:%@",sitesssClass.siteName);
    PlanName = sitesssClass.planname;
    delegate.PlanName = PlanName;
    self.firstTime = YES;
    int total_photo = 0;
    NSLog(@"_instructData.count:%lu",(unsigned long)_instructData.count);
    NSLog(@"selectedTab:%@",self.selectedTab);
    //if(isImgeAvailableAllsteps){
    if(self.ArrayofstepPhoto != nil){
        if(self.selectedTab == nil){
            for(int i=0; i<_instructData.count;i++){
                NSLog(@"i:%d",i);
                NSMutableDictionary *dict = [[_instructData objectAtIndex:i] mutableCopy];
                int countt = [[dict objectForKey:@"instruction_number"]intValue];
                for(int i=0; i<self.ArrayofstepPhoto.count;i++){
                    NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
                    int newcountt = [[newdict objectForKey:@"InstructNumber"]intValue];
                    if(countt == newcountt){
                        //self.wholeStepsCount = i;
=======
        imge = [[ServerUtility alloc] init];
        if([self.parkLoad valueForKey:@"instructData"]!=nil){
            _instructData = [self.parkLoad valueForKey:@"instructData"];
        }
        
        //parkload_empty_img
        self.isTrue = false;
        for(int i = 0; i<self.ArrayofstepPhoto.count;i++){
            NSString* imagename = [[self.ArrayofstepPhoto valueForKey:@"imageName"] objectAtIndex:i];
            if([imagename isEqual: @""]){
                self.isTrue = true;
                break;
            }
        }
        
        cameraboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
        NSLog(@"cameraboolToRestrict:%d",cameraboolToRestrict);
        pickimage = false;
        pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];
        uploadCount = self.siteData.uploadCount;
        self.tapCount = 0;
        NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
        NSLog(@"IOSVersion %@",iOSVersion);
        
        if(!(self.myimagearray.count > 0)) {
            self.myimagearray = [[NSMutableArray alloc]init];
        }
        self.tapCount = self.myimagearray.count;
        SiteData *sitesssClass = delegate.siteDatas;
        NSLog(@"the selected site:%@",sitesssClass.siteName);
        PlanName = sitesssClass.planname;
        delegate.PlanName = PlanName;
        self.firstTime = YES;
        int total_photo = 0;
        NSLog(@"_instructData.count:%lu",(unsigned long)_instructData.count);
        NSLog(@"selectedTab:%@",self.selectedTab);
        //if(isImgeAvailableAllsteps){
        if(self.ArrayofstepPhoto != nil){
            if(self.selectedTab == nil){
                for(int i=0; i<_instructData.count;i++){
                    NSLog(@"i:%d",i);
                    NSMutableDictionary *dict = [[_instructData objectAtIndex:i] mutableCopy];
                    int countt = [[dict objectForKey:@"instruction_number"]intValue];
                    for(int i=0; i<self.ArrayofstepPhoto.count;i++){
                        NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
                        int newcountt = [[newdict objectForKey:@"InstructNumber"]intValue];
                        if(countt == newcountt){
                            //self.wholeStepsCount = i;
                            [self.myimagearray addObject:newdict];
                            [self.collection_View reloadData];
                        }
                    }
                }
            }else{
                NSMutableDictionary *dict = [[_instructData objectAtIndex:self.selectedTab.selectedTab] mutableCopy];
                int countt = [[dict objectForKey:@"instruction_number"]intValue];
                [self.myimagearray removeAllObjects];
                for(int i=0; i<self.ArrayofstepPhoto.count;i++){
                    NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
                    if(countt == [[newdict objectForKey:@"InstructNumber"]intValue]){
                        self.wholeStepsCount = self.selectedTab.selectedTab;
>>>>>>> main
                        [self.myimagearray addObject:newdict];
                        [self.collection_View reloadData];
                    }
                }
            }
<<<<<<< HEAD
        }else{
            NSMutableDictionary *dict = [[_instructData objectAtIndex:self.selectedTab.selectedTab] mutableCopy];
            int countt = [[dict objectForKey:@"instruction_number"]intValue];
            [self.myimagearray removeAllObjects];
            for(int i=0; i<self.ArrayofstepPhoto.count;i++){
                NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
                if(countt == [[newdict objectForKey:@"InstructNumber"]intValue]){
                    self.wholeStepsCount = self.selectedTab.selectedTab;
                    [self.myimagearray addObject:newdict];
                    [self.collection_View reloadData];
                }
            }
        }
    }
    [self Instruc];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //notification
    [zoomlbl setHidden:TRUE];
    
    
    //Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    latitude = @"0.00000000";
    longitude = @"0.00000000";
    NSLog(@"latitude:%@",latitude);
    NSLog(@"longitude:%@",longitude);
    //Location
    
    //Back button
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
=======
        }
        [self Instruc];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
        //notification
        [zoomlbl setHidden:TRUE];
        
        
        //Location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
        latitude = @"0.00000000";
        longitude = @"0.00000000";
        NSLog(@"latitude:%@",latitude);
        NSLog(@"longitude:%@",longitude);

  /*  UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [logout addTarget:self action:@selector(logoutClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;*/
    
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.back setBackgroundImage:[UIImage imageNamed:@"backward_new.png"] forState:UIControlStateNormal];
>>>>>>> main
    [self.back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.back];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
<<<<<<< HEAD
    
    //next button
    self.next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.next addTarget:self action:@selector(btn_NextTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithCustomView:self.next];
    self.navigationItem.rightBarButtonItem = NextButton;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    
    
    //flash mode
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![flashLight isTorchAvailable]){
        flashButton.hidden = true;
    }
    
    if([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10 - 30, 300, 50)];
            flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 100, 50)];
        }else {
            flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10 - 30, 100, 50)];
            flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 50)];
        }
        flashButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        flashButton.textColor = [UIColor whiteColor];
        flashButton.textAlignment = NSTextAlignmentLeft;
        flashButton.text = NSLocalizedString(@"OFF",@"");
        flashButton.tag = 1;
        flashButton.userInteractionEnabled=TRUE;
        [self.imageforcapture addSubview:flashButton];
        
        // flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 30)];
        flashLabel.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        flashLabel.textColor = [UIColor whiteColor];
        flashLabel.textAlignment = NSTextAlignmentCenter;
        flashLabel.text = NSLocalizedString(@"Flash Mode:",@"");
        
        [self.imageforcapture addSubview:flashLabel];
        [self.imageforcapture bringSubviewToFront:flashButton];
        [self.imageforcapture bringSubviewToFront:flashLabel];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashToggle:)];
        [flashButton addGestureRecognizer:recognizer];
        [flashLabel setLineBreakMode: NSLineBreakByClipping];
    }
    //flash mode
    
    //Corner radius for button
    self.btn_reset.layer.cornerRadius = 10;
    self.btn_reset.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:189/255.0 alpha:1.0].CGColor;
    self.btn_Logout.layer.cornerRadius = 10;
    self.btn_Logout.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    self.Labelsteps.layer.borderColor = [UIColor blackColor].CGColor;
    self.Labelsteps.layer.borderWidth = 1;
    self.Labelsteps.layer.cornerRadius = 10;
    [self.Labelsteps sizeToFit];
    self.Labelsteps.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
    NSLog(@"%f",self.LabelstepsView.frame.size.width);
    
    self.btn_TakePhoto.layer.cornerRadius = 10;
    self.btn_TakePhoto.backgroundColor = UIColor.whiteColor;
    self.btn_TakePhoto.tintColor = UIColor.blackColor;
    self.videoBtn.tintColor = UIColor.whiteColor;
    [self.imgBtn setHidden:YES];
    [self.startvideoBtn setHidden:YES];
    [self.progressBar setHidden:YES];
    [self.progressView setHidden:YES];
    [self.innervideoBtn setHidden:YES];
    [self.timeLbl setHidden:YES];
    [self.progressBar setUserInteractionEnabled:NO];
    if([PlanName isEqualToString:@"Silver"] || [PlanName isEqualToString:@"Bronze"]){
        [self.bottomView setHidden:YES];
        [self.btn_TakePhoto setHidden:YES];
        [self.videoBtn setHidden:YES];
=======
    // Remove the right navigation bar button
    self.navigationItem.rightBarButtonItem = nil;
    
    // Create UIImageView instance
    UIImageView *DefaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,100,80,120)];
    // Set the image programmatically
    UIImage *image = [UIImage imageNamed:@"Test.png"];
    DefaultImage.image = image;
    // Assign the image to the capturedImage property
       self.capturedImage = image;
    // Add the UIImageView to your view hierarchy
    [self.view addSubview:DefaultImage];
    // Hide the UIImageView
    DefaultImage.hidden = YES;
    
    //Set StatusBar color
//    if (@available(iOS 13.0, *)) {
//        UIView *statusBarBackgroundView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
//        statusBarBackgroundView.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
//        [[UIApplication sharedApplication].keyWindow addSubview:statusBarBackgroundView];
//    } else {
//        // Fallback on earlier versions
//    }
    self.FlashButton.hidden = YES;

        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
        
        //flash mode
        AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (![flashLight isTorchAvailable]){
            //self.FlashButton.hidden = true;
        }
        
        if([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10 - 30, 300, 50)];
                flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 100, 50)];
            }else {
                flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10 - 30, 100, 50)];
                flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 50)];
            }
            flashButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
            flashButton.textColor = [UIColor whiteColor];
            flashButton.textAlignment = NSTextAlignmentLeft;
            flashButton.text = NSLocalizedString(@"OFF",@"");
            flashButton.tag = 1;
            flashButton.userInteractionEnabled=TRUE;
            [self.imageforcapture addSubview:flashButton];
            
           // flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 30)];
            flashLabel.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
            flashLabel.textColor = [UIColor whiteColor];
            flashLabel.textAlignment = NSTextAlignmentCenter;
            flashLabel.text = NSLocalizedString(@"Flash Mode:",@"");
            
            [self.imageforcapture addSubview:flashLabel];
            [self.imageforcapture bringSubviewToFront:flashButton];
            [self.imageforcapture bringSubviewToFront:flashLabel];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashToggle:)];
            [flashButton addGestureRecognizer:recognizer];
            [flashLabel setLineBreakMode: NSLineBreakByClipping];
        }
        //flash mode
        
        //Corner radius for button
    
        //self.LabelstepsView.layer.cornerRadius = 10;
        self.LabelstepsView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:189/255.0 alpha:1.0].CGColor;
        [self.Labelsteps sizeToFit];
        self.LabelstepsView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
        NSLog(@"%f",self.LabelstepsView.frame.size.width);
      
    //eye anim
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.ViewButton addSubview:imageView];
    imageView.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"eye_opened.png"],
                                [UIImage imageNamed:@"eye_closed.png"],
                                nil];
    
    imageView.animationDuration = 2.0f;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
    
        self.btn_TakePhoto.layer.cornerRadius = 10;
        self.btn_TakePhoto.backgroundColor = UIColor.whiteColor;
        self.btn_TakePhoto.tintColor = UIColor.blackColor;
        self.videoBtn.tintColor = UIColor.whiteColor;
>>>>>>> main
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.innervideoBtn setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.progressBar setUserInteractionEnabled:NO];
<<<<<<< HEAD
    }
    [self.bottomView setHidden:YES];
    self.navigationItem.hidesBackButton = NO;
    [self configureToCapturePhoto];
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
    } else if(authStatus == AVAuthorizationStatusDenied){
        // denied
        dispatch_async(dispatch_get_main_queue(), ^{
            [self camDenied];
        });
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        [self.navigationController popViewControllerAnimated:YES];
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
    
    //FreeTier-SUresh
    if([self.siteData.planname isEqual:@"FreeTier"]){
        if (uploadCount >= 100) {
            uploadCount = 100;
        }else if(uploadCount>0){
            
        }else if(uploadCount==0 && self.siteData.RemainingVideocount>0){
            int a=self.siteData.RemainingVideocount;
            uploadCount= a;
        }else{
            [self.view makeToast:NSLocalizedString(@"Maximum Limit for Uploading Mediafiles is Reached, Kindly Upgrade This Site to Continue.",@"") duration:3.0 position:CSToastPositionCenter];
        }
    }
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
    
    //ZoomFeature
    NSString *model=[UIDevice currentDevice].model;
    [zoomlbl setHidden:FALSE];
    [_zoomSlider setHidden:FALSE];
    //[_zoomSlider setBackgroundColor:[UIColor whiteColor]];
    [_zoomSlider addTarget:self action:@selector(scaleOfview:) forControlEvents:UIControlEventValueChanged];
=======
        if([PlanName isEqualToString:@"Silver"] || [PlanName isEqualToString:@"Bronze"]){
            [self.bottomView setHidden:YES];
            [self.btn_TakePhoto setHidden:YES];
            [self.videoBtn setHidden:YES];
            [self.imgBtn setHidden:YES];
            [self.startvideoBtn setHidden:YES];
            [self.progressBar setHidden:YES];
            [self.progressView setHidden:YES];
            [self.innervideoBtn setHidden:YES];
            [self.timeLbl setHidden:YES];
            [self.progressBar setUserInteractionEnabled:NO];
        }
        [self.bottomView setHidden:YES];
        self.navigationItem.hidesBackButton = NO;
        [self configureToCapturePhoto];
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
            dispatch_async(dispatch_get_main_queue(), ^{
                [self camDenied];
            });
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
            [self.navigationController popViewControllerAnimated:YES];
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
        }
        
        //FreeTier-SUresh
        if([self.siteData.planname isEqual:@"FreeTier"]){
            if (uploadCount >= 100) {
                uploadCount = 100;
            }else if(uploadCount>0){
                
            }else if(uploadCount==0 && self.siteData.RemainingVideocount>0){
                int a=self.siteData.RemainingVideocount;
                uploadCount= a;
            }else{
                [self.view makeToast:NSLocalizedString(@"Maximum Limit for Uploading Mediafiles is Reached, Kindly Upgrade This Site to Continue.",@"") duration:3.0 position:CSToastPositionCenter];
            }
        }
        _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
        
        //ZoomFeature
        NSString *model=[UIDevice currentDevice].model;
        [zoomlbl setHidden:FALSE];
        [_zoomSlider setHidden:FALSE];
        //[_zoomSlider setBackgroundColor:[UIColor whiteColor]];
    [_zoomSlider addTarget:self action:@selector(scaleOfview:) forControlEvents:UIControlEventValueChanged];

    // Remove the rotation transformation
    _zoomSlider.transform = CGAffineTransformIdentity;
    //_zoomSlider.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians


    // Update frame based on orientation and device type
//    CGFloat sliderWidth = 180;
//    CGFloat sliderHeight = 14;
//    CGFloat sliderX = CGRectGetMidX(previewLayer.bounds) - (sliderWidth / 2);
//    CGFloat sliderY = previewLayer.bounds.size.height - 10;
//    _zoomSlider.frame = CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight);
//
//    // Update minimum and maximum values
//    [_zoomSlider setMinimumValue:1];
//    [_zoomSlider setMaximumValue:4];
//
//    // Update label frame
//    CGFloat labelWidth = 50;
//    CGFloat labelHeight = 30;
//    CGFloat labelX = sliderX;
//    CGFloat labelY = CGRectGetMaxY(_zoomSlider.frame) + 5;
//    
//    zoomlbl = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
 
>>>>>>> main
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    
    _zoomSlider.transform = trans;
    if ([model isEqualToString:@"iPhone"]){
<<<<<<< HEAD
        
        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.80), (previewLayer.frame.size.height*0.25), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
        
    }else if([model isEqualToString:@"iPad"]){
        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.85), (previewLayer.frame.size.height*0.30), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
    }else{
        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.55), (previewLayer.frame.size.height*0.20), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
    }
    
    [_zoomSlider setMinimumValue:1];
    [_zoomSlider setMaximumValue:4];
    
=======

        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.80), (previewLayer.frame.size.height*0.50), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.40));
        
    }else if([model isEqualToString:@"iPad"]){
        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.85), (previewLayer.frame.size.height*0.70), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.40));
    }else{
        _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.55), (previewLayer.frame.size.height*0.20), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.40));
    }

    [_zoomSlider setMinimumValue:1];
    [_zoomSlider setMaximumValue:4];
   
>>>>>>> main
    CGFloat c = _zoomSlider.frame.origin.y + _zoomSlider.frame.size.height;
    CGFloat d = _zoomSlider.frame.size.width/2;
    zoomlbl =[[UILabel alloc] initWithFrame:CGRectMake(_zoomSlider.frame.origin.x + d - 25,c, 50,30)];
    zoomlbl.adjustsFontSizeToFitWidth = YES;
<<<<<<< HEAD
    zoomlbl.text = @"1.0 x";
    [zoomlbl setTextColor:paleBlue];
    [self.imageforcapture addSubview:zoomlbl];
    [self.imageforcapture bringSubviewToFront:zoomlbl];
    [self.imageforcapture bringSubviewToFront:_zoomSlider];
    
    if(self.siteData.addon_gallery_mode.boolValue==TRUE)
        [self.btn_Logout setImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
    else
        [self.btn_Logout setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    //    if(self.siteData.images_error_type != NULL){
    //        checkBlur = self.siteData.images_error_type;
    //          //[self.view makeToast:checkBlur duration:2.0 position:CSToastPositionCenter];
    //      }
    //NSString *slat =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
    NSString *slan =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
    timeZone =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneName"];
    
    
    //screen orientation change detection
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.isDeviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.1; // Set the update interval as needed
        [self.motionManager startDeviceMotionUpdates];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self handleDeviceMotionUpdate:motion];
        }];
    }
    // top constraint for imageView relative to collectionView
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.DefaultImage
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.collection_View
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:15];
    
    // bottom constraint for imageView relative to collectionView
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.DefaultImage
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.collection_View
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    
    // Activate constraints
    [NSLayoutConstraint activateConstraints:@[topConstraint, bottomConstraint]];
   
  
}

- (void)handleDeviceMotionUpdate:(CMDeviceMotion *)motion {
    double x = motion.gravity.x;
    double y = motion.gravity.y;
    
=======
    
    zoomlbl.text = @"1.0 x";
    [zoomlbl setTextColor:paleBlue];
    [self.view addSubview:zoomlbl];
    [self.view addSubview:_zoomSlider];
    [self.view bringSubviewToFront:zoomlbl];
    [self.view bringSubviewToFront:_zoomSlider];

        
        if(self.siteData.addon_gallery_mode.boolValue==TRUE)
            [self.btn_Logout setImage:[UIImage imageNamed:@"gallery_new.png"] forState:UIControlStateNormal];
        else
            [self.btn_Logout setImage:[UIImage imageNamed:@"logout_new.png"] forState:UIControlStateNormal];
        //    if(self.siteData.images_error_type != NULL){
        //        checkBlur = self.siteData.images_error_type;
        //          //[self.view makeToast:checkBlur duration:2.0 position:CSToastPositionCenter];
        //      }
    //NSString *slat =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
    NSString *slan = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
    timeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneName"];
  /*  zoomlbl.adjustsFontSizeToFitWidth = YES;
    zoomlbl.text = @"1.0 x";
    [zoomlbl setTextColor:paleBlue];*/
    
    //screen orientation change detection
    self.motionManager = [[CMMotionManager alloc] init];
        if (self.motionManager.isDeviceMotionAvailable) {
            self.motionManager.deviceMotionUpdateInterval = 0.1; // Set the update interval as needed
            [self.motionManager startDeviceMotionUpdates];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
                [self handleDeviceMotionUpdate:motion];
            }];
        }
    self.Labelsteps.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];

    
}


- (void)handleDeviceMotionUpdate:(CMDeviceMotion *)motion {
    double x = motion.gravity.x;
    double y = motion.gravity.y;

>>>>>>> main
    // Determine the device orientation based on the gravity values
    if (fabs(y) >= fabs(x)) {
        if (y >= 0.0) {
            // Device is in portrait orientation
            NSLog(@"Portrait");
            captureOrientation = 0;
        } else {
            // Device is in portrait upside-down orientation
            NSLog(@"Portrait Upside Down");
            captureOrientation = 0;
        }
    } else {
        if (x >= 0.0) {
            // Device is in landscape right orientation
            NSLog(@"Landscape Right");
            captureOrientation = 270;
        } else {
            // Device is in landscape left orientation
            NSLog(@"Landscape Left");
            captureOrientation = 90;
        }
    }
}

-(void) checkTimeZone{
    if(timeZone != nil){
        NSLog(@"timezone avail");
    }else {
        NSString *slat = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
        NSString *slan = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
        timeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneName"];
        if(slat != nil){
            if(timeZone != nil){
                NSLog(@"%@", timeZone);
            }else {
                if([slat doubleValue] > 0){
                    [self getTimeZone:[slat doubleValue] withsecond:[slan doubleValue]];
                }
            }
        }else {
            if(latitude != nil){
                if([latitude doubleValue] > 0){
                    [self getTimeZone:[latitude doubleValue] withsecond:[longitude doubleValue]];
                }
            }
        }
    }
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
                self->timeZone = name;
                //NSString *timeZone =  [timeZoneObj objectForKey:@"abbreviation_STD"];
<<<<<<< HEAD
                //                [self.view makeToast:name duration:2.0 position:CSToastPositionCenter];
=======
//                [self.view makeToast:name duration:2.0 position:CSToastPositionCenter];
>>>>>>> main
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"timeZoneName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
}

-(void)proceed{
    if(self.myimagearray.count != 0){
        [tempImgarr removeAllObjects];
        [tempImgarr addObjectsFromArray:self.myimagearray];
        [self.ArrayofstepPhoto addObjectsFromArray: self.myimagearray];
        [self.myimagearray removeAllObjects];
        [self.collection_View reloadData];
        NSLog(@"wholeStepsCount:%d",self.wholeStepsCount);
    }
}


-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
            [((UIButton *)button) setExclusiveTouch:NO];
        else if ([button isKindOfClass:[UIView class]]){
            [self setExclusiveTouchForButtons:nil];
        }
    }
}

-(IBAction)scaleOfview:(id)sender
{
    //ZoomFeature
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    
    if ([inputDevice lockForConfiguration:&error]) {
        inputDevice.videoZoomFactor = MAX(1.0, MIN(_zoomSlider.value, inputDevice.activeFormat.videoMaxZoomFactor));
        [inputDevice unlockForConfiguration];
        zoomlbl.text =[NSString stringWithFormat: @"%.2f x",MAX(1.0, MIN(_zoomSlider.value, inputDevice.activeFormat.videoMaxZoomFactor))];
        NSLog(@"zoom value: %f",MAX(1.0, MIN(_zoomSlider.value, inputDevice.activeFormat.videoMaxZoomFactor)));
    }
    
}

-(void)back_button:(id)sender {
<<<<<<< HEAD
=======
    
>>>>>>> main
    self.back.enabled = NO;
    NSDictionary*dict;
    NSMutableArray *checkArr = [self.parkLoad objectForKey:@"img"];
    if(checkArr != nil && checkArr.count>0){
        for(int i=0; i<checkArr.count; i++){
            dict = [checkArr objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;;
            }
        }
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            self.back.enabled = YES;
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
            return;
        }
    }
    bool isAddon7Custom = [[self.parkLoad objectForKey:@"isAddon7Custom"]boolValue];
    NSArray * arr = [self.parkLoad objectForKey:@"img"];
<<<<<<< HEAD
    
=======

>>>>>>> main
    if(isAddon7Custom){
        if([[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            [self backBtn_customGPCC ];
        }else{
            self.back.enabled = YES;
            if(arr.count > 0){
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
                // break;
            }else{
                [self backBtn_customGPCC];
            }
        }
    }else{
        if([[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
            for(NSUInteger i = array.count - 1;i>=0;i--) {
                NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
                    [self.navigationController popToViewController:array[i] animated:true];
                    break;
                }else{
                    LoadSelectionViewController *LoadVc= [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
<<<<<<< HEAD
                    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
                    LoadVc.siteData = self.siteData;
                    //sitevc.movetolc=YES;
                    [navigationArray removeAllObjects];
                    [navigationArray addObject:LoadVc];
                    self.navigationController.viewControllers = navigationArray;
                    [self.navigationController popToViewController:LoadVc animated:true];
                    break;
                    // }
=======
                        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
                        LoadVc.siteData = self.siteData;
                        //sitevc.movetolc=YES;
                        [navigationArray removeAllObjects];
                        [navigationArray addObject:LoadVc];
                        self.navigationController.viewControllers = navigationArray;
                        [self.navigationController popToViewController:LoadVc animated:true];
                        break;
                   // }
>>>>>>> main
                }
            }
        }else{
            if (self.ArrayofstepPhoto.count > 0 || self.myimagearray.count > 0){
                self.back.enabled = YES;
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
                
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
            }else{
                [self.parkLoadArray removeObjectAtIndex:currentLoadNumber];
                [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
                for(NSUInteger i = array.count - 1; i>=0 ; i--) {
                    NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                    if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
                        
                        [self.navigationController popToViewController:array[i] animated:true];
                        break;
                    }else{
                        LoadSelectionViewController *LoadVc= [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
                        LoadVc.siteData = self.siteData;
                        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
                        
                        //LoadVc.movetolc=YES;
                        [navigationArray removeAllObjects];
                        [navigationArray addObject:LoadVc];
                        self.navigationController.viewControllers = navigationArray;
                        
                        [self.navigationController popToViewController:LoadVc animated:true];
                        break;
                    }
                }
            }
        }
    }
}
-(void)backBtn_customGPCC{
    
    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
    NSString *ifCatAvailable = @"";
    //for(NSUInteger i = array.count - 1;i>=0;i--) {
    for(int i = 0; i<array.count;i++){
        NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
        if([array[i] isKindOfClass:CategoryViewController.class]) {
            ifCatAvailable = @"Yes";
            [self.navigationController popToViewController:array[i] animated:true];
            break;
        }
    }
    if([ifCatAvailable isEqualToString:@"Yes"]){
<<<<<<< HEAD
        // [self.navigationController popViewControllerAnimated:YES];
=======
       // [self.navigationController popViewControllerAnimated:YES];
>>>>>>> main
    }else{
        CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
        Category.siteData = self.siteData;
        Category.sitename = self.siteName;
        Category.image_quality = self.siteData.image_quality;
        delegateVC.ImageTapcount = 0;
        delegateVC.isNoEdit = YES;
        
        [[NSUserDefaults standardUserDefaults] setInteger:currentLoadNumber forKey: @"CurrentLoadNumber"];
        [self.parkLoad setValue:@"true" forKey:@"isAddon7Custom"];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:Category animated:YES];
    }
}

-(IBAction)deleteLoad:(id)sender{
    [self.alertbox hideView];
    
    [self.parkLoadArray removeObjectAtIndex:currentLoadNumber];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
<<<<<<< HEAD
    
=======

>>>>>>> main
    //[self.navigationController popViewControllerAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AZCAppDelegate *delegate = AZCAppDelegate.sharedInstance;
        [delegate.window makeToast:NSLocalizedString(@"Images Deleted Successfully",@"")  duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
    });
    
    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
    for(NSUInteger i = array.count - 1; i>=0 ; i--) {
        NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
        if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
            
            [self.navigationController popToViewController:array[i] animated:true];
            break;
        } else {
            SiteViewController *sitevc= [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            
            sitevc.movetolc=YES;
            [navigationArray removeAllObjects];
            [navigationArray addObject:sitevc];
            self.navigationController.viewControllers = navigationArray;
            
            [self.navigationController popToViewController:sitevc animated:true];
            break;
        }
    }
}
<<<<<<< HEAD

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // Format the current date time to match the format of
    // the photo's metadata timestamp string
=======
    
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
        // Format the current date time to match the format of
        // the photo's metadata timestamp string
>>>>>>> main
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"location string:%@",stringFromDate);
<<<<<<< HEAD
    // Add the location as a value in the location NSMutableDictionary
    // while using the formatted current datetime as its key
    // _location = stringFromDate;
=======
        // Add the location as a value in the location NSMutableDictionary
        // while using the formatted current datetime as its key
        // _location = stringFromDate;
>>>>>>> main
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    if(latitude.length == 0)
    {
        latitude = @"0.0000000";
    }
    if(longitude.length == 0)
    {
        longitude = @"0.0000000";
    }
    if(![latitude isEqual:@"0.0000000"]){
        [self checkTimeZone];
    }
    NSLog(@"latitude:%@",latitude);
    NSLog(@"longitude:%@",longitude);
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

-(void)handleTimer {
<<<<<<< HEAD
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
=======
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
   
>>>>>>> main
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(210,12,16,16)];
=======
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(30,12,16,16)];
    } else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,10,20,20)];
        }else {
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,12,15,15)];
        }
>>>>>>> main
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(225,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(-10,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,0, 175, 40)];
=======
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(220,3,35,32)];
    } else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 95,8,25,25)];
        }else {
            cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 95,8,20,20)];
        }
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 0, 169, 40)];
    }else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw/2 - 160,0, 200, 40)];
    }
>>>>>>> main
    titleLabel.text = self.siteName;
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
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
<<<<<<< HEAD
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
=======
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 195,8,25,25)];
        }else {
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 195,8,20,20)];
        }
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_new.png"]  forState:UIControlStateNormal];
    parkloadIcon.layer.masksToBounds = YES;
    
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
        [networkStater setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
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
    //parkload icon
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && self.parkLoadArray.count == 1){
        parkloadIcon.hidden = YES;
    }
}
/*-(void)handleTimer {
    
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(30,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(210,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(220,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(230,8,25,25)];
>>>>>>> main
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
    parkloadIcon.layer.masksToBounds = YES;
    
<<<<<<< HEAD
=======
    UILabel* titleLabel;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 169, 40)];
    }else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 170, 40)];
    }
    titleLabel.text = [self.siteName stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 255, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
>>>>>>> main
    //internet_indicator
    bool isOrange = false;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        isOrange = false;
        [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
<<<<<<< HEAD
        //RGBA ( 0 , 229 , 8 , 100)
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        //RGBA ( 0 , 174 , 7 , 100 )
=======
            //RGBA ( 0 , 229 , 8 , 100)
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
            //RGBA ( 0 , 174 , 7 , 100 )
>>>>>>> main
        NSLog(@"Network Connection available");
    }else{
        isOrange = true;
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
<<<<<<< HEAD
        //RGBA ( 248 , 181 , 82 , 80 )
=======
            //RGBA ( 248 , 181 , 82 , 80 )
>>>>>>> main
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
    //parkload icon
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && self.parkLoadArray.count == 1){
        parkloadIcon.hidden = YES;
    }
<<<<<<< HEAD
}
=======
}*/
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
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
<<<<<<< HEAD
    [self handleTimer];
=======
        [self handleTimer];
>>>>>>> main
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


-(void) parkload_poper{
<<<<<<< HEAD
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    
=======

     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
     [self.alertbox setHorizontalButtons:YES];
     
>>>>>>> main
    long a = self.parkLoadArray.count;
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
        a--;
    }
<<<<<<< HEAD
    NSString *stat = @(a).stringValue;
    NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox setHideTitle:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
}
=======
     NSString *stat = @(a).stringValue;
     NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
     
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox setHideTitle:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
 }
>>>>>>> main

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)viewWillAppear:(BOOL)animated {
    self.back.enabled = YES;
    tempImgarr = [[NSMutableArray alloc]init];
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    if([self.parkLoad valueForKey:@"img"] != Nil){
        self.ArrayofstepPhoto = [[self.parkLoad valueForKey:@"img"]mutableCopy];
        
    }
    if(self.ArrayofstepPhoto == nil){
        self.ArrayofstepPhoto = [[NSMutableArray alloc]init];
    }
<<<<<<< HEAD
    
    //if(imagepick == FALSE){
    [self Instruc];
=======

    //if(imagepick == FALSE){
      [self Instruc];
>>>>>>> main
    //}
    if((self.alertbox == nil) || (![self.alertbox isVisible]))
    {
        NSString *name;
        for (NSDictionary *dic in self.myimagearray) {
<<<<<<< HEAD
            name = [dic valueForKey:@"imageName"];
=======
          name = [dic valueForKey:@"imageName"];
>>>>>>> main
        }
        if(pickimage == FALSE && self.selectedTab == nil && ![[self.parkLoad valueForKey:@"isParked"] isEqualToString:@"1"]){
            if(self.myimagearray.count != 0 || (self.ArrayofstepPhoto.count != 0)){
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(reset_tapped) backgroundColor:Red];
                [self.alertbox addButton:NSLocalizedString(@"Proceed",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking Proceed button will Continue in Current load",@"") closeButtonTitle:nil duration:1.0f ];
            }
        }
    }
    //imagepick = false;
    pickimage = false;
<<<<<<< HEAD
    
    NSLog(@"myimagearray:%@",self.myimagearray);
    NSLog(@"self.myimagearray.count:%lu",(unsigned long)self.myimagearray.count);
    
=======

    NSLog(@"myimagearray:%@",self.myimagearray);
    NSLog(@"self.myimagearray.count:%lu",(unsigned long)self.myimagearray.count);

>>>>>>> main
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"CameraVC";
    [[NSUserDefaults standardUserDefaults] setValue:@"CameraVC" forKey:@"CurrentVC"];
    for (NSDictionary *dic in self.myimagearray) {
        NSString *name = [dic valueForKey:@"imageName"];
        NSString* Path1= [pathToImageFolder stringByAppendingPathComponent:name];
        if(![[NSFileManager defaultManager] fileExistsAtPath:Path1]){
            [self.myimagearray removeObject:dic];
        }
    }
    [super viewWillAppear:animated];
<<<<<<< HEAD
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
    [self handleTimer];
=======
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
>>>>>>> main
    //}
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.collection_View reloadData];
    NSLog(@"%f",self.view.frame.size.height * 0.09);
    if(self.startvideoBtn.isHidden == YES){
        if(delegate.isEnterForegroundCamera == YES )
        {
            delegate.isEnterForegroundCamera = NO;
            [self.view makeToast: NSLocalizedString(@"Tap to Take Pictures",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
        }
    }
    if(self.startvideoBtn.isHidden == NO){
        if(delegate.isEnterForegroundVideo == YES )
        {
            delegate.isEnterForegroundVideo = NO;
            [self.view makeToast:  NSLocalizedString(@"Tap On Video Icon To Record",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
        }
    }
    [self addRoundedIconWithBorder ];
    [zoomlbl setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
    [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
<<<<<<< HEAD
    //    [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    //    [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
        [flashLabel setHidden:NO];
        [flashButton setHidden:NO];
=======
//    [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
//    [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
        [self.FlashButton setHidden:NO];
>>>>>>> main
    }
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
}

-(void)viewDidLayoutSubviews{
    
    if(self.selectedTab != nil && self.ArrayofstepPhoto.count -1 >= self.selectedTab.errorIndex){
        
        NSLog(@"self.ArrayofstepPhoto.count :%lu",(unsigned long)self.ArrayofstepPhoto.count);
        NSLog(@"self.selectedTab.indexPath:%d",self.selectedTab.indexPath );
        NSLog(@"self.selectedTab.errorIndex :%d",self.selectedTab.errorIndex );
        
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = [self.ArrayofstepPhoto objectAtIndex:self.selectedTab.errorIndex];
        NSString * str = [dict objectForKey:@"imageName"];
        if([str isEqualToString: @""]){
            if((self.InstructCount - 1 == self.selectedTab.indexPath  || self.selectedTab.indexPath == 5)){
                NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.selectedTab.indexPath  inSection:section];
                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }else{
                NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.selectedTab.indexPath + 1  inSection:section];
                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

//multi_img_picker
-(void)getSelectedPhoto:(NSMutableArray *)aryPhoto
{
    [locationManager startUpdatingLocation];
    @try{
        //Initlize array
        _arrImage = nil;
        _arrImage = [NSMutableArray new];
        _arrImage = [aryPhoto mutableCopy]; //mainImage, Asset, selected
        NSLog(@"info:%@",_arrImage);
        
        int pos = 0;
        NSString* imagePath;
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = true;
        for (NSDictionary *dict in _arrImage)
        {
            @autoreleasepool {
                //size_conversion
                self.tapCount ++;
                pos ++;
                UIImage *chosenImage = [dict valueForKey:@"mainImage"];
                NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                
                NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                NSString *UDID = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"];
                NSString* imageName = [NSString stringWithFormat:@"%@_%@_%d.jpg",UDID,epochTime,pos];
                imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
                if (![self.siteData.image_quality isEqual:@"4"]) {
                    
                    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
                    CGImageRef takenCGImage = chosenImage.CGImage;
                    size_t width = CGImageGetWidth(takenCGImage);
                    size_t height = CGImageGetHeight(takenCGImage);
                    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                    chosenImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:chosenImage.imageOrientation];
                    CGImageRelease(cropCGImage);
                    UIGraphicsBeginImageContext(chosenImage.size);
                    [chosenImage drawAtPoint:CGPointZero];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    //REducing the captured image size
                    CGSize imageSize;
                    NSLog(@"Image Quality :%@",self.siteData.image_quality);
                    if ([self.siteData.image_quality isEqual:@"1"]) {
                        imageSize = CGSizeMake(720,1080);
                    }else{
                        imageSize = CGSizeMake(1440,2160);
                    }
                    UIGraphicsBeginImageContext(imageSize);
                    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    [UIImageJPEGRepresentation(chosenImage,1) writeToFile:imagePath atomically:true];
                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
                    //int epochTimeInt = [epochTime intValue];
                    int epochTimeInt = [epochTime intValue] + pos;
                    NSNumber * newTime = [NSNumber numberWithInt:epochTimeInt];
                    [myimagedict setObject:imageName forKey:@"imageName"];
                    [myimagedict setObject:newTime forKey:@"created_Epoch_Time"];
                    [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
                    [myimagedict setObject:latitude forKey:@"latitude"];
                    [myimagedict setObject:longitude forKey:@"longitude"];
                    
                    //NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                    NSString *islowlight=@"FALSE";
                    [myimagedict setObject:islowlight forKey:@"brightness"];
                    [myimagedict setObject:@"FALSE" forKey:@"variance"];
                    if(self.selectedTab != nil){
                        [self.myimagearray replaceObjectAtIndex:self.selectedTab.errorIndex withObject:myimagedict];
                        [self.ArrayofstepPhoto replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                    }else{
                        [self.myimagearray addObject:myimagedict];
                        [self.ArrayofstepPhoto addObject:myimagedict];
                    }
<<<<<<< HEAD
                    //                    NSLog(@" the taken photo is:%@",self.myimagearray);
=======
//                    NSLog(@" the taken photo is:%@",self.myimagearray);
>>>>>>> main
                }else {
                    PHAsset *asset = dict[@"assest"];
                    PHImageManager *manager = [PHImageManager defaultManager];
                    [manager requestImageDataForAsset:asset
<<<<<<< HEAD
                                              options:requestOptions
                                        resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
                     {
=======
                                                                  options:requestOptions
                                                            resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
                                         {
>>>>>>> main
                        CGImageSourceRef imgSrc = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
                        NSString *uti = (NSString*)CGImageSourceGetType(imgSrc);
                        if([uti containsString:@"heif"] || [uti containsString:@"hevc"] || [uti containsString:@"heic"]
                           || [uti containsString:@"HEIF"] || [uti containsString:@"HEVC"] || [uti containsString:@"HEIC"]){
                            UIImage *image = [UIImage imageWithData:imageData];
                            NSData *jpegImageData = UIImageJPEGRepresentation(image, 0.8);
                            [jpegImageData writeToFile:imagePath atomically:true];
<<<<<<< HEAD
                            //                            NSLog(@"SizeofImagehevc(bytes):%lu",(unsigned long)[jpegImageData length]);
                        }else {
                            //                            NSLog(@"SizeofImagejpeg(bytes):%lu",(unsigned long)[imageData length]);
=======
//                            NSLog(@"SizeofImagehevc(bytes):%lu",(unsigned long)[jpegImageData length]);
                        }else {
//                            NSLog(@"SizeofImagejpeg(bytes):%lu",(unsigned long)[imageData length]);
>>>>>>> main
                            [imageData writeToFile:imagePath atomically:true];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
                        //int epochTimeInt = [epochTime intValue];
                        int epochTimeInt = [epochTime intValue] + pos;
                        NSNumber * newTime = [NSNumber numberWithInt:epochTimeInt];
                        [myimagedict setObject:imageName forKey:@"imageName"];
                        [myimagedict setObject:newTime forKey:@"created_Epoch_Time"];
                        [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
                        [myimagedict setObject:self->latitude forKey:@"latitude"];
                        [myimagedict setObject:self->longitude forKey:@"longitude"];
                        
                        //NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                        NSString *islowlight=@"FALSE";
                        [myimagedict setObject:islowlight forKey:@"brightness"];
                        [myimagedict setObject:@"FALSE" forKey:@"variance"];
                        if(self.selectedTab != nil){
                            [self.myimagearray replaceObjectAtIndex:self.selectedTab.errorIndex withObject:myimagedict];
                            [self.ArrayofstepPhoto replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                        }else{
                            [self.myimagearray addObject:myimagedict];
                            [self.ArrayofstepPhoto addObject:myimagedict];
                        }
                    }];
                }
                
                //reloading the collection view
                [self.collection_View reloadData];
                NSLog(@"my %@",myimagedict);
                imge.picslist = _myimagearray;
                [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"my1 %@",imge.picslist);
                _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
                numberofphotoCapturedforsteps = numberofphotoCapturedforsteps + 1;
                [self.collection_View reloadData];
                if(self.selectedTab != nil){
                    for(int i =0; i<self.ArrayofstepPhoto.count; i++){
                        NSDictionary * newdict = [[NSDictionary alloc]init];
                        newdict = [self.ArrayofstepPhoto objectAtIndex:i];
                        if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]]){
                            if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                                [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.errorIndex]];
                            }
                        }
                    }
                    [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
                    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }else if(numberofphotoCapturedforsteps == TotalNoOfPhoto){
                    
                    [self.view makeToast: NSLocalizedString(@"Tap to Move Next",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
                    // self.next.hidden = false;
                }else{
                    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                    //NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
                    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.myimagearray.count - 1 inSection:section];
                    [self.collection_View reloadData];
                    NSString *model=[UIDevice currentDevice].model;
                    bool needToscroll = FALSE;
                    if ([model isEqualToString:@"iPad"] ) {
                        if(self.myimagearray.count>3){
                            needToscroll = TRUE;
                        }
                    }else{
                        if(self.myimagearray.count>2){
                            needToscroll = TRUE;
                        }
                    }
                    if(needToscroll == TRUE){
<<<<<<< HEAD
                        [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                        //                        if(self.myimagearray.count > 4){
                        //                            // Calculate the content offset to scroll to the end
                        //                            CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
                        //                            // Make sure the contentOffset doesn't go below 0
                        //                            contentOffsetX = MAX(0, contentOffsetX + 150);
                        //                            // Scroll to the calculated content offset
                        //                            [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
                        //                        }
=======
                        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
                        if(![langStr isEqualToString:@"Arabic"] && ![langStr isEqualToString:@"Urdu"]){
                            [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                        }
//                        if(self.myimagearray.count > 4){
//                            // Calculate the content offset to scroll to the end
//                            CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
//                            // Make sure the contentOffset doesn't go below 0
//                            contentOffsetX = MAX(0, contentOffsetX + 150);
//                            // Scroll to the calculated content offset
//                            [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
//                        }
>>>>>>> main
                    }
                }
            }
        }
        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    if(self.selectedTab != nil){
        GalleryViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
        GalleryVC.imageArray = self.ArrayofstepPhoto;
        GalleryVC.siteData = self.siteData;
        GalleryVC.sitename = self.siteName;
        GalleryVC.pathToImageFolder = pathToImageFolder;
        GalleryVC.instructData = [self.parkLoad valueForKey:@"instructData"];
        [self.navigationController pushViewController:GalleryVC animated:YES];
    }
}


-(void) addRoundedIconWithBorder{
    _imgBtn.layer.masksToBounds = YES;
    _innervideoBtn.layer.masksToBounds = YES;
    _startvideoBtn.layer.masksToBounds = YES;
    
    _imgBtn.layer.cornerRadius = 20;
    _innervideoBtn.layer.cornerRadius = 20;
    _startvideoBtn.layer.cornerRadius = 20;
    
    _imgBtn.layer.borderWidth = 1;
    _innervideoBtn.layer.borderWidth = 1;
    _startvideoBtn.layer.borderWidth = 1;
    
    
    _imgBtn.layer.borderColor = [UIColor colorWithRed:193/255.0 green:32/255 blue:32/255 alpha:1.0].CGColor;
    _innervideoBtn.layer.borderColor = [UIColor colorWithRed:193/255.0 green:32/255 blue:32/255 alpha:1.0].CGColor;
    _startvideoBtn.layer.borderColor = [UIColor colorWithRed:193/255.0 green:32/255 blue:32/255 alpha:1.0].CGColor;
<<<<<<< HEAD
    
=======

>>>>>>> main
}

- (void) ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:141/255.0f green:0/255.0f blue:254/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
<<<<<<< HEAD
        [alert dismissViewControllerAnimated:YES completion:^{
=======
    [alert dismissViewControllerAnimated:YES completion:^{
>>>>>>> main
        }];
    });
}

-(void)viewWillDisappear:(BOOL)animated {
<<<<<<< HEAD
=======
    
>>>>>>> main
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.tapCount = 0 ;
        [session stopRunning];
    }
    [self.alertbox hideView];
    [super viewWillDisappear:animated];
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    WeAreRecording = NO;
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
<<<<<<< HEAD
            if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text =NSLocalizedString(@"OFF",@"");
=======
            if(self.FlashButton.tag == 0){
                self.FlashButton.tag=1;
               [self.FlashButton setImage:[UIImage imageNamed:@"flash_new.png"] forState:UIControlStateNormal];

>>>>>>> main
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            [flashLight unlockForConfiguration];
        }
    }
}


-(void) configureToCapturePhoto
{
    session = [[AVCaptureSession alloc]init];
    [session beginConfiguration];
<<<<<<< HEAD
    
=======
   
>>>>>>> main
    avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([avCaptureDevice lockForConfiguration:&error]) {
        //float zoomFactor = avCaptureDevice.activeFormat.videoZoomFactorUpscaleThreshold;
        [avCaptureDevice setVideoZoomFactor:1.0];
        [avCaptureDevice unlockForConfiguration];
    }
    
    //increase camera brightness
    if ([avCaptureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
<<<<<<< HEAD
        NSError *error = nil;
        if ([avCaptureDevice lockForConfiguration:&error]) {
            [avCaptureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [avCaptureDevice setExposureTargetBias:0.5 completionHandler:nil]; // Increase this value to make the image brighter
            [avCaptureDevice unlockForConfiguration];
        } else {
            NSLog(@"Error: %@", error);
        }
    }
=======
          NSError *error = nil;
          if ([avCaptureDevice lockForConfiguration:&error]) {
              [avCaptureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
              [avCaptureDevice setExposureTargetBias:0.5 completionHandler:nil]; // Increase this value to make the image brighter
              [avCaptureDevice unlockForConfiguration];
          } else {
              NSLog(@"Error: %@", error);
          }
      }
>>>>>>> main
    
    [CaptureScreenViewController setFlashMode: AVCaptureFlashModeAuto forDevice:avCaptureDevice];
    //  NSError *error;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:avCaptureDevice error:&error];
    
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResize];
    CALayer *rootLayer = self.imageforcapture.layer;
    [rootLayer setMasksToBounds:YES];
    [_imageforcapture layoutIfNeeded];
<<<<<<< HEAD
    //    @try{
    CGRect frame = _imageforcapture.bounds; //CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height *0.65);//
    //    previewLayer.backgroundColor = [UIColor redColor].CGColor;
    [previewLayer setFrame:frame];
    
=======
//    @try{
    CGRect frame = _imageforcapture.bounds; //CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height *0.65);//
    //    previewLayer.backgroundColor = [UIColor redColor].CGColor;
    [previewLayer setFrame:frame];
 
>>>>>>> main
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    StillImageOutput = [[AVCapturePhotoOutput alloc]init];
    AVCapturePhotoSettings *_avSettings = [AVCapturePhotoSettings photoSettings];
<<<<<<< HEAD
    //    AVCaptureSession* captureSession = [[AVCaptureSession alloc] init];
    //    [captureSession startRunning];
    //        if ([captureSession canAddOutput: StillImageOutput]){
    //            [captureSession addOutput: StillImageOutput];
    //        }
    NSNumber *previewPixelType = _avSettings.availablePreviewPhotoPixelFormatTypes.firstObject;
    
    NSString *formatTypeKey = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSString *widthKey = (NSString *)kCVPixelBufferWidthKey;
    NSString *heightKey = (NSString *)kCVPixelBufferHeightKey;
    if ([self.siteData.image_quality isEqual:@"1"]) {
        NSDictionary *previewFormat = @{formatTypeKey:previewPixelType,
                                        widthKey:@1024,
                                        heightKey:@768
        };
        _avSettings.previewPhotoFormat = previewFormat;
    }else {
        NSDictionary *previewFormat = @{formatTypeKey:previewPixelType,
                                        widthKey:@2160,
                                        heightKey:@1440
        };
        _avSettings.previewPhotoFormat = previewFormat;
    }
    //    NSDictionary *outputSettings =[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //    [StillImageOutput setOutputSettings:outputSettings];
=======
//    AVCaptureSession* captureSession = [[AVCaptureSession alloc] init];
//    [captureSession startRunning];
//        if ([captureSession canAddOutput: StillImageOutput]){
//            [captureSession addOutput: StillImageOutput];
//        }
    NSNumber *previewPixelType = _avSettings.availablePreviewPhotoPixelFormatTypes.firstObject;

    NSString *formatTypeKey = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSString *widthKey = (NSString *)kCVPixelBufferWidthKey;
    NSString *heightKey = (NSString *)kCVPixelBufferHeightKey;
        if ([self.siteData.image_quality isEqual:@"1"]) {
            NSDictionary *previewFormat = @{formatTypeKey:previewPixelType,
                                               widthKey:@1024,
                                               heightKey:@768
                                               };
            _avSettings.previewPhotoFormat = previewFormat;
        }else {
            NSDictionary *previewFormat = @{formatTypeKey:previewPixelType,
                                               widthKey:@2160,
                                               heightKey:@1440
                                               };
            _avSettings.previewPhotoFormat = previewFormat;
        }
//    NSDictionary *outputSettings =[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
//    [StillImageOutput setOutputSettings:outputSettings];
>>>>>>> main
    
    
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 100;            //Total seconds
    int32_t preferredTimeScale = 1;    //Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);    //<<SET MAX DURATION//
    MovieFileOutput.maxRecordedDuration = maxDuration;
<<<<<<< HEAD
    
    //    } @catch (NSException *exception) {
    //        NSLog(@"%@", exception.description);
    //    }
=======
        
//    } @catch (NSException *exception) {
//        NSLog(@"%@", exception.description);
//    }
>>>>>>> main
    
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;                        //<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
    // AVCaptureVideoOrientation
    [session addOutput:StillImageOutput];
    if ([session canAddOutput:MovieFileOutput])
        [session addOutput:MovieFileOutput];
    [session commitConfiguration];
    // Add the photo output to the capture session
    if ([session canAddOutput:StillImageOutput]) {
        [session addOutput:StillImageOutput];
    }
    // Start the capture session
    [session startRunning];
    // Audio setting
    
    audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [session startRunning];
}

#pragma mark - Notification

#pragma mark - Collection View Delagate Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView :(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count = self.InstructCount;
    return count;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth;
    
    cellWidth =  self.collection_View.frame.size.height;
    return CGSizeMake(cellWidth, cellWidth);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    bool isEmpty = false;
    for(int i = 0; i<self.myimagearray.count; i++){
        NSDictionary *adict =[self.myimagearray objectAtIndex:i];
        NSString* imageName = [adict valueForKey: @"imageName"];
        if([imageName isEqualToString:@""]){
            isEmpty = true;
            break;
        }
    }
    CollectionViewCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.myimagearray.count == 0) {
        
        Cell.image_View.image = [UIImage imageNamed:@"Placeholder.png"];
        Cell.waterMark_lbl.text = @"";
        [Cell.delete_btn setHidden:YES];
        [Cell.videoicon setHidden:YES];
        [Cell.low_light setHidden:YES];
        [Cell.blur_img setHidden:YES];
<<<<<<< HEAD
        
=======
        [Cell.waterMark_lbl setHidden:YES];
>>>>>>> main
    }else{
        if (self.myimagearray.count < indexPath.row + 1){
            Cell.image_View.image = [UIImage imageNamed:@"Placeholder.png"];
            Cell.waterMark_lbl.text = @"";
            [Cell.delete_btn setHidden:YES];
            [Cell.videoicon setHidden:YES];
            [Cell.low_light setHidden:YES];
            [Cell.blur_img setHidden:YES];
<<<<<<< HEAD
=======
            [Cell.waterMark_lbl setHidden:YES];
>>>>>>> main
        }else{
            
            NSDictionary *adict =[self.myimagearray objectAtIndex:indexPath.row];
            NSString* imageName = [adict valueForKey: @"imageName"];
            if([[adict valueForKey: @"imageName"] isEqual: @""]){
                Cell.image_View.image =[UIImage imageNamed:@"missing_img.png"];
            }
            if(!isEmpty){
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
                if([extentionArray[1] isEqualToString:@"mp4"])
                {
                    NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
                    UIImage* image = [self generateThumbImage : path];
                    if(image != nil)
                    {
                        Cell.image_View.image = image;
                    }
                    else{
                        Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
                    }
                    [Cell.blur_img setHidden:YES];
                    [Cell.low_light setHidden:YES];
                    [Cell.videoicon setHidden:NO];
                    if([[adict valueForKey: @"imageName"] isEqual: @""]){
                        [Cell.delete_btn setHidden:YES];
                        [Cell.videoicon setHidden:YES];
                    }else{
                        [Cell.delete_btn setHidden:NO];
                        [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                        [Cell.delete_btn setTag:indexPath.row];
                    }
                }else{
                    
                    //lowLight
                    NSString* IsLowLight = [adict valueForKey:@"brightness"];
                    if ([IsLowLight isEqualToString:@"FALSE"]) {
                        [Cell.low_light setHidden:YES];
                    }else{
                        if(cameraboolToRestrict == FALSE){
                            [Cell.low_light setHidden:NO];
                        }else{
                            [Cell.low_light setHidden:YES];
                        }
                    }
                    
                    //blur_img
                    NSString* variance = [adict valueForKey:@"variance"];
                    if ([variance isEqualToString:@"FALSE"]) {
                        [Cell.blur_img setHidden:YES];
                    }else{
                        if(cameraboolToRestrict == FALSE){
                            [Cell.blur_img setHidden:NO];
                        }else{
                            [Cell.blur_img setHidden:YES];
                        }
                    }
                    [Cell.videoicon setHidden:YES];
                    Cell.image_View.image =image;
                    if([[adict valueForKey: @"imageName"] isEqual: @""]){
                        [Cell.delete_btn setHidden:YES];
                        [Cell.videoicon setHidden:YES];
                    }else{
                        [Cell.delete_btn setHidden:NO];
                        [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                        [Cell.delete_btn setTag:indexPath.row];
                    }
                }
            }else{
                if(imageName.length >4){
                    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                    NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
                    if([extentionArray[1] isEqualToString:@"mp4"])
                    {
                        NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
                        UIImage* image = [self generateThumbImage : path];
                        if(image != nil)
                        {
                            Cell.image_View.image = image;
                        }
                        else{
                            Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
                        }
                        [Cell.blur_img setHidden:YES];
                        [Cell.low_light setHidden:YES];
                        [Cell.videoicon setHidden:NO];
                        if([[adict valueForKey: @"imageName"] isEqual: @""]){
                            [Cell.delete_btn setHidden:YES];
                            [Cell.videoicon setHidden:YES];
                        }else{
                            [Cell.delete_btn setHidden:NO];
                            [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                            [Cell.delete_btn setTag:indexPath.row];
                        }
                    }else{
                        Cell.image_View.image =image;
                        [Cell.videoicon setHidden:YES];
                    }
                }
                [Cell.low_light setHidden:YES];
                [Cell.blur_img setHidden:YES];
                [Cell.delete_btn setHidden:YES];
                [Cell.videoicon setHidden:YES];
            }
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
<<<<<<< HEAD
=======
            Cell.waterMark_lbl.layer.cornerRadius = Cell.waterMark_lbl.frame.size.width / 2.0;
            Cell.waterMark_lbl.clipsToBounds = YES;
            [Cell.waterMark_lbl setHidden:NO];
            // Check if the image is available for the current indexPath
            if (indexPath.row < self.myimagearray.count) {
                // Set the background color of the watermark label to white
                Cell.waterMark_lbl.backgroundColor = [UIColor whiteColor];
            } else if (indexPath.row >= self.myimagearray.count && indexPath.row < self.myimagearray.count) {
                // Set the background color of the watermark label to clear if the image has been deleted
                Cell.waterMark_lbl.backgroundColor = [UIColor clearColor];
            } else {
                // Hide the watermark label or set its background color to clear if no image is available
                Cell.waterMark_lbl.backgroundColor = [UIColor clearColor];
            }

>>>>>>> main
        }
    }
    return Cell;
}


-(void)Instruc{
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
<<<<<<< HEAD
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
=======
       if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
           [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
       }
>>>>>>> main
    numberofphotoCapturedforsteps = self.myimagearray.count;
    NSLog(@"instructDataa:%@",_instructData);
    NSMutableDictionary *InstructDict = [[_instructData objectAtIndex:self.wholeStepsCount] mutableCopy];
    self.InstructNumb = [InstructDict objectForKey:@"instruction_number"];
    self.InstructName = [self htmlEntityDecode:[InstructDict objectForKey:@"instruction_name"]];
<<<<<<< HEAD
=======
    self.InstructFile = [self htmlEntityDecode:[InstructDict objectForKey:@"step_file"]];
>>>>>>> main
    self.InstructCount = [[InstructDict objectForKey:@"count_for_step_pics"]intValue];
    NSLog(@"InstructNumb:%@",self.InstructNumb);
    NSLog(@"InstructName:%@",self.InstructName);
    NSLog(@"InstructCount:%d",self.InstructCount);
<<<<<<< HEAD
    
    TotalNoOfPhoto =  self.InstructCount;
    
    self.Labelsteps.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.Labelsteps setTitle:[NSString stringWithFormat:@" %@  ",self.InstructName] forState:UIControlStateNormal];
    NSLog(@"self.Labelsteps.titleLabel.text:%@",self.Labelsteps.titleLabel.text);
    
=======
    if(self.InstructFile != nil &&  ![self.InstructFile  isEqual: @""]){
        self.ViewButton.hidden = NO;
    }else {
        self.ViewButton.hidden = YES;
    }

    TotalNoOfPhoto =  self.InstructCount;
    [self.Labelsteps setTitle:@"" forState:UIControlStateNormal];
    self.Labelsteps.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.Labelsteps setTitle:[NSString stringWithFormat:@" %@  ",self.InstructName] forState:UIControlStateNormal];
    // Set the content edge insets to move the title text 2 points away from the leading
    self.Labelsteps.contentEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    NSLog(@"self.Labelsteps.titleLabel.text:%@",self.Labelsteps.titleLabel.text);

    int pos =self.wholeStepsCount % 22;
    NSString *colorCode = [colorCodes objectAtIndex:pos];
    UIColor *color = [self colorFromHexString:colorCode];
    self.LabelstepsView.backgroundColor = color;
    
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    // Initialize a counter to keep track of the current character index
    __block NSUInteger characterIndex = 0;

    // Set up the timer to update the button's text every interval
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // Check if the character index is less than the length of the button's text
        if (characterIndex < self.InstructName.length) {
            // Get the substring from the beginning up to the current character index
            NSString *substring = [self.InstructName substringToIndex:characterIndex + 1];
            
            // Update the button's text with the substring
            [self.Labelsteps setTitle:[NSString stringWithFormat:@" %@  ", substring] forState:UIControlStateNormal];
            
            // Increment the character index
            characterIndex++;
        } else {
            // Stop the timer when all characters have been displayed
            [timer invalidate];
            timer = nil;
        }
    }];

    // Run the timer on the main run loop
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
    gpccTitle = self.InstructName;
>>>>>>> main
    //parkload
    if([self.parkLoad valueForKey:@"category"] && [self.parkLoad valueForKey:@"img"]>0 && self.isTrue == false){
        [self.myimagearray removeAllObjects];
        NSMutableDictionary *dict = [[self.instructData objectAtIndex:self.wholeStepsCount] mutableCopy];
        int value = [[dict objectForKey:@"instruction_number"]intValue];
        for(int i=0; i<self.ArrayofstepPhoto.count;i++){
            NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
            int valuee = [[newdict objectForKey:@"InstructNumber"]intValue];
            if(value == valuee){
                [self.myimagearray addObject:newdict];
                [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:newdict];
                [self.collection_View reloadData];
                NSLog(@"self.myimagearray:%@",self.myimagearray);
            }
        }
        numberofphotoCapturedforsteps = self.myimagearray.count;
    }else{
        [self.myimagearray removeAllObjects];
        NSMutableDictionary *dict = [[self.instructData objectAtIndex:self.wholeStepsCount] mutableCopy];
        int value = [[dict objectForKey:@"instruction_number"]intValue];
        for(int i=0; i<self.ArrayofstepPhoto.count;i++){
            NSMutableDictionary *newdict = [[self.ArrayofstepPhoto objectAtIndex:i] mutableCopy];
            int valuee = [[newdict objectForKey:@"InstructNumber"]intValue];
            if(value == valuee){
                [self.myimagearray addObject:newdict];
                [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:newdict];
                [self.collection_View reloadData];
                NSLog(@"self.myimagearray:%@",self.myimagearray);
            }
        }
        numberofphotoCapturedforsteps = self.myimagearray.count;
    }
    [self.collection_View reloadData];
<<<<<<< HEAD
}

=======
    
    // Initialize currentIndex
    //currentIndex = 0;
//    CATransition *transition = nil;
//     transition = [CATransition animation];
//     transition.duration = 0.5;
//     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//     transition.type = kCATransitionPush;
//     transition.subtype =kCATransitionFromBottom ;
//     [self.Labelsteps.layer addAnimation:transition forKey:nil];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5
//                                                      target:self
//                                   selector:@selector(textAnim:)
//                                                    userInfo:nil
//      
   /* self.currentIndex = 0;
        self.fullText = self.InstructName;
    [self animateText];repeats:NO; */
}



 /* - (void)animateText{
    
    //if (self.currentIndex < self.fullText.length) {
    NSString *substring = [self.fullText substringWithRange:NSMakeRange(self->currentIndex, 1)];
            NSString *currentText = [self.Labelsteps titleForState:UIControlStateNormal];
            NSString *newText = [NSString stringWithFormat:@"%@%@", currentText, substring];
            
            // Apply animation to simulate characters coming from bottom
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromBottom;
            [self.Labelsteps.layer addAnimation:animation forKey:nil];
            
            [self.Labelsteps setTitle:self.fullText forState:UIControlStateNormal];
    self->currentIndex++;
            
            // Call recursively after a delay to create a sequential effect
            //[self performSelector:@selector(animateText) withObject:nil afterDelay:0.1];
      //  }
} */

- (void)backgroundAnim:(NSTimer *)timer  {
    CATransition *transition = nil;
     transition = [CATransition animation];
     transition.duration = 0.5;//kAnimationDuration
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     transition.type = kCATransitionPush;
     transition.subtype =kCATransitionFromBottom ;
     [self.Labelsteps.layer addAnimation:transition forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                   selector:@selector(textAnim:)
                                                    userInfo:nil
                                                     repeats:NO];
}
- (void)textAnim:(NSTimer *)timer  {
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                   selector:@selector(updateButtonTitle:)
                                                    userInfo:nil
                                                     repeats:YES];
}
- (void)updateButtonTitle:(NSTimer *)timer  {
    NSString *fullText = gpccTitle;
    if (currentIndex < fullText.length) {
           NSString *substring = [fullText substringToIndex:currentIndex + 1];
        [self.Labelsteps setTitle:substring forState:UIControlStateNormal];
           currentIndex++;
       } else {
           [timer invalidate]; // Stop the timer when animation is complete
       }
   
}


>>>>>>> main
-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}


#pragma mark - Action  Methods


-(IBAction)delete:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSDictionary* myimagedict = [self.myimagearray objectAtIndex:btn.tag];
    NSString* imageName = [myimagedict valueForKey:@"imageName"];
    NSString *path = [[AZCAppDelegate.sharedInstance getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    NSString* imagePath = [path stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    numberofphotoCapturedforsteps = numberofphotoCapturedforsteps - 1;
    [self.myimagearray removeObjectAtIndex:btn.tag];
    self.tapCount = self.myimagearray.count;
    NSLog(@" the delete array is :%@",self.myimagearray);
    [self.collection_View reloadData];
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
<<<<<<< HEAD
    
=======

>>>>>>> main
    //RemovingfromMainArray - loopingArray
    int index = 0;
    long arr_time = [[myimagedict objectForKey:@"created_Epoch_Time"]intValue];
    int instr_numb =[[myimagedict objectForKey:@"InstructNumber"]intValue];
<<<<<<< HEAD
    
=======

>>>>>>> main
    for(int i=0; i<self.ArrayofstepPhoto.count; i++){
        NSDictionary*dicto = [self.ArrayofstepPhoto objectAtIndex:i];
        long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
        int instr_numb_dict =[[dicto objectForKey:@"InstructNumber"]intValue];
<<<<<<< HEAD
        
=======

>>>>>>> main
        if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }
    [self.ArrayofstepPhoto removeObjectAtIndex:index];
    [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//while tapping next button
-(IBAction)btn_NextTapped:(id)sender
{
    NSDictionary*dict;
    NSMutableArray *checkArr = [self.parkLoad objectForKey:@"img"];
    if(checkArr != nil && checkArr.count>0){
        for(int i=0; i<checkArr.count; i++){
            dict = [checkArr objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;;
            }
        }
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
            return;
        }
    }
    if(self.myimagearray.count == 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"CameraVC"]){
        [self.view makeToast:NSLocalizedString(@"Capture Atleast 1 Image",@"") duration:2.0 position:CSToastPositionCenter];
    }
    else if(self.instructData.count == self.nxt_clicked)
    {
        if([[dict valueForKey: @"imageName"] isEqual: @""] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"CameraVC"]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            //next_screen
            if(self.selectedTab == nil){
<<<<<<< HEAD
                // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
=======
               // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
>>>>>>> main
            }
            imge.picslist = self.ArrayofstepPhoto;
            NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);
            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"my next %@",imge.picslist);
            
            if(WeAreRecording == YES )
            {
                [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
                return;
            }
            
            GalleryViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
            GalleryVC.imageArray = self.ArrayofstepPhoto;
            GalleryVC.siteData = self.siteData;
            GalleryVC.sitename = self.siteName;
            GalleryVC.pathToImageFolder = pathToImageFolder;
            GalleryVC.instructData = [self.parkLoad valueForKey:@"instructData"];
            [self.navigationController pushViewController:GalleryVC animated:YES];
        }
<<<<<<< HEAD
        //        else{
        //            if ([checkBlur.lowercaseString isEqualToString:@"error"] || [checkBlur.lowercaseString isEqualToString:@"warning"]) {
        //                            int blurPos = -1;
        //                            int lowLightPos = -1;
        //                            NSMutableString * blurMesg;
        //                            NSMutableString * lowLightMesg;
        //                            for(int y= 0; y < self.myimagearray.count; y++){
        //                                NSMutableDictionary * dic =[self.myimagearray objectAtIndex:y];
        //                                NSString* IsLowLight = [dic valueForKey:@"brightness"];
        //                                NSString* variance = [dic valueForKey:@"variance"];
        //                                if ([variance isEqualToString:@"TRUE"]) {
        //                                    if(blurPos == -1){
        //                                        [blurMesg appendFormat:@"%d", y+1];
        //                                    }else{
        //                                        [blurMesg appendFormat:@", %d", y+1];
        //                                    }
        //                                    blurPos = y;
        //                                }
        //                                if ([IsLowLight isEqualToString:@"TRUE"]) {
        //                                    if(lowLightPos == -1){
        //                                        [lowLightMesg appendFormat:@"%d", y+1];
        //                                    }else{
        //                                        [lowLightMesg appendFormat:@", %d", y+1];
        //                                    }
        //                                    lowLightPos = y;
        //                                }
        //                            }
        //                            if(blurPos > -1){
        //                                [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"blur" withfourth: 1];
        //                                return;
        //                            }
        //                            if(lowLightPos > -1){
        //                                [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"lowLight" withfourth: 1];
        //                                return;
        //                            }
        //                       }
        //            //next_screen
        //            if(self.selectedTab == nil){
        //               // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
        //            }
        //            imge.picslist = self.ArrayofstepPhoto;
        //            NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);
        //            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
        //            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        //            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //            NSLog(@"my next %@",imge.picslist);
        //
        //            if(WeAreRecording == YES )
        //            {
        //                [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
        //                return;
        //            }
        //
        //            GalleryViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
        //            GalleryVC.imageArray = self.ArrayofstepPhoto;
        //            GalleryVC.siteData = self.siteData;
        //            GalleryVC.sitename = self.siteName;
        //            GalleryVC.pathToImageFolder = pathToImageFolder;
        //            GalleryVC.instructData = [self.parkLoad valueForKey:@"instructData"];
        //            [self.navigationController pushViewController:GalleryVC animated:YES];
        //        }
=======
//        else{
//            if ([checkBlur.lowercaseString isEqualToString:@"error"] || [checkBlur.lowercaseString isEqualToString:@"warning"]) {
//                            int blurPos = -1;
//                            int lowLightPos = -1;
//                            NSMutableString * blurMesg;
//                            NSMutableString * lowLightMesg;
//                            for(int y= 0; y < self.myimagearray.count; y++){
//                                NSMutableDictionary * dic =[self.myimagearray objectAtIndex:y];
//                                NSString* IsLowLight = [dic valueForKey:@"brightness"];
//                                NSString* variance = [dic valueForKey:@"variance"];
//                                if ([variance isEqualToString:@"TRUE"]) {
//                                    if(blurPos == -1){
//                                        [blurMesg appendFormat:@"%d", y+1];
//                                    }else{
//                                        [blurMesg appendFormat:@", %d", y+1];
//                                    }
//                                    blurPos = y;
//                                }
//                                if ([IsLowLight isEqualToString:@"TRUE"]) {
//                                    if(lowLightPos == -1){
//                                        [lowLightMesg appendFormat:@"%d", y+1];
//                                    }else{
//                                        [lowLightMesg appendFormat:@", %d", y+1];
//                                    }
//                                    lowLightPos = y;
//                                }
//                            }
//                            if(blurPos > -1){
//                                [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"blur" withfourth: 1];
//                                return;
//                            }
//                            if(lowLightPos > -1){
//                                [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"lowLight" withfourth: 1];
//                                return;
//                            }
//                       }
//            //next_screen
//            if(self.selectedTab == nil){
//               // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
//            }
//            imge.picslist = self.ArrayofstepPhoto;
//            NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);
//            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
//            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSLog(@"my next %@",imge.picslist);
//
//            if(WeAreRecording == YES )
//            {
//                [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
//                return;
//            }
//
//            GalleryViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
//            GalleryVC.imageArray = self.ArrayofstepPhoto;
//            GalleryVC.siteData = self.siteData;
//            GalleryVC.sitename = self.siteName;
//            GalleryVC.pathToImageFolder = pathToImageFolder;
//            GalleryVC.instructData = [self.parkLoad valueForKey:@"instructData"];
//            [self.navigationController pushViewController:GalleryVC animated:YES];
//        }
>>>>>>> main
    }else{
        if(self.selectedTab != nil && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"PicViewVC"]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            if ([checkBlur.lowercaseString isEqualToString:@"error"] || [checkBlur.lowercaseString isEqualToString:@"warning"]) {
<<<<<<< HEAD
                int blurPos = -1;
                int lowLightPos = -1;
                NSMutableString * blurMesg;
                NSMutableString * lowLightMesg;
                for(int y= 0; y < self.myimagearray.count; y++){
                    NSMutableDictionary * dic =[self.myimagearray objectAtIndex:y];
                    NSString* IsLowLight = [dic valueForKey:@"brightness"];
                    NSString* variance = [dic valueForKey:@"variance"];
                    if ([variance isEqualToString:@"TRUE"]) {
                        if(blurPos == -1){
                            [blurMesg appendFormat:@"%d", y+1];
                        }else{
                            [blurMesg appendFormat:@", %d", y+1];
                        }
                        blurPos = y;
                    }
                    if ([IsLowLight isEqualToString:@"TRUE"]) {
                        if(lowLightPos == -1){
                            [lowLightMesg appendFormat:@"%d", y+1];
                        }else{
                            [lowLightMesg appendFormat:@", %d", y+1];
                        }
                        lowLightPos = y;
                    }
                }
                if(blurPos > -1){
                    [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"blur" withfourth: 2];
                    return;
                }
                if(lowLightPos > -1){
                    [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"lowLight" withfourth: 2];
                    return;
                }
            }
=======
                          int blurPos = -1;
                          int lowLightPos = -1;
                          NSMutableString * blurMesg;
                          NSMutableString * lowLightMesg;
                          for(int y= 0; y < self.myimagearray.count; y++){
                              NSMutableDictionary * dic =[self.myimagearray objectAtIndex:y];
                              NSString* IsLowLight = [dic valueForKey:@"brightness"];
                              NSString* variance = [dic valueForKey:@"variance"];
                              if ([variance isEqualToString:@"TRUE"]) {
                                  if(blurPos == -1){
                                      [blurMesg appendFormat:@"%d", y+1];
                                  }else{
                                      [blurMesg appendFormat:@", %d", y+1];
                                  }
                                  blurPos = y;
                              }
                              if ([IsLowLight isEqualToString:@"TRUE"]) {
                                  if(lowLightPos == -1){
                                      [lowLightMesg appendFormat:@"%d", y+1];
                                  }else{
                                      [lowLightMesg appendFormat:@", %d", y+1];
                                  }
                                  lowLightPos = y;
                              }
                          }
                          if(blurPos > -1){
                              [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"blur" withfourth: 2];
                              return;
                          }
                          if(lowLightPos > -1){
                              [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"lowLight" withfourth: 2];
                              return;
                          }
                      }
>>>>>>> main
            //next_step
            self.nxt_clicked ++;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
            //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            int count = [self->_instructData count];
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            [self.collection_View reloadData];
            NSString *model=[UIDevice currentDevice].model;
            bool needToscroll = FALSE;
            if ([model isEqualToString:@"iPad"] ) {
                if(self.myimagearray.count>3){
                    needToscroll = TRUE;
                }
            }else{
                if(self.myimagearray.count>2){
                    needToscroll = TRUE;
                }
            }
            if(needToscroll == TRUE){
                
                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
            //needToscroll = FALSE;
            if(self.wholeStepsCount == count-1)
            {
                // self.next.hidden = false;
            }else{
                [self.myimagearray removeAllObjects];
                if(self.wholeStepsCount+1 < _instructData.count){
                    self.wholeStepsCount++;
                }
                [self Instruc];
            }
        }
    }
}


-(void) blurAlertPopup: (NSMutableString *) blurCount withsecond:(NSMutableString *) lowLight withthird:(NSString *) type withfourth:(int) pageType {
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Retake",@"") target:self selector:@selector(dummy:) backgroundColor:Red ];
    if(![checkBlur.lowercaseString isEqualToString:@"error"]){
        if(pageType == 1){
            [self.alertbox addButton:NSLocalizedString(@"Skip",@"") target:self selector:@selector(blurPopupContinue1:) backgroundColor:Green];
        }else{
            [self.alertbox addButton:NSLocalizedString(@"Skip",@"") target:self selector:@selector(blurPopupContinue2:) backgroundColor:Green];
        }
        self.alertbox.title = NSLocalizedString(@"Warning!",@"");
        if([type isEqualToString:@"blur"]){
<<<<<<< HEAD
            [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
            [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Low light image",@"" ) closeButtonTitle:nil duration:1.0f ];
=======
        [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
         [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Low light image",@"" ) closeButtonTitle:nil duration:1.0f ];
>>>>>>> main
        }
    }else{
        self.alertbox.title = @"Error";
        if([type isEqualToString:@"blur"]){
<<<<<<< HEAD
            [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
            [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
=======
        [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
         [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
>>>>>>> main
        }
    }
}

-(IBAction)blurPopupContinue2:(id)sender{
    
    [self.alertbox hideView];
    //next_step
    self.nxt_clicked ++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
    //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
    [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    int count = [self->_instructData count];
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    [self.collection_View reloadData];
    NSString *model=[UIDevice currentDevice].model;
    bool needToscroll = FALSE;
    if ([model isEqualToString:@"iPad"] ) {
        if(self.myimagearray.count>3){
            needToscroll = TRUE;
        }
    }else{
        if(self.myimagearray.count>2){
            needToscroll = TRUE;
        }
    }
    if(needToscroll == TRUE){
        
        [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    //needToscroll = FALSE;
    if(self.wholeStepsCount == count-1)
    {
        // self.next.hidden = false;
    }else{
        [self.myimagearray removeAllObjects];
        if(self.wholeStepsCount+1 < _instructData.count){
            self.wholeStepsCount++;
        }
        [self Instruc];
    }
}

-(IBAction)blurPopupContinue1:(id)sender{
<<<<<<< HEAD
    
    [self.alertbox hideView];
    //next_screen
    if(self.selectedTab == nil){
        // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
    }
    imge.picslist = self.ArrayofstepPhoto;
    NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);
    
=======
   
    [self.alertbox hideView];
    //next_screen
    if(self.selectedTab == nil){
       // [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
    }
    imge.picslist = self.ArrayofstepPhoto;
    NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);

>>>>>>> main
    [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"my next %@",imge.picslist);
<<<<<<< HEAD
    
=======

>>>>>>> main
    if(WeAreRecording == YES )
    {
        [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
        return;
    }
<<<<<<< HEAD
    
=======

>>>>>>> main
    GalleryViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
    GalleryVC.imageArray = self.ArrayofstepPhoto;
    GalleryVC.siteData = self.siteData;
    GalleryVC.sitename = self.siteName;
    GalleryVC.pathToImageFolder = pathToImageFolder;
    GalleryVC.instructData = [self.parkLoad valueForKey:@"instructData"];
    [self.navigationController pushViewController:GalleryVC animated:YES];
<<<<<<< HEAD
    
=======
  
>>>>>>> main
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //imagepick = false;
    pickimage = true;
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)clickImageAction:(id)sender{
    
    [locationManager startUpdatingLocation];
    if(self.selectedTab != nil){
        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
            NSDictionary * newdict = [[NSDictionary alloc]init];
            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
            {
                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    self.nxt_clicked = self.instructData.count;
                    [self.captureAction setEnabled:NO];
                    [self.imgBtn setEnabled:NO];
                    
                    //hiding for camera improper numbering
                    AVCaptureConnection *videoConnection  = nil;
                    for(AVCaptureConnection *connection in StillImageOutput.connections){
                        for(AVCaptureInputPort *port in  [connection inputPorts]){
                            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                                videoConnection =connection;
                                break;
                            }
                        }
                    }
                    
                    // Capture a still photo
                    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
                    [StillImageOutput capturePhotoWithSettings:photoSettings delegate:self];
                    
<<<<<<< HEAD
                    //                    [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
                    //                    if (imageDataSampleBuffer!=NULL) {
                    //                        CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
                    //                        NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
                    //                        CFRelease(metadataDict);
                    //                        NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
                    //                        float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
                    //                        NSLog(@"Brightness value: %f",brightnessValue);
                    //                        NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    //                        UIImage *capturedImage = [UIImage imageWithData:imageData];
                    //                        CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
                    //                        UIImage *resizedImage ;
                    //                        if(![self.siteData.image_quality isEqual:@"4"]){
                    //
                    //                            CGImageRef takenCGImage = capturedImage.CGImage;
                    //                            size_t width = CGImageGetWidth(takenCGImage);
                    //                            size_t height = CGImageGetHeight(takenCGImage);
                    //                            CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                    //                            CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                    //                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                    //                            CGImageRelease(cropCGImage);
                    //                            UIGraphicsBeginImageContext(capturedImage.size);
                    //                            [capturedImage drawAtPoint:CGPointZero];
                    //                            capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                    //                            UIGraphicsEndImageContext();
                    //                            //REducing the captured image size
                    //                            CGSize imageSize;
                    //                            NSLog(@"Image Quality :%@",self.siteData.image_quality);
                    //                            if ([self.siteData.image_quality isEqual:@"1"]) {
                    //                                imageSize = CGSizeMake(720,1080);
                    //                            }else{
                    //                                imageSize = CGSizeMake(1440,2160);
                    //                            }
                    //                            UIGraphicsBeginImageContext(imageSize);
                    //                            [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    //                            resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                    //                            UIGraphicsEndImageContext();
                    //                        }else{
                    //                            resizedImage =capturedImage;
                    //                        }
                    //                        //OLD CODE END
                    //                        int x = arc4random() % 100;
                    //                        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                    //                        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                    //                        NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                    //                        NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
                    //                        NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
                    //                        NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
                    //                        [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
                    //                        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                    //                        [[NSUserDefaults standardUserDefaults] synchronize];
                    //                        [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
                    //                        [myimagedict setObject:imageName forKey:@"imageName"];
                    //                        [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
                    //                        [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
                    //                        [myimagedict setObject:latitude forKey:@"latitude"];
                    //                        [myimagedict setObject:longitude forKey:@"longitude"];
                    //                        NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                    //                        [myimagedict setObject:islowlight forKey:@"brightness"];
                    //
                    //                        NSLog(@"pics %@",pics);
                    //
                    //                        CGImageRef iimage = [resizedImage CGImage];
                    //
                    //                        if (@available(iOS 12, *)) {
                    //                            NSString *model=[UIDevice currentDevice].model;
                    //                            float target=2.0; //ipod
                    //                            if ([model isEqualToString:@"iPad"]) {
                    //                                target=12.0;
                    //                            }else if([model isEqualToString:@"iPhone"]){
                    //                                target=7.0;
                    //                            }
                    //                            [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
                    //                        }else{
                    //                            [myimagedict setObject:@"FALSE" forKey:@"variance"];
                    //                        }
                    //                        NSMutableDictionary*dicto;
                    //                        int index = 0;
                    //                        for(int i=0; i<self.myimagearray.count; i++){
                    //                            dicto = [[self.myimagearray objectAtIndex:i]mutableCopy];
                    //                            if([[dicto objectForKey:@"imageName"] isEqual:@""]){
                    //                                index = i;
                    //                                NSLog(@"index:%d",index);
                    //                                break;
                    //                            }
                    //                        }
                    //                        //if(self.selectedTab != nil){
                    //                            [myimagedict setObject:[newdict objectForKey:@"InstructNumber"] forKey:@"InstructNumber"];
                    //                            [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                    //                        //}else{
                    //                         //   [self.myimagearray addObject:myimagedict];
                    //                        //}
                    //                        //[self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                    //                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:myimagedict];
                    //                        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
                    //
                    //                        NSLog(@" the taken photo is:%@",self.myimagearray);
                    //                        //reloading the collection view
                    //                        [self.collection_View reloadData];
                    //                        NSLog(@"my %@",myimagedict);
                    //                        imge.picslist = self.myimagearray;
                    //                        [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
                    //                        [[NSUserDefaults standardUserDefaults]synchronize];
                    //                        NSLog(@"my2 %@",imge.picslist);
                    //                        _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
                    //
                    //                        if(self.selectedTab != nil){
                    //                            for(int i =0; i<self.ArrayofstepPhoto.count; i++){
                    //                                NSDictionary * newdict = [[NSDictionary alloc]init];
                    //                                newdict = [self.ArrayofstepPhoto objectAtIndex:i];
                    //                                if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                    //                                {
                    //                                    if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    //                                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                    //                                    }
                    //                                }
                    //                            }
                    //                            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
                    //                            if(self.parkLoadArray.count != 0){
                    //                                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                    //                            }
                    //                            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                    //                            [[NSUserDefaults standardUserDefaults] synchronize];
                    //                            [self btn_NextTapped:self.view];
                    //                        }
                    //                    }
                    //                    }];
=======
//                    [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
//                    if (imageDataSampleBuffer!=NULL) {
//                        CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//                        NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
//                        CFRelease(metadataDict);
//                        NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
//                        float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
//                        NSLog(@"Brightness value: %f",brightnessValue);
//                        NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                        UIImage *capturedImage = [UIImage imageWithData:imageData];
//                        CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
//                        UIImage *resizedImage ;
//                        if(![self.siteData.image_quality isEqual:@"4"]){
//
//                            CGImageRef takenCGImage = capturedImage.CGImage;
//                            size_t width = CGImageGetWidth(takenCGImage);
//                            size_t height = CGImageGetHeight(takenCGImage);
//                            CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
//                            CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
//                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
//                            CGImageRelease(cropCGImage);
//                            UIGraphicsBeginImageContext(capturedImage.size);
//                            [capturedImage drawAtPoint:CGPointZero];
//                            capturedImage = UIGraphicsGetImageFromCurrentImageContext();
//                            UIGraphicsEndImageContext();
//                            //REducing the captured image size
//                            CGSize imageSize;
//                            NSLog(@"Image Quality :%@",self.siteData.image_quality);
//                            if ([self.siteData.image_quality isEqual:@"1"]) {
//                                imageSize = CGSizeMake(720,1080);
//                            }else{
//                                imageSize = CGSizeMake(1440,2160);
//                            }
//                            UIGraphicsBeginImageContext(imageSize);
//                            [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//                            resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//                            UIGraphicsEndImageContext();
//                        }else{
//                            resizedImage =capturedImage;
//                        }
//                        //OLD CODE END
//                        int x = arc4random() % 100;
//                        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
//                        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
//                        NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
//                        NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
//                        NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
//                        NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
//                        [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
//                        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
//                        [myimagedict setObject:imageName forKey:@"imageName"];
//                        [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
//                        [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
//                        [myimagedict setObject:latitude forKey:@"latitude"];
//                        [myimagedict setObject:longitude forKey:@"longitude"];
//                        NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
//                        [myimagedict setObject:islowlight forKey:@"brightness"];
//
//                        NSLog(@"pics %@",pics);
//
//                        CGImageRef iimage = [resizedImage CGImage];
//
//                        if (@available(iOS 12, *)) {
//                            NSString *model=[UIDevice currentDevice].model;
//                            float target=2.0; //ipod
//                            if ([model isEqualToString:@"iPad"]) {
//                                target=12.0;
//                            }else if([model isEqualToString:@"iPhone"]){
//                                target=7.0;
//                            }
//                            [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
//                        }else{
//                            [myimagedict setObject:@"FALSE" forKey:@"variance"];
//                        }
//                        NSMutableDictionary*dicto;
//                        int index = 0;
//                        for(int i=0; i<self.myimagearray.count; i++){
//                            dicto = [[self.myimagearray objectAtIndex:i]mutableCopy];
//                            if([[dicto objectForKey:@"imageName"] isEqual:@""]){
//                                index = i;
//                                NSLog(@"index:%d",index);
//                                break;
//                            }
//                        }
//                        //if(self.selectedTab != nil){
//                            [myimagedict setObject:[newdict objectForKey:@"InstructNumber"] forKey:@"InstructNumber"];
//                            [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
//                        //}else{
//                         //   [self.myimagearray addObject:myimagedict];
//                        //}
//                        //[self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
//                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:myimagedict];
//                        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
//
//                        NSLog(@" the taken photo is:%@",self.myimagearray);
//                        //reloading the collection view
//                        [self.collection_View reloadData];
//                        NSLog(@"my %@",myimagedict);
//                        imge.picslist = self.myimagearray;
//                        [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
//                        [[NSUserDefaults standardUserDefaults]synchronize];
//                        NSLog(@"my2 %@",imge.picslist);
//                        _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
//
//                        if(self.selectedTab != nil){
//                            for(int i =0; i<self.ArrayofstepPhoto.count; i++){
//                                NSDictionary * newdict = [[NSDictionary alloc]init];
//                                newdict = [self.ArrayofstepPhoto objectAtIndex:i];
//                                if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
//                                {
//                                    if([[newdict objectForKey:@"imageName"] isEqual:@""]){
//                                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
//                                    }
//                                }
//                            }
//                            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
//                            if(self.parkLoadArray.count != 0){
//                                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//                            }
//                            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            [self btn_NextTapped:self.view];
//                        }
//                    }
//                    }];
>>>>>>> main
                }
            }
        }
    }else{
        numberofphotoCapturedforsteps = numberofphotoCapturedforsteps + 1;
        if(numberofphotoCapturedforsteps <= TotalNoOfPhoto){
            [self.captureAction setEnabled:NO];
            [self.imgBtn setEnabled:NO];
            AVCaptureConnection *videoConnection  = nil;
            for(AVCaptureConnection *connection in StillImageOutput.connections){
                for(AVCaptureInputPort *port in  [connection inputPorts]){
                    if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                        videoConnection =connection;
                        break;
                    }
                }
            }
            // Capture a still photo
            AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
            [StillImageOutput capturePhotoWithSettings:photoSettings delegate:self];
            
<<<<<<< HEAD
            //            [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
            //                if (imageDataSampleBuffer!=NULL) {
            //                    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
            //                    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
            //                    CFRelease(metadataDict);
            //                    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
            //                    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
            //                    NSLog(@"Brightness value: %f",brightnessValue);
            //                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //                    UIImage *capturedImage = [UIImage imageWithData:imageData];
            //                    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
            //                    UIImage *resizedImage ;
            //                    if(![self.siteData.image_quality isEqual:@"4"]){
            //                        CGImageRef takenCGImage = capturedImage.CGImage;
            //                        size_t width = CGImageGetWidth(takenCGImage);
            //                        size_t height = CGImageGetHeight(takenCGImage);
            //                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
            //                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
            //                        capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
            //                        CGImageRelease(cropCGImage);
            //                        UIGraphicsBeginImageContext(capturedImage.size);
            //                        [capturedImage drawAtPoint:CGPointZero];
            //                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
            //                        UIGraphicsEndImageContext();
            //                        //REducing the captured image size
            //                        CGSize imageSize;
            //                        NSLog(@"Image Quality :%@",self.siteData.image_quality);
            //                        if ([self.siteData.image_quality isEqual:@"1"]) {
            //                            imageSize = CGSizeMake(720,1080);
            //                        }else{
            //                            imageSize = CGSizeMake(1440,2160);
            //                        }
            //                        UIGraphicsBeginImageContext(imageSize);
            //                        [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            //                        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            //                        UIGraphicsEndImageContext();
            //                    }else{
            //                        resizedImage =capturedImage;
            //                    }
            //                    //OLD CODE END
            //                    int x = arc4random() % 100;
            //                    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            //                    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
            //                    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
            //                    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
            //                    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
            //                    NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
            //                    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
            //                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
            //                    [[NSUserDefaults standardUserDefaults] synchronize];
            //                    [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
            //                    [myimagedict setObject:imageName forKey:@"imageName"];
            //                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
            //                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
            //                    [myimagedict setObject:latitude forKey:@"latitude"];
            //                    [myimagedict setObject:longitude forKey:@"longitude"];
            //                    NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
            //                    [myimagedict setObject:islowlight
            //                      forKey:@"brightness"];
            //
            //                    CGImageRef iimage = [resizedImage CGImage];
            //
            //                    if (@available(iOS 12, *)) {
            //                        NSString *model=[UIDevice currentDevice].model;
            //                        float target=2.0; //ipod
            //                        if ([model isEqualToString:@"iPad"]) {
            //                            target=12.0;
            //                        }else if([model isEqualToString:@"iPhone"]){
            //                            target=7.0;
            //                        }
            //                        [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
            //                    }else{
            //                        [myimagedict setObject:@"FALSE"forKey:@"variance"];
            //                    }
            //                    [self.myimagearray addObject:myimagedict];
            //                    [self.ArrayofstepPhoto addObject:myimagedict];
            //                    //reloading the collection view
            //                    [self.collection_View reloadData];
            //                    NSLog(@"my %@",myimagedict);
            //                    imge.picslist = _myimagearray;
            //                    [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
            //                    [[NSUserDefaults standardUserDefaults]synchronize];
            //                    NSLog(@"my2 %@",imge.picslist);
            //                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
            //
            //                    if(self.selectedTab != nil){
            //                        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
            //                            NSDictionary * newdict = [[NSDictionary alloc]init];
            //                            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
            //                            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
            //                            {
            //                                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
            //                                    [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
            //                                }
            //                            }
            //                        }
            //
            //                    }else{
            //                         NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            //                         NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.myimagearray.count - 1 inSection:section];
            //                         [self.collection_View reloadData];
            //                         NSString *model=[UIDevice currentDevice].model;
            //                         bool needToscroll = FALSE;
            //                         if ([model isEqualToString:@"iPad"] ) {
            //                             if(self.myimagearray.count>3){
            //                                 needToscroll = TRUE;
            //                             }
            //                         }else{
            //                             if(self.myimagearray.count>2){
            //                                 needToscroll = TRUE;
            //                             }
            //                         }
            //                         if(needToscroll == TRUE){
            //                             [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            //                         }
            //                     }
            //                }
            //                [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
            //                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            //                [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            //                [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
            //            }];
=======
//            [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
//                if (imageDataSampleBuffer!=NULL) {
//                    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//                    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
//                    CFRelease(metadataDict);
//                    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
//                    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
//                    NSLog(@"Brightness value: %f",brightnessValue);
//                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                    UIImage *capturedImage = [UIImage imageWithData:imageData];
//                    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
//                    UIImage *resizedImage ;
//                    if(![self.siteData.image_quality isEqual:@"4"]){
//                        CGImageRef takenCGImage = capturedImage.CGImage;
//                        size_t width = CGImageGetWidth(takenCGImage);
//                        size_t height = CGImageGetHeight(takenCGImage);
//                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
//                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
//                        capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
//                        CGImageRelease(cropCGImage);
//                        UIGraphicsBeginImageContext(capturedImage.size);
//                        [capturedImage drawAtPoint:CGPointZero];
//                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
//                        UIGraphicsEndImageContext();
//                        //REducing the captured image size
//                        CGSize imageSize;
//                        NSLog(@"Image Quality :%@",self.siteData.image_quality);
//                        if ([self.siteData.image_quality isEqual:@"1"]) {
//                            imageSize = CGSizeMake(720,1080);
//                        }else{
//                            imageSize = CGSizeMake(1440,2160);
//                        }
//                        UIGraphicsBeginImageContext(imageSize);
//                        [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//                        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//                        UIGraphicsEndImageContext();
//                    }else{
//                        resizedImage =capturedImage;
//                    }
//                    //OLD CODE END
//                    int x = arc4random() % 100;
//                    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
//                    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
//                    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
//                    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
//                    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
//                    NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
//                    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
//                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
//                    [myimagedict setObject:imageName forKey:@"imageName"];
//                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
//                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
//                    [myimagedict setObject:latitude forKey:@"latitude"];
//                    [myimagedict setObject:longitude forKey:@"longitude"];
//                    NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
//                    [myimagedict setObject:islowlight
//                      forKey:@"brightness"];
//
//                    CGImageRef iimage = [resizedImage CGImage];
//
//                    if (@available(iOS 12, *)) {
//                        NSString *model=[UIDevice currentDevice].model;
//                        float target=2.0; //ipod
//                        if ([model isEqualToString:@"iPad"]) {
//                            target=12.0;
//                        }else if([model isEqualToString:@"iPhone"]){
//                            target=7.0;
//                        }
//                        [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
//                    }else{
//                        [myimagedict setObject:@"FALSE"forKey:@"variance"];
//                    }
//                    [self.myimagearray addObject:myimagedict];
//                    [self.ArrayofstepPhoto addObject:myimagedict];
//                    //reloading the collection view
//                    [self.collection_View reloadData];
//                    NSLog(@"my %@",myimagedict);
//                    imge.picslist = _myimagearray;
//                    [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    NSLog(@"my2 %@",imge.picslist);
//                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
//
//                    if(self.selectedTab != nil){
//                        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
//                            NSDictionary * newdict = [[NSDictionary alloc]init];
//                            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
//                            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
//                            {
//                                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
//                                    [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
//                                }
//                            }
//                        }
//
//                    }else{
//                         NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
//                         NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.myimagearray.count - 1 inSection:section];
//                         [self.collection_View reloadData];
//                         NSString *model=[UIDevice currentDevice].model;
//                         bool needToscroll = FALSE;
//                         if ([model isEqualToString:@"iPad"] ) {
//                             if(self.myimagearray.count>3){
//                                 needToscroll = TRUE;
//                             }
//                         }else{
//                             if(self.myimagearray.count>2){
//                                 needToscroll = TRUE;
//                             }
//                         }
//                         if(needToscroll == TRUE){
//                             [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//                         }
//                     }
//                }
//                [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
//                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//                [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
//            }];
>>>>>>> main
            NSLog(@"the array count is :%lu",(unsigned long)self.myimagearray.count);
        }else if(self.myimagearray.count == TotalNoOfPhoto){
            [self btn_NextTapped:self.view];
        }
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    if (error) {
        // Handle error
        return;
    }
    [locationManager startUpdatingLocation];
    // Access the captured photo
    NSData *imageData = photo.fileDataRepresentation;
    UIImage *capturedImage = [UIImage imageWithData:imageData];
    
<<<<<<< HEAD
    //     Process or display the captured image
    //                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
=======
//     Process or display the captured image
//                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
>>>>>>> main
    
    //UIImage *capturedImage = [self increaseImageClarity:image];
    
    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
<<<<<<< HEAD
    //self.siteData.image_quality = @"4";
=======
                    //self.siteData.image_quality = @"4";
>>>>>>> main
    UIImage *resizedImage;
    float brightnessValue = [self calculateBrightnessLevelOfImage:capturedImage];
    
    if(self.selectedTab != nil){
        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
            NSDictionary * newdict = [[NSDictionary alloc]init];
            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
            {
                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    if(![self.siteData.image_quality isEqual:@"4"]){
                        CGImageRef takenCGImage = capturedImage.CGImage;
                        size_t width = CGImageGetWidth(takenCGImage);
                        size_t height = CGImageGetHeight(takenCGImage);
                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                        //capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                        if(captureOrientation == 90){
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                        }else{
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
                        }
                        CGImageRelease(cropCGImage);
                        UIGraphicsBeginImageContext(capturedImage.size);
<<<<<<< HEAD
                        //UIGraphicsBeginImageContextWithOptions(capturedImage.size, capturedImage.opaque, 0.0);
=======
                                    //UIGraphicsBeginImageContextWithOptions(capturedImage.size, capturedImage.opaque, 0.0);
>>>>>>> main
                        [capturedImage drawAtPoint:CGPointZero];
                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        CGSize imageSize;
                        NSLog(@"Image Quality :%@",self.siteData.image_quality);
                        if(captureOrientation == 90 || captureOrientation == 270){
                            if ([self.siteData.image_quality isEqual:@"1"]) {
                                imageSize = CGSizeMake(1080, 720);
                            }else{
                                imageSize = CGSizeMake(2160, 1440);
                            }
                        }else {
                            if ([self.siteData.image_quality isEqual:@"1"]) {
                                imageSize = CGSizeMake(720,1080);
                                //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                            }else{
                                imageSize = CGSizeMake(1440,2160);
                                //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                            }
                        }
<<<<<<< HEAD
                        UIGraphicsBeginImageContext(imageSize);
                        [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
=======
                    UIGraphicsBeginImageContext(imageSize);
                    [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
>>>>>>> main
                    }else{
                        CGImageRef takenCGImage = capturedImage.CGImage;
                        size_t width = CGImageGetWidth(takenCGImage);
                        size_t height = CGImageGetHeight(takenCGImage);
                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                        if(captureOrientation == 90){
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                        }else{
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
                        }
                        resizedImage = capturedImage;
                    }
                    //OLD CODE END
                    int x = arc4random() % 100;
                    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
                    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
                    NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
                    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
                    [myimagedict setObject:imageName forKey:@"imageName"];
                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
                    [myimagedict setObject:latitude forKey:@"latitude"];
                    [myimagedict setObject:longitude forKey:@"longitude"];
                    NSString *islowlight=brightnessValue<=0.15?@"TRUE":@"FALSE";
                    [myimagedict setObject:islowlight forKey:@"brightness"];
<<<<<<< HEAD
                    
                    NSLog(@"pics %@",pics);
                    
                    CGImageRef iimage = [resizedImage CGImage];
                    
=======

                    NSLog(@"pics %@",pics);

                    CGImageRef iimage = [resizedImage CGImage];

>>>>>>> main
                    if (@available(iOS 12, *)) {
                        NSString *model=[UIDevice currentDevice].model;
                        float target=2.0; //ipod
                        if ([model isEqualToString:@"iPad"]) {
                            target=100.0;
                        }else if([model isEqualToString:@"iPhone"]){
                            target=100.0;
                        }
                        [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
                    }else{
                        [myimagedict setObject:@"FALSE" forKey:@"variance"];
                    }
                    NSMutableDictionary*dicto;
                    int index = 0;
                    for(int i=0; i<self.myimagearray.count; i++){
                        dicto = [[self.myimagearray objectAtIndex:i]mutableCopy];
                        if([[dicto objectForKey:@"imageName"] isEqual:@""]){
                            index = i;
                            NSLog(@"index:%d",index);
                            break;
                        }
                    }
                    //if(self.selectedTab != nil){
<<<<<<< HEAD
                    [myimagedict setObject:[newdict objectForKey:@"InstructNumber"] forKey:@"InstructNumber"];
                    [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                    //}else{
                    //   [self.myimagearray addObject:myimagedict];
=======
                        [myimagedict setObject:[newdict objectForKey:@"InstructNumber"] forKey:@"InstructNumber"];
                        [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                    //}else{
                     //   [self.myimagearray addObject:myimagedict];
>>>>>>> main
                    //}
                    //[self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                    [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:myimagedict];
                    [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
<<<<<<< HEAD
                    
=======

>>>>>>> main
                    NSLog(@" the taken photo is:%@",self.myimagearray);
                    //reloading the collection view
                    [self.collection_View reloadData];
                    NSLog(@"my %@",myimagedict);
                    imge.picslist = self.myimagearray;
                    [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    NSLog(@"my2 %@",imge.picslist);
                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
<<<<<<< HEAD
                    
=======

>>>>>>> main
                    if(self.selectedTab != nil){
                        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
                            NSDictionary * newdict = [[NSDictionary alloc]init];
                            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
                            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                            {
                                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                                    [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                                }
                            }
                        }
                        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
                        if(self.parkLoadArray.count != 0){
                            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self btn_NextTapped:self.view];
                    }
                    
                }
            }
        }
    }else {
<<<<<<< HEAD
        if(![self.siteData.image_quality isEqual:@"4"]){
            CGImageRef takenCGImage = capturedImage.CGImage;
            size_t width = CGImageGetWidth(takenCGImage);
            size_t height = CGImageGetHeight(takenCGImage);
            CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
            CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
            //capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
            if(captureOrientation == 90){
                capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
            }else{
                capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
            }
            CGImageRelease(cropCGImage);
            UIGraphicsBeginImageContext(capturedImage.size);
            //UIGraphicsBeginImageContextWithOptions(capturedImage.size, capturedImage.opaque, 0.0);
            [capturedImage drawAtPoint:CGPointZero];
            capturedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGSize imageSize;
            NSLog(@"Image Quality :%@",self.siteData.image_quality);
            if(captureOrientation == 90 || captureOrientation == 270){
                if ([self.siteData.image_quality isEqual:@"1"]) {
                    imageSize = CGSizeMake(1080, 720);
                }else{
                    imageSize = CGSizeMake(2160, 1440);
                }
            }else {
                if ([self.siteData.image_quality isEqual:@"1"]) {
                    imageSize = CGSizeMake(720,1080);
                    //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                }else{
                    imageSize = CGSizeMake(1440,2160);
                    //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                }
            }
=======
            if(![self.siteData.image_quality isEqual:@"4"]){
                CGImageRef takenCGImage = capturedImage.CGImage;
                size_t width = CGImageGetWidth(takenCGImage);
                size_t height = CGImageGetHeight(takenCGImage);
                CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                //capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                if(captureOrientation == 90){
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                }else{
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
                }
                CGImageRelease(cropCGImage);
                UIGraphicsBeginImageContext(capturedImage.size);
                            //UIGraphicsBeginImageContextWithOptions(capturedImage.size, capturedImage.opaque, 0.0);
                [capturedImage drawAtPoint:CGPointZero];
                capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                CGSize imageSize;
                NSLog(@"Image Quality :%@",self.siteData.image_quality);
                if(captureOrientation == 90 || captureOrientation == 270){
                    if ([self.siteData.image_quality isEqual:@"1"]) {
                        imageSize = CGSizeMake(1080, 720);
                    }else{
                        imageSize = CGSizeMake(2160, 1440);
                    }
                }else {
                    if ([self.siteData.image_quality isEqual:@"1"]) {
                        imageSize = CGSizeMake(720,1080);
                        //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                    }else{
                        imageSize = CGSizeMake(1440,2160);
                        //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                    }
                }
>>>>>>> main
            UIGraphicsBeginImageContext(imageSize);
            [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
<<<<<<< HEAD
        }else{
            CGImageRef takenCGImage = capturedImage.CGImage;
            size_t width = CGImageGetWidth(takenCGImage);
            size_t height = CGImageGetHeight(takenCGImage);
            CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
            CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
            if(captureOrientation == 90){
                capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
            }else{
                capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
            }
            resizedImage = capturedImage;
        }
        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
        NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
        NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
        NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
        NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
        [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
        [myimagedict setObject:imageName forKey:@"imageName"];
        [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
        [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
        [myimagedict setObject:latitude forKey:@"latitude"];
        [myimagedict setObject:longitude forKey:@"longitude"];
        NSString *islowlight=brightnessValue<=0.15?@"TRUE":@"FALSE";
        [myimagedict setObject:islowlight
                        forKey:@"brightness"];
        
        CGImageRef iimage = [resizedImage CGImage];
        
        if (@available(iOS 12, *)) {
            NSString *model=[UIDevice currentDevice].model;
            float target=2.0; //ipod
            if ([model isEqualToString:@"iPad"]) {
                target=100.0;
            }else if([model isEqualToString:@"iPhone"]){
                target=100.0;
            }
            [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
        }else{
            [myimagedict setObject:@"FALSE"forKey:@"variance"];
        }
        [self.myimagearray addObject:myimagedict];
        [self.ArrayofstepPhoto addObject:myimagedict];
        //reloading the collection view
        [self.collection_View reloadData];
        NSLog(@"my %@",myimagedict);
        imge.picslist = _myimagearray;
        [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"my2 %@",imge.picslist);
        _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];
        
        if(self.selectedTab != nil){
            for(int i =0; i<self.ArrayofstepPhoto.count; i++){
                NSDictionary * newdict = [[NSDictionary alloc]init];
                newdict = [self.ArrayofstepPhoto objectAtIndex:i];
                if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                {
                    if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                    }
                }
            }
            
        }else{
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.myimagearray.count - 1 inSection:section];
            [self.collection_View reloadData];
            NSString *model=[UIDevice currentDevice].model;
            bool needToscroll = FALSE;
            if ([model isEqualToString:@"iPad"] ) {
                if(self.myimagearray.count>3){
                    needToscroll = TRUE;
                }
            }else{
                if(self.myimagearray.count>2){
                    needToscroll = TRUE;
                }
            }
            if(needToscroll == TRUE){
                //                     [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                if(self.myimagearray.count > 4){
                    // Calculate the content offset to scroll to the end
                    CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
                    // Make sure the contentOffset doesn't go below 0
                    contentOffsetX = MAX(0, contentOffsetX + 150);
                    // Scroll to the calculated content offset
                    [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
                }
            }
        }
=======
            }else{
                CGImageRef takenCGImage = capturedImage.CGImage;
                size_t width = CGImageGetWidth(takenCGImage);
                size_t height = CGImageGetHeight(takenCGImage);
                CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                if(captureOrientation == 90){
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                }else{
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + captureOrientation];
                }
                resizedImage = capturedImage;
            }
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
            NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
            NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
            NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
            NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
            [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
            [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
            [myimagedict setObject:imageName forKey:@"imageName"];
            [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
            [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
            [myimagedict setObject:latitude forKey:@"latitude"];
            [myimagedict setObject:longitude forKey:@"longitude"];
            NSString *islowlight=brightnessValue<=0.15?@"TRUE":@"FALSE";
            [myimagedict setObject:islowlight
              forKey:@"brightness"];

            CGImageRef iimage = [resizedImage CGImage];

            if (@available(iOS 12, *)) {
                NSString *model=[UIDevice currentDevice].model;
                float target=2.0; //ipod
                if ([model isEqualToString:@"iPad"]) {
                    target=100.0;
                }else if([model isEqualToString:@"iPhone"]){
                    target=100.0;
                }
                [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE" forKey:@"variance"];
            }else{
                [myimagedict setObject:@"FALSE"forKey:@"variance"];
            }
            [self.myimagearray addObject:myimagedict];
            [self.ArrayofstepPhoto addObject:myimagedict];
            //reloading the collection view
            [self.collection_View reloadData];
            NSLog(@"my %@",myimagedict);
            imge.picslist = _myimagearray;
            [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"my2 %@",imge.picslist);
            _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCount];

            if(self.selectedTab != nil){
                for(int i =0; i<self.ArrayofstepPhoto.count; i++){
                    NSDictionary * newdict = [[NSDictionary alloc]init];
                    newdict = [self.ArrayofstepPhoto objectAtIndex:i];
                    if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                    {
                        if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                            [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                        }
                    }
                }

            }else{
                 NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                 NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.myimagearray.count - 1 inSection:section];
                 [self.collection_View reloadData];
                 NSString *model=[UIDevice currentDevice].model;
                 bool needToscroll = FALSE;
                 if ([model isEqualToString:@"iPad"] ) {
                     if(self.myimagearray.count>3){
                         needToscroll = TRUE;
                     }
                 }else{
                     if(self.myimagearray.count>2){
                         needToscroll = TRUE;
                     }
                 }
                 if(needToscroll == TRUE){
//                     [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                     NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
                     if(![langStr isEqualToString:@"Arabic"] && ![langStr isEqualToString:@"Urdu"]){
                         if(self.myimagearray.count > 4){
                             // Calculate the content offset to scroll to the end
                             CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
                             // Make sure the contentOffset doesn't go below 0
                             contentOffsetX = MAX(0, contentOffsetX + 150);
                             // Scroll to the calculated content offset
                             [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
                         }
                     }
                 }
             }
>>>>>>> main
        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"];
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
    }
    
}

- (CGFloat)calculateBrightnessLevelOfImage:(UIImage *)image {
    // Convert the UIImage to CIImage
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
<<<<<<< HEAD
    
    // Apply the CIAreaAverage filter to calculate the average color values
    CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    // Retrieve the output image from the filter
    CIImage *outputImage = [filter outputImage];
    
    // Create a CIContext
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Create a CGRect representing the entire image
    CGRect extent = [outputImage extent];
    
    // Render the output image
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:extent];
    
    // Get the pixel data from the CGImage
    NSData *pixelData = (__bridge_transfer NSData *)CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    
    // Calculate the brightness level
    const UInt8 *pixelBytes = [pixelData bytes];
    CGFloat brightness = (CGFloat)(pixelBytes[0] + pixelBytes[1] + pixelBytes[2]) / (3.0 * 255.0);
    
    // Release the CGImage
    CGImageRelease(cgImage);
    
=======

    // Apply the CIAreaAverage filter to calculate the average color values
    CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage"];
    [filter setValue:ciImage forKey:kCIInputImageKey];

    // Retrieve the output image from the filter
    CIImage *outputImage = [filter outputImage];

    // Create a CIContext
    CIContext *context = [CIContext contextWithOptions:nil];

    // Create a CGRect representing the entire image
    CGRect extent = [outputImage extent];

    // Render the output image
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:extent];

    // Get the pixel data from the CGImage
    NSData *pixelData = (__bridge_transfer NSData *)CGDataProviderCopyData(CGImageGetDataProvider(cgImage));

    // Calculate the brightness level
    const UInt8 *pixelBytes = [pixelData bytes];
    CGFloat brightness = (CGFloat)(pixelBytes[0] + pixelBytes[1] + pixelBytes[2]) / (3.0 * 255.0);

    // Release the CGImage
    CGImageRelease(cgImage);

>>>>>>> main
    return brightness;
}


//While tapping logout button
-(IBAction)logoutClicked:(id)sender {
    
    //GalleryMode
<<<<<<< HEAD
    //self.siteData.addon_gallery_mode=@"FALSE";
=======
     //self.siteData.addon_gallery_mode=@"FALSE";
>>>>>>> main
    if(self.siteData.addon_gallery_mode.boolValue==TRUE){
        int countlimit = uploadCount  >= 50 ? uploadCount : self.siteData.RemainingImagecount;
        NSDictionary*dict;
        for(int i=0; i<self.ArrayofstepPhoto.count; i++){
            dict = [self.ArrayofstepPhoto objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;
            }
        }
        if (self.myimagearray.count < self.InstructCount || [[dict valueForKey: @"imageName"] isEqual: @""]) {
            //Multi_img_selector
<<<<<<< HEAD
            CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"multiPicker" bundle:Nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
            objPhotoViewController.strTitle = NSLocalizedString(@"Choose Photos",@"");
            objPhotoViewController.siteData = self.siteData;
            objPhotoViewController.delegate = self;
            objPhotoViewController.arySelectedPhoto = _arrImage;
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                objPhotoViewController.maxCount = 1;
            }else{
                objPhotoViewController.maxCount = (self.InstructCount - self.myimagearray.count);
            }
            objPhotoViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.navigationController presentViewController:navController animated:YES completion:nil];
            
            
            //Single image selection
            /* UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
             pickerView.allowsEditing = NO;
             pickerView.delegate = self;
             if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
             {
             imagepick = TRUE;
             pickimage = TRUE;
             pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
             pickerView.modalPresentationStyle = UIModalPresentationFullScreen;
             }
             [self presentViewController:pickerView animated:YES completion:nil];*/
=======
                CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"multiPicker" bundle:Nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
                objPhotoViewController.strTitle = NSLocalizedString(@"Choose Photos",@"");
                objPhotoViewController.siteData = self.siteData;
                objPhotoViewController.delegate = self;
                objPhotoViewController.arySelectedPhoto = _arrImage;
                if([[dict valueForKey: @"imageName"] isEqual: @""]){
                    objPhotoViewController.maxCount = 1;
                }else{
                    objPhotoViewController.maxCount = (self.InstructCount - self.myimagearray.count);
                }
                objPhotoViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self.navigationController presentViewController:navController animated:YES completion:nil];
                
            
                //Single image selection
               /* UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
                pickerView.allowsEditing = NO;
                pickerView.delegate = self;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    imagepick = TRUE;
                    pickimage = TRUE;
                    pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    pickerView.modalPresentationStyle = UIModalPresentationFullScreen;
                }
                [self presentViewController:pickerView animated:YES completion:nil];*/
>>>>>>> main
            
        }else{
            [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
        }
    }else{
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            if(WeAreRecording  == YES){
                [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Stop Video Recording To Logout.",@"") duration:3.0 position:CSToastPositionCenter];
                return;
            }
<<<<<<< HEAD
            
=======
           
>>>>>>> main
            if(self.parkLoadArray!=nil && self.parkLoadArray.count>0){
                if(self.parkLoadArray.count==1){
                    NSMutableDictionary *dict= [[self.parkLoadArray objectAtIndex:0] mutableCopy];
                    NSMutableArray *imgarr = [dict valueForKey:@"img"];
                    bool isAddon7Custom = [[self.parkLoad objectForKey:@"isAddon7Custom"]boolValue];
                    
                    if ([dict valueForKey:@"category"] || (imgarr.count > 0)) {
                        if(isAddon7Custom && ![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && imgarr.count == 0){
                            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                            [self.alertbox setHorizontalButtons:YES];
                            [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                            
                            [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                            
                            [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
                        }else{
                            [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:3.0 position:CSToastPositionCenter];
                            return;
                        }
                    }else{
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox setHorizontalButtons:YES];
                        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                        
                        [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                        
                        [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
                    }
                }else{
                    [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:3.0 position:CSToastPositionCenter];
                    return;
                }
            }else{
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                
                [self.alertbox showSuccess:NSLocalizedString(@"Logout",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
            }
        }else{
            [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout, Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter];
        }
    }
}


-(IBAction)signout:(id)sender {
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ismaster"];
<<<<<<< HEAD
    
=======

>>>>>>> main
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
    }
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    if([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE)){
        [self.view makeToast:NSLocalizedString( @"Server Under Maintenance",@"") duration:4.0 position:CSToastPositionCenter];
<<<<<<< HEAD
        
=======

>>>>>>> main
    }else {
        NSString *trackerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TrackId"];
        NSMutableDictionary *dictionary = [[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceTracker"] mutableCopy];
        NSMutableArray* deviceData = [dictionary valueForKey:@"device_offline_details"];
        if(dictionary != nil && trackerId != nil && ![trackerId isEqual:@"0"] && ![trackerId isEqual:@"0.0"]){
            [ServerUtility getdevice_tracker:(NSString *)trackerId withOfflinedata:(NSArray *) deviceData withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)latitude withlongi:(NSString *)longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
                
                if (!error) {
                    NSLog(@"Logout data:%@",@"done");
                }
            }];
        }
        [ServerUtility getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)latitude withlongi:(NSString *)longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
            
            if (!error) {
                NSLog(@"Logout data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"]){
                    
                    [self.alertbox hideView];
                    self.tapCount = 0;
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
                    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_name"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"timeZoneName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                    
                    // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
                    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                    [[AZCAppDelegate sharedInstance] clearAllLoads];
                }
            }
        }];
    }
}


//while taking photos
-(IBAction)takephoto:(id)sender
{
    [locationManager startUpdatingLocation];
    NSLog(@"lm:%@",locationManager);
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    self.btn_TakePhoto.layer.cornerRadius = 10;
    self.btn_TakePhoto.backgroundColor = UIColor.whiteColor;
    self.btn_TakePhoto.tintColor = UIColor.blackColor;
    self.videoBtn.tintColor = UIColor.whiteColor;
    self.videoBtn.backgroundColor = UIColor.clearColor;
    [self.imgBtn setHidden:YES];
    [self.startvideoBtn setHidden:YES];
    [self.progressBar setHidden:YES];
    [self.progressView setHidden:YES];
    [self.innervideoBtn setHidden:YES];
    [self.captureAction setHidden:NO];
<<<<<<< HEAD
    
=======
        
>>>>>>> main
    [zoomlbl setHidden:FALSE];
    [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
    zoomlbl.text = @"1.00 x";
    [_zoomSlider setValue:1];
    //[flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    //[flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    [self flashOff];
}

-(void) flashOff{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
<<<<<<< HEAD
            flashButton.tag=1;
            flashButton.text =NSLocalizedString(@"OFF",@"");
=======
            self.FlashButton.tag=1;
            [self.FlashButton setImage:[UIImage imageNamed:@"flash_new.png"] forState:UIControlStateNormal];

>>>>>>> main
            [flashLight setTorchMode:AVCaptureTorchModeOff];
            [flashLight unlockForConfiguration];
        }
    }
}

-(void)enableAfterSomeTime{
    [self.captureAction setEnabled:YES];
    [self.imgBtn setEnabled:YES];
}






//****************************************************
#pragma mark - Flash Methods
//****************************************************

//for flash
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash]) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            //evice.flashMode = flashMode;
            AVCapturePhotoSettings *_avSettings = [AVCapturePhotoSettings photoSettings];
            _avSettings.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}


- (IBAction)takeimageBtnClick:(id)sender {
    [self clickImageAction:sender ];
}


// blur_image_detection
- (float) detectBlur: (CGImageRef)iimage {
    NSLog(@"detectBlur: %@", iimage);
    // Initialize MTL
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    id<MTLCommandQueue> queue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
<<<<<<< HEAD
    
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    id<MTLTexture> sourceTexture = [textureLoader newTextureWithCGImage:iimage options:nil error:nil];
    
    
=======

    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    id<MTLTexture> sourceTexture = [textureLoader newTextureWithCGImage:iimage options:nil error:nil];


>>>>>>> main
    CGColorSpaceRef srcColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef dstColorSpace = CGColorSpaceCreateDeviceGray();
    CGColorConversionInfoRef conversionInfo = CGColorConversionInfoCreate(srcColorSpace, dstColorSpace);
    MPSImageConversion *conversion = [[MPSImageConversion alloc] initWithDevice:device
<<<<<<< HEAD
                                                                       srcAlpha:MPSAlphaTypeAlphaIsOne
                                                                      destAlpha:MPSAlphaTypeAlphaIsOne
                                                                backgroundColor:nil
                                                                 conversionInfo:conversionInfo];
=======
              srcAlpha:MPSAlphaTypeAlphaIsOne
              destAlpha:MPSAlphaTypeAlphaIsOne
              backgroundColor:nil
              conversionInfo:conversionInfo];
>>>>>>> main
    MTLTextureDescriptor *grayTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR16Unorm width:sourceTexture.width height:sourceTexture.height mipmapped:false];
    grayTextureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
    id<MTLTexture> grayTexture = [device newTextureWithDescriptor:grayTextureDescriptor];
    [conversion encodeToCommandBuffer:commandBuffer sourceTexture:sourceTexture destinationTexture:grayTexture];
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:grayTexture.pixelFormat width:sourceTexture.width height:sourceTexture.height mipmapped:false];
    textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
    id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];
<<<<<<< HEAD
    
    MPSImageLaplacian *imageKernel = [[MPSImageLaplacian alloc] initWithDevice:device];
    [imageKernel encodeToCommandBuffer:commandBuffer sourceTexture:grayTexture destinationTexture:texture];
    
=======

    MPSImageLaplacian *imageKernel = [[MPSImageLaplacian alloc] initWithDevice:device];
    [imageKernel encodeToCommandBuffer:commandBuffer sourceTexture:grayTexture destinationTexture:texture];

>>>>>>> main
    MPSImageStatisticsMeanAndVariance *meanAndVariance =[[MPSImageStatisticsMeanAndVariance alloc] initWithDevice:device];
    MTLTextureDescriptor *varianceTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR32Float width:2 height:1 mipmapped:NO];
    varianceTextureDescriptor.usage = MTLTextureUsageShaderWrite;
    id<MTLTexture> varianceTexture = [device newTextureWithDescriptor:varianceTextureDescriptor];
    [meanAndVariance encodeToCommandBuffer:commandBuffer sourceTexture:texture destinationTexture:varianceTexture];
<<<<<<< HEAD
    
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    
=======

    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

>>>>>>> main
    union {
        float f[2];
        unsigned char bytes[8];
    } u;
<<<<<<< HEAD
    
=======

>>>>>>> main
    MTLRegion region = MTLRegionMake2D(0, 0, 2, 1);
    [varianceTexture getBytes:u.bytes bytesPerRow:2 * 4 fromRegion:region mipmapLevel: 0];
    NSLog(@"mean: %f", u.f[0] * 255);
    float variance;
    variance = u.f[1] * 255 * 255;
    NSLog(@"variance:%f",variance);
    
    return variance;
}




- (void)camDenied
{
    NSLog(@"%@", @"Denied camera access");
    
    NSString *alertText;
    NSString *alertButton;
    
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings)
    {
        alertText =NSLocalizedString( @"It looks like your privacy settings are preventing us from accessing your camera to capyure image and video. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera/microPhone on.\n\n3. Open this app and try again.",@"");
        
        alertButton = NSLocalizedString(@"Go",@"");
    }
    else
    {
        alertText = NSLocalizedString(@"It looks like your privacy settings are preventing us from accessing your camera to capyure image and video. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera/microPhone on.\n\n5. Open this app and try again.",@"");
        
        alertButton = NSLocalizedString(@"OK",@"");
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Message",@"")
                          message:alertText
                          delegate:self
                          cancelButtonTitle:alertButton
                          otherButtonTitles:nil];
    alert.tag = 55;
    [alert show];
}




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 55)
    {
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}



- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"ApplicationEnterBackGround"])
        NSLog (@"Successfully received the test notification!");
    if(WeAreRecording  == YES )
    {
        NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
        NSString* myDocumentPath1= [pathToImageFolder stringByAppendingPathComponent:AudioName];
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath1 error:nil];
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.innervideoBtn setHidden:NO];
        [self.bottomView setHidden:NO];
        __weak typeof(self) weakSelf =self;
    }
}


-(IBAction)BlurImgClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Blur image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)btn_Reset:(id)sender
{
    if(![[self.parkLoad valueForKey:@"isParked"] isEqualToString:@"1"] && self.ParkloadImages.count == 0 && (self.myimagearray.count != 0 || self.nxt_clicked != 1)){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:NSLocalizedString(@"Reset",@"") target:self selector:@selector(reset_tapped) backgroundColor:Red];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking Reset button will delete all pictures in this Load.",@"") closeButtonTitle:nil duration:1.0f ];
    }
}


-(void)reset_tapped{
    //reset = true;
    //self.nxt_clicked = 1;
    self.nxt_clicked = 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
    self.selectedTab = 0;
    self.wholeStepsCount = 0;
    [self.ArrayofstepPhoto removeAllObjects];
    [self.myimagearray removeAllObjects];
    [self.parkLoad setValue:nil forKey:@"img"];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self Instruc];
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        //[self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    [self.collection_View reloadData];
}
-(NSString *)htmlEntityDecode:(NSString *)string
<<<<<<< HEAD
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

- (IBAction)previewButtonTapped:(id)sender {
    
    CapturePreviewScreenController *previewVC =[self.storyboard instantiateViewControllerWithIdentifier:@"CapturePreview"];
    
     previewVC.Image = self.DefaultImage.image;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Veruna clean" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    previewVC.videoURL = url;
    
    previewVC.preferredContentSize = CGSizeMake(414,600);
    
    previewVC.modalPresentationStyle = UIModalPresentationPopover;
=======
    {
        string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"

        return string;
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

-(IBAction)ViewButtonTapped:(id)sender {
    
    PreviewPopController *previewVC =[self.storyboard instantiateViewControllerWithIdentifier:@"Preview"];
    
    //previewVC.Image = "";
    
    //NSString *path = @"http://videocdn.bodybuilding.com/video/mp4/62000/62792m.mp4";
    NSString *path = self.InstructFile;
    //NSURL *url = [NSURL fileURLWithPath:path];
    previewVC.videourl = path;
   
    previewVC.preferredContentSize = self.previewScreensize;
    
    previewVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
>>>>>>> main
    
    UIPopoverPresentationController *popoverController = previewVC.popoverPresentationController;
    popoverController.sourceView = self.view;
    popoverController.delegate = self;
<<<<<<< HEAD
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 100, 0, 300);
    popoverController.permittedArrowDirections = 0;
    self.view.alpha = 0.5;
    [self presentViewController:previewVC animated:YES completion:nil];
}

- (void)dismissPreviewScreen {
    [self dismissViewControllerAnimated:YES completion:^{
        // Reset the alpha property of the capture screen to make it fully visible
        self.view.alpha = 1.0;
    }];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // Return NO to prevent dismissal when tapping outside the popover.
    return YES;
}
=======
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds)-20, CGRectGetMidY(self.view.bounds) - 100, 0, 300);
    popoverController.permittedArrowDirections = 0;
    popoverController.backgroundColor = UIColor.clearColor;
   [self presentViewController:previewVC animated:YES completion:nil];
    
}

>>>>>>> main

//popup view
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
<<<<<<< HEAD

=======
>>>>>>> main
