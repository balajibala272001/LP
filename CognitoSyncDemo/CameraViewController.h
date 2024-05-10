//
//  CameraViewController.h
//  sgpcapp
//
//  Created by SmartGladiator on 07/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SiteData.h"
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVBase.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DPVideoMerger.h"
#import "SCLAlertView.h"
#import "Add_on.h"
#import <CoreMotion/CoreMotion.h>

@import CoreLocation;


@interface CameraViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate,AVCapturePhotoCaptureDelegate>
    {
        CLLocationManager *locationManager;
        NSString *latitude, *longitude;
    }
//zoom
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

- (IBAction)docBtnClick:(id)sender;
- (IBAction)videoBtnTwoWayOnClick:(id)sender;
- (IBAction)imgBtnTwoWayOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *twoWayBtnLayout;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnTwoWay;
@property (weak, nonatomic) IBOutlet UIButton *videoBtnTwoWay;

@property (strong, nonatomic) NSString *selectedDocType;
@property (strong, nonatomic) NSString *selectedDocTypeId;
@property (strong, nonatomic) NSString *docType;
@property (strong, nonatomic) NSString *pageName;

@property (weak, nonatomic) IBOutlet UIButton *docBtn;
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
//@property (weak, nonatomic) IBOutlet UILabel *uploadFinalSize;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

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

//addon_8
//@property (nonatomic, assign) int IsiteId;
//@property (nonatomic, assign) int currentTappiCount;
//@property (nonatomic, assign) int instruction_number;
//@property (strong, nonatomic) NSMutableArray *temparr;
//@property (nonatomic, strong) Add_on *addon;
//@property (nonatomic, strong)NSMutableArray *totalImagearray;
@property (nonatomic, strong) NSData *photoData;
@property (nonatomic, strong) NSTimer *longPressTimer;

@property (strong, nonatomic) CMMotionManager *motionManager;


@end
