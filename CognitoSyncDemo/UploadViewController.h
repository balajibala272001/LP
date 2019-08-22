//
//  UploadViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
{
    NSMutableDictionary *FinalDict ;
    
    NSMutableArray *arrrrray;
    
    NSMutableArray *savedOldValuesArray;
    NSMutableDictionary *details;

    
    
    
}


@property (strong, nonatomic) IBOutlet UIView *Sub_View;


@property (nonatomic,assign) int currentIndex;
@property (nonatomic ,strong) NSString *category;


@property (nonatomic,strong) NSMutableArray *arrayWithImages;
@property (nonatomic,strong) NSMutableDictionary *dictMetaData;

@property (nonatomic,strong) NSString *UserCategory;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong)NSTimer *myTimer;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (strong,nonatomic)NSString *localerror;



@property (strong,nonatomic) UIButton *retry_Btn;

@property (strong,nonatomic) NSString *serverError;
@property (strong,nonatomic) NSString *ErrorLocal;

@property (assign,nonatomic) int load_id;
@property (weak, nonatomic) IBOutlet UILabel *upload_lbl;


@property(strong,nonatomic) UIView *customAlertView;

//@property (nonatomic,strong) UIColor *color;
//@property (nonatomic,strong)UIImage *icon;
//
//@property (nonatomic,assign) OpinionzAlertIcon iconType;
//
//

@property (assign,nonatomic) int pic_count;
//- (IBAction)back_Button:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *back_btn;


//@property (weak,nonatomic) UINavigationItem *Upload;

@property (strong ,nonatomic) UIBarButtonItem *Upload;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *back_btn;

- (IBAction)back_action_btn:(id)sender;
@property (weak,nonatomic) NSString *sitename;
@property (weak, nonatomic) IBOutlet UILabel *SiteName_Value_Label;
@property (weak, nonatomic) IBOutlet UILabel *Category_Value_Label;


@property(weak,nonatomic) NSString *message;

//
- (IBAction)upload_btn_action:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *upload_btn;

- (IBAction)park_action_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *park_btn;

@property (strong,nonatomic)NSMutableArray *savedOldValues;

@property (strong,nonatomic) NSMutableDictionary *savedOldValuesDict;

//
@property (weak,nonatomic) NSMutableArray *arraySavedOldValues;


@property  BOOL isEdit;


@end
