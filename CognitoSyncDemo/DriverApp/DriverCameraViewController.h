//
//  DriverCameraViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 12/01/2023.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SiteData.h"
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DPVideoMerger.h"
#import "SCLAlertView.h"
#import "Add_on.h"
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriverCameraViewController : UIViewController
<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate,AVCapturePhotoCaptureDelegate>
    {
        CLLocationManager *locationManager;
        NSString *latitude, *longitude;
    }

//@property (weak, nonatomic)  UISlider *zoomSlider;
@property (strong, nonatomic) NSString *siteName;
@property (strong, nonatomic) NSString *newstring;

@property (nonatomic, strong)NSMutableArray *myimagearray;
@property (nonatomic, strong)NSMutableArray *parkLoadArray;
@property (nonatomic, strong)NSMutableDictionary *parkLoad;

@property (assign, nonatomic) int value;
@property (assign, nonatomic) int load_number;
@property (assign, nonatomic) int tapCount;

@property (assign) BOOL firstTime;
@property  BOOL isEdit;

@property (nonatomic, strong) SCLAlertView *alertbox ;
@property (strong, nonatomic) SiteData *siteData;

//multiple_img_selector
@property (strong, nonatomic) NSMutableArray *arrImage;
@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;
@property (weak, nonatomic) IBOutlet UISlider *progressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *imageforcapture;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;

-(IBAction)takeimageBtnClick:(id)sender;
-(IBAction)startVideoBtnClick:(id)sender;
-(IBAction)VideoButtonClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)BlurImgClickAction:(id)sender;
-(IBAction)btn_NextTapped:(id)sender;
-(IBAction)takephoto:(id)sender;
//-(IBAction)back_action_btn:(id)sender;
-(IBAction)clickImageAction:(id)sender;
-(IBAction)innerVideoButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn_Next;
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *captureAction;
@property (weak, nonatomic) IBOutlet UIButton *innervideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *startvideoBtn;

@property (weak, nonatomic) IBOutlet UILabel *imageUploadCountTotalCount;
@property (weak, nonatomic) IBOutlet UILabel *uploadOriginalSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadOCropingSize;

@property (strong, nonatomic) CMMotionManager *motionManager;
//@property (weak, nonatomic) IBOutlet UILabel *uploadFinalSize;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
- (void)setFlashModee:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device;
@end

NS_ASSUME_NONNULL_END
