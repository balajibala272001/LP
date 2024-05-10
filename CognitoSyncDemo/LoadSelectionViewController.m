//
//  LoadSelectionViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 2/15/17.
//  Copyright © 2017 Behroozi, David. All rights reserved.
//

#import "LoadSelectionViewController.h"
#import "CameraViewController.h"
#import "Constants.h"
#import "StaticHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "AZCAppDelegate.h"
#import "UploadViewController.h"
#import "UIView+Toast.h"
#import "LoadSelectionTableViewCell.h"
#import "Reachability.h"
#import "networkpopViewController.h"
#import "Add_on.h"
#define kOpinionzSeparatorColor      [UIColor colorWithRed:0.724 green:0.727 blue:0.731 alpha:1.000]

#define kOpinionzDefaultHeaderColor  [UIColor colorWithRed:0.8 green:0.13 blue:0.15 alpha:1]
@interface LoadSelectionViewController ()<UIPopoverControllerDelegate>{
    Checkbox *cbox;
    Checkbox *selectAll;
    int loadIndex;
    networkpopViewController *popover;
    NSMutableArray *parkloadarray;
    NSInteger currentloadnumber;
    NSMutableDictionary * parkload;
    bool hasCustomCategory;
}
@end

@implementation LoadSelectionViewController

-(void) checkAction{
    

    for (int i=0;i<parkloadarray.count;i++) {
        NSMutableDictionary *load=[[NSMutableDictionary alloc]init];
        load=[[parkloadarray objectAtIndex:i] mutableCopy];
        NSMutableArray *count=[[NSMutableArray alloc] init];
        count=[load objectForKey:@"img"];

        if (selectAll.isChecked == true){
                    
                    if( count.count>0 && [load valueForKey:@"category"] != nil &&
                       [load valueForKey:@"fields"] != nil) {
                        self.label.text = @"Upload";
                        [load setValue:@"1" forKey:@"isAutoUpload"];
                    } else {
                        self.label.text =@"Click to Start a New Load";
                        [load setValue:@"0" forKey:@"isAutoUpload"];
                        
                    }
                }else{
                    self.label.text =@"Click to Start a New Load";
                    [load setValue:@"0" forKey:@"isAutoUpload"];
                    if (selectAll.isChecked == true) {
                        [selectAll setChecked:false];
                    }
                    
                }
        [parkloadarray replaceObjectAtIndex:i withObject:load];
    }
    [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.load_Table_View reloadData];
    [self button_status];
}

-(void) button_status{
    int limit=5;
    if([self.siteData.planname isEqualToString:@"Gold"]){
        limit=20;
    }else if([self.siteData.planname isEqualToString:@"Platinum"]){
        limit=50;
    }
    if (limit>parkloadarray.count) {
        self.Load_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1];
    }else if(parkloadarray.count==limit){
        for (int i=0;i<parkloadarray.count;i++) {
            NSMutableDictionary *load=[[NSMutableDictionary alloc]init];
            load=[[parkloadarray objectAtIndex:i] mutableCopy];
            if([[load objectForKey:@"isAutoUpload"]  isEqual: @"1"]){
                self.Load_btn.alpha=0.5;
                self.Load_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1];
                break;
            }else{
                self.Load_btn.alpha=1;
                self.Load_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0.5];
            }
    }
    }
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.subView.layer.cornerRadius = 10;
    self.subView.layer.borderWidth =1;
    self.subView.layer.borderColor = Blue.CGColor;
    
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        self.Load_btn.layer.cornerRadius = (self.view.frame.size.width/10 )-25;
    }else{
        self.Load_btn.layer.cornerRadius = self.view.frame.size.width/10;
    }
    self.Load_btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.Load_btn.layer.borderWidth = 1 ;
    self.Load_btn.backgroundColor = Blue;
    self.siteName = [[NSUserDefaults standardUserDefaults] stringForKey:@"siteName"];
    NSLog(@"width : %f, Radius : %f",self.view.frame.size.width ,self.Load_btn.layer.cornerRadius);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
    self.dict = [[NSMutableDictionary alloc]init];
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [self.load_Table_View setSeparatorColor:[UIColor clearColor]];
    
    self.sitesNameArr = delegate.userProfiels.arrSites;
    if (self.sitesNameArr.count == 1)
    {
        UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [logout setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    else{
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back_button:)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    }

    self.navigationItem.hidesBackButton = NO;
    
    
    //notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(park:) name:@"park" object:nil];
    self.imageArray =[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"uploaded" object:nil];
    
    _siteName_Lbl.text = _siteName;
    _siteName_Lbl.textColor = [UIColor purpleColor];
    _lowStorageLabel.backgroundColor=[UIColor whiteColor];

     int x,y1,Y,y2,y3,y;
    //x=(self.view.frame.size.width - self.Load_btn.frame.size.width)/2+15;
    x= self.load_Table_View.frame.origin.x;
    y1=self.load_Table_View.frame.origin.y+10;
    y2=_lowStorageLabel.frame.origin.y+2;
    y3=_lowStorageLabel.frame.size.height;
    y=_Load_btn.frame.origin.y +_Load_btn.frame.size.height;
    Y=(y2+y3)+((y1-(y2+y3))/2)+10;

    selectAll = [[Checkbox alloc] initWithFrame:CGRectMake(1,0, 110, 25)];
    
    [selectAll addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
       // _lowStorageLabel.priority = 250;
        [self.select_all_view addSubview:selectAll];
        //[self.lowStorageLabel bringSubviewToFront:selectAll];
        selectAll.userInteractionEnabled = YES;
    }
    [self button_status];
}


-(IBAction)logout:(id)sender {
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    if (parkloadarray.count > 0){
        [self.view makeToast:@"One or more loads are parked, please upload or delete the parked loads to proceed" duration:1.0 position:CSToastPositionCenter];
    }
    else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton:@"YES" target:self selector:@selector(signout:) backgroundColor:Red];
        [self.alertbox showSuccess:@"Logout" subTitle:@"Are you sure to Logout ?" closeButtonTitle:nil duration:1.0f ];
    }
    else{
        [self.view makeToast:@"Internet Connectivity is Offline.\n To Logout kindly reconnect Network Connection." duration:1.0 position:CSToastPositionCenter style:nil];
    }
}

-(IBAction)signout:(id)sender {
    [self.alertbox hideView];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_name"];

    UINavigationController *controller = (UINavigationController*)[self.storyboard
                                                                   instantiateViewControllerWithIdentifier: @"StartNavigation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        // [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
    [[[UIApplication sharedApplication].delegate window ]setRootViewController:controller];
    [[AZCAppDelegate sharedInstance] clearAllLoads];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:selectAll]) {
        return NO;
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    hasCustomCategory=false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on *add_on=[self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSLog(@"%@",parkloadarray);
    currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    
            //    int count = delegate.count;
            //    if (count>0) {
        [self.load_Table_View reloadData];
            //    }
        
        if ([self.siteData.planname isEqual:@"FreeTier"]) {
            _tblTopConstraint.priority = 250; //Lbl Show
            self.lowStorageLabel.text=[NSString stringWithFormat:@"Only %d images and %d videos can be captured. Please contact admin to increase storage limit for this site",self.siteData.RemainingImagecount,self.siteData.RemainingVideocount];
            [self.lowStorageLabel sizeToFit];
        }else if ([self.siteData.LowStorage isEqual:@"1"] ) {
            _tblTopConstraint.priority = 250; //Lbl Show
            self.lowStorageLabel.text=[NSString stringWithFormat:@"Only %.2f percent storage left. Please contact admin to increase storage limit for this site",self.siteData.RemainingSpacePercentage];
            [self.lowStorageLabel sizeToFit];
        }else{
            self.lowStorageLabel.text=@"";
            _tblTopConstraint.priority = 250;
            
                //        self.lowStorageLabel.text=@"";
                //        _tblTopConstraint.priority = 1000;  //Lbl hide
                //
        }
        
        
        [self handleTimer];
        
  //  if (parkloadarray!=nil && parkloadarray.count>-1){
    if (currentloadnumber!=-1) {
        
        parkload=[parkloadarray objectAtIndex:currentloadnumber];
    }
    if ( parkloadarray.count>0 ) {
        
        selectAll.text = @"Select All";
        selectAll.showTextLabel = YES;
        selectAll.labelFont = [UIFont systemFontOfSize:16];
        selectAll.hidden=NO;
            //[selectAll setChecked:false];
        
    }else{
        selectAll.hidden=YES;
    }
    
        
        
//    }else if(parkloadarray==nil){
//        NSLog(@"array: %@",parkloadarray);
//    }else if(parkloadarray.count>-1){
//        NSLog(@"Count: %lu",(unsigned long)parkloadarray.count);
//    }
    [self checkforUpload];
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

- (IBAction)Load_btn_action:(id)sender {
    
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
     
    int counter=0;
    
    for (int i=0; i<parkloadarray.count; i++) {
        NSMutableDictionary *dict=[parkloadarray objectAtIndex:i];
        NSLog(@"Delegate value sub: %d %@",i,dict);
        if ([[dict objectForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            
            //_Load_btn.titleLabel.text=@"               Upload";
            counter++;
        }else{
            
            //_Load_btn.titleLabel.text=@"       Click to Start a New Load";
        }
    }
    if (counter>0) {
        
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
           // [self.Load_btn setTitle:@"Upload" forState:UIControlStateNormal];

            self.label.text=@"Upload";
            UploadVC.siteData=self.siteData;
            UploadVC.sitename = self.siteData.siteName;
            UploadVC.image_quality=self.siteData.image_quality;
            UploadVC.isEdit =NO;
            [self.navigationController pushViewController:UploadVC animated:YES];
        }else{
            [self.view makeToast:@"Internet Connectivity Missing!.\nEnable network to upload the loads." duration:1.0 position:CSToastPositionCenter];
        }
    }else{
        
        NSMutableDictionary *parkload = [[NSMutableDictionary alloc]init];
        NSMutableArray *parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *parkedTime = [outputFormatter stringFromDate:now];
        NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
        NSNumber *epochTime = [NSNumber numberWithInt:secondsSinceUnixEpoch];
        
        
        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.cId] forKey:@"c_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.userId] forKey:@"u_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d", self.siteData.siteId] forKey:@"s_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",delegate.userProfiels.Device_id] forKey:@"device_id"];
        [parkload setValue:parkedTime forKey:@"parked_time"];
        [parkload setValue:epochTime forKey:@"park_id"];
        [parkload setValue:[NSString stringWithFormat:@"%d",self.siteData.networkId]  forKey:@"n_id"];
        [parkload setValue:@"0" forKey:@"isAutoUpload"];
        NSMutableArray *parkLoad = [[NSMutableArray alloc] init];
        [parkload setValue:parkLoad forKey:@"img"];
        [parkload setValue:nil forKey:@"fields"];
        [parkload setValue:nil forKey:@"category"];
        
        
        
        int loadcount=5;
        if([self.siteData.planname isEqualToString:@"Gold"]){
            loadcount=20;
        }else if([self.siteData.planname isEqualToString:@"Platinum"]){
            loadcount=50;
        }
        
        if (parkLoadArray == nil) {
            parkLoadArray= [[NSMutableArray alloc]init];
        }
        
        if (loadcount > parkLoadArray.count) {
            
            
            [parkLoadArray addObject:parkload];
            
            
            
            currentloadnumber=(int)parkLoadArray.count;//
            
            CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
            self.label.text=@"Click to Start a New Load";
           // [self.Load_btn setTitle:@"Click to Start a New Load" forState:UIControlStateNormal];
            CameraVC.siteData = self.siteData;
            CameraVC.siteName = self.siteName;
            
            delegate.ImageTapcount = 0;
            
            delegate.isNoEdit = YES;//
            [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber-1 forKey: @"CurrentLoadNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController pushViewController:CameraVC animated:YES];
        }else{
            [self.view makeToast:[NSString stringWithFormat:@"You can't create more than %d loads",loadcount] duration:1.0 position:CSToastPositionCenter];
            [self button_status];
        }
    }
    
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        //Handle Alert 1
        if (buttonIndex == 0) {
        }
    }
    else if(alertView.tag ==102)
    {
        if (buttonIndex == 0) {
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            [parkloadarray removeObjectAtIndex:self.tag];
            int count = delegate.count;
            count -- ;
            delegate.count = count;
            [self.load_Table_View reloadData];
        }
    }
}


- (void)back_button:(id)sender {
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (parkloadarray.count > 0) {
//        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Pressing Back button will delete all the pictures that have not been uploaded to the server. Do you want to proceeed?" preferredStyle:UIAlertControllerStyleAlert];
//        [controller addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
//            delegate.count = 0;
//            [delegate.DisplayOldValues removeAllObjects];
//            [[AZCAppDelegate sharedInstance] clearAllLoads];
//            [self.navigationController popViewControllerAnimated:YES];
//        }]];
//        [controller addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//        [self presentViewController:controller animated:true completion:nil];
        [self.view makeToast:@"One or more loads are parked, please upload or delete the parked loads to proceed" duration:1.0 position:CSToastPositionCenter];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"siteID"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
       // else{
//        [[UIApplication sharedApplication] terminate:nil];
//    }
}

-(void)park:(NSNotification *)notification{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[LoadSelectionViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
//            self.arrayDisplayOldValues = notification.object;
//            NSMutableArray *arr = [[NSMutableArray alloc]init];
//            arr = notification.object;
//            NSLog(@" the array:%@",arr);
            break;
        }
    }
}

- (void) handleTimer{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    networkStater.adjustsImageWhenHighlighted=YES;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = @"Load Selection";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
        //titleLabel.backgroundColor = [UIColor blackColor];
    
    
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
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        popover.labelvalue.text =@"Network Not Connected";
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
    /* if(popover == nil)
     {
     popover = [self.storyboard instantiateViewControllerWithIdentifier:@"netpop"];
     }
     
     popover.preferredContentSize = CGSizeMake(180, 30);
     popover.modalPresentationStyle = UIModalPresentationPopover;
     UIPopoverPresentationController *popoverController = popover.popoverPresentationController;
     popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
     popoverController.delegate = self;
     popoverController.sourceView = self.view;
     popoverController.sourceRect = [sender frame];
     //popoverController.backgroundColor =[UIColor blueColor];
     
     [self presentViewController:popover animated:YES completion:nil];*/
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

-(IBAction)dummy:(id)sender
{
    [self.alertbox hideView];
}

#pragma -mark Tableview Methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.sitesNameArr count];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
   return parkloadarray.count;
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //    
    //
    //    CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
    //    
    //    
    //    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //    arr =[delegate.DisplayOldValues objectAtIndex:indexPath.row];
    //    
    //    delegate.LoadNumber = indexPath.row;
    //    
    //    
    //    
    //    CameraVC.siteData = self.siteData;
    //    CameraVC.siteName = self.siteName;
    //    CameraVC.arrr = arr;
    //    CameraVC.tapCount = delegate.ImageTapcount;
    //    
    //    
    //    CameraVC.oldDict = self.dict;
    //    CameraVC.isEdit = YES;
    //    
    //    
    //    CameraVC.load_number = self.loadNumber;
    //    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    
    //    [self.navigationController pushViewController:CameraVC animated:YES];
  
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Load";
    LoadSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
    }
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dict = [parkloadarray objectAtIndex:indexPath.row];
    int count = delegate.count;
    
    
   

    
    //Getting field label
    
    SiteData *sitess = self.siteData;
    
    if (hasCustomCategory) {
        for (int index=0; index<self.siteData.customCategory.count; index++) {
            CategoryData *cat= [self.siteData.customCategory objectAtIndex:index];
            if ([cat.categoryName isEqual:[self.dict objectForKey:@"category"]]) {
                self.metaData=cat.categoryMetaArray;
                break;
            }

        }
        
        
        //self.metaData= [self.dict objectForKey:@"fields"];
    }else{
        self.metaData = sitess.arrFieldData;
    }
    
   
    //iterating the fielddata array
    int fieldId1 = 0;
    int fieldId2 = 0;
    
    NSString *field_label1;
    NSString *field_label2;
    
    
    NSMutableDictionary *DictFields1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *DictFields2 = [[NSMutableDictionary alloc]init];
    
    int old_field_id1 = 0;
    int old_field_id2 = 0;
    FieldData *fieldData1;
    FieldData *fieldData2;
    
    NSMutableArray *fields = [[NSMutableArray alloc]init];
    
    if(self.metaData.count > 1)
    {
        fieldData1 = [self.metaData objectAtIndex:0];
        fieldData2 = [self.metaData objectAtIndex:1];
    }
    
    else if (self.metaData.count == 1)
        
    {
        fieldData1 = [self.metaData objectAtIndex:0];
        
    }
    //getting image count
    
    self.imageArray =[[NSMutableArray alloc]init];
    self.imageArray =[self.dict objectForKey:@"img"];
    
    int image_count = (int)[self.imageArray count];
    
    
    NSString *str_image_count = [NSString stringWithFormat: @"%ld", (long)image_count];
    //image count
    
    //Getting time
    NSString *parkedTime = [self.dict objectForKey:@"parked_time"];
    
    
    
    NSLog(@"LOAD:%@",self.dict);
    
    fields = [self.dict objectForKey:@"fields"];
    
    NSLog(@"fields:%@",fields);
    
    
    
    NSString * fieldvalue2 = @"";
    NSString * fieldvalue1 = @"";
    if (fields.count >1 ) {
        DictFields1 =[fields objectAtIndex:0];
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        
        
        if (fieldId1 == old_field_id1 ) {
            NSString *fieldval1=@"[ ";
        if ([[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
            
            NSArray *array= [DictFields1 objectForKey:@"field_value"];
            
            for (int i=0; i<array.count; i++) {
                
                fieldval1 = [fieldval1 stringByAppendingString:[array objectAtIndex:i]];
                    
                if (i!=array.count-1) {
                    fieldval1=[fieldval1 stringByAppendingString:@" , "];
                }else{
                     fieldval1=[fieldval1 stringByAppendingString:@" ]"];
                }
                
            }
            self.field_label1 =field_label1;
            fieldvalue1 = fieldval1.length>2?fieldval1:@"";
        }
        
    else{
                fieldval1 = [DictFields1 objectForKey:@"field_value"];
            }
        
            self.field_label1 =field_label1;
            fieldvalue1 = fieldval1;
            
    }
        DictFields2 = [fields objectAtIndex:1];
        fieldId2 = fieldData2.fieldId;
        field_label2 =fieldData2.strFieldLabel;
        
        old_field_id2 =[[DictFields2 objectForKey:@"field_id"] intValue];
        
        
        if (fieldId2 == old_field_id2) {
            NSString *fieldval2 =@"[ ";
            
        if ([[DictFields2 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields2 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
                
                NSArray *array= [DictFields2 objectForKey:@"field_value"];
                
                for (int i=0; i<array.count; i++) {
                    
                    fieldval2 = [fieldval2 stringByAppendingString:[array objectAtIndex:i]];
                    
                    if (i!=array.count-1) {
                        fieldval2=[fieldval2 stringByAppendingString:@" , "];
                    }else{
                        fieldval2=[fieldval2 stringByAppendingString:@" ]"];
                    }
                    
                }
            fieldval2 = fieldval2.length>2?fieldval2:@"";
            fieldvalue2 = fieldval2;
            }else{
                fieldvalue2 = [DictFields2 objectForKey:@"field_value"];
            }
             
        
            self.field_label2 = field_label2;
            NSLog(@"fieldval2%@",fieldval2);
            NSLog(@"field_value2%@",fieldvalue2);

        }
        
        
        
        
    }
    else if(fields.count == 1)
    {
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        fields = [self.dict objectForKey:@"fields"];
        DictFields1 =[fields objectAtIndex:0];
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        if (fieldId1 == old_field_id1 ) {
            NSString *fieldval1=@" [ ";
        if ([[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Radio"]||[[DictFields1 objectForKey:@"field_attribute"] isEqual:@"Checkbox"]) {
            
            NSArray *array= [DictFields1 objectForKey:@"field_value"];
            
            for (int i=0; i<array.count; i++) {
                
                fieldval1 = [fieldval1 stringByAppendingString:[array objectAtIndex:i]];
                    
                if (i!=array.count-1) {
                    fieldval1=[fieldval1 stringByAppendingString:@" , "];
                }else{
                     fieldval1=[fieldval1 stringByAppendingString:@" ]"];
                }
            }
        }
    else{
                fieldval1 = [DictFields1 objectForKey:@"field_value"];
            }
            self.field_label1 =field_label1;
            fieldvalue1 = fieldval1;
    }
        // DictFields2 = [fields objectAtIndex:1];
    }
    NSLog(@"field_value2%@",fieldvalue2);
    NSString *model=[UIDevice currentDevice].model;
    int x,width;
    
    x= self.view.frame.size.width /40 ;
    if ([model isEqualToString:@"iPad"]) {
        width = (self.view.frame.size.width/8)*7.3;
    }else{
    width = (self.view.frame.size.width/8)*7;
    }
    int y = 10;
    int height = 130;
    
    UIButton *loadBtn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
    loadBtn.tag = 1;
    loadBtn.adjustsImageWhenHighlighted=YES;
    NSDictionary *dict=[parkloadarray objectAtIndex:indexPath.row];
    loadBtn.layer.cornerRadius = 10;
    loadBtn.layer.borderWidth =2;
    loadBtn.layer.borderColor = Blue.CGColor;
    [loadBtn addTarget:self action:@selector(Loads:) forControlEvents:UIControlEventTouchUpInside];
    [loadBtn setTag:indexPath.row];
    bool isMandate=false,hasMandate=false;
    NSMutableArray *field_count=[[NSMutableArray alloc]init];
    field_count=[dict objectForKey:@"fields"];
    for (int index=0; index<field_count.count; index++) {
        NSDictionary *d=[field_count objectAtIndex:index];
        if ([[d objectForKey:@"field_mandatory"] isEqual:@"1"] ) {
            hasMandate=true;
            if ([[d objectForKey:@"field_attribute"]isEqual: @"Checkbox"]|| [[d objectForKey:@"field_attribute"]isEqual: @"Radio"]) {
                NSArray *arr=[d objectForKey:@"field_value"];
                isMandate= arr.count>0;
                
            }else{
                NSString *str=[d objectForKey:@"field_value"];
                isMandate= str.length>0;
                
            }
            if (!isMandate) {
                break;
            }
        }
    }
    NSMutableArray *img_count=[[NSMutableArray alloc]init];
    img_count=[dict objectForKey:@"img"];
    if (dict!=nil && [dict objectForKey:@"load_id"] !=nil) {
        loadBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:236.0/255.0 blue:134.0/255.0 alpha:1.0];
    }else{
        if (img_count.count>0 &&[dict valueForKey:@"category"] != nil && [dict valueForKey:@"fields"] != nil&& (!hasMandate|| isMandate)) {
            loadBtn.backgroundColor = [UIColor whiteColor];
        }else{
            loadBtn.backgroundColor = [UIColor colorWithRed:0.85 green:0.1 blue:0.0 alpha:0.75];
        }
    }
    
    //checkbox
    int cboxX, cboxY,cboxH,cboxW;
    cboxX = 5;
    cboxY = loadBtn.frame.size.height/2 - 10;
    cboxH = loadBtn.frame.size.height/6;
    cboxW = loadBtn.frame.size.height/6;
    cbox = [[Checkbox alloc] initWithFrame:CGRectMake(cboxX, cboxY, cboxH, cboxW)];
    NSMutableDictionary *dummy= [parkloadarray objectAtIndex:indexPath.row];
    bool checked=[[dummy objectForKey:@"isAutoUpload"] isEqualToString:@"1"];
    [cbox addTarget:self action:@selector(selectload:)
   forControlEvents:UIControlEventTouchUpInside];
    [cbox setTag:indexPath.row];
    NSMutableArray *co=[dummy objectForKey:@"img"];
    if (co.count >0 ) {
        if (checked) {
            [cbox setChecked:true];
        }else{
            [cbox setChecked:false];
        }
    }else{
        [cbox setChecked:false];
    }
    
    if (![self.siteData.planname isEqual:@"FreeTier"]) {
        [loadBtn addSubview:cbox];
    }
    
    
    
    //Cretaing a label1-Meta Data1
    int meta_x = cbox.frame.size.width + cbox.frame.origin.x + 5;
    UILabel *meta_Data1 ;
    if ([model isEqualToString:@"iPhone"]) {
    meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, loadBtn.frame.size.width/2.6, 40)];
    }else if ([model isEqualToString:@"iPad"]) {
    meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, loadBtn.frame.size.width/2.3, 40)];
    }else{
        meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,10, loadBtn.frame.size.width/2.7, 40)];
    }
    meta_Data1.layer.borderWidth = 1;
    meta_Data1.layer.borderColor = [UIColor blackColor].CGColor;
    meta_Data1.layer.cornerRadius = 10;
    meta_Data1.layer.backgroundColor = Blue.CGColor;
    meta_Data1.text = self.field_label1;
    meta_Data1.textColor = [UIColor whiteColor];
    [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data1.textAlignment = NSTextAlignmentCenter;
    meta_Data1.minimumScaleFactor=0.5;
    
    UILabel *meta_Data_value1;
    if ([model isEqualToString:@"iPhone"]) {
        meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, loadBtn.frame.size.width/2.6, 40)];
        
    }else if ([model isEqualToString:@"iPad"]) {
        meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, loadBtn.frame.size.width/2.3, 40)];
    }else{
        meta_Data_value1 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width + 5,10, loadBtn.frame.size.width/2.7, 40)];

    }
    meta_Data_value1.layer.borderWidth = 1;
    meta_Data_value1.layer.borderColor = [UIColor blackColor].CGColor;
    meta_Data_value1.layer.cornerRadius = 10;
    meta_Data_value1.text = fieldvalue1;
    meta_Data_value1.textColor = Blue;
    [meta_Data_value1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data_value1.textAlignment = NSTextAlignmentCenter;
    meta_Data_value1.minimumScaleFactor=0.5;
    
    //Creating a Label1-Meta Data2
    UILabel* meta_Data2;
    if ([model isEqualToString:@"iPhone"]) {
    meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.6, 40)];
    }else if ([model isEqualToString:@"iPad"]) {
        meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.3, 40)];
    }else{
        meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.7, 40)];
    }
    if (fields.count >1) {
        meta_Data2.layer.backgroundColor = Blue.CGColor;
        meta_Data2.layer.borderWidth = 1;
        meta_Data2.layer.borderColor = [UIColor blackColor].CGColor;
        meta_Data2.layer.cornerRadius = 10;
        meta_Data2.text = self.field_label2;
        meta_Data2.textColor = [UIColor whiteColor];
        [meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data2.textAlignment = NSTextAlignmentCenter;
        meta_Data2.minimumScaleFactor=0.5;
    }
    
    UILabel* meta_Data_value2;
    if ([model isEqualToString:@"iPhone"]) {
    meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.6, 40)];
    }else if ([model isEqualToString:@"iPad"]){
        meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.3, 40)];
    }else{
        meta_Data_value2 =[[UILabel alloc]initWithFrame:CGRectMake(meta_x + meta_Data1.frame.size.width+5,meta_Data1.frame.size.height + 15, loadBtn.frame.size.width/2.7, 40)];

    }
    if (fields.count >1) {
        meta_Data_value2.layer.borderWidth = 1;
        meta_Data_value2.layer.borderColor = [UIColor blackColor].CGColor;
        meta_Data_value2.layer.cornerRadius = 10;
        meta_Data_value2.text = fieldvalue2;
        meta_Data_value2.textColor = Blue;
        [meta_Data_value2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data_value2.textAlignment = NSTextAlignmentCenter;
        meta_Data_value2.minimumScaleFactor=0.5;
    }

    
    //Creating a Button -Delete Button
    UIButton *delete_button =[[UIButton alloc]initWithFrame:CGRectMake(width - 35, 4, 30, 30)];
    [delete_button setBackgroundImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
    [delete_button addTarget:self action:@selector(deleteLoad:) forControlEvents:UIControlEventTouchUpInside];
    [delete_button setTag:indexPath.row];
    
    //creating label for diaplaying image count
    int meta_y = meta_Data1.frame.size.height + meta_Data_value1.frame.size.height+ 15;
    UILabel *image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data1.frame.origin.x,meta_y,meta_Data1.frame.size.width, 30)];
    image_Count.text =[NSString stringWithFormat:@"%@ Media files",str_image_count];
    image_Count.adjustsFontSizeToFitWidth = YES;
    [image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    image_Count.textAlignment =  NSTextAlignmentCenter;
    NSLog(@"image_Count %@",image_Count);
    NSLog(@"meta_y %d",meta_y);
    NSLog(@"meta_Data1 %@",meta_Data1);
    NSLog(@"meta_Data2 %@",meta_Data2);

    //Cretaing label for displaying the time
    UILabel *parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(meta_Data_value1.frame.origin.x, meta_y,meta_Data1.frame.size.width, 30)];
    parked_time.adjustsFontSizeToFitWidth = YES;
    parked_time.text = [NSString stringWithFormat:@"Parked at %@",parkedTime];
    [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    parked_time.textAlignment =  NSTextAlignmentCenter;

    [loadBtn addSubview:parked_time];
    [loadBtn addSubview:image_Count];
    [loadBtn addSubview:delete_button];
    
    if (fields.count>0) {
        [loadBtn addSubview:meta_Data1];
        [loadBtn addSubview:meta_Data_value1];
    }
    
    if (fields.count>1) //&& self.field_value2.length>0)
    {
        [loadBtn addSubview:meta_Data2];
        [loadBtn addSubview:meta_Data_value2];
    }
    [cell addSubview:loadBtn];
    
    
    [cell setTag:indexPath.row];
    NSLog(@"loadbtn %@",loadBtn);
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.alertbox hideView];
}

-(void)alert{
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"Upload" target:self selector:@selector(upload:) backgroundColor:Green];
    [self.alertbox addButton:@"Cancel" target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox showSuccess:@"Warning" subTitle:@"This load can't be edited because it was interrupted while uploading.\nClick 'Upload' to resume upload." closeButtonTitle:nil duration:1.0f ];
}
    
-(IBAction)upload:(id)sender
{
    //self.customAlertView.hidden = YES;
    [self.alertbox hideView];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        
        
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        
        
        UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];

        
        UploadVC.sitename = self.siteData.siteName;
        UploadVC.siteData=self.siteData;
        UploadVC.image_quality=self.siteData.image_quality;
        UploadVC.isEdit =NO;
        [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:UploadVC animated:YES];
    }else{
        [self.view makeToast:@"Internet Connectivity Missing!.\nEnable network to upload the loads." duration:1.0 position:CSToastPositionCenter];
    }
}

-(IBAction)closealert:(id)sender
{
    self.customAlertView.hidden=YES;
}


- (IBAction)selectload:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *_oldDict = [[parkloadarray objectAtIndex:btn.tag ] mutableCopy];
    NSMutableArray *count=[[NSMutableArray alloc]init];
    NSMutableArray *field_count=[[NSMutableArray alloc]init];
    count=[_oldDict objectForKey:@"img"];
    field_count=[_oldDict objectForKey:@"fields"];
    bool isMandate=false,hasMandate=false;
    for (int index=0; index<field_count.count; index++) {
        NSDictionary *d=[field_count objectAtIndex:index];
        if ([[d objectForKey:@"field_mandatory"] isEqual:@"1"] ) {
            hasMandate=true;
            if ([[d objectForKey:@"field_attribute"]isEqual: @"Checkbox"]|| [[d objectForKey:@"field_attribute"]isEqual: @"Radio"]) {
                NSArray *arr=[d objectForKey:@"field_value"];
                isMandate= arr.count>0;
            }else{
                NSString *str=[d objectForKey:@"field_value"];
                isMandate= str.length>0;
            }
            if (!isMandate) {
                break;
            }
        }
    }
    
    if (count.count>0 &&[_oldDict valueForKey:@"category"] != nil  && [_oldDict valueForKey:@"fields"] != nil&&(!hasMandate|| isMandate)) {
        
        if ([[_oldDict objectForKey:@"isAutoUpload"] isEqualToString:@"0"]) {
            [_oldDict setValue:@"1" forKey:@"isAutoUpload"];
            
        }
        else{
            [_oldDict setValue:@"0" forKey:@"isAutoUpload"];
        }
        NSInteger index=btn.tag;
        [parkloadarray replaceObjectAtIndex:index withObject:_oldDict];
        [[NSUserDefaults standardUserDefaults] setValue:parkloadarray forKey: @"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"old_value_sub : %@",parkloadarray);
        [self checkforUpload];
    }else{
        if(count.count==0){
        
            [self.view makeToast:@"This Parked load has Zero mediafile.Please capture atleast one media file to upload " duration:1.0 position:CSToastPositionCenter];
           
        }else if(!hasMandate||isMandate){
            [self.view makeToast:@"MetaData not entered for Mandatory field.\n Enter mandatory and try to upload." duration:1.0 position:CSToastPositionCenter];
        }else if ([_oldDict valueForKey:@"fields"] == nil){
            
             [self.view makeToast:@"MetaData not entered for this load.\n Enter MetaData and try to upload." duration:1.0 position:CSToastPositionCenter];
        }else{
            [self.view makeToast:@"Category is not selected for this load.\nSelect Category and try to upload." duration:1.0 position:CSToastPositionCenter];
            
        }
    }
    [self button_status];
    [self.load_Table_View reloadData];
    
}


-(void) checkforUpload{
    
    
    BOOL isSelectall=NO;
    
    int counter=0;
    for (int i=0; i<parkloadarray.count; i++) {
        
        NSMutableDictionary *dict = [[parkloadarray objectAtIndex:i ] mutableCopy];
        if ([[dict valueForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            counter++;
            isSelectall=YES;
            //[self.Load_btn setTitle:@"Upload" forState:UIControlStateNormal];

            self.label.text=@"Upload";
        }
    }
    if (!isSelectall) {
       // [self.Load_btn setTitle:@"Click to Start a New Load" forState:UIControlStateNormal];

        self.label.text =@"Click to Start a New Load";
        // [selectAll setChecked:false];

    }
    
    if (counter==parkloadarray.count) {
        if (parkloadarray.count==0) {
            selectAll.hidden=YES;
            
        }else{
            selectAll.hidden=NO;
            [selectAll setChecked:true];
        }
    }else {
        [selectAll setChecked:false];
    }

    [self button_status];
}

-(IBAction)deleteLoad:(id)sender
{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    UIButton *btn = (UIButton *)sender;
    
    loadIndex=btn.tag;
        
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"NO" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox addButton:@"YES" target:self selector:@selector(delete:) backgroundColor:Red];
    
    [self.alertbox showSuccess:@"Warning" subTitle:@"Deleting the load will delete all the pictures in the load, continue?" closeButtonTitle:nil duration:1.0f ];
   
}


-(IBAction)delete:(id)sender{
    [self.alertbox hideView];
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDictionary *_oldDict = [parkloadarray objectAtIndex:loadIndex];
    
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    
    if (parkloadarray == nil) {
        parkloadarray = [[NSMutableArray alloc] init];
    }
    
    if (parkloadarray.count>loadIndex) {
        [parkloadarray removeObjectAtIndex:loadIndex];
    }
    [self.view makeToast:@"Load Deleted Sucessfully" duration:1.0 position:CSToastPositionCenter];
      
    if (parkloadarray.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"CurrentLoadNumber"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    int count = delegate.count;
    count -- ;
    delegate.count = count;
    [self.load_Table_View reloadData];
    
    parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
    if (parkloadarray == nil || parkloadarray.count == 0) {
        [[AZCAppDelegate sharedInstance] clearAllLoads];
    }
    
    [self checkforUpload];
    [self button_status];
    
}
-(BOOL) isBatchUpload{
    
    for (int i=0; i<parkloadarray.count; i++) {
        NSMutableDictionary *dict=[parkloadarray objectAtIndex:i];
        NSLog(@"Delegate value sub: %d %@",i,dict);
        if ([[dict objectForKey:@"isAutoUpload"] isEqualToString:@"1"]) {
            return true;
        }
    }
    return false;
}


-(IBAction)Loads:(id)sender
{
    if ([self isBatchUpload]){
        [self.view makeToast:@"Un-Select all 'Quick Upload' Checkbox to access the parked loads." duration:1.0 position:CSToastPositionCenter];
    }else {
        
        
        UIButton *btn = (UIButton *)sender;
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
        
            // NSIndexPath *selectedIndexPath = [self.load_Table_View indexPathForSelectedRow];
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
            // arr =[delegate.DisplayOldValues objectAtIndex:selectedIndexPath.row];
        
        arr = [parkloadarray objectAtIndex:btn.tag];
        
        
            //delegate.LoadNumber = selectedIndexPath.row;
        currentloadnumber =(int) btn.tag;
        delegate.isNoEdit = NO;
        
        NSLog(@"dLoadNumber:%d",currentloadnumber);
        
        
        
        if ([arr valueForKey:@"load_id"] != nil) {
            [self alert ];
        }else{
            CameraVC.siteData = self.siteData;
            CameraVC.siteName = self.siteName;
            CameraVC.tapCount = delegate.ImageTapcount;
            CameraVC.isEdit = YES;
            NSLog(@" load number :%d",self.loadNumber);
            
                // CameraVC.load_number = (int)btn.tag ;
            [[NSUserDefaults standardUserDefaults] setInteger:currentloadnumber forKey:@"CurrentLoadNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            CameraVC.load_number = self.loadNumber;
                // [self.load_Table_View deselectRowAtIndexPath:btn.tag animated:YES];
            
            [self.navigationController pushViewController:CameraVC animated:YES];
        }
    }
}


-(void)remove:(NSNotification *)notification{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[LoadSelectionViewController class]])
        {
//            [self.navigationController popToViewController:controller animated:YES];
            // [self.myimagearray removeAllObjects];
            //[self.collection_View reloadData];
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            if (parkloadarray.count > 0) {
                if (delegate.isEdit) {
                    [parkloadarray removeObjectAtIndex:currentloadnumber];
                    int count = 0;
                    count = delegate.count;
                    count --;
                    delegate.count = count;
                    // break;
                }
                [self.load_Table_View reloadData];
            }
            else
            {
                delegate.count = 0;
                [self.load_Table_View reloadData];
            }
        }
    }
}



@end
