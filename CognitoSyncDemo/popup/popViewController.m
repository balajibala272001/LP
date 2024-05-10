//
//  popViewController.m
//  coredata
//
//  Created by mac on 30/07/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//

#import "pop1ViewController.h"
#import "pop2ViewController.h"
#import "popViewController.h"
#import "CognitoHomeViewController.h"
#import "Constants.h"
#import "AZCAppDelegate.h"

@interface popViewController ()<UIPopoverPresentationControllerDelegate> {
    pop1ViewController *pop1;
    pop2ViewController *pop2;
  //  pop3ViewController *pop3;
    CognitoHomeViewController * cc;
NSString * pass;
}
@end

@implementation popViewController

- (void)viewDidLoad {
    pass = @"Smart";

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}



-(void)ShowInputAlertWithM:(NSString *)msg
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"To Use Production Server" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alertVC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
       // subSubView.backgroundColor = [UIColor whiteColor];
    }
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         textField.placeholder=@"Password";
         textField.textColor=[UIColor blackColor];
         textField.layer.borderColor = [UIColor blackColor].CGColor;

         textField.clearButtonMode=UITextFieldViewModeWhileEditing;
         textField.secureTextEntry=true;
     }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alertVC addAction:cancel];
    
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Live");
        NSString *password=alertVC.textFields[0].text;
        NSLog(@"%@",password);
        if ([password isEqual:pass]) {
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Changed To Production" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];
            
            NSString *EnvironmentName=@"https://api.loadproof.us/api/v1";
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [aler2 show];
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self performSegueWithIdentifier:@"cc" sender:msg];

        }
        else{
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Password Invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];
            
            [aler2 show];
        }
    }];
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:true completion:nil];
    
}







-(void)ShowInputAlertWithMs:(NSString *)msg
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"To Use Pre-Production Server" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alertVC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
       // subSubView.backgroundColor = [UIColor whiteColor];
    }
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         textField.placeholder=@"Password";
         textField.textColor=[UIColor blackColor];
         textField.clearButtonMode=UITextFieldViewModeWhileEditing;
         textField.secureTextEntry=true;
         textField.layer.borderColor = [UIColor blackColor].CGColor;

     }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Pre-Prod");
        NSString *password=alertVC.textFields[0].text;
        NSLog(@"%@",password);
        if ([password isEqual:pass]) {
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Changed To Pre-Production" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];
            
            [aler2 show];
            
            NSString *EnvironmentName=@"http://ec2-54-204-9-153.compute-1.amazonaws.com/api/v1";
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self performSegueWithIdentifier:@"cc" sender:msg];

        }else{
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Password Invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];
            
            [aler2 show];
            
        }
    }];
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:true completion:nil];
    
}




-(void)ShowInputAlertWithMsg:(NSString *)msg
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"To Use Site Server" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alertVC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        
    }
    
    
[alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder=@"Password";
        textField.textColor=[UIColor blackColor];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.secureTextEntry=true;
        textField.layer.borderColor = [UIColor blackColor].CGColor;

    }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    

    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Info");
        NSString *password=alertVC.textFields[0].text;
        NSLog(@"%@",password);
        if ([password isEqual:pass]) {
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Changed To Site" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];

            [aler2 show];
            NSString *EnvironmentName=@"http://ec2-54-144-60-83.compute-1.amazonaws.com/loadproof/api/v1";
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self performSegueWithIdentifier:@"cc" sender:msg];

        }else{
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Password Invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];

            [aler2 show];
        }
    }];
    [alertVC addAction:action];

       [self presentViewController:alertVC animated:true completion:nil];
    

}

-(void)ShowInputAlertWithMsgs:(NSString *)msg
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"To Use Test Server" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alertVC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        
    }
    
    
[alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder=@"Password";
        textField.textColor=[UIColor blackColor];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.secureTextEntry=true;
        textField.layer.borderColor = [UIColor blackColor].CGColor;

    }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    

    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Info");
        NSString *password=alertVC.textFields[0].text;
        NSLog(@"%@",password);
        if ([password isEqual:pass]) {
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Changed To Test" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];

            [aler2 show];
            
            NSString *EnvironmentName=@"https://loadproof.info/loadproof/api/v1";
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self performSegueWithIdentifier:@"cc" sender:msg];

        }else{
            UIAlertView *aler2 = [[UIAlertView alloc] initWithTitle:@"" message:@"Password Invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            aler2.backgroundColor = [UIColor whiteColor];

            [aler2 show];
        }
    }];
    [alertVC addAction:action];

       [self presentViewController:alertVC animated:true completion:nil];
    

}





- (IBAction)site:(UIButton*)button {

    [self ShowInputAlertWithMsg:@"Enter Password"];


}
- (IBAction)pre_prod:(UIButton*)button {

    [self ShowInputAlertWithMs:@"Enter Password"];
    
}
- (IBAction)live:(UIButton*)button {
    
    [self ShowInputAlertWithM:@"Enter Password"];

}
- (IBAction)info:(UIButton*)button {

    [self ShowInputAlertWithMsgs:@"Enter Password"];


}




- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
