//
//  User.h
//  CognitoSyncDemo
//
//  Created by mac on 10/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldData.h"
#import "SiteData.h"

@interface User : NSObject
@property(nonatomic,strong) NSString *corporateEntity;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,assign) int userId;
@property (nonatomic,assign) int userACustomer;


@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;

@property (nonatomic,strong) NSString *userType;
@property (nonatomic,assign) int userLevel;
@property(nonatomic,assign) int cId;

@property (nonatomic, strong) NSMutableArray *arrSites;

-(instancetype)initWithDictionary:(NSDictionary *)dictUserData;




@end
