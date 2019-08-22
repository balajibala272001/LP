//
//  UserIDViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/24/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "UserIDViewController.h"

#import "SiteViewController.h"


#import "KeychainItemWrapper.h"


@interface UserIDViewController ()

@end

@implementation UserIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.userid_txt.delegate = self;
    
    self.sub_View.layer.cornerRadius = 10;
    self.sub_View.layer.borderWidth =1;
    
    self.sub_View.layer.borderColor = [UIColor colorWithRed:39/255.0 green:149/255.0 blue:215/255.0 alpha:1.0].CGColor;
    

    
    self.btn1.layer.cornerRadius = 10;
    self.btn1.layer.borderWidth =1;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_ClickMe:(id)sender {
    
    
    NSString *userid = self.userid_txt.text;
    
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"YourAppLogin" accessGroup:nil];
    
    [keyChain setObject:userid forKey:(__bridge id)(kSecAttrAccount)];

    NSString *str = [keyChain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    
    NSLog(@" the user is:%@",str);
    
    SiteViewController *SiteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
    //PictureVC.imageArray = self.imageArray;
    
    [self.navigationController pushViewController:SiteVC animated:YES];

    
    
}
@end
