



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
#import "Reachability.h"
#import "KeychainItemWrapper.h"
#import "PPPinPadViewController.h"
#import "CognitoHomeViewController.h"
#import "PasscodePinViewController.h"
#import "UserIDViewController.h"
#import "SiteViewController.h"
#import "LoadSelectionViewController.h"
#import "CameraViewController.h"
#import "PicViewController.h"
#import "ProjectDetailsViewController.h"
#import "UploadViewController.h"
#import "ServerUtility.h"
#import "DriverCameraViewController.h"

@import Firebase;
@import FirebaseDynamicLinks;


@implementation AZCAppDelegate
<<<<<<< HEAD
=======


>>>>>>> main

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FIRApp configure];
    [[UIButton appearance] setExclusiveTouch:YES];

<<<<<<< HEAD

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FIRApp configure];
    [[UIButton appearance] setExclusiveTouch:YES];
=======
>>>>>>> main
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
       [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
       // [[UINavigationBar appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    //single_device_login
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSString * accessVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
        if(![accessVersion isEqualToString:@"v1"] && ![accessVersion isEqualToString:@"v2"]){
            NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
            bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
            if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
                [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
            }
        }
    }
    [self createImageDirectory];
    _isEnterForegroundCamera = YES;
    _isEnterForegroundVideo = YES;
    self.displayData = [[NSMutableArray alloc]init];
    self.count = 0;
    NSString *str = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];
    NSString *offstr = [[NSUserDefaults standardUserDefaults]stringForKey:@"OfflineUser"];
    BOOL isLoggedIn=[[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
    
    if ((str.length > 0 || offstr.length>0 ) && isLoggedIn==YES &&  !([self.CurrentVC  isEqual: @"HomeVC"] || [self.CurrentVC isEqual: @"AboutVC"] || [self.CurrentVC isEqual: @"PinVC"])){
        
        UINavigationController *controller =(UINavigationController*)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier: @"NavigationBar"];
        self.window.rootViewController = controller;
        NSLog(@"viewcontroller name %@",controller);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PasscodePinViewController *PasscodePinViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
            if (@available(iOS 13.0, *)){
                [PasscodePinViewController setModalPresentationStyle:UIModalPresentationFullScreen];
            }
            [self.window.rootViewController presentViewController:PasscodePinViewController animated:YES completion:nil];
        });
    }
    
<<<<<<< HEAD
 

    
    return YES;

}
=======
    return YES;

}

>>>>>>> main

-(void) handleTimer:(NSTimer *)timer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];    
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSString *cid= [[NSUserDefaults standardUserDefaults] objectForKey:@"cID"];
    NSString *uid= [[NSUserDefaults standardUserDefaults] objectForKey:@"uID"];
    NSString * accessVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
    NSString * corpid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CorporateLevel"];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
    bool boolvalue;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLocation"]){
        boolvalue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        NSLog(@"boolSingle:%d",boolvalue);
    }else{
        boolvalue = FALSE;
        NSLog(@"boolSingle:%d",boolvalue);
    }

    if(!([delegate.CurrentVC  isEqual: @"PassVC"] || [delegate.CurrentVC  isEqual: @"PinVC"] || [delegate.CurrentVC  isEqual: @"AboutVC"] || [delegate.CurrentVC  isEqual: @"HomeVC"]
         || [delegate.CurrentVC isEqual:@"Upload_btn_VC"]
         || [delegate.CurrentVC isEqual:@"DriverCameraVC"] || [delegate.CurrentVC isEqual:@"DriverPicviewVC"] || [delegate.CurrentVC isEqual:@"DriverMetaDataVC"] || [delegate.CurrentVC isEqual:@"DriverUploadVC"] || [delegate.CurrentVC isEqual:@"Driver_Upload_btn_VC"])
       && corpid != nil && isLoggedIn == YES)
    {
        [ServerUtility deviceLastseenWithCid:cid withUid:uid withcorpid:corpid withaccessVersion:accessVersion withBoolvalue:boolvalue andCompletion:^(NSError * error ,id data,float dummy){
           AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
           delegate.isMaintenance=NO;
           if (!error)
           {
                NSLog(@"App delegate data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    NSLog(@"currentVC:%@",delegate.CurrentVC);
                    NSLog(@"newDateStringstatus:%@",newDateString);

                }else{
                    if([data valueForKey:@"multi_device"]){
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
                        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"] subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:-100 ];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        PasscodePinViewController *PasscodePinViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
                        if (@available(iOS 13.0, *)) {
                            [PasscodePinViewController setModalPresentationStyle:UIModalPresentationFullScreen];// = YES
                        }
                        [self.window.rootViewController presentViewController:PasscodePinViewController animated:NO completion:nil];
                    }else{
                        NSLog(@"Error:%@",error);
                    }
                }
            }
        }];
    }
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
       [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    if([delegate.CurrentVC  isEqual: @"PassVC"]){
        if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            //Calling Api_SiteMaintenance
            NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
            [ServerUtility websiteMaintenance:^(NSError * error ,id data,float dummy){
                if (!error) {
                    //Printing the data received from the server
                    NSLog(@"PinSCreenData_siteMaintenance:%@",data);
                    bool maintenance = [[data objectForKey:@"maintenance"]boolValue];
                    int levelInt  = [[data objectForKey:@"level"]intValue];
                    NSString *level = [NSString stringWithFormat:@"%d",levelInt];
                    if(maintenance == TRUE){
                        if([level isEqualToString: @"1"] || [level isEqualToString: @"1.0"]){
                            [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                        }else if([level isEqualToString: @"2"] || [level isEqualToString: @"2.0"]){
                            [[NSUserDefaults standardUserDefaults]setObject:@"True2" forKey:@"maintenance_stage"];
                        }else{
                            if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                                self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                                [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                                [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                            }
                            [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                        }
                    }else{
                        if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                            [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                            [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                        }
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                } else {
                    NSString *str_error = error.localizedDescription;
                    if([str_error containsString:@"404"]){
                        [[NSUserDefaults standardUserDefaults]setObject:@"True1" forKey:@"maintenance_stage"];
                    }else{
                        if([maintenance_stage isEqualToString: @"True1"] || [maintenance_stage isEqualToString:@"True2"] ){
                            self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                            [self.alertbox addButton: NSLocalizedString(@"OK", @" ") target:self selector:@selector(dummy:) backgroundColor:Blue];
                            [self.alertbox showSuccess:NSLocalizedString(@"LoadProof Cloud is Up", @"") subTitle:NSLocalizedString(@"Thank You for your patience Loadproof cloud is up and you can proceed with your upload", @" ") closeButtonTitle:nil duration:1.0f ];
                        }
                        [[NSUserDefaults standardUserDefaults]setObject:@"False" forKey:@"maintenance_stage"];
                    }
                }
            }];
        }
    }
    if (self.bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
    UIViewController *currentView = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSLog(@"currentView:%@",currentView);
    _isEnterForegroundCamera = YES;
    _isEnterForegroundVideo = YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
       [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
<<<<<<< HEAD
=======
    [ServerUtility cancelUpload];
>>>>>>> main
    _isEnterForground = YES;
    NSMutableDictionary *currentLotRelatedData = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"currentLotRelatedData"] mutableCopy];
    NSString *offstr = [[NSUserDefaults standardUserDefaults]stringForKey:@"OfflineUser"];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];

    if (currentLotRelatedData==nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationEnterBackGround" object:nil userInfo:nil];
        NSString *str = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_name"];
        if ((str.length > 0 || offstr.length>0) && !([self.CurrentVC  isEqual: @"HomeVC"] || [self.CurrentVC isEqual: @"AboutVC"] || [self.CurrentVC isEqual: @"PinVC"]|| [self.CurrentVC isEqual: @"DriverCameraVC"]|| [self.CurrentVC isEqual: @"DriverPicviewVC"]|| [self.CurrentVC isEqual: @"DriverUploadVC"]|| [self.CurrentVC isEqual: @"DriverMetaDataVC"]||  [self.CurrentVC isEqual: @"Driver_Upload_btn_VC"]) && isLoggedIn == YES){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PasscodePinViewController *PasscodePinViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
            if (@available(iOS 13.0, *)) {
                [PasscodePinViewController setModalPresentationStyle:UIModalPresentationFullScreen];// = YES
            }
            [self.window.rootViewController presentViewController:PasscodePinViewController animated:NO completion:nil];
        }
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLocation"];

        NSLog(@"Moves to Background");
        __block UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background Time:%f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];           backgroundTaskIdentifier = backgroundTaskIdentifier;}];
    }
    self.bgTask = UIBackgroundTaskInvalid;
}


- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
}

- (NSInteger)pinLenght {
    return 4;
}


+(instancetype)sharedInstance {
    return (AZCAppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL) createImageDirectory {
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    NSLog(@"createpath:%@",path);
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
}


- (void) clearCurrentLoad { // should clear images in current load only
    NSDictionary* currentLotRelatedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"] mutableCopy];
    NSLog(@"Mythi Clear current Load : %@",currentLotRelatedData);
    NSMutableArray* imagesArray = [currentLotRelatedData objectForKey:@"img"];
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];

    for (NSDictionary* dic in imagesArray) {
        NSString* imageName = [dic valueForKey:@"imageName"];
        NSString* imagePath = [path stringByAppendingPathComponent:imageName];
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
}

- (void) clearAllLoads { // should clear all images
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ParkLoadArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentLotRelatedData"];
    NSLog(@"Mythi ClearALLLoad");
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:LoadImagesFolder];
    BOOL isDeleted =  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSLog(@"isDeleted: %@",@(isDeleted));
    [self createImageDirectory];
}

- (BOOL) hasCurrentLoad {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"];
}

- (BOOL) hasParkedLoad:(BOOL)add_on7 {
    //if(add_on7){
   //     return [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"] || [];
   // }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
}

- (NSMutableString*)getUserDocumentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [[paths objectAtIndex:0] mutableCopy];
    return path;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
       [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
  return [self application:app
                   openURL:url
         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

//dyniamic link

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];

  if (dynamicLink) {
    if (dynamicLink.url) {
      // Handle the deep link. For example, show the deep-linked content,
      // apply a promotional offer to the user's account or show customized onboarding view.
      // [START_EXCLUDE]
      // In this sample, we just open an alert.
      [self handleDynamicLink:dynamicLink];
      // [END_EXCLUDE]
    } else {
      // Dynamic link has empty deep link. This situation will happens if
      // Firebase Dynamic Links iOS SDK tried to retrieve pending dynamic link,
      // but pending link is not available for this device/App combination.
      // At this point you may display default onboarding view.
    }
    return YES;
  }
  // [START_EXCLUDE silent]
  // Show the deep link that the app was called with.
  [self showDeepLinkAlertViewWithMessage:[NSString stringWithFormat:@"openURL:\n%@", url]];
  // [END_EXCLUDE]
  return NO;
}
// [END openurl]

// [START continueuseractivity]
- (BOOL)application:(UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:
#if defined(__IPHONE_12_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_12_0)
(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler {
#else
    (nonnull void (^)(NSArray *_Nullable))restorationHandler {
#endif  // __IPHONE_12_0
  BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                          completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                                       NSError * _Nullable error) {
                                                            // [START_EXCLUDE]
                                                            [self handleDynamicLink:dynamicLink];
                                                            // [END_EXCLUDE]
                                                          }];
  // [START_EXCLUDE silent]
  if (!handled) {
    // Show the deep link URL from userActivity.
    NSString *message = [NSString stringWithFormat:@"continueUserActivity webPageURL:\n%@",
                         userActivity.webpageURL];
    [self showDeepLinkAlertViewWithMessage:message];
  }
  // [END_EXCLUDE]
  return handled;
}
// [END continueuseractivity]

- (void)handleDynamicLink:(FIRDynamicLink *)dynamicLink {
  NSString *matchConfidence;
  if (dynamicLink.matchType == FIRDLMatchTypeWeak) {
    matchConfidence = @"Weak";
  } else {
    matchConfidence = @"Strong";
  }
    NSArray<NSString *> *keyValuePairs = [dynamicLink.url.absoluteString componentsSeparatedByString:@"&"];

      NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithCapacity:keyValuePairs.count];

      for (NSString *pair in keyValuePairs) {
          NSArray *keyValuePair = [pair componentsSeparatedByString:@"="];
          if (keyValuePair.count == 2) {
              NSString *key = keyValuePair[0];
              NSString *value = [keyValuePair[1] stringByRemovingPercentEncoding];
              [queryDictionary setObject:value forKey:key];
              [self driverCamera:value];
//              [self showDeepLinkAlertViewWithMessage:value];
              break;
          }
      }
}
    
- (void) driverCamera: (NSString *) message{
    NSDictionary *siteInfo = @{@"deeplinkData" : message};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationName" object:nil userInfo:siteInfo];
}

- (void)showDeepLinkAlertViewWithMessage:(NSString *)message {
    if([message containsString:@"sitedata="] && [message containsString:@"LP"]){
        [self driverCamera:message];
    }else {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Deep Link"
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        UIViewController *rootViewController = self.window.rootViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
}


@end
