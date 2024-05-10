//
//  CategoryViewController.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 23/03/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//
#import "User.h"
#import "ServerUtility.h"
#import "Add_on.h"
#import "Constants.h"
#import "Reachability.h"
#import "SCLAlertView.h"
#import "AZCAppDelegate.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"
#import "ProjectDetailsViewController.h"
#import "CategoryData.h"
#import "PicViewController.h"
#import "GalleryLoopViewController.h"
#import "CaptureScreenViewController.h"
#import "UIView+Toast.h"
#import "LoadSelectionViewController.h"

@interface CategoryViewController ()<UIPopoverControllerDelegate>
{
    NSInteger index;
    CategoryTableViewCell *cell;
    UIImageView *img;
    bool hasCustomCategory;
    UIImageView *imageView;
    AZCAppDelegate *delegateVC;
    bool hasAddon8;
    UIButton *btn;
    int currentPosi;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    currentPosi=0;
    //Checking_add0n8
    hasAddon8 = FALSE;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            hasAddon8 = TRUE;
        }
    }

    self.subview.layer.cornerRadius = 10;
    self.subview.layer.borderWidth = 1;
    self.subview.layer.borderColor = Blue.CGColor;
    
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
<<<<<<< HEAD
=======
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
>>>>>>> main
    [self handleTimer];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table_view reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"CategoryVC";
    [_table_view reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


-(void)handleTimer {
    
    //internet_indicator
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    UIButton *networkStater;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
    parkloadIcon.layer.masksToBounds = YES;
    
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(195,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Category",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 245, 40)];
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
    //parkload icon
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
    
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    if(![[parkload objectForKey:@"isParked"] isEqual:@"1"] && parkloadarray.count == 1){
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

-(void) parkload_poper{

     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
     [self.alertbox setHorizontalButtons:YES];
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
    long a = parkloadarray.count;
    if(![[parkload objectForKey:@"isParked"] isEqual:@"1"]){
        a--;
    }
     NSString *stat = @(a).stringValue;
     NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
     
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox setHideTitle:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
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
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    hasCustomCategory=false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * add_on = [self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    return hasCustomCategory?self.siteData.customCategory.count:5;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cat";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //tableView.rowHeight=cell.frame.size.height;
    int x,y,width,height;
    
    x= 10;
    width = self.table_view.frame.size.width-(2*x);
    y = 10;
    height =  self.table_view.frame.size.height/5-(2*y);
    
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
   

    
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y,width,110)];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake( btn.frame.size.width - 70, (btn.frame.size.height - 40)/2, 50,40 )];
    [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
    //[imageView setTag:500];
    if (indexPath.row  % 5 == 0) {
        btn.backgroundColor = Orange;
    }else if(indexPath.row % 5 == 1) {
        btn.backgroundColor = Lavender;
    }else if(indexPath.row % 5 == 2) {
        btn.backgroundColor = Gold;
    }else if(indexPath.row % 5 == 3) {
        btn.backgroundColor = Purple;
    }else if(indexPath.row % 5 == 4) {
        btn.backgroundColor = paleBlue;
            //[UIColor colorWithRed: 0.29 green: 0.64 blue: 0.66 alpha: 1.00];
    }
    NSString *str= [parkload objectForKey:@"category"];
    if (!hasCustomCategory) {
        
        AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        int userACustomer = delegate.userProfiels.userACustomer;
        self.StaticCategory=@[@"Load",@"Quality Issue",@"Gemba Walk",@"Miscellaneous",@"Safety Incident"];
        NSString *category=[self.StaticCategory objectAtIndex:indexPath.row];
        if (userACustomer==1 && indexPath.row>1) {
            [btn setEnabled:false];
            [btn setBackgroundColor:[UIColor lightGrayColor]];
        }
        [btn setTitle:category forState:UIControlStateNormal];

        if ([str isEqual:category]) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }else{
        CategoryData *category= self.siteData.customCategory[indexPath.row] ;
        NSString *str1=category.categoryName;
        [btn setTitle:  str1 forState:UIControlStateNormal];
        if ([str isEqual:str1]) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }

    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:indexPath.row];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 1;
    [btn.layer setShadowOffset:CGSizeMake(5, 5)];
    [btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [btn.layer setShadowOpacity:0.5];
    btn.layer.shadowRadius = 10;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    index = indexPath.row;
    btn.tag = indexPath.row;
    NSLog(@"Index:%ld",(long)indexPath.row);
    [btn addSubview: imageView];
    [cell addSubview:btn];
    
    return cell;
}

-(void)btnPressed:(UIButton*)sender
{
    @try{
        UIButton *btn = (UIButton *)sender;
        //NSInteger newindex = btn.tag;
        currentPosi = btn.tag;
        
        NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
        NSString *category=[parkload objectForKey:@"category"];
        bool isAddon7Custom = [[parkload objectForKey:@"isAddon7Custom"]boolValue];
        NSLog(@"parkload%@",parkload);
        
        if(isAddon7Custom){
            CategoryData *cat= self.siteData.customCategory[btn.tag];
            NSString *catName = cat.categoryName;
            int catId = cat.categoryId;
            NSMutableArray *categoryInstData = cat.customInstructData;
            
            if((category.length>0 && ![category isEqual: sender.currentTitle])){
                
                self.str = btn.currentTitle;
                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                [self.alertbox setHorizontalButtons:YES];
                [self.alertbox addButton:NSLocalizedString(@"NO",@"")target:self selector:@selector(dummy:) backgroundColor:Blue];
                [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(remove_custom:) backgroundColor:Red];
                [self.alertbox showSuccess:NSLocalizedString(@"Configuration change", @"") subTitle:NSLocalizedString(@"Changing category will clear the metadata values & media files in this load. Continue",@"") closeButtonTitle:nil duration:1.0f ];
            }else{
                if(categoryInstData != nil && categoryInstData.count >0){
                    [parkload setValue:categoryInstData forKey:@"instructData"];
                    [[NSUserDefaults standardUserDefaults] setInteger: catId forKey:@"ProfileId"];
                    [parkload setObject:[NSString stringWithFormat:@"%d",catId] forKey:@"catID"];
                    [parkload setValue:catName forKey:@"category"];
                    [parkload setValue:@"true" forKey:@"isAddon7CustomGpcc"];
                }else{
                    [parkload setValue:nil forKey:@"instructData"];
                    [parkload setObject:[NSString stringWithFormat:@"%d",catId] forKey:@"catID"];
                    [parkload setValue:catName forKey:@"category"];
                    [parkload setValue:@"false" forKey:@"isAddon7CustomGpcc"];
                }
                
                self.str = btn.currentTitle;
                [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
                [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"parkloadarray:%@",parkloadarray);
                //clear saved doc type before open camera
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeId"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if(categoryInstData != nil && categoryInstData.count >0){
                    CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
                    CaptureVC.siteData = self.siteData;
                    CaptureVC.siteName = self.sitename;
                    delegateVC.ImageTapcount = 0;
                    delegateVC.isNoEdit = YES;
                    [self.navigationController pushViewController:CaptureVC animated:YES];
                }else{
                    CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
                    CameraVC.siteData = self.siteData;
                    CameraVC.siteName = self.sitename;
                    delegateVC.ImageTapcount = 0;
                    delegateVC.isNoEdit = YES;
                    [self.navigationController pushViewController:CameraVC animated:YES];
                }
            }
        }else{
            if(category!=nil){
                if(hasCustomCategory && !(category.length>0 && [category isEqual: sender.currentTitle]))    {
                    self.str = btn.currentTitle;
                    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                    [self.alertbox setHorizontalButtons:YES];
                    [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
                    [self.alertbox addButton:NSLocalizedString(@"YES",@"") target:self selector:@selector(remove:) backgroundColor:Red];
                    [self.alertbox showSuccess:NSLocalizedString(@"Warning!", @"") subTitle:NSLocalizedString(@"If Category is changed Metadata's will be Erased",@"") closeButtonTitle:nil duration:1.0f ];
                    
                }else{
                    
                    self.str = btn.currentTitle;
                    [parkload setObject:self.str forKey:@"category"];
                    [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
                    [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"parkloadarray:%@",parkloadarray);
                    
                    ProjectDetailsViewController *Project = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
                    [self.navigationController pushViewController:Project animated:YES];
                    
                    Project.siteData = self.siteData;
                    Project.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes;
                    NSLog(@"imageArraycat:%@",self.arrayOfImagesWithNotes);
                    Project.sitename = self.sitename;
                    Project.sitename = self.sitename;
                    Project.image_quality = self.siteData.image_quality;
                    Project.isEdit = self.isEdit;
                    Project.delegate = self;
                }
            }else{
                
                self.str = sender.currentTitle;
                [parkload setObject:self.str forKey:@"category"];
                [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
                [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"HELLOO:%ld",sender.tag);
                NSLog(@"parkloadarray:%@",parkloadarray);
                
                ProjectDetailsViewController *Project = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
                [self.navigationController pushViewController:Project animated:YES];
                
                Project.siteData = self.siteData;
                Project.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes;
                Project.sitename = self.sitename;
                Project.image_quality = self.siteData.image_quality;
                Project.isEdit = self.isEdit;
                Project.delegate = self;
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

-(void)remove_custom:(id)sender
{
    //UIButton *btn = (UIButton *)sender;
    CategoryData *category= self.siteData.customCategory[currentPosi];
    NSString *catName = category.categoryName;
    int catId = category.categoryId;
    NSMutableArray *categoryInstData = category.customInstructData;
    
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
    
    //NSString *category=[parkload objectForKey:@"category"];
    bool isAddon7Custom = [[parkload objectForKey:@"isAddon7Custom"]boolValue];
    NSLog(@"parkload%@",parkload);
    bool isAddon7CustomGpcc = [[parkload objectForKey:@"isAddon7CustomGpcc"]boolValue];
    
    if(isAddon7Custom){
        
        NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
        
        [parkload removeObjectForKey:@"fields"];
        [parkload removeObjectForKey:@"img"];
        //self.str = sender.currentTitle;
        
        [parkload setObject:catName forKey:@"category"];
        [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //NSLog(@"HELLOO:%ld",sender.tag);
        NSLog(@"parkloadarray:%@",parkloadarray);
       
        if(categoryInstData != nil && categoryInstData.count >0){
            [parkload setValue:categoryInstData forKey:@"instructData"];
            [parkload setObject:[NSString stringWithFormat:@"%d",catId] forKey:@"catID"];
            [parkload setValue:catName forKey:@"category"];
            [parkload setValue:@"true" forKey:@"isAddon7CustomGpcc"];
        }else{
            [parkload setValue:nil forKey:@"instructData"];
            [parkload setObject:[NSString stringWithFormat:@"%d",catId] forKey:@"catID"];
            [parkload setValue:catName forKey:@"category"];
            [parkload setValue:@"false" forKey:@"isAddon7CustomGpcc"];
        }
        
       // self.str = btn.currentTitle;
        [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"parkloadarray:%@",parkloadarray);
        //clear saved doc type before open camera
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeId"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedDocTypeName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(categoryInstData != nil && categoryInstData.count >0){
            CaptureScreenViewController *CaptureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture_View_Controller"];
            CaptureVC.siteData = self.siteData;
            CaptureVC.siteName = self.sitename;
            delegateVC.ImageTapcount = 0;
            delegateVC.isNoEdit = YES;
            [self.navigationController pushViewController:CaptureVC animated:YES];
            
        }else{
            CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
            CameraVC.siteData = self.siteData;
            CameraVC.siteName = self.sitename;
            delegateVC.ImageTapcount = 0;
            delegateVC.isNoEdit = YES;
            [self.navigationController pushViewController:CameraVC animated:YES];
        }
    }
}

-(void)remove:(id)sender
{
        NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
        if(hasAddon8 && !hasCustomCategory){
            [parkload removeObjectForKey:@"basefields"];
        }else{
            [parkload removeObjectForKey:@"fields"];
        }
        //self.str = sender.currentTitle;
        
        [parkload setObject:self.str forKey:@"category"];
        [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //NSLog(@"HELLOO:%ld",sender.tag);
        NSLog(@"parkloadarray:%@",parkloadarray);
        
        ProjectDetailsViewController *Project = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
        [self.navigationController pushViewController:Project animated:YES];
        
        Project.siteData = self.siteData;
        Project.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes;
        Project.sitename = self.sitename;
        Project.image_quality = self.siteData.image_quality;
        Project.isEdit = self.isEdit;
        Project.delegate = self;
}

- (void)back_button:(id)sender
{
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
    if(parkload != nil){
        bool isAddonn7Custom = [[parkload objectForKey:@"isAddon7Custom"]boolValue];

        if(hasAddon8 && !hasCustomCategory){
            GalleryLoopViewController *PictureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryLoopVC"];
            
            PictureVC.imageArray = self.arrayOfImagesWithNotes;
            PictureVC.siteData = self.siteData;
            PictureVC.sitename = self.sitename;
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            PictureVC.pathToImageFolder = [[delegate getUserDocumentDir]    stringByAppendingPathComponent:LoadImagesFolder];

            [self.navigationController pushViewController:PictureVC animated:YES];
            
        }else if(isAddonn7Custom){
            if([[parkload objectForKey:@"isParked"] isEqual:@"1"]){
                NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
                NSString *ifCatAvailable = @"";
                for(int i = 0; i<array.count;i++){
                    NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
                    if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
                        ifCatAvailable = @"Yes";
                        break;
                    }
                }
                if([ifCatAvailable isEqualToString:@"Yes"]){
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
                    [[NSUserDefaults standardUserDefaults] setObject:_siteData.siteName forKey:@"siteName"];
                    [[NSUserDefaults standardUserDefaults] setObject:_siteData.image_quality forKey:@"image_quality"];
                    [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    LoadSelectionVC.siteName = _siteData.siteName;
                    LoadSelectionVC.siteData = _siteData;
                    delegateVC.siteDatas =  _siteData;
                    delegateVC.count = 0;
                    LoadSelectionVC.count = delegateVC.count;
                    NSLog(@"Netid1 :%d",_siteData.networkId);
                    [self.navigationController pushViewController:LoadSelectionVC animated:YES];
                }
                
            }else{
                [self deleteLoad];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}

-(void)deleteLoad{
    
    [self.alertbox hideView];
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    [parkloadarray removeObjectAtIndex:currentloadnumber];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //[self.navigationController popViewControllerAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AZCAppDelegate *delegate = AZCAppDelegate.sharedInstance;
        //[delegate.window makeToast:NSLocalizedString(@"Images Deleted Successfully",@"")  duration:2.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:nil];
    });
    
    NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
    for(NSUInteger i = array.count - 1; i>=0 ; i--) {
        NSLog(@"class: %lu , %@",(unsigned long)i,array[i] );
        if([array[i] isKindOfClass:LoadSelectionViewController.class]) {
            
            [self.navigationController popToViewController:array[i] animated:true];
            break;
        } else {
            SiteViewController *sitevc= [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            
            sitevc.movetolc=YES;
            [navigationArray removeAllObjects];
            [navigationArray addObject:sitevc];
            self.navigationController.viewControllers = navigationArray;
            
            [self.navigationController popToViewController:sitevc animated:true];
            break;
        }
    }
}
@end
