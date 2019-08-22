//
//  CameraViewController.h
//  sgpcapp
//
//  Created by SmartGladiator on 07/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SiteData.h"
#import <CoreLocation/CoreLocation.h>
@import CoreLocation;


@interface CameraViewController : UIViewController<UICollectionViewDataSource ,UICollectionViewDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet UIView *imageforcapture;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;

@property (nonatomic,strong)NSMutableArray *myimagearray;
@property (weak, nonatomic) IBOutlet UIButton *btn_Next;
-(IBAction)btn_NextTapped:(id)sender;
-(IBAction)takephoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakePhoto;




@property (strong,nonatomic) NSString *siteName;

@property (strong,nonatomic) SiteData *siteData;

@property (assign) BOOL firstTime;


- (IBAction)back_action_btn:(id)sender;

@property (assign,nonatomic) int load_number;
@property (strong,nonatomic) NSMutableDictionary *oldDict;
@property (strong,nonatomic) NSMutableArray *arrr;


@property (strong,nonatomic) NSDictionary *WholeLoadDict;


@property  BOOL isEdit;

@property (assign,nonatomic) int tapCount;

//@property(assign,nonatomic) CLLocationManager *locationManager;



@end
