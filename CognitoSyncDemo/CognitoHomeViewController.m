
#import "CognitoHomeViewController.h"
#import "PasscodeViewController.h"
#import "PicViewController.h"
#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "KeychainItemWrapper.h"
#import "PPPinPadViewController.h"
#import "PasscodePinViewController.h"
#import "AboutViewController.h"
#import "ServerUtility.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"

@interface CognitoHomeViewController()





@end

#import "StaticHelper.h"
#import "SiteViewController.h"
@implementation CognitoHomeViewController

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    self.UserName_txt.delegate = self;
    self.UserName_txt.keyboardType = bold;
    
    self.UserName_txt.layer.cornerRadius =10;
    self.UserName_txt.layer.borderWidth = 1;
    self.UserName_txt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.Login_ok_pressed.layer.cornerRadius =10;
    self.Login_ok_pressed.layer.borderWidth =1;
    self.Login_ok_pressed.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    self.about_pressed.layer.cornerRadius =10;
    self.about_pressed.layer.borderWidth =1;
    self.about_pressed.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.Background_View.layer.cornerRadius = 10;
    self.Background_View.layer.borderWidth = 1;
    self.Background_View.layer.borderColor = [UIColor blackColor].CGColor;
    self.UserName_txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *strVersionString = [NSString stringWithFormat:@"v%@(%@)",appVersionString,appBuildString];
    
    
    //  [StaticHelper setLocalizedBackButtonForViewController:self];
    
    
    // self.version_lbl.text = strVersionString;
    // [self.view addSubview:self.version_lbl];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}









//****************************************************
#pragma mark - Action Methods
//****************************************************

- (IBAction)login_ok:(UIButton *)sender
{
    
    
    
    [self.UserName_txt resignFirstResponder];
    
    
    NSString *strUsername = self.UserName_txt.text;
    
    if (strUsername.length == 0) {
        [self.view makeToast:@"Invalid Username" duration:1.0 position:CSToastPositionCenter];
        
    }
    
    
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        __weak typeof(self) weakSelf =self;
        
        
        
        //Calling API to get username
        
        
        [ServerUtility getUserName:strUsername andCompletion:^(NSError * error ,id data){
            
            
            if (!error) {
                //Printing the data received from the server
                NSLog(@" the data are:%@",data);
                
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"]) {
                    
                    
                    PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                    
                    
                    
                    pinViewController.delegate = self;
                    
                    pinViewController.pinTitle = @"Enter PIN";
                    //pinViewController.errorTitle = @"Passcode is not correct";
                    pinViewController.cancelButtonHidden = NO; //default is False
                    pinViewController.userName = strUsername;
                    pinViewController.backgroundImage = [UIImage imageNamed:@""];
                    
                    
                    
                    
                    [self.navigationController pushViewController:pinViewController
                                                         animated:YES];
                    
                }
                else if ([strResType.lowercaseString isEqualToString:@"error"])
                    
                {
                    NSString *strMsg = [data objectForKey:@"msg"];
                    
                    [self.view makeToast:strMsg duration:1.0 position:CSToastPositionCenter];
                }
                
                
                
            }
            
            else{
                [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
                
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
        }];
        
        
    }
    
    
}



- (IBAction)about:(UIButton *)sender
{
    //    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    //    [self.navigationController pushViewController:aboutViewController animated:YES];
    
    // AboutViewController *aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
    // [self.navigationController pushViewController:aboutVC animated:YES];
    
}


#pragma delegate methods for next vc

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
}

- (NSInteger)pinLenght {
    return 4;
}

//****************************************************
#pragma mark - UITextFieldDelegate Methods
//****************************************************

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    NSString *strUsername = self.UserName_txt.text;
    
    if (strUsername.length == 0) {
        [self.view makeToast:@"Invalid Username" duration:1.0 position:CSToastPositionCenter];
        
        // [StaticHelper showAlertWithTitle:nil message:@"Invalid Username" onViewController:self];
    }
    
    else{
        
        NSString *string = self.UserName_txt.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        
        
        if (trimmedString.length == 0) {
            
            [StaticHelper showAlertWithTitle:nil message:@"Invalid Username" onViewController:self];
            
        }
        else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            __weak typeof(self) weakSelf =self;
            
            
            [ServerUtility getUserName:strUsername andCompletion:^(NSError * error ,id data){
                
                if (!error) {
                    //Printing the data received from the server
                    NSLog(@" the data are:%@",data);
                    
                    NSString *strResType = [data objectForKey:@"res_type"];
                    if ([strResType.lowercaseString isEqualToString:@"success"]) {
                        
                        
                        PPPinPadViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PPPinPadViewController"];
                        
                        
                        pinViewController.delegate = self;
                        pinViewController.pinTitle = @"Enter PIN";
                        pinViewController.errorTitle = @"Passcode is not correct";
                        pinViewController.cancelButtonHidden = NO; //default is False
                        pinViewController.self.userName = strUsername;
                        pinViewController.backgroundImage = [UIImage imageNamed:@""];
                        // [pinViewController setTintColor:[UIColor redColor]];
                        [self.navigationController pushViewController:pinViewController
                                                             animated:YES];
                        
                    }
                    else if ([strResType.lowercaseString isEqualToString:@"error"])
                        
                    {
                        NSString *strMsg = [data objectForKey:@"msg"];
                        
                        [self.view makeToast:strMsg duration:1.0 position:CSToastPositionCenter];
                    }
                    
                    
                    
                }
                
                else{
                    [self.view makeToast:@"Error" duration:1.0 position:CSToastPositionCenter];
                    
                }
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                
                
            }];
            
            
        }
        
        
    }
    
    
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        
    }
}



- (BOOL)canBecomeFirstResponder {
    
    
    return NO;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}




@end
