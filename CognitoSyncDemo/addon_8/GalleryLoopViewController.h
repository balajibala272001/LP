//
//  GalleryLoopViewController.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 01/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "NotesViewController.h"
#import "SiteData.h"
#import "ProjectDetailsViewController.h"
#import "PreviewViewController.h"
#import "SCLAlertView.h"
#import "ServerUtility.h"
#import "Looping_Camera_ViewController.h"
#import "ImageCropView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GalleryLoopViewController : UIViewController<sendNotesDataProtocol,senddataProtocol,UICollectionViewDelegate,UICollectionViewDataSource,ImageCropViewControllerDelegate>
{
    UIImage* image;
    ImageCropView* imageCropView;
    NotesViewController *notesVC;
    NSInteger currentLoadNumber;
}

@property (assign,nonatomic) int tapCount;
@property(nonatomic,strong) ServerUtility * imge;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (strong,nonatomic) NSMutableArray *imageArray;
-(IBAction)BlurImgClickAction:(id)sender;
-(IBAction)LowlightClickAction:(id)sender;
-(IBAction)PreviewAction:(id)sender;

//image
@property (strong,nonatomic) NSMutableDictionary *oneImageDict;
@property (strong, nonatomic) IBOutlet UIView *sub_View;

@property (nonatomic,strong) NSMutableArray *parkLoadArray;
@property (nonatomic,strong) NSMutableDictionary *parkLoad;
@property (strong,nonatomic) SiteData *siteData;
@property (strong,nonatomic) NSString* pathToImageFolder;
@property (strong,nonatomic) Looping_Camera_ViewController * cameraLoopvc;


@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;
@property NSMutableArray *oldValues;
@property  BOOL isEdit;
-(IBAction)TakePhoto:(id)sender;


//Addon8
//@property (strong,nonatomic) NSMutableArray *instructData;
@property (weak, nonatomic) IBOutlet UICollectionView *list_CollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tab_CollectionView;
//@property (weak, nonatomic) IBOutlet UILabel *step_Label;
@property (assign,nonatomic) int imageCount;
@property (assign,nonatomic) int tappicount;
@property (assign,nonatomic) int currentTappiCount;
@property (assign,nonatomic) int instruction_number;
@property (strong,nonatomic) NSMutableArray *oldGalleryData;

//@property (strong,nonatomic) NSMutableArray *oldGalleryData;


//crop_image
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (nonatomic,strong) NSMutableDictionary *dictionaries;
@end
NS_ASSUME_NONNULL_END
