//
//  CategoryData.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 12/04/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryData.h"

#import "FieldData.h"

@implementation CategoryData

-(instancetype)initWithDictionary:(NSDictionary *)catagoryDict
{
    if (self = [super init])
    {
        self.categoryId = [[catagoryDict objectForKey:@"category_id"]intValue];
        self.categoryName = [catagoryDict objectForKey:@"category_name"];
        NSArray *arrayFieldData= [catagoryDict objectForKey:@"field_data"];
        NSMutableArray *categoryMetaArray=nil;
        for (int j=0; j<arrayFieldData.count; j++) {
            NSDictionary *fieldDict= [arrayFieldData[j]mutableCopy];
       // for (NSDictionary *fieldDict in arrayFieldData) {
            FieldData *fieldData = [[FieldData alloc]initWithDictionary:fieldDict];
            if (!categoryMetaArray) {
                categoryMetaArray = [NSMutableArray array];
            }
            if (fieldData.active) {
                [categoryMetaArray addObject:fieldData];
            }
        }
        self.categoryMetaArray = [categoryMetaArray copy];
    }
    return  self;
}
@end
