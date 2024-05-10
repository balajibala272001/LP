//
//  SiteData.h
//  CognitoSyncDemo
//
//  Created by mac on 10/23/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldData.h"
#import "User.h"
#import "CategoryData.h"
#import "InstructData.h"
@interface SiteData : NSObject


@property (nonatomic,assign) int siteId;
@property (nonatomic,strong)NSString *siteName;
@property (nonatomic,strong) NSMutableArray *categoryAddon;
@property (nonatomic,strong) NSMutableArray *customerDictSetup;
@property (nonatomic,strong) NSString *image_quality;
@property (nonatomic,assign) int networkId;
@property (nonatomic,strong) NSString *site_active;
@property (nonatomic, strong) NSMutableArray *arrFieldData;
@property (nonatomic,assign) int uploadCount;
@property (nonatomic,strong) NSString* uploadC;
@property (nonatomic,strong) NSString* planname;
@property (nonatomic,strong) NSMutableArray *customCategory;

@property (nonatomic,assign) int RemainingStorageSpace;
@property (nonatomic,assign) int  RemainingVideocount;
@property (nonatomic,assign) int  RemainingImagecount;
@property (nonatomic,assign) double RemainingSpacePercentage;
@property (nonatomic,strong) NSString * LowStorage;
@property (nonatomic,strong) NSString * addon_gallery_mode;
@property (nonatomic,strong) NSString * pcp_flag;
@property (nonatomic,strong) NSString * addOn;
@property (nonatomic,strong) NSString * addOnMail;
@property (nonatomic,strong) NSString *images_error_type;
@property (nonatomic,strong) NSString *tappi_name;

@property (nonatomic,strong) NSString * max_storage;
@property (nonatomic,strong) NSString * percent;
@property (nonatomic,strong) NSString * storage_msg;
@property (nonatomic,strong) NSString * free_trial_msg;
@property (nonatomic,strong) NSString *addon_doc_type;
@property (nonatomic,strong) NSMutableArray *docTypes;
@property (nonatomic,strong) NSMutableArray *qrArrFieldData;



-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData;


//addon_8
@property (nonatomic,strong) NSMutableArray *looping_data;
//+(void)saveCustomObject:(SiteData*)object key:(NSString *)key;
//+(SiteData*)loadCustomObjectWithKey:(NSString *)key;
@end
