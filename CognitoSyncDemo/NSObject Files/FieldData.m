//
//  FieldData.m
//  CognitoSyncDemo
//
//  Created by mac on 10/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "FieldData.h"
#import "SiteData.h"

@implementation FieldData


-(instancetype)initWithDictionary:(NSDictionary *)dictFieldData{
<<<<<<< HEAD
=======
    @try{
>>>>>>> main
    if (self = [super init]) {

        self.fieldId = [[dictFieldData objectForKey:@"f_id"]intValue];
        self.display = [[dictFieldData objectForKey:@"f_display"]boolValue];
        self.active = [[dictFieldData objectForKey:@"f_active"]boolValue];
        self.fieldLength = [[dictFieldData objectForKey:@"f_length"]intValue];
        if(![[dictFieldData objectForKey:@"f_mandatary"] isEqual:(id)[NSNull null]]){
            self.mandatory = [[dictFieldData objectForKey:@"f_mandatary"]boolValue];
        }
        self.load_centric = [[dictFieldData objectForKey:@"f_load_centric"]boolValue];
        self.strFieldLabel = [self htmlEntityDecode:[dictFieldData objectForKey:@"f_label"]];
        //NSString *strFieldAttrib = @"";
        //if([[dictFieldData objectForKey:@"f_attribute"] isKindOfClass:[NSNull class]]){
        NSString *strFieldAttrib = [dictFieldData objectForKey:@"f_attribute"];
        //}
<<<<<<< HEAD
=======
        NSString *matched = [dictFieldData objectForKey:@"f_matched"];
        if([matched isEqual:@"1"]){
            self.f_matched = true;
        }else {
            self.f_matched = false;
        }
        self.matched_f_id = [dictFieldData objectForKey:@"matched_f_id"];
>>>>>>> main
        NSMutableArray *fieldOptionsArr = [dictFieldData objectForKey:@"f_options"];
        self.fieldOptions = fieldOptionsArr;
        @try{
            if(fieldOptionsArr != nil){
                if (([strFieldAttrib.lowercaseString isEqualToString:@"radio"] ||
                    [strFieldAttrib.lowercaseString isEqualToString:@"checkbox"]) &&
                     ![fieldOptionsArr isEqual:@""]) {
                        NSMutableArray *filteredArr = [[NSMutableArray alloc] init];
                        if(fieldOptionsArr != NO)
                            for (int i = 0; i < [fieldOptionsArr count]; i++) {
                                NSString *lang = (NSString*) [fieldOptionsArr objectAtIndex:i];
                                NSString *str = [self htmlEntityDecode:lang];
                                [filteredArr addObject:str];
                            }
                        self.fieldOptions = filteredArr;
                }else {
                    self.fieldOptions = fieldOptionsArr;
                }
            }else {
                self.fieldOptions = fieldOptionsArr;
            }
        }@catch(NSException *ex){
            NSLog(@"");
            self.fieldOptions = fieldOptionsArr;
        }
        self.customer_id =[[dictFieldData objectForKey:@"customer_id"]boolValue];
        self.siteListId = [dictFieldData objectForKey:@"site_list_id"];
        NSLog(@"customer_id:%i",self.customer_id);
        NSLog(@"siteListId:%@",self.siteListId);
        if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha"]) {
            
            self.fieldAttribute = FieldAttributeAlpha;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"numeric"]) {
            
            self.fieldAttribute = FieldAttributeNumeric;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha/numeric"]) {
            
            self.fieldAttribute = FieldAttributeAlphaNumeric;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"radio"]) {
            
            self.fieldAttribute = FieldAttributeRadio;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"checkbox"]) {
            
            self.fieldAttribute = FieldAttributeCheckbox;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"force barcode"]) {
            
            self.fieldAttribute = FieldAttributeBarcode;
            
        }else if ([strFieldAttrib.lowercaseString isEqualToString:@"date"]) {
            
            self.fieldAttribute = FieldAttributeDatePicker;
        }else if ([strFieldAttrib.lowercaseString isEqualToString:@"comments"]) {
            
            self.fieldAttribute = FieldAttributeComments;
        }
        if ([dictFieldData objectForKey:@"metadata_value"]) {
<<<<<<< HEAD
            NSString *str = [self htmlEntityDecode:[dictFieldData objectForKey:@"metadata_value"]];
            if(str != nil && ![str isEqual:@""]){
                if (!self.qrMetaData) {
                    self.qrMetaData = [NSMutableArray array];
                }
                if([strFieldAttrib.lowercaseString isEqualToString:@"checkbox"]){
                    NSArray *arrayOfComponents = [str componentsSeparatedByString:@","];
                    for(int i = 0; i < arrayOfComponents.count; i++) {
                        [self.qrMetaData addObject:arrayOfComponents[i]];
                    }
                }else {
                    [self.qrMetaData addObject:str];
=======
            if([[dictFieldData objectForKey:@"metadata_value"] isKindOfClass:[NSString class]]){
                NSString *str = [self htmlEntityDecode:[dictFieldData objectForKey:@"metadata_value"]];
                if(str != nil && ![str isEqual:@""]){
                    if (!self.qrMetaData) {
                        self.qrMetaData = [NSMutableArray array];
                    }
                    if([strFieldAttrib.lowercaseString isEqualToString:@"checkbox"]){
                        NSArray *arrayOfComponents = [str componentsSeparatedByString:@","];
                        for(int i = 0; i < arrayOfComponents.count; i++) {
                            [self.qrMetaData addObject:arrayOfComponents[i]];
                        }
                    }else {
                        [self.qrMetaData addObject:str];
                    }
>>>>>>> main
                }
            }
        }
        
    }
<<<<<<< HEAD
=======
    }@catch(NSException *ep){
        NSLog(@"error");
    }
>>>>>>> main
    return self;
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
