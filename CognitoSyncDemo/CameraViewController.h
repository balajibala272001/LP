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
@import CoreLocation;


@interface CameraViewController : UIViewController<UICollectionViewDataSource ,UICollectionViewDelegate,UIImagePickerControllerDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate,AVCapturePhotoCaptureDelegate>
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


//@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *imageforcapture;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;
- (IBAction)takeimageBtnClick:(id)sender;
- (IBAction)startVideoBtnClick:(id)sender;

@property (nonatomic,strong)NSMutableArray *myimagearray;
@property (nonatomic,strong)NSMutableArray *parkLoadArray;
@property (nonatomic,strong)NSMutableDictionary *parkLoad;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;

-(IBAction)VideoButtonClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)BlurImgClickAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_Next;
-(IBAction)btn_NextTapped:(id)sender;
-(IBAction)takephoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;

@property (weak, nonatomic) IBOutlet UILabel *imageUploadCountTotalCount;

@property (weak, nonatomic) IBOutlet UILabel *uploadOriginalSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadOCropingSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadFinalSize;



@property (strong,nonatomic) NSString *siteName;

@property (strong,nonatomic) SiteData *siteData;

@property (assign) BOOL firstTime;


- (IBAction)back_action_btn:(id)sender;

@property (assign,nonatomic) int load_number;
//@property (strong,nonatomic) NSMutableDictionary *oldDict;
//@property (strong,nonatomic) NSMutableArray *arrr;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)clickImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *captureAction;

@property (weak, nonatomic) IBOutlet UIButton *innervideoBtn;
- (IBAction)innerVideoButtonAction:(id)sender;
//@property (strong,nonatomic) NSDictionary *WholeLoadDict;


@property  BOOL isEdit;

@property (assign,nonatomic) int tapCount;
@property(nonatomic,strong) SCLAlertView *alertbox ;
//@property(assign,nonatomic) CLLocationManager *locationManager;



@end
