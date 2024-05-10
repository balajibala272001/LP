//
//  Looping_Camera_ViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 26/09/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import "Looping_Camera_ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CollectionViewCell.h"
#import "StaticHelper.h"
#import "PicViewController.h"
#import "PicViewController.h"
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
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "CreolePhotoSelection.h"
#import "GalleryLoopViewController.h"
#import "LoopingViewController.h"
#import "selectedTab.h"

@interface Looping_Camera_ViewController ()<CreolePhotoSelectionDelegate> {
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
    NSMutableArray *ThumbArray;
    NSMutableArray *URLArray;
    NSMutableDictionary *recordSetting;
    NSInteger currentLoadNumber;
    UILabel *flashButton, *flashLabel, *zoomlbl;
    AZCAppDelegate *delegateVC;
    bool cameraboolToRestrict;
    bool hasAddon8;
    ServerUtility * imge;
    NSString *checkBlur;
}

-(UIImage *)generateThumbImage : (NSString *)filepath;
@end

@implementation Looping_Camera_ViewController
int countLimit = 325;
int loopScreenOrientation = 0;

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

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************
- (IBAction)flashToggle:(id)sender{
    [self flash];
}

-(void) flash{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success){
            if (flashButton.tag == 1) {
                flashButton.tag=0;
                flashButton.text = NSLocalizedString(@"ON",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }else if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text = NSLocalizedString(@"OFF",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            [flashLight unlockForConfiguration];
        }
    }
}

- (void)viewDidLoad {
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    AZCAppDelegate *delegatee = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.IsiteId = delegatee.userProfiels.instruct.sitee_Id;

    cameraboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    NSLog(@"cameraboolToRestrict:%d",cameraboolToRestrict);
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];

    ThumbArray = [[NSMutableArray alloc]init];
    URLArray = [[NSMutableArray alloc]init];
    countLimit = self.siteData.uploadCount;
    // countLimit = 10;
    self.tapCount = 0; 
    SiteData *sitesssClass = delegate.siteDatas;
    int networkid = sitesssClass.networkId;
    NSLog(@"the selected site:%@",sitesssClass.siteName);
    
    //Checking_add0n8
    hasAddon8 = FALSE;
    for (int index=0; index<sitesssClass.categoryAddon.count; index++) {
        Add_on * dict = [sitesssClass.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            hasAddon8 = TRUE;
        }
    }
    self.instruction_number = [[[NSUserDefaults standardUserDefaults] valueForKey:@"img_instruction_number"]intValue];
    self.currentTappiCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"current_Looping_Count"]intValue];
    
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"IOSVersion %@",iOSVersion);
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    self.myimagearray = [[NSMutableArray alloc]init];
    self.loopImagearray = [[self.parkLoad objectForKey:@"img"]mutableCopy];
   
    if (!(self.myimagearray.count > 0)) {
        self.myimagearray = [[NSMutableArray alloc]init];
    }
    self.tapCount =  self.loopImagearray.count;
    [self.myimagearray removeAllObjects];
    [self.myimagearray removeAllObjects];
    if(self.selectedTab == nil){
        NSLog(@"self.loopImagearray:%@",self.loopImagearray);
        for(int i=0; i<self.loopImagearray.count;i++){
            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
            int valuee = [[newdict objectForKey:@"img_numb"]intValue];
            if(self.currentTappiCount == valuee){
                [self.myimagearray addObject:newdict];
                [self.collection_View reloadData];
                NSLog(@"self.myimagearray:%@",self.myimagearray);
            }
        }
    }else{
        NSLog(@"self.loopImagearray:%@",self.loopImagearray);
        for(int i=0; i<self.loopImagearray.count;i++){
            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
            int valuee = [[newdict objectForKey:@"img_numb"]intValue];
            if(self.selectedTab.selectedTab == valuee){
                [self.myimagearray addObject:newdict];
                [self.collection_View reloadData];
                NSLog(@"self.myimagearray:%@",self.myimagearray);
            }
        }
    }
    PlanName = sitesssClass.planname;
    delegate.PlanName = PlanName;
    self.firstTime = YES;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [super viewDidLoad];
  
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
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    //flash mode
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![flashLight isTorchAvailable]){
        flashButton.hidden = true;
    }

    if ([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
        flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10, 300, 30)];
        flashButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        flashButton.textColor = [UIColor whiteColor];
        flashButton.textAlignment = NSTextAlignmentLeft;
        flashButton.text =NSLocalizedString(@"OFF",@"");
        flashButton.tag=1;
        flashButton.userInteractionEnabled=TRUE;
        [self.imageforcapture addSubview:flashButton];
    
        flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 30)];
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
        //flashLabel. = UIControlContentHorizontalAlignmentLeft;
    }
    //flash mode
        
    //Corner radius for button
    self.btn_Next.layer.cornerRadius = 10;
    
    self.btn_Next.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:189/255.0 alpha:1.0].CGColor;
    self.btn_Logout.layer.cornerRadius = 10;
    
    self.btn_Logout.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    
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
    NSLog(@"PlanName:%@",PlanName);
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
    } else {
        // impossible, unknown authorization status
    }
   
    if([self.siteData.planname isEqual:@"FreeTier"]){
        if (countLimit >= 100) {
            countLimit = 100;
        }else if(countLimit>0){

        }else if(countLimit==0 && self.siteData.RemainingVideocount>0){
            int a=self.siteData.RemainingVideocount;
            countLimit= a;
        }else{
            [self.view makeToast:NSLocalizedString(@"Maximum Limit for Uploading Mediafiles is Reached, Kindly Upgrade This Site to Continue.",@"") duration:3.0 position:CSToastPositionCenter];
        }
    }
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
    

    //ZoomFeature
    //if(([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  && cameraboolToRestrict  == FALSE){
        
        NSString *model=[UIDevice currentDevice].model;
        [zoomlbl setHidden:FALSE];
        [_zoomSlider setHidden:FALSE];
        [_zoomSlider addTarget:self action:@selector(scaleOfview:) forControlEvents:UIControlEventValueChanged];
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
        
        _zoomSlider.transform = trans;
        if ([model isEqualToString:@"iPhone"]){
            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.80), (previewLayer.frame.size.height*0.25), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
            
        }else if([model isEqualToString:@"iPad"]){
            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.85), (previewLayer.frame.size.height*0.30), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
        }else{
            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.55), (previewLayer.frame.size.height*0.20), (previewLayer.frame.size.height*0.10),(previewLayer.frame.size.height*0.50));
        }
    
        [_zoomSlider setMinimumValue:1];
        [_zoomSlider setMaximumValue:4];
        
        CGFloat c = _zoomSlider.frame.origin.y + _zoomSlider.frame.size.height;
        CGFloat d = _zoomSlider.frame.size.width/2;
        zoomlbl =[[UILabel alloc] initWithFrame:CGRectMake(_zoomSlider.frame.origin.x + d - 25,c, 50,30)];
        zoomlbl.adjustsFontSizeToFitWidth = YES;
        zoomlbl.text = @"1.0 x";
        [zoomlbl setTextColor:paleBlue];
        [self.imageforcapture addSubview:zoomlbl];
        [self.imageforcapture bringSubviewToFront:zoomlbl];
        [self.imageforcapture bringSubviewToFront:_zoomSlider];

    //}else{
      //  [_zoomSlider setHidden:TRUE];
      //  [zoomlbl setHidden:TRUE];
   // }
    //self.siteData.addon_gallery_mode=@"TRUE";
    //GalleryMode
    if(self.siteData.addon_gallery_mode.boolValue==TRUE)
        [self.btn_Logout setImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
    else
         [self.btn_Logout setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    
//    if(self.siteData.images_error_type != NULL){
//        checkBlur = self.siteData.images_error_type;
//          //[self.view makeToast:checkBlur duration:2.0 position:CSToastPositionCenter];
//      }
    //NSString *slat =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLat"];
    //NSString *slan =[[NSUserDefaults standardUserDefaults] objectForKey:@"timeZoneLon"];
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
}

- (void)handleDeviceMotionUpdate:(CMDeviceMotion *)motion {
    double x = motion.gravity.x;
    double y = motion.gravity.y;

    // Determine the device orientation based on the gravity values
    if (fabs(y) >= fabs(x)) {
        if (y >= 0.0) {
            // Device is in portrait orientation
            NSLog(@"Portrait");
            loopScreenOrientation = 0;
        } else {
            // Device is in portrait upside-down orientation
            NSLog(@"Portrait Upside Down");
            loopScreenOrientation = 0;
        }
    } else {
        if (x >= 0.0) {
            // Device is in landscape right orientation
            NSLog(@"Landscape Right");
            loopScreenOrientation = 270;
        } else {
            // Device is in landscape left orientation
            NSLog(@"Landscape Left");
            loopScreenOrientation = 90;
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
//                [self.view makeToast:name duration:2.0 position:CSToastPositionCenter];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"timeZoneName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
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

-(IBAction)scaleOfview:(id)sender{
    
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
   
    if(WeAreRecording  == YES){
        [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
        return;
    }else{
        NSDictionary*dict;
        for(int i=0; i<self.loopImagearray.count; i++){
            dict = [self.loopImagearray objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;
            }
        }
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            if(![self.parkLoad valueForKey:@"category"] && self.currentTappiCount == 0 && self.instruction_number == 0 && (self.loopImagearray.count > 0)){
                
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
        
            }else if(self.currentTappiCount == 0 && self.instruction_number == 0){
                if([[self.parkLoad valueForKey:@"isParked"] isEqualToString:@"1"]){
                    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
                    for(NSUInteger i = array.count - 1; i>=0 ; i--) {
                        NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                        if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
                            [self.navigationController popToViewController:array[i] animated:true];
                            break;
                        }else {
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
                }else if(self.loopImagearray.count == 0){
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
                        }else {
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
                }else{
                    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                    [self.alertbox setHorizontalButtons:YES];
                    [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                    
                    [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
                    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
                }
            }else if(self.currentTappiCount > 0 && self.instruction_number > 0){
                
                NSLog(@"self.currentTappiCount:%d",self.currentTappiCount);
                self.currentTappiCount = self.currentTappiCount-1;
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.currentTappiCount] forKey:@"current_Looping_Count"];
                NSLog(@"self.instruction_number:%d",self.instruction_number);
                self.instruction_number = self.instruction_number-1;
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_instruction_number"];
                
                LoopingViewController *loopingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loopingVC"];
                loopingVC.tappi_count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"tappi_count"]intValue];
                loopingVC.siteData = self.siteData;
                loopingVC.arrayOfImagesWithNotes = self.loopImagearray;
                loopingVC.sitename = self.siteName;
                loopingVC.image_quality = self.siteData.image_quality;
                loopingVC.isEdit = self.isEdit;
                [self.navigationController pushViewController:loopingVC animated:YES];
                
            }else{
                NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
                for(NSUInteger i = array.count - 1; i>=0 ; i--) {
                    NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                    if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
                        [self.navigationController popToViewController:array[i] animated:true];
                        break;
                    }else {
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
        }
    }
}

-(IBAction)deleteLoad:(id)sender{
    
    [self.alertbox hideView];
    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"tappicount"];
    [self.parkLoadArray removeObjectAtIndex:currentLoadNumber];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
        // Format the current date time to match the format of
        // the photo's metadata timestamp strings
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"location string:%@",stringFromDate);
        // Add the location as a value in the location NSMutableDictionary
        // while using the formatted current datetime as its key
        // _location = stringFromDate;
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
}


-(void)handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
=======
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(30,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(210,12,16,16)];
>>>>>>> main
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(195,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(-10,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,0, 180, 40)];
=======
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(220,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 0, 169, 40)];
    }else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 170, 40)];
    }
>>>>>>> main
    titleLabel.text = self.siteName;
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
<<<<<<< HEAD
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 245, 40)];
=======
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 255, 40)];
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
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(230,8,25,25)];
>>>>>>> main
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
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
    //parkload icon
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && self.parkLoadArray.count == 1){
        parkloadIcon.hidden = YES;
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
        stat= NSLocalizedString(@"LoadProof Cloud is Offline, proceed with Parkloads.",@"");
    }else if ([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Online, proceed with the uploads.",@"");
    }else{
        stat= NSLocalizedString(@"Network Not Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
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
     
    long a = self.parkLoadArray.count;
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
        a--;
    }
     NSString *stat = @(a).stringValue;
     NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
     
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox setHideTitle:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
 }

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Screen_Freezing_issue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![session isRunning])
            {
                [session startRunning];
            }
    });

    NSLog(@"loopImagearray_before:%@",self.loopImagearray);
    if(self.myimagearray == nil){
        for(int i=0; i<self.loopImagearray.count;i++){
            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
            int valuee = [[newdict objectForKey:@"img_numb"]intValue];
            if(self.currentTappiCount == valuee){
                [self.myimagearray addObject:newdict];
                [self.collection_View reloadData];
            }
        }
    }
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"CameraVC";
    [[NSUserDefaults standardUserDefaults] setValue:@"CameraVC" forKey:@"CurrentVC"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSLog(@"myimagearray_before:%@",self.myimagearray);

    for (int i=0; i<self.myimagearray.count; i++) {
        dic = [self.myimagearray objectAtIndex:i];
        NSString *name = [dic valueForKey:@"imageName"];
        NSString* Path1= [pathToImageFolder stringByAppendingPathComponent:name];
        NSLog(@"Path1:%@",Path1);
        if(![[NSFileManager defaultManager] fileExistsAtPath:Path1])
        {
           // [self.myimagearray removeObject:dic];
        }
    }
    NSLog(@"myimagearray_after:%@",self.myimagearray);
    [super viewWillAppear:animated];
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.collection_View reloadData];

    NSLog(@"%f",self.view.frame.size.height * 0.09);
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    if(self.startvideoBtn.isHidden == YES && self.innervideoBtn.hidden == YES){
        if(delegate.isEnterForegroundCamera == YES)
        {
            delegate.isEnterForegroundCamera = NO;
            [self.view makeToast: NSLocalizedString(@"Tap to Take Pictures",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
        }
    }
    if(self.startvideoBtn.isHidden == NO){
        if(delegate.isEnterForegroundVideo == YES )
        {
            delegate.isEnterForegroundVideo = NO;
            [self.view makeToast: NSLocalizedString(@"Tap On Video Icon To Record",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
        }
    }
    if(self.startvideoBtn.isHidden == YES){
        
        [zoomlbl setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
    }
    [flashLabel setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
    [flashButton setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
<<<<<<< HEAD
    
=======
    [self.btn_Logout setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
   
>>>>>>> main
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
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
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

-(void)viewWillDisappear:(BOOL)animated {

    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound){
        self.tapCount = 0 ;
        [session stopRunning];
    }
    
    [self.alertbox hideView];
    [super viewWillDisappear:animated];
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
<<<<<<< HEAD
    WeAreRecording = NO;
=======
>>>>>>> main
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if(flashButton.tag == 0){
                flashButton.tag = 1;
                flashButton.text =NSLocalizedString( @"OFF",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            [flashLight unlockForConfiguration];
        }
    }
<<<<<<< HEAD
=======
    if(WeAreRecording == YES){
        WeAreRecording = NO;
        [self stopTimer];
        [self stoprecording];
    }
>>>>>>> main
}


-(void) configureToCapturePhoto
{
    session = [[AVCaptureSession alloc]init];
    [session beginConfiguration];
    
    avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([avCaptureDevice lockForConfiguration:&error]) {
//        float zoomFactor = avCaptureDevice.activeFormat.videoZoomFactorUpscaleThreshold;
        [avCaptureDevice setVideoZoomFactor:1.0];
        [avCaptureDevice unlockForConfiguration];
    }
    
    //increase camera brightness
    if ([avCaptureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
          NSError *error = nil;
          if ([avCaptureDevice lockForConfiguration:&error]) {
              [avCaptureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
              [avCaptureDevice setExposureTargetBias:0.5 completionHandler:nil]; // Increase this value to make the image brighter
              [avCaptureDevice unlockForConfiguration];
          } else {
              NSLog(@"Error: %@", error);
          }
      }
    
    [Looping_Camera_ViewController setFlashMode:AVCaptureFlashModeAuto forDevice:avCaptureDevice];
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
    CGRect frame = _imageforcapture.bounds;
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    StillImageOutput = [[AVCapturePhotoOutput alloc]init];
    AVCapturePhotoSettings *_avSettings = [AVCapturePhotoSettings photoSettings];
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
    
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 100;        //Total seconds
    int32_t preferredTimeScale = 1;    //Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);
    //<<SET MAX DURATION//
    MovieFileOutput.maxRecordedDuration = maxDuration;
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    //<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
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
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC]forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [session startRunning];
}

#pragma mark - Notification
#pragma mark - Collection View Delagate Methods
//data source and delegates method


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.loopImagearray.count == 0) {
        CGFloat cellWidth = self.collection_View.frame.size.height;
        
        int totalimg = self.view.frame.size.width/cellWidth;
        
        CGFloat balanceSpace = self.view.frame.size.width - (totalimg * cellWidth);
        
        if(balanceSpace > 20){
            totalimg += 1;
        }
        return totalimg;
    }
    else
    {
        NSString *model=[UIDevice currentDevice].model;
        
        int count=3;
        if ([model isEqualToString:@"iPad"]) {
            count=4;
        }
<<<<<<< HEAD
        if(self.loopImagearray.count <count)
        {
            return count;
        }else{
            return self.loopImagearray.count;
=======
        if(self.myimagearray.count <count)
        {
            return count;
        }else{
            return self.myimagearray.count;
>>>>>>> main
        }
    }
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
    }else{
        if (self.myimagearray.count < indexPath.row + 1){
            
            Cell.image_View.image = [UIImage imageNamed:@"Placeholder.png"];
            Cell.waterMark_lbl.text = @"";
            [Cell.delete_btn setHidden:YES];
            [Cell.videoicon setHidden:YES];
            [Cell.low_light setHidden:YES];
            [Cell.blur_img setHidden:YES];
        }else{
            NSDictionary *adict =[self.myimagearray objectAtIndex:indexPath.row];
            NSString* imageName = [adict valueForKey: @"imageName"];
            if([[adict valueForKey: @"imageName"] isEqual: @""]){
                
                Cell.image_View.image = [UIImage imageNamed:@"missing_img.png"];
                [Cell.videoicon setHidden:YES];
                [Cell.low_light setHidden:YES];
                [Cell.blur_img setHidden:YES];
                [Cell.delete_btn setHidden:YES];
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
                // [Cell.delete_btn addTarget:self action:Nil forControlEvents:UIControlEventTouchUpInside];
                //[Cell.delete_btn setTag:indexPath.row];
            }
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
        }
    }
    return Cell;
}


-(UIImage *)generateThumbImage : (NSString *)filepath{
    
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
//while tapping X delete symbol to delete the picture


-(IBAction)delete:(id)sender {
    
    if(WeAreRecording == YES){
        [self.view makeToast:NSLocalizedString(@"Cannot Delete File While Recording Video.",@"") duration:2.0 position:CSToastPositionCenter];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    //myimagearray
    NSDictionary* myimagedict = [self.myimagearray objectAtIndex:btn.tag];
    NSLog(@"myimagedict:%@",myimagedict);
    NSString* imageName = [myimagedict valueForKey:@"imageName"];
    NSString *path = [[AZCAppDelegate.sharedInstance getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    NSString* imagePath = [path stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    [self.myimagearray removeObjectAtIndex:btn.tag];
    NSLog(@"myimagearray:%@",self.myimagearray);
    
    //RemovingfromMainArray - loopingArray
    int index = 0;
    long arr_time = [[myimagedict objectForKey:@"created_Epoch_Time"]intValue];
    int instr_numb =[[myimagedict objectForKey:@"img_numb"]intValue];
    for(int i=0; i<self.loopImagearray.count; i++){
        NSDictionary*dicto = [self.loopImagearray objectAtIndex:i];
        long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
        int instr_numb_dict =[[dicto objectForKey:@"img_numb"]intValue];
        if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }
    [self.loopImagearray removeObjectAtIndex:index];
    NSLog(@"loopImagearray:%@",self.loopImagearray);
    self.tapCount =(int)self.loopImagearray.count;
    NSLog(@" the delete array is :%@",self.loopImagearray);
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
    [self.parkLoad setObject:self.loopImagearray forKey:@"img"];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collection_View reloadData];
}


//while tapping next button
-(IBAction)btn_NextTapped:(id)sender{
    
    int inte = [[[NSUserDefaults standardUserDefaults] valueForKey:@"tappi_count"]intValue];
    if(self.tapCount == countLimit && (self.currentTappiCount == 0 || self.currentTappiCount <= inte-2)){

        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor:Blue];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Plan Limit Reached. No Image count available for next Tappi.",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:1.0f ];
    }else{
        ServerUtility * imge = [[ServerUtility alloc] init];
        imge.picslist = self.loopImagearray;
        [self.parkLoad setObject:self.loopImagearray forKey:@"img"];
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary*dict;
        for(int i=0; i<self.loopImagearray.count; i++){
            dict = [self.loopImagearray objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;
            }
        }
        if(WeAreRecording == YES ){
            [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
            return;
        }
        //NSLog(@"self.siteData.looping_metadata:%@",self.siteData.looping_metadata);
        if(self.loopImagearray.count == 0 || self.myimagearray.count == 0){
            [self.view makeToast:NSLocalizedString(@"Take Atleast 1 Media file ",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            if([[dict valueForKey: @"imageName"] isEqual: @""] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"CameraVC"]){
                [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
            }else{
                GalleryLoopViewController *GalleryLoopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
                
                GalleryLoopVC.imageArray = self.loopImagearray;
                GalleryLoopVC.siteData = self.siteData;
                GalleryLoopVC.sitename = self.siteName;
                GalleryLoopVC.pathToImageFolder = pathToImageFolder;
                
                [self.navigationController pushViewController:GalleryLoopVC animated:YES];
            }
//            else{
//
//                if ([checkBlur.lowercaseString isEqualToString:@"error"] || [checkBlur.lowercaseString isEqualToString:@"warning"]) {
//                    int blurPos = -1;
//                    int lowLightPos = -1;
//                    NSMutableString * blurMesg;
//                    NSMutableString * lowLightMesg;
//                    for(int y= 0; y < self.myimagearray.count; y++){
//                        NSMutableDictionary * dic =[self.myimagearray objectAtIndex:y];
//                        NSString* IsLowLight = [dic valueForKey:@"brightness"];
//                        NSString* variance = [dic valueForKey:@"variance"];
//                        if ([variance isEqualToString:@"TRUE"]) {
//                            if(blurPos == -1){
//                                [blurMesg appendFormat:@"%d", y+1];
//                            }else{
//                                [blurMesg appendFormat:@", %d", y+1];
//                            }
//                            blurPos = y;
//                        }
//                        if ([IsLowLight isEqualToString:@"TRUE"]) {
//                            if(lowLightPos == -1){
//                                [lowLightMesg appendFormat:@"%d", y+1];
//                            }else{
//                                [lowLightMesg appendFormat:@", %d", y+1];
//                            }
//                            lowLightPos = y;
//                        }
//                    }
//                    if(blurPos > -1){
//                        [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"blur"];
//                        return;
//                    }
//                    if(lowLightPos > -1){
//                        [self blurAlertPopup: blurMesg withsecond: lowLightMesg withthird: @"lowLight"];
//                        return;
//                    }
//                }
//                GalleryLoopViewController *GalleryLoopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
//
//                GalleryLoopVC.imageArray = self.loopImagearray;
//                GalleryLoopVC.siteData = self.siteData;
//                GalleryLoopVC.sitename = self.siteName;
//                GalleryLoopVC.pathToImageFolder = pathToImageFolder;
//
//                [self.navigationController pushViewController:GalleryLoopVC animated:YES];
//            }
        }
    }
}


//Blur_popup
-(void) blurAlertPopup: (NSMutableString *) blurCount withsecond:(NSMutableString *) lowLight withthird:(NSString *) type {
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    UIView* viewImg=[[UIView alloc]init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    imageView.image = [UIImage imageNamed:@"backward.png"];
    [viewImg addSubview:imageView];
    [self.alertbox addCustomView: viewImg];
    [self.alertbox addButton:NSLocalizedString(@"Retake",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    if(![checkBlur.lowercaseString isEqualToString:@"error"]){
        [self.alertbox addButton:NSLocalizedString(@"Skip",@"") target:self selector:@selector(blurPopupContinue:) backgroundColor:Green];
        self.alertbox.title = NSLocalizedString(@"Warning!",@"");
        if([type isEqualToString:@"blur"]){
            [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
            [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Low light image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }
    }else{
        self.alertbox.title = @"Error";
        if([type isEqualToString:@"blur"]){
            [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Blur image",@"" ) closeButtonTitle:nil duration:1.0f ];
        }else {
            [self.alertbox showSuccess: NSLocalizedString(@"Error",@"") subTitle: NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
        }
    }
}

-(IBAction)blurPopupContinue:(id)sender{
   
    [self.alertbox hideView];
    GalleryLoopViewController *GalleryLoopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
    
    GalleryLoopVC.imageArray = self.loopImagearray;
    GalleryLoopVC.siteData = self.siteData;
    GalleryLoopVC.sitename = self.siteName;
    GalleryLoopVC.pathToImageFolder = pathToImageFolder;
    
    [self.navigationController pushViewController:GalleryLoopVC animated:YES];
}


//multi_img_picker
-(void)getSelectedPhoto:(NSMutableArray *)aryPhoto{
    
    [locationManager startUpdatingLocation];
    //Initlize array
    _arrImage = nil;
    _arrImage = [NSMutableArray new];
    _arrImage = [aryPhoto mutableCopy];
    NSLog(@"info:%@",_arrImage);

    int pos = 0;
    NSString* imagePath;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    for (NSDictionary *dict in _arrImage){
        @autoreleasepool{
            
            //size_conversion
            self.tapCount ++;
            NSLog(@"tapCount:%d",self.tapCount);
            pos ++;
            NSLog(@"size_conversion:%d",pos);
            UIImage *chosenImage =[dict valueForKey:@"mainImage"];
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch+pos];
            NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
            NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
            NSString* imageName = [NSString stringWithFormat:@"%@_%@_%d.jpg",UDID,epochTime,pos];
            NSLog(@"imageName:%@",imageName);
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
                //CGFloat widthh = chosenImage.size.width;
                //CGFloat heightt = chosenImage.size.height;
                CGSize imageSize;
                //UIImage *resizedImage;
                NSLog(@"Image Quality :%@",self.siteData.image_quality);
                if ([self.siteData.image_quality isEqual:@"1"]) {
                    //if(widthh != 720 && heightt != 1080){
                    imageSize = CGSizeMake(720,1080);
                    UIGraphicsBeginImageContext(imageSize);
                    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    //}
                }else{
                    //if(widthh != 1440 && heightt != 2160){
                    imageSize = CGSizeMake(1440,2160);
                    UIGraphicsBeginImageContext(imageSize);
                    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    //}
                }
                [UIImageJPEGRepresentation(chosenImage,1) writeToFile:imagePath atomically:true];
                [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [myimagedict setObject:imageName forKey:@"imageName"];
                //if(self.selectedTab == nil){
                    [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
                //}
                int epochTimeInt = [epochTime intValue] + pos;
                NSNumber * newTime = [NSNumber numberWithInt:epochTimeInt];
                [myimagedict setObject:newTime forKey:@"created_Epoch_Time"];
                [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
                [myimagedict setObject:latitude forKey:@"latitude"];
                [myimagedict setObject:longitude forKey:@"longitude"];
                NSString *islowlight=@"FALSE";
                [myimagedict setObject:islowlight forKey:@"brightness"];
                [myimagedict setObject:@"FALSE" forKey:@"variance"];
                //finding_index
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
                if(self.selectedTab != nil){
                    [myimagedict setObject:[dicto objectForKey:@"img_numb"] forKey:@"img_numb"];
                    [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                }else{
                    [self.myimagearray addObject:myimagedict];
                }
                if(self.selectedTab != nil){
                    for(int i=0; i<self.loopImagearray.count;i++){
                        NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
                        if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                            [myimagedict setObject:[newdict objectForKey:@"img_numb"] forKey:@"img_numb"];
                            [self.loopImagearray replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:index]];
                        }
                    }
                }else{
                    [self.loopImagearray addObject:myimagedict];
                }
//                NSLog(@"myimagearray:%@",self.myimagearray);
            }else {
                PHAsset *asset = dict[@"assest"];
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestImageDataForAsset:asset
                                                              options:requestOptions
                                                        resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
                                     {
                    CGImageSourceRef imgSrc = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
                    NSString *uti = (NSString*)CGImageSourceGetType(imgSrc);
                    if([uti containsString:@"heif"] || [uti containsString:@"hevc"] || [uti containsString:@"heic"]
                       || [uti containsString:@"HEIF"] || [uti containsString:@"HEVC"] || [uti containsString:@"HEIC"]){
                        UIImage *image = [UIImage imageWithData:imageData];
                        NSData *jpegImageData = UIImageJPEGRepresentation(image, 0.8);
                        [jpegImageData writeToFile:imagePath atomically:true];
                        NSLog(@"SizeofImagehevc(bytes):%lu",(unsigned long)[jpegImageData length]);
                    }else {
                        NSLog(@"SizeofImagejpeg(bytes):%lu",(unsigned long)[imageData length]);
                        [imageData writeToFile:imagePath atomically:true];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [myimagedict setObject:imageName forKey:@"imageName"];
                    //if(self.selectedTab == nil){
                        [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
                    //}
                    int epochTimeInt = [epochTime intValue] + pos;
                    NSNumber * newTime = [NSNumber numberWithInt:epochTimeInt];
                    [myimagedict setObject:newTime forKey:@"created_Epoch_Time"];
                    [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
                    [myimagedict setObject:self->latitude forKey:@"latitude"];
                    [myimagedict setObject:self->longitude forKey:@"longitude"];
                    NSString *islowlight=@"FALSE";
                    [myimagedict setObject:islowlight forKey:@"brightness"];
                    [myimagedict setObject:@"FALSE" forKey:@"variance"];
                    //finding_index
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
                    if(self.selectedTab != nil){
                        [myimagedict setObject:[dicto objectForKey:@"img_numb"] forKey:@"img_numb"];
                        [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                    }else{
                        [self.myimagearray addObject:myimagedict];
                    }
                    if(self.selectedTab != nil){
                        for(int i=0; i<self.loopImagearray.count;i++){
                            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
                            if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                                [myimagedict setObject:[newdict objectForKey:@"img_numb"] forKey:@"img_numb"];
                                [self.loopImagearray replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:index]];
                            }
                        }
                    }else{
                        [self.loopImagearray addObject:myimagedict];
                    }
                }];
            }
          
            [self.collection_View reloadData];
            ServerUtility * imge = [[ServerUtility alloc] init];
            imge.picslist = _loopImagearray;
            [[NSUserDefaults standardUserDefaults]setObject:_loopImagearray forKey:@"picslist"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"loopImagearray: %@", self.loopImagearray);
            NSLog(@"loopImagearray.length: %lu", (unsigned long)self->_loopImagearray.count);
            _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            NSInteger item = self.myimagearray.count-2;//[self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
<<<<<<< HEAD
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
=======
            NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
            if(![langStr isEqualToString:@"Arabic"] && ![langStr isEqualToString:@"Urdu"]){
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
>>>>>>> main
            [self.parkLoad setObject:self.loopImagearray forKey: @"img"];
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if(self.selectedTab != nil){
        GalleryLoopViewController *GalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
        GalleryVC.imageArray = self.loopImagearray;
        GalleryVC.siteData = self.siteData;
        GalleryVC.sitename = self.siteName;
        GalleryVC.pathToImageFolder = pathToImageFolder;
        
        [self.navigationController pushViewController:GalleryVC animated:YES];
    }
}
                    


//While tapping logout button
-(IBAction)logoutClicked:(id)sender {
    //GalleryMode
    //self.siteData.addon_gallery_mode=@"FALSE";
    if(self.siteData.addon_gallery_mode.boolValue==TRUE){
        if(WeAreRecording  == YES )
        {
            [self.view makeToast:NSLocalizedString(@"Cannot Open Gallery File While Recording Video.",@"") duration:2.0 position:CSToastPositionCenter];
            return;
        }else{
            int countlimit = countLimit  >= 50 ? countLimit : self.siteData.RemainingImagecount;
            NSDictionary*dict;
            for(int i=0; i<self.loopImagearray.count; i++){
                dict = [self.loopImagearray objectAtIndex:i];
                if([[dict valueForKey: @"imageName"] isEqual: @""]){
                    break;
                }
            }
            if (self.myimagearray.count <= self.loopImagearray.count || [[dict valueForKey: @"imageName"] isEqual: @""]) {
                
                //Multi_img_selector
                CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"multiPicker" bundle:Nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
                objPhotoViewController.strTitle = NSLocalizedString(@"Choose Photos",@"");
                objPhotoViewController.siteData = self.siteData;
                objPhotoViewController.delegate = self;
                objPhotoViewController.arySelectedPhoto = _arrImage;
                if([[dict valueForKey: @"imageName"] isEqual: @""]){
                    objPhotoViewController.maxCount = 1;
                }else{
//                    objPhotoViewController.maxCount = (countLimit - self.loopImagearray.count);
                    long balanceLimit = (countLimit - self.loopImagearray.count);
                    if(balanceLimit > 30 && [self.siteData.image_quality isEqual:@"4"]){
                        objPhotoViewController.maxCount = 30;
                    }else {
                        objPhotoViewController.maxCount = @(balanceLimit).intValue;
                    }
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
                
            }else{
                [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
            }
        }
    }else{
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            if(WeAreRecording  == YES ){
                [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Stop Video Recording To Logout.",@"") duration:3.0 position:CSToastPositionCenter];
                return;
            }
            if(self.parkLoadArray!=nil && self.parkLoadArray.count>0){
                if(self.parkLoadArray.count==1 ){
                    NSMutableDictionary *dict= [[self.parkLoadArray objectAtIndex:0] mutableCopy];
                    NSMutableArray *imgarr = [dict valueForKey:@"img"];
                    if ([dict valueForKey:@"category"] || (imgarr.count > 0)) {
                        [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:3.0 position:CSToastPositionCenter];
                        return;
                    }else{
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox setHorizontalButtons:YES];
                        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                        
                        [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                        
                        [self.alertbox showSuccess:NSLocalizedString(@"LogOut",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
                    }
                }else{
                    [self.view makeToast:NSLocalizedString(@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed",@"") duration:3.0 position:CSToastPositionCenter];
                    return;
                }
            }else{
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
                
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(signout:) backgroundColor:Red];
                
                
                [self.alertbox showSuccess:NSLocalizedString(@"LogOut",@"") subTitle:NSLocalizedString(@"Are you sure you want to Logout ?",@"") closeButtonTitle:nil duration:1.0f ];
                
            }
            
            
        }else{
            [self.view makeToast:NSLocalizedString(@"Network is Offline.\n To Logout, Kindly Connect With Internet.",@"") duration:2.0 position:CSToastPositionCenter];
        }
    }
}


-(IBAction)signout:(id)sender {
    
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
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
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
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
-(IBAction)takephoto:(id)sender{
    
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
    [self.btn_Logout setHidden:NO];
>>>>>>> main
    [zoomlbl setHidden:FALSE];
    [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
            zoomlbl.text = @"1.00 x";
    [_zoomSlider setValue:1];
    [flashLabel setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
    [flashButton setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
    [self flashOff];
}

-(void) flashOff{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            flashButton.tag=1;
            flashButton.text = NSLocalizedString(@"OFF",@"");
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

- (IBAction)VideoButtonClickAction:(id)sender {
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([inputDevice lockForConfiguration:&error]) {
        [inputDevice setVideoZoomFactor:1.0];
        [inputDevice unlockForConfiguration];
    }

    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    if(delegate.isEnterForegroundVideo == YES )
    {
        delegate.isEnterForegroundVideo = NO;
        [self.view makeToast:  NSLocalizedString(@"Tap On Video Icon To Record",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
        //[self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
    }
    
    
    BOOL count =  [self VideoCount];
    if (count == NO) {
        return;
    }
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
        dispatch_async(dispatch_get_main_queue(), ^{
            [self VideoAcess];
        });
    } else if(authStatus == AVAuthorizationStatusDenied){
        // denied
        dispatch_async(dispatch_get_main_queue(), ^{
            [self camDenied];
        });
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        return;
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self VideoAcess];
                });
            } else {
                return;
                
            }
        }];
    } else {
        // impossible, unknown authorization status
    }
    
    
}
-(void)VideoAcess
{
    NSDictionary*dict;
    for(int i=0; i<self.loopImagearray.count; i++){
        dict = [self.loopImagearray objectAtIndex:i];
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            break;
        }
    }
    //if (self.myimagearray.count < self.loopImagearray.count ) {
    if (self.loopImagearray.count < countLimit || [[dict valueForKey: @"imageName"] isEqual: @""]) {
        
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.innervideoBtn setHidden:NO];
        [self.captureAction setHidden:YES];
<<<<<<< HEAD
=======
        [self.btn_Logout setHidden:YES];
>>>>>>> main
        self.videoBtn.layer.cornerRadius = 10;
        self.btn_TakePhoto.backgroundColor = UIColor.clearColor;
        self.btn_TakePhoto.tintColor = UIColor.whiteColor;
        self.videoBtn.backgroundColor = UIColor.whiteColor;
        self.videoBtn.tintColor = UIColor.blackColor;
        [zoomlbl setHidden:TRUE];
        
        //if ([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"]) {
        [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        //}
        [flashLabel setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
        [flashButton setHidden:self.videoBtn.backgroundColor == UIColor.whiteColor];
    }
    else{
        [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    
    if(delegate.isEnterForegroundVideo == YES  && WeAreRecording)
    {
        [self.view makeToast:NSLocalizedString(@"Saving Video Failed +5",@"")];
        [self videorecorderexception];
        return;
    }
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter 123456");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        //----- RECORDED SUCESSFULLY -----

        [self MergeAfterSomeTime];
 
        // UISaveVideoAtPathToSavedPhotosAlbum(myString, nil, nil, nil);
    }
}


- (IBAction)takeimageBtnClick:(id)sender {
    
    int countlimit;
    if([PlanName  isEqual:@"Bronze"]||[PlanName  isEqual:@"Freemium"]){
        countlimit = countLimit  >= 40 ? countLimit : self.siteData.RemainingImagecount;
    }else{
        countlimit = countLimit  >= 50 ? countLimit : self.siteData.RemainingImagecount;
    }
    if (self.loopImagearray.count < countlimit) {
        [self clickImageAction:sender ];
    }
    else{
        [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

- (IBAction)startVideoBtnClick:(id)sender {
    WeAreRecording = NO;
    [self stoprecording];
   [self.view makeToast:@"Saving Video Failed +2"];
}

-(void)stoprecording
{
    NSLog(@"STOP RECORDING");
    [self stopTimer];
    [MovieFileOutput stopRecording];
    [recorder stop];
    [audiosession setActive:NO error:nil];
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text =NSLocalizedString( @"OFF",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
                
            [flashLight unlockForConfiguration];
        }
    }
}

-(void)MergeAfterSomeTime{
    
    NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
    NSString* myDocumentPath1= [pathToImageFolder stringByAppendingPathComponent:AudioName];
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath1])
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            WeAreRecording = YES;
            [self mergeTwoVideo];
        }
    }
}


-(void)startTimer {
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer {
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

-(void)timerFired:(NSTimer *)timer
{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSTimeInterval remainingTime = timecount - elapsedTime;
    CGFloat timeRemain = remainingTime;
    NSLog(@"%f timerFired", remainingTime);
    int value = (int)timeRemain;
    self.timeLbl.text = [NSString stringWithFormat:@"00.%02d", value];
    //float val = 31.0 - (1.0 * timeRemain / 31.0);
    self.progressBar.value = 1.0 - (1.0 * timeRemain / 31.0);
    if (remainingTime < 0.0 || remainingTime == 0.0) {
        WeAreRecording = NO;
        self.timeLbl.text = [NSString stringWithFormat:@"00.00"];
        [self.progressBar setValue:1.0f];
        [self.progressView setHidden:NO];
        [self stoprecording];
        return;
    }
}


- (IBAction)clickImageAction:(id)sender {
    
    [locationManager startUpdatingLocation];
    if(self.selectedTab != nil){
        for(int i=0; i<self.loopImagearray.count;i++){
            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
            if([[newdict objectForKey:@"imageName"] isEqual:@""] ){
                int instr_numb = [[newdict objectForKey:@"img_numb"]intValue];
                [self.captureAction setEnabled:NO];
                [self.imgBtn setEnabled:NO];
                //hiding for camera improper numbering
                AVCaptureConnection *videoConnection  = nil;
                for(AVCaptureConnection *connection in StillImageOutput.connections)
                {
                    for(AVCaptureInputPort *port in  [connection inputPorts])
                    {
                        if([[port mediaType] isEqual:AVMediaTypeVideo]){
                            videoConnection =connection;
                            break;
                        }
                    }
                }
                // Capture a still photo
                AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
                [StillImageOutput capturePhotoWithSettings:photoSettings delegate:self];
                
//                [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
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
//
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
//                            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
//                        }else{
//                            imageSize = CGSizeMake(1440,2160);
//                            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
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
//                    if(self.selectedTab == nil){
//                        [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
//                    }
//                    [myimagedict setObject:imageName forKey:@"imageName"];
//                    //[myimagedict setObject: forKey:@"index"];
//                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
//                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
//                    [myimagedict setObject:latitude forKey:@"latitude"];
//                    [myimagedict setObject:longitude forKey:@"longitude"];
//                    NSString *islowlight = brightnessValue<=-1?@"TRUE":@"FALSE";
//                    [myimagedict setObject:islowlight forKey:@"brightness"];
//
//                    NSLog(@"pics %@",pics);
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
//                        [myimagedict setObject:@"FALSE" forKey:@"variance"];
//                    }
//                    //
//                    NSMutableDictionary*dicto;
//                    int index = 0;
//                    for(int i=0; i<self.myimagearray.count; i++){
//                        dicto = [[self.myimagearray objectAtIndex:i]mutableCopy];
//                        //long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
//                        //long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
//                        if([[dicto objectForKey:@"imageName"] isEqual:@""]){
//                            //[self.imageArray replaceObjectAtIndex:i withObject:dict];
//                            index = i;
//                            NSLog(@"index:%d",index);
//                            break;
//                        }
//                    }
//                    if(self.selectedTab != nil){
//                        [myimagedict setObject:[newdict objectForKey:@"img_numb"] forKey:@"img_numb"];
//                        [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
//                    }else{
//                        [self.myimagearray addObject:myimagedict];
//                    }
//                    NSLog(@" the taken photo is:%@",self.myimagearray);
//                    //reloading the collection view
//                    [self.collection_View reloadData];
//                    NSLog(@"my %@",myimagedict);
//                    imge.picslist =self.myimagearray;
//                    [[NSUserDefaults standardUserDefaults]setObject:self.myimagearray forKey:@"picslist"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    NSLog(@"my2 %@",imge.picslist);
//                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, countLimit];
//
//
//                    if(self.selectedTab != nil){
//                        for(int i =0; i<self.loopImagearray.count; i++){
//                            NSDictionary * newdict = [[NSDictionary alloc]init];
//                            newdict = [self.loopImagearray objectAtIndex:i];
//                            if([[newdict objectForKey:@"img_numb"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
//                            {
//                                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
//                                    [self.loopImagearray replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:index]];
//                                }
//                            }
//                        }
//                        [self.parkLoad setObject:self.loopImagearray forKey:@"img"] ;
//                        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//                        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        [self btn_NextTapped:self.view];
//                        }
//                    }
//                }];
            }
        }
    }else{
        int countlimit;
        if([PlanName isEqual:@"Bronze"]||[PlanName  isEqual:@"Freemium"]){
            countlimit = countLimit  >= 40 ? countLimit : self.siteData.RemainingImagecount;
        }else{
            countlimit = countLimit  >= 50 ? countLimit : self.siteData.RemainingImagecount;
        }
        if (self.loopImagearray.count < countlimit) {
            self.tapCount ++;
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
//            [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
//                if (imageDataSampleBuffer!=NULL) {
//                    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//                    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
//                    CFRelease(metadataDict);
//                    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
//                    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
//                    NSLog(@"Brightness value: %f",brightnessValue);
//
//                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//
//                    UIImage *capturedImage = [UIImage imageWithData:imageData];
//                    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
//                    UIImage *resizedImage;
//                    if(![self.siteData.image_quality isEqual:@"4"]){
//                        CGImageRef takenCGImage = capturedImage.CGImage;
//                        size_t width = CGImageGetWidth(takenCGImage);
//                        size_t height = CGImageGetHeight(takenCGImage);
//                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
//
//                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
//
//                        capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
//                        CGImageRelease(cropCGImage);
//
//                        UIGraphicsBeginImageContext(capturedImage.size);
//                        [capturedImage drawAtPoint:CGPointZero];
//                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
//                        UIGraphicsEndImageContext();
//
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
//                    NSString *UDID = [[NSUserDefaults standardUserDefaults]
//                                      stringForKey:@"identifier"];
//                    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
//                    NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
//                    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
//                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [myimagedict setObject:imageName forKey:@"imageName"];
//                    if(hasAddon8){
//                        [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
//                    }
//                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
//                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
//                    [myimagedict setObject:latitude forKey:@"latitude"];
//                    [myimagedict setObject:longitude forKey:@"longitude"];
//
//                    NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
//                    [myimagedict setObject:islowlight
//                                    forKey:@"brightness"];
//                    NSLog(@"pics %@",pics);
//                    CGImageRef iimage = [resizedImage CGImage];
//                    if (@available(iOS 12, *)) {
//                        NSString *model=[UIDevice currentDevice].model;
//                        float target=2.0; //ipod
//                        if ([model isEqualToString:@"iPad"]) {
//                            target=12.0;
//                        }else if([model isEqualToString:@"iPhone"]){
//                            target=7.0;
//                        }
//                        [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE"
//                                        forKey:@"variance"];
//                    }else{
//                        [myimagedict setObject:@"FALSE" forKey:@"variance"];
//                    }
//                    NSLog(@" the taken photo is:%@",self.loopImagearray);
//                    [self.myimagearray addObject:myimagedict];
//                    [self.loopImagearray addObject:myimagedict];
//                    NSLog(@"myimagearray:%@",self.myimagearray);
//                    NSLog(@" the taken photo is:%@",self.loopImagearray);
//
//                    //reloading the collection view
//                    [self.collection_View reloadData];
//                    ServerUtility * imge = [[ServerUtility alloc] init];
//                    NSLog(@"my %@",myimagedict);
//                    imge.picslist = _loopImagearray;
//                    [[NSUserDefaults standardUserDefaults]setObject:_loopImagearray forKey:@"picslist"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    NSLog(@"my2 %@",imge.picslist);
//                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
//                    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
//                    NSInteger item = self.myimagearray.count-2;//[self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
//                    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//                    [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//
//                    [self.parkLoad setObject:self.loopImagearray forKey:@"img"] ;
//                    if(self.parkLoadArray.count != 0){
//                        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//                    }
//                    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
//                [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
//            }];
            NSLog(@"the array count is :%lu",(unsigned long)self
                  .loopImagearray.count);
            NSLog(@" taps occured%d",self.tapCount);
            //[locationManager stopUpdatingLocation];
        }else{
            [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
        }
    }
//    [self.parkLoad setObject:self.loopImagearray forKey:@"img"];
//    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
//    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    //     Process or display the captured image
    //                    NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    
    //UIImage *capturedImage = [self increaseImageClarity:image];
    
    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
    //self.siteData.image_quality = @"4";
    UIImage *resizedImage;
    float brightnessValue = [self calculateBrightnessLevelOfImage:capturedImage];
    
    if(self.selectedTab != nil){
        for(int i =0; i<self.loopImagearray.count; i++){
            NSDictionary * newdict = [[NSDictionary alloc]init];
            newdict = [self.loopImagearray objectAtIndex:i];
//            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
//            {
                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    UIImage *resizedImage ;
                    if(![self.siteData.image_quality isEqual:@"4"]){

                        CGImageRef takenCGImage = capturedImage.CGImage;
                        size_t width = CGImageGetWidth(takenCGImage);
                        size_t height = CGImageGetHeight(takenCGImage);
                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                        //capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                        if(loopScreenOrientation == 90){
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                        }else{
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + loopScreenOrientation];
                        }
                        CGImageRelease(cropCGImage);
                        UIGraphicsBeginImageContext(capturedImage.size);
                        [capturedImage drawAtPoint:CGPointZero];
                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        //REducing the captured image size
                        CGSize imageSize;
                        NSLog(@"Image Quality :%@",self.siteData.image_quality);
                        if(loopScreenOrientation == 90 || loopScreenOrientation == 270){
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
                        UIGraphicsBeginImageContext(imageSize);
                        [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                    }else{
                        CGImageRef takenCGImage = capturedImage.CGImage;
                        size_t width = CGImageGetWidth(takenCGImage);
                        size_t height = CGImageGetHeight(takenCGImage);
                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                        if(loopScreenOrientation == 90){
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                        }else{
                            capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + loopScreenOrientation];
                        }
                        resizedImage = capturedImage;
                    }
                    //OLD CODE END
                    //int x = arc4random() % 100;
                    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
                    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
                    NSString*imagePath=[pathToImageFolder stringByAppendingPathComponent:imageName];
                    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
                    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if(self.selectedTab == nil){
                        [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
                    }
                    [myimagedict setObject:imageName forKey:@"imageName"];
                    //[myimagedict setObject: forKey:@"index"];
                    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
                    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
                    [myimagedict setObject:latitude forKey:@"latitude"];
                    [myimagedict setObject:longitude forKey:@"longitude"];
                    NSString *islowlight = brightnessValue<=0.15?@"TRUE":@"FALSE";
                    [myimagedict setObject:islowlight forKey:@"brightness"];
                    
                    NSLog(@"pics %@",pics);
                    
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
                        [myimagedict setObject:@"FALSE" forKey:@"variance"];
                    }
                    //
                    NSMutableDictionary*dicto;
                    int index = 0;
                    for(int i=0; i<self.myimagearray.count; i++){
                        dicto = [[self.myimagearray objectAtIndex:i]mutableCopy];
                        //long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
                        //long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
                        if([[dicto objectForKey:@"imageName"] isEqual:@""]){
                            //[self.imageArray replaceObjectAtIndex:i withObject:dict];
                            index = i;
                            NSLog(@"index:%d",index);
                            break;
                        }
                    }
                    if(self.selectedTab != nil){
                        [myimagedict setObject:[newdict objectForKey:@"img_numb"] forKey:@"img_numb"];
                        [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
                    }else{
                        [self.myimagearray addObject:myimagedict];
                    }
                    NSLog(@" the taken photo is:%@",self.myimagearray);
                    //reloading the collection view
                    [self.collection_View reloadData];
                    NSLog(@"my %@",myimagedict);
                    imge.picslist =self.myimagearray;
                    [[NSUserDefaults standardUserDefaults]setObject:self.myimagearray forKey:@"picslist"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    NSLog(@"my2 %@",imge.picslist);
                    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, countLimit];
                    
                    
                    if(self.selectedTab != nil){
                        for(int i =0; i<self.loopImagearray.count; i++){
                            NSDictionary * newdict = [[NSDictionary alloc]init];
                            newdict = [self.loopImagearray objectAtIndex:i];
                            if([[newdict objectForKey:@"img_numb"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                            {
                                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                                    [self.loopImagearray replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:index]];
                                }
                            }
                        }
                        [self.parkLoad setObject:self.loopImagearray forKey:@"img"] ;
                        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self btn_NextTapped:self.view];
                    }
                    
                }
//            }
        }
    }else {
            UIImage *resizedImage;
            if(![self.siteData.image_quality isEqual:@"4"]){
                CGImageRef takenCGImage = capturedImage.CGImage;
                size_t width = CGImageGetWidth(takenCGImage);
                size_t height = CGImageGetHeight(takenCGImage);
                CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);

                CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);

                //capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                if(loopScreenOrientation == 90){
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                }else{
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + loopScreenOrientation];
                }
                CGImageRelease(cropCGImage);

                UIGraphicsBeginImageContext(capturedImage.size);
                [capturedImage drawAtPoint:CGPointZero];
                capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                CGSize imageSize;
                NSLog(@"Image Quality :%@",self.siteData.image_quality);
                if(loopScreenOrientation == 90 || loopScreenOrientation == 270){
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
                UIGraphicsBeginImageContext(imageSize);
                [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }else{
                CGImageRef takenCGImage = capturedImage.CGImage;
                size_t width = CGImageGetWidth(takenCGImage);
                size_t height = CGImageGetHeight(takenCGImage);
                CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                if(loopScreenOrientation == 90){
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:UIImageOrientationUp];
                }else{
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation + loopScreenOrientation];
                }
                resizedImage =capturedImage;
            }
            //OLD CODE END
            //int x = arc4random() % 100;
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
            NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
            NSString *UDID = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"identifier"];
            NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
            NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
            [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
            [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myimagedict setObject:imageName forKey:@"imageName"];
            if(hasAddon8){
                [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
            }
            [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
            [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
            [myimagedict setObject:latitude forKey:@"latitude"];
            [myimagedict setObject:longitude forKey:@"longitude"];

            NSString *islowlight=brightnessValue<=0.15?@"TRUE":@"FALSE";
            [myimagedict setObject:islowlight
                            forKey:@"brightness"];
            NSLog(@"pics %@",pics);
            CGImageRef iimage = [resizedImage CGImage];
            if (@available(iOS 12, *)) {
                NSString *model=[UIDevice currentDevice].model;
                float target=2.0; //ipod
                if ([model isEqualToString:@"iPad"]) {
                    target=100.0;
                }else if([model isEqualToString:@"iPhone"]){
                    target=100.0;
                }
                [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE"
                                forKey:@"variance"];
            }else{
                [myimagedict setObject:@"FALSE" forKey:@"variance"];
            }
            NSLog(@" the taken photo is:%@",self.loopImagearray);
            [self.myimagearray addObject:myimagedict];
            [self.loopImagearray addObject:myimagedict];
            NSLog(@"myimagearray:%@",self.myimagearray);
            NSLog(@" the taken photo is:%@",self.loopImagearray);
            
            //reloading the collection view
            [self.collection_View reloadData];
            ServerUtility * imge = [[ServerUtility alloc] init];
            NSLog(@"my %@",myimagedict);
            imge.picslist = _loopImagearray;
            [[NSUserDefaults standardUserDefaults]setObject:_loopImagearray forKey:@"picslist"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"my2 %@",imge.picslist);
            _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            NSInteger item = self.myimagearray.count-2;//[self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//            [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            [self.parkLoad setObject:self.loopImagearray forKey:@"img"] ;
            if(self.parkLoadArray.count != 0){
                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            }
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
        [self.parkLoad setObject:self.loopImagearray forKey:@"img"];
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
<<<<<<< HEAD
    if(self.myimagearray.count > 4){
        // Calculate the content offset to scroll to the end
        CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
        // Make sure the contentOffset doesn't go below 0
        contentOffsetX = MAX(0, contentOffsetX + 150);
        // Scroll to the calculated content offset
        [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
=======
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
>>>>>>> main
    }
}

- (CGFloat)calculateBrightnessLevelOfImage:(UIImage *)image {
    // Convert the UIImage to CIImage
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];

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

    return brightness;
}


//Blur-Detector
- (float) detectBlur: (CGImageRef)iimage {
    
    NSLog(@"detectBlur: %@", iimage);
    // Initialize MTL
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    id<MTLCommandQueue> queue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    id<MTLTexture> sourceTexture = [textureLoader newTextureWithCGImage:iimage options:nil error:nil];
    CGColorSpaceRef srcColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef dstColorSpace = CGColorSpaceCreateDeviceGray();
    CGColorConversionInfoRef conversionInfo = CGColorConversionInfoCreate(srcColorSpace, dstColorSpace);
    MPSImageConversion *conversion = [[MPSImageConversion alloc] initWithDevice:device
          srcAlpha:MPSAlphaTypeAlphaIsOne
          destAlpha:MPSAlphaTypeAlphaIsOne
          backgroundColor:nil
          conversionInfo:conversionInfo];
    MTLTextureDescriptor *grayTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR16Unorm width:sourceTexture.width height:sourceTexture.height mipmapped:false];
      grayTextureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
      id<MTLTexture> grayTexture = [device newTextureWithDescriptor:grayTextureDescriptor];
      [conversion encodeToCommandBuffer:commandBuffer sourceTexture:sourceTexture destinationTexture:grayTexture];
      MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:grayTexture.pixelFormat width:sourceTexture.width height:sourceTexture.height mipmapped:false];
      textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
      id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];
      MPSImageLaplacian *imageKernel = [[MPSImageLaplacian alloc] initWithDevice:device];
      [imageKernel encodeToCommandBuffer:commandBuffer sourceTexture:grayTexture destinationTexture:texture];

      MPSImageStatisticsMeanAndVariance *meanAndVariance =[[MPSImageStatisticsMeanAndVariance alloc] initWithDevice:device];
      MTLTextureDescriptor *varianceTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR32Float width:2 height:1 mipmapped:NO];
      varianceTextureDescriptor.usage = MTLTextureUsageShaderWrite;
      id<MTLTexture> varianceTexture = [device newTextureWithDescriptor:varianceTextureDescriptor];
      [meanAndVariance encodeToCommandBuffer:commandBuffer sourceTexture:texture destinationTexture:varianceTexture];
      [commandBuffer commit];
      [commandBuffer waitUntilCompleted];
      union {
          float f[2];
          unsigned char bytes[8];
      } u;
      MTLRegion region = MTLRegionMake2D(0, 0, 2, 1);
      [varianceTexture getBytes:u.bytes bytesPerRow:2 * 4 fromRegion:region mipmapLevel: 0];
      NSLog(@"mean: %f", u.f[0] * 255);
      float variance;
      variance = u.f[1] * 255 * 255;
      NSLog(@"variance:%f",variance);
      return variance;
}



- (IBAction)innerVideoButtonAction:(id)sender {
    BOOL count =  [self VideoCount];
    if (count == NO) {
        return;
    }
    NSDictionary*dict;
    for(int i=0; i<self.loopImagearray.count; i++){
        dict = [self.loopImagearray objectAtIndex:i];
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            break;
        }
    }
    if (self.loopImagearray.count < countLimit || [[dict valueForKey: @"imageName"] isEqual: @""]) {
        if(![[dict valueForKey: @"imageName"] isEqual: @""]){
            self.tapCount ++;
        }
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:NO];
        [self.progressBar setHidden:NO];
        [self.progressView setHidden:YES];
        [self.timeLbl setHidden:NO];
        [self.innervideoBtn setHidden:YES];
        [self.bottomView setHidden:YES];
        self.timeLbl.text = @"00.30";
        self.progressBar.value = 0;
        if (!WeAreRecording)
        {
            [locationManager startUpdatingLocation];
            //----- START RECORDING -----
            NSLog(@"START RECORDING");
            WeAreRecording = YES;
            timecount = 31.0;
            startDate = [NSDate date];
            [self startTimer];
            //Create temporary URL to record to
            UIGraphicsEndImageContext();
            int x = arc4random() % 100;
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
            NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
            NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
            videoName = imageName;
            NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
            
            NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:imagePath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:imagePath])
            {
                NSError *error;
                if ([fileManager removeItemAtPath:imagePath error:&error] == NO)
                {
                    //Error - handle if requried
                }
            }
            
            //Start recording
            [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
            // Audio record
            NSString* imageName1 = [NSString stringWithFormat:@"%@_%@.m4a",UDID,epochTime];
            
            NSString* imagePath1 = [pathToImageFolder stringByAppendingPathComponent:imageName1];
            AudioName = imageName1;
            NSURL *outputURL1 = [[NSURL alloc] initFileURLWithPath:imagePath1];
            recorder = [[AVAudioRecorder alloc] initWithURL:outputURL1 settings:recordSetting error:NULL];
            recorder.delegate = self;
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [audiosession setActive:YES error:nil];
            [recorder record];
        }
    }
    else{
        [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
    }
}



-(BOOL)VideoCount
{
    if([PlanName isEqualToString:@"Gold"]||[PlanName isEqualToString:@"Freemium"]||[PlanName isEqualToString:@"Silver"]||[PlanName isEqualToString:@"Bronze"])
    {
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToImageFolder error:NULL];
        NSMutableArray *extentionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.loopImagearray) {
            NSString *name = [dic valueForKey:@"imageName"];
            NSString *extension = [name pathExtension];
            if([extension isEqualToString:@"mp4"])
            {
                [extentionArray addObject:extension];
            }
        }
        if (extentionArray.count > 1 || extentionArray.count == 1) {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:NSLocalizedString(@"Information",@"") subTitle:NSLocalizedString(@"Maximum Video Limit has been Reached, Kindly Upgrade to Record More Videos",@"") closeButtonTitle:nil duration:1.0f ];
<<<<<<< HEAD
=======
            //[zoomlbl setHidden:NO];
            zoomlbl.text = @"1.00 x";
            [_zoomSlider setValue:1];
>>>>>>> main
            return NO;
        }else{
            return YES;
        }
    }
    else  if([PlanName isEqualToString:@"Platinum"])
    {
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToImageFolder error:NULL];
        NSMutableArray *extentionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.loopImagearray) {
            NSString *name = [dic  valueForKey:@"imageName"];
            NSString *extension = [name  pathExtension];
            if([extension isEqualToString:@"mp4"])
            {
                [extentionArray addObject:extension];
            }
        }
        if (extentionArray.count == 3 || extentionArray.count > 3) {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:NSLocalizedString(@"Information",@"") subTitle:NSLocalizedString(@"Maximum Video Limit has been Reached.",@"") closeButtonTitle:nil duration:1.0f ];
<<<<<<< HEAD
=======
            //[zoomlbl setHidden:NO];
            zoomlbl.text = @"1.00 x";
            [_zoomSlider setValue:1];
>>>>>>> main
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}


- (void) mergeTwoVideo
{
<<<<<<< HEAD
    NSString* video= [pathToImageFolder stringByAppendingPathComponent:videoName];
    NSURL *vedioURL = [NSURL fileURLWithPath:video];
    NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
    NSURL *audioURL = [NSURL fileURLWithPath:audio];
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:vedioURL options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime time = audioAsset.duration;
    double durationInSeconds = CMTimeGetSeconds(time);
    if(durationInSeconds != 0)
    {
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]atTime:kCMTimeZero error:nil];
    }
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime time1 = videoAsset.duration;
    double durationInSeconds1 = CMTimeGetSeconds(time1);
    if(durationInSeconds1 != 0)
    {
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]atTime:kCMTimeZero error:nil];
    }
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(-1*compositionVideoTrack.naturalSize.height/2, 0.0);
    [videolayerInstruction setTransform:CGAffineTransformRotate(translateToCenter, M_PI/2) atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:compositionVideoTrack.asset.duration];
    
    //    3.
    AVMutableVideoCompositionInstruction *videoCompositionInstrution = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    videoCompositionInstrution.timeRange = CMTimeRangeMake(kCMTimeZero, compositionVideoTrack.asset.duration);
    videoCompositionInstrution.layerInstructions = @[videolayerInstruction];
    
    //    4.
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize =  CGSizeMake(compositionVideoTrack.naturalSize.width, compositionVideoTrack.naturalSize.height);
    
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //    videoComposition.renderScale
    videoComposition.instructions = [NSArray arrayWithObject:videoCompositionInstrution];
    
    NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
    NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    NSString* myDocumentPath1= [pathToImageFolder stringByAppendingPathComponent:@"video.mp4"];
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
    }
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough] ;
    exporter.outputURL=url;
    exporter.outputFileType = @"com.apple.quicktime-movie";
    exporter.shouldOptimizeForNetworkUse = YES;
    @try {
        exporter.videoComposition = videoComposition;
    }
    @catch (NSException * __unused exception) {
        [self videorecorderexception];
        return ;
    }
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"status:%ld",(long)[exporter status]);

        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
            {
                [self videorecorderexception];
                NSLog(@"FAIL");
                __weak typeof(self) weakSelf =self;
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
                break;
            case AVAssetExportSessionStatusCancelled:
                [self videorecorderexception];
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"COMPLETE");
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
                    NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
                    [self videoCut:myDocumentPath audio:audio];
                });
            }
                break;
            default:
                break;
        }
    }];
=======
    @try{
        NSString* video= [pathToImageFolder stringByAppendingPathComponent:videoName];
        NSURL *vedioURL = [NSURL fileURLWithPath:video];
        NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
        NSURL *audioURL = [NSURL fileURLWithPath:audio];
        AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
        AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:vedioURL options:nil];
        AVMutableComposition* mixComposition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        CMTime time = audioAsset.duration;
        double durationInSeconds = CMTimeGetSeconds(time);
        if(durationInSeconds != 0)
        {
            [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]atTime:kCMTimeZero error:nil];
        }
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        CMTime time1 = videoAsset.duration;
        double durationInSeconds1 = CMTimeGetSeconds(time1);
        if(durationInSeconds1 != 0)
        {
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]atTime:kCMTimeZero error:nil];
        }
        AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(-1*compositionVideoTrack.naturalSize.height/2, 0.0);
        [videolayerInstruction setTransform:CGAffineTransformRotate(translateToCenter, M_PI/2) atTime:kCMTimeZero];
        [videolayerInstruction setOpacity:0.0 atTime:compositionVideoTrack.asset.duration];
        
        //    3.
        AVMutableVideoCompositionInstruction *videoCompositionInstrution = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        videoCompositionInstrution.timeRange = CMTimeRangeMake(kCMTimeZero, compositionVideoTrack.asset.duration);
        videoCompositionInstrution.layerInstructions = @[videolayerInstruction];
        
        //    4.
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.renderSize =  CGSizeMake(compositionVideoTrack.naturalSize.width, compositionVideoTrack.naturalSize.height);
        
        videoComposition.frameDuration = CMTimeMake(1, 30);
        //    videoComposition.renderScale
        videoComposition.instructions = [NSArray arrayWithObject:videoCompositionInstrution];
        
        NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
        NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
        NSString* myDocumentPath1= [pathToImageFolder stringByAppendingPathComponent:@"video.mp4"];
        if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        }
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough] ;
        exporter.outputURL=url;
        exporter.outputFileType = @"com.apple.quicktime-movie";
        exporter.shouldOptimizeForNetworkUse = YES;
        @try {
            exporter.videoComposition = videoComposition;
        }
        @catch (NSException * __unused exception) {
            [self videorecorderexception];
            return ;
        }
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            NSLog(@"status:%ld",(long)[exporter status]);
            
            switch ([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [self videorecorderexception];
                    NSLog(@"FAIL");
                    __weak typeof(self) weakSelf =self;
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    [self videorecorderexception];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"COMPLETE");
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
                        NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
                        [self videoCut:myDocumentPath audio:audio];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }@catch(NSException *ex){
        NSLog(@"aaa");
    }
>>>>>>> main
}


-(void) videorecorderexception
{
    __weak typeof(self) weakSelf =self;
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    [self.view makeToast:NSLocalizedString(@"Saving Video Failed +1",@"")];
    WeAreRecording = NO;
    [self stoprecording];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.innervideoBtn setHidden:NO];
        [self.bottomView setHidden:NO];
    });
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



- (void)videoCut:(NSString *)path audio:(NSString *)audiopath{
<<<<<<< HEAD
    //    1.
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audiopath]];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack  *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack  *compositionTrack1 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *error = nil;
    
    NSArray *tracks = asset.tracks;
    NSLog(@"Track:%@\n",tracks);
    [compositionTrack setPreferredTransform:[[asset tracksWithMediaType:AVMediaTypeVideo].firstObject preferredTransform]];
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject atTime:kCMTimeZero error:&error];
    [compositionTrack1 setPreferredTransform:[[asset tracksWithMediaType:AVMediaTypeAudio].firstObject preferredTransform]];
    [compositionTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:&error];
    //    2.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack];
    CGAffineTransform translateToCenter= CGAffineTransformMakeTranslation(compositionTrack.naturalSize.height , 0.0 );
    [videolayerInstruction setTransform:CGAffineTransformRotate(translateToCenter, M_PI/2) atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:compositionTrack.asset.duration];
    
    //    3.
    AVMutableVideoCompositionInstruction *videoCompositionInstrution = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    videoCompositionInstrution.timeRange = CMTimeRangeMake(kCMTimeZero, compositionTrack.asset.duration);
    videoCompositionInstrution.layerInstructions = @[videolayerInstruction];
    
    //    4.
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize =  CGSizeMake(compositionTrack.naturalSize.height, compositionTrack.naturalSize.width);
    
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //    videoComposition.renderScale
    videoComposition.instructions = [NSArray arrayWithObject:videoCompositionInstrution];
    
    //    5.
    AVAssetExportSession *exportSesstion = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    UIGraphicsEndImageContext();
    int x = arc4random() % 100;
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];

    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
    NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
    videoName = imageName;
    NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
    exportSesstion.outputURL = [NSURL fileURLWithPath:imagePath];
    exportSesstion.outputFileType = @"com.apple.quicktime-movie";
    exportSesstion.shouldOptimizeForNetworkUse = YES;
    exportSesstion.videoComposition = videoComposition;
    
    [exportSesstion exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = exportSesstion.status;
        if (status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"Complete");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self SaveVideo];
            });
            
        }else{
            [self videorecorderexception];
            __weak typeof(self) weakSelf =self;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSLog(@"Error--%@",exportSesstion.error);
        }
    }];
=======
    @try{
        //    1.
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
        AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audiopath]];
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack  *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack  *compositionTrack1 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        NSError *error = nil;
        
        NSArray *tracks = asset.tracks;
        NSLog(@"Track:%@\n",tracks);
        [compositionTrack setPreferredTransform:[[asset tracksWithMediaType:AVMediaTypeVideo].firstObject preferredTransform]];
        [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject atTime:kCMTimeZero error:&error];
        [compositionTrack1 setPreferredTransform:[[asset tracksWithMediaType:AVMediaTypeAudio].firstObject preferredTransform]];
        [compositionTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:&error];
        //    2.
        AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack];
        CGAffineTransform translateToCenter= CGAffineTransformMakeTranslation(compositionTrack.naturalSize.height , 0.0 );
        [videolayerInstruction setTransform:CGAffineTransformRotate(translateToCenter, M_PI/2) atTime:kCMTimeZero];
        [videolayerInstruction setOpacity:0.0 atTime:compositionTrack.asset.duration];
        
        //    3.
        AVMutableVideoCompositionInstruction *videoCompositionInstrution = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        videoCompositionInstrution.timeRange = CMTimeRangeMake(kCMTimeZero, compositionTrack.asset.duration);
        videoCompositionInstrution.layerInstructions = @[videolayerInstruction];
        
        //    4.
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.renderSize =  CGSizeMake(compositionTrack.naturalSize.height, compositionTrack.naturalSize.width);
        
        videoComposition.frameDuration = CMTimeMake(1, 30);
        //    videoComposition.renderScale
        videoComposition.instructions = [NSArray arrayWithObject:videoCompositionInstrution];
        
        //    5.
        AVAssetExportSession *exportSesstion = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        UIGraphicsEndImageContext();
        int x = arc4random() % 100;
        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
        
        NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
        NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
        videoName = imageName;
        NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
        exportSesstion.outputURL = [NSURL fileURLWithPath:imagePath];
        exportSesstion.outputFileType = @"com.apple.quicktime-movie";
        exportSesstion.shouldOptimizeForNetworkUse = YES;
        exportSesstion.videoComposition = videoComposition;
        
        [exportSesstion exportAsynchronouslyWithCompletionHandler:^{
            AVAssetExportSessionStatus status = exportSesstion.status;
            if (status == AVAssetExportSessionStatusCompleted) {
                NSLog(@"Complete");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self SaveVideo];
                });
                
            }else{
                [self videorecorderexception];
                __weak typeof(self) weakSelf =self;
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                NSLog(@"Error--%@",exportSesstion.error);
            }
        }];
    }@catch(NSException *ex){
        NSLog(@"aaa");
    }
>>>>>>> main
}


-(void)SaveVideo
{
    NSLog(@"videoName:%@",videoName);
   
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    NSString *UDID = [[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"];
    NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:videoName forKey:@"imageName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [myimagedict setObject:videoName forKey:@"imageName"];
    if(self.selectedTab == nil){
        [myimagedict setObject:[NSString stringWithFormat:@"%d",self.instruction_number] forKey:@"img_numb"];
    }
    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
    [myimagedict setObject:latitude forKey:@"latitude"];
    [myimagedict setObject:longitude forKey:@"longitude"];
    
    NSLog(@"pics %@",pics);
    NSString* myDocumentPath = [pathToImageFolder stringByAppendingPathComponent:videoName];
    UIImage *img = [self generateThumbImage:myDocumentPath];
    if(img != nil)
    {
        CGSize size = img.size;
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
        [[UIImage imageWithCGImage:[img CGImage] scale:1.0 orientation:UIImageOrientationUp ] drawInRect:CGRectMake(0,0,size.width ,size.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [ThumbArray addObject:newImage];
        [URLArray addObject:videoName];
    }
    [myimagedict setObject:@"False" forKey:@"variance"];
    [myimagedict setObject:@"False" forKey:@"brightness"];
    NSLog(@"myimagearray:%@",self.myimagearray);
    NSLog(@" the taken photo is:%@",self.loopImagearray);
    //finding index
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
    if(self.selectedTab != nil){
        [myimagedict setObject:[dicto objectForKey:@"img_numb"] forKey:@"img_numb"];
        [self.myimagearray replaceObjectAtIndex:index withObject:myimagedict];
    }else{
        [self.myimagearray addObject:myimagedict];
    }
    if(self.selectedTab != nil){
        for(int i=0; i<self.loopImagearray.count;i++){
            NSMutableDictionary *newdict = [[self.loopImagearray objectAtIndex:i] mutableCopy];
            if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                [myimagedict setObject:[newdict objectForKey:@"img_numb"] forKey:@"img_numb"];
                [self.loopImagearray replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:index]];
            }
        }
    }else{
        [self.loopImagearray addObject:myimagedict];
       // [self.myimagearray addObject:myimagedict];
    }
    ServerUtility * imge = [[ServerUtility alloc] init];
    NSLog(@"my %@",myimagedict);
    imge.picslist = _loopImagearray;
    [[NSUserDefaults standardUserDefaults]setObject:_loopImagearray forKey:@"picslist"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"my3 %@",imge.picslist);
    [self.parkLoad setObject:self.loopImagearray forKey:@"img"];
    [self.collection_View reloadData];
      
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                  
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.loopImagearray.count, countLimit];
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSInteger item = self.myimagearray.count-2;//[self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//    [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    if(self.myimagearray.count > 4){
        // Calculate the content offset to scroll to the end
        CGFloat contentOffsetX = self.collection_View.contentSize.width - self.collection_View.bounds.size.width;
        // Make sure the contentOffset doesn't go below 0
        contentOffsetX = MAX(0, contentOffsetX + 150);
        // Scroll to the calculated content offset
        [self.collection_View setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    }
    [self.imgBtn setHidden:YES];
    [self.startvideoBtn setHidden:YES];
    [self.progressBar setHidden:YES];
    [self.progressView setHidden:YES];
    [self.timeLbl setHidden:YES];
    [self.innervideoBtn setHidden:NO];
    [self.bottomView setHidden:NO];
    __weak typeof(self) weakSelf =self;
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    WeAreRecording = NO;
    [self.view makeToast:NSLocalizedString(@"Saving Video Failed +3",@"")];
    if(self.selectedTab != nil){
        [self btn_NextTapped:self.view];
    }
}


- (void) receiveNotification:(NSNotification *) notification{
    
    if ([[notification name] isEqualToString:@"ApplicationEnterBackGround"])
        NSLog (@"Successfully received the test notification!");
    if(WeAreRecording == YES)
    {
        NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
        NSString* myDocumentPath1= [pathToImageFolder stringByAppendingPathComponent:AudioName];
        //[[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
       // [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath1 error:nil];
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.innervideoBtn setHidden:NO];
        [self.bottomView setHidden:NO];
        //[self configureToCapturePhoto];

        __weak typeof(self) weakSelf =self;
    }
}


-(IBAction)BlurImgClickAction:(id)sender{
    
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

@end
