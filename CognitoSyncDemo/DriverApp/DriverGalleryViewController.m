//
//  DriverGalleryViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 10/01/2023.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import "DriverGalleryViewController.h"
#import "NotesViewController.h"
#import "PicturesCollectionViewCell.h"
#import "StaticHelper.h"
#import "SingletonImage.h"
#import "Reachability.h"
#import "pageViewController.h"
#import "AZCAppDelegate.h"
#import "SCLAlertView.h"
#import "Constants.h"
#import "ServerUtility.h"
#import "UIView+Toast.h"
#import "DriverUploadViewController.h"
#import "DriverMetadataController.h"

@interface DriverGalleryViewController ()<UIPopoverControllerDelegate>{
    NSInteger deletePosition;
    NSInteger cropPosition;
    AZCAppDelegate *delegateVC;
<<<<<<< HEAD
=======
    NSString *deviceModel;
>>>>>>> main
}

@end

@implementation DriverGalleryViewController

@synthesize pathToImageFolder;


- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"wholeDict:%@",_wholeLoadDict);
    self.oldValues = [[NSMutableArray alloc]init];
    //Intializing array and Dictionary
    self.oneImageDict = [[NSMutableDictionary alloc]init];
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverCurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    //Navigation Title
    //self.navigationItem.title = @"Picture Confirmation";
    
    
    //Makiking Cornerner Radius for sub-view
    self.sub_View.layer.cornerRadius = 10;
    self.sub_View.layer.borderWidth =1;
    self.sub_View.layer.borderColor = Blue.CGColor;
    
<<<<<<< HEAD
=======
    deviceModel = [UIDevice currentDevice].model;
    
>>>>>>> main
    //For back button
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    
    //Navigation controller next button
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:next ];
    self.navigationItem.rightBarButtonItem = NextButton;
}


- (void)didReceiveMemoryWarning {
    
    NSLog(@"memory warning");
    
    @try {
        [[SingletonImage singletonImage]nilTheDictionary];
    } @catch (NSException *exception) {
        NSLog(@"Exception :%@",exception.reason);
    } @finally {
        NSLog(@"final");
        [super didReceiveMemoryWarning];
    }
}

-(void)handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    //internet_indicator
    UIButton *networkStater;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(0,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(180,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(180,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = NSLocalizedString( @"Gallery",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
    //internet_indicator
    bool isOrange = false;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        isOrange = false;
        [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
            //RGBA ( 0 , 174 , 7 , 100 )
        NSLog(@"Network Connection available");
    } else {
        isOrange = true;
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
    }
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [cloud_indicator setBackgroundImage: [UIImage imageNamed:@"orangecloud.png"] forState:UIControlStateNormal];
    }else if([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable && !isOrange){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greencloud.png"]  forState:UIControlStateNormal];
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greycloud.png"]  forState:UIControlStateNormal];
    }
    
    //cloud_indicator
    [cloud_indicator addTarget:self action:@selector(cloud_poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cloud_indicator];
    
    //internet_indicator
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    self.navigationItem.titleView = view;
}

-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Offline.",@"");
    }else if ([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Online, proceed with the uploads.",@"");
    }else{
        stat= NSLocalizedString(@"Network Not Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)poper:(id)sender {
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    
    NSString *stat= NSLocalizedString(@"Network Not Connected",@"");
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"Network Connected",@"");
    }
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess: NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f];
}


-(IBAction)dummy:(id)sender
{
    [self.alertbox hideView];
}

//****************************************************
#pragma mark - Collection View Delegate  Methods
//****************************************************


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"q1");
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"q2");
    return  self.imageArray.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"q3");
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return CGSizeMake(150, 225);
    }
    else if (self.view.frame.size.width == 320)
    {
        return CGSizeMake(75, 112.5);
    }
    else{
        return CGSizeMake(100, 150);
    }
}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"q4");
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        int val  = self.view.frame.size.width - 486;
        int val1 = val/4;
        float v = (float) val1;
       return UIEdgeInsetsMake(5, v, 5, v);
    }
    else if (self.view.frame.size.width == 320)
    {
        int val  = self.view.frame.size.width - 261;
        int val1 = val/4;
        float v = (float) val1;
        return UIEdgeInsetsMake(5, v, 5, v);
    }
    else{
        int val  = self.view.frame.size.width - 336;
        int val1 = val/4;
        float v = (float) val1;
       return UIEdgeInsetsMake(5, v, 5, v);
    }
     // top, left, bottom, right
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//    int val  = self.view.frame.size.width - 466;
//    int val1 = val/3;
//    float v = (float) val1;
//    return v;
//    }
//    else{
//        int val  = self.view.frame.size.width - 316;
//        int val1 = val/3;
//        float v = (float) val1;
//        return v;
//    }
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"DriverPicviewVC";
    [[NSUserDefaults standardUserDefaults] setObject:@"DriverPicviewVC" forKey:@"DriverCurrentVC"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverCurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
   
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    [self.selected_CollectionView reloadData];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
    
    //printing the taken dictionary
   // NSLog(@"%@",dict);
    
    //reading the image and text from the dictionary
//    NSString* imageName = [dict valueForKey:@"imageName"];
//    NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
//
    NSLog(@"q6");
    NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
    
    NSMutableDictionary *dict= [[self.imageArray objectAtIndex:indexPath.row] mutableCopy];
    NotesVC.dictionaries = dict;
    NotesVC.indexPathRow = indexPath.row;
    NotesVC.delegate = self;
    [self.navigationController pushViewController:NotesVC animated:YES];
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicturesCollectionViewCell *Cell1 ;
    NSLog(@"q7");
    
    @try {
        Cell1= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
            //Getting the dictionary from the array of dictionaries
        NSDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
            //reading the image and text from the dictionary
        NSString* imageName = [dict valueForKey:@"imageName"];
        NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
        if([extentionArray[1] isEqualToString:@"mp4"])
        {
            NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
            UIImage* image = [self generateThumbImage : path];
            if(image != nil)
            {
                Cell1.imageView.image = image;
            }
            else{
                Cell1.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            [Cell1.videoicon setHidden:NO];
            [Cell1.crop_but setHidden:YES];
            [Cell1.blur_img setHidden:YES];
            [Cell1.low_light setHidden:YES];
        }else{
<<<<<<< HEAD
=======
            Cell1.imageView.backgroundColor = [UIColor grayColor]; // Set the background color of the container view
>>>>>>> main
            Cell1.imageView.contentMode = UIViewContentModeScaleAspectFit;
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
            
            bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
            NSLog(@"boolToRestrict:%d",boolToRestrict);
            
            //Low_light
            NSString* IsLowLight = [dict valueForKey:@"brightness"];
            if ([IsLowLight isEqualToString:@"FALSE"]) {
                [Cell1.low_light setHidden:YES];
            }else{
                if(boolToRestrict == FALSE){
                    [Cell1.low_light setHidden:NO];
                }else{
                    [Cell1.low_light setHidden:YES];
                }
            }
            //blur_img
            NSString* variance = [dict valueForKey:@"variance"];
            if ([variance isEqualToString:@"FALSE"]) {
                [Cell1.blur_img setHidden:YES];
            }else{
                if(boolToRestrict  == FALSE){
                    [Cell1.blur_img setHidden:NO];
                }else{
                    [Cell1.blur_img setHidden:YES];
                }
            }
            NSData *imageData;
            NSLog(@"Image Quality (upload):%@",self.siteData.image_quality);
            
           // self.siteData.image_quality = @"4";
            
//            if([self.siteData.image_quality isEqual:@"1"]) {
//                imageData = UIImageJPEGRepresentation(image, 0.93);
//                NSLog(@"compress ratio : %f",0.93);
//            }else if([self.siteData.image_quality isEqual:@"2"]){
                imageData = UIImageJPEGRepresentation(image, 0.1);
                NSLog(@"compress ratio : %f",0.85);
//            }else if([self.siteData.image_quality isEqual:@"3"]){
//                imageData = UIImageJPEGRepresentation(image, 0.9942);
//                NSLog(@"compress ratio : %f",0.994);
//            }else if([self.siteData.image_quality isEqual:@"4"]){
//                imageData = UIImageJPEGRepresentation(image, 1.0);//.9942);
//                NSLog(@"compress ratio : %f",1.0);
//            }
            //imageData = UIImageJPEGRepresentation(image, 0.9942);

            UIImage *scaled;
//            if([self.siteData.image_quality isEqual:@"4"]){
//                scaled =image;
//            }else{
                CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
                CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                    (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                    (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                    (id) kCGImageSourceThumbnailMaxPixelSize : @(300)
                };
                CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
                scaled = [UIImage imageWithCGImage:scaledImageRef];
                CGImageRelease(scaledImageRef);
//            }
            Cell1.imageView.image =scaled;
<<<<<<< HEAD
=======
            // Activate width and height constraints with 2:1 aspect ratio
            if([deviceModel isEqual:@"iPad"]){
                NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:Cell1
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:nil
                                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                                  multiplier:1.0
                                                                                    constant:135]; // Change this value as needed
                [Cell1 addConstraint:widthConstraint];
            }else {
                NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:Cell1
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:nil
                                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                                  multiplier:1
                                                                                    constant:83]; // Change this value as needed
                [Cell1 addConstraint:widthConstraint];
            }
>>>>>>> main
//            NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
//            UIImage* image = [self generateThumbImage : path];
            //Cell1.imageView.image =image;
            NSLog(@"Updated : W %f H %f",image.size.width,image.size.height);
            NSLog(@"Size : %@",NSStringFromCGSize(image.size));

            [Cell1.videoicon setHidden:YES];
            [Cell1.crop_but setHidden:NO];
        }
        
        
        NSString *text = [dict objectForKey:@"string"];
        NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
        Cell1.number_lbl.text = the_index_path;
        Cell1.notesImageView.image =[UIImage imageNamed:@"notesicon.png"];
        if (text.length == 0) {
            [Cell1.notesImageView setHidden:YES];
        }
        else{
            [Cell1.notesImageView setHidden:NO];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Error log: %@", exception.reason);
    } @finally {
        NSLog(@"q8");
        
        [Cell1.preview_but addTarget:self action:@selector(PreviewAction:) forControlEvents:UIControlEventTouchUpInside];
        [Cell1.preview_but setTag:indexPath.row];
        [Cell1.crop_but addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
        [Cell1.crop_but setTag:indexPath.row];
        [Cell1.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [Cell1.delete_btn setTag:indexPath.row];

        return Cell1;
    }
}


-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSLog(@"q9");
    NSURL *url = [NSURL fileURLWithPath:filepath];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    CGSize imageSize;
    imageSize = CGSizeMake(200, 300);
    NSLog(@"Actual : W %f H %f",thumbnail.size.width,thumbnail.size.height);
    UIGraphicsBeginImageContext(imageSize);
    [thumbnail drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    NSLog(@"Updated : W %f H %f",imageSize.width,imageSize.height);
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    return resizedImage;
}


//****************************************************
#pragma mark - IBAction Methods
//****************************************************


-(void)next:(id)sender
{
    ServerUtility * imge = [[ServerUtility alloc] init];
    imge.picslist = self.imageArray;
    @try{
    if (self.imageArray.count>0) {
        DriverMetadataController *Project = [self.storyboard instantiateViewControllerWithIdentifier:@"driverMetadataVC"];
        [self.navigationController pushViewController:Project animated:YES];
        Project.siteData = self.siteData;
        Project.arrayOfImagesWithNotes = self.imageArray;
        Project.sitename = self.sitename;
        Project.image_quality = self.siteData.image_quality;
        Project.isEdit = self.isEdit;
//        Project.delegate = self;
        //DriverUploadViewController *DriverUploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverUploadVC"];
        //DriverUploadVC.uploadDelegate = self;
       // DriverUploadVC.image_quality=site.image_quality;
        //DriverUploadVC.siteData=site;
        //DriverUploadVC.sitename = site.siteName;
       // [self.navigationController pushViewController:DriverUploadVC animated:YES];
    }else{
        [self.view makeToast: NSLocalizedString(@"Take Atleast 1 Media file ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
    }@catch(NSException *ex){
        NSLog(@"jj", @"jjj");
    }
}




//- (IBAction)btn_single:(id)sender
//{
//    NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
//    NSMutableDictionary *dictOneImage= [self.imageArray objectAtIndex:0];
//    NotesVC.self.dictionaries = dictOneImage;
//    NotesVC.delegate = self;
//    [self.navigationController pushViewController:NotesVC animated:YES];
//}



-(void)notesData:(NSInteger *)indexPathRow changedData:(NSMutableDictionary *)dic
{
    [self.imageArray replaceObjectAtIndex:indexPathRow withObject:dic];
    NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverParkLoadArray"]mutableCopy];
    int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverCurrentLoadNumber"] intValue];
    load= [[array objectAtIndex:i]mutableCopy];
    [load setObject:self.imageArray forKey:@"img"];
    [array replaceObjectAtIndex:i withObject:load];
    [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.selected_CollectionView reloadData];
}



-(void)sendDataToPictureConfirmation:(NSMutableArray *)array{
    NSLog(@"q0");
    self.oldValues = array;
    NSLog(@"%@",self.oldValues);
}


- (void)back_button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)BlurImgClickAction:(id)sender{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Blur image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor: Green];
    [self.alertbox showSuccess: NSLocalizedString(@"Warning!",@"") subTitle: NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)PreviewAction:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger indexPath = btn.tag;
    pageViewController *pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    pageVC.array = self.imageArray;
    pageVC.indexPath = indexPath;
    [self.navigationController pushViewController:pageVC animated:YES];
}


-(IBAction)delete:(id)sender
{
     UIButton *btn = (UIButton *)sender;
    deletePosition=btn.tag;
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox addButton: NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
    [self.alertbox showSuccess: NSLocalizedString(@"Alert !",@"") subTitle: NSLocalizedString(@"Are You Sure To Delete",@"") closeButtonTitle:nil duration:1.0f ];
}


-(void)deleteLoad:(id)sender
{
        NSDictionary* myimagedict = [self.imageArray objectAtIndex:deletePosition];
        NSString* imageName = [myimagedict valueForKey:@"imageName"];
        NSString *path = [[AZCAppDelegate.sharedInstance getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
        NSString* imagePath = [path stringByAppendingPathComponent:imageName];
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        [self.imageArray removeObjectAtIndex:deletePosition];
        NSLog(@" the delete array is :%@",self.imageArray);
        [self.selected_CollectionView reloadData];
        [self.parkLoad setObject:self.imageArray forKey:@"img"];
        [self.parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:self.parkLoad];
        [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"DriverParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}




- (IBAction)crop:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    cropPosition=btn.tag;
    NSMutableDictionary *dic=[self.imageArray objectAtIndex:btn.tag];
    NSString* imageName = [dic valueForKey:@"imageName"];
    NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    if(image != nil){
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
        controller.delegate = self;
        controller.blurredBackground = YES;
        // set the cropped area
        // controller.cropArea = CGRectMake(0, 0, 100, 200);
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

-(void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    image = croppedImage;
    //Cell1.imageView.image = croppedImage;
    CGRect cropArea = controller.cropArea;
    self.dictionaries= [[self.imageArray objectAtIndex:cropPosition] mutableCopy];

    //REducing the cropped image size
    CGSize imageSize;
    NSLog(@"Image Quality :%@",self.siteData.image_quality);
<<<<<<< HEAD
    if ([self.siteData.image_quality isEqual:@"1"]) {
        imageSize = CGSizeMake(720,1080);
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
    }else{
        imageSize = CGSizeMake(1440,2160);
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
    }
=======
//    if ([self.siteData.image_quality isEqual:@"1"]) {
//        imageSize = CGSizeMake(720,1080);
//    }else{
//        imageSize = CGSizeMake(1440,2160);
//    }
    imageSize = CGSizeMake(image.size.width,image.size.height);
    
>>>>>>> main
    UIGraphicsBeginImageContext(imageSize);
    [croppedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    NSString *UDID = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"identifier"];
    NSString* imageName = [NSString stringWithFormat:@"%@_%@.jpg",UDID,epochTime];
    NSString* imagePath = [pathToImageFolder stringByAppendingPathComponent:imageName];
    [UIImageJPEGRepresentation(resizedImage,1) writeToFile:imagePath atomically:true];
    [self.dictionaries setObject:imageName forKey:@"imageName"];
    NSLog(@"dictionaries:%@",self.dictionaries);
    [self.imageArray replaceObjectAtIndex:cropPosition withObject:self.dictionaries];
    
    //image_saving
    NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverParkLoadArray"]mutableCopy];
    int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DriverCurrentLoadNumber"] intValue];
    load= [[array objectAtIndex:i]mutableCopy];
    [load setObject:self.imageArray forKey:@"img"];
    [array replaceObjectAtIndex:i withObject:load];
    [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"DriverParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self navigationController] popViewControllerAnimated:YES];

}

-(void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    //self.imgview.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
