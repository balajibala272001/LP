//
//  CaptureScreenViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 31/08/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
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
#import "selectedTab.h"
#import <CoreMotion/CoreMotion.h>
<<<<<<< HEAD
#import <AVKit/AVKit.h>
#import "CapturePreviewScreenController.h"
=======
>>>>>>> main

NS_ASSUME_NONNULL_BEGIN
@import CoreLocation;
@interface CaptureScreenViewController : UIViewController <UICollectionViewDataSource ,UICollectionViewDelegate,UIImagePickerControllerDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate,AVCapturePhotoCaptureDelegate>
{
    CLLocationManager *locationManager;
    NSString *latitude, *longitude;
}
//zoom
@property (weak,nonatomic)  UISlider *zoomSlider;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressBar;
@property (strong,nonatomic) NSString *newstring;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *startvideoBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIImageView *DefaultImage;
@property (weak, nonatomic) IBOutlet UIButton *PreviewButton;

@property(strong, nonatomic) AVPlayer *playVideo;
=======
@property (nonatomic, strong) UIImage *capturedImage;
>>>>>>> main
//@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *imageforcapture;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;

<<<<<<< HEAD
@property(strong, nonatomic) NSString *extention;
=======

>>>>>>> main
@property (nonatomic,strong)NSMutableArray *myimagearray;
@property (nonatomic,strong)NSMutableArray *parkLoadArray;
@property (nonatomic,strong)NSMutableDictionary *parkLoad;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;

-(void)reset_tapped;
- (void)drawTextInRect:(CGRect)rect;

-(IBAction)VideoButtonClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)BlurImgClickAction:(id)sender;
-(IBAction)takeimageBtnClick:(id)sender;
-(IBAction)startVideoBtnClick:(id)sender;
-(IBAction)btn_Reset:(id)sender;
-(IBAction)takephoto:(id)sender;
-(IBAction)logoutClicked:(id)sender;
-(IBAction)innerVideoButtonAction:(id)sender;
-(IBAction)clickImageAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_reset;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;
=======
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;
@property(weak,nonatomic) IBOutlet UIButton * btn_Logout;
>>>>>>> main

@property (weak, nonatomic) IBOutlet UILabel *imageUploadCountTotalCount;
@property (weak, nonatomic) IBOutlet UILabel *uploadOriginalSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadOCropingSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadFinalSize;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *captureAction;
@property (weak, nonatomic) IBOutlet UIButton *innervideoBtn;
<<<<<<< HEAD
=======
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;
@property (weak, nonatomic) IBOutlet UIButton *ViewButton;
@property (weak, nonatomic) IBOutlet UIView *BtmView;
@property (weak, nonatomic) IBOutlet UIButton *FlashButton;

>>>>>>> main

@property  BOOL movetolc;
@property  BOOL isEdit;
@property (assign) BOOL firstTime;

@property (strong,nonatomic) NSString *siteName;
@property (strong,nonatomic) SiteData *siteData;

@property (assign,nonatomic) int load_number;
@property (assign,nonatomic) int tapCount;

@property(nonatomic,strong) SCLAlertView *alertbox ;

//AddOn7
@property (strong,nonatomic) NSString * InstructNumb;
@property (strong,nonatomic) NSString *InstructName;
<<<<<<< HEAD
=======
@property (strong,nonatomic) NSString *InstructFile;
>>>>>>> main
@property (assign,nonatomic) int InstructCount;
@property (strong,nonatomic) IBOutlet UIButton* Labelsteps;
@property (assign,nonatomic) selectedTab *selectedTab;
@property (assign,nonatomic) int wholeStepsCount;
@property (strong,nonatomic) IBOutlet UIView* LabelstepsView;
@property (nonatomic,strong) NSMutableArray *ArrayofstepPhoto;
@property (assign,nonatomic) int imageCount;
@property (strong,nonatomic) UIButton *next;
@property (strong,nonatomic) UIButton *back;
@property (assign,nonatomic) int nxt_clicked;
@property (strong,nonatomic) NSMutableArray *arrImage;
@property (assign,nonatomic) int gpcCount;
@property (strong,nonatomic) NSMutableArray * instructData;
@property (strong,nonatomic) NSMutableArray *ParkloadImages;
@property  BOOL isTrue;
@property (strong, nonatomic) CMMotionManager *motionManager;
<<<<<<< HEAD


=======
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (nonatomic) CGSize previewScreensize;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *fullText;
>>>>>>> main
@end

NS_ASSUME_NONNULL_END
