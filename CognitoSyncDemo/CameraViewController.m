//
//  CameraViewController.m
//  sgpcapp
//
//  Created by SmartGladiator on 07/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//

#import "CameraViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CollectionViewCell.h"
#import "StaticHelper.h"
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

@import MobileCoreServices;



@interface CameraViewController ()<CreolePhotoSelectionDelegate> {
    NSString* pathToImageFolder;
    NSMutableArray *pics;
    NSString *videoName;
    NSString *AudioName;
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
}
-(UIImage *)generateThumbImage : (NSString *)filepath;
@end

@implementation CameraViewController
int uploadCountLimit = 325;

BOOL WeAreRecording;

AVCaptureSession *session;
AVAudioSession *audiosession;
AVAudioRecorder *recorder;
AVCaptureMovieFileOutput *MovieFileOutput;
AVCaptureStillImageOutput *StillImageOutput;
AVCaptureVideoDataOutput * _captureVideoDataOutput;
NSDate * _lastSequenceCaptureDate;
UIImageOrientation _sequenceCaptureOrientation;
AVCaptureVideoPreviewLayer *previewLayer;
//tapCount = 0;

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
        if (success)
        {
            if (flashButton.tag == 1) {
                flashButton.tag=0;
                flashButton.text = @"ON";
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }else if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text = @"OFF";
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
                //            if ([flashLight isTorchActive]) {
                //                [flashLight setTorchMode:AVCaptureTorchModeOff];
                //            } else {
                //                [flashLight setTorchMode:AVCaptureTorchModeOn];
                //            }
            [flashLight unlockForConfiguration];
        }
    }
}

- (void)viewDidLoad {
    cameraboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    NSLog(@"cameraboolToRestrict:%d",cameraboolToRestrict);

    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];

    ThumbArray = [[NSMutableArray alloc]init];
    URLArray = [[NSMutableArray alloc]init];
    uploadCountLimit = self.siteData.uploadCount;
    // uploadCountLimit = 10;
    self.tapCount = 0;
    
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"IOSVersion %@",iOSVersion);
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    self.myimagearray = [[self.parkLoad objectForKey:@"img"]mutableCopy];
    if (!(self.myimagearray.count > 0)) {
        self.myimagearray = [[NSMutableArray alloc]init];
    }
    
    self.tapCount =  self.myimagearray.count;
    SiteData *sitesssClass = delegate.siteDatas;
    int networkid = sitesssClass.networkId;
    NSLog(@"the selected site:%@",sitesssClass.siteName);
    
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
    
    
    
    //flash mode
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![flashLight isTorchAvailable]){
        flashButton.hidden = true;
    }

    if ([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff] && cameraboolToRestrict  == FALSE){
   
    flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+30, self.view.frame.size.height*0.10, 40, 30)];
    flashButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        flashButton.textColor = [UIColor whiteColor];
    flashButton.textAlignment = NSTextAlignmentCenter;
    flashButton.text = @"OFF";
    flashButton.tag=1;
    flashButton.userInteractionEnabled=TRUE;
    [self.imageforcapture addSubview:flashButton];
    
    flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-70, flashButton.frame.origin.y, 100, 30)];
    flashLabel.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
    flashLabel.textColor = [UIColor whiteColor];
    flashLabel.textAlignment = NSTextAlignmentCenter;
    flashLabel.text = @"Flash Mode:";
    
    [self.imageforcapture addSubview:flashLabel];
    
    [self.imageforcapture bringSubviewToFront:flashButton];
    [self.imageforcapture bringSubviewToFront:flashLabel];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashToggle:)];
    [flashButton addGestureRecognizer:recognizer];
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
    if([PlanName isEqualToString:@"Silver"]||[PlanName isEqualToString:@"Bronze"])
    {
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
   
    //FreeTier-SUresh
    if([self.siteData.planname isEqual:@"FreeTier"]){
        /*NSString *msg = [NSString stringWithFormat:@"Remaining Images: %d \t Remaining Videos: %d",self.siteData.RemainingImagecount, self.siteData.RemainingVideocount];
        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];*/
        if (uploadCountLimit >= 50) {
            uploadCountLimit = 50;
        }else if(uploadCountLimit>0){

        }else if(uploadCountLimit==0 && self.siteData.RemainingVideocount>0){
            int a=self.siteData.RemainingVideocount;
            uploadCountLimit= a;
        }else{
            [self.view makeToast:@"Maximum Limit for Uploading Mediafiles is Reached, Kindly Upgrade This Site to Continue." duration:3.0 position:CSToastPositionCenter];
        }
    }
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
    

    //ZoomFeature
    if(([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  && cameraboolToRestrict  == FALSE){
        
        NSString *model=[UIDevice currentDevice].model;
        [zoomlbl setHidden:FALSE];
        [_zoomSlider setHidden:FALSE];
        [_zoomSlider addTarget:self action:@selector(scaleOfview:) forControlEvents:UIControlEventValueChanged];
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
        
        _zoomSlider.transform = trans;
        if ([model isEqualToString:@"iPhone"]){

            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.55), (previewLayer.frame.size.height*0.25), (previewLayer.frame.size.height*0.50),(previewLayer.frame.size.height*0.50));
        

        }else if([model isEqualToString:@"iPad"]){
            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.65), (previewLayer.frame.size.height*0.30), (previewLayer.frame.size.height*0.50),(previewLayer.frame.size.height*0.50));
        }else{
            _zoomSlider.frame =CGRectMake((previewLayer.frame.size.width*0.55), (previewLayer.frame.size.height*0.20), (previewLayer.frame.size.height*0.50),(previewLayer.frame.size.height*0.50));
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

    }else{
        [_zoomSlider setHidden:TRUE];
        [zoomlbl setHidden:TRUE];
    }
    
    //self.siteData.addon_gallery_mode=@"TRUE";
    
    //GalleryMode
    
    if(self.siteData.addon_gallery_mode.boolValue==TRUE)
        [self.btn_Logout setImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
    else
         [self.btn_Logout setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        
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
    
    if(WeAreRecording  == YES )
    {
        [self.view makeToast:@"Recording Video, Please Wait." duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if([self.parkLoad valueForKey:@"category"]){
        //[self.parkLoadArray replaceObjectAtIndex:(currentLoadNumber) withObject:(self.parkLoad)];
        
        //[[NSUserDefaults standardUserDefaults ] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
      //  [[NSUserDefaults standardUserDefaults ] synchronize];
        
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
        
    }else{
        if (self.myimagearray.count > 0) {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
            
            [self.alertbox addButton:@"YES" target:self selector:@selector(deleteLoad:) backgroundColor:Red];
            [self.alertbox showSuccess:@"Alert" subTitle:@"Clicking back button will delete all pictures in this Load. Continue?" closeButtonTitle:nil duration:1.0f ];
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
    }
}

-(IBAction)deleteLoad:(id)sender{
    [self.alertbox hideView];
    
    [self.parkLoadArray removeObjectAtIndex:currentLoadNumber];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AZCAppDelegate *delegate = AZCAppDelegate.sharedInstance;
        [delegate.window makeToast:@"Images Deleted Successfully"  duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
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
        // the photo's metadata timestamp string
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
    
    NSLog(@"latitude:%@",latitude);
    NSLog(@"longitude:%@",longitude);
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}


-(void )handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(200,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = self.siteName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
        //titleLabel.backgroundColor = [UIColor blackColor];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 240, 40)];
    [view addSubview:titleLabel];
    
    view.center = self.view.center;
    
    
    if (delegate.isMaintenance) {
        
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"yellow_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.921 blue: 0.243 alpha: 1.00].CGColor;
        
            //RGBA ( 255 , 235 , 62 , 100 )
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
        
            //RGBA ( 213 , 191 , 0 , 100 )
        
        NSLog(@"Server Under maintenance");
        
    }else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 229 , 8 , 100)
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 174 , 7 , 100 )
        
        
        NSLog(@"Network Connection available");
    } else {
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
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

-(void)viewWillAppear:(BOOL)animated {
    
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"CameraVC";
    
    for (NSDictionary *dic in self.myimagearray) {
        
        NSString *name = [dic  valueForKey:@"imageName"];
        NSString* Path1= [pathToImageFolder stringByAppendingPathComponent:name];

        if(![[NSFileManager defaultManager] fileExistsAtPath:Path1])
        {
            [self.myimagearray removeObject:dic];
        }
    }
    
    [super viewWillAppear:animated];
    [self handleTimer];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.collection_View reloadData];
    //NSInteger imgint = self.myimagearray.count;
    //NSIndexPath *imgcount = imgint;
    //[self.collection_View scrollToItemAtIndexPath:imgcount atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    NSLog(@"%f",self.view.frame.size.height * 0.09);
    
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    
    if(self.startvideoBtn.isHidden == YES){
        if(delegate.isEnterForegroundCamera == YES )
        {
            delegate.isEnterForegroundCamera = NO;
            [self.view makeToast: @"Tap to Take Pictures" duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
            //[self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
        }
        
    }
    if(self.startvideoBtn.isHidden == NO){
        if(delegate.isEnterForegroundVideo == YES )
        {
            delegate.isEnterForegroundVideo = NO;
            [self.view makeToast: @"Tap On Video Icon To Record" duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
            //[self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
        }
    }
    if(WeAreRecording == YES )
        [self videorecorderexception];
    [self addRoundedIconWithBorder ];
    // [session startRunning];
    
    
    if (([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  && cameraboolToRestrict  == FALSE) {
        [zoomlbl setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
    }
    [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
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
            if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text = @"OFF";
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
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([inputDevice lockForConfiguration:&error]) {
        float zoomFactor = inputDevice.activeFormat.videoZoomFactorUpscaleThreshold;
        [inputDevice setVideoZoomFactor:1.0];
        [inputDevice unlockForConfiguration];
    }
    
    [CameraViewController setFlashMode:AVCaptureFlashModeAuto forDevice:inputDevice];
    //  NSError *error;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
        
    }
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResize];
    CALayer *rootLayer = self.imageforcapture.layer;
    [rootLayer setMasksToBounds:YES];
    [_imageforcapture layoutIfNeeded];
    
    CGRect frame = _imageforcapture.bounds; //CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height *0.65);//
    //    previewLayer.backgroundColor = [UIColor redColor].CGColor;
    [previewLayer setFrame:frame];
 
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    StillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings =[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [StillImageOutput setOutputSettings:outputSettings];
    
    
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 100;            //Total seconds
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

//****************************************************
#pragma mark - Notification
//****************************************************


            
//****************************************************
#pragma mark - Collection View Delagate Methods
//****************************************************
//data source and delegates method


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.myimagearray.count == 0) {
        CGFloat cellWidth = self.collection_View.frame.size.height;
        
        int totalimg = self.view.frame.size.width/cellWidth;
        
        CGFloat balanceSpace = self.view.frame.size.width - (totalimg * cellWidth);
        
        if(balanceSpace > 20){
            totalimg += 1;
        }
        //       int v = self.view.frame.size.width/self.collection_View.frame.size.height;
        //
        //
        //       if(v < 3)
        //       {
        return totalimg;
        //       }
        //       else{
        //          return self.view.frame.size.width/self.collection_View.frame.size.height;
        //       }
        
    }
    else
    {
        NSString *model=[UIDevice currentDevice].model;
        
        int count=3;
        if ([model isEqualToString:@"iPad"]) {
            count=4;
        }
        if(self.myimagearray.count <count)
        {
            return count;
        }else{
            return self.myimagearray.count;
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
    
    //    if (IS_IPHONE_6) {
    //
    //int numberOfCellInRow = [self.collection_View numberOfItemsInSection:0];
    cellWidth =  self.collection_View.frame.size.height;
    return CGSizeMake(cellWidth, cellWidth);
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   // Cell.blur_img.backgroundColor = [UIColor clearColor];
   // Cell.blur_img.tintColor = [UIColor yellowColor];
    if (self.myimagearray.count == 0) {
        Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
        Cell.waterMark_lbl.text =@"";
        [Cell.delete_btn setHidden:YES];
        [Cell.videoicon setHidden:YES];
        [Cell.low_light setHidden:YES];
        [Cell.blur_img setHidden:YES];

    }else
    {
        
        if (self.myimagearray.count < indexPath.row + 1)
        {
            Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
            Cell.waterMark_lbl.text =@"";
            [Cell.delete_btn setHidden:YES];
            [Cell.videoicon setHidden:YES];
            [Cell.low_light setHidden:YES];
            [Cell.blur_img setHidden:YES];

        }
        else
        {
            //for(int i = 0; i<self.myimagearray.count; i++){
            NSDictionary *adict =[self.myimagearray objectAtIndex:indexPath.row];
            
            NSString* imageName = [adict valueForKey:@"imageName"];
            
            NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
            
            
            if([extentionArray[1] isEqualToString:@"mp4"])
            {
                [Cell.blur_img setHidden:YES];
                [Cell.low_light setHidden:YES];
                [Cell.videoicon setHidden:NO];
                NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
                UIImage* image = [self generateThumbImage : path];
                if(image != nil)
                {
                    Cell.image_View.image =image;
                }
                else{
                    Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
                }
                
            }
            else{
                
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
                
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                Cell.image_View.image = image;
                [Cell.image_View setTag:1];
                [Cell.videoicon setHidden:YES];
            }
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
            [Cell.delete_btn setHidden:NO];
            
            [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [Cell.delete_btn setTag:indexPath.row];
            //}
        }
    }
    return Cell;
    
}


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



//****************************************************
#pragma mark - Action  Methods
//****************************************************//while tapping X delete symbol to delete the picture


-(IBAction)delete:(id)sender {
    if(WeAreRecording  == YES )
    {
        [self.view makeToast:@"Cannot Delete File While Recording Video." duration:2.0 position:CSToastPositionCenter];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    NSDictionary* myimagedict = [self.myimagearray objectAtIndex:btn.tag];
    NSString* imageName = [myimagedict valueForKey:@"imageName"];
    NSString *path = [[AZCAppDelegate.sharedInstance getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    NSString* imagePath = [path stringByAppendingPathComponent:imageName];
    
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    
    [self.myimagearray removeObjectAtIndex:btn.tag];
    self.tapCount= self.myimagearray.count;
    
    NSLog(@" the delete array is :%@",self.myimagearray);
    [self.collection_View reloadData];
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
    
    [self.parkLoad setObject:self.myimagearray forKey:@"img"];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//while tapping next button
-(IBAction)btn_NextTapped:(id)sender
{
    ServerUtility * imge = [[ServerUtility alloc] init];
    imge.picslist = self.myimagearray;
  //  NSLog(@"my next %@",imge.picslist);
    
    if(WeAreRecording == YES )
    {
        [self.view makeToast:@"Recording Video, Kindly Wait." duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if(self.myimagearray.count == 0)
    {
        [self.view makeToast:@"Take At least 1 Media file " duration:2.0 position:CSToastPositionCenter];
    } else{
      
        PicViewController *PictureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureVC"];
        
        PictureVC.imageArray = self.myimagearray;
        PictureVC.siteData = self.siteData;
        PictureVC.sitename = self.siteName;
        PictureVC.pathToImageFolder = pathToImageFolder;
        PictureVC.thumbArray = ThumbArray;
        PictureVC.urlArray = URLArray;
        
        
        [self.navigationController pushViewController:PictureVC animated:YES];
    }
    
}


//multi_img_picker
-(void)getSelectedPhoto:(NSMutableArray *)aryPhoto
{
    //Initlize array
    _arrImage = nil;
    _arrImage = [NSMutableArray new];
    _arrImage = [aryPhoto mutableCopy]; //mainImage, Asset, selected
    NSLog(@"info:%@",_arrImage);
    int pos = 0;
    for (NSDictionary *dict in _arrImage)
    {
        @autoreleasepool
        {
            //size_conversion
            self.tapCount ++;
            NSLog(@"tapCount:%d",self.tapCount);
            pos ++;
            NSLog(@"size_conversion:%d",pos);
            UIImage *chosenImage =[dict valueForKey:@"mainImage"];
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
            CGFloat widthh = chosenImage.size.width;
            CGFloat heightt = chosenImage.size.height;
            CGSize imageSize;
            //UIImage *resizedImage;
            NSLog(@"Image Quality :%@",self.siteData.image_quality);
            if ([self.siteData.image_quality isEqual:@"1"]) {
                if(widthh != 720 && heightt != 1080){
                    imageSize = CGSizeMake(720,1080);
                    UIGraphicsBeginImageContext(imageSize);
                    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
                
            }else{
                if(widthh != 1440 && heightt != 2160){
                    imageSize = CGSizeMake(1440,2160);
                    UIGraphicsBeginImageContext(imageSize);
                    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
            }
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
             
            NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
            NSString *UDID = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"identifier"];
            NSString* imageName = [NSString stringWithFormat:@"%@_%@_%d.jpg",UDID,epochTime,pos];
            NSLog(@"imageName:%@",imageName);
            NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];

            [UIImageJPEGRepresentation(chosenImage,1) writeToFile:imagePath atomically:true];
            [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myimagedict setObject:imageName forKey:@"imageName"];
            [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
            [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
            [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"latitude"];
            [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"longitude"];
            
            
            //NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
            NSString *islowlight=@"FALSE";
            [myimagedict setObject:islowlight
                            forKey:@"brightness"];
            
            //CGImageRef iimage = [chosenImage CGImage];
            
            [myimagedict setObject:@"FALSE"
                            forKey:@"variance"];
            [self.myimagearray addObject:myimagedict];
            //NSLog(@" the taken photo is:%@",self.myimagearray);
                //reloading the collection view
            [self.collection_View reloadData];
            ServerUtility * imge = [[ServerUtility alloc] init];
            //NSLog(@"myimagedict %@",myimagedict);
            imge.picslist = _myimagearray;
            [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //NSLog(@"imge.picslist %@",imge.picslist);
            NSLog(@"myimagearray: %@", self.myimagearray);
            NSLog(@"myimagearray.length: %lu", (unsigned long)self->_myimagearray.count);
            _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            [self.parkLoad setObject:self.myimagearray forKey: @"img"];
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


//While tapping logout button
-(IBAction)logoutClicked:(id)sender {
    
    //GalleryMode
     //self.siteData.addon_gallery_mode=@"TRUE";
    if(self.siteData.addon_gallery_mode.boolValue==TRUE){
        //gallerymode
        if(WeAreRecording  == YES )
        {
            [self.view makeToast:@"Recording video. Please wait." duration:2.0 position:CSToastPositionCenter];
            return;
        }
        int countlimit;
        if([PlanName  isEqual:@"Bronze"]){
            countlimit = uploadCountLimit  >= 40 ? uploadCountLimit : self.siteData.RemainingImagecount;
        }else{
            countlimit = uploadCountLimit  >= 50 ? uploadCountLimit : self.siteData.RemainingImagecount;
        }
        if (self.myimagearray.count < uploadCountLimit) {
            
        //Multi_img_selector
            CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"multiPicker" bundle:Nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
            objPhotoViewController.strTitle = @"Choose Photos";
            //objPhotoViewController.mediaTypes = @[(NSString *)kUTTypeImage];
             //, (NSString *)kUTTypeMovie];
            objPhotoViewController.delegate = self;
            objPhotoViewController.arySelectedPhoto = _arrImage;
            objPhotoViewController.maxCount = (uploadCountLimit - self.myimagearray.count);
            objPhotoViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.navigationController presentViewController:navController animated:YES completion:nil];
            
            
        //single_img_selector
            
          /*  UIImagePickerController *pickerView =[[UIImagePickerController alloc] init];
            pickerView.allowsEditing = NO;
            pickerView.delegate = self;
            //[pickerView isBeingDismissed];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerView.modalPresentationStyle = UIModalPresentationFullScreen;
            }
            [self presentViewController:pickerView animated:YES completion:nil];*/
            
            
        }else{
            [self.view makeToast:@"Limit Exceeded" duration:2.0 position:CSToastPositionCenter];
        }
    }else{
        
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            if(WeAreRecording  == YES )
            {
                [self.view makeToast:@"Recording Video, Kindly Stop Video Recording To Logout." duration:3.0 position:CSToastPositionCenter];
                return;
            }
            
            if(self.parkLoadArray!=nil && self.parkLoadArray.count>0){
                if(self.parkLoadArray.count==1 ){
                    NSMutableDictionary *dict= [[self.parkLoadArray objectAtIndex:0] mutableCopy];
                    NSMutableArray *imgarr = [dict valueForKey:@"img"];
                    if ([dict valueForKey:@"category"] || (imgarr.count > 0)) {
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox setHorizontalButtons:YES];
                        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
                        
                        [self.alertbox addButton:@"YES" target:self selector:@selector(signout:) backgroundColor:Red];

                        [self.alertbox showSuccess:@"Logout" subTitle:@"Are you sure you want to Logout ?" closeButtonTitle:nil duration:1.0f ];
                    }else{
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox setHorizontalButtons:YES];
                        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
                        
                        [self.alertbox addButton:@"YES" target:self selector:@selector(signout:) backgroundColor:Red];
                        
                        [self.alertbox showSuccess:@"Logout" subTitle:@"Are you sure you want to Logout ?" closeButtonTitle:nil duration:1.0f ];
                    }
                }else{
                    [self.view makeToast:@"One or More Loads are Parked, Kindly Upload or Delete the parked Loads to Proceed" duration:3.0 position:CSToastPositionCenter];
                    return;
                }
            }else{
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
                
                [self.alertbox addButton:@"YES" target:self selector:@selector(signout:) backgroundColor:Red];
                
                [self.alertbox showSuccess:@"Logout" subTitle:@"Are you sure you want to Logout ?" closeButtonTitle:nil duration:1.0f];
            }
            
        }else{
            [self.view makeToast:@"Network is Offline,\n To Logout, Kindly Connect With Internet." duration:2.0 position:CSToastPositionCenter];
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
    [ServerUtility getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cid withUid:(NSString *)uid withlat:(NSString *)latitude withlongi:(NSString *)longitude withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
        
       if (!error) {
               NSLog(@"Logout data:%@",data);
               NSString *strResType = [data objectForKey:@"res_type"];
           if ([strResType.lowercaseString isEqualToString:@"success"]){
               
                [self.alertbox hideView];
                self.tapCount = 0;
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
                
                    // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
                [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
                [[AZCAppDelegate sharedInstance] clearAllLoads];
           }
       }
   }];
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
    
    
    if ([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  {
        if(cameraboolToRestrict == FALSE){
            
        [zoomlbl setHidden:FALSE];
        [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        zoomlbl.text = @"1.00 x";
        [_zoomSlider setValue:1];

        }
    }
    [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
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
            flashButton.text = @"OFF";
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
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
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
        [self.view makeToast: @"Tap On Video Icon To Record" duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
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
    
    if (self.myimagearray.count < uploadCountLimit) {
        
        [self.imgBtn setHidden:YES];
        [self.startvideoBtn setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.timeLbl setHidden:YES];
        [self.progressBar setHidden:YES];
        [self.progressView setHidden:YES];
        [self.innervideoBtn setHidden:NO];
        [self.captureAction setHidden:YES];
        self.videoBtn.layer.cornerRadius = 10;
        self.btn_TakePhoto.backgroundColor = UIColor.clearColor;
        self.btn_TakePhoto.tintColor = UIColor.whiteColor;
        self.videoBtn.backgroundColor = UIColor.whiteColor;
        self.videoBtn.tintColor = UIColor.blackColor;
        [zoomlbl setHidden:TRUE];
        
        if ([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"]) {
            [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        }
        [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
        [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    }
    else{
        [self.view makeToast:@"Limit Exceeded" duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    
    if(delegate.isEnterForegroundVideo == YES  && WeAreRecording)
    {
        [self.view makeToast:@"Saving Video Failed +5"];
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
    if([PlanName  isEqual:@"Bronze"]){
        countlimit = uploadCountLimit  >= 40 ? uploadCountLimit : self.siteData.RemainingImagecount;
    }else{
        countlimit = uploadCountLimit  >= 50 ? uploadCountLimit : self.siteData.RemainingImagecount;
    }
    if (self.myimagearray.count < countlimit) {
        [self clickImageAction:sender ];
    }
    else{
        [self.view makeToast:@"Limit Exceeded" duration:2.0 position:CSToastPositionCenter];
    }
}

- (IBAction)startVideoBtnClick:(id)sender {
    WeAreRecording = NO;
    [self stoprecording];
   [self.view makeToast:@"Saving Video Failed +2"];
}

-(void)stoprecording

{
    //----- STOP RECORDING -----
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
                flashButton.text = @"OFF";
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
    //    NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
    //      NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
    //    [self videoCut:myDocumentPath audio:audio];
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
    // timecount -= 1;
    NSLog(@"%f timerFired", remainingTime);
    
    // if(ResumeBtnClick == NO)
    // {
    int value = (int)timeRemain;
    //  NSString *str = [val string]
    self.timeLbl.text = [NSString stringWithFormat:@"00.%02d", value];
    float val = 30.0 - (1.0 * timeRemain / 30.0);
    //  [self.progressBar setProgress:timeRemain animated:YES];
    self.progressBar.value = 1.0 - (1.0 * timeRemain / 30.0);
    if (remainingTime < 0.0 || remainingTime == 0.0) {
        
            //[self stopTimer];
        WeAreRecording = NO;
        
        self.timeLbl.text = [NSString stringWithFormat:@"00.00"];
        [self.progressBar setValue:1.0f];
        [self.progressView setHidden:NO];
        [self stoprecording];
        
        return;
    }
}


- (IBAction)clickImageAction:(id)sender {
    int countlimit;
    if([PlanName  isEqual:@"Bronze"]){
        countlimit = uploadCountLimit  >= 40 ? uploadCountLimit : self.siteData.RemainingImagecount;
    }else{
        countlimit = uploadCountLimit  >= 50 ? uploadCountLimit : self.siteData.RemainingImagecount;
    }
    if (self.myimagearray.count < countlimit) {
    
        self.tapCount ++;
        // [self.btn_TakePhoto setEnabled:NO];
        [self.captureAction setEnabled:NO];
        [self.imgBtn setEnabled:NO];
        //hiding for camera improper numbering

        
        AVCaptureConnection *videoConnection  = nil;
        for(AVCaptureConnection *connection in StillImageOutput.connections)
        {
            for(AVCaptureInputPort *port in  [connection inputPorts])
            {
                if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                    videoConnection =connection;
                    break;
                }
            }
        }

        [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){


            if (imageDataSampleBuffer!=NULL) {
                
                CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
                NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
                CFRelease(metadataDict);
            
                NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
                float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue]  floatValue];
                NSLog(@"Brightness value: %f",brightnessValue);
                    
                NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    
                
//                                NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_1" ofType:@"png"];
//                                NSData *imageData = [[NSData data]initWithContentsOfFile:path];
                                UIImage *capturedImage = [UIImage imageWithData:imageData];
                
                
                                CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];

                                CGImageRef takenCGImage = capturedImage.CGImage;
                                size_t width = CGImageGetWidth(takenCGImage);
                                size_t height = CGImageGetHeight(takenCGImage);

//                                _uploadOriginalSize.text = [NSString stringWithFormat:@"Original : %zu x %zu",width,height];
                
                                CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);

                                CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);

                                capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                                CGImageRelease(cropCGImage);

                                UIGraphicsBeginImageContext(capturedImage.size);
                                [capturedImage drawAtPoint:CGPointZero];
                                capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();



                            

//                                _uploadOCropingSize.text = [NSString stringWithFormat:@"Crop : %zu x %zu",width1,height1];
                
                //OLD CODE//
//                UIImage *capturedImage = [UIImage imageWithData:imageData];
                //REducing the captured image size
                CGSize imageSize;
                NSLog(@"Image Quality :%@",self.siteData.image_quality);
                if ([self.siteData.image_quality isEqual:@"1"]) {
                    imageSize = CGSizeMake(720,1080);
                    //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                    
                }else{
                    imageSize = CGSizeMake(1440,2160);
                    //                    _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                    
                    
                }
                
                // imageSize = CGSizeMake(1224, 1632);
                //imageSize  =CGSizeMake (1224,1224);
                // imageSize = CGSizeMake(120,120);
                
                // imageSize = CGSizeMake(816, 1088);//original size divided by 3
                
                //imageSize = CGSizeMake(700, 750);
                
                UIGraphicsBeginImageContext(imageSize);
                [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //                NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((capturedImage), 0.5)];
                //                int imageSize1   = imgData.length;
                //                NSLog(@"size of image in KB: %f ", imageSize1/1024.0);
                
                UIGraphicsEndImageContext();
                
                //OLD CODE END
                int x = arc4random() % 100;
                NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                //                CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
                //                CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
                NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                NSString *UDID = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"];
                NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
                NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
                
                [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
                [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [myimagedict setObject:imageName forKey:@"imageName"];
                [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
                [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
                [myimagedict setObject:latitude forKey:@"latitude"];
                [myimagedict setObject:longitude forKey:@"longitude"];
                
                NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                [myimagedict setObject:islowlight
                  forKey:@"brightness"];
                
                // NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                //UIImage *img = [UIImage imageNamed:@"notes"];
                
                // [myimagedict setObject:img forKey:@"image"];
                //                pics = [NSMutableArray alloc];
                //                pics = [myimagedict valueForKey:@"imageName"];
                NSLog(@"pics %@",pics);
                //UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil);
                //                AnotherViewController *controller = [[AnotherViewController alloc] init];
                //                controller.data = myCurrentDictionoary;
                CGImageRef iimage = [resizedImage CGImage];
                
                
                if (@available(iOS 12, *)) {
                    NSString *model=[UIDevice currentDevice].model;
                    float target=2.0; //ipod
                    if ([model isEqualToString:@"iPad"]) {
                        target=12.0;
                    }else if([model isEqualToString:@"iPhone"]){
                        target=7.0;
                    }
                    [myimagedict setObject:[self detectBlur:iimage]<target?@"TRUE":@"FALSE"
                                    forKey:@"variance"];
                }else{
                    [myimagedict setObject:@"FALSE"
                                    forKey:@"variance"];
                }
                
                [self.myimagearray addObject:myimagedict];
                NSLog(@" the taken photo is:%@",self.myimagearray);
                //reloading the collection view
                [self.collection_View reloadData];
                ServerUtility * imge = [[ServerUtility alloc] init];
                NSLog(@"my %@",myimagedict);
                imge.picslist = _myimagearray;
                [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"my2 %@",imge.picslist);
                _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
                NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                
                [self.parkLoad setObject:self.myimagearray forKey:@"img"] ;
                [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
              
                
            }
            
            [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
        }];
        NSLog(@"the array count is :%lu",(unsigned long)self
              .myimagearray.count);
        NSLog(@" taps occured%d",self.tapCount);
        //[locationManager stopUpdatingLocation];
    }
    else {
        [self.view makeToast:@"Limit Exceeded" duration:2.0 position:CSToastPositionCenter];
    }

}


////   blur_image_detection  /////

    /// <#Description#>
    /// @param iimage <#iimage description#>
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
  MTLTextureDescriptor *grayTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR16Unorm
                                                                                                   width:sourceTexture.width
                                                                                                  height:sourceTexture.height
                                                                                               mipmapped:false];
  grayTextureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
  id<MTLTexture> grayTexture = [device newTextureWithDescriptor:grayTextureDescriptor];
  [conversion encodeToCommandBuffer:commandBuffer sourceTexture:sourceTexture destinationTexture:grayTexture];


  MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:grayTexture.pixelFormat
                                                                                               width:sourceTexture.width
                                                                                              height:sourceTexture.height
                                                                                           mipmapped:false];
  textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
  id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];

  MPSImageLaplacian *imageKernel = [[MPSImageLaplacian alloc] initWithDevice:device];
  [imageKernel encodeToCommandBuffer:commandBuffer sourceTexture:grayTexture destinationTexture:texture];


  MPSImageStatisticsMeanAndVariance *meanAndVariance = [[MPSImageStatisticsMeanAndVariance alloc] initWithDevice:device];
  MTLTextureDescriptor *varianceTextureDescriptor = [MTLTextureDescriptor
                                                     texture2DDescriptorWithPixelFormat:MTLPixelFormatR32Float
                                                     width:2
                                                     height:1
                                                     mipmapped:NO];
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

/*const char* bytes = resultBytes;
NSLog(@"***resultBytes: %d", bytes[0]);
NSLog(@"***resultBytes: %d", bytes[1]);
[varianceTexture getBytes: resultBytes bytesPerRow: 1 * 2 * 4 fromRegion: region mipmapLevel: 0];
NSLog(@"resultBytes: %d", bytes[0]);
NSLog(@"resultBytes: %d", bytes[1]);
*/
    float variance;

    variance = u.f[1] * 255 * 255;
NSLog(@"variance:%f",variance);
    //[self.view makeToast:[NSString stringWithFormat:@"%f",variance ] duration:2.0 position:CSToastPositionCenter style:nil];
    return variance;
}



- (IBAction)innerVideoButtonAction:(id)sender {
    BOOL count =  [self VideoCount];
    if (count == NO) {
        return;
    }
    
    if (self.myimagearray.count < uploadCountLimit) {
        self.tapCount ++;
        [locationManager startUpdatingLocation];
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
            //----- START RECORDING -----
            NSLog(@"START RECORDING");
            WeAreRecording = YES;
            timecount = 30.0;
            startDate = [NSDate date];
            [self startTimer];
            //Create temporary URL to record to
            UIGraphicsEndImageContext();
            int x = arc4random() % 100;
            NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
            NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
            //            CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
            //            CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
            NSString *UDID = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"identifier"];
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
        [self.view makeToast:@"Limit Exceeded" duration:2.0 position:CSToastPositionCenter];
    }
}



-(BOOL)VideoCount
{
    if([PlanName isEqualToString:@"Silver"]||[PlanName isEqualToString:@"Bronze"])
    {
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox showSuccess:@"Information" subTitle:@"Video mode is not featured for this site." closeButtonTitle:nil duration:1.0f ];
        
        return NO;
        
    }
    
    //FreeTier-Suresh
    else  if([PlanName isEqualToString:@"Gold"] || [PlanName isEqualToString:@"FreeTier"])
    //else  if([PlanName isEqualToString:@"Gold"])
    {
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToImageFolder error:NULL];
        NSMutableArray *extentionArray = [[NSMutableArray alloc]init];
        // for (int count = 0; count < (int)[directoryContent count]; count++)
        for (NSDictionary *dic in self.myimagearray) {
            NSString *name = [dic  valueForKey:@"imageName"];
            NSString *extension = [name  pathExtension];
            //   NSString *extension = [dic  valueForKey:@"imageName"];
            if([extension isEqualToString:@"mp4"])
            {
                [extentionArray addObject:extension];
            }
        }
        /*  {
         
         NSString *str =[directoryContent objectAtIndex: count];
         NSString *extension = [str  pathExtension];
         if([extension isEqualToString:@"mp4"])
         {
         [extentionArray addObject:extension];
         }
         
         }*/
        if (extentionArray.count > 1 || extentionArray.count == 1) {
            
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:@"Information" subTitle:@"Maximum Video Limit has been Reached, Kindly Upgrade to Record More Videos" closeButtonTitle:nil duration:1.0f ];

            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    else  if([PlanName isEqualToString:@"Platinum"])
    {
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToImageFolder error:NULL];
        NSMutableArray *extentionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.myimagearray) {
            NSString *name = [dic  valueForKey:@"imageName"];
            NSString *extension = [name  pathExtension];
            if([extension isEqualToString:@"mp4"])
            {
                [extentionArray addObject:extension];
            }
        }
        //        for (int count = 0; count < (int)[directoryContent count]; count++)
        //        {
        //            NSString *str =[directoryContent objectAtIndex: count];
        //            NSString *extension = [str  pathExtension];
        //            if([extension isEqualToString:@"mp4"])
        //            {
        //                [extentionArray addObject:extension];
        //            }
        //
        //        }
        if (extentionArray.count == 3 || extentionArray.count > 3) {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:@"Information" subTitle:@"Maximum Video Limit has been Reached." closeButtonTitle:nil duration:1.0f ];

            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    return NO;
}




- (void) mergeTwoVideo
{
    
    NSString* video= [pathToImageFolder stringByAppendingPathComponent:videoName];
    NSURL *vedioURL = [NSURL fileURLWithPath:video];
    NSString* audio= [pathToImageFolder stringByAppendingPathComponent:AudioName];
    NSURL *audioURL = [NSURL fileURLWithPath:audio];
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:vedioURL options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime time = audioAsset.duration;
    double durationInSeconds = CMTimeGetSeconds(time);
    if(durationInSeconds != 0)
    {
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                             atTime:kCMTimeZero error:nil];
    }
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime time1 = videoAsset.duration;
    double durationInSeconds1 = CMTimeGetSeconds(time1);
    if(durationInSeconds1 != 0)
    {
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                       ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                        atTime:kCMTimeZero error:nil];
        
    }
    
    ///////
    
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
    /////////
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
    
}




-(void) videorecorderexception
{
    __weak typeof(self) weakSelf =self;
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    [self.view makeToast:@"Saving Video Failed +1"];
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
        alertText = @"It looks like your privacy settings are preventing us from accessing your camera to capyure image and video. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera/microPhone on.\n\n3. Open this app and try again.";
        
        alertButton = @"Go";
    }
    else
    {
        alertText = @"It looks like your privacy settings are preventing us from accessing your camera to capyure image and video. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera/microPhone on.\n\n5. Open this app and try again.";
        
        alertButton = @"OK";
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Message"
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
    //            CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    //            CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *UDID = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"identifier"];
    NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
    videoName = imageName;
    NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
    
    //NSString * _newVideoPath = [pathToImageFolder stringByAppendingPathComponent:@"video.mp4"];
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
}





-(void)SaveVideo
{
    NSLog(@"videoName:%@",videoName);
   
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    NSString *UDID = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"identifier"];
    NSString* imageName = [NSString stringWithFormat:@"%@_%@.mp4",UDID,epochTime];
    // videoName = imageName;
    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:videoName forKey:@"imageName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [myimagedict setObject:videoName forKey:@"imageName"];
    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
    [myimagedict setObject:@"camera" forKey:@"load_tookout_type"];
    [myimagedict setObject:latitude forKey:@"latitude"];
    [myimagedict setObject:longitude forKey:@"longitude"];
    
    
    NSLog(@"pics %@",pics);
    NSString* myDocumentPath= [pathToImageFolder stringByAppendingPathComponent:videoName];
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
    [self.myimagearray addObject:myimagedict];
    NSLog(@" the taken photo is:%@",self.myimagearray);
    //reloading the collection view
    
    ServerUtility * imge = [[ServerUtility alloc] init];
    NSLog(@"my %@",myimagedict);
    imge.picslist = _myimagearray;
    [[NSUserDefaults standardUserDefaults]setObject:_myimagearray forKey:@"picslist"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"my3 %@",imge.picslist);
    [self.parkLoad setObject:self.myimagearray forKey:@"img"];
    [self.collection_View reloadData];
      
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                  
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _imageUploadCountTotalCount.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.myimagearray.count, uploadCountLimit];
    
    /* [self.collection_View reloadData];
     NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
     NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
     NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
     [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];*/
    
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    // NSString *myString = outputFileURL.absoluteString;
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
    [self.view makeToast:@"Saving Video Failed +3"];
    //[locationManager stopUpdatingLocation];
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
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:@"Warning!" subTitle:@"Blur image" closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:@"Warning!" subTitle:@"Low light image" closeButtonTitle:nil duration:1.0f ];
}

//- (IBAction)zoomslider:(UISlider *)sender {
    //float value = [sender value];
    //_zoom.text = [NSString stringWithFormat:@"%f",_zoomSlider.value];
//}
@end

