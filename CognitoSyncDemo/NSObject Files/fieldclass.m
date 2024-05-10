//
//  fieldclass.m
//  CognitoSyncDemo
//
//  Created by mac on 12/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "fieldclass.h"

@implementation fieldclass

-(instancetype)initWithDictionary:(NSDictionary *)dictFieldData
{
    if (self = [super init]) {
        
        
        self.fieldId = [[dictFieldData objectForKey:@"f_id"]intValue];
        self.display = [[dictFieldData objectForKey:@"f_display"]boolValue];
        self.active = [[dictFieldData objectForKey:@"f_active"]boolValue];
        
        self.fieldLength = [[dictFieldData objectForKey:@"f_length"]intValue];
        self.mandatory = [[dictFieldData objectForKey:@"f_mandatary"]boolValue];
        self.strFieldLabel = [dictFieldData objectForKey:@"f_label"];
        
        NSString *strFieldAttrib = [dictFieldData objectForKey:@"f_attribute"];
        if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha"]) {
            
            self.fieldAttribute = newFieldAttributeAlpha;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"numeric"]) {
            
            self.fieldAttribute = newFieldAttributeNumeric;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha_numeric"]) {
            
            self.fieldAttribute = newFieldAttributeAlphaNumeric;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"Force Barcode"]) {
            
            self.fieldAttribute = newFieldAttributeBarcode;
        }else if ([strFieldAttrib.lowercaseString isEqualToString:@"Date"]) {
            
            self.fieldAttribute = newFieldAttributeDatePicker;
        }else if ([strFieldAttrib.lowercaseString isEqualToString:@"Comments"]) {
            
            self.fieldAttribute = newFieldAttributeComments;
        }
        
        
        
        
    }
    
    return self;
}


@end
