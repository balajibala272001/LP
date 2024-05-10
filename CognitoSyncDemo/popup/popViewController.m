//
//  popViewController.m
//  coredata
//
//  Created by mac on 30/07/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//

#import "popViewController.h"
#import "CognitoHomeViewController.h"
#import "Constants.h"
#import "AZCAppDelegate.h"
#import "SCLAlertView.h"
#import "SCLTextView.h"
#import "UIView+Toast.h"
#import "ServerUtility.h"

@interface popViewController ()<UIPopoverPresentationControllerDelegate> {
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

-(void)production_envi
{
    NSString *password=self.textField_live.text;
        NSLog(@"Password:%@",password);
        if ([password isEqual:pass]) {
            
            NSString *EnvironmentName=@"https://api.loadproof.us/api/v1";
            NSString* sitM_api = @"https://api.loadproof.us/";

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineCustomCategory"];
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]setValue:sitM_api forKey:@"siteMapi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.view makeToast:NSLocalizedString(@"Changed To Production",@"") duration:5.0 position:CSToastPositionCenter style:nil];
            if(self.switch_live.isSelected){
                NSLog(@"self.switch_live.isSelected:on");
                [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"internal_test_mode"];
            }else{
                NSLog(@"self.switch_live.isSelected:off");
                [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"internal_test_mode"];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [self.view makeToast:NSLocalizedString(@"Password Invalid",@"") duration:3.0 position:CSToastPositionCenter style:nil];
        }
}

-(void)preProduction_envi{
    
        NSString *password = self.textField_ppd.text;
        NSLog(@"Password:%@",password);
        if ([password isEqual:pass]) {

            NSString *EnvironmentName=@"http://ec2-54-204-9-153.compute-1.amazonaws.com/api/v1";
            NSString* sitM_api = @"http://ec2-54-204-9-153.compute-1.amazonaws.com/";

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineCustomCategory"];
            [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
            [[NSUserDefaults standardUserDefaults]setValue:sitM_api forKey:@"siteMapi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.view makeToast:NSLocalizedString(@"Changed To Pre-Production",@"") duration:5.0 position:CSToastPositionCenter style:nil];
            
            if(self.switch_ppd.isSelected){
                NSLog(@"self.switch_ppd.isSelected:on");
                [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"internal_test_mode"];
            }else{
                NSLog(@"self.switch_ppd.isSelected:off");
                [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"internal_test_mode"];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self.view makeToast:NSLocalizedString(@"Password Invalid",@"") duration:3.0 position:CSToastPositionCenter style:nil];
        }
}


-(void)site_envi{
    
    NSString *password=self.textField_site.text;
    NSLog(@"Password:%@",password);
    if ([password isEqual:pass]) {
        NSString *EnvironmentName=@"http://ec2-54-144-60-83.compute-1.amazonaws.com/loadproof/api/v1";
        NSString* sitM_api = @"http://ec2-54-144-60-83.compute-1.amazonaws.com/";
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineCustomCategory"];
        [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
        [[NSUserDefaults standardUserDefaults]setValue:sitM_api forKey:@"siteMapi"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.view makeToast:NSLocalizedString(@"Changed To Site",@"") duration:5.0 position:CSToastPositionCenter style:nil];
        
        if(self.switch_site.isSelected){
            NSLog(@"self.switch_site.isSelected:on");
            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"internal_test_mode"];
        }else{
            NSLog(@"self.switch_site.isSelected:off");
            [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"internal_test_mode"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        
        [self.view makeToast:NSLocalizedString(@"Password Invalid",@"") duration:2.0 position:CSToastPositionCenter style:nil];
    }
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)test_envi{
    
    NSString *password=self.textField_test.text;
    NSLog(@"password:%@",password);
    if ([password isEqual:pass]) {
        
        NSString *EnvironmentName=@"https://loadproof.info/loadproof/api/v1";
        NSString* sitM_api = @"https://loadproof.info/";

        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineUser"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflinePin"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineData"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"OfflineCustomCategory"];
        [[NSUserDefaults standardUserDefaults]setValue:EnvironmentName forKey:@"Environment"];
        [[NSUserDefaults standardUserDefaults]setValue:sitM_api forKey:@"siteMapi"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

        [self.view makeToast:NSLocalizedString(@"Changed To Test",@"") duration:5.0 position:CSToastPositionCenter style:nil];

        if(self.switch_test.isSelected){
            NSLog(@"self.switch_test.isSelected:on");
            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"internal_test_mode"];
        }else{
            NSLog(@"self.switch_test.isSelected:off");
            [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"internal_test_mode"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self.view makeToast:NSLocalizedString(@"Password Invalid",@"") duration:3.0 position:CSToastPositionCenter style:nil];
    }
}



- (IBAction)site:(UIButton*)button {
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];

    if([maintenance_stage isEqualToString:@"True2"]){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

        //textField
        self.textField_site = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_site.secureTextEntry = YES;

        //switch
        self.switch_site=[self.alertbox addSwitchViewWithLabel:NSLocalizedString(@"Internal Testing",@"")];

        if(internal_test_mode){
            self.switch_site.selected = TRUE;
        }

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(site_envi) backgroundColor:Green];

        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Site Server,\n Enter Password",@"") closeButtonTitle:nil duration:-100];

    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        
        //textField
        self.textField_site = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_site.secureTextEntry = YES;

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(site_envi) backgroundColor:Green];
        
        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Site Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }

}


- (IBAction)pre_prod:(UIButton*)button {
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults]boolForKey:@"internal_test_mode"];

    if([maintenance_stage isEqualToString:@"True2"]){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

        //textField
        self.textField_ppd = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_ppd.secureTextEntry = YES;

        //switch
        self.switch_ppd=[self.alertbox addSwitchViewWithLabel:NSLocalizedString(@"Internal Testing",@"")];


        if(internal_test_mode){
            self.switch_ppd.selected = TRUE;
        }

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(preProduction_envi) backgroundColor:Green];

        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Pre-Production Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        
        //textField
        self.textField_ppd = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_ppd.secureTextEntry = YES;

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(preProduction_envi) backgroundColor:Green];
        
        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Pre-Production Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }
    
}

- (IBAction)live:(UIButton*)button {
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults]boolForKey:@"internal_test_mode"];

    if([maintenance_stage isEqualToString:@"True2"]){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

        //textField
        self.textField_live = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_live.secureTextEntry = YES;

        //switch
        self.switch_live=[self.alertbox addSwitchViewWithLabel:NSLocalizedString(@"Internal Testing",@"")];

        if(internal_test_mode){
            self.switch_live.selected = TRUE;
        }
        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(production_envi) backgroundColor:Green];

        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Production Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        
        //textField
        self.textField_live = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_live.secureTextEntry = YES;

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"")target:self selector:@selector(production_envi) backgroundColor:Green];
        
        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Production Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }

}

- (IBAction)info:(UIButton*)button {
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults]boolForKey:@"internal_test_mode"];

    if([maintenance_stage isEqualToString:@"True2"]){
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];

        //textField
        self.textField_test = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_test.secureTextEntry = YES;

        //switch
        self.switch_test=[self.alertbox addSwitchViewWithLabel:NSLocalizedString(@"Internal Testing",@"")];
        if(internal_test_mode){
            self.switch_test.selected = TRUE;
        }
        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(test_envi) backgroundColor:Green];

        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Test Server",@"") closeButtonTitle:nil duration:1.0f];
    }else{
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        
        //textField
        self.textField_test = [self.alertbox addTextField:NSLocalizedString(@"Enter Password",@"") setDefaultText:nil];
        self.textField_test.secureTextEntry = YES;

        //button
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(test_envi) backgroundColor:Green];
        
        [self.alertbox showSuccess:NSLocalizedString(@"Enviroinment",@"") subTitle:NSLocalizedString(@"To Use Test Server,\n Enter Password",@"") closeButtonTitle:nil duration:1.0f];
    }

}



- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
