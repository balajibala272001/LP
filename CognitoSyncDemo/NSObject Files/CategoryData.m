//
//  CategoryData.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 12/04/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryData.h"
#import "InstructData.h"
#import "FieldData.h"

@implementation CategoryData

-(instancetype)initWithDictionary:(NSDictionary *)catagoryDict
{
    if (self = [super init])
    {
        self.categoryId = [[catagoryDict objectForKey:@"category_id"]intValue];
        self.categoryName = [self htmlEntityDecode:[catagoryDict objectForKey:@"category_name"]];
        self.pcpflag_custom = [catagoryDict objectForKey:@"pcp_flag"];
        
        //Addon7&Addon5_combo
        NSMutableArray *arryInstructData= [catagoryDict objectForKey:@"instruction_data"];
        if(arryInstructData.count !=0){
            self.customInstructData = [arryInstructData copy];
        }else{
            self.customInstructData = [arryInstructData copy];
        }
        
        //Addon5_fieldData
        NSArray *arrayFieldData= [catagoryDict objectForKey:@"field_data"];
        NSMutableArray *categoryMetaArray=nil;
        for (int j=0; j<arrayFieldData.count; j++) {
            NSMutableDictionary *fieldDict= [arrayFieldData[j]mutableCopy];
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

-(NSString *)htmlEntityDecode:(NSString *)string
    {
        string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        string = [string stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"

        return string;
}


@end
