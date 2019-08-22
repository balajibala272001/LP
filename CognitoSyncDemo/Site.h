//
//  Site.h
//  CognitoSyncDemo
//
//  Created by mac on 10/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Site : NSObject

@property (nonatomic,assign) int siteId;
@property (nonatomic,strong) NSString *siteName;


-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData;






//@property (strong,nonatomic) FieldData *fieldData;



@end
