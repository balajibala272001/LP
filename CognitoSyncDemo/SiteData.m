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
        self.uploadCount = [[dictSiteData objectForKey:@"plancount"] intValue];

        FieldData *fieldsData = [[FieldData alloc]init];
        NSLog(@"%d",fieldsData.fieldId);
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.siteName forKey:@"siteName"];
    [encoder encodeInt:self.siteId forKey:@"siteId"];
    [encoder encodeInt:self.networkId forKey:@"networkId"];
    [encoder encodeObject:self.arrFieldData forKey:@"arrFieldData"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.siteName = [decoder decodeObjectForKey:@"siteName"];
        self.siteId = [decoder decodeIntForKey:@"siteId"];
        self.networkId = [decoder decodeIntForKey:@"networkId"];
        self.arrFieldData = [decoder decodeObjectForKey:@"siteName"];
    }
    return self;
}

//+(void)saveCustomObject:(SiteData *)object key:(NSString *)key {
//    
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:object forKey:key];
//    [defaults synchronize];
//}

//+(SiteData*)loadCustomObjectWithKey:(NSString *)key {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *encodedObject = [defaults rm_customObjectForKey:key];
//    SiteData *object = [defaults rm_customObjectForKey:key];
////    [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
//    return object;
//}

@end
