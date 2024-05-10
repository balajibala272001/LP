//
//  SiteViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/19/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"
#import "SCLAlertView.h"
#import "UploadViewController.h"
#import "Add_on.h"

@interface SiteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UploadViewControllerDelegate,CLLocationManagerDelegate>{
    UploadViewController *UploadVC;
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
}
@property (nonatomic,strong) NSMutableArray *instructData;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic) NSString *ErrorLocal;
@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak,nonatomic) SiteData *siteData;
@property (weak,nonatomic) SiteData *newsiteData;

@property (weak,nonatomic) Add_on * add_on;
@property (nonatomic,assign) int IsiteId;
@property (weak, nonatomic) IBOutlet UITableView *simple_tbleView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *i;

@property (nonatomic,strong)NSMutableArray *sitesNameArr;
@property  BOOL movetolc;
@property  BOOL movetoCp;

//Addon8
@property (nonatomic, assign) int currentTappiCount;
@property (nonatomic, assign) int instruction_number;
@property (nonatomic,strong) NSMutableArray *looping_metaDataArray;
@property (nonatomic,strong) NSMutableArray *base_metaDataArray;

@end
