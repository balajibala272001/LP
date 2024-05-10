//
//  CaptureScreenViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 31/08/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

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


@interface CaptureScreenViewController ()<CreolePhotoSelectionDelegate>
{
    NSString* pathToImageFolder;
    NSMutableArray *pics;
    NSString *videoName;
    NSString *AudioName;
    NSTimer *timer;
    NSTimeInterval totalCountdownInterval;
    NSDate* startDate;
    int timecount;
    NSString  *PlanName;
    NSMutableDictionary *recordSetting;
    NSInteger currentLoadNumber;
    UILabel *flashButton, *flashLabel, *zoomlbl;
    bool imagepick;
    bool pickimage;
    bool reset;
    AZCAppDelegate *delegateVC;
    bool cameraboolToRestrict;
    int numberofphotoCapturedforsteps;
    int TotalNoOfPhoto;
    ServerUtility * imge;
    NSMutableArray *tempImgarr;
}

-(UIImage *)generateThumbImage : (NSString *)filepath;

@end

@implementation CaptureScreenViewController

int uploadCount = 325;

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

-(void) flash
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    //reset = false;
    NSLog(@"self.ArrayofstepPhoto:%@",self.ArrayofstepPhoto);
    if(self.ArrayofstepPhoto.count != 0){
        self.nxt_clicked = [[[NSUserDefaults standardUserDefaults]valueForKey:@"nxtCount"]intValue];
        self.wholeStepsCount = self.nxt_clicked - 1;
    }else{
        self.nxt_clicked = 1;
    }
 
    imge = [[ServerUtility alloc] init];
    if(self.ArrayofstepPhoto == nil){
        self.ArrayofstepPhoto = [[NSMutableArray alloc]init];
    }
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    _instructData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
    cameraboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    NSLog(@"cameraboolToRestrict:%d",cameraboolToRestrict);
    imagepick = false;
    pickimage = false;
    pathToImageFolder = [[delegate getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ApplicationEnterBackGround" object:nil];
    uploadCount = self.siteData.uploadCount;
    // uploadCount = 10;
    self.tapCount = 0;
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"IOSVersion %@",iOSVersion);
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    NSLog(@"self.parkLoadArray1 :%@",self.parkLoadArray);
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
   // self.myimagearray = [[self.parkLoad objectForKey:@"img"]mutableCopy];
    if (!(self.myimagearray.count > 0)) {
        self.myimagearray = [[NSMutableArray alloc]init];
    }
    self.tapCount = self.myimagearray.count;
    SiteData *sitesssClass = delegate.siteDatas;
    //int networkid = sitesssClass.networkId;
    NSLog(@"the selected site:%@",sitesssClass.siteName);
    PlanName = sitesssClass.planname;
    delegate.PlanName = PlanName;
    self.firstTime = YES;
    int total_photo = 0;
    NSLog(@"_instructData.count:%lu",(unsigned long)_instructData.count);
    NSLog(@"selectedTab:%@",self.selectedTab);
    if(self.selectedTab == nil){
        for(int i=0; i<_instructData.count;i++){
            NSLog(@"i:%d",i);
            NSMutableDictionary *dict = [[_instructData objectAtIndex:i] mutableCopy];
            int countt = [[dict objectForKey:@"count_for_step_pics"]intValue];
            total_photo = total_photo + countt;
            if(self.myimagearray.count < total_photo){
                [self proceed];
            }else if(self.myimagearray.count == total_photo){
                if(_instructData.count > i+1 ){
                    self.wholeStepsCount= i+1;
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
                [self.myimagearray addObject:newdict];
                [self.collection_View reloadData];
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
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //next button
    self.next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.next addTarget:self action:@selector(btn_NextTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithCustomView:self.next];
    self.navigationItem.rightBarButtonItem = NextButton;
    //self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    //self.next.hidden = YES;
    
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
        flashButton.text = NSLocalizedString(@"OFF",@"");
        flashButton.tag=1;
        flashButton.userInteractionEnabled=TRUE;
        [self.imageforcapture addSubview:flashButton];
        
        flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-70, flashButton.frame.origin.y, 100, 30)];
        flashLabel.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        flashLabel.textColor = [UIColor whiteColor];
        flashLabel.textAlignment = NSTextAlignmentCenter;
        flashLabel.text = NSLocalizedString(@"Flash Mode:",@"");
        
        [self.imageforcapture addSubview:flashLabel];
        [self.imageforcapture bringSubviewToFront:flashButton];
        [self.imageforcapture bringSubviewToFront:flashLabel];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashToggle:)];
        [flashButton addGestureRecognizer:recognizer];
    }
    //flash mode
    
    
    
    //Corner radius for button
    self.btn_reset.layer.cornerRadius = 10;
    self.btn_reset.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:189/255.0 alpha:1.0].CGColor;
    self.btn_Logout.layer.cornerRadius = 10;
    self.btn_Logout.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    //self.Labelsteps.layer.cornerRadius = 10;
    self.Labelsteps.layer.borderColor = [UIColor blackColor].CGColor;
    self.Labelsteps.layer.borderWidth = 1;
    self.Labelsteps.layer.cornerRadius = 10;
    [self.Labelsteps sizeToFit];
    self.Labelsteps.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
    //self.Labelsteps.preferredMaxLayoutWidth = 400;
    //NSLog(@"%f",self.Labelsteps.preferredMaxLayoutWidth);
    NSLog(@"%f",self.LabelstepsView.frame.size.width);
    //self.Labelsteps.adjustsFontSizeToFitWidth = YES;
    //self.Labelsteps.numberOfLines = 2;

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
    if([PlanName isEqualToString:@"Silver"] || [PlanName isEqualToString:@"Bronze"])
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
    } else {
        // impossible, unknown authorization status
    }
   
    //FreeTier-SUresh
    if([self.siteData.planname isEqual:@"FreeTier"]){
        if (uploadCount >= 50) {
            uploadCount = 50;
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
    //if (([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  && cameraboolToRestrict  == FALSE) {

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

    //}else{
    //    [_zoomSlider setHidden:TRUE];
    //    [zoomlbl setHidden:TRUE];
    //}
        //GalleryMode
    //self.siteData.addon_gallery_mode=@"FALSE";

    if(self.siteData.addon_gallery_mode.boolValue==TRUE)
        [self.btn_Logout setImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
    else
        [self.btn_Logout setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
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
    
    
    if([self.parkLoad valueForKey:@"category"]){
  
        NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
        for(NSUInteger i = array.count - 1;i>=0;i--) {
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
        if (self.ArrayofstepPhoto.count > 0 || self.myimagearray.count > 0 ) {
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
            
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
    titleLabel.textColor = [UIColor blackColor];

    
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
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)viewWillAppear:(BOOL)animated {
    //reset = false;
    //NSDictionary*dict;
    tempImgarr = [[NSMutableArray alloc]init];
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    if(self.ArrayofstepPhoto == nil){
        self.ArrayofstepPhoto = [[NSMutableArray alloc]init];
    }
    int total_photo = 0;
    NSLog(@"_instructData.count:%lu",(unsigned long)_instructData.count);
    for(int i=0; i<_instructData.count;i++){
        NSLog(@"i:%d",i);
        NSMutableDictionary *dict = [[_instructData objectAtIndex:i] mutableCopy];
        int countt = [[dict objectForKey:@"count_for_step_pics"]intValue];
        total_photo = total_photo + countt;
    }
   /* if(self.selectedTab == nil && imagepick == FALSE){
        for(int i=0; i<_instructData.count;i++){
            NSLog(@"i:%d",i);
            NSMutableDictionary *dict = [[_instructData objectAtIndex:i] mutableCopy];
            int countt = [[dict objectForKey:@"count_for_step_pics"]intValue];
            total_photo = total_photo + countt;
            if(self.myimagearray.count <= total_photo){
                [self proceed];
            }else if(self.myimagearray.count >= total_photo){
                if(_instructData.count > i+1 ){
                    self.wholeStepsCount++;
                }
            }
//            if(i+1 == _instructData.count){
//                self.myimagearray = tempImgarr;
//            }
        }
    }*/
    
    if(imagepick == FALSE){
      [self Instruc];
    }
    
    if((self.alertbox == nil) || (![self.alertbox isVisible]))
    {
        NSString *name;
        for (NSDictionary *dic in self.myimagearray) {
          name = [dic valueForKey:@"imageName"];
        }
        if(pickimage == FALSE && self.selectedTab == nil){
            if(self.myimagearray.count != 0 || (self.ArrayofstepPhoto.count != 0)){
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(reset_tapped) backgroundColor:Red];
                [self.alertbox addButton:NSLocalizedString(@"Proceed",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking Proceed button will Continue in Current load",@"") closeButtonTitle:nil duration:1.0f ];
            }
        }
    }
    imagepick = false;
    pickimage = false;

    NSLog(@"myimagearray:%@",self.myimagearray);
    NSLog(@"total_photo:%d",total_photo);
    NSLog(@"self.myimagearray.count:%lu",(unsigned long)self.myimagearray.count);

    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"CameraVC";
    [[NSUserDefaults standardUserDefaults] setValue:@"CameraVC" forKey:@"CurrentVC"];
    for (NSDictionary *dic in self.myimagearray) {
        
        NSString *name = [dic valueForKey:@"imageName"];
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


    NSLog(@"%f",self.view.frame.size.height * 0.09);


    if(self.startvideoBtn.isHidden == YES){
        if(delegate.isEnterForegroundCamera == YES )
        {
            delegate.isEnterForegroundCamera = NO;
            [self.view makeToast: NSLocalizedString(@"Tap to Take Pictures",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
            //[self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
        }
        
    }
    if(self.startvideoBtn.isHidden == NO){
        if(delegate.isEnterForegroundVideo == YES )
        {
            delegate.isEnterForegroundVideo = NO;
            [self.view makeToast:  NSLocalizedString(@"Tap On Video Icon To Record",@"") duration:2.0 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"tap"] style:nil completion:nil];
            //[self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
        }
    }
    [self addRoundedIconWithBorder ];
    // [session startRunning];


   // if (([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"])  && cameraboolToRestrict  == FALSE) {
        [zoomlbl setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
        [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
    //}
    [flashLabel setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];
    [flashButton setHidden:self.videoBtn.backgroundColor != UIColor.whiteColor];

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
    //Initlize array
    _arrImage = nil;
    _arrImage = [NSMutableArray new];
    _arrImage = [aryPhoto mutableCopy]; //mainImage, Asset, selected
    NSLog(@"info:%@",_arrImage);
    
    //Gallery Screen deleted image picking
    if(self.selectedTab != nil){
        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
            NSDictionary * newdict = [[NSDictionary alloc]init];
            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
            {
                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                    //moving to next screen
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
                    GalleryVC.instructData =[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];

                    [self.navigationController pushViewController:GalleryVC animated:YES];
                }
            }
        }
        //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //self.next.hidden = false;
        [self btn_NextTapped:self.view];

    }
    
    NSLog(@"_arrImage:%@",_arrImage);
    int pos = 0;
    for (NSDictionary *dict in _arrImage)
    {
      @autoreleasepool {
        //size_conversion
        self.tapCount ++;
        pos ++;
        UIImage *chosenImage = [dict valueForKey:@"mainImage"];
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
            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
        }else{
            imageSize = CGSizeMake(1440,2160);
            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
        }
        UIGraphicsBeginImageContext(imageSize);
        [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
            
        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
         
        NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
        NSString *UDID = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"identifier"];
        NSString* imageName = [NSString stringWithFormat:@"%@_%@_%d.jpg",UDID,epochTime,pos];
        NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];

        [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"imageName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
        [myimagedict setObject:imageName forKey:@"imageName"];
        [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
        [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
        [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"latitude"];
        [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"longitude"];
        
        
        //NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
        NSString *islowlight=@"FALSE";
        [myimagedict setObject:islowlight forKey:@"brightness"];
        [myimagedict setObject:@"FALSE" forKey:@"variance"];
        if(self.selectedTab != nil){
            [self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
        }else{
            [self.myimagearray addObject:myimagedict];
        }
        NSLog(@" the taken photo is:%@",self.myimagearray);
            
        //reloading the collection view
        [self.collection_View reloadData];
        NSLog(@"my %@",myimagedict);
        imge.picslist = _myimagearray;
        //[server.picslist addObjectsFromArray:_myimagearray];
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
                if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                {
                    if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                    }
                }
            }
            //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //self.next.hidden = false;
           // [self btn_NextTapped:self.view];

        }
        else if(numberofphotoCapturedforsteps == TotalNoOfPhoto)
        {
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
                 [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
             }
         }
      }
   }
}


//SinglePicker
/*- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:YES completion:NULL];

    self.tapCount ++;
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
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
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
    }else{
        imageSize = CGSizeMake(1440,2160);
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
    }
    UIGraphicsBeginImageContext(imageSize);
    [chosenImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
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
    [myimagedict setObject:self.InstructNumb forKey:@"InstructNumber"];
    [myimagedict setObject:imageName forKey:@"imageName"];
    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
    [myimagedict setObject:@"gallery" forKey:@"load_tookout_type"];
    [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"latitude"];
    [myimagedict setObject:[NSNumber numberWithFloat:0.0] forKey:@"longitude"];
    
    
    //NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
    NSString *islowlight=@"FALSE";
    [myimagedict setObject:islowlight forKey:@"brightness"];
    [myimagedict setObject:@"FALSE" forKey:@"variance"];
    if(self.selectedTab != nil){
            [self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
    }else{
            [self.myimagearray addObject:myimagedict];
    }
    NSLog(@" the taken photo is:%@",self.myimagearray);
        
    //reloading the collection view
    [self.collection_View reloadData];
    NSLog(@"my %@",myimagedict);
        imge.picslist = _myimagearray;
        //[server.picslist addObjectsFromArray:_myimagearray];
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
                if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
                {
                    if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                        [self.ArrayofstepPhoto replaceObjectAtIndex:i withObject:[self.myimagearray objectAtIndex:self.selectedTab.indexPath]];
                    }
                }
            }
            //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self btn_NextTapped:self.view];

        }
        else if(numberofphotoCapturedforsteps == TotalNoOfPhoto)
         {
             [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
             [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
             [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
             [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             int count = [self->_instructData count];
             NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
             //NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
             NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
             [self.collection_View reloadData];
             NSString *model=[UIDevice currentDevice].model;
             bool needToscroll = FALSE;
             if ([model isEqualToString:@"iPad"] ) {
                 if(self.myimagearray.count>3){s
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
             if(self.wholeStepsCount == count-1)
             {
                [self btn_NextTapped:self.view];
             }else{
                [self.myimagearray removeAllObjects];
                 if(self.wholeStepsCount+1 < _instructData.count){
                     self.wholeStepsCount++;
                 }
                 [self Instruc];
                 
             }
             
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
                 [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
             }
             
         }
}
*/


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
                flashButton.text =NSLocalizedString(@"OFF",@"");
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
    
    [CaptureScreenViewController setFlashMode: AVCaptureFlashModeAuto forDevice:inputDevice];
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
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);    //<<SET MAX DURATION//
    MovieFileOutput.maxRecordedDuration = maxDuration;
    
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;                        //<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
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
    
    CollectionViewCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   // Cell.blur_img.backgroundColor = [UIColor clearColor];
   // Cell.blur_img.tintColor = [UIColor yellowColor];
    if (self.myimagearray.count == 0) {
        Cell.image_View.image = [UIImage imageNamed:@"Placeholder.png"];
        Cell.waterMark_lbl.text = @"";
        [Cell.delete_btn setHidden:YES];
        [Cell.videoicon setHidden:YES];
        [Cell.low_light setHidden:YES];
        [Cell.blur_img setHidden:YES];

    }else
    {
        if (self.myimagearray.count < indexPath.row + 1)
        {
            Cell.image_View.image = [UIImage imageNamed:@"Placeholder.png"];
            Cell.waterMark_lbl.text = @"";
            [Cell.delete_btn setHidden:YES];
            [Cell.videoicon setHidden:YES];
            [Cell.low_light setHidden:YES];
            [Cell.blur_img setHidden:YES];
        }
        else
        {
            NSDictionary *adict =[self.myimagearray objectAtIndex:indexPath.row];
            NSString* imageName = [adict valueForKey: @"imageName"];
            if([[adict valueForKey: @"imageName"] isEqual: @""]){
                Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
            }
            
            if(self.selectedTab == nil)
            {
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
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
                Cell.image_View.image =image;
                [Cell.videoicon setHidden:YES];
                [Cell.delete_btn setHidden:NO];
                [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                [Cell.delete_btn setTag:indexPath.row];

            }else{
                if(imageName.length >4){
                    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                    Cell.image_View.image =image;
                }
                [Cell.videoicon setHidden:YES];
                [Cell.low_light setHidden:YES];
                [Cell.blur_img setHidden:YES];
                [Cell.delete_btn setHidden:YES];
               // [Cell.delete_btn addTarget:self action:Nil forControlEvents:UIControlEventTouchUpInside];
                [Cell.delete_btn setTag:indexPath.row];
            }
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
        }
    }
    return Cell;
    
}

-(void)Instruc
{
    numberofphotoCapturedforsteps = self.myimagearray.count;
    NSLog(@"instructDataa:%@",_instructData);
    NSMutableDictionary *InstructDict = [[_instructData objectAtIndex:self.wholeStepsCount] mutableCopy];
        self.InstructNumb = [InstructDict objectForKey:@"instruction_number"];
        self.InstructName = [InstructDict objectForKey:@"instruction_name"];
        self.InstructCount = [[InstructDict objectForKey:@"count_for_step_pics"]intValue];
    NSLog(@"InstructNumb:%@",self.InstructNumb);
    NSLog(@"InstructName:%@",self.InstructName);
    NSLog(@"InstructCount:%d",self.InstructCount);
//    NSString * str = [NSString stringWithFormat:@"%@", [InstructDict objectForKey:@"count_for_step_pics"]];
//    for(int i = 0; i<_instructData.count; i++){
//        [self.arrCount addObject:str];
//        NSLog(@"self.arrCount:%@",self.arrCount);
//    }
    TotalNoOfPhoto =  self.InstructCount;
   // self.Labelsteps.titleLabel.text =[NSString stringWithFormat:@" %@  ",self.InstructName];
    self.Labelsteps.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.Labelsteps setTitle:[NSString stringWithFormat:@" %@  ",self.InstructName] forState:UIControlStateNormal];
    NSLog(@"self.Labelsteps.titleLabel.text:%@",self.Labelsteps.titleLabel.text);
    [self.collection_View reloadData];

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
   // [self.parkLoad setObject:self.myimagearray forKey:@"img"];
   // [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
   // [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}


//while tapping next button
-(IBAction)btn_NextTapped:(id)sender
{
    NSDictionary*dict;
    for(int i=0; i<self.ArrayofstepPhoto.count; i++){
        dict = [self.ArrayofstepPhoto objectAtIndex:i];
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            break;
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
                [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
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
            GalleryVC.instructData =[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];

            [self.navigationController pushViewController:GalleryVC animated:YES];
        }
    }else{
        if(self.selectedTab != nil && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentVC"] isEqualToString:@"PicViewVC"]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
        }else{
            //next_step
            self.nxt_clicked ++;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
            [self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            int count = [self->_instructData count];
            NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
            //NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
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



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    imagepick = false;
    pickimage = true;
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)clickImageAction:(id)sender
{
    if(self.selectedTab != nil){
        for(int i =0; i<self.ArrayofstepPhoto.count; i++){
            NSDictionary * newdict = [[NSDictionary alloc]init];
            newdict = [self.ArrayofstepPhoto objectAtIndex:i];
            if([[newdict objectForKey:@"InstructNumber"] isEqual:[NSString stringWithFormat: @"%d",self.selectedTab.instructionNumb]])
            {
                if([[newdict objectForKey:@"imageName"] isEqual:@""]){
                    //numberofphotoCapturedforsteps = numberofphotoCapturedforsteps - 1;
                    self.nxt_clicked = self.instructData.count;
                    //capture
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
                        UIImage *capturedImage = [UIImage imageWithData:imageData];
                        CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
                        CGImageRef takenCGImage = capturedImage.CGImage;
                        size_t width = CGImageGetWidth(takenCGImage);
                        size_t height = CGImageGetHeight(takenCGImage);
                        CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                        capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                        CGImageRelease(cropCGImage);
                        UIGraphicsBeginImageContext(capturedImage.size);
                        [capturedImage drawAtPoint:CGPointZero];
                        capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        //REducing the captured image size
                        CGSize imageSize;
                        NSLog(@"Image Quality :%@",self.siteData.image_quality);
                        if ([self.siteData.image_quality isEqual:@"1"]) {
                            imageSize = CGSizeMake(720,1080);
                            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                        }else{
                            imageSize = CGSizeMake(1440,2160);
                            // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                        }
                        UIGraphicsBeginImageContext(imageSize);
                        [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
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
                        NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                        [myimagedict setObject:islowlight
                          forKey:@"brightness"];
                  
                        NSLog(@"pics %@",pics);
                     
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
                        if(self.selectedTab != nil){
                            [self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                        }else{
                            [self.myimagearray addObject:myimagedict];
                        }
                        NSLog(@" the taken photo is:%@",self.myimagearray);
                        //reloading the collection view
                        [self.collection_View reloadData];
                        NSLog(@"my %@",myimagedict);
                        imge.picslist = self.myimagearray;
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
                            //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
                            [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
                            [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                            [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            //self.next.hidden = false;
                            [self btn_NextTapped:self.view];
                            //capture

                        }
                    }
                    }];
                }
            }
        }
    }else{
        numberofphotoCapturedforsteps = numberofphotoCapturedforsteps + 1;

        if(numberofphotoCapturedforsteps <= TotalNoOfPhoto)
        {
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
                    UIImage *capturedImage = [UIImage imageWithData:imageData];
                    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:_imageforcapture.layer.bounds];
                    CGImageRef takenCGImage = capturedImage.CGImage;
                    size_t width = CGImageGetWidth(takenCGImage);
                    size_t height = CGImageGetHeight(takenCGImage);
                    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
                    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
                    capturedImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:capturedImage.imageOrientation];
                    CGImageRelease(cropCGImage);
                    UIGraphicsBeginImageContext(capturedImage.size);
                    [capturedImage drawAtPoint:CGPointZero];
                    capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    //REducing the captured image size
                    CGSize imageSize;
                    NSLog(@"Image Quality :%@",self.siteData.image_quality);
                    if ([self.siteData.image_quality isEqual:@"1"]) {
                        imageSize = CGSizeMake(720,1080);
                        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
                    }else{
                        imageSize = CGSizeMake(1440,2160);
                        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
                    }
                    UIGraphicsBeginImageContext(imageSize);
                    [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
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
                    NSString *islowlight=brightnessValue<=-1?@"TRUE":@"FALSE";
                    [myimagedict setObject:islowlight
                      forKey:@"brightness"];
              
                    NSLog(@"pics %@",pics);
                 
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
                    if(self.selectedTab != nil){
                        [self.myimagearray replaceObjectAtIndex:self.selectedTab.indexPath withObject:myimagedict];
                    }else{
                        [self.myimagearray addObject:myimagedict];
                    }
                    NSLog(@" the taken photo is:%@",self.myimagearray);
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
                        //[self.ArrayofstepPhoto addObjectsFromArray:self.myimagearray];
                        [self.parkLoad setObject:self.ArrayofstepPhoto forKey:@"img"] ;
                        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
                        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        //self.next.hidden = false;
                        //[self btn_NextTapped:self.view];

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
                             
                             [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                         }
                         //needToscroll = FALSE;
                     }
                }
                [self performSelector:@selector(enableAfterSomeTime) withObject:nil afterDelay:1.0];
            }];
            NSLog(@"the array count is :%lu",(unsigned long)self.myimagearray.count);
        }else if(self.myimagearray.count == TotalNoOfPhoto){
             //self.next.hidden = false;
            [self btn_NextTapped:self.view];
        }
    }
}


//While tapping logout button
-(IBAction)logoutClicked:(id)sender {
    
    //GalleryMode
     //self.siteData.addon_gallery_mode=@"FALSE";
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
                CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"multiPicker" bundle:Nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
                objPhotoViewController.strTitle = NSLocalizedString(@"Choose Photos",@"");
                objPhotoViewController.delegate = self;
                objPhotoViewController.arySelectedPhoto = _arrImage;
                //objPhotoViewController.modalPresentationStyle = UIModalPresentationFullScreen;
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
            
        }else{
            [self.view makeToast:NSLocalizedString(@"Limit Exceeded",@"") duration:2.0 position:CSToastPositionCenter];
        }
    }else{
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            if(WeAreRecording  == YES )
            {
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
                        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
                        
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
                [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
                
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
                [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"current_Looping_Count"];
                [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"img_instruction_number"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
                [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"ArrCount"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_name"];
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
    
    
    //if ([self.siteData.planname isEqual:@"Platinum"] || [self.siteData.planname isEqual:@"Gold"] || [self.siteData.planname isEqual:@"FreeTier"]) {
    //    if(cameraboolToRestrict == FALSE){
            [zoomlbl setHidden:FALSE];
            [_zoomSlider setHidden:self.btn_TakePhoto.backgroundColor != UIColor.whiteColor];
            zoomlbl.text = @"1.00 x";
            [_zoomSlider setValue:1];
     //   }
    //}
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
            flashButton.text =NSLocalizedString(@"OFF",@"");
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
        
        alertButton = @"OK";
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
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Blur Image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)btn_Reset:(id)sender
{
    
    if(self.myimagearray.count != 0 || self.nxt_clicked != 1){
        self.nxt_clicked = 1;
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:NSLocalizedString(@"Reset",@"") target:self selector:@selector(reset_tapped) backgroundColor:Red];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking Reset button will delete all pictures in this Load.",@"") closeButtonTitle:nil duration:1.0f ];
    }else{
   
    }
}


-(void)reset_tapped{
    //reset = true;
    self.nxt_clicked = 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.nxt_clicked] forKey:@"nxtCount"];
    self.selectedTab = 0;
    self.wholeStepsCount = 0;
    [self.ArrayofstepPhoto removeAllObjects];
    [self.myimagearray removeAllObjects];
    [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self Instruc];
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collection_View reloadData];
}
@end
