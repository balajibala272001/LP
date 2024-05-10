//
//  SiteViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/19/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "SiteViewController.h"
#import "SiteTableViewCell.h"
#import "CameraViewController.h"
#import "StaticHelper.h"
#import "AZCAppDelegate.h"
#import "SiteData.h"
#import "Constants.h"
#import "Reachability.h"
#import "LoadSelectionViewController.h"
#import "UIView+Toast.h"
#import "SCLAlertView.h"
#import "networkpopViewController.h"
#import "Add_on.h"
#import "ServerUtility.h"

@interface SiteViewController ()<UIPopoverControllerDelegate>
{
    networkpopViewController *popover;
    bool isLogin;
}
@end

@implementation SiteViewController
@synthesize btn;
@synthesize simple_tbleView;
@synthesize i;

- (void)viewDidLoad {
    [super viewDidLoad];
    isLogin = false;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sitesArr:) name:@"sites" object:nil];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];

   self.sitesNameArr = delegate.userProfiels.arrSites;
    [self.simple_tbleView reloadData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"Site Selection";
    //self.navigationItem.hidesBackButton = YES;
   
    
    self.sub_view.layer.cornerRadius = 10;
    self.sub_view.layer.borderWidth =1;
    self.sub_view.layer.borderColor = Blue.CGColor;
    self.simple_tbleView.layer.borderWidth = 1.0;
    self.simple_tbleView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    
    
    self.btn.layer.cornerRadius=8;
    simple_tbleView.layer.cornerRadius=8;
   // NSLog(@" the sites are:%@",self.sitesNameArr);
    
    // Do any additional setup after loading the view.
    
    UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [logout setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    if (self.movetolc) {
        [self moveToLoadSelection];
    }
    if(!isLogin)
    {
        NSIndexPath *ip = 0;
        if (self.sitesNameArr.count == 1) {
            [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleTimer];
//    [self checkForPendingUpload];
}

-(void )handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = @"Site Selection";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
        //titleLabel.backgroundColor = [UIColor blackColor];
    [networkStater
     setBackgroundImage:[UIImage imageNamed:@"yellow_nw.png"]  forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
    [view addSubview:titleLabel];
    
    view.center = self.view.center;
    
    
    if (delegate.isMaintenance) {
        
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.921 blue: 0.243 alpha: 1.00].CGColor;
        
            //RGBA ( 255 , 235 , 62 , 100 )
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
        
        
            //RGBA ( 213 , 191 , 0 , 100 )
        
        NSLog(@"Server Under maintenance");
        popover.labelvalue.text =@"Server maintenance";
    }else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        popover.labelvalue.text =@"Network Connected";
        
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 229 , 8 , 100)
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 174 , 7 , 100 )
        
        NSLog(@"Network Connection available");
    } else {
        NSLog(@"Network Connection not available");
        popover.labelvalue.text =@"Network Not Connected";
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
    NSString *stat=@"Network Not Connected";
     if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
         stat=@"Network Connected";
     }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
     [self.alertbox showSuccess:@"Status" subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}


-(IBAction)logout:(id)sender {
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:@"YES" target:self selector:@selector(signout:) backgroundColor:Red];
        [self.alertbox showSuccess:@"Logout" subTitle:@"Are you sure to Logout ?" closeButtonTitle:nil duration:1.0f ];
    }else{
        [self.view makeToast:@"Internet Connectivity is Offline.\n To Logout kindly reconnect Network Connection." duration:1.0 position:CSToastPositionCenter style:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.simple_tbleView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
}

-(IBAction)signout:(id)sender {
    [self.alertbox hideView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
    NSString * tokid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"TokenID"];
    NSLog(@"tokid%@",tokid);
    [[NSUserDefaults standardUserDefaults] synchronize];
    UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"StartNavigation"];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
    [[AZCAppDelegate sharedInstance] clearAllLoads];
    NSString * logout = @"logged_Out";
    //[ServerUtility sendStatuslogin:logout andCompletion:^(NSError *error,id data,float dummy)];
}

-(void) checkForPendingUpload {
    NSLog(@"navigationController %lu",(unsigned long)self.navigationController.viewControllers.count);

    if (self.navigationController.viewControllers.count == 1 ) {
        if ([[AZCAppDelegate sharedInstance] hasCurrentLoad]) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]) {
            int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
            
            SiteData *site;
            if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                
                if (filteredArray.count == 1) {
                    site = [filteredArray objectAtIndex:0];
                    
                    if(site!=NULL){
                        [[NSUserDefaults standardUserDefaults] setObject:site.image_quality forKey:@"image_quality"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
            UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
            UploadVC.uploadDelegate = self;
            UploadVC.image_quality=site.image_quality;
                //UploadVC.oldDict=delegate.DisplayOldValues;
            UploadVC.siteData=site;
            UploadVC.sitename = site.siteName;
            [self.navigationController pushViewController:UploadVC animated:YES];
        } else if ([[AZCAppDelegate sharedInstance] hasParkedLoad]) {
            
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
                
                int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
                
                SiteData *site;
                if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                    NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                    
                    if (filteredArray.count == 1) {
                        site = [filteredArray objectAtIndex:0];
                    }
                }
            if (site != nil) {
                
                int loadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
                if (loadnumber>-1) {
                    NSMutableArray *loadArray= [[NSMutableArray alloc] init];
                    loadArray= [[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy ];
                    if (loadArray.count>0) {
                        
                        
                        CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
                        
                            // NSIndexPath *selectedIndexPath = [self.load_Table_View indexPathForSelectedRow];
                        
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                            // arr =[delegate.DisplayOldValues objectAtIndex:selectedIndexPath.row];
                        
                        arr = [loadArray objectAtIndex:loadnumber];
                        
                        
                            //delegate.LoadNumber = selectedIndexPath.row;
                        
                        
                        
                        NSLog(@"dLoadNumber:%d",loadnumber);
                        
                        SiteData *site;
                        int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
        
                        if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                            NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                            
                            if (filteredArray.count == 1) {
                                site = [filteredArray objectAtIndex:0];
                            }
                        }
                        
                        if (site==nil) {
                            [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }else{
                            
                            
                            delegate.siteDatas =  site;
                            CameraVC.siteData = site;
                            CameraVC.siteName = site.siteName;
                            
                            CameraVC.tapCount = delegate.ImageTapcount;
                            
                            CameraVC.isEdit = YES;
                            
                                //self.loadNumber = (int)btn.tag;
                            
                            NSLog(@" load number :%d",loadnumber);
                            
                                // CameraVC.load_number = (int)btn.tag ;
                            [[NSUserDefaults standardUserDefaults] setInteger:loadnumber forKey:@"CurrentLoadNumber"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            CameraVC.load_number = loadnumber;
                                // [self.load_Table_View deselectRowAtIndexPath:btn.tag animated:YES];
                            
                            [self.navigationController pushViewController:CameraVC animated:YES];
                        }
                    }
                }else{
                    
                    LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
                        //                    [SiteData saveCustomObject:site key:@"siteData"];
                    [[NSUserDefaults standardUserDefaults] setObject:site.image_quality forKey:@"image_quality"];
                    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    LoadSelectionVC.siteName = site.siteName;
                    LoadSelectionVC.siteData = site;
                    
                    delegate.siteDatas =  site;
                    delegate.count = 0;
                    LoadSelectionVC.count = delegate.count;
                    
                    
                    NSLog(@"Netid1 :%d",site.networkId);
                    
                    [self.navigationController pushViewController:LoadSelectionVC animated:YES];
                }
            }
                
           
        }
        else
        {
            [[AZCAppDelegate sharedInstance] clearAllLoads];
            NSIndexPath *ip = 0;
            if (self.sitesNameArr.count == 1) {
                [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
        }
        }
    }else{
//        NSIndexPath *ip = 0;
//        if (self.sitesNameArr.count == 1) {
//            [self tableView:simple_tbleView  didSelectRowAtIndexPath:ip];
//        }
    }
}

-(void)uploadFinishCheckParkLoad{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SiteViewController class]])
        {
            [self.navigationController popToViewController:controller animated:true];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]){
        
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
            
            SiteData *site;
            if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
                NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
                
                if (filteredArray.count == 1) {
                    site = [filteredArray objectAtIndex:0];
                }
            }
            
            
            if (site != nil) {
                LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
                
                [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
                //                    [SiteData saveCustomObject:site key:@"siteData"];
                [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                LoadSelectionVC.siteName = site.siteName;
                LoadSelectionVC.siteData = site;
                
                
                delegate.siteDatas =  site;
                delegate.count = 0;
                LoadSelectionVC.count = delegate.count;
                NSLog(@"Netid2 :%d",site.networkId);
                [self.navigationController pushViewController:LoadSelectionVC animated:false];
            }
    }
}


-(void)moveToLoadSelection{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    int siteID = [[userDefaults valueForKey:@"siteID"] intValue];
    
    SiteData *site;
    if (self.sitesNameArr != nil && self.sitesNameArr.count > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteId == %d", siteID];
        NSArray *filteredArray = [self.sitesNameArr filteredArrayUsingPredicate:predicate];
        
        if (filteredArray.count == 1) {
            site = [filteredArray objectAtIndex:0];
        }
    }
    
    
    if (site != nil) {
        LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
        
        [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
            //                    [SiteData saveCustomObject:site key:@"siteData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoadSelectionVC.siteName = site.siteName;
        LoadSelectionVC.siteData = site;
        
        delegate.siteDatas =  site;
        delegate.count = 0;
        LoadSelectionVC.count = delegate.count;
        NSLog(@"Netid3 :%d",site.networkId);
        [self.navigationController pushViewController:LoadSelectionVC animated:false];
    }
}

-(void)restartedUploadFinished{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SiteViewController class]])
        {
            [self.navigationController popToViewController:controller animated:true];
        }
    }
    [self moveToLoadSelection];
}
    


-(void)sitesArr:(NSNotification *)notification
{

    self.sitesNameArr = [ notification object];
    [self.simple_tbleView reloadData];
    isLogin = true;
    [self checkForPendingUpload];
    
}
-(void)startLocating:(NSNotification *)notification {
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.sitesNameArr = delegate.userProfiels.arrSites;
}

-(void)receiveNotofication:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"received"]) {
        self.sitesNameArr = notification.userInfo;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sitesNameArr count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Site";
    

    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
    }
    
    // Set up the cell...
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    
    SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
    cell.textLabel.text = site.siteName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES; // As alternative you can also make it multi-line.
    cell.textLabel.minimumScaleFactor = 0.1;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor purpleColor];
    

    [self.simple_tbleView setSeparatorColor:[UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0]];

    UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
    
    [cell setSelectedBackgroundView:bgColorView];
   //   cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setTintColor:[UIColor redColor]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 15, 15)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [[UIImage imageNamed:@"right_arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    imgView.tintColor = [UIColor purpleColor];
    cell.accessoryView = imgView;
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
   

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
    bool hasCustomCategory=false;//,hasCustomMeta=false;
    
    for (int index=0; index<site.categoryAddon.count; index++) {
        Add_on *add_on = [site.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    
    if ( hasCustomCategory && ( site.customCategory.count == 0 ) ){
        [self.view makeToast:@"Custom Category is not configured for this Site.\nPlease contact Network admin to configure custom category." duration:1.0 position:CSToastPositionCenter style:nil];
    }else{
    LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
        
        [[NSUserDefaults standardUserDefaults] setObject:site.siteName forKey:@"siteName"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:site.siteId forKey:@"siteID"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"SiteId %d",site.siteId);
        NSLog(@"SiteName %@",site.siteName);
        LoadSelectionVC.siteName = site.siteName;
        LoadSelectionVC.siteData = site;
        
        AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        delegate.siteDatas =  site;
        delegate.count = 0;
        LoadSelectionVC.count = delegate.count;
        NSLog(@"Netid4 :%d",site.networkId);
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:LoadSelectionVC animated:YES];
        
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.btn=nil;
    self.simple_tbleView=nil;
    self.i=nil;
    [super viewDidUnload];
}

@end

