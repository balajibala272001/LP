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
@property (strong,nonatomic) NSMutableArray * instructData;

//@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *imageforcapture;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;
- (IBAction)takeimageBtnClick:(id)sender;
- (IBAction)startVideoBtnClick:(id)sender;

@property (nonatomic,strong)NSMutableArray *myimagearray;
@property (nonatomic,strong)NSMutableArray *ArrayofstepPhoto;
@property (nonatomic,strong)NSMutableArray *parkLoadArray;
@property (nonatomic,strong)NSMutableDictionary *parkLoad;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
-(void)reset_tapped;
-(IBAction)VideoButtonClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)BlurImgClickAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_reset;
-(IBAction)btn_Reset:(id)sender;
-(IBAction)takephoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;
-(IBAction)logoutClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *imageUploadCountTotalCount;

@property (weak, nonatomic) IBOutlet UILabel *uploadOriginalSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadOCropingSize;
@property (weak, nonatomic) IBOutlet UILabel *uploadFinalSize;

@property  BOOL movetolc;

- (void)drawTextInRect:(CGRect)rect;
@property (strong,nonatomic) NSString *siteName;

@property (strong,nonatomic) SiteData *siteData;

@property (assign) BOOL firstTime;

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

//AddOn7
@property (strong,nonatomic) NSString * InstructNumb;
@property (strong,nonatomic) NSString *InstructName;
@property (assign,nonatomic) int InstructCount;
@property (strong,nonatomic) IBOutlet UIButton* Labelsteps;
@property (assign,nonatomic) selectedTab *selectedTab;
@property (assign,nonatomic) int wholeStepsCount;
@property (strong,nonatomic) IBOutlet UIView* LabelstepsView;
@property (assign,nonatomic) int imageCount;
@property (strong,nonatomic) UIButton *next;
@property (assign,nonatomic) int nxt_clicked;
@property (strong,nonatomic) NSMutableArray *arrImage;
@property (assign,nonatomic) int gpcCount;

@end

NS_ASSUME_NONNULL_END
