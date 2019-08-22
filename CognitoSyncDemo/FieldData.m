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
        
        NSMutableArray *fieldOptionsArr = [dictFieldData objectForKey:@"f_options"];
        
        self.fieldOptions = fieldOptionsArr;
        
        if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha"]) {
            
            self.fieldAttribute = FieldAttributeAlpha;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"numeric"]) {
            
            self.fieldAttribute = FieldAttributeNumeric;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"alpha_numeric"]) {
            
            self.fieldAttribute = FieldAttributeAlphaNumeric;
        }
       
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"radio"]) {
            
            self.fieldAttribute = FieldAttributeRadio;
        }
        else if ([strFieldAttrib.lowercaseString isEqualToString:@"checkbox"]) {
            
            self.fieldAttribute = FieldAttributeCheckbox;
        }
        
     
        
    }
    
    return self;
}



@end
