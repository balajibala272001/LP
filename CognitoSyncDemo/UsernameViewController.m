//
//  UsernameViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/17/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "UsernameViewController.h"
#import "ABPadLockScreenView.h"
#import "ABPadButton.h"
#import "ABPinSelectionView.h"
#import "UIColor+HexValue.h"

//#import "ABPadLockScreenViewController.h"


@interface UsernameViewController ()

@end

@implementation UsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ABPadLockScreenView appearance] setBackgroundColor:[UIColor colorWithHexValue:@"282B35"]];
    
    UIColor* color = [UIColor colorWithRed:229.0f/255.0f green:180.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor whiteColor]];
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor blackColor]];
    [[ABPadButton appearance] setBackgroundColor:[UIColor clearColor]];
    [[ABPadButton appearance] setBorderColor:color];
    [[ABPadButton appearance] setSelectedColor:color];
    
    [[ABPinSelectionView appearance] setSelectedColor:color];

    
    
    
    // Do any additional setup after loading the view.
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

- (IBAction)btn_pin:(id)sender {
    
    

    ABPadLockScreenSetupViewController *lockScreen = [[ABPadLockScreenSetupViewController alloc] initWithDelegate:self complexPin:YES subtitleLabelText:@"You need a PIN to continue"];
    lockScreen.tapSoundEnabled = YES;
    lockScreen.errorVibrateEnabled = YES;
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
//    	Example using an image
//    	UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
//    	backgroundView.contentMode = UIViewContentModeScaleAspectFill;
//    	backgroundView.clipsToBounds = YES;
//    	[lockScreen setBackgroundView:backgroundView];
    
    [self presentViewController:lockScreen animated:YES completion:nil];

}
@end
