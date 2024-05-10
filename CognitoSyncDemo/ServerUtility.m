//
//  ServerUtility.m
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//

#import "ServerUtility.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import <objc/runtime.h>
#import "AZCAppDelegate.h"
#import "CameraViewController.h"
#import "HttpPostMultipart.h"


NSMutableArray *imglist;
NSMutableArray *myimagearray;
NSString *img;
<<<<<<< HEAD
=======
AFHTTPRequestOperationManager *manager1;
>>>>>>> main
int i;
@interface ServerUtility()
@end
@implementation ServerUtility
@synthesize picslist;

- (NSMutableArray *)picslist {
    imglist = picslist;
    NSLog(@"image name :%@",picslist);
    return picslist;
}

- (int *)picscount{
    NSLog(@"picscount :%d",_picsCount);
    i = *(self.picscount);
    return &i;
}
#pragma mark - Public Methods


//devictracker
+(void)getdevice_tracker:(NSString *)trackerId withOfflinedata:(NSMutableArray*) data withCid:(NSString *)cId withUid:(NSString *)uId withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    NSString *Os_name = @"iOS";
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * DeviceName = [UIDevice currentDevice].model;
    NSString * OSVersion = [UIDevice currentDevice].systemVersion;
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSError * err;
    NSData *nsdata = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&err];
    NSString * myString = [[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];
    
    NSDictionary *getLogout =@{
        @"c_id":cId,
        @"u_id":uId,
        @"latitude":lat,
        @"longitude":longi,
        @"Os_name":Os_name,
        @"Os_version":OSVersion,
        @"Device_name":DeviceName,
        @"Imei":str,
        @"Appversion":appVersionString,
        @"tracker_device_id":trackerId,
        @"Master":@(boolvalue),
        @"device_offline_details":myString
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlogout = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_OFFLINE_DEVICE_LOG];
    [self createPOSTRequestWithParams:getLogout urlString:strGetlogout andCompletion:completion];
<<<<<<< HEAD
}
//logout
+(void)getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cId withUid:(NSString *)uId withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    NSString *Os_name = @"iOS";
    NSDictionary *getLogout =@{
        @"c_id":cId,
        @"u_id":uId,
        @"tracker_device_id":trackerId,
        @"latitude":lat,
        @"longitude":longi,
        @"Master":@(boolvalue),
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlogout = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_LOGOUT];
    [self createPOSTRequestWithParams:getLogout urlString:strGetlogout andCompletion:completion];
}


//CustomCategory
+(void)getCid:(NSString *)cId withUid:(NSString *)uId  andCompletion:(GFWebServiceHandler)completion
{
    NSString *Os_name = @"iOS";
    NSDictionary *getCategory =@{
        @"c_id":cId,
        @"u_id":uId,
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetCategory = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_ADDON5];
    [self createPOSTRequestWithParams:getCategory urlString:strGetCategory andCompletion:completion];
}




//single_device_login
+(void)deviceLastseenWithCid:(NSString *)cId withUid:(NSString *)uId withcorpid:(NSString *)corpid withaccessVersion:(NSString *)accessVersion withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"c_id":cId,
        @"u_id":uId,
        @"app_access_version":accessVersion,
        @"corporate_level_plan":corpid,
        @"Imei":str,
        @"Master":@(boolvalue),
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_LASTSEEN];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
}

//single_device_login
+(void)driverLoadValidationCid:(NSString *)cId withLoadid:(NSString *)loadId andCompletion:(GFWebServiceHandler)completion{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"site_id":cId,
        @"load_id":loadId
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_DRIVER_SITE_VALIDATION];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
}

//get load centric data
+(void)getLoadCentricDataCid:(NSString *)qr_sId withLoadid:(NSString *)qr_loadId withsid:(NSString *)sId andCompletion:(GFWebServiceHandler)completion{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"qr_site_id":qr_sId,
        @"qr_load_id":qr_loadId,
        @"site_id":sId
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_GET_CENTRIC_DATA];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
=======
>>>>>>> main
}
//logout
+(void)getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cId withUid:(NSString *)uId withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    NSString *Os_name = @"iOS";
    NSDictionary *getLogout =@{
        @"c_id":cId,
        @"u_id":uId,
        @"tracker_device_id":trackerId,
        @"latitude":lat,
        @"longitude":longi,
        @"Master":@(boolvalue),
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlogout = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_LOGOUT];
    [self createPOSTRequestWithParams:getLogout urlString:strGetlogout andCompletion:completion];
}


<<<<<<< HEAD
NSString* deviceName()
{
=======
//CustomCategory
+(void)getCid:(NSString *)cId withUid:(NSString *)uId  andCompletion:(GFWebServiceHandler)completion
{
    NSString *Os_name = @"iOS";
    NSDictionary *getCategory =@{
        @"c_id":cId,
        @"u_id":uId,
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetCategory = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_ADDON5];
    [self createPOSTRequestWithParams:getCategory urlString:strGetCategory andCompletion:completion];
}




//single_device_login
+(void)deviceLastseenWithCid:(NSString *)cId withUid:(NSString *)uId withcorpid:(NSString *)corpid withaccessVersion:(NSString *)accessVersion withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"c_id":cId,
        @"u_id":uId,
        @"app_access_version":accessVersion,
        @"corporate_level_plan":corpid,
        @"Imei":str,
        @"Master":@(boolvalue),
        @"Os_name":Os_name
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_LASTSEEN];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
}

//single_device_login
+(void)driverLoadValidationCid:(NSString *)cId withLoadid:(NSString *)loadId andCompletion:(GFWebServiceHandler)completion{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"site_id":cId,
        @"load_id":loadId
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_DRIVER_SITE_VALIDATION];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
}

//get load centric data
+(void)getLoadCentricDataCid:(NSString *)qr_sId withLoadid:(NSString *)qr_loadId withsid:(NSString *)sId andCompletion:(GFWebServiceHandler)completion{
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *Os_name = @"iOS";

    NSDictionary *deviceLastseen =@{
        @"qr_site_id":qr_sId,
        @"qr_load_id":qr_loadId,
        @"site_id":sId
    };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetlastseen = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_GET_CENTRIC_DATA];
    [self createPOSTRequestWithParams:deviceLastseen urlString:strGetlastseen andCompletion:completion];
}

NSString* deviceName()
{
>>>>>>> main
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *name=[NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    NSString *actualName;
    if ([name isEqualToString:@"iPhone1,1"]) {
       actualName=@"iPhone";
    }else if ([name isEqualToString:@"iPhone1,2"]){
       actualName=@"iPhone 3G";
    }
    else if ([name isEqualToString:@"iPhone2,1"]){
        actualName=@"iPhone 3GS";
    }
    else if ([name isEqualToString:@"iPhone3,1"] || [name isEqualToString:@"iPhone3,2"] || [name isEqualToString:@"iPhone3,3"]){
        actualName=@"iPhone 4";
    }
    else if ([name isEqualToString:@"iPhone4,1"]){
        actualName=@"iPhone 4S";
    }
    else if ([name isEqualToString:@"iPhone5,1"] || [name isEqualToString:@"iPhone5,2"]){
        actualName=@"iPhone 5";
    }
    else if ([name isEqualToString:@"iPhone5,3"] || [name isEqualToString:@"iPhone5,4"]){
        actualName=@"iPhone 5c";
    }
    else if ([name isEqualToString:@"iPhone6,1"] || [name isEqualToString:@"iPhone6,2"]){
        actualName=@"iPhone 5S";
    }
    else if ([name isEqualToString:@"iPhone7,1"]){
        actualName=@"iPhone 6 Plus";
    }
    else if ([name isEqualToString:@"iPhone7,2"]){
        actualName=@"iPhone 6";
    }
    else if ([name isEqualToString:@"iPhone8,1"]){
        actualName=@"iPhone 6S";
    }
    else if ([name isEqualToString:@"iPhone8,2"]){
        actualName=@"iPhone 6S Plus";
    }
    else if ([name isEqualToString:@"iPhone8,4"]){
        actualName=@"iPhone SE";
    }
    else if ([name isEqualToString:@"iPhone9,1"]){
        actualName=@"iPhone 7 (CDMA)";
    }
    else if ([name isEqualToString:@"iPhone9,2"]){
        actualName=@"iPhone 7 (GSM)";
    }
    else if ([name isEqualToString:@"iPhone9,3"]){
        actualName=@"iPhone 7 Plus (CDMA)";
    }
    else if ([name isEqualToString:@"iPhone9,4"]){
        actualName=@"iPhone 7 Plus (GSM)";
    }
    else if ([name isEqualToString:@"iPhone10,1"]){
        actualName=@"iPhone 8 (CDMA)";
    }
    else if ([name isEqualToString:@"iPhone10,2"]){
        actualName=@"iPhone 8 Plus (CDMA)";
    }
    else if ([name isEqualToString:@"iPhone10,3"]){
        actualName=@"iPhone X (CDMA)";
    }
    else if ([name isEqualToString:@"iPhone10,4"]){
        actualName=@"iPhone 8 (GSM)";
    }
    else if ([name isEqualToString:@"iPhone10,5"]){
        actualName=@"iPhone 8 Plus (GSM)";
    }
    else if ([name isEqualToString:@"iPhone10,6"]){
        actualName=@"iPhone X (GSM)";
    }
    else if ([name isEqualToString:@"iPhone11,2"]){
        actualName=@"iPhone XS";
    }
    else if ([name isEqualToString:@"iPhone11,4"] || [name isEqualToString:@"iPhone11,6"]){
        actualName=@"iPhone XS MAX";
    }
    else if ([name isEqualToString:@"iPhone11,8"]){
        actualName=@"iPhone XR";
    }
    else if ([name isEqualToString:@"iPhone12,1"]){
        actualName=@"iPhone 11";
    }
    else if ([name isEqualToString:@"iPhone12,3"]){
        actualName=@"iPhone 11 Pro";
    }
    else if ([name isEqualToString:@"iPhone12,5"]){
        actualName=@"iPhone 11 Pro Max";
    }
    else if ([name isEqualToString:@"iPhone12,8"]){
        actualName=@"iPhone SE (2nd Gen)";
    }
    else if ([name isEqualToString:@"iPhone13,1"]){
        actualName=@"iPhone 12 Mini";
    }
    else if ([name isEqualToString:@"iPhone13,2"]){
        actualName=@"iPhone 12";
    }
    else if ([name isEqualToString:@"iPhone13,3"]){
        actualName=@"iPhone 12 Pro";
    }
    else if ([name isEqualToString:@"iPhone13,4"]){
        actualName=@"iPhone 12 Pro Max";
    }
    else if ([name isEqualToString:@"iPad1,1"]){
        actualName=@"iPad (WiFi)";
    }
    else if ([name isEqualToString:@"iPad1,2"]){
        actualName=@"iPad (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad2,1"] || [name isEqualToString:@"iPad2,5"]){
        actualName=@"iPad Mini (WiFi)";
    }
    else if ([name isEqualToString:@"iPad2,2"]){
        actualName=@"iPad Mini (3G)";
    }
    else if ([name isEqualToString:@"iPad2,3"]){
        actualName=@"iPad Mini (GSM)";
    }
    else if ([name isEqualToString:@"iPad2,5"]){
        actualName=@"iPad Mini (WiFi)";
    }
    else if ([name isEqualToString:@"iPad2,6"] || [name isEqualToString:@"iPad2,7"]){
        actualName=@"iPad Mini (WiFi + Cellular)";
    }
    
    else if ([name isEqualToString:@"iPad3,1"]){
        actualName=@"iPad 4 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad3,2"] || [name isEqualToString:@"iPad3,3"]){
        actualName=@"iPad 4 (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad3,4"]){
        actualName=@"iPad 4 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad3,5"] || [name isEqualToString:@"iPad3,6"]){
        actualName=@"iPad 4 (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad4,1"]){
        actualName=@"iPad Air2 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad4,2"] || [name isEqualToString:@"iPad4,3"]){
        actualName=@"iPad Air2 (WiFi + Cellular)";
    }
    
    else if ([name isEqualToString:@"iPad4,4"]){
        actualName=@"iPad Mini 2 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad4,6"] ||[name isEqualToString:@"iPad4,5"]){
        actualName=@"iPad Mini 2 (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad4,7"]){
        actualName=@"iPad Mini 3 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad4,9"] || [name isEqualToString:@"iPad4,8"]){
        actualName=@"iPad Mini 3 (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad5,1"]){
        actualName=@"iPad Mini 4 (WiFi)";
    }
    else if ([name isEqualToString:@"iPad5,2"]){
        actualName=@"iPad Mini 4 (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad5,3"]){
        actualName=@"iPad Air (WiFi)";
    }
    else if ([name isEqualToString:@"iPad5,4"]){
        actualName=@"iPad Air (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad6,3"]){
        actualName=@"iPad Pro 9.7\" (WiFi)";
    }
    else if ([name isEqualToString:@"iPad6,4"]){
        actualName=@"iPad Pro 9.7\" (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad6,7"]){
        actualName=@"iPad Pro 12.9\" (WiFi)";
    }
    else if ([name isEqualToString:@"iPad6,8"]){
        actualName=@"iPad Pro 12.9\" (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad6,11"]){
        actualName=@"iPad 5th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad6,12"]){
        actualName=@"iPad 5th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad7,1"]){
        actualName=@"iPad Pro 12.9\" 2nd Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad7,2"]){
        actualName=@"iPad Pro 12.9\" 2nd Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad7,3"]){
        actualName=@"iPad Pro 10.5\" (WiFi)";
    }
    else if ([name isEqualToString:@"iPad7,4"]){
        actualName=@"iPad Pro 10.5\" (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad7,5"]){
        actualName=@"iPad 6th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad7,6"]){
        actualName=@"iPad 6th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad7,11"]){
        actualName=@"iPad 7th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad7,12"]){
        actualName=@"iPad 7th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad8,1"] || [name isEqualToString:@"iPad8,2"]){
        actualName=@"iPad Pro 11\" (WiFi)";
    }
    else if ([name isEqualToString:@"iPad8,3"] || [name isEqualToString:@"iPad8,4"]){
        actualName=@"iPad Pro 11\" (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad8,5"] || [name isEqualToString:@"iPad8,6"]){
        actualName=@"iPad Pro 12.9\" 3rd Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad8,7"] || [name isEqualToString:@"iPad8,8"]){
        actualName=@"iPad Pro 12.9\" 3rd Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad8,9"] || [name isEqualToString:@"iPad8,10"]){
        actualName=@"iPad Pro 11\" 2nd Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad8,11"]){
        actualName=@"iPad Pro 12.9\" 4th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad8,12"]){
        actualName=@"iPad Pro 12.9\" 4th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad11,1"]){
        actualName=@"iPad Mini 5th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad11,2"]){
        actualName=@"iPad Mini 5th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad11,3"]){
        actualName=@"iPad Air 3rd Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad11,4"]){
        actualName=@"iPad Air 3rd Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad11,6"]){
        actualName=@"iPad 8th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad11,7"]){
        actualName=@"iPad 8th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPad13,1"]){
        actualName=@"iPad Air 4th Generation (WiFi)";
    }
    else if ([name isEqualToString:@"iPad13,2"]){
        actualName=@"iPad Air 4th Generation (WiFi + Cellular)";
    }
    else if ([name isEqualToString:@"iPod1,1"]){
        actualName= @"iPod Touch";
    }
    else if ([name isEqualToString:@"iPod2,1"]){
        actualName=@"iPod Touch 2nd Generation";
    }
    else if ([name isEqualToString:@"iPod3,1"]){
        actualName=@"iPod Touch 3rd Generation";
    }
    else if ([name isEqualToString:@"iPod4,1"]){
        actualName=@"iPod Touch 4th Generation";
    }
    else if ([name isEqualToString:@"iPod5,1"]){
        actualName=@"iPod Touch 5th Generation";
    }
    else if ([name isEqualToString:@"iPod6,1"]){
        actualName=@"iPod Touch 5th Generation";
    }
    else if ([name isEqualToString:@"iPod7,1"]){
        actualName=@"iPod Touch 6th Generation";
    }
    else if ([name isEqualToString:@"iPod9,1"]){
        actualName=@"iPod Touch 7th Generation";
    }else{
        return name;
    }
    
    return actualName;
<<<<<<< HEAD
}

//username
+(void)getUserName:(NSString *)strUserName withLat:(NSString *)lat withLongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    //Parameters_values
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * DeviceName = [UIDevice currentDevice].model;
    NSString * OSVersion = [UIDevice currentDevice].systemVersion;
    NSString * DeviceModel = deviceName();
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *Os_name = @"iOS";
    NSLog(@"DeviceModel:%@",DeviceModel);
    NSLog(@"OSVersion:%@",OSVersion);
    NSLog(@"DeviceName:%@",DeviceName);
    NSLog(@"appVersionString:%@",appVersionString);
    NSLog(@"imei:%@",str);
    NSLog(@"lat:%@",lat);
    NSLog(@"longi:%@",longi);
    NSDictionary *getUserName =@{@"user_name":strUserName,
                                 @"Imei":str,
                                 @"Serial_number":str,
                                 @"Os_name":Os_name,
                                 @"Os_version":OSVersion,
                                 @"Device_name":DeviceName,
                                 @"Device_model":DeviceModel,
                                 @"Appversion":appVersionString,
                                 @"latitude":lat,
                                 @"longitude":longi,
                                 @"Master":@(boolvalue)};
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetUserName = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_GET_USER_NAME];
    [self createPOSTRequestWithParams:getUserName urlString:strGetUserName andCompletion:completion];
=======
>>>>>>> main
}

//username
+(void)getUserName:(NSString *)strUserName withLat:(NSString *)lat withLongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    //Parameters_values
    NSString *str= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * DeviceName = [UIDevice currentDevice].model;
    NSString * OSVersion = [UIDevice currentDevice].systemVersion;
    NSString * DeviceModel = deviceName();
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *Os_name = @"iOS";
    NSLog(@"DeviceModel:%@",DeviceModel);
    NSLog(@"OSVersion:%@",OSVersion);
    NSLog(@"DeviceName:%@",DeviceName);
    NSLog(@"appVersionString:%@",appVersionString);
    NSLog(@"imei:%@",str);
    NSLog(@"lat:%@",lat);
    NSLog(@"longi:%@",longi);
    NSDictionary *getUserName =@{@"user_name":strUserName,
                                 @"Imei":str,
                                 @"Serial_number":str,
                                 @"Os_name":Os_name,
                                 @"Os_version":OSVersion,
                                 @"Device_name":DeviceName,
                                 @"Device_model":DeviceModel,
                                 @"Appversion":appVersionString,
                                 @"latitude":lat,
                                 @"longitude":longi,
                                 @"Master":@(boolvalue)};
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strGetUserName = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_GET_USER_NAME];
    [self createPOSTRequestWithParams:getUserName urlString:strGetUserName andCompletion:completion];
}

<<<<<<< HEAD
//pin & Passcode
+(void)getUserNameAndUserPin:(NSString *)strUserName withUserPin:(NSString *)strUserPin withOs_name:(NSString *)Os_name withOs_version:(NSString *)Os_version withDevice_name:(NSString *)Device_name withDevice_model:(NSString *)Device_model withImei:(NSString *)Imei withAppversion:(NSString *)Appversion withAppaccessversion:(NSString *)AppAccessVr withDevicetracker:(BOOL) devicetracker withcorporate:(BOOL) corp withlat:lat_app withlong:longi_app withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
=======

//pin & Passcode
+(void)getUserNameAndUserPin:(NSString *)strUserName withUserPin:(NSString *)strUserPin withOs_name:(NSString *)Os_name withOs_version:(NSString *)Os_version withDevice_name:(NSString *)Device_name withDevice_model:(NSString *)Device_model withImei:(NSString *)Imei withAppversion:(NSString *)Appversion withAppaccessversion:(NSString *)AppAccessVr withDevicetracker:(BOOL) devicetracker withcorporate:(BOOL) corp withlat:lat_app withlong:longi_app withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion
{
    
    NSLog(@"deviceTrack api:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTrackerAccess"]);
    NSLog(@"CorporateLevel api:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CorporateLevel"]);

    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *DeviceModel = deviceName();
    NSLog(@"[UIDevice currentDevice].model: %@",DeviceModel);
    NSLog(@"[UIDevice currentDevice].description: %@",[UIDevice currentDevice].description);
    NSLog(@"[UIDevice currentDevice].localizedModel: %@",[UIDevice currentDevice].localizedModel);
    NSLog(@"[UIDevice currentDevice].name: %@",[UIDevice currentDevice].name);
    NSLog(@"[UIDevice currentDevice].systemVersion: %@",[UIDevice currentDevice].systemVersion);
    NSLog(@"[UIDevice currentDevice].systemName: %@",[UIDevice currentDevice].systemName);
    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", identifier);
>>>>>>> main
    
    NSLog(@"deviceTrack api:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTrackerAccess"]);
    NSLog(@"CorporateLevel api:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CorporateLevel"]);

    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *DeviceModel = deviceName();
    NSLog(@"[UIDevice currentDevice].model: %@",DeviceModel);
    NSLog(@"[UIDevice currentDevice].description: %@",[UIDevice currentDevice].description);
    NSLog(@"[UIDevice currentDevice].localizedModel: %@",[UIDevice currentDevice].localizedModel);
    NSLog(@"[UIDevice currentDevice].name: %@",[UIDevice currentDevice].name);
    NSLog(@"[UIDevice currentDevice].systemVersion: %@",[UIDevice currentDevice].systemVersion);
    NSLog(@"[UIDevice currentDevice].systemName: %@",[UIDevice currentDevice].systemName);
    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", identifier);
    
<<<<<<< HEAD
    
    NSString * OS = [UIDevice currentDevice].systemName;
    NSString * DeviceName = [UIDevice currentDevice].model;
    NSString * OSVersion = [UIDevice currentDevice].systemVersion;
    [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:@"appVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:DeviceModel forKey:@"DeviceModel"];
    [[NSUserDefaults standardUserDefaults] setObject:DeviceName forKey:@"DeviceName"];
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"identifier"];
    [[NSUserDefaults standardUserDefaults] setObject:OS forKey:@"OS"];
    [[NSUserDefaults standardUserDefaults] setObject:OSVersion forKey:@"OSVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    Appversion = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"appVersion"];
    Device_model = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"DeviceModel"];
    Imei = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"identifier"];
    Os_name = @"iOS";
    Os_version = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"OSVersion"];
    Device_name = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"DeviceName"];
    
    //UTC current time
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    //NSString *falsee = @"0"; "yyyy-MM-dd HH:mm:ss z"
    //NSString *truee = @"Yes";
    NSDictionary *getUserNameAndPin =@{@"user_name":strUserName,
                                       @"user_pin":strUserPin,
                                       @"Os_name":Os_name,
                                       @"Os_version":Os_version,
                                       @"Device_name":Device_name,
                                       @"Device_model":Device_model,
                                       @"Imei":Imei,
                                       @"Serial_number":Imei,
                                       @"Appversion":Appversion,
                                       @"app_access_version":[[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"],
                                       @"device_track_access":@(devicetracker),
                                       @"corporate_level_plan":@(corp),
                                       @"Master":@(boolvalue),
                                       @"latitude":lat_app,
                                       @"longitude":longi_app,
                                       @"device_login_time":localDateString
                                       };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strUserNameAndUserPin = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_GET_USER_NAME_AND_USER_PIN];
    
    [self createPOSTRequestWithParams:getUserNameAndPin urlString:strUserNameAndUserPin andCompletion:completion];
    
=======
    NSString * OS = [UIDevice currentDevice].systemName;
    NSString * DeviceName = [UIDevice currentDevice].model;
    NSString * OSVersion = [UIDevice currentDevice].systemVersion;
    [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:@"appVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:DeviceModel forKey:@"DeviceModel"];
    [[NSUserDefaults standardUserDefaults] setObject:DeviceName forKey:@"DeviceName"];
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"identifier"];
    [[NSUserDefaults standardUserDefaults] setObject:OS forKey:@"OS"];
    [[NSUserDefaults standardUserDefaults] setObject:OSVersion forKey:@"OSVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    Appversion = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"appVersion"];
    Device_model = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"DeviceModel"];
    Imei = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"identifier"];
    Os_name = @"iOS";
    Os_version = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"OSVersion"];
    Device_name = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"DeviceName"];
    
    //UTC current time
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    //NSString *falsee = @"0"; "yyyy-MM-dd HH:mm:ss z"
    //NSString *truee = @"Yes";
    NSDictionary *getUserNameAndPin =@{@"user_name":strUserName,
                                       @"user_pin":strUserPin,
                                       @"Os_name":Os_name,
                                       @"Os_version":Os_version,
                                       @"Device_name":Device_name,
                                       @"Device_model":Device_model,
                                       @"Imei":Imei,
                                       @"Serial_number":Imei,
                                       @"Appversion":Appversion,
                                       @"app_access_version":[[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"],
                                       @"device_track_access":@(devicetracker),
                                       @"corporate_level_plan":@(corp),
                                       @"Master":@(boolvalue),
                                       @"latitude":lat_app,
                                       @"longitude":longi_app,
                                       @"device_login_time":localDateString
                                       };
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *strUserNameAndUserPin = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_GET_USER_NAME_AND_USER_PIN];
    
    [self createPOSTRequestWithParams:getUserNameAndPin urlString:strUserNameAndUserPin andCompletion:completion];
    
>>>>>>> main
}


//imageupload_friver
+(void)driverUploadImageWithAllDetails:(NSMutableDictionary *)dictNoteDetails noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion
{
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_DRIVER_UPLOAD_IMAGE];
    NSLog(@"jsonString URL Subash :%@",createNoteUrl);
    NSString *DeviceModel = deviceName();
    [dictNoteDetails setObject:DeviceModel forKey:@"Device_model"];

        // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictNoteDetails options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *Imei= [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSDictionary *getImei =@{@"Imei":Imei};

        // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:createNoteUrl parameters:getImei
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
<<<<<<< HEAD
=======
        
>>>>>>> main
        
        NSLog(@"jsonString test innner images :%@",jsonString);
        
        NSLog(@"jsonString test innner images :%@",jsonString);
        
        [formData appendPartWithFormData:jsonData name:@"userDetails"];
            //        for (NSString *imageName in imglist) {
            //        }
        if (noteResource) {
            if ([dictNoteDetails objectForKey:@"pic_count"]) {
                NSNumber *number = [dictNoteDetails objectForKey:@"pic_count"];
                i = [number intValue];
            }
            else{
                i = 0;
            }
            if (i<imglist.count) {
                    //NSMutableArray * Image = [ valueForKey:@"imageName"];
                    // NSMutableArray * images = [imglist valueForKey:@"imageName"];
                if(imglist.count != 0)
                {
                    NSMutableArray * Imges =  [imglist valueForKey:@"imageName"];
                    img= [NSString stringWithFormat:@"%@",[Imges objectAtIndex:i]];
                    NSLog(@"i value: %d",i);
                    NSLog(@"INameDetail1 : %@",img);
                    NSArray *extentionArray = [img componentsSeparatedByString:@"."];
                    if([extentionArray[1] isEqualToString:@"mp4"])
                    {
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"video/mp4"];
                    }
                    else{
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"image/jpeg"];
                    }
                    i++;
                }
            }
        }
    }];
    NSString * sid = [dictNoteDetails objectForKey:@"s_id"];
    NSString * loadid = [dictNoteDetails objectForKey:@"load_id"];
  
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
   // [manager1.requestSerializer setValue:sid forHTTPHeaderField:@"token_id"];
   // [manager1.requestSerializer setValue:loadid forHTTPHeaderField:@"token_value"];
    AFHTTPRequestOperation *operation =
    [manager1 HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         completion(nil,responseObject,1);
        NSLog(@"request_Success %@", request);
        NSLog(@"Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,0);
        NSLog(@"request_failure %@", request);
        NSLog(@"Failure %@", error.description);
    }];
    
        // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        completion(nil,nil,((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
        NSLog(@"uploaded %f %%", ((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
    }];
    
        // 5. Begin!
    
    
    [operation start];
    
}

//imageupload
+(void)uploadImageWithAllDetails:(NSDictionary *)dictNoteDetails withBoolvalue:(BOOL)isLoadCentric noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion
{
    NSString *EnvironmentName = [[NSUserDefaults standardUserDefaults]stringForKey:@"Environment"];
    if (EnvironmentName == nil || EnvironmentName.length == 0) {
        EnvironmentName = BASE_URL;
    }
    NSString *createNoteUrl = nil;
    if(isLoadCentric){
        createNoteUrl = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_UPLOAD_LOAD_CENTRIC_IMAGE];
    }else {
        createNoteUrl = [NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_UPLOAD_IMAGE];
    }
    NSLog(@"jsonString URL Subash :%@",createNoteUrl);

        // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictNoteDetails options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *Imei= [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSDictionary *getImei =@{@"Imei":Imei};

        // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:createNoteUrl parameters:getImei
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        NSLog(@"jsonString test innner images :%@",jsonString);
        
        [formData appendPartWithFormData:jsonData name:@"userDetails"];
            //        for (NSString *imageName in imglist) {
            //        }
        if (noteResource) {
            if ([dictNoteDetails objectForKey:@"pic_count"]) {
                NSNumber *number = [dictNoteDetails objectForKey:@"pic_count"];
                i = [number intValue];
            }
            else{
                i = 0;
            }
            if (i<imglist.count) {
                    //NSMutableArray * Image = [ valueForKey:@"imageName"];
                    // NSMutableArray * images = [imglist valueForKey:@"imageName"];
                if(imglist.count != 0)
                {
                    NSMutableArray * Imges =  [imglist valueForKey:@"imageName"];
                    img= [NSString stringWithFormat:@"%@",[Imges objectAtIndex:i]];
                    NSLog(@"i value: %d",i);
                    NSLog(@"INameDetail1 : %@",img);
                    NSArray *extentionArray = [img componentsSeparatedByString:@"."];
                    if([extentionArray[1] isEqualToString:@"mp4"])
                    {
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"video/mp4"];
                    }
                    else{
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"image/jpeg"];
                    }
                    i++;
                }
            }
<<<<<<< HEAD
        }
    }];
    
        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager1 HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         completion(nil,responseObject,1);
        NSLog(@"request_Success %@", request);
        NSLog(@"Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,0);
        NSLog(@"request_failure %@", request);
        NSLog(@"Failure %@", error.description);
    }];
    
        // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        completion(nil,nil,((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
        NSLog(@"uploaded %f %%", ((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
    }];
    
        // 5. Begin!
    
    
    [operation start];
    
=======
        }
    }];
    
        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    manager1 = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager1 HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         completion(nil,responseObject,1);
        NSLog(@"request_Success %@", request);
        NSLog(@"Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,0);
        NSLog(@"request_failure %@", request);
        NSLog(@"Failure %@", error.description);
    }];
    
        // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        completion(nil,nil,((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
        NSLog(@"uploaded %f %%", ((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
    }];
    
        // 5. Begin!
    [operation start];
}

+(void) cancelUpload{
    if(manager1 != nil){
        if(manager1.operationQueue != nil){
            [manager1.operationQueue cancelAllOperations];
        }
    }
>>>>>>> main
}

//imageUpload - Looping
+(void)uploadLoopingImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion
{
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_UPLOAD_LOOPING_IMAGE];
    NSLog(@"jsonString URL Subash :%@",createNoteUrl);

        // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictNoteDetails options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *Imei= [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSDictionary *getImei =@{@"Imei":Imei};

        // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:createNoteUrl parameters:getImei
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        NSLog(@"jsonString test innner images :%@",jsonString);
        
        [formData appendPartWithFormData:jsonData name:@"userDetails"];
            //        for (NSString *imageName in imglist) {
            //        }
        if (noteResource) {
            if ([dictNoteDetails objectForKey:@"pic_count"]) {
                NSNumber *number = [dictNoteDetails objectForKey:@"pic_count"];
                i = [number intValue];
            }
            else{
                i = 0;
            }
            if (i<imglist.count) {
                    //NSMutableArray * Image = [ valueForKey:@"imageName"];
                    // NSMutableArray * images = [imglist valueForKey:@"imageName"];
                if(imglist.count != 0)
                {
                    NSMutableArray * Imges =  [imglist valueForKey:@"imageName"];
                    img= [NSString stringWithFormat:@"%@",[Imges objectAtIndex:i]];
                    NSLog(@"i value: %d",i);
                    NSLog(@"INameDetail1 : %@",img);
                    NSArray *extentionArray = [img componentsSeparatedByString:@"."];
                    if([extentionArray[1] isEqualToString:@"mp4"])
                    {
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"video/mp4"];
                    }
                    else{
                        [formData appendPartWithFileData:noteResource name:@"userImage" fileName:img mimeType:@"image/jpeg"];
                    }
                    i++;
                }
            }
        }
    }];
    
        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager1 HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         completion(nil,responseObject,1);
        NSLog(@"request_Success %@", request);
        NSLog(@"Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,0);
        NSLog(@"request_failure %@", request);
        NSLog(@"Failure: %@", error.description);
    }];
    
        // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        completion(nil,nil,((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
        NSLog(@"uploaded %f %%", ((totalBytesWritten)*1.0)/totalBytesExpectedToWrite);
    }];
    
        // 5. Begin!
    
    
    [operation start];
    
}


+(void)SendAllDetails:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withCorpId:(NSString *)strCorpId withSiteId:(NSString *)strSiteId withLoadId:(NSString *)strLoadId andCompletion:(GFWebServiceHandler)completion
{
    
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
     NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_QUALITY_ISSUE];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:createNoteUrl]];
  
     NSString *userUpdate =[NSString stringWithFormat:@"user_type=%@&email_id=%@&first_name_load=%@&last_name_load=%@&site_name=%@&last_insert_load_id=%@&site_id=%@&c_id=%@",usertype,strEmail,strFirstName,strLastName,strSiteName,strLoadId,strSiteId,strCorpId];
    
    
    
    NSString *tokedId =  [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenID"];
    NSString *tokedValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenValue"];
    //create the Method "GET" or "POST"

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@", tokedId] forHTTPHeaderField:@"token_id"];
    [urlRequest addValue:tokedValue forHTTPHeaderField:@"token_value"];
    
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
       NSLog(@"url request%@",urlRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                NSLog(@"Login SUCCESS");
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
    
    
    
}


+(void)sendAddOnMail:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withSiteId:(NSString *)strSiteId withCropId:(NSString *)strCropId withLoadId:(NSString *)strLoadId withCorpName:(NSString *)corp_name andCompletion:(GFWebServiceHandler)completion
{
    
    NSString *EnvironmentName=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Environment"];
    if (EnvironmentName==nil || EnvironmentName.length==0) {
        EnvironmentName=BASE_URL;
    }
    NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",EnvironmentName,API_TO_ADDON_MAIL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:createNoteUrl]];
  
    NSString *userUpdate =[NSString stringWithFormat:@"user_type=%@&email_id=%@&first_name_load=%@&last_name_load=%@&site_name=%@&site_id=%@&c_id=%@&last_insert_load_id=%@&corp_name=%@",usertype,strEmail,strFirstName,strLastName,strSiteName,strSiteId,strCropId,strLoadId,corp_name];
    
    //create the Method "GET" or "POST"
    
    NSString *tokedId =  [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenID"];
    NSString *tokedValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenValue"];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@", tokedId] forHTTPHeaderField:@"token_id"];
    [urlRequest addValue:tokedValue forHTTPHeaderField:@"token_value"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
       NSLog(@"url request%@",urlRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200){
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1){
                NSLog(@"Login SUCCESS");
            }else{
                NSLog(@"Login FAILURE");
            }
        }else{
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

//****************************************************
#pragma mark - Helper Method for POST and GET request
//****************************************************


//PostMethod
+(AFHTTPRequestOperationManager *)createPOSTRequestWithParams:(NSDictionary *)dictParams urlString:(NSString *)strUrl andCompletion:(GFWebServiceHandler)completion{
    
    NSString *tokedId =  [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenID"];
    NSString *tokedValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenValue"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue: tokedId == NULL ? @"loadproof" : [NSString stringWithFormat:@"%@", tokedId]forHTTPHeaderField:@"token_id"];
    [manager.requestSerializer setValue: tokedValue == NULL ? @"loadproof" : tokedValue forHTTPHeaderField:@"token_value"];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    NSString *strEncodedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:strEncodedUrl parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject:%@",responseObject);
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString:%@",jsonString);
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSLog(@"responsedict:%@",dict);
        completion(nil,dict,-1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,-1);
    }];
    return manager;
}


//GetMethod
+(AFHTTPRequestOperationManager *)createGETRequestWithParams:(NSDictionary *)dictParams urlString:(NSString *)strUrl andCompletion:(GFWebServiceHandler)completion
{
    NSString *strUrlWithParams = [self stringByAppendingParams:dictParams toUrlString:strUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    
    NSString *tokedId =  [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenID"];
    NSString *tokedValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenValue"];
    
    [manager.requestSerializer setValue: tokedId == NULL ? @"loadproof" : [NSString stringWithFormat:@"%@", tokedId] forHTTPHeaderField:@"token_id"];
    [manager.requestSerializer setValue: tokedValue == NULL ?  @"loadproof" : tokedValue forHTTPHeaderField:@"token_value"];

    NSString *strEncodedUrl = [strUrlWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:strEncodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
        NSLog(@"responseObject:%@",responseObject);
        //NSLog(@"%@",responseObject);

        completion(nil,responseObject,-1);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,-1);
    }];
    
    return manager;
}

+(NSString *)stringByAppendingParams:(NSDictionary *)dictParams toUrlString:(NSString *)strUrl
{
    if (strUrl.length > 0) {
        NSMutableString *strUrlWithParams = [NSMutableString stringWithString:strUrl];
        if (dictParams.count > 0) {
            ///Append ? for first param
            [strUrlWithParams appendString:@"?"];
            for (id paramName in [dictParams allKeys]) {
                ///Get value associated to param name
                id paramVal = [dictParams objectForKey:paramName];
                ///Append Param
                [strUrlWithParams appendFormat:@"%@=%@&",paramName,paramVal];
            }
            ///Remove & from last
            NSRange lastCharRange = NSMakeRange(strUrlWithParams.length - 1, 1);
            [strUrlWithParams deleteCharactersInRange:lastCharRange];
        } 
        return strUrlWithParams;
    }
    return nil;
}

//site-maintanence
+(void)websiteMaintenance:(GFWebServiceHandler)completion{
    NSString *siteMapi=[[NSUserDefaults standardUserDefaults]
                               stringForKey:@"siteMapi"];
    if (siteMapi==nil || siteMapi.length==0) {
        siteMapi = SITEM_URL;
    }
    NSString *url=[NSString stringWithFormat:@"%@site_maintenance.json",siteMapi];
    //NSString* url = @"http://ec2-54-204-9-153.compute-1.amazonaws.com/site_maintenance.json";
    NSLog(@"url:%@",url);
    [self createGETRequestWithParams:nil urlString:url andCompletion:completion];
}

//timezone
+(void)getTimeZoneAPiLat:(NSString *)lat lon:(NSString *)lon format:(NSString *)format apiKey:(NSString *)apiKey :(GFWebServiceHandler)completion{
   
    NSString *timeZoneUrl = TIMEZONE_URL;
    
    NSString *url = [timeZoneUrl stringByAppendingString:@"lat"];
    NSString *urlWithLat = [url stringByAppendingString:lat];
    NSString *url1 = [urlWithLat stringByAppendingString:@"lon"];
    NSString *urlWithLon = [url1 stringByAppendingString:lon];
    NSString *url2 = [urlWithLon stringByAppendingString:@"format"];
    NSString *urlWithFormat = [url2 stringByAppendingString:format];
    NSString *url3 = [urlWithFormat stringByAppendingString:@"apiKey"];
    NSString *urlWithKey = [url3 stringByAppendingString:apiKey];
    
    [self createGETRequestWithParams:nil urlString:urlWithKey andCompletion:completion];
}

//GetMethod
+(AFHTTPRequestOperationManager *)getTimeZoneAPiLat:(NSString *)lat lon:(NSString *)lon andCompletion:(GFWebServiceHandler)completion
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    NSString *timeZoneUrl = TIMEZONE_URL;
    
    NSString *url = [timeZoneUrl stringByAppendingString:@"lat="];
    NSString *urlWithLat = [url stringByAppendingString:lat];
    NSString *url1 = [urlWithLat stringByAppendingString:@"&lon="];
    NSString *urlWithLon = [url1 stringByAppendingString:lon];
    NSString *urlWithFormat = [urlWithLon stringByAppendingString:@"&format=json"];
    NSString *url2 = [urlWithFormat stringByAppendingString:@"&apiKey="];
    NSString *urlWithKey = [url2 stringByAppendingString:TIMEZONE_KEY];
    NSLog(@"timezoneurl%@", urlWithKey);
        
    [manager GET:urlWithKey parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
        completion(nil,responseObject,-1);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil,-1);
    }];
    
    return manager;
}


@end
