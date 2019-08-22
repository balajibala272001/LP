//
//  SiteData.m
//  CognitoSyncDemo
//
//  Created by mac on 10/23/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "SiteData.h"
#import "FieldData.h"

@implementation SiteData




-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData
{
    
    
    if (self = [super init]) {
        
     
        
        
        
        self.siteId = [[dictSiteData objectForKey:@"s_id"]intValue];
        
        self.siteName = [dictSiteData objectForKey:@"site_name"];
        
        
       
        
        FieldData *fieldsData = [[FieldData alloc]init];
        
        
        
        NSLog(@"%d",fieldsData.fieldId);

        
        
    }
    
    return self;
}


@end
