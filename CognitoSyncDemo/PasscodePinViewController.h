//
//  PasscodePinViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/26/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteViewController.h"

@interface PasscodePinViewController : UIViewController

{


    __weak IBOutlet UIView *_pinCirclesView;
    __weak IBOutlet UIView *_errorView;
    __weak IBOutlet UILabel *pinLabel;
    __weak IBOutlet UILabel *pinErrorLabel;
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *cancelButton;
    NSMutableString *_inputPin;
    NSMutableArray *_circleViewList;
}

//@property (nonatomic,assign) id<> delegate;


@property (nonatomic, strong) NSString *errorTitle;
@property (nonatomic, strong) NSString *pinTitle;
@property (nonatomic, assign) BOOL cancelButtonHidden;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) BOOL isSettingPinCode;

@property (strong, nonatomic) IBOutlet UIView *sub_view;

- (IBAction)Logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *InnerView;


@property (nonatomic,strong) NSString *struserName;

@property (nonatomic,strong)NSMutableArray *sites;


@property (nonatomic,strong)SiteViewController *SiteVC2;


@property (nonatomic, strong) NSMutableArray *arrSites;

@end
