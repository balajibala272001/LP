//
//  UserCategoryViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/15/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "UserCategoryViewController.h"
#import "UploadViewController.h"
#import "StaticHelper.h"

#import "AZCAppDelegate.h"

@interface UserCategoryViewController ()

@end

@implementation UserCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSDictionary *dict = self.wholeDictionar;
    
    int userACustomer = 0;
    // delegate.userProfiels.userACustomer =
    userACustomer = delegate.userProfiels.userACustomer;
    
    if (userACustomer == 1) {
        
        self.btn1.enabled = YES;
        self.btn2.enabled = NO;
        
        self.btn3.enabled = YES;
        self.btn4.enabled = NO;
        self.btn5.enabled = NO;
        
        self.btn2.backgroundColor = [UIColor lightGrayColor];
        self.btn4.backgroundColor = [UIColor lightGrayColor];
        self.btn5.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.btn1.enabled = YES;
        self.btn2.enabled = YES;
        self.btn3.enabled = YES;
        self.btn4.enabled = YES;
        self.btn5.enabled = YES;

    }
    
    if (dict.count > 0) {
        NSString *cate = [dict objectForKey:@"category"];
        if (cate.length > 0) {
            NSString *btn1_Tittle =self.btn1.titleLabel.text ;
            
            NSString *btn2_Tittle =self.btn2.titleLabel.text ;
            
            NSString *btn3_Tittle =self.btn3.titleLabel.text ;
            
            NSString *btn4_Tittle =self.btn4.titleLabel.text ;
            
            NSString *btn5_Tittle =self.btn5.titleLabel.text ;
            
            
            if ([cate isEqualToString:btn1_Tittle]) {
                
               
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 210, 5, 50,40 )];
               
                [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
                
                [self.btn1 addSubview: imageView];
                
                
            }
            
            
            else if ([cate isEqualToString:btn2_Tittle])
            {
               // [self.btn2 setHighlighted:YES];
               // [self.btn2 setSelected:YES];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 210, 5, 50,40 )];
              //  [imageView setBackgroundColor: [UIColor clearColor]];
                [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
                [self.btn2 addSubview: imageView];

            }
            
            else if ([cate isEqualToString:btn3_Tittle])
            {
               // [self.btn3 setHighlighted:YES];
               // [self.btn3 setSelected:YES];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 210, 5, 50,40 )];

                [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
                [self.btn3 addSubview: imageView];

            }
            
            else if ([cate isEqualToString:btn4_Tittle])
            {
                //[self.btn4 setHighlighted:YES];
               // [self.btn4 setSelected:YES];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 210, 5,50,40 )];
                //  [imageView setBackgroundColor: [UIColor clearColor]];
                [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
                [self.btn4 addSubview: imageView];

            }
            
            else if ([cate isEqualToString:btn5_Tittle])
            {
                //[self.btn5 setHighlighted:YES];
               // [self.btn5 setSelected:YES];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 210, 5, 50,40)];
                //  [imageView setBackgroundColor: [UIColor clearColor]];
                [imageView setImage:[UIImage imageNamed:@"greentick.png"]];
                [self.btn5 addSubview: imageView];

            }
            
        }
        

        
    }
    
    [self buttonAlignment];
    
    
    self.cloudView.layer.cornerRadius = 10;
    self.cloudView.layer.borderWidth =1;
    
  
    self.cloudView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    
    
    
    
    self.navigationItem.title = @"Category";
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    [StaticHelper setLocalizedBackButtonForViewController:self];

    // Do any additional setup after loading the view.
}


-(void)buttonAlignment
{
    
    if (IS_IPHONE_6) {
        
//    self.btn1.frame = CGRectMake(25, 92, 92, 45);//load
//    self.btn2.frame = CGRectMake(80, 190, 95, 45);//gema walk
//
//    self.btn3.frame = CGRectMake(25, 140, 121, 45);//quailtty issues
//    self.btn4.frame = CGRectMake(142,287,100,42);//safety incident
//    self.btn5.frame = CGRectMake(108, 240, 108, 45);//miscelleneous


        
        [self.btn1.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.btn1.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.btn1.layer setShadowOpacity:0.5];
        self.btn1.layer.cornerRadius = 5;
        
        
        
        [self.btn2.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.btn2.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.btn2.layer setShadowOpacity:0.5];
        self.btn2.layer.cornerRadius = 5;
        

        
        [self.btn3.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.btn3.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.btn3.layer setShadowOpacity:0.5];
        self.btn3.layer.cornerRadius = 5;
        
        
        [self.btn4.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.btn4.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.btn4.layer setShadowOpacity:0.5];
        self.btn4.layer.cornerRadius = 5;
        
        
        
        
        [self.btn5.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.btn5.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.btn5.layer setShadowOpacity:0.5];
        self.btn5.layer.cornerRadius = 5;


    }
    else
    {
        
    
    [self.btn1.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.btn1.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.btn1.layer setShadowOpacity:0.5];
    self.btn1.layer.cornerRadius = 5;
    
    
    
    [self.btn2.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.btn2.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.btn2.layer setShadowOpacity:0.5];
    self.btn2.layer.cornerRadius = 5;
    
    
    [self.btn3.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.btn3.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.btn3.layer setShadowOpacity:0.5];
    self.btn3.layer.cornerRadius = 5;
    
    
    [self.btn4.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.btn4.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.btn4.layer setShadowOpacity:0.5];
    self.btn4.layer.cornerRadius = 5;
    

    [self.btn5.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.btn5.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.btn5.layer setShadowOpacity:0.5];
    self.btn5.layer.cornerRadius = 5;
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)labelAlignment
{
    [self.btn1 setTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    [self.btn2 setTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    ////
    [self.btn3 setTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    //
    [self.btn4 setTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    [self.btn5 setTransform:CGAffineTransformMakeRotation(-M_PI_4)];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_Load:(id)sender {
    
    
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    
    
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Load";
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit =self.isEdit;
    
    
    [self.navigationController pushViewController:UploadVC animated:YES];

    
    
}

-(IBAction)next:(id)sender
{
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    
    
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Load";
    
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit = self.isEdit;
    
    
    [self.navigationController pushViewController:UploadVC animated:YES];
    

}


- (IBAction)btn_Safetyincident:(id)sender {
    
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Gemba Walk";
    
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit =self.isEdit;

    [self.navigationController pushViewController:UploadVC animated:YES];
}

- (IBAction)btn_GembaWalk:(id)sender {
    
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Quality Issue";
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit =self.isEdit;

    [self.navigationController pushViewController:UploadVC animated:YES];
}

- (IBAction)btn_OqualityIssue:(id)sender {
    
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Safety Incident";
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit =self.isEdit;

    [self.navigationController pushViewController:UploadVC animated:YES];
}

- (IBAction)btn_miscellaneous:(id)sender {
    
    
    UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
    UploadVC.arrayWithImages = self.arrayOfImagesWithNotes;
    UploadVC.dictMetaData = self.dictMetaData;
    UploadVC.UserCategory = @"Miscellaneous";
    UploadVC.sitename = self.sitename;
    UploadVC.isEdit =self.isEdit;

    [self.navigationController pushViewController:UploadVC animated:YES];
}
-(IBAction)back_action_btn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
