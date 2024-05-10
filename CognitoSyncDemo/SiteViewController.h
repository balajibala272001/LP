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
@interface SiteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UploadViewControllerDelegate>{
    UploadViewController *UploadVC;
    
}

@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic) NSString *ErrorLocal;
@property (weak, nonatomic) IBOutlet UIView *sub_view;

@property (weak, nonatomic) IBOutlet UITableView *simple_tbleView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *i;

@property (nonatomic,strong)NSMutableArray *sitesNameArr;
@property  BOOL movetolc;
@end
