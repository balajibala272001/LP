//
//  DriverGalleryViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 10/01/2023.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "NotesViewController.h"
#import "SiteData.h"
#import "ProjectDetailsViewController.h"
#import "PreviewViewController.h"
#import "SCLAlertView.h"
#import "ImageCropView.h"
#import "DriverMetadataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DriverGalleryViewController : UIViewController<sendNotesDataProtocol,senddataProtocoll,UICollectionViewDelegate,UICollectionViewDataSource,ImageCropViewControllerDelegate>{
    UIImage* image;
    ImageCropView* imageCropView;
    NotesViewController *notesVC;
    NSInteger currentLoadNumber;
}

@property (assign,nonatomic) int tapCount;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic)NSMutableArray *imageArray;
@property (strong,nonatomic)NSMutableArray *thumbArray;
@property (strong,nonatomic)NSMutableArray *urlArray;
@property (weak, nonatomic) IBOutlet UICollectionView *selected_CollectionView;
-(IBAction)BlurImgClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)PreviewAction:(id)sender;

//image
@property (strong,nonatomic)NSMutableDictionary *oneImageDict;
@property (strong, nonatomic) IBOutlet UIView *sub_View;

@property (nonatomic,strong)NSMutableArray *parkLoadArray;
@property (nonatomic,strong)NSMutableDictionary *parkLoad;
@property (strong,nonatomic) SiteData *siteData;
@property (strong,nonatomic) NSString* pathToImageFolder;


- (IBAction)back_btn:(id)sender;

@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;
@property NSMutableArray *oldValues;
@property  BOOL isEdit;

//crop_image
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (nonatomic,strong)NSMutableDictionary *dictionaries;


@end

NS_ASSUME_NONNULL_END
