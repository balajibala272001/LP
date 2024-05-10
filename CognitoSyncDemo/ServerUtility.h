//
//  ServerUtility.h
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CognitoHomeViewController.h"
#import "Constants.h"
#import "PPPinPadViewController.h"
#import "PasscodePinViewController.h"
#import "CameraViewController.h"


typedef void (^GFWebServiceHandler)(NSError *error, id data,float percentage);

@interface ServerUtility : NSObject
@property (weak,nonatomic) NSMutableArray * picslist;
@property (nonatomic) int  picsCount;


+(void)websiteMaintenance:(GFWebServiceHandler)completion;

+(void)getTimeZoneAPiLat:(NSString *)lat lon:(NSString *)lon andCompletion:(GFWebServiceHandler)completion;

+(void)deviceLastseenWithCid:(NSString *)cId withUid:(NSString *)uId withcorpid:(NSString *)corpid withaccessVersion:(NSString *)accessVersion withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion;

+(void)driverLoadValidationCid:(NSString *)cId withLoadid:(NSString *)loadId andCompletion:(GFWebServiceHandler)completion;

+(void)getdevice_tracker:(NSString *)trackerId withOfflinedata:(NSArray*) data withCid:(NSString *)cId withUid:(NSString *)uId withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue  andCompletion:(GFWebServiceHandler)completion;

+(void)getdevice_tracker_id:(NSString *)trackerId withCid:(NSString *)cId withUid:(NSString *)uId withlat:(NSString *)lat withlongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue  andCompletion:(GFWebServiceHandler)completion;

+(void)getUserName:(NSString *)strUserName withLat:(NSString *)lat withLongi:(NSString *)longi withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion;

+(void)getCid:(NSString *)cId withUid:(NSString *)uId  andCompletion:(GFWebServiceHandler)completion;

+(void)getUserNameAndUserPin:(NSString *)strUserName withUserPin:(NSString *)strUserPin withOs_name:(NSString *)Os_name withOs_version:(NSString *)Os_version withDevice_name:(NSString *)Device_name withDevice_model:(NSString *)Device_model withImei:(NSString *)Imei withAppversion:(NSString *)Appversion withAppaccessversion:(NSString *)AppAccessVr withDevicetracker:(BOOL) devicetracker withcorporate:(BOOL) corp withlat:lat_app withlong:longi_app withBoolvalue:(BOOL)boolvalue andCompletion:(GFWebServiceHandler)completion;

+(void)driverUploadImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource  andCompletion:(GFWebServiceHandler)completion;
<<<<<<< HEAD

+(void)uploadImageWithAllDetails:(NSDictionary *)dictNoteDetails withBoolvalue:(BOOL)isLoadCentric noteResource:(NSData *)noteResource  andCompletion:(GFWebServiceHandler)completion;

+(void)uploadLoopingImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion;

+(void)SendAllDetails:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withCorpId:(NSString *)strCorpId withSiteId:(NSString *)strSiteId withLoadId:(NSString *)strLoadId andCompletion:(GFWebServiceHandler)completion;

+(void)sendAddOnMail:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withSiteId:(NSString *)strSiteId withCropId:(NSString *)strCropId withLoadId:(NSString *)strLoadId withCorpName:(NSString *)corp_name andCompletion:(GFWebServiceHandler)completion;

+(void)getLoadCentricDataCid:(NSString *)qr_sId withLoadid:(NSString *)qr_loadId withsid:(NSString *)sId andCompletion:(GFWebServiceHandler)completion;
=======

+(void)uploadImageWithAllDetails:(NSDictionary *)dictNoteDetails withBoolvalue:(BOOL)isLoadCentric noteResource:(NSData *)noteResource  andCompletion:(GFWebServiceHandler)completion;

+(void)uploadLoopingImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion;

+(void)SendAllDetails:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withCorpId:(NSString *)strCorpId withSiteId:(NSString *)strSiteId withLoadId:(NSString *)strLoadId andCompletion:(GFWebServiceHandler)completion;

+(void)sendAddOnMail:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withSiteId:(NSString *)strSiteId withCropId:(NSString *)strCropId withLoadId:(NSString *)strLoadId withCorpName:(NSString *)corp_name andCompletion:(GFWebServiceHandler)completion;

+(void)getLoadCentricDataCid:(NSString *)qr_sId withLoadid:(NSString *)qr_loadId withsid:(NSString *)sId andCompletion:(GFWebServiceHandler)completion;

+(void)cancelUpload;
>>>>>>> main

@end
