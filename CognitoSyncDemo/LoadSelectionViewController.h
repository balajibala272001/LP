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


@interface LoadSelectionViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UIView * subView;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic) NSString *siteName;
@property (strong,nonatomic) SiteData *siteData;
//@property (weak,nonatomic) IBOutlet UIView *parent;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tblTopConstraint;
@property(strong,nonatomic) UIView *customAlertView;
@property (strong, nonatomic) IBOutlet UIButton *Load_btn;
@property (nonatomic,strong)NSMutableArray *sitesNameArr;
- (IBAction)Load_btn_action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *siteName_Lbl;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *lowStorageLabel;

@property (strong,nonatomic) IBOutlet UIView * select_all_view;

@property (nonatomic,assign) int count;

@property (strong,nonatomic) NSMutableArray *arrayDisplayOldValues;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll_View;

@property (strong, nonatomic) IBOutlet UIView *inner_view;
@property (strong, nonatomic) IBOutlet UITableView *load_Table_View;

@property (assign,nonatomic) int tag;
@property (strong,nonatomic) NSMutableArray *imageArray;


@property (assign,nonatomic)int loadNumber;

@property (assign,nonatomic) NSMutableDictionary *dict;


@property (weak,nonatomic) NSString *field_label1;
@property (weak,nonatomic) NSString *field_label2;

@property (weak,nonatomic) NSString *field_value1;
@property (weak,nonatomic) NSString *field_value2;


@property (strong,nonatomic)NSMutableArray *metaData;


@end
