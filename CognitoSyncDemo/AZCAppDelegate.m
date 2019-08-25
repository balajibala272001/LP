



/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "AZCAppDelegate.h"



#import "UserIDViewController.h"
#import "SiteViewController.h"



//Passcode screen header file

#import "PPPinPadViewController.h"
#import "KeychainItemWrapper.h"
#import "CognitoHomeViewController.h"
#import "PasscodePinViewController.h"

@implementation AZCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
//    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Login" accessGroup:nil];
//    
//       NSString *str = [keyChain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    self.displayData = [[NSMutableArray alloc]init];
    self.DisplayOldValues = [[NSMutableArray alloc]init];
    
    
    self.count = 0;
    
    NSString *str = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];
    
    
    if (str.length > 0){
           
            
        //self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UINavigationController *controller = (UINavigationController*)[self.window.rootViewController.storyboard
                                                                                            instantiateViewControllerWithIdentifier: @"NavigationBar"];
            

            self.window.rootViewController = controller;
            //[self.window makeKeyAndVisible];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            PasscodePinViewController *PasscodePinViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
            [self.window.rootViewController presentViewController:
             PasscodePinViewController animated:YES completion:nil];
            
            

        });
        
}return YES;
    
}


-(void)applicationDidEnterBackground:(UIApplication *)application
{

//    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Login" accessGroup:nil];
//    
//    NSString *str = [keyChain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];

    if (str.length >0){
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PasscodePinViewController *PasscodePinViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
              [self.window.rootViewController presentViewController:PasscodePinViewController animated:NO completion:nil];
    }
    

}

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
  
}

- (NSInteger)pinLenght {
    return 4;
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

+(instancetype)sharedInstance
{
    return (AZCAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSMutableString*)getUserDocumentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[paths objectAtIndex:0]];
    return path;
}

-(void) clearLastSavedLot {
    NSMutableString *path = [self getUserDocumentDir];
    [path appendString:@"/CurrentLot"];
    BOOL isDeleted =  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSLog(@"isDeleted: %@",@(isDeleted));
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
}




@end
