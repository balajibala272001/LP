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


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.siteName forKey:@"siteName"];
    [encoder encodeObject:@(self.siteId) forKey:@"siteId"];
    [encoder encodeObject:@(self.networkId) forKey:@"networkId"];
    [encoder encodeObject:self.arrFieldData forKey:@"arrFieldData"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.siteName = [decoder decodeObjectForKey:@"siteName"];
        self.siteId = [decoder decodeIntegerForKey:@"siteId"];
        self.networkId = [decoder decodeIntegerForKey:@"networkId"];
        self.arrFieldData = [decoder decodeObjectForKey:@"siteName"];
    }
    return self;
}

+(void)saveCustomObject:(SiteData *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+(SiteData*)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    SiteData *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
