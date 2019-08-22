










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

#import "LoadSelectionViewController.h"


@interface SiteViewController ()

@end





@implementation SiteViewController
@synthesize btn;
@synthesize simple_tbleView;
@synthesize i;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sitesArr:) name:@"sites" object:nil];
    
    
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
   self.sitesNameArr = delegate.userProfiels.arrSites;
      
    
    [self.simple_tbleView reloadData];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [StaticHelper setLocalizedBackButtonForViewController:self];

    self.navigationItem.title = @"Site Selection";
    //self.navigationItem.hidesBackButton = YES;
   
    
   self.sub_view.layer.cornerRadius = 10;
    self.sub_view.layer.borderWidth =1;
    
   // self.sub_view.layer.borderColor = [UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0].CGColor;
    
    
    self.sub_view.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    
    

    
    
    self.btn.layer.cornerRadius=8;
    simple_tbleView.layer.cornerRadius=8;
   // NSLog(@" the sites are:%@",self.sitesNameArr);
    
    // Do any additional setup after loading the view.
}


-(void)sitesArr:(NSNotification *)notification
{
    
    self.sitesNameArr = [ notification object];
    
    [self.simple_tbleView reloadData];
    
}
-(void)startLocating:(NSNotification *)notification


{
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.sitesNameArr = delegate.userProfiels.arrSites;
    

    
}

-(void)receiveNotofication:(NSNotification *)notification
{
    
    
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
   // cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
    cell.textLabel.text = site.siteName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES; // As alternative you can also make it multi-line.
    cell.textLabel.minimumScaleFactor = 0.1;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
   cell.textLabel.textColor = [UIColor purpleColor];
    
  //  cell.textLabel.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
    
   // [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
    UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
   //   cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
     return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SiteData *site = [self.sitesNameArr objectAtIndex:indexPath.row];
    
    
    LoadSelectionViewController *LoadSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSelectionVC"];
    

    LoadSelectionVC.siteName = site.siteName;
    LoadSelectionVC.siteData = site;
    
  
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.siteDatas =  site;
    delegate.count = 0;
    LoadSelectionVC.count = delegate.count;
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
          [self.navigationController pushViewController:LoadSelectionVC animated:YES];


}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    self.btn=nil;
    self.simple_tbleView=nil;
    self.i=nil;
    
    [super viewDidUnload];
    
}






@end
