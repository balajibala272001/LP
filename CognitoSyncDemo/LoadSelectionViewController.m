//
//  LoadSelectionViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 2/15/17.
//  Copyright © 2017 Behroozi, David. All rights reserved.
//

#import "LoadSelectionViewController.h"
#import "CameraViewController.h"

#import "StaticHelper.h"


#import "AZCAppDelegate.h"
#import "UploadViewController.h"

#import "LoadSelectionTableViewCell.h"
@interface LoadSelectionViewController ()

@end

@implementation LoadSelectionViewController
{
    CGFloat xaxis,yaxis;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.siteName = [[NSUserDefaults standardUserDefaults] stringForKey:@"siteName"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new" object:nil];
    xaxis = 60;
    yaxis = 130;
    
//    self.arrayDisplayOldValues = [[NSMutableArray alloc]init];
    self.dict = [[NSMutableDictionary alloc]init];
    
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];

    [self.load_Table_View setSeparatorColor:[UIColor clearColor]];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = @"Load Selection";
    //titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.adjustsFontSizeToFitWidth = YES; // As alternative you can also make it multi-line.
    titleLabel.minimumScaleFactor = 0.1;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    [StaticHelper setLocalizedBackButtonForViewController:self];
    
    self.navigationItem.hidesBackButton = NO;
    //notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(park:) name:@"park" object:nil];
    self.imageArray =[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"uploaded" object:nil];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{

    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@" delegate:%lu",delegate.DisplayOldValues.count);
//    int count = delegate.count;
//    if (count>0) {
        [self.load_Table_View reloadData];
//    }
    
    if (delegate.DisplayOldValues.count == 5) {
        //self.Load_btn.hidden = YES;
        self.Load_btn.enabled = NO;
    }
    else
    {
        self.Load_btn.enabled = YES;
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

- (IBAction)Load_btn_action:(id)sender {
    
    CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    CameraVC.siteData = self.siteData;
    CameraVC.siteName = self.siteName;
    // CameraVC.tapCount = 0;
    delegate.ImageTapcount = 0;
    delegate.isNoEdit = YES;
    [self.navigationController pushViewController:CameraVC animated:YES];
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
            [delegate.DisplayOldValues removeObjectAtIndex:self.tag];
            int count = delegate.count;
            count -- ;
            delegate.count = count;
            [self.load_Table_View reloadData];
        }
    }
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    // the user clicked OK
//    if (buttonIndex == 0) {
//        
//        
//        AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//        delegate.count = 0;
//    
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//        // do something here...
//    }
//}
- (IBAction)back_action_btn:(id)sender {
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (delegate.DisplayOldValues.count > 0) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Pressing Back button will delete all the pictures that have not been uploaded to the server. Do you want to proceeed?" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
            delegate.count = 0;
            [delegate.DisplayOldValues removeAllObjects];
            [[AZCAppDelegate sharedInstance] clearSavedParkLoads];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:true completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma -mark Tableview Methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.sitesNameArr count];
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    return delegate.DisplayOldValues.count;
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
    self.dict = [delegate.DisplayOldValues objectAtIndex:indexPath.row];
    int count = delegate.count;
    
    if (delegate.DisplayOldValues.count  == 5) {
        //self.Load_btn.hidden = YES;
        self.Load_btn.enabled = NO;
    }
    else
    {
        self.Load_btn.enabled = YES;
    }

    //Getting field label
    
    SiteData *sitess = self.siteData;
    
    self.metaData = sitess.arrFieldData;
    
    
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
    
    
    
    
    
    if (fields.count >1) {
        DictFields1 =[fields objectAtIndex:0];
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        ;
        
        if (fieldId1 == old_field_id1 ) {
            
            NSString *fieldval1 = [DictFields1 objectForKey:@"field_value"];
            
            self.field_value1 =[NSString stringWithFormat:@"%@:%@",field_label1,fieldval1];
            
        }
        DictFields2 = [fields objectAtIndex:1];
        fieldId2 = fieldData2.fieldId;
        field_label2 =fieldData2.strFieldLabel;
        
        old_field_id2 =[[DictFields2 objectForKey:@"field_id"] intValue];
        
        
        if (fieldId2 == old_field_id2) {
            
            NSString *fieldval2 = [DictFields2 objectForKey:@"field_value"];
            
            self.field_value2 =[NSString stringWithFormat:@"%@:%@",field_label2,fieldval2];
            
        }
        
        
        
        
    }
    else
    {
        fieldId1 = fieldData1.fieldId;
        field_label1 =fieldData1.strFieldLabel;
        
        fields = [self.dict objectForKey:@"fields"];
        DictFields1 =[fields objectAtIndex:0];
        
        
        old_field_id1 = [[DictFields1 objectForKey:@"field_id"] intValue];
        
        
        if (fieldId1 == old_field_id1 ) {
            
            
            
            NSString *fieldval1 = [DictFields1 objectForKey:@"field_value"];
            
            self.field_value1 =[NSString stringWithFormat:@"%@:%@",field_label1,fieldval1];
            
            
        }
        
        // DictFields2 = [fields objectAtIndex:1];
        
    }
    
    
    
    int x= 30;
    int y = 30;
    int width = 270;
    int height =130;
    
    
    
    
    UIButton *loadBtn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
    loadBtn.tag = 1;
    loadBtn.backgroundColor = [UIColor whiteColor];
    loadBtn.layer.cornerRadius = 10;
    loadBtn.layer.borderWidth =3;
    
    
    loadBtn.layer.borderColor = [UIColor colorWithRed:20/255.0 green:126/255.0 blue:132/255.0 alpha:1.0].CGColor;
    [loadBtn addTarget:self action:@selector(Loads:) forControlEvents:UIControlEventTouchUpInside];
    [loadBtn setTag:indexPath.row];
    
    
    
    //Cretaing a label1-Meta Data1
    UILabel *meta_Data1 =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 40)];
    
    meta_Data1.backgroundColor = [UIColor colorWithRed:20/255.0 green:126/255.0 blue:132/255.0 alpha:1.0]  ;
    meta_Data1.text = self.field_value1;
    meta_Data1.textColor = [UIColor whiteColor];
    [meta_Data1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    meta_Data1.textAlignment = NSTextAlignmentCenter;
    meta_Data1.adjustsFontSizeToFitWidth=YES;
    meta_Data1.minimumScaleFactor=0.5;
    
    UILabel *meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(15, 80, 120, 40)];
    if (fields.count >1) {
        
        //Creating a Label1-Meta Data2
        // UILabel *meta_Data2 =[[UILabel alloc]initWithFrame:CGRectMake(15, 80, 90, 40)];
        meta_Data2.backgroundColor = [UIColor colorWithRed:20/255.0 green:126/255.0 blue:132/255.0 alpha:1.0]  ;
        meta_Data2.text = self.field_value2;
        meta_Data2.textColor = [UIColor whiteColor];
        [meta_Data2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        meta_Data2.textAlignment = NSTextAlignmentCenter;
        meta_Data2.adjustsFontSizeToFitWidth=YES;
        meta_Data2.minimumScaleFactor=0.5;
    }
    
    //Creating a Button -Delete Button
    UIButton *delete_button =[[UIButton alloc]initWithFrame:CGRectMake(230, 4, 30, 30)];
    
    [delete_button setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [delete_button addTarget:self action:@selector(deleteLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    [delete_button setTag:indexPath.row];
    
    
    
    //creating label for diaplaying image count
    UILabel *image_Count  =[[UILabel alloc]initWithFrame:CGRectMake(180, 70, 90, 30)];
    
    image_Count.text =[NSString stringWithFormat:@"%@ Photos",str_image_count];
    // [image_Count setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    //Cretaing label for displaying the time
    
    UILabel *parked_time  =[[UILabel alloc]initWithFrame:CGRectMake(150, 90, 110, 30)];
    
    parked_time.text = [NSString stringWithFormat:@"Parked at %@",parkedTime];
    
    [parked_time setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    
    [loadBtn addSubview:parked_time];
    
    [loadBtn addSubview:image_Count];
    [loadBtn addSubview:delete_button];
    [loadBtn addSubview:meta_Data1];
    
    if (fields.count >1) {
        
        [loadBtn addSubview:meta_Data2];
        
    }
    
    
    [cell addSubview:loadBtn];
    
    
    
    
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}

-(IBAction)deleteLoad:(id)sender
{
    //    UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Deleting the load will delete all the pictures in the load, continue?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    UIButton *btn = (UIButton *)sender;
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Deleting the load will delete all the pictures in the load, continue?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
            NSDictionary *_oldDict = [delegate.DisplayOldValues objectAtIndex:btn.tag];

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
            if (parkLoadArray.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:parkLoadArray forKey:@"ParkLoadArray"];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [delegate.DisplayOldValues removeObjectAtIndex:btn.tag];
            int count = delegate.count;
            count -- ;
            delegate.count = count;
            [self.load_Table_View reloadData];
            
            parkLoadArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ParkLoadArray"] mutableCopy];
            if (parkLoadArray == nil || parkLoadArray.count == 0) {
                [[AZCAppDelegate sharedInstance] clearLastSavedLoad];
            }
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        [cancel setValue:[UIColor greenColor] forKey:@"titleTextColor"];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //    alert2.tag = 102;
    //    
    //    [alert2 show];
    //
    //    UIButton *btn = (UIButton *)sender;
    //    self.tag = (int)btn.tag;
}



-(IBAction)Loads:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
    
    // NSIndexPath *selectedIndexPath = [self.load_Table_View indexPathForSelectedRow];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    // arr =[delegate.DisplayOldValues objectAtIndex:selectedIndexPath.row];
    
    arr = [delegate.DisplayOldValues objectAtIndex:btn.tag];
    
    
    //delegate.LoadNumber = selectedIndexPath.row;
    delegate.LoadNumber =(int) btn.tag;
    delegate.isNoEdit = NO;
    
    NSLog(@"dLoadNumber:%d",delegate.LoadNumber);
    
    
    CameraVC.siteData = self.siteData;
    CameraVC.siteName = self.siteName;
    CameraVC.arrr = arr;
    CameraVC.tapCount = delegate.ImageTapcount;
    
    self.dict = [delegate.DisplayOldValues objectAtIndex:btn.tag];
    CameraVC.oldDict = self.dict;
    CameraVC.isEdit = YES;
    
    //self.loadNumber = (int)btn.tag;
    
    NSLog(@" load number :%d",self.loadNumber);
    
    // CameraVC.load_number = (int)btn.tag ;
    CameraVC.load_number = self.loadNumber;
    // [self.load_Table_View deselectRowAtIndexPath:btn.tag animated:YES];
    
    [self.navigationController pushViewController:CameraVC animated:YES];
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
            if (delegate.DisplayOldValues.count > 0) {
                if (delegate.isEdit) {
                    [delegate.DisplayOldValues removeObjectAtIndex:delegate.LoadNumber];
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
