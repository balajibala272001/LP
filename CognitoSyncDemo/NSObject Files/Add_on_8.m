//
//  Add_on_8.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 25/08/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import "Add_on_8.h"
#import "FieldData.h"

@implementation Add_on_8

-(instancetype)initWithDictionary:(NSDictionary *)looping_details

{
    if (self = [super init])
    {
        self.base_meta = [looping_details objectForKey:@"base_meta"];
        NSLog(@"self.base_meta:%@",self.base_meta);
        self.child_meta = [looping_details objectForKey:@"looping_meta"];
        NSLog(@"self.child_meta%@",self.child_meta);
        NSMutableArray *baseMetaArray=nil;
        NSMutableArray *loopingMetaArray=nil;
        for (int i=0; i<self.base_meta.count; i++) {
            NSDictionary *fieldDict= [self.base_meta[i]mutableCopy];
            FieldData *fieldData = [[FieldData alloc]initWithDictionary:fieldDict];
            if (!baseMetaArray) {
                baseMetaArray = [NSMutableArray array];
            }
            if (fieldData.active) {
                [baseMetaArray addObject:fieldData];
            }
        }
        self.baseMetaData = [baseMetaArray copy];
        for (int j=0; j<self.child_meta.count; j++) {
            NSDictionary *fieldDict= [self.child_meta[j]mutableCopy];
            FieldData *fieldData = [[FieldData alloc]initWithDictionary:fieldDict];
            if (!loopingMetaArray) {
                loopingMetaArray = [NSMutableArray array];
            }
            if (fieldData.active) {
                [loopingMetaArray addObject:fieldData];
            }
        }
        self.loopingMetaData = [loopingMetaArray copy];
    }
    return  self;
}

@end
