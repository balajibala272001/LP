//
//  LoadSelectionViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 2/15/17.
//  Copyright © 2017 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"


@interface LoadSelectionViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>



@property (strong,nonatomic) NSString *siteName;
@property (strong,nonatomic) SiteData *siteData;
@property (strong, nonatomic) IBOutlet UIButton *Load_btn;
- (IBAction)Load_btn_action:(id)sender;

- (IBAction)back_action_btn:(id)sender;

- (IBAction)load_action_btn1:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *load_btn1;

- (IBAction)load_action_btn2:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *load_btn2;

- (IBAction)load_action_btn3:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *load_btn3;



- (IBAction)load_action_btn4:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *load_btn4;




- (IBAction)load_action_btn5:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *load_btn5;

@property (nonatomic,assign) int count;



@property (strong,nonatomic) NSMutableArray *arrayDisplayOldValues;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll_View;

@property (strong, nonatomic) IBOutlet UIView *inner_view;
@property (strong, nonatomic) IBOutlet UITableView *load_Table_View;

@property (assign,nonatomic) int tag;
@property (strong,nonatomic) NSMutableArray *imageArray;


@property (assign,nonatomic)int loadNumber;
@property (assign,nonatomic) NSMutableDictionary *dict;



@property (weak,nonatomic) NSString *field_value1;
@property (weak,nonatomic) NSString *field_value2;


@property (weak,nonatomic)NSMutableArray *metaData;

@end
