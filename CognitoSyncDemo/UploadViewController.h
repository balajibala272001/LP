//
//  UploadViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "Constants.h"
#import "MRCircularProgressView.h"

@protocol UploadViewControllerDelegate <NSObject>

-(void)uploadFinishCheckParkLoad;
-(void)restartedUploadFinished;
-(void)getAbbriviationByTimeZone:(NSString *)tmeZone;

@end

@interface UploadViewController : UIViewController<CLLocationManagerDelegate>
{
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
@property (strong, nonatomic) id<UploadViewControllerDelegate>uploadDelegate;
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
@property (weak, nonatomic) IBOutlet UILabel *upload_lbl;
@property(nonatomic,strong) SCLAlertView *alertbox ;

@property (assign,nonatomic) int pic_count;

@property (strong ,nonatomic) UIBarButtonItem *Upload;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *back_btn;

-(IBAction)back_action_btn:(id)sender;
@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;
@property (weak,nonatomic) SiteData *siteData;
@property (weak, nonatomic) IBOutlet UILabel *site_name_label;
@property (weak, nonatomic) IBOutlet UILabel *category_lbl;
@property (weak, nonatomic) IBOutlet UILabel *total_load_lbl;
@property (weak, nonatomic) IBOutlet UILabel *total_image_lbl;

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
@property (weak, nonatomic) IBOutlet UILabel *total_image_title;
@property (weak, nonatomic) IBOutlet UILabel *total_load_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_laod_title_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_load_lbl_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_image_title_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_image_lbl_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_load_dot_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_image_dot_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_img_title_const_main;

//directUpload
@property BOOL isupload;
@property BOOL isUploadingPreviousLot;
@end
