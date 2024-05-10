//
//  DocType.m
//  CognitoSyncDemo
//
//  Created by smartgladiator on 13/09/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocType.h"

@implementation DocType


-(instancetype)initWithDictionary:(NSDictionary *)docTypeDict

{
    if (self = [super init])
    {
        self.doc_type_id = [docTypeDict objectForKey:@"upload_type_id"];
        self.docTypeName = [self htmlEntityDecode:[docTypeDict objectForKey:@"upload_list"]];
    }
   return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.doc_type_id forKey:@"upload_type_id"];
    [encoder encodeObject:self.docTypeName forKey:@"upload_list"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init]))
    {
    //decode properties, other class vars
    self.doc_type_id = [decoder decodeObjectForKey:@"upload_type_id"];
    self.docTypeName = [decoder decodeObjectForKey:@"upload_list"];
    }
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
