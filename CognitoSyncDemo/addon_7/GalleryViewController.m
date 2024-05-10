//
//  GalleryViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 01/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//
#import "CategoryViewController.h"
#import "GalleryViewController.h"
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

@interface GalleryViewController ()
{
    NSInteger deletePosition;
    AZCAppDelegate *delegateVC;
    int selected_tab;
    int indeValue;
    NSMutableArray *tempArr;
    selectedTab *tab;
    NSInteger cropPosition;
}

@property (nonatomic,strong) NSMutableDictionary *contentOffsetDictionary;
@end

@implementation GalleryViewController
@synthesize pathToImageFolder;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

- (void)viewDidLoad {
    NSLog(@"arr:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"]);
    [super viewDidLoad];
    tab = [selectedTab alloc];
    tempArr = [[NSMutableArray alloc]init];
    indeValue = 0;
    selected_tab = 0;
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [_instructData objectAtIndex:selected_tab];
    NSString *value = [dictionary objectForKey:@"instruction_name"];
    
    [self updateCollectionView];
    self.step_Label.text = value;

    self.tab_CollectionView.layer.cornerRadius = 10;
    self.tab_CollectionView.layer.borderWidth = 5;
    self.tab_CollectionView.layer.borderColor = [UIColor whiteColor].CGColor;
  
      NSLog(@"_imageArray: %@",_imageArray);

    //NSLog(@"wholeDict:%@",_wholeLoadDict);
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
    } else {
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
    if([collectionView isEqual:self.tab_CollectionView]){
    NSLog(@"q1");
        return 1;
    }else{
        return 1;
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:self.tab_CollectionView]){
        NSLog(@"q2");
        //AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
       // _instructData = delegate.userProfiels.instruct.instructData;
        return  _instructData.count;
        
    }else{
        int numb_of_picsCapt = 0;
        self.oldGalleryData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = [self.oldGalleryData objectAtIndex:selected_tab];
        int value = [[dict objectForKey:@"instruction_number"]intValue];
        for(int i=0; i < self.imageArray.count; i++){
            NSDictionary *dictt = [[NSDictionary alloc] init];
            dictt = [self.imageArray objectAtIndex:i];
            int valuee = [[dictt objectForKey:@"InstructNumber"]intValue];
           // numb_of_picsCapt = 0;
            if(value == valuee){
                numb_of_picsCapt ++;
            }
        }
        return numb_of_picsCapt;
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.list_CollectionView]){

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
    else{
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
        totalCellwidth = 40 * self.instructData.count; //50->cellWidth
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
        int errorIndex = 0, errorTab = 0, tabCounter = -1;
        int InctNumb = 0;
        bool error = false ;
        int newIndex = 0,preciousInstructNum = -1;
        for(int i=0; i<self.imageArray.count; i++ , newIndex++){
            NSDictionary*dict = [self.imageArray objectAtIndex:i];
            InctNumb = [[dict valueForKey:@"InstructNumber"]intValue];
            if(preciousInstructNum == -1 || preciousInstructNum != InctNumb){
                newIndex = 0;
                tabCounter ++;
                preciousInstructNum = InctNumb;
            }
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                error = true;
                errorTab = tabCounter;
                errorIndex = i;
                break;
            }
        }
        if(error == true && indexPath.row == newIndex && errorTab == selected_tab){
            NSLog(@"single tap");
            tab.selectedTab = selected_tab;
            tab.errorIndex = errorIndex;
            tab.indexPath = indexPath.row;
            tab.instructionNumb = InctNumb;
            CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
            CaptureVC.siteData = self.siteData;
            CaptureVC.siteName = self.sitename;
            CaptureVC.tapCount = self.imageArray.count;
            CaptureVC.isEdit = YES;
            CaptureVC.ArrayofstepPhoto = self.imageArray;
            int loadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            CaptureVC.load_number = loadnumber;
            CaptureVC.selectedTab = tab;
            [self.navigationController pushViewController:CaptureVC animated:YES];
        }else{
            NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
            int posi = 0;
            NSLog(@"selected_tab:%d",selected_tab);
            for(int i = 0; i<selected_tab;i++){
                self.oldGalleryData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
                NSDictionary *dict = [[NSDictionary alloc] init];
                dict = [self.oldGalleryData objectAtIndex:i];
                int value = [[dict objectForKey:@"instruction_number"]intValue];
                
                int numb_of_picsCapt = 0;
                for(int i=0; i < self.imageArray.count; i++){
                    NSDictionary *dictt = [[NSDictionary alloc] init];
                    dictt = [self.imageArray objectAtIndex:i];
                    int valuee = [[dictt objectForKey:@"InstructNumber"]intValue];
                   // numb_of_picsCapt = 0;
                    if(value == valuee){
                        numb_of_picsCapt ++;
                        //return numb_of_picsCapt;
                    }else{
                        //break;
                    }
                }
                posi = posi + numb_of_picsCapt;
                NSLog(@"positionNote:%d",posi);
            }
            if(posi+indexPath.row < self.imageArray.count){

                NSMutableDictionary *dicto = [[self.imageArray objectAtIndex:posi+indexPath.row] mutableCopy];
                NotesVC.dictionaries = dicto;
                NotesVC.indexPathRow = posi+indexPath.row;
                NotesVC.delegate = self;
                [self.navigationController pushViewController:NotesVC animated:YES];
            }
        }

    }else{
       
        NSDictionary *dictionary = [[NSDictionary alloc] init];
        dictionary = [_instructData objectAtIndex:indexPath.row];
        NSString *value = [dictionary objectForKey:@"instruction_name"];
        self.step_Label.text = value;
        selected_tab = indexPath.row;
        NSDictionary *dicti = [[NSDictionary alloc] init];
        dicti = [_instructData objectAtIndex:selected_tab];
        NSString *instnum = [dicti objectForKey:@"instruction_number"];
        [tempArr removeAllObjects];

        for(int i=0; i<self.imageArray.count; i++)
        {
            NSMutableDictionary *dict= [self.imageArray objectAtIndex:i];
            NSString *valueNum = [dict objectForKey:@"InstructNumber"];

            if([valueNum isEqualToString:instnum])
            {
                [tempArr addObject:dict];
            }
        }
        [self.list_CollectionView reloadData];
        [self.tab_CollectionView reloadData];
    }
}


-(void)updateCollectionView{
    NSDictionary *dicti = [[NSDictionary alloc] init];
    dicti = [_instructData objectAtIndex:selected_tab];
    NSString *instnum = [dicti objectForKey:@"instruction_number"];
    [tempArr removeAllObjects];
    for(int i=0; i<self.imageArray.count; i++)
    {
        NSMutableDictionary *dict= [self.imageArray objectAtIndex:i];
        NSString *valueNum = [dict objectForKey:@"InstructNumber"];
        if([valueNum isEqualToString:instnum])
        {
            [tempArr addObject:dict];
        }else{
           // break;
        }
    }
    [self.list_CollectionView reloadData];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([collectionView isEqual:self.list_CollectionView]){

        GalleryCollectionViewCell *Cell1 ;
        Cell1= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        //image
        NSDictionary *dictionary = [[NSDictionary alloc] init];
        dictionary = [_instructData objectAtIndex:selected_tab];
        int position = 0;
        int numb_of_picsCapt = 0;
        NSLog(@"selected_tab:%d",selected_tab);
        for(int i = 0; i<selected_tab;i++){
            self.oldGalleryData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict = [self.oldGalleryData objectAtIndex:i];
            int value = [[dict objectForKey:@"instruction_number"]intValue];
            for(int i=0; i < self.imageArray.count; i++){
                NSDictionary *dictt = [[NSDictionary alloc] init];
                dictt = [self.imageArray objectAtIndex:i];
                int valuee = [[dictt objectForKey:@"InstructNumber"]intValue];
               // numb_of_picsCapt = 0;
                if(value == valuee){
                    numb_of_picsCapt ++;
                    //return numb_of_picsCapt;
                }else{
                    //break;
                }
            }
            NSLog(@"positionNote:%d",position);
            NSLog(@"numb_of_picsCapt:%d",numb_of_picsCapt);
            position = numb_of_picsCapt;
            NSLog(@"positionNote:%d",position);
            
        }
       // if(position+indexPath.row < self.imageArray.count){
            NSMutableDictionary *dictt = [[self.imageArray objectAtIndex:position+indexPath.row] mutableCopy];
           // NSMutableDictionary *dict= [tempArr objectAtIndex:indexPath.row];
            NSString* imageName = [dictt valueForKey:@"imageName"];

           //image
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
                        Cell1.imageView.image =image;
                    }
                    else{
                        Cell1.imageView.image =[UIImage imageNamed:@"Placeholder.png"];
                    }
                    [Cell1.videoicon setHidden:NO];
                    //[Cell1.crop_but setHidden:YES];
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
                    Cell1.imageView.image =scaled;
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
            [Cell1.delete_btn setTag:position+indexPath.row];
            [Cell1.crop_but addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.crop_but setTag:position+indexPath.row];


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
                int position = 0;
                int numb_of_picsCapt = 0;
                NSLog(@"selected_tab:%d",selected_tab);
                for(int i = 0; i<selected_tab;i++){
                    self.oldGalleryData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
                    NSDictionary *dict = [[NSDictionary alloc] init];
                    dict = [self.oldGalleryData objectAtIndex:i];
                    int value = [[dict objectForKey:@"instruction_number"]intValue];
                    for(int i=0; i < self.imageArray.count; i++){
                        NSDictionary *dictt = [[NSDictionary alloc] init];
                        dictt = [self.imageArray objectAtIndex:i];
                        int valuee = [[dictt objectForKey:@"InstructNumber"]intValue];
                       // numb_of_picsCapt = 0;
                        if(value == valuee){
                            numb_of_picsCapt ++;
                            //return numb_of_picsCapt;
                        }else{
                            //break;
                        }
                    }
                    position = numb_of_picsCapt;
                    NSLog(@"position:%d",position);
                }
                NSIndexPath *indexPath = [self.list_CollectionView indexPathForItemAtPoint:p];
                NSMutableDictionary *dict = [[self.imageArray objectAtIndex:position+indexPath.row] mutableCopy];
                pageVC.array = self.imageArray;
                pageVC.indexPath = position+indexPath.row;
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
                [[NSUserDefaults standardUserDefaults]setObject:self.imageArray forKey:@"picslist"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"my1 %@",imge.picslist);
                
                CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
                Category.siteData = self.siteData;
                Category.arrayOfImagesWithNotes = self.imageArray;
                NSLog(@"imageArraygallery:%@",self.imageArray);
                Category.sitename = self.sitename;
                    // ProjectVC.pathToImageFolder = pathToImageFolder;
                Category.image_quality = self.siteData.image_quality;
                Category.isEdit = self.isEdit;
                
                if (self.oldValues.count ==0) {
                    NSLog(@"yes");
                    Category.oldValuesReturn = self.oldValues;
                }
                [self.navigationController pushViewController:Category animated:YES];
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
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoadd:) backgroundColor:Red];
    [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
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
    NSDictionary *dict = [[NSDictionary alloc] init];
    int valuee = 0;
    for(int i = 0; i<selected_tab;i++){
        self.oldGalleryData = [[NSUserDefaults standardUserDefaults]valueForKey:@"ArrCount"];
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = [self.oldGalleryData objectAtIndex:i];
        int value = [[dict objectForKey:@"instruction_number"]intValue];
        
        int numb_of_picsCapt = 0;
        for(int i=0; i < self.imageArray.count; i++){
            NSDictionary *dictt = [[NSDictionary alloc] init];
            dictt = [self.imageArray objectAtIndex:i];
            int valuee = [[dictt objectForKey:@"InstructNumber"]intValue];
           // numb_of_picsCapt = 0;
            if(value == valuee){
                numb_of_picsCapt ++;
                //return numb_of_picsCapt;
            }else{
                //break;
            }
        }
        valuee =  numb_of_picsCapt;
    }
    NSLog(@"value:%d",valuee);
    deletePosition = btn.tag;
    NSDictionary* myimagedict = [[self.imageArray objectAtIndex:deletePosition]mutableCopy];
    NSLog(@"myimagedict:%@",myimagedict);
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

-(IBAction)deleteLoadd:(id)sender
{
    [self.alertbox hideView];
     LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
    [self.parkLoadArray removeObjectAtIndex:currentLoadNumber];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:self.parkLoadArray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AZCAppDelegate *delegate = AZCAppDelegate.sharedInstance;
        [delegate.window makeToast:NSLocalizedString(@"Images Deleted Successfully",@"")  duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
    });
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeAllObjects];
    LoadSelectionVC.siteData = self.siteData;
    [navigationArray addObject:LoadSelectionVC];
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popToViewController:LoadSelectionVC animated:YES];
}



-(void)deleteLoad:(id)sender
{
    NSDictionary* myimagedict = [[self.imageArray objectAtIndex:deletePosition]mutableCopy];
    NSString* imageName = [myimagedict valueForKey:@"imageName"];
    NSLog(@"myimagedict:%@",myimagedict);
    [myimagedict setValue:@"" forKey:@"brightness"];
    [myimagedict setValue:@"" forKey:@"created_Epoch_Time"];
    [myimagedict setValue:@"" forKey:@"latitude"];
    [myimagedict setValue:@"" forKey:@"load_tookout_type"];
    [myimagedict setValue:@"" forKey:@"longitude"];
    [myimagedict setValue:@"" forKey:@"variance"];
    [myimagedict setValue:@"" forKey:@"imageName"];
    NSLog(@"myimagedict1:%@",myimagedict);
    [self.imageArray replaceObjectAtIndex:deletePosition withObject:myimagedict];
    [_parkLoad setObject:self.imageArray forKey:@"img"];
    [_parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:_parkLoad];
    [[NSUserDefaults standardUserDefaults]setObject:_parkLoadArray forKey:@"ParkLoadArray" ];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self updateCollectionView];
    [_list_CollectionView reloadData];
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
    [self.imageArray replaceObjectAtIndex:cropPosition withObject:self.dictionaries];
    
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
