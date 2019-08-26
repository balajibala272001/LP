//
//  CameraViewController.m
//  sgpcapp
//
//  Created by SmartGladiator on 07/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//

#import "CameraViewController.h"
#import "CollectionViewCell.h"
#import "StaticHelper.h"
#import "PicViewController.h"
#import "KeychainItemWrapper.h"
#import "UIView+Toast.h"
#import "Constants.h"
#import "AZCAppDelegate.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

int uploadCountLimit = 325;

AVCaptureSession *session;
AVCaptureStillImageOutput *StillImageOutput;

//tapCount = 0;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************



- (void)viewDidLoad {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];

    uploadCountLimit = self.siteData.uploadCount;
        
    self.tapCount = 0;
    
    //if (delegate.ImageTapcount > 0) {
    self.tapCount = delegate.ImageTapcount;
    
    //}
    SiteData *sitesssClass = delegate.siteDatas;
    int networkid = sitesssClass.networkId;
    NSLog(@" the selected netid:%d",networkid);
    
    
    
    //location
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];
    //location
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = self.siteName;
    //titleLabel.backgroundColor = [UIColor blackColor];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.adjustsFontSizeToFitWidth = YES; // As alternative you can also make it multi-line.
    titleLabel.minimumScaleFactor = 0.1;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.firstTime = YES;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [super viewDidLoad];
    
    //notification
    
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"new" object:nil];
    
    //Back button
    [StaticHelper setLocalizedBackButtonForViewController:self];
    
    if (!(self.myimagearray.count > 0)) {
        self.myimagearray = [[NSMutableArray alloc]init];
        
    }
    
    
    
    //Corner radius for button
    self.btn_Next.layer.cornerRadius = 10;
    
    self.btn_Next.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:189/255.0 alpha:1.0].CGColor;
    self.btn_Logout.layer.cornerRadius = 10;
    
    self.btn_Logout.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    
    
    self.navigationItem.hidesBackButton = NO;
    
    
    session = [[AVCaptureSession alloc]init];
    
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //changes
    
    //    AVCaptureDevice *inputDevice = nil;
    //    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    for (AVCaptureDevice *camera in devices ) {
    //        if ([camera position] == AVCaptureDevicePositionFront) {
    //
    //            inputDevice = camera;
    //            break;
    //
    //        }
    //
    //
    //    }
    
    //changes
    
    
    //hiding camera for improper numbering
    
    [CameraViewController setFlashMode:AVCaptureFlashModeAuto forDevice:inputDevice];
    NSError *error;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
        
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view]layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.imageforcapture.frame;
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    StillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings =[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [StillImageOutput setOutputSettings:outputSettings];
    [session addOutput:StillImageOutput];
    [session startRunning];
    
    
    
    
    
    if (self.arrr.count >0) {
        
        NSMutableArray *whole = [[NSMutableArray alloc]init];
        
        whole =self.arrr;
        
        
        // NSDictionary *ddict =[[NSDictionary alloc]init];
        //ddict = whole;
        self.WholeLoadDict =  whole;
        
        
        //   NSLog(@"%@",ddict);
        
        NSMutableArray *arrayOfImages =[[NSMutableArray alloc]init];
        
        arrayOfImages =[self.WholeLoadDict objectForKey:@"img"];
        
        
        self.myimagearray = arrayOfImages;
        
        
        
        
        
        
        
    }
    NSLog(@" whole array :%@",self.arrr);
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    
    
    NSLog(@"memory warning occured");
    
    //[[SingletonImage singletonImage]nilTheDictionary];
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    // tapCount = 0 ;
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    
    [session startRunning];
    
    
    
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.tapCount = 0 ;
        [session stopRunning];
        
        
    }
    [super viewWillDisappear:animated];
}



//****************************************************
#pragma mark - Notification
//****************************************************



//-(void)remove:(NSNotification *)notification
//
//
//{
//    
//    for (UIViewController *controller in self.navigationController.viewControllers)
//    {
//        if ([controller isKindOfClass:[CameraViewController class]])
//        {
//            [self.navigationController popToViewController:controller animated:YES];
//            
//            [self.myimagearray removeAllObjects];
//            [self.collection_View reloadData];
//            
//            
//            break;
//        }
//    }
//    
//    
//    
//}



              
//****************************************************
#pragma mark - Collection View Delagate Methods
//****************************************************
//data source and delegates method


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.myimagearray.count == 0) {
        return 3;
    } else if (self.myimagearray.count == 1) {
        return 3;
    } else if (self.myimagearray.count == 2) {
        return 3;
    } else{
        return self.myimagearray.count;
    }
}

//
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (IS_IPHONE_6) {
//        
//    }
//    
//    return 1;
//    
//    
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth;
    
    if (IS_IPHONE_6) {
        
        int numberOfCellInRow = 3;
        cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
        return CGSizeMake(cellWidth, cellWidth);
        
        
    }
    else
    {
        return CGSizeMake(100, 100);
    }
    
    
    // return CGSizeMake(cellWidth, cellWidth);
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
//}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectionViewCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [Cell.delete_btn setTag:indexPath.row];
    
    
    
    
    if (self.myimagearray.count == 0) {
        
        Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
        
        Cell.waterMark_lbl.text =@"";
        [Cell.delete_btn setHidden:YES]
        ;
        
        
        
    }
    
    else  if (self.myimagearray.count == 1)
    {
        
        if (indexPath.row ==0) {
            
            NSDictionary *adict =[self.myimagearray objectAtIndex:0];
            
            UIImage *image = [adict objectForKey:@"image"];
            
            
            Cell.image_View.image =image;
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
            
            
            
            [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            
            [Cell.delete_btn setHidden:NO];
            
            
            
            
        }
        if (indexPath.row ==1) {
            Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
            
            Cell.waterMark_lbl.text =@"";
            
            [Cell.delete_btn setHidden:YES];
        }
        if (indexPath.row ==2) {
            Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
            Cell.waterMark_lbl.text =@"";
            [Cell.delete_btn setHidden:YES];
        }
    }
    
    
    
    
    //for seconf image
    
    else  if (self.myimagearray.count == 2)
    {
        
        if (indexPath.row == 0) {
            
            NSDictionary *adict =[self.myimagearray objectAtIndex:0];
            
            UIImage *image = [adict objectForKey:@"image"];
            
            
            Cell.image_View.image =image;
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
            
            
            [Cell.delete_btn setHidden:NO];
            [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if (indexPath.row ==1)
        {
            
            
            NSDictionary *adict =[self.myimagearray objectAtIndex:1];
            
            UIImage *image = [adict objectForKey:@"image"];
            
            
            Cell.image_View.image =image;
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell.waterMark_lbl.text = the_index_path;
            [Cell.delete_btn setHidden:NO];
            [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        if (indexPath.row ==2)
            
            
        {
            Cell.image_View.image =[UIImage imageNamed:@"Placeholder.png"];
            
            Cell.waterMark_lbl.text =@"";
            [Cell.delete_btn setHidden:YES];
            
        }
        
        
        
        
    }
    
    
    
    
    else
    {
        NSDictionary *adict =[self.myimagearray objectAtIndex:indexPath.row];
        
        
        UIImage *image = [adict objectForKey:@"image"];
        
        
        Cell.image_View.image =image;
        
        NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
        Cell.waterMark_lbl.text = the_index_path;
        [Cell.delete_btn setHidden:NO];
        
        [Cell.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    return Cell;
    
}


//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *layoutAttributes ;
//    
//    if (indexPath.section == 0 ) // or whatever specific item you're trying to override
//    {
//      layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        layoutAttributes.frame = CGRectMake(10,20,100,100); // or whatever...
//       // return layoutAttributes;
//    }
//    
//    
//    return  layoutAttributes;
//    
//}

//****************************************************
#pragma mark - Action  Methods
//****************************************************//while tapping X delete symbol to delete the picture
-(IBAction)delete:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    self.tapCount-=1;
    
    
    [self.myimagearray removeObjectAtIndex:btn.tag];
    
    NSLog(@" the delete array is :%@",self.myimagearray);
    
    
    [self.collection_View reloadData];
    
    
}


//while tapping next button
-(IBAction)btn_NextTapped:(id)sender
{
    
    if(self.myimagearray.count == 0) {
        
        [self.view makeToast:@"Take at least 1 Picture" duration:1.0 position:CSToastPositionCenter];
        PicViewController *PictureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureVC"];
        [self.navigationController pushViewController:PictureVC animated:YES];
        
    }
    //
    else{
        
        
        
        //location
        CLLocationCoordinate2D coordinate = [self getLocation];
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        NSLog(@"*dLatitude : %@", latitude);
        NSLog(@"*dLongitude : %@",longitude);
        //location
        
        PicViewController *PictureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureVC"];
        
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        PictureVC.imageArray = self.myimagearray;
        PictureVC.siteData = self.siteData;
        PictureVC.sitename = self.siteName;
        PictureVC.wholeLoadDict = self.WholeLoadDict;
        PictureVC.isEdit = self.isEdit;
        delegate.ImageTapcount = self.tapCount;
        [self.navigationController pushViewController:PictureVC animated:YES];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    //CLLocationDegrees lat =
    
    
    //NSString  *latitude = String(@"normal: %f", myLocation.coordinate.latitude);
    
    //NSString *longitude = crnLoc.coordinate.longitude;
    
    NSLog(@"Lattitude :%f",crnLoc.coordinate.latitude);
    NSLog(@"Longitude :%f",crnLoc.coordinate.longitude);
}
-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//
//    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
//}
//While tapping logout button
-(IBAction)logoutClicked:(id)sender {
    
    self.tapCount = 0;
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [delegate.DisplayOldValues removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];
    
    
    
    UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                   instantiateViewControllerWithIdentifier: @"StartNavigation"];
    
    // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
    
}



//while taking photos
-(IBAction)takephoto:(id)sender
{
    if (self.tapCount < uploadCountLimit) {
        self.tapCount ++;
        [self.btn_TakePhoto setEnabled:NO];

        //hiding for camera improper numbering

        AVCaptureConnection *videoConnection  = nil;
        for(AVCaptureConnection *connection in StillImageOutput.connections)
        {
            for(AVCaptureInputPort *port in  [connection inputPorts])
            {
                if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                    videoConnection =connection;
                    break;
                }}}

        [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){

            [self.btn_TakePhoto setEnabled:YES];
            if (imageDataSampleBuffer!=NULL) {
                NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

                UIImage *capturedImage = [UIImage imageWithData:imageData];
                //REducing the captured image size
                CGSize imageSize;
                imageSize = CGSizeMake(590, 750);
                // imageSize = CGSizeMake(1224, 1632);
                //imageSize  =CGSizeMake (1224,1224);
                // imageSize = CGSizeMake(120,120);

                // imageSize = CGSizeMake(816, 1088);//original size divided by 3

                //imageSize = CGSizeMake(700, 750);

                UIGraphicsBeginImageContext(imageSize);
                [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();

                //                NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((capturedImage), 0.5)];
                //                int imageSize1   = imgData.length;
                //                NSLog(@"size of image in KB: %f ", imageSize1/1024.0);

                UIGraphicsEndImageContext();
                int x = arc4random() % 100;
                NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
                NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
                NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                [myimagedict setObject:resizedImage forKey:@"image"];
                [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
                // NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
                //UIImage *img = [UIImage imageNamed:@"notes"];

                // [myimagedict setObject:img forKey:@"image"];


                //UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil);


                [self.myimagearray addObject:myimagedict];
                NSLog(@" the taken photo is:%@",self.myimagearray);
                //reloading the collection view
                [self.collection_View reloadData];
                NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
                NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];

                [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }];
        NSLog(@"the array count is :%lu",(unsigned long)self
              .myimagearray.count);
        NSLog(@" taps occured%d",self.tapCount);
    } else {
        [self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
    }
}


//-(IBAction)takephoto:(id)sender
//{
//    if (self.tapCount < uploadCountLimit) {
//        self.tapCount ++;
//        [self.btn_TakePhoto setEnabled:NO];
//        
//        //hiding for camera improper numbering
//        [self selectPhoto];
//        
//        NSLog(@"the array count is :%lu",(unsigned long)self
//              .myimagearray.count);
//        NSLog(@" taps occured%d",self.tapCount);
//    } else {
//        [self.view makeToast:@"Limit Exceeded" duration:1.0 position:CSToastPositionCenter];
//    }
//}

-(void) selectPhoto {
    UIImagePickerController *simpleImagePicker = [[UIImagePickerController alloc] init];
    simpleImagePicker.delegate = self;
    [simpleImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:simpleImagePicker animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc] init];
    
    UIImage *capturedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    //REducing the captured image size
    CGSize imageSize;
    imageSize = CGSizeMake(590, 750);
    
    UIGraphicsBeginImageContext(imageSize);
    [capturedImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    int x = arc4random() % 100;
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
    
    [myimagedict setObject:resizedImage forKey:@"image"];
    [myimagedict setObject:epochTime forKey:@"created_Epoch_Time"];
    
    [self.myimagearray addObject:myimagedict];
    [self.btn_TakePhoto setEnabled:YES];
    [self.collection_View reloadData];
    NSInteger section = [self numberOfSectionsInCollectionView:self.collection_View] - 1;
    NSInteger item = [self collectionView:self.collection_View numberOfItemsInSection:section] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.collection_View scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
    [self.btn_TakePhoto setEnabled:YES];
}

//****************************************************
#pragma mark - Flash Methods
//****************************************************

//for flash
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}

- (IBAction)back_action_btn:(id)sender {
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    delegate.ImageTapcount = self.tapCount;
    //        delegate.count = 0;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
