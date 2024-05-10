//
//  SplashViewController.m
//  CognitoSyncDemo
//
//  Created by SG's Mac on 17/04/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

#import "LogoViewController.h"
#import "CognitoHomeViewController.h"

@interface LogoViewController ()

@end

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self MoveToLogin];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)MoveToLogin {
    
    CognitoHomeViewController *cognitoVC =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    // Push the CognitoHomeViewController onto the navigation stack
        [self.navigationController pushViewController:cognitoVC animated:YES];
}

@end
