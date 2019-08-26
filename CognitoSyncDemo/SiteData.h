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

@interface SiteData : NSObject


@property (nonatomic,assign) int siteId;
@property (nonatomic,strong)NSString *siteName;
@property (nonatomic,assign) int networkId;
@property (nonatomic, strong) NSArray *arrFieldData;
@property(nonatomic,assign) int uploadCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData;

+(void)saveCustomObject:(SiteData*)object key:(NSString *)key;
+(SiteData*)loadCustomObjectWithKey:(NSString *)key;
@end
