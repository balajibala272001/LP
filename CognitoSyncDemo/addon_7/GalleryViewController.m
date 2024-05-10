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
<<<<<<< HEAD
=======
    NSString *deviceModel;
    NSArray *colorCodes;
    NSMutableArray *animatedPositions;
    NSString *value;
    NSTimer *timer;
>>>>>>> main
}

@property (nonatomic,strong) NSMutableDictionary *contentOffsetDictionary;
@end

@implementation GalleryViewController
@synthesize pathToImageFolder;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************
<<<<<<< HEAD

- (void)viewDidLoad {
    [super viewDidLoad];

=======
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    colorCodes = [NSArray array];
    colorCodes = @[@"#237EC2", @"#C32120", @"#C3A622", @"#22C259", @"#DB504A", @"#B2339D", @"#A270FF", @"#6D3E3C", @"#188687", @"#F8812E", @"#01AF7E", @"#97677C", @"#C5D602", @"#4B0082", @"#567C6C", @"#AD9396", @"#C57D52", @"#245923", @"#FF4D00", @"#E9539B", @"#A9484D", @"#1B61B4"];
    animatedPositions = [[NSMutableArray alloc]init];
>>>>>>> main
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    tab = [selectedTab alloc];
    tempArr = [[NSMutableArray alloc]init];
    indeValue = 0;
    selected_tab = 0;
    if(_instructData.count == 0){
        NSMutableArray *parkloadarray = [[NSMutableArray alloc] init];
        self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
        self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
        if([self.parkLoad valueForKey:@"instructData"]!=nil){
            _instructData = [self.parkLoad valueForKey:@"instructData"];
        }
    }
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [_instructData objectAtIndex:selected_tab];
    NSString *value = [self htmlEntityDecode:[dictionary objectForKey:@"instruction_name"]];
    
    
    [self updateCollectionView];
<<<<<<< HEAD
    self.step_Label.text = value;
=======
    //self.step_Label.text = value;
    [animatedPositions addObject:@(0).stringValue];
    // Initialize a counter to keep track of the current character index
    __block NSUInteger characterIndex = 0;

    // Set up the timer to update the button's text every interval
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // Check if the character index is less than the length of the button's text
        if (characterIndex < value.length) {
            // Get the substring from the beginning up to the current character index
            NSString *substring = [value substringToIndex:characterIndex + 1];
            
            // Update the button's text with the substring
            self.step_Label.text = [NSString stringWithFormat:@" %@  ", substring];
            
            // Increment the character index
            characterIndex++;
        } else {
            // Stop the timer when all characters have been displayed
            [timer invalidate];
            timer = nil;
        }
    }];
>>>>>>> main

    self.tab_CollectionView.layer.cornerRadius = 10;
    self.tab_CollectionView.layer.borderWidth = 5;
    self.tab_CollectionView.layer.borderColor = [UIColor whiteColor].CGColor;
<<<<<<< HEAD
=======
    
    deviceModel = [UIDevice currentDevice].model;
>>>>>>> main
  
      NSLog(@"_imageArray: %@",_imageArray);
    @try{
        //NSLog(@"wholeDict:%@",_wholeLoadDict);
        self.oldValues = [[NSMutableArray alloc]init];
        //Intializing array and Dictionary
        self.oneImageDict = [[NSMutableDictionary alloc]init];
        self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
        self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
        bool isAddon7Custom = [[self.parkLoad valueForKey:@"isAddon7Custom"]boolValue];
        //Making Corner Radius for sub-view
        self.sub_View.layer.cornerRadius = 10;
        self.sub_View.layer.borderWidth = 1;
        self.sub_View.layer.borderColor = Blue.CGColor;
    }@catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    
    //For back button
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
<<<<<<< HEAD
=======
    back.contentMode = UIViewContentModeScaleAspectFit;
>>>>>>> main
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    
<<<<<<< HEAD
    
=======
    // Remove the right navigation bar button
    self.navigationItem.rightBarButtonItem = nil;
    
    // set corner radius for Next Button
    self.NextBtn.layer.cornerRadius = 10.0;
>>>>>>> main
    //Navigation controller next button
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithCustomView:next ];
    self.navigationItem.rightBarButtonItem = NextButton;
<<<<<<< HEAD
=======
    self.NextBtn.hidden = YES;
>>>>>>> main
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
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

<<<<<<< HEAD

-(void)handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
=======
/*-(void)handleTimer {
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
     CGFloat sw = [UIScreen mainScreen].bounds.size.width;
     //internet_indicator
     UIButton *networkStater;
     NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
     if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
         networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
     }else{
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 130,10,20,20)];
         }else {
             networkStater = [[UIButton alloc] initWithFrame:CGRectMake(sw - 125,10,15,15)];
         }
     }
     networkStater.layer.masksToBounds = YES;
     networkStater.layer.cornerRadius = 10.0;
     //cloud_indicator
     UIButton *cloud_indicator;
     if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
         cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
     }else{
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 100,8,25,25)];
         }else {
             cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(sw - 100,8,20,20)];
         }
     }
     cloud_indicator.layer.masksToBounds = YES;
     cloud_indicator.layer.cornerRadius = 10.0;
     
     UIView *view;
     if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
         view = [[UIView alloc] initWithFrame:CGRectMake(0,0, sw, 40)];
     }else {
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             view = [[UIView alloc] initWithFrame:CGRectMake(0,0, sw, 40)];
         }else {
             view = [[UIView alloc] initWithFrame:CGRectMake(-90,0, sw, 40)];
         }
     }
     
    UILabel* titleLabel;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 180, 40)];
    }else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw/2 - 140, 0, 180, 40)];
        }else {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 180, 40)];
        }
    }
     titleLabel.text = NSLocalizedString(@"Gallery",@"");//392/2 = 196 - 85 = 110
     //titleLabel.minimumFontSize = 18;
     titleLabel.textAlignment = NSTextAlignmentCenter;
     titleLabel.highlighted=YES;
     titleLabel.textColor = [UIColor blackColor];
     [view addSubview:titleLabel];
     view.center = self.view.center;
     
     //parkload button
     UIButton *parkloadIcon;
     if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
         parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(61,8,25,25)];
     }else{
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 165,8,25,25)];
         }else {
             parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(sw - 155,8,20,20)];
         }
     }
     [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
     parkloadIcon.layer.masksToBounds = YES;
     //parkload icon
     [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
     [parkloadIcon setExclusiveTouch:YES];
     [view addSubview:parkloadIcon];
     
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
     }else{
         isOrange = true;
         NSLog(@"Network Connection not available");
         [networkStater
          setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
         networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
             //RGBA ( 248 , 181 , 82 , 80 )
         networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
     }
     networkStater.layer.borderColor = [UIColor colorWithRed: 1.00 green: 1.0 blue: 1.0 alpha: 1.00].CGColor;
     networkStater.layer.borderWidth = 1.0;
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
     if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && self.parkLoadArray.count == 1){
         parkloadIcon.hidden = YES;
     }

}*/
-(void)handleTimer {
    
>>>>>>> main
    //internet_indicator
    UIButton *networkStater;
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(195,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
<<<<<<< HEAD
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Gallery",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 245, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
=======
>>>>>>> main
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
    parkloadIcon.layer.masksToBounds = YES;
<<<<<<< HEAD
=======
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Gallery",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 245, 40)];
    [view addSubview:titleLabel];
    view.center = self.view.center;
    
>>>>>>> main
    //parkload icon
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [view addSubview:parkloadIcon];
<<<<<<< HEAD
=======
    view.center = self.view.center;
>>>>>>> main
    
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
    }else{
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
    if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"] && self.parkLoadArray.count == 1){
        parkloadIcon.hidden = YES;
    }
}

-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Offline, proceed with Parkloads.",@"");
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
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(void) parkload_poper{

     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
     [self.alertbox setHorizontalButtons:YES];
     
     long a = self.parkLoadArray.count;
     if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
        a--;
     }
     NSString *stat = @(a).stringValue;
     NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
     
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox setHideTitle:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
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
        return _instructData.count;
    }else{
        int numb_of_picsCapt = 0;
        self.oldGalleryData =[self.parkLoad valueForKey:@"instructData"];
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
        if(!(numb_of_picsCapt==0)){
            return numb_of_picsCapt;
        }else{
            return 0;
        }
        //return numb_of_picsCapt;
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.list_CollectionView]){

    NSLog(@"q3");
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
<<<<<<< HEAD
        return CGSizeMake(150, 225);
    }
    else if (self.view.frame.size.width == 320)
    {
        return CGSizeMake(75, 112.5);
    }
    else{
        return CGSizeMake(100, 150);
    }
    
=======
        return CGSizeMake(150,225);
    }
    else if (self.view.frame.size.width == 320)
    {
        return CGSizeMake(75,112.5);
    }
    else{
        return CGSizeMake(100,150);
       }
>>>>>>> main
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
    }else{
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];

        int grossCellwidth = 0 , totalCellwidth = 0;
        totalCellwidth = 40 * self.instructData.count; //50->cellWidth
        grossCellwidth = totalCellwidth + 20;
        int widthDiff = (self.tab_CollectionView.frame.size.width - grossCellwidth);
        if(widthDiff <= 0){
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                return UIEdgeInsetsMake(0,0 , 0, widthDiff/2);
            }else{
                return UIEdgeInsetsMake(0,widthDiff/2 , 0, 0);
            }
        }
          //      return UIEdgeInsetsMake(0, 80 , 0, 0);

    }
     // top, left, bottom, right
}

-(void)viewDidAppear:(BOOL)animated {
    [self.list_CollectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    @autoreleasepool {
        delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        delegateVC.CurrentVC = @"PicviewVC";
        [[NSUserDefaults standardUserDefaults] setValue:@"PicViewVC" forKey:@"CurrentVC"];
        self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
        self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
        [super viewWillAppear:animated];
        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
        bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
        //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
        //}
        [self updateCollectionView];
        [self.list_CollectionView reloadData];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
<<<<<<< HEAD
=======
        
        //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:214/255.0 alpha:1.0];
>>>>>>> main
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isEqual:self.list_CollectionView]){
        int InctNumb = 0;
        bool error = false;
        int newIndex = -1;
        
        //TempArr_to_displayImages
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
        instructDataArr =[self.parkLoad valueForKey:@"instructData"];
        NSDictionary *ddict = [[NSDictionary alloc] init];
        ddict = [instructDataArr objectAtIndex:selected_tab];
        int value = [[ddict objectForKey:@"instruction_number"]intValue];
        for(int j=0; j < self.imageArray.count; j++){
            NSDictionary *ddictt = [[NSDictionary alloc] init];
            ddictt = [self.imageArray objectAtIndex:j];
            int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
            if(value == valuee){
                [arr addObject:ddictt];
            }
        }
        for(int j=0; j < arr.count; j++){
            NSDictionary *dicto = [[NSDictionary alloc] init];
            dicto = [arr objectAtIndex:j];
            if([[dicto valueForKey: @"imageName"] isEqual: @""]){
                newIndex = j;
            }
        }
        
        //IndexFromMainArr
        NSMutableDictionary*dicto;
        int index = 0;
        for(int i=0; i<self.imageArray.count; i++){
            dicto = [[self.imageArray objectAtIndex:i]mutableCopy];
            if([[dicto valueForKey: @"imageName"] isEqual: @""]){
                error = true;
                InctNumb = [[dicto objectForKey:@"InstructNumber"]intValue];
                index = i;
                NSLog(@"index:%d",index);
                break;
            }
        }
        if(error == true && indexPath.row == newIndex){
            NSLog(@"single tap - takePhoto");
            tab.selectedTab = selected_tab;
            tab.errorIndex = newIndex;
            tab.indexPath = index;
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
            NSLog(@"Single Tap - Notes");
            NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
            
            //TempArr_to_displayImages
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
            instructDataArr =[self.parkLoad valueForKey:@"instructData"];
            NSDictionary *ddict = [[NSDictionary alloc] init];
            ddict = [instructDataArr objectAtIndex:selected_tab];
            int value = [[ddict objectForKey:@"instruction_number"]intValue];
            for(int j=0; j < self.imageArray.count; j++){
                NSDictionary *ddictt = [[NSDictionary alloc] init];
                ddictt = [self.imageArray objectAtIndex:j];
                int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
                if(value == valuee){
                    [arr addObject:ddictt];
                }
            }
            NSDictionary* dict = [arr objectAtIndex:indexPath.row];
            
            //RemovingfromMainArray
            int index = 0;
            long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
            int instr_numb =[[dict objectForKey:@"InstructNumber"]intValue];
            NSMutableDictionary*dicti;
            for(int i=0; i<self.imageArray.count; i++){
                dicti = [[self.imageArray objectAtIndex:i]mutableCopy];
                long imageArray_time = [[dicti objectForKey:@"created_Epoch_Time"]intValue];
                int instr_numb_dict =[[dicti objectForKey:@"InstructNumber"]intValue];

                if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
                    index = i;
                    NSLog(@"index:%d",index);
                    break;
                }
            }
            NotesVC.dictionaries = dicti;
            NotesVC.indexPathRow = index;
            NotesVC.delegate = self;
            [self.navigationController pushViewController:NotesVC animated:YES];
        }
    }else{
       
        NSDictionary *dictionary = [[NSDictionary alloc] init];
        dictionary = [_instructData objectAtIndex:indexPath.row];
<<<<<<< HEAD
        NSString *value = [self htmlEntityDecode:[dictionary objectForKey:@"instruction_name"]];
        self.step_Label.text = value;
=======
        value = [self htmlEntityDecode:[dictionary objectForKey:@"instruction_name"]];
        self.step_Label.text = @"";
        if (![animatedPositions containsObject:@(indexPath.row).stringValue]) {
            [animatedPositions addObject:@(indexPath.row).stringValue];
            // Create a dispatch queue to animate the label's text
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                // Iterate through each character of the text
//                for (NSUInteger i = 0; i < self->value.length; i++) {
//                    // Get the current substring up to the ith character
//                    NSString *substring = [value substringToIndex:i + 1];
//                    
//                    // Update the label's text on the main thread
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.step_Label.text = substring;
//                    });
//                    
//                    // Pause for a short duration to create the typing effect
//                    [NSThread sleepForTimeInterval:0.1];
//                }
//            });
            
            if(timer != nil){
                [timer invalidate];
                timer = nil;
            }
            __block NSUInteger characterIndex = 0;

            // Set up the timer to update the button's text every interval
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                // Check if the character index is less than the length of the button's text
                if (characterIndex < self->value.length) {
                    // Get the substring from the beginning up to the current character index
                    NSString *substring = [self->value substringToIndex:characterIndex + 1];
                    
                    // Update the button's text with the substring
                    self.step_Label.text = [NSString stringWithFormat:@" %@  ", substring];
                    
                    // Increment the character index
                    characterIndex++;
                } else {
                    // Stop the timer when all characters have been displayed
                    [timer invalidate];
                    timer = nil;
                }
            }];
        }else {
            self.step_Label.text = value;
        }
        
        int pos = indexPath.row % 22;
        NSString *colorCode = [colorCodes objectAtIndex:pos];
        UIColor *color = [self colorFromHexString:colorCode];
        self.step_Label.backgroundColor = color;
        
      //  self.step_Label.backgroundColor = [UIColor whiteColor];
        
        /*[UIView animateWithDuration:1.0 animations:^{
            // Generate random RGB values for the new background color
            CGFloat red = (CGFloat)arc4random_uniform(256) / 255.0; // Random value between 0 and 255
            CGFloat green = (CGFloat)arc4random_uniform(256) / 255.0; // Random value between 0 and 255
            CGFloat blue = (CGFloat)arc4random_uniform(256) / 255.0; // Random value between 0 and 255
            
            // Set the new background color with random RGB values
            self.step_Label.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        } completion:^(BOOL finished) {
        }]; */
        
>>>>>>> main
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

<<<<<<< HEAD
=======
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // skip the #
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0
                           alpha:1.0];
}
>>>>>>> main

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
<<<<<<< HEAD
}



=======
    
    int pos = 0;
    NSString *colorCode = [colorCodes objectAtIndex:pos];
    UIColor *color = [self colorFromHexString:colorCode];
    self.step_Label.backgroundColor = color;
    
}


>>>>>>> main
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([collectionView isEqual:self.list_CollectionView]){

        GalleryCollectionViewCell *Cell1 ;
        Cell1= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        //image
        NSDictionary *dictionary = [[NSDictionary alloc] init];
        dictionary = [_instructData objectAtIndex:selected_tab];
        //int position = 0;
        //int numb_of_picsCapt = 0;
        NSLog(@"selected_tab:%d",selected_tab);
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
        instructDataArr =[self.parkLoad valueForKey:@"instructData"];
        NSDictionary *ddict = [[NSDictionary alloc] init];
        ddict = [instructDataArr objectAtIndex:selected_tab];
        int value = [[ddict objectForKey:@"instruction_number"]intValue];
        for(int j=0; j < self.imageArray.count; j++){
            NSDictionary *ddictt = [[NSDictionary alloc] init];
            ddictt = [self.imageArray objectAtIndex:j];
            int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
            if(value == valuee){
                [arr addObject:ddictt];
            }
        }
        NSMutableDictionary *dict = [[arr objectAtIndex:indexPath.row] mutableCopy];
        NSString* imageName = [dict valueForKey:@"imageName"];
        [Cell1.Takephoto setTitle:NSLocalizedString(@"Take Photo",@"") forState:UIControlStateNormal];
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
            [Cell1.preview_but setHidden:YES];
            
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
            [Cell1.preview_but setHidden:NO];

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
                    Cell1.imageView.image =[UIImage imageNamed:@"missing_img.png"];
                }
                [Cell1.videoicon setHidden:NO];
                //[Cell1.crop_but setHidden:YES];
                [Cell1.blur_img setHidden:YES];
                [Cell1.low_light setHidden:YES];
                [Cell1.Takephoto setHidden:YES];

            }else{
<<<<<<< HEAD
=======
                Cell1.imageView.backgroundColor = [UIColor grayColor]; // Set the background color of the container view
>>>>>>> main
                Cell1.imageView.contentMode = UIViewContentModeScaleAspectFit;
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
                bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
                NSLog(@"boolToRestrict:%d",boolToRestrict);
                
                //lowlight
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
                [Cell1.preview_but setHidden:NO];
                [Cell1.Takephoto setHidden:YES];
                NSData *imageData;
                NSLog(@"Image Quality (upload):%@",self.siteData.image_quality);
                if([self.siteData.image_quality isEqual:@"1"]) {
                    imageData = UIImageJPEGRepresentation(image, 0.93);
                }else if([self.siteData.image_quality isEqual:@"2"]) {
                    imageData = UIImageJPEGRepresentation(image, 0.85);
                }else if([self.siteData.image_quality isEqual:@"3"]){
                    imageData = UIImageJPEGRepresentation(image, 0.9942);
                }else if([self.siteData.image_quality isEqual:@"4"]){
                    imageData = UIImageJPEGRepresentation(image, 0.1);
                }
                UIImage *scaled;
//                if([self.siteData.image_quality isEqual:@"4"]){
//                    scaled =image;
//                }else{
                    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
                    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                        (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                        (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                        (id) kCGImageSourceThumbnailMaxPixelSize : @(300)
                    };
                    
                    CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
                    scaled = [UIImage imageWithCGImage:scaledImageRef];
                    CGImageRelease(scaledImageRef);
//                }
                Cell1.imageView.image =scaled;
<<<<<<< HEAD
=======
                if([deviceModel isEqual:@"iPad"]){
                    // Activate width and height constraints with 2:1 aspect ratio
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
                NSLog(@"Updated : W %f H %f",image.size.width,image.size.height);
                [Cell1.videoicon setHidden:YES];
            }
            NSString *text = [dict objectForKey:@"string"];
            NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
            Cell1.number_lbl.text = the_index_path;
<<<<<<< HEAD
=======
            // Number_lbl
            Cell1.number_lbl.layer.cornerRadius = Cell1.number_lbl.frame.size.width / 2.0;
            Cell1.number_lbl.clipsToBounds = YES;
            
            // Check if the image is available for the current indexPath
            if (indexPath.row < self.imageArray.count) {
                // Set the background color of the watermark label to white
                Cell1.number_lbl.backgroundColor = [UIColor whiteColor];
            } else if (indexPath.row >= self.imageArray.count && indexPath.row < self.imageArray.count) {
                // Set the background color of the watermark label to clear if the image has been deleted
                Cell1.number_lbl.backgroundColor = [UIColor clearColor];
            } else {
                // Hide the watermark label or set its background color to clear if no image is available
                Cell1.number_lbl.backgroundColor = [UIColor clearColor];
            }

            
>>>>>>> main
            Cell1.notesImageView.image =[UIImage imageNamed:@"notesicon.png"];
            if (text.length == 0) {
                [Cell1.notesImageView setHidden:YES];
            }
            else{
                [Cell1.notesImageView setHidden:NO];
            }
            
            NSLog(@"q8");
            [Cell1.delete_btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.delete_btn setTag:indexPath.row];
            [Cell1.preview_but addTarget:self action:@selector(PreviewAction:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.preview_but setTag:indexPath.row];
            [Cell1.crop_but addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
            [Cell1.crop_but setTag:indexPath.row];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [Cell1 addGestureRecognizer:longPress];
            
            return Cell1;
        }
    }else{
        TabCollectionViewCell *Cell2 ;
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        Cell2= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        NSString * str= [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        Cell2.Lab_title.text = str;
<<<<<<< HEAD
        Cell2.layer.cornerRadius = 20;
=======
        Cell2.layer.cornerRadius = 6;
>>>>>>> main
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


<<<<<<< HEAD
-(void)next:(id)sender
=======
-(IBAction)next:(id)sender
>>>>>>> main
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
                [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
                [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"")subTitle:NSLocalizedString(@"Kindly capture the missing photo to move next.",@"") closeButtonTitle:nil duration:1.0f ];
            }else{
                self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
                bool isAddon7Custom = [[self.parkLoad valueForKey:@"isAddon7Custom"]boolValue];
                if(isAddon7Custom){
                    
                    ProjectDetailsViewController *Project = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
                    [self.navigationController pushViewController:Project animated:YES];
                    
                    Project.siteData = self.siteData;
                    Project.arrayOfImagesWithNotes = self.imageArray;
                    //NSLog(@"imageArraycat:%@",self.arrayOfImagesWithNotes);
                    Project.sitename = self.sitename;
                    Project.sitename = self.sitename;
                    Project.image_quality = self.siteData.image_quality;
                    Project.isEdit = self.isEdit;
                    Project.delegate = self;
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
            }
    }else{
        [self.view makeToast:NSLocalizedString(@"Take Atleast 1 Media file ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
}


-(void)notesData:(NSInteger *)indexPathRow changedData:(NSMutableDictionary *)dic{
    
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


- (void)back_button:(id)sender{
    
    NSDictionary*dict;
    NSMutableArray *checkArr = [self.parkLoad objectForKey:@"img"];
    if(checkArr != nil && checkArr.count>0){
        for(int i=0; i<checkArr.count; i++){
            dict = [checkArr objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                break;
            }
        }
        if([[dict valueForKey: @"imageName"] isEqual: @""]){
            [self.view makeToast:NSLocalizedString(@"Capture deleted image to proceed",@"") duration:2.0 position:CSToastPositionCenter];
            return;
        }
    }
    bool isAddon7Custom = [[self.parkLoad objectForKey:@"isAddon7Custom"]boolValue];
    //NSArray * arr = [self.parkLoad objectForKey:@"img"];
    self.IsiteId = delegateVC.userProfiels.instruct.sitee_Id;
    if(isAddon7Custom){
        self.parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        currentLoadNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLoadNumber"] intValue];
        self.parkLoad = [[self.parkLoadArray objectAtIndex:currentLoadNumber] mutableCopy];
        
        if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoadd:) backgroundColor:Red];
            [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
        }else{
            NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
            NSString *ifCatAvailable = @"";
            for(int i = 0; i<array.count;i++){
                NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                if([array[i] isKindOfClass:CaptureScreenViewController.class]) {
                    [self.navigationController popToViewController:array[i] animated:true];
                    ifCatAvailable = @"Yes";
                    break;
                }
            }
            if([ifCatAvailable isEqualToString:@"Yes"]){
               // [self.navigationController popViewControllerAnimated:YES];
            }else{
                CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                CaptureVC.siteData = self.siteData;
                CaptureVC.siteName = self.sitename;
                delegateVC.ImageTapcount = 0;
                delegateVC.isNoEdit = YES;
                [self.navigationController pushViewController:CaptureVC animated:YES];
            }
        }
    }else if(delegateVC.userProfiels.instruct.instructData != nil && delegateVC.userProfiels.instruct.instructData.count >0 && self.IsiteId == self.siteData.siteId) {
        if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoadd:) backgroundColor:Red];
            [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
        }else{
            NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
            NSString *ifCatAvailable = @"";
            for(int i = 0; i<array.count;i++){
                NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                if([array[i] isKindOfClass:CaptureScreenViewController.class]) {
                    [self.navigationController popToViewController:array[i] animated:true];

                    ifCatAvailable = @"Yes";
                    break;
                }
            }
            if([ifCatAvailable isEqualToString:@"Yes"]){
                //[self.navigationController popViewControllerAnimated:YES];
            }else{
                CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                CaptureVC.siteData = self.siteData;
                CaptureVC.siteName = self.sitename;
                delegateVC.ImageTapcount = 0;
                delegateVC.isNoEdit = YES;
                [self.navigationController pushViewController:CaptureVC animated:YES];
            }
        }
    }else{
        if(![[self.parkLoad objectForKey:@"isParked"] isEqual:@"1"]){
            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
            [self.alertbox setHorizontalButtons:YES];
            [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
            [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(deleteLoadd:) backgroundColor:Red];
            [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"Clicking back button will delete all pictures in this Load. Continue?",@"") closeButtonTitle:nil duration:1.0f ];
        }else{
            CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
            CaptureVC.siteData = self.siteData;
            CaptureVC.siteName = self.sitename;
            delegateVC.ImageTapcount = 0;
            delegateVC.isNoEdit = YES;
            [self.navigationController pushViewController:CaptureVC animated:YES];        }
    }
}


-(IBAction)BlurImgClickAction:(id)sender{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Blur image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)LowlightClickAction:(id)sender{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(dummy:) backgroundColor: Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"Low light image",@"") closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)PreviewAction:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger indexPath = btn.tag;
    
    //temp_ARR
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
    instructDataArr =[self.parkLoad valueForKey:@"instructData"];
    NSDictionary *ddict = [[NSDictionary alloc] init];
    ddict = [instructDataArr objectAtIndex:selected_tab];
    int value = [[ddict objectForKey:@"instruction_number"]intValue];
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *ddictt = [[NSDictionary alloc] init];
        ddictt = [self.imageArray objectAtIndex:j];
        int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
        if(value == valuee){
            [arr addObject:ddictt];
        }
    }
    NSMutableDictionary *dict = [[arr objectAtIndex:indexPath] mutableCopy];
    if([[dict valueForKey: @"imageName"] isEqualToString:@""]){
        NSLog(@"i:%ld",(long)indexPath);
        NSLog(@"Long Pressed");
    }else{
        pageViewController *pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
        
        //RemovingfromMainArray
        int index = 0;
        long arr_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
        int instr_numb =[[dict objectForKey:@"InstructNumber"]intValue];

        for(int i=0; i<self.imageArray.count; i++){
            NSDictionary*dicto = [self.imageArray objectAtIndex:i];
            long imageArray_time = [[dicto objectForKey:@"created_Epoch_Time"]intValue];
            int instr_numb_dict =[[dicto objectForKey:@"InstructNumber"]intValue];

            if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
                index = i;
                NSLog(@"index:%d",index);
                break;
            }
        }
        pageVC.array = self.imageArray;
        pageVC.indexPath = index;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
    //return;
}


- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    CGPoint p = [gesture locationInView:self.list_CollectionView];
    NSIndexPath *indexPath = [self.list_CollectionView indexPathForItemAtPoint:p];
    @try{
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
                    self.oldGalleryData = self.instructData;
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
//                NSMutableDictionary *dict = [[self.imageArray objectAtIndex:position+indexPath.row] mutableCopy];
                pageVC.array = self.imageArray;
                pageVC.indexPath = position + indexPath.row;
                //  NSURL *vedioURL = [NSURL fileURLWithPath:path];
                [self.navigationController pushViewController:pageVC animated:YES];
                UICollectionViewCell *cellLongPressed = (UICollectionViewCell *) gesture.view;
            }
        }
    }@catch(NSException *exp){
        NSLog(@"aaa");
    }
}

-(IBAction)delete:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    deletePosition = btn.tag;
    bool error = false;
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
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:NSLocalizedString(@"You are not allowed to delete photo. Unless you capture missing photo.",@"") closeButtonTitle:nil duration:1.0f ];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
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



-(void)deleteLoad:(id)sender{
    
    //TempArr_to_displayImages
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
    instructDataArr =[self.parkLoad valueForKey:@"instructData"];
    NSDictionary *ddict = [[NSDictionary alloc] init];
    ddict = [instructDataArr objectAtIndex:selected_tab];
    int value = [[ddict objectForKey:@"instruction_number"]intValue];
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *ddictt = [[NSDictionary alloc] init];
        ddictt = [self.imageArray objectAtIndex:j];
        int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
        if(value == valuee){
            [arr addObject:ddictt];
        }
    }
    NSMutableDictionary *myimagedict = [[NSMutableDictionary alloc]init];
    myimagedict = [[arr objectAtIndex:deletePosition]mutableCopy];
    NSLog(@"myimagedict:%@",myimagedict);
    [myimagedict setValue:@"" forKey:@"brightness"];
    //[myimagedict setValue:@"" forKey:@"created_Epoch_Time"];
    [myimagedict setValue:@"" forKey:@"latitude"];
    [myimagedict setValue:@"" forKey:@"load_tookout_type"];
    [myimagedict setValue:@"" forKey:@"longitude"];
    [myimagedict setValue:@"" forKey:@"variance"];
    [myimagedict setValue:@"" forKey:@"imageName"];
    NSLog(@"myimagedict1:%@",myimagedict);
    
    //RemovingfromMainArray
    int index = 0;
    long arr_time = [[myimagedict objectForKey:@"created_Epoch_Time"]intValue];
    int instr_numb =[[myimagedict objectForKey:@"InstructNumber"]intValue];

    for(int i=0; i<self.imageArray.count; i++){
        NSDictionary*dict = [self.imageArray objectAtIndex:i];
        long imageArray_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
        int instr_numb_dict =[[dict objectForKey:@"InstructNumber"]intValue];

        if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }

    [arr replaceObjectAtIndex:deletePosition withObject:myimagedict];
    [self.imageArray replaceObjectAtIndex:index withObject:myimagedict];
    [_parkLoad setObject:self.imageArray forKey:@"img"];
    [_parkLoadArray replaceObjectAtIndex:currentLoadNumber withObject:_parkLoad];
    [[NSUserDefaults standardUserDefaults]setObject:_parkLoadArray forKey:@"ParkLoadArray" ];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self updateCollectionView];
    [_list_CollectionView reloadData];
}


- (IBAction)crop:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    cropPosition = btn.tag;
    
    //TempArr_to_displayImages
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
    instructDataArr =[self.parkLoad valueForKey:@"instructData"];
    NSDictionary *ddict = [[NSDictionary alloc] init];
    ddict = [instructDataArr objectAtIndex:selected_tab];
    int value = [[ddict objectForKey:@"instruction_number"]intValue];
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *ddictt = [[NSDictionary alloc] init];
        ddictt = [self.imageArray objectAtIndex:j];
        int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
        if(value == valuee){
            [arr addObject:ddictt];
        }
    }
    NSMutableDictionary *dic=[arr objectAtIndex:cropPosition];
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
    CGRect cropArea = controller.cropArea;
    //REducing the cropped image size
    CGSize imageSize;
    NSLog(@"Image Quality :%@",self.siteData.image_quality);
<<<<<<< HEAD
    if ([self.siteData.image_quality isEqual:@"1"]) {
        imageSize = CGSizeMake(720,1080);
    }else{
        imageSize = CGSizeMake(1440,2160);
    }
=======
//    if ([self.siteData.image_quality isEqual:@"1"]) {
//        imageSize = CGSizeMake(720,1080);
//    }else{
//        imageSize = CGSizeMake(1440,2160);
//    }
    imageSize = CGSizeMake(image.size.width,image.size.height);
>>>>>>> main
    
    //TempArr_to_displayImages
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *instructDataArr = [[NSMutableArray alloc]init];
    instructDataArr =[self.parkLoad valueForKey:@"instructData"];
    NSDictionary *ddict = [[NSDictionary alloc] init];
    ddict = [instructDataArr objectAtIndex:selected_tab];
    int value = [[ddict objectForKey:@"instruction_number"]intValue];
    for(int j=0; j < self.imageArray.count; j++){
        NSDictionary *ddictt = [[NSDictionary alloc] init];
        ddictt = [self.imageArray objectAtIndex:j];
        int valuee = [[ddictt objectForKey:@"InstructNumber"]intValue];
        if(value == valuee){
            [arr addObject:ddictt];
        }
    }
    self.dictionaries= [[arr objectAtIndex:cropPosition] mutableCopy];

   
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
    [arr replaceObjectAtIndex:cropPosition withObject:self.dictionaries];

    
    //RemovingfromMainArray
    int index = 0;
    long arr_time = [[self.dictionaries objectForKey:@"created_Epoch_Time"]intValue];
    int instr_numb =[[self.dictionaries objectForKey:@"InstructNumber"]intValue];

    for(int i=0; i<self.imageArray.count; i++){
        NSDictionary*dict = [self.imageArray objectAtIndex:i];
        long imageArray_time = [[dict objectForKey:@"created_Epoch_Time"]intValue];
        int instr_numb_dict =[[dict objectForKey:@"InstructNumber"]intValue];

        if(arr_time == imageArray_time && instr_numb == instr_numb_dict){
            index = i;
            NSLog(@"index:%d",index);
            break;
        }
    }

    //[arr replaceObjectAtIndex:deletePosition withObject:myimagedict];
    [self.imageArray replaceObjectAtIndex:index withObject:self.dictionaries];
    
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

-(NSString *)htmlEntityDecode:(NSString *)string
    {
        string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"

        return string;
}

<<<<<<< HEAD
- (void)TakePhoto:(nonnull id)sender __attribute__((ibaction)) {
}

=======
>>>>>>> main
@end
