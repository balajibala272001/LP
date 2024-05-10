//
//  LoadSelectionViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 2/15/17.
//  Copyright © 2017 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"
#import "Checkbox.h"
#import "SCLAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "InstructData.h"
#import "Add_on.h"

@interface LoadSelectionViewController : UIViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
}

- (IBAction)Load_btn_action:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sitenameconstraint;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tblTopConstraint;
@property (strong,nonatomic) IBOutlet UIView * subView;
@property (strong, nonatomic) IBOutlet UIButton *Load_btn;
@property (strong, nonatomic) IBOutlet UILabel *siteName_Lbl;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *lowStorageLabel;
@property (strong,nonatomic) IBOutlet UIView * select_all_view;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_View;
@property (strong, nonatomic) IBOutlet UIView *inner_view;
@property (strong, nonatomic) IBOutlet UITableView *load_Table_View;
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (strong,nonatomic) NSString *siteName;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (weak,nonatomic) NSString *field_label1;
@property (weak,nonatomic) NSString *field_label2;
@property (weak,nonatomic) NSString *field_value1;
@property (weak,nonatomic) NSString *field_value2;

@property (nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic) SiteData *siteData;
@property (strong,nonatomic) NSMutableDictionary *selected_siteData;
@property (assign,nonatomic) NSMutableDictionary *dict;

@property (strong,nonatomic) UIView *customAlertView;

@property (nonatomic,assign) int IsiteId;
@property (nonatomic,assign) int count;
@property (assign,nonatomic) int loadNumber;
@property (assign,nonatomic) int tag;

@property (strong,nonatomic) NSMutableArray *arrayDisplayOldValues;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (strong,nonatomic) NSMutableArray *metaData;
@property (nonatomic,strong) NSMutableArray *sitesNameArr;

//Addon8
@property (nonatomic, assign) int currentTappiCount;
@property (nonatomic, assign) int instruction_number;

//directUpload
@property BOOL isupload;

//parkload
@property (nonatomic,strong)NSMutableDictionary *parkLoad;
@property (nonatomic,assign) int tappi_missing;

//parkload_button
@property (strong, nonatomic) IBOutlet UIButton *loadBtn;
@property (strong, nonatomic) IBOutlet UIButton *delete_button;
@property (weak, nonatomic) IBOutlet UIStackView *sitename_lable_stackview;

@end
