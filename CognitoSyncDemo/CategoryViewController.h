//
//  CategoryViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 23/03/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//
#import "SiteData.h"
#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import "AZCAppDelegate.h"
#import "Add_on.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryViewController : UIViewController

@property  BOOL isEdit;

@property (strong,nonatomic) IBOutlet UITableView *table_view;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property(nonatomic,strong) IBOutlet UIView *subview ;
@property(nonatomic,strong) NSArray *StaticCategory;
@property (strong,nonatomic) SiteData *siteData;
@property (strong,nonatomic) User *user;
@property (nonatomic,strong) NSMutableArray *arrayOfImagesWithNotes;
@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;
@property (weak,nonatomic) NSMutableArray *oldValuesReturn;
@property (weak,nonatomic) NSString *str;

//api
@property (nonatomic,strong) NSMutableArray *CategoryNameArr;

@end

NS_ASSUME_NONNULL_END
