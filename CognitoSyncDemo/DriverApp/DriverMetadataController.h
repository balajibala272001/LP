//
//  DriverMetaData.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 23/05/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "igViewController.h"
#import "SiteData.h"
#import "SCLAlertView.h"
#import "ViewController.h"

//saving old data values of meta data
@protocol senddataProtocoll  <NSObject>

-(void)sendDataToPictureConfirmation:(NSArray *)array;

@end

@interface DriverMetadataController :UIViewController<ScannedDelegateIGView,UIImagePickerControllerDelegate,ScannedDelegateView,UITextFieldDelegate>{
    igViewController *IGVC;
}

@property(nonatomic,assign)id<senddataProtocoll> delegate;

@property (weak, nonatomic) IBOutlet UIView *subVieww;
@property (weak, nonatomic) IBOutlet UIView *sub_Vieww;

@property (strong,nonatomic) SiteData *siteData;
@property(nonatomic,strong) SCLAlertView *alertbox ;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_Vieww;
@property (weak, nonatomic) IBOutlet UILabel *topLbl;

@property (nonatomic,assign) int senderTag;
@property (nonatomic,assign) int sub_View_Height;
@property (nonatomic,assign) int fieldId;
@property (nonatomic,assign) int c_fieldId;

@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;

@property (nonatomic,strong) NSMutableArray *arrayOfImagesWithNotes;
@property (nonatomic,strong) NSMutableArray *oldValuesReturn;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *metaDataArray;
@property (nonatomic,strong) NSMutableArray *sitesNameArr;
@property (nonatomic,strong) NSMutableArray *qrMetaDataArray;

@property  BOOL isEdit;
@property  BOOL isRadio;
@property NSDictionary *oldDict;

@property (nonatomic,strong) UIButton *yourButton;
@property (nonatomic,strong) UIButton *checkBoxButton;

//Addon8
@property (nonatomic,assign) int tappi_count;
@property (strong, nonatomic) UITextView *tappi_txt;
@property (strong, nonatomic) UITextView *driver_name_txt;
@property (strong, nonatomic) UITextView *driver_email_mobile_txt;
//@property (nonatomic, assign) int currentTappiCount;
//@property (nonatomic, assign) int instruction_number;

@end
