//
//  SiteViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/19/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteData.h"


@interface SiteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UIView *sub_view;

@property (weak, nonatomic) IBOutlet UITableView *simple_tbleView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *i;

@property (nonatomic,strong)NSMutableArray *sitesNameArr;

@end
