//
//  Site.m
//  CognitoSyncDemo
//
//  Created by mac on 10/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "Site.h"

#import "FieldData.h"
#import "User.h"

@implementation Site



-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData
{
    
    
    
    if (self = [super init]) {
        
        
        self.siteId = [[dictSiteData objectForKey:@"s_id"]intValue];
        
        self.siteName = [dictSiteData objectForKey:@"site_name"];
                
        
    }
    
    return self;
}

@end
