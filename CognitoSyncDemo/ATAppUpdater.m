//
//  ATAppUpdater.m
//  versionupdate
//
//  Created by mac on 23/06/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//

#import "ATAppUpdater.h"
#import "SCLAlertView.h"
#import "Constants.h"
#import "AZCAppDelegate.h"

@interface ATAppUpdater ()
{    SCLAlertView* alert;
    NSDate *nextDate;
    NSDate *newdate;
    int seconds;
    int minutes;
    int hours;
    NSString *dateString;
    NSString * time;
    NSTimer *timer;
    bool force;
}
@end

@implementation ATAppUpdater


#pragma mark - Init


+ (id)sharedUpdater
{
    static ATAppUpdater *sharedUpdater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUpdater = [[ATAppUpdater alloc] init];
    });
    return sharedUpdater;
}

- (id)init
{
    self = [super init];
    //forceTo = NO;
    force = [[NSUserDefaults standardUserDefaults] boolForKey:@"forceTo"];
    if (self) {
        self.alertTitle = NSLocalizedString(@"New Version",@"");
        self.alertMessage = NSLocalizedString(@"A new update is available. Please update.",@"");
        self.alertUpdateButtonTitle = NSLocalizedString(@"Update",@"");
        self.alertCancelButtonTitle = NSLocalizedString(@"Skip",@"");
    }
    return self;
}


#pragma mark - Instance Methods

- (void)showUpdateWithConfirmation
{
    BOOL hasConnection = [self hasConnection];
    if (!hasConnection) return;
    
    [self checkNewAppVersion:^(BOOL newVersion, NSString *version) {
        if (newVersion){
            NSLog(@"force:%d",self->force);
            [self alertUpdateForVersion:version withForce:self->force];

        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"forceTo"];
            self->force = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"date2"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
}

- (void)updateController:(UIViewController *)u_controller{
    self.controller = u_controller;
}
//- (void)showUpdateWithConfirmationOnce
//{
//    BOOL hasConnection = [self hasConnection];
//    if (!hasConnection) return;
//
//    [self checkNewAppVersion:^(BOOL newVersion, NSString *version) {
//        if (newVersion){
//            NSString *keyUD_versionPromptInfo = @"versionPromptInfo";
//            NSString *keyPromptInfo_version = @"version";
//            NSString *keyPromptInfo_date = @"promptedAt";
//            NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:keyUD_versionPromptInfo];
//            NSString *versionPrompted = info[keyPromptInfo_version];
//
//            //not showing dialog, if prompted for this version already
//            BOOL showDialog = [versionPrompted isEqualToString:version] ? NO : YES;
//            if (showDialog) {
//                [self alertUpdateForVersion:version withForce:NO];
//                NSDictionary *newInfo = @{keyPromptInfo_version : version,
//                                          keyPromptInfo_date: [NSDate date]
//                                          };
//                [[NSUserDefaults standardUserDefaults] setObject:newInfo forKey:keyUD_versionPromptInfo];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
//    }];
//}


#pragma mark - Private Methods


- (BOOL)hasConnection
{
    const char *host = "itunes.apple.com";
    BOOL reachable;
    BOOL success;
    
    // Link SystemConfiguration.framework! <SystemConfiguration/SystemConfiguration.h>
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    reachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return reachable;
}

NSString *appStoreURL = nil;

- (void)checkNewAppVersion:(void(^)(BOOL newVersion, NSString *version))completion
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = bundleInfo[@"CFBundleIdentifier"];
    NSString *currentVersion = bundleInfo[@"CFBundleShortVersionString"];
    NSURL *lookupURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", bundleIdentifier]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        
        NSData *lookupResults = [NSData dataWithContentsOfURL:lookupURL];
        if (!lookupResults) {
            completion(NO, nil);
            return;
        }
        
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:lookupResults options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSUInteger resultCount = [jsonResults[@"resultCount"] integerValue];
            if (resultCount){
                NSDictionary *appDetails = [jsonResults[@"results"] firstObject];
                NSString *appItunesUrl = [appDetails[@"trackViewUrl"] stringByReplacingOccurrencesOfString:@"&uo=4" withString:@""];
                NSString *latestVersion = appDetails[@"version"];
                if ([latestVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                    appStoreURL = appItunesUrl;
                    completion(YES, latestVersion);
                } else {
                    completion(NO, nil);
                }
            } else {
                completion(NO, nil);
            }
        });
    });
}

- (void)alertUpdateForVersion:(NSString *)version withForce:(BOOL)force
{
        NSString *alertMessage = [NSString stringWithFormat:self.alertMessage, version];
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:self.alertUpdateButtonTitle target:self selector:@selector(updater:) backgroundColor:Green];
    [self.alertbox showSuccess:self.alertTitle subTitle:alertMessage closeButtonTitle:nil duration:1.0f ];
    NSDate *newdate = [NSDate date];
    nextDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"date2"];
    NSTimeInterval diff = [nextDate timeIntervalSinceDate:newdate];
    NSInteger total_seconds = diff;
   
    seconds = (total_seconds % 60);
    minutes = (total_seconds % 3600) / 60;
    hours = (total_seconds % 86400) / 3600;
    int days = (total_seconds % (86400 * 30)) / 86400;
    
    NSLog(@"diff %f",diff);
    NSLog(@"seconds %d",seconds);
    NSLog(@"minutes %d",minutes);
    NSLog(@"hours %d",hours);
    NSLog(@"days %d",days);
    NSLog(@"date2:%@",nextDate);
    //popup
    if((hours>0 || minutes > 0 || seconds > 0) || [[NSUserDefaults standardUserDefaults] objectForKey:@"date2"] == NULL)
    {
        [self.alertbox addButton:self.alertCancelButtonTitle target:self selector:@selector(cancel:) backgroundColor:Red];
    }
    NSLog(@"minutes1 %d",minutes);
    NSLog(@"force %d",force);
    NSLog(@"date2 %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"date2"]);
}

-(void)dismiss{
    [self.alertbox hideView];
}

-(void)updater:(id)sender
{
//    if(@available(iOS 10.0, *)){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
//    }else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
//                                                   options:@{}
//                                         completionHandler:^(BOOL success) {
//                }];
//    }
    if ([self.delegate respondsToSelector:@selector(appUpdaterUserDidLaunchAppStore)]) {
        [self.delegate appUpdaterUserDidLaunchAppStore];
    }
}

-(void)cancel:(id)sender
{
    //cancelPressed
    [self.alertbox hideView];

   /* newdate = [NSDate date];
    NSLog(@"newdate:%@",newdate);
    
    //date_Aft_24hrs
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    //dayComponent.minute = 15;
    nextDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"date2"];
    
    if(nextDate == nil){
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
        nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    [[NSUserDefaults standardUserDefaults] setObject:nextDate forKey:@"date2"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
       [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
       dateString = [dateFormatter stringFromDate:nextDate];
    NSLog(@"Current date is %@",dateString);
       NSLog(@"nextDate:%@",nextDate);

    
    //update count popup
    alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setHorizontalButtons:YES];
    [alert addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    newdate = [NSDate date];
    NSTimeInterval diff = [nextDate timeIntervalSinceDate:newdate];
    NSInteger total_seconds = diff;
   
    int seconds = (total_seconds % 60);
    int minutes = (total_seconds % 3600) / 60;
    int hours = (total_seconds % 86400) / 3600;
    NSString * timee = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];

    [alert showSuccess:@"Update Alert" subTitle:[NSString stringWithFormat:@"Update the app within 24 hours.\nRemaining time: %@",timee] closeButtonTitle:nil duration:2.0f ];


    //timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];


    if ([self.delegate respondsToSelector:@selector(appUpdaterUserDidCancel)]) {
        [self.delegate appUpdaterUserDidCancel];
    }*/
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void) handleTimer:(NSTimer *)timer {
  
    newdate = [NSDate date];
    NSTimeInterval diff = [nextDate timeIntervalSinceDate:newdate];
    NSInteger total_seconds = diff;
   
    seconds = (total_seconds % 60);
    minutes = (total_seconds % 3600) / 60;
    hours = (total_seconds % 86400) / 3600;
    int days = (total_seconds % (86400 * 30)) / 86400;
    
    NSLog(@"diff %f",diff);
    NSLog(@"seconds %d",seconds);
    NSLog(@"minutes %d",minutes);
    NSLog(@"hours %d",hours);
    NSLog(@"days %d",days);

    //popup
    if(hours<=0 && minutes <= 0 && seconds <= 0)
    {
        [self stopTimer];
       //[timer invalidate];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"forceTo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self->force = YES;
        [self showUpdateWithConfirmation];
    }else{
        time = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        NSString *subtitle = [NSString stringWithFormat:@"Update the app within 24 hours. \nRemaining time: %@",time];
        [alert updateSubTitle:subtitle];
    }
}

-(void)stopTimer{
    if(self.alertbox != nil){
    [self.alertbox hideView];
    }
    if(alert != nil){
        [alert hideView];
    }
    if(timer != nil && [timer isValid]){
        [timer invalidate];
    }
    timer = nil;
}
@end
