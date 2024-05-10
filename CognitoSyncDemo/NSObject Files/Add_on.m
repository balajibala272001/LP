//
//  Add_on.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 21/06/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import "Add_on.h"

@implementation Add_on


-(instancetype)initWithDictionary:(NSDictionary *)addonDict

{
    if (self = [super init])
    {
        self.addonId = [[addonDict objectForKey:@"addon_id"]intValue];
        self.addonName = [addonDict objectForKey:@"addon_name"];
        self.addonStatus = [addonDict objectForKey:@"is_addon_status"];
        self.lastUpdatedTime = @"";
        self.lastUpdatedTime = [addonDict objectForKey:@"category_updated_time"];
        NSLog(@"time:%@",self.lastUpdatedTime);
        NSLog(@"bool:%@",self.addonStatus);
    }
   return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    //Encode properties, other class variables, etc
    [encoder encodeInt:self.addonId forKey:@"addon_id"];
    [encoder encodeObject:self.addonName forKey:@"addon_name"];
    [encoder encodeBool:self.addonStatus forKey:@"is_addon_status"];
    [encoder encodeObject:self.lastUpdatedTime forKey:@"category_updated_time"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init]))
    {
    //decode properties, other class vars
    self.addonId = [decoder decodeIntForKey:@"addon_id"];
    self.addonName = [decoder decodeObjectForKey:@"addon_name"];
    self.addonStatus = [decoder decodeObjectForKey:@"is_addon_status"];
    self.lastUpdatedTime = [decoder decodeObjectForKey:@"category_updated_time"];
    }
    return self;
}

@end
