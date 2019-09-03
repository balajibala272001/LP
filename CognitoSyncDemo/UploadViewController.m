//
//  UploadViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "UploadViewController.h"
#import "StaticHelper.h"
#import "ServerUtility.h"
#import "CameraViewController.h"

#import "UIView+Toast.h"
#import "CustomIOSAlertView.h"


#import "UserCategoryViewController.h"
#import "ProjectDetailsViewController.h"
#import "PicViewController.h"
#import "LoadSelectionViewController.h"
#import <OpinionzAlertView.h>


#import "AZCAppDelegate.h"




//#import "FCAlertView/Classes/FCAlertView.h"

#define kOpinionzSeparatorColor      [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]

#define kOpinionzDefaultHeaderColor  [UIColor colorWithRed:0.8 green:0.13 blue:0.15 alpha:1]
@interface UploadViewController () {
    NSMutableDictionary* currentLotRelatedData;
    BOOL isUploadingPreviousLot;
    
    NSMutableDictionary *parkLoadRelatedData;
    
}

@end



@implementation UploadViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];
    if (currentLotRelatedData) {
        isUploadingPreviousLot = true;
        [self prepopulateDataFromPrevoiusLot];
    } else {
        isUploadingPreviousLot = false;
        currentLotRelatedData = [NSMutableDictionary dictionary];
        self.currentIndex = 0;
    }
    
    details = [[NSMutableDictionary alloc]init];
    
    savedOldValuesArray = [[NSMutableArray alloc]init];
    
    self.upload_lbl.text = @"Start Uploading";
    
    
    self.progressView.hidden = YES;
    self.progressView.progress = 0.0;
    
    self.SiteName_Value_Label.text = self.sitename;
    self.Category_Value_Label.text = self.UserCategory;
    
    
    
    self.SiteName_Value_Label.minimumScaleFactor = 0.5;
    self.SiteName_Value_Label.numberOfLines = 2;
    
    self.Category_Value_Label.minimumScaleFactor = 0.6;
    self.Category_Value_Label.numberOfLines = 2;
    
    
    int count  = self.arrayWithImages.count;
    self.progressLabel.text = [NSString stringWithFormat:@"%d",count];
    
    
    
    
    
    self.Sub_View.layer.cornerRadius = 10;
    self.Sub_View.layer.borderWidth = 1;
    
    
    self.Sub_View.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    self.navigationItem.title = @"Upload";
    
    
    [StaticHelper setLocalizedBackButtonForViewController:self];
    
    [self.upload_btn.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.upload_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.upload_btn.layer setShadowOpacity:0.5];
    self.upload_btn.layer.cornerRadius = 5;
    
    [self.park_btn.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.park_btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.park_btn.layer setShadowOpacity:0.5];
    self.park_btn.layer.cornerRadius = 5;
    
    
    self.upload_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.park_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    //   self.Upload = [[UIBarButtonItem alloc]
    //                                   initWithTitle:@"Upload"
    //                                   style:UIBarButtonItemStyleBordered
    //                                   target:self
    //                                   action:@selector(upload:)];
    //
    //    self.navigationItem.rightBarButtonItem = self.Upload
    //    ;
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    //[uploadButton release];
    // Do any additional setup after loading the view.
    
    if (isUploadingPreviousLot) {
        [self upload_btn_action:nil];
    }
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(IBAction)upload:(id)sender {
    [self preUploadLot];
    self.view.userInteractionEnabled = NO;
    [self.Upload setEnabled:NO];
    self.progressLabel.text = [NSString stringWithFormat:@"1/%d",(int)self.arrayWithImages.count];
    [self uploadingImage];
}

-(void) prepopulateDataFromPrevoiusLot {
    // prepopulate array
    NSMutableArray* imagesArray = [currentLotRelatedData objectForKey:@"img"];
    NSMutableArray* arrayWithImages = [NSMutableArray array];
    NSString* pathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:CurrentLoadFolderName];
    for (NSInteger index = 0; index < imagesArray.count; index++) {
        NSMutableDictionary *imageDic = [imagesArray[index] mutableCopy];
        // we will work on image path now.
        [arrayWithImages addObject:imageDic];
    }
    
    self.arrayWithImages = arrayWithImages;
    
    self.dictMetaData = [[currentLotRelatedData objectForKey:@"self.dictMetaData"] mutableCopy];
    self.isEdit = [[currentLotRelatedData objectForKey:@"self.isEdit"] boolValue];
    self.UserCategory = [currentLotRelatedData objectForKey:@"self.UserCategory"];
    self.currentIndex = [[currentLotRelatedData objectForKey:@"self.currentIndex"] intValue];
    self.load_id = [[currentLotRelatedData objectForKey:@"self.load_id"] intValue];
    self.pic_count = [[currentLotRelatedData objectForKey:@"self.pic_count"] intValue];
    self.sitename = [currentLotRelatedData objectForKey:@"self.sitename"];
}

-(void) preUploadLot {
    // Folder -> Current Lot
    
    if (isUploadingPreviousLot) {
        return; // no need to save it, its already saved in there.
    }
    
    // check if Folder exists
    // if folde exists, do not save the photos and just return
    // else
    // create Folder in document directory
    // 1. save all images to Folder, with name <Array Index>.png // PENDING
    //// save all the UPLOAD RELATED DATA into user defaults
    // 2. save self.dictMetaData
    // 3. save self.currentIndex
    // 4. save self.UserCategory
    // 5. save self.load_id
    // 6. save self.pic_count
    NSString* currentPathToFolder = [[[AZCAppDelegate sharedInstance] getTempDir] stringByAppendingPathComponent:CurrentLoadFolderName];
    NSString* newPathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:CurrentLoadFolderName];

    
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:newPathToFolder]) {
        [[NSFileManager defaultManager] removeItemAtPath:newPathToFolder error:&error];
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:currentPathToFolder toPath:newPathToFolder error:&error];
    
    // not required to clear the folder from temp folder because we moved it from temp directory to document directory.
    [[AZCAppDelegate sharedInstance] clearCurrentLoad];
    
    
    NSMutableArray* newArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.arrayWithImages.count; index++) {
        NSMutableDictionary *imageDic = [self.arrayWithImages[index] mutableCopy];\
        // now we will work on image path
        [newArray addObject:imageDic];
    }
    
    [currentLotRelatedData setObject:newArray forKey:@"img"]; // 1
    
    [currentLotRelatedData setObject:self.dictMetaData forKey:@"self.dictMetaData"]; // 2
    [currentLotRelatedData setObject:@(self.currentIndex) forKey:@"self.currentIndex"]; // 3
    [currentLotRelatedData setObject:self.UserCategory forKey:@"self.UserCategory"]; // 4
    [currentLotRelatedData setObject:@(self.load_id) forKey:@"self.load_id"]; // 5
    [currentLotRelatedData setObject:@(self.pic_count) forKey:@"self.pic_count"]; // 6
    [currentLotRelatedData setObject:@(self.isEdit) forKey:@"self.isEdit"]; // 6
    [currentLotRelatedData setObject:self.sitename forKey:@"self.sitename"]; // 6
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) createMyDocsDirectory {
    NSString*path = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:CurrentLoadFolderName];
    NSLog(@"createpath:%@",path);
    return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                     withIntermediateDirectories:NO
                                                      attributes:nil
                                                           error:NULL];
}

-(void) updateCurrentIndexInUserDefaults {
    // update the self.currentIndex in user defaults
    [currentLotRelatedData setObject:@(self.currentIndex) forKey:@"self.currentIndex"]; // 2
    [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) postUploadLot {
    // clear the user defaults
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self moveToLoadVC];
}


-(void)uploadingImage
{
    self.customAlertView.hidden = YES;
    [self.back_btn setEnabled:NO];
    self.upload_lbl.text = @"Uploading...";
    
    int indexCount = self.currentIndex + 1;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d/%lu",indexCount,(unsigned long)self.arrayWithImages.count];
    int index = self.currentIndex;
    int count  =(int) self.arrayWithImages.count;
    self.progressView.progress = (index > 0) ? ((float)indexCount/count):0;
    self.progressView.hidden = NO;
    NSString *userCategory = self.UserCategory;
    
    NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
    NSString *notes = [dict objectForKey:@"string"];
    
    NSString* pathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:CurrentLoadFolderName];
    
    NSString* imageName = [dict objectForKey:@"imageName"];
    UIImage* sample = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToFolder stringByAppendingPathComponent:imageName]]];

    // NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((sample), 0.5)];
    
    
    
    NSNumber *ImageTime = [dict objectForKey:@"created_Epoch_Time"];
    
    NSData *sampleData = UIImageJPEGRepresentation(sample, 1.0);
    NSUInteger imageSize1   = sampleData.length;
    NSLog(@"size of image in KB in upload : %f ", imageSize1/1024.0);
    NSLog(@"%@",sampleData);
    
    FinalDict = [self.dictMetaData mutableCopy];
    
    [FinalDict setObject:userCategory forKey:@"category"];
    [FinalDict setObject:ImageTime forKey:@"created_Epoch_Time"];
    
    
    
    if (notes.length > 0) {
        
        [FinalDict setObject:notes forKey:@"note"];
        
    }
    if (self.load_id > 0) {
        
        [FinalDict setObject:[NSNumber numberWithInt:self.load_id] forKey:@"load_id"];
        
        
    }
    if (self.pic_count > 0) {
        [FinalDict setObject:[NSNumber numberWithInt:self.pic_count] forKey:@"pic_count"];
    }
    NSLog(@"FinalDict:%@",FinalDict);
    
    [ServerUtility uploadImageWithAllDetails:FinalDict noteResource:sampleData andCompletion:^(NSError *error,id data)
     {   
         if (!error) {
             NSLog(@"data:%@",data);
             NSString *strResType = [data objectForKey:@"res_type"];
             self.message = [data objectForKey:@"msg"];
             if ([strResType.lowercaseString isEqualToString:@"success"]) {
                 if (self.load_id == 0) {
                     self.load_id  = [[data objectForKey:@"load_id"]intValue];
                     [currentLotRelatedData setObject:@(self.load_id) forKey:@"self.load_id"]; // 5
                     [[NSUserDefaults standardUserDefaults] setObject:currentLotRelatedData forKey:@"currentLotRelatedData"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 
                 NSString *email =[data objectForKey:@"nau_email"];
                 NSLog(@"Upload Successfully");
                 self.currentIndex += 1;
                 int index = self.currentIndex;
                 self.pic_count = index+1;
                 int count  =(int) self.arrayWithImages.count;
                 self.progressView.progress = (index > 0) ? ((float)index/count):0;
                 NSLog(@" the progress value is:%f",self.progressView.progress);
                 if (self.currentIndex < self.arrayWithImages.count) {
                     [self updateCurrentIndexInUserDefaults];
                     [self uploadingImage];
                 }
                 else {
                     AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
                     self.upload_lbl.text = @"Uploaded";
                     
                     [self.back_btn setEnabled:NO];
                     // [self.Upload setEnabled:NO];
                     
                     
                     [self disableUploadButton];
                     // self.view.userInteractionEnabled = YES;
                     [self.view makeToast:@"Uploaded Successfully" duration:1.0 position:CSToastPositionCenter];
                     NSString *user = delegate.userProfiels.userType;
                     NSString *FirstName = delegate.userProfiels.firstName;
                     NSString *LastName = delegate.userProfiels.lastName;
                     NSString *SiteName = self.sitename;
                     NSString *Load_id_no = [NSString stringWithFormat:@"%d",self.load_id];
                     NSString *message = @"Quality Issue";
                     NSLog(@"message:%@",message);
                     NSLog(@"self.message:%@",self.message);
                     NSLog(@"loadidno:%@",Load_id_no);
                     if ([self.UserCategory isEqualToString:message]) {
                         [details setObject:user forKey:@"user_type"];
                         [details setObject:email forKey:@"email_id"];
                         [details setObject:FirstName forKey:@"first_name_load"];
                         [details setObject:LastName forKey:@"last_name_load"];
                         [details setObject:SiteName forKey:@"site_name"];
                         [details setObject:Load_id_no forKey:@"last_insert_load_id"];
                         NSLog(@"details:%@",details);
                         [ServerUtility SendAllDetails:user withEmail:email withFirstName:FirstName withLastName:LastName withSiteName:SiteName withLoadId:Load_id_no andCompletion:^(NSError *error,id data)
                          
                          //[ServerUtility sendGMFData:details toServerWithBaseUrl:BASE_URL andCompletion:^(NSError *error,id data)
                          //  [ServerUtility SendInfo:details andCompletion:^(NSError *error,id data)
                          //            [ServerUtility SendInfo:user details:email details:FirstName details:LastName details:self.sitename details:Load_id_no andCompletion:^(NSError *error,id data)
                          {
                              if (!error) {
                                  NSLog(@"LAST API:%@",data);
                              } else {
                                  self.ErrorLocal = error.localizedDescription;
                                  NSLog(@"ERR:%@",error.localizedDescription);
                                  [self errorAlert];
                              }
                          }];
                         
                     }//ending if
                     
                     //                     AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                     
                     
                     BOOL isParkLoadAvailable = false;
                     if (_isEdit && delegate.DisplayOldValues.count > 0) {
                         NSDictionary *_oldDict = [delegate.DisplayOldValues objectAtIndex:delegate.LoadNumber];
                         
                         NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                         
                         if (parkLoadArray == nil) {
                             parkLoadArray = [[NSMutableArray alloc] init];
                         }
                         
                         if (_oldDict != nil) {
                             NSNumber *OldEpochTime = [_oldDict valueForKey:@"park_id"];
                             for (NSDictionary *dict in parkLoadArray) {
                                 if ([dict valueForKey:@"park_id"] == OldEpochTime) {
                                     [parkLoadArray removeObject:dict];
                                     break;
                                 }
                             }
                         }
                         [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
                         if (parkLoadArray == nil || parkLoadArray.count == 0) {
                             [delegate clearSavedParkLoads];
                         }
                         if (_uploadDelegate) {
                             isParkLoadAvailable = true;
                             [self.uploadDelegate uploadFinishCheckParkLoad];
                         }
                     }

                     if (!delegate.isNoEdit) {
                         if (delegate.DisplayOldValues.count > 0) {
                             //new
                             NSLog(@"load n:%d",delegate.LoadNumber);
                             [delegate.DisplayOldValues removeObjectAtIndex:delegate.LoadNumber];
                         }
                     }
                     
                
                     double delayInSeconds = .5;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                     
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"uploaded" object:delegate.DisplayOldValues];
                         //code to be executed on the main queue after delay
                     });
                     
                     if (isParkLoadAvailable) {
                         [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }else{
                         [self postUploadLot];
                     }
                     
                 }
             }else if ([strResType.lowercaseString isEqualToString:@"error"]){
                 //self.back_btn.hidden = YES;
                 [self.back_btn setEnabled:NO];
                 // [self.Upload setEnabled:NO];
                 [self disableUploadButton];
                 self.serverError= [data objectForKey:@"msg"];
                 //  self.view.userInteractionEnabled = NO;
                 // [self customAlert];
                 [self errorAlert];
                 // [self.back_btn setEnabled:YES];
                 //[self.Upload setEnabled:YES];
                 self.view.userInteractionEnabled = YES;
             }
         } else{
             NSLog(@" the current index after gettingg error:%d",self.currentIndex);
             [self.back_btn setEnabled:NO];
             //   [self.Upload setEnabled:NO];
             [self disableUploadButton];
             self.localerror = error.localizedDescription;
             self.upload_lbl.hidden = YES;
             [self errorAlert];
             // [self.back_btn setEnabled:YES];
             // [self.Upload setEnabled:YES];
             self.view.userInteractionEnabled = YES;
             
             
             
             
         }
         
         
         
     }];
}

-(void)errorAlert
{
    
    [self.back_btn setEnabled:NO];
    
    self.view.userInteractionEnabled = NO;
    self.customAlertView = [[UIView alloc]initWithFrame:CGRectMake(20, 120, 280, 210)];
    
    [self.customAlertView setBackgroundColor:[UIColor clearColor]];
    
    
    [self.customAlertView.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.customAlertView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self.customAlertView.layer setShadowOpacity:0.5];
    self.customAlertView.layer.cornerRadius = 5;
    
    
    [self.view addSubview:self.customAlertView];
    if (NSClassFromString(@"UIVisualEffectView") != nil) {
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.customAlertView.bounds;
        [self.customAlertView addSubview:visualEffectView];
    } else {
        [self.customAlertView setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    UIView *hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 80)];
    hearderView.backgroundColor = [UIColor orangeColor];
    
    [self.customAlertView addSubview:hearderView];
    
    //Uimage
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(120, 30, 40, 40)];
    
    image.image = [UIImage imageNamed:@"OpinionzAlertIconWarning.png"];
    
    [hearderView addSubview:image];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-6, 5, 300, 20)];
    
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setText:@"Warning"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.customAlertView addSubview:titleLabel];
    
    
    UILabel *messageView = [[UILabel alloc]initWithFrame:CGRectMake(9, 100, 260, 40)];
    
    if (self.serverError.length > 0) {
        [messageView setText:self.serverError];
    } else {
        [messageView setText:self.localerror];
    }
    
    [messageView setTextColor:[UIColor blackColor]];
    [messageView setTextAlignment:NSTextAlignmentCenter];
    [messageView setUserInteractionEnabled:NO];
    [messageView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    messageView.numberOfLines = 2;
    
    [messageView setBackgroundColor:[UIColor clearColor]];
    [self.customAlertView addSubview:messageView];
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, 300, 30)];
    [self.customAlertView addSubview:buttonView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280
                                                               , 0.5)];
    
    lineView.backgroundColor = kOpinionzSeparatorColor;
    
    [buttonView addSubview:lineView];
    
    NSString *messageCompare = @"The storage space for this site is full, please contact admin.";
    //button
    UIButton *retry = [[UIButton alloc]initWithFrame:CGRectMake(100, 10, 80, 30)];
    if ([self.message isEqualToString:messageCompare]) {
        [retry setTitle:@"Ok" forState:UIControlStateNormal];
        [retry addTarget:self action:@selector(retryWithOk:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [retry setTitle:@"Retry" forState:UIControlStateNormal];
        [retry addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    }
    [retry setTitleColor:[UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0] forState:UIControlStateNormal];
    retry.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [buttonView addSubview:retry];
}


-(void)startTimerToMove {
    self.progressView.progress = 0.0;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
}

-(IBAction)move:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
}

-(void)alertView{
    self.customAlertView.hidden = NO;
    self.progressView.hidden = YES;
    self.progressLabel.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    self.customAlertView = [[UIView alloc]initWithFrame:CGRectMake(5, 150, 270, 100)];
    self.customAlertView.backgroundColor = [UIColor whiteColor];
    self.customAlertView.layer.cornerRadius = 5;
    self.customAlertView.layer.borderWidth = 1;
    self.customAlertView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.Sub_View addSubview:self.customAlertView];
    UILabel *errorLabel = [[UILabel alloc]init];
    errorLabel.frame = CGRectMake(30, 50,200, 50);
    errorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [errorLabel setText:self.localerror];
    errorLabel.numberOfLines = 2;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    [errorLabel setTextColor:[UIColor blackColor]];
    [self.customAlertView addSubview:errorLabel ];
    UIButton *retry = [[UIButton alloc]init];
    
    retry.frame =CGRectMake(100,80,50,40);
    
    retry.layer.cornerRadius = 5;
    
    
    [retry setTitle:@"Retry" forState:UIControlStateNormal];
    [retry setTitleColor:[UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    retry.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [retry addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customAlertView addSubview:retry];
}


-(void)customAlert
{
    self.customAlertView.hidden = NO;
    
    
    self.progressView.hidden = YES;
    self.progressLabel.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    
    
    self.customAlertView =[[UIView alloc]initWithFrame:CGRectMake(5,100, 270, 300)];
    
    
    self.customAlertView.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:221.0/255.0];
    
    self.customAlertView.layer.cornerRadius = 5;
    self.customAlertView.layer.borderWidth = 1;
    self.customAlertView.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    
    [self.Sub_View addSubview:self.customAlertView];
    
    
    //innerview
    UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(10, 10,250,210)];
    
    UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 40, 40)];
    imageView.image = [UIImage imageNamed:@"error1.png"];
    innerView.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:131.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    
    innerView.layer.cornerRadius = 5;
    
    
    [self.customAlertView addSubview:innerView];
    
    [innerView addSubview:imageView];
    
    //line separator view
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 225, 280, 1)];
    
    
    
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [self.customAlertView addSubview:lineView];
    
    
    
    UILabel *errorLabel = [[UILabel alloc]init];
    errorLabel.frame = CGRectMake(30, 70,200, 50);
    
    errorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    
    [errorLabel setText:self.localerror];
    
    
    errorLabel.numberOfLines = 2;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    
    [errorLabel setTextColor:[UIColor whiteColor]];
    
    
    [innerView addSubview:errorLabel];
    
    
    
    
    //buttons
    UIButton *retry = [[UIButton alloc]init];
    
    retry.frame =CGRectMake(100,250,50,40);
    
    retry.layer.cornerRadius = 5;
    
    
    [retry setTitle:@"Retry" forState:UIControlStateNormal];
    [retry setTitleColor:[UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    retry.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [retry addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customAlertView addSubview:retry];
    
    
    
    
    
}

-(IBAction)retry:(id)sender
{
    self.customAlertView.hidden = YES;
    
    self.upload_lbl.hidden = NO;
    
    //[self.back_btn setEnabled:YES];
    //[self.Upload setEnabled:YES];
    
    self.progressLabel.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    [self uploadingImage];
    self.view.userInteractionEnabled = NO;
}

-(IBAction)retryWithOk:(id)sender
{
    self.customAlertView.hidden = YES;
    
    self.upload_lbl.hidden = YES;
    self.upload_lbl.text = @"Uploading Failed...";
    
    [self.back_btn setEnabled:YES];
    // [self.Upload setEnabled:YES];
    
    [self enableUploadButton];
    [self enableParkButton];
    
    self.progressLabel.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    
    // [self uploadingImage];
    
    
    self.view.userInteractionEnabled = YES;
    
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (IBAction)back_Button:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (IBAction)back_action_btn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)moveToLoadVC {
    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
    for(NSUInteger i = array.count - 1; i>=0 ; i--) {
        if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
            NSLog(@"testing %lu", (unsigned long)i);
            [self.navigationController popToViewController:array[i] animated:true];
            break;
        } else if ([array[i] isKindOfClass:SiteViewController.class]){
            [self.navigationController popToViewController:array[i] animated:true];
            break;
        }
    }
}

- (IBAction)upload_btn_action:(id)sender {
    [self preUploadLot];
    
    self.view.userInteractionEnabled = NO;
    
    
    [self disableUploadButton];
    [self disbleParkButton];
    
    //[self.Upload setEnabled:NO];
    self.progressLabel.text = [NSString stringWithFormat:@"1/%d",(int)self.arrayWithImages.count];
    [self uploadingImage];
    
}

-(void)disableUploadButton{
    [self.upload_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.upload_btn setEnabled:NO];
}
-(void)enableUploadButton{
    [self.upload_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.upload_btn setEnabled:YES];
}

-(void)disbleParkButton{
    [self.park_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.park_btn setEnabled:NO];
}

-(void)enableParkButton{
    [self.park_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.park_btn setEnabled:YES];
}

- (IBAction)park_action_btn:(id)sender {
    
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!_isEdit ) {
        int ccount = delegate.count;
        ccount ++;
        delegate.count = ccount;
    }
    //old values
//    int indexCount = self.currentIndex + 1;
    NSString *userCategory = self.UserCategory;
    NSDictionary *dict = [self.arrayWithImages objectAtIndex:self.currentIndex];
    NSString *notes = [dict objectForKey:@"string"];
    //ss
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    NSMutableArray *ddict = [[NSMutableArray alloc]init];
    ddict = [self.dictMetaData objectForKey:@"fields"];

    if (notes.length> 0) {
        [self.savedOldValuesDict setObject:notes forKey:@"string"];
    }
    NSMutableDictionary *dictSavedOldValues = [[NSMutableDictionary alloc]init];
    self.arraySavedOldValues = [[NSMutableArray alloc]init];

    //saving notes in dictionary
    if (notes.length >0 ) {
        [dictSavedOldValues setValue:notes forKey:@"string"];
    }
    
    //Saving ctaegory in dictionary
    [dictSavedOldValues setValue:userCategory forKey:@"category"];
    [dictSavedOldValues setValue:self.arrayWithImages forKey:@"img"];
    [dictSavedOldValues setValue:ddict forKey:@"fields"];
    [dictSavedOldValues setValue:newDateString forKey:@"parked_time"];
    
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    [dictSavedOldValues setObject:epochTime forKey:@"park_id"];
    [self saveParkedLoad:[dictSavedOldValues mutableCopy]];
    delegate.DisplayOldValues = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
//    if (_isEdit ) {
//        [ replaceObjectAtIndex:delegate.LoadNumber withObject:dictSavedOldValues];
//    }
//    else {
//        [delegate.DisplayOldValues addObject:dictSavedOldValues];
//    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"park" object:self.arraySavedOldValues];
}

-(void)saveParkedLoad:(NSMutableDictionary *)parkLoadDict{
    
    
    BOOL isCreated = [self createParkLoadDirectory];
    NSString* pathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:ParkLoadFolderName];
    
    NSMutableArray* newArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.arrayWithImages.count; index++) {
        NSMutableDictionary *imageDic = [self.arrayWithImages[index] mutableCopy];

        NSString* currentPathToFolder = [[[AZCAppDelegate sharedInstance] getTempDir] stringByAppendingPathComponent:CurrentLoadFolderName];
        if (self.isEdit) {
            currentPathToFolder = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:ParkLoadFolderName];
        }

        NSString* imageName = [imageDic valueForKey:@"imageName"];
        
        NSString* fileName = [NSString stringWithFormat:@"%@_%@.png",@(index), [parkLoadDict valueForKey:@"park_id"]];
        // save this image to Folder with fileName

        NSString *currentFilePath = [currentPathToFolder stringByAppendingPathComponent:imageName]; //Add the file name
        NSString *newFilePath = [pathToFolder stringByAppendingPathComponent:fileName]; //Add the file name
        NSError* error;
        [[NSFileManager defaultManager] moveItemAtPath:currentFilePath toPath:newFilePath error:&error];
//        [pngData writeToFile:filePath atomically:YES]; //Write the file
        
        // Image name will be stored in the dict
        [imageDic setObject:fileName forKey:@"imageName"];
        [newArray addObject:imageDic];
    }
    
    [parkLoadDict setObject:newArray forKey:@"img"]; // 1
    
    
    NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    
    if (parkLoadArray == nil) {
        parkLoadArray = [[NSMutableArray alloc] init];
    }
    
    
    if (_oldDict != nil) {
        NSNumber *OldEpochTime = [_oldDict valueForKey:@"park_id"];
        for (NSDictionary *dict in parkLoadArray) {
            if ([dict valueForKey:@"park_id"] == OldEpochTime) {
                
                [parkLoadArray replaceObjectAtIndex:[parkLoadArray indexOfObject:dict] withObject:parkLoadDict];
                break;
            }
        }
    }else{
        [parkLoadArray addObject:parkLoadDict];
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) createParkLoadDirectory {
    NSString *path = [[[AZCAppDelegate sharedInstance] getUserDocumentDir] stringByAppendingPathComponent:ParkLoadFolderName];
    NSLog(@"createpath:%@",path);
    return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                     withIntermediateDirectories:NO
                                                      attributes:nil
                                                           error:NULL];
}


@end
