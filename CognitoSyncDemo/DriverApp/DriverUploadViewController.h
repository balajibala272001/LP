//
//  DriverUploadViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 10/01/2023.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "Constants.h"
#import "MRCircularProgressView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DriverUploadViewControllerDelegate <NSObject>

-(void)uploadFinishCheckParkLoad;
-(void)restartedUploadFinished;
-(void)getAbbriviationByTimeZone:(NSString *)tmeZone;

@end

@interface DriverUploadViewController : UIViewController<CLLocationManagerDelegate>{
    NSMutableDictionary *FinalDict ;
    NSMutableArray *arrrrray;
    NSMutableArray *savedOldValuesArray;
    NSMutableDictionary *details;
}
-(void)uploader;

//advertising
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) IBOutlet UIView *Ad_holder;
@property (strong, nonatomic) IBOutlet UILabel *title_label;
@property (strong, nonatomic) IBOutlet UIView *circle_view;
@property (strong, nonatomic) IBOutlet UILabel *Ad_label;

//@property (nonatomic,strong) NSString * AppAccessVersion;

@property (strong, nonatomic)  IBOutlet UILabel *image_progress;
@property (strong, nonatomic) IBOutlet UILabel *current_load;
@property (strong, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;
@property (strong, nonatomic) id<DriverUploadViewControllerDelegate>uploadDelegate;
@property (strong, nonatomic) IBOutlet UIView *Sub_View;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSMutableArray *arrayWithImages;
@property (nonatomic,strong) NSMutableDictionary *dictMetaData;
@property (nonatomic,strong) NSMutableArray *metaData;
@property (nonatomic,strong) NSMutableDictionary *oldDict;
@property (nonatomic,strong) NSString *UserCategory;
@property (assign,nonatomic) int counter;

@property (assign,nonatomic) int Device_id;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong)NSTimer *myTimer;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentage;
@property (weak, nonatomic) IBOutlet UILabel *totalBatchloads;

@property (strong,nonatomic)NSString *localerror;

@property (strong,nonatomic) UIButton *retry_Btn;

@property (strong,nonatomic) NSString *serverError;
@property (strong,nonatomic) NSString *ErrorLocal;

@property (assign,nonatomic) int load_id;
@property (assign,nonatomic) int tappi_id;
@property (weak, nonatomic) IBOutlet UILabel *upload_lbl;
@property(nonatomic,strong) SCLAlertView *alertbox ;

@property (assign,nonatomic) int pic_count;

@property (strong ,nonatomic) UIBarButtonItem *Upload;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *back_btn;

-(IBAction)back_action_btn:(id)sender;
@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;
@property (weak,nonatomic) SiteData *siteData;

@property (weak, nonatomic) IBOutlet UILabel *SiteName_Value_Label;
@property (weak, nonatomic) IBOutlet UILabel *Category_Value_Label;

@property(weak,nonatomic) NSString *message;

-(IBAction)upload_btn_action:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *upload_btn;

- (IBAction)park_action_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *park_btn;
@property (nonatomic,assign) int IsiteId;
@property (strong,nonatomic) NSMutableArray *savedOldValues;

@property (strong,nonatomic) NSMutableDictionary *savedOldValuesDict;
@property NSDictionary *wholeLoadDict;

@property (weak,nonatomic) NSMutableArray *arraySavedOldValues;


@property  BOOL isEdit;
@property  BOOL isBatchUpload;
@property (weak,nonatomic) IBOutlet UIImageView *gif_img;

//directUpload
@property BOOL isupload;
@property (weak, nonatomic) IBOutlet UIView *adview;
@property (weak, nonatomic) IBOutlet UITextField *mobile_field;


@end

NS_ASSUME_NONNULL_END
