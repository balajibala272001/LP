//
//  GalleryViewController.m
//  CognitoSyncDemo
//
//  Created by Suganya on 01/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//
#import "CategoryViewController.h"
#import "GalleryLoopViewController.h"
#import "NotesViewController.h"
#import "PicturesCollectionViewCell.h"
#import "ProjectDetailsViewController.h"
#import "StaticHelper.h"
#import "SingletonImage.h"
#import "Reachability.h"
#import "pageViewController.h"
#import "AZCAppDelegate.h"
#import "SCLAlertView.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "GalleryCollectionViewCell.h"
#import "TabCollectionViewCell.h"
#import "CaptureScreenViewController.h"
#import "LoadSelectionViewController.h"
#import "selectedTab.h"
#import "LoopingViewController.h"

@interface GalleryLoopViewController ()
{
    NSInteger deletePosition;
    AZCAppDelegate *delegateVC;
    int selected_tab;
    NSMutableArray *tempArr;
    selectedTab *tab;
    NSInteger cropPosition;
}

@property (nonatomic,strong) NSMutableDictionary *contentOffsetDictionary;
@end

@implementation GalleryLoopViewController
@synthesize pathToImageFolder;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

- (void)viewDidLoad {
    [super viewDidLoad];
    tab = [selectedTab alloc];
    tempArr = [[NSMutableArray alloc]init];
    selected_tab = 0;
    self.instruction_number = [[[NSUserDefaults standardUserDefaults] valueForKey:@"img_instruction_number"]intValue];
    self.currentTappiCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"current_Looping_Count"]intValue];
    self.tappicount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"tappi_count"]intValue];
    if(self.instruction_number == 0 && self.currentTappiCount == 0){
        self.tab_CollectionView.hidden = YES;
    }
    //[self updateCollectionView];
    self.tab_CollectionView.layer.cornerRadius = 10;
    self.tab_CollectionView.layer.borderWidth = 5;
    self.tab_CollectionView.layer.borderColor = [UIColor whiteColor].CGColor;
  
     NSLog(@"_imageArray: %@",_imageArray);

    self.oldValues = [[NSMutableArray alloc]init];
    //Intializing array and Dictionary
    self.oneImageDict = [[NSMutableDictionary alloc]init];
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
  
    //Making Corner Radius for sub-view
    self.sub_View.layer.cornerRadius = 10;
    self.sub_View.layer.borderWidth = 1;
    self.sub_View.layer.borderColor = Blue.CGColor;
    
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
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithCustomView:next ];
    self.navigationItem.rightBarButtonItem = NextButton;
    [self.list_CollectionView reloadData];
    selected_tab = self.currentTappiCount;
    [self.tab_CollectionView reloadData];
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


-(void )handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(140,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Gallery",@"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
    [view addSubview:titleLabel];
    
    view.center = self.view.center;

    if (delegate.isMaintenance) {
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"yellow_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.921 blue: 0.243 alpha: 1.00].CGColor;
        
            //RGBA ( 255 , 235 , 62 , 100 )
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
        
            //RGBA ( 213 , 191 , 0 , 100 )
       
        NSLog(@"Server Under maintenance");
        
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 229 , 8 , 100)
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 174 , 7 , 100 )
        
        NSLog(@"Network Connection available");
    }else{
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
        
            //RGBA ( 248 , 181 , 82 , 80 )
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
        
            //RGBA ( 253 , 133 , 8 , 100 )
    }
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    self.navigationItem.titleView = view;
    
}


-(IBAction)poper:(id)sender {
    [self handleTimer];
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
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
    if([collectionView isEqual:self.tab_CollectionView]){
        return  self.tappicount;
    }else{
        int numb_of_picsCapt = 0;
        for(int i = 0; i<self.imageArray.count; i++){
            NSDictionary *dictt = [[NSDictionary alloc] init];
            dictt = [self.imageArray objectAtIndex:i];
            if(selected_tab == [[dictt objectForKey:@"img_numb"]intValue]){
                numb_of_picsCapt ++;
            }
        }
        if(!(numb_of_picsCapt==0)){
            return numb_of_picsCapt;
        }else{
            return 0;
        }
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.list_CollectionView]){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            return CGSizeMake(150, 225);
        }else if (self.view.frame.size.width == 320)
        {
            return CGSizeMake(75, 112.5);
        }else{
            return CGSizeMake(100, 150);
        }
    }else{
        return CGSizeMake(40, 40);
    }
}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"q4");
    if([collectionView isEqual:self.list_CollectionView]){
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
    }
    else{
        int grossCellwidth = 0 , totalCellwidth = 0;
        totalCellwidth = 40 * self.tappicount; //50->cellWidth
        grossCellwidth = totalCellwidth + 20;
        int widthDiff = (self.tab_CollectionView.frame.size.width - grossCellwidth);
        if(widthDiff <= 0){
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            return UIEdgeInsetsMake(0,widthDiff/2 , 0, 0);
        }
          //      return UIEdgeInsetsMake(0, 80 , 0, 0);

    }
     // top, left, bottom, right
}
-(void)viewDidAppear:(BOOL)animated {
    [self.list_CollectionView reloadData];
}



-(void)viewWillAppear:(BOOL)animated {
    
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"PicviewVC";
    [[NSUserDefaults standardUserDefaults] setValue:@"PicViewVC" forKey:@"CurrentVC"];
    self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
    self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
    [super viewWillAppear:animated];
    [self handleTimer];
    [self updateCollectionView];
    [self.list_CollectionView reloadData];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isEqual:self.list_CollectionView]){
        //int errorIndex = 0, errorTab = 0, tabCounter = -1;
        int InctNumb = 0;
        bool error = false ;
        int newIndex = 0;
        
        //TempArr_to_displayImages
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        int value = selected_tab;
        for(int j=0; j < self.imageArray.count; j++){
            NSDictionary *dictt = [[NSDictionary alloc] init];
            dictt = [self.imageArray objectAtIndex:j];
            int valuee = [[dictt objectForKey:@"img_numb"]intValue];
            if(value == valuee){
                [arr addObject:dictt];
            }
        }
        for(int j=0; j < arr.count; j++){
            NSDictionary *dicto = [[NSDictionary alloc] init];
            dicto = [arr objectAtIndex:j];
            if([[dicto valueForKey: @"imageName"] isEqual: @""]){
                newIndex = j;
            }
        }
        
      //  NSDictionary*dict;
       // for(int i=0; i<self.imageArray.count; i++ , newIndex++){
       //     dict = [self.imageArray objectAtIndex:i];
        //    InctNumb = [[dict valueForKey:@"img_numb"]intValue];
//            if(preciousInstructNum == -1 || preciousInstructNum != InctNumb){
//                newIndex = 0;
//                tabCounter ++;
//                preciousInstructNum = InctNumb;
//            }
//            if([[dict valueForKey: @"imageName"] isEqual: @""]){
//                error = true;
//                //errorTab = tabCounter;
//                errorIndex = i;
//                break;
//            }
//        }
        
        //IndexFromMainArr
        NSMutableDictionary*dicto;
        int index = 0;
        for(int i=0; i<self.imageArray.count; i++){
            dicto = [[self.imageArray objectAtIndex:i]mutableCopy];
            //long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
            //long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
            if([[dicto valueForKey: @"imageName"] isEqual: @""]){
                error = true;
                InctNumb = [[dicto objectForKey:@"img_numb"]intValue];
                index = i;
                NSLog(@"index:%d",index);
                break;
            }
        }
        if(error == true && indexPath.row == newIndex){
            NSLog(@"single tap");
            //maintaining_currenttappi_count
            self.currentTappiCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"] intValue];
            self.instruction_number = [[[NSUserDefaults standardUserDefaults] valueForKey:@"img_instruction_number"] intValue];
            
            tab.selectedTab = selected_tab;
            tab.errorIndex = newIndex;
            tab.indexPath = index;
            tab.instructionNumb = InctNumb;
            Looping_Camera_ViewController *cameraLoopvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraLoopVC"];
            cameraLoopvc.siteData = self.siteData;
            cameraLoopvc.siteName = self.sitename;
            cameraLoopvc.tapCount = self.imageArray.count;
            cameraLoopvc.isEdit = YES;
            cameraLoopvc.loopImagearray = self.imageArray;
            int loadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            cameraLoopvc.load_number = loadnumber;
            cameraLoopvc.selectedTab = tab;
            //cameraLoopvc.selected_tab = selected_tab;
            [self.navigationController pushViewController:cameraLoopvc animated:YES];
        }else{
            NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
            
            //TempArr_to_displayImages
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            int value = selected_tab;
            for(int j=0; j < self.imageArray.count; j++){
                NSDictionary *dictt = [self.imageArray objectAtIndex:j];
                int valuee = [[dictt objectForKey:@"img_numb"]intValue];
                if(value == valuee){
                    [arr addObject:dictt];
                }
            }
            NSDictionary* dict = [arr objectAtIndex:indexPath.row];
            
            //RemovingfromMainArray
            NSMutableDictionary*dicto;//= [[NSDictionary alloc] init];
            int index = 0;
            for(int i=0; i<self.imageArray.count; i++){
                dicto = [[self.imageArray objectAtIndex:i]mutableCopy];
                long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
                long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
                if(arr_time == imageArray_time){
                    //[self.imageArray replaceObjectAtIndex:i withObject:dict];
                    index = i;
                    NSLog(@"index:%d",index);
                    break;
                }
            }
            NotesVC.dictionaries = dicto;
            NotesVC.indexPathRow = index;
            NotesVC.delegate = self;
            [self.navigationController pushViewController:NotesVC animated:YES];
        }

    }else{
        selected_tab = indexPath.row;
        [self.list_CollectionView reloadData];
        [self.tab_CollectionView reloadData];
    }
}


-(void)updateCollectionView{
    
    NSString *instnum = [NSString stringWithFormat:@"%d", selected_tab];
    [tempArr removeAllObjects];
    for(int i=0; i<self.imageArray.count; i++)
    {
        NSMutableDictionary *dict= [self.imageArray objectAtIndex:i];
        NSString *valueNum = [dict objectForKey:@"img_numb"];
        if([valueNum isEqualToString:instnum])
        {
            [tempArr addObject:dict];
        }
    }
    [self.list_CollectionView reloadData];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([collectionView isEqual:self.list_CollectionView]){

        GalleryCollectionViewCell *Cell1 ;
        Cell1= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
       
        //TempArr_to_displayImages
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        int value = selected_tab;
        for(int j=0; j < self.imageArray.count; j++){
            NSDictionary *dictt = [[NSDictionary alloc] init];
            dictt = [self.imageArray objectAtIndex:j];
            int valuee = [[dictt objectForKey:@"img_numb"]intValue];
            if(value == valuee){
                [arr addObject:dictt];
            }
        }
        
        NSDictionary * dictt = [arr objectAtIndex:indexPath.row];
        NSString *imageName = [dictt valueForKey:@"imageName"];
        if([imageName isEqualToString:@""]){
            
            [Cell1.Takephoto setHidden:NO];
            [Cell1.imageView setHidden:YES];
            [Cell1.crop_but setHidden:YES];
            [Cell1.low_light setHidden:YES];
            [Cell1.blur_img setHidden:YES];
            [Cell1.videoicon setHidden:YES];
            [Cell1.delete_btn setHidden:YES];
            [Cell1.notesImageView setHidden:YES];
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell1.number_lbl.text = the_index_path;
            Cell1.layer.borderColor = [UIColor blackColor].CGColor;
            Cell1.layer.borderWidth = 2;
            Cell1.layer.cornerRadius = 3;
        
            return Cell1;
            
        }else{
            Cell1.layer.borderColor = [UIColor blackColor].CGColor;
            Cell1.layer.borderWidth = 0;
            Cell1.layer.cornerRadius = 3;
            [Cell1.imageView setHidden:NO];
            [Cell1.crop_but setHidden:NO];
            [Cell1.delete_btn setHidden:NO];
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
                    Cell1.imageView.image =[UIImage imageNamed:@"Placeholder.png"];
                }
                [Cell1.videoicon setHidden:NO];
                [Cell1.crop_but setHidden:YES];
                [Cell1.blur_img setHidden:YES];
                [Cell1.low_light setHidden:YES];
                [Cell1.Takephoto setHidden:YES];
            }else{
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
                NSLog(@"boolToRestrict:%d",boolToRestrict);
            
                //lowlight
                NSString* IsLowLight = [dictt valueForKey:@"brightness"];
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
                NSString* variance = [dictt valueForKey:@"variance"];
                if ([variance isEqualToString:@"FALSE"]) {
                    [Cell1.blur_img setHidden:YES];
                }else{
                    if(boolToRestrict  == FALSE){
                        [Cell1.blur_img setHidden:NO];
                    }else{
                        [Cell1.blur_img setHidden:YES];
                    }
                }
            
                [Cell1.Takephoto setHidden:YES];
                NSData *imageData;
                NSLog(@"Image Quality (upload):%@",self.image_quality);
                if([self.siteData.image_quality isEqual:@"1"]) {
                    imageData = UIImageJPEGRepresentation(image, 0.93);
                    NSLog(@"compress ratio : %f",0.93);
                }else if([self.siteData.image_quality isEqual:@"2"]) {
                    imageData = UIImageJPEGRepresentation(image, 0.85);
                    NSLog(@"compress ratio : %f",0.85);
                }else if([self.siteData.image_quality isEqual:@"3"]){
                    imageData = UIImageJPEGRepresentation(image, 0.9942);
                    NSLog(@"compress ratio : %f",0.994);
                }
                
                CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
                CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                    (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                    (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                    (id) kCGImageSourceThumbnailMaxPixelSize : @(300)
                };

                CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
                UIImage *scaled = [UIImage imageWithCGImage:scaledImageRef];
                CGImageRelease(scaledImageRef);
                Cell1.imageView.image = scaled;
                NSLog(@"Updated : W %f H %f",image.size.width,image.size.height);
                [Cell1.videoicon setHidden:YES];
            }

            NSString *text = [dictt objectForKey:@"string"];
            
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell1.number_lbl.text = the_index_path;
            Cell1.notesImageView.image =[UIImage imageNamed:@"notesicon.png"];
            if (text.length == 0) {
                [Cell1.notesImageView setHidden:YES];
            }
            else{
                [Cell1.notesImageView setHidden:NO];
            }
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [Cell1 addGestureRecognizer:longPress];
            NSLog(@"q8");
            [Cell1.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.delete_btn setTag:indexPath.row];
            [Cell1.crop_but addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.crop_but setTag:indexPath.row];

            return Cell1;
        }
    }else{
        TabCollectionViewCell *Cell2 ;
        Cell2= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        NSString * str= [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        Cell2.Lab_title.text = str;
        Cell2.layer.cornerRadius = 20;
        if(selected_tab == indexPath.row){
            Cell2.Lab_title.layer.borderColor = [UIColor whiteColor].CGColor;
            Cell2.Lab_title.backgroundColor = Blue;
            Cell2.Lab_title.textColor = [UIColor whiteColor];
        }else{
            Cell2.Lab_title.layer.borderColor = Blue.CGColor;
            Cell2.Lab_title.backgroundColor = [UIColor whiteColor];
            Cell2.Lab_title.textColor = Blue;
        }
        return Cell2;
    }
}




- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    CGPoint p = [gesture locationInView:self.list_CollectionView];
    NSIndexPath *indexPath = [self.list_CollectionView indexPathForItemAtPoint:p];
    NSMutableDictionary *dict = [[self.imageArray objectAtIndex:indexPath.row] mutableCopy];
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            NSLog(@"i:%ld",(long)indexPath.row);
            NSLog(@"Long Pressed");
        }else{
            if ( gesture.state == UIGestureRecognizerStateBegan ) {
                pageViewController *pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
                CGPoint p = [gesture locationInView:self.list_CollectionView];
                //TempArr_to_displayImages
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                int value = selected_tab;
                for(int j=0; j < self.imageArray.count; j++){
                    NSDictionary *dictt = [[NSDictionary alloc] init];
                    dictt = [self.imageArray objectAtIndex:j];
                    int valuee = [[dictt objectForKey:@"img_numb"]intValue];
                    if(value == valuee){
                        [arr addObject:dictt];
                    }
                }
                NSDictionary * dict = [arr objectAtIndex:indexPath.row];
                
                //RemovingfromMainArray
                NSMutableDictionary*dicto = [[NSMutableDictionary alloc] init];
                int index = 0;
                for(int i=0; i<self.imageArray.count; i++){
                    dicto = [self.imageArray objectAtIndex:i];
                    long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
                    long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
                    if(arr_time == imageArray_time){
                        //[self.imageArray replaceObjectAtIndex:i withObject:dict];
                        index = i;
                        NSLog(@"index:%d",index);
                        break;
                    }
                }
                NSIndexPath *indexPath = [self.list_CollectionView indexPathForItemAtPoint:p];
                //NSMutableDictionary *dict = [[self.imageArray objectAtIndex:index] mutableCopy];
                pageVC.array = self.imageArray;
                pageVC.indexPath = index;
                    //  NSURL *vedioURL = [NSURL fileURLWithPath:path];
                [self.navigationController pushViewController:pageVC animated:YES];
                UICollectionViewCell *cellLongPressed = (UICollectionViewCell *) gesture.view;
             }
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
    
    NSLog(@"gallery imageArray:%@",self.imageArray);
    if (self.imageArray.count>0) {
        bool error = false ;
        for(int i=0; i<self.imageArray.count; i++){
            NSDictionary*dict = [self.imageArray objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                error = true;
                break;
            }
        }
            if(error == true){
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"")subTitle:NSLocalizedString(@"Kindly capture the missing photo to move next.",@"") closeButtonTitle:nil duration:1.0f ];
            }else{
                if(self.currentTappiCount == 0 && self.instruction_number == 0){
                    [[NSUserDefaults standardUserDefaults]setObject:self.imageArray forKey:@"picslist"];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                    CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
                    
                    Category.siteData = self.siteData;
                    Category.arrayOfImagesWithNotes = self.imageArray;
                    NSLog(@"imageArray:%@",self.imageArray);
                    Category.sitename = self.sitename;
                        // ProjectVC.pathToImageFolder = pathToImageFolder;
                    Category.image_quality = self.siteData.image_quality;
                    Category.isEdit = self.isEdit;
                    
                    if (self.oldValues.count ==0) {
                        NSLog(@"yes");
                        Category.oldValuesReturn = self.oldValues;
                    }
                    [self.navigationController pushViewController:Category animated:YES];
                    
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:self.imageArray forKey:@"picslist"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    LoopingViewController *loopingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loopingVC"];
                    loopingVC.siteData = self.siteData;
                    loopingVC.arrayOfImagesWithNotes = self.imageArray;
                    NSLog(@"imageArraygallery:%@",self.imageArray);
                    loopingVC.sitename = self.sitename;
                        // ProjectVC.pathToImageFolder = pathToImageFolder;
                    loopingVC.image_quality = self.siteData.image_quality;
                    loopingVC.isEdit = self.isEdit;
                    loopingVC.tappi_count = self.tappicount;
                    if (self.oldValues.count == 0) {
                        NSLog(@"yes");
                        loopingVC.oldValuesReturn = self.oldValues;
                    }
                    [self.navigationController pushViewController:loopingVC animated:YES];
                }
            }
    }else{
        [self.view makeToast:NSLocalizedString(@"Take Atleast 1 Media file ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
}


-(void)notesData:(NSInteger *)indexPathRow changedData:(NSMutableDictionary *)dic
{
    [self.imageArray replaceObjectAtIndex:indexPathRow withObject:dic];
    NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    load= [[array objectAtIndex:i]mutableCopy];
    [load setObject:self.imageArray forKey:@"img"];
    [array replaceObjectAtIndex:i withObject:load];
    [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.list_CollectionView reloadData];
}



-(void)sendDataToPictureConfirmation:(NSMutableArray *)array{
    NSLog(@"q0");
    self.oldValues = array;
    NSLog(@"%@",self.oldValues);
}


- (void)back_button:(id)sender
{
    ServerUtility * imge = [[ServerUtility alloc] init];
    imge.picslist = self.imageArray;
    NSLog(@"gallery imageArray:%@",self.imageArray);
    if (self.imageArray.count>0) {
        bool error = false ;
        for(int i=0; i<self.imageArray.count; i++){
            NSDictionary*dict = [self.imageArray objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                error = true;
                break;
            }
        }
        if(error == true){
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"")subTitle:NSLocalizedString(@"Kindly capture the missing photo to move next.",@"") closeButtonTitle:nil duration:1.0f ];
        }else{
            self.currentTappiCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"current_Looping_Count"] intValue];
            self.instruction_number = [[[NSUserDefaults standardUserDefaults] valueForKey:@"img_instruction_number"] intValue];

            NSLog(@"self.currentTappiCount:%d",self.currentTappiCount);
            NSLog(@"self.instruction_number:%d",self.instruction_number);
            Looping_Camera_ViewController *cameraLoopvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraLoopVC"];
            cameraLoopvc.siteData = self.siteData;
            cameraLoopvc.siteName = self.sitename;
            cameraLoopvc.tapCount = self.imageArray.count;
            cameraLoopvc.isEdit = YES;
            cameraLoopvc.loopImagearray = self.imageArray;
            int loadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            cameraLoopvc.load_number = loadnumber;
           // cameraLoopvc.selectedTab = tab;
            [self.navigationController pushViewController:cameraLoopvc animated:YES];
        }
    }
}


-(IBAction)BlurImgClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Blur Image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender
{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor: Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)delete:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    deletePosition = btn.tag;
    bool error = false ;
    for(int i=0; i<self.imageArray.count; i++){
        NSDictionary*dict = [self.imageArray objectAtIndex:i];
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            error = true;
            break;
        }
    }
    if(error == true){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"You are not allowed to delete photo. Unless you capture missing photo.",@"") closeButtonTitle:nil duration:1.0f ];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoad:) backgroundColor:Red];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Are You Sure you want to delete this media file?",@"") closeButtonTitle:nil duration:1.0f ];
    }
}


-(void)deleteLoad:(id)sender
{
    
    //TempArr_to_displayImages
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    int value = selected_tab;
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *dictt = [[NSDictionary alloc] init];
        dictt = [self.imageArray objectAtIndex:j];
        int valuee = [[dictt objectForKey:@"img_numb"]intValue];
        if(value == valuee){
            [arr addObject:dictt];
        }
    }
    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
    myimagedict = [[arr objectAtIndex:deletePosition]mutableCopy];
    NSLog(@"myimagedict_delete:%@",myimagedict);
    [myimagedict setValue:@"" forKey:@"brightness"];
    //[myimagedict setValue:@"" forKey:@"created_Epoch_Time"];
    [myimagedict setValue:@"" forKey:@"latitude"];
    [myimagedict setValue:@"" forKey:@"load_tookout_type"];
    [myimagedict setValue:@"" forKey:@"longitude"];
    [myimagedict setValue:@"" forKey:@"variance"];
    [myimagedict setValue:@"" forKey:@"imageName"];
    int img_num = [[myimagedict objectForKey:@"img_numb"]intValue];
    [myimagedict setValue:[NSString stringWithFormat:@"%d",img_num] forKey:@"img_numb"];
    int time = [[myimagedict objectForKey:@"created_Epoch_Time"]intValue];
    [myimagedict setValue:[NSString stringWithFormat:@"%d",time] forKey:@"created_Epoch_Time"];
    NSLog(@"myimagedict1:%@",myimagedict);
    
    //RemovingfromMainArray
    int index = 0;
    for(int i=0; i<self.imageArray.count; i++){
        NSDictionary*dict = [self.imageArray objectAtIndex:i];
        long arr_time = [[myimagedict objectForKey:@"created_Epoch_Time"]intValue];
        long imageArray_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
        if(arr_time == imageArray_time){
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }
    [self.imageArray replaceObjectAtIndex:index withObject:myimagedict];
    [_parkLoad setObject:self.imageArray forKey:@"img"];
    [_parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:_parkLoad];
    [[NSUserDefaults standardUserDefaults]setObject:_parkLoadArray forKey:@"ParkLoadArray" ];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[self updateCollectionView];
    [_list_CollectionView reloadData];
}


- (IBAction)crop:(id)sender {
    UIButton *btn = (UIButton *)sender;
    cropPosition = btn.tag;
    
    //tempArr
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    int value = selected_tab;
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *dictt = [[NSDictionary alloc] init];
        dictt = [self.imageArray objectAtIndex:j];
        int valuee = [[dictt objectForKey:@"img_numb"]intValue];
        if(value == valuee){
            [arr addObject:dictt];
        }
    }
    
    NSDictionary * dic = [[arr objectAtIndex:cropPosition]mutableCopy];
    //NSMutableDictionary *dic=[self.imageArray objectAtIndex:btn.tag];
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

    //tempArr
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    int value = selected_tab;
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *dictt = [[NSDictionary alloc] init];
        dictt = [self.imageArray objectAtIndex:j];
        int valuee = [[dictt objectForKey:@"img_numb"]intValue];
        if(value == valuee){
            [arr addObject:dictt];
        }
    }
    
    CGRect cropArea = controller.cropArea;
    self.dictionaries= [[arr objectAtIndex:cropPosition]mutableCopy];

    //REducing the cropped image size
    CGSize imageSize;
    NSLog(@"Image Quality :%@",self.siteData.image_quality);
    if ([self.siteData.image_quality isEqual:@"1"]) {
        imageSize = CGSizeMake(720,1080);
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 720 x 1080"];
    }else{
        imageSize = CGSizeMake(1440,2160);
        // _uploadFinalSize.text  = [NSString stringWithFormat:@"Fianl Upload : 1440 x 2160"];
    }
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
    //RemovingfromMainArray
    int index = 0;
    for(int i=0; i<self.imageArray.count; i++){
        NSMutableDictionary*dict = [self.imageArray objectAtIndex:i];
        long arr_time = [[self.dictionaries objectForKey:@"created_Epoch_Time"]intValue];
        long imageArray_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
        if(arr_time == imageArray_time){
            [self.imageArray replaceObjectAtIndex:i withObject:self.dictionaries];
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }
    //[self.imageArray replaceObjectAtIndex:cropPosition withObject:self.dictionaries];
    
    //image_saving
    NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    load= [[array objectAtIndex:i]mutableCopy];
    [load setObject:self.imageArray forKey:@"img"];
    [array replaceObjectAtIndex:i withObject:load];
    [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self navigationController] popViewControllerAnimated:YES];

}

-(void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    //self.imgview.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}

@end