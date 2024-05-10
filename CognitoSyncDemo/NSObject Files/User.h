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
#import "InstructData.h"

@interface User : NSObject
@property(nonatomic,strong) NSString *corporateEntity;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,assign) int userId;
@property (nonatomic,assign) int userACustomer;

@property(nonatomic,assign) int Device_id;
@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *userType;
@property (nonatomic,assign) int userLevel;
@property(nonatomic,assign) int cId;
@property(nonatomic,assign) int networkId;

@property (nonatomic, strong) NSMutableArray *arrSites;

@property (nonatomic, strong) InstructData *instruct;

//instructData
-(instancetype)initWithDictionary:(NSDictionary *)dictUserData;
@property (nonatomic, assign)int InstructContValue;
@property (nonatomic, strong) NSMutableArray *instructArray;

@end
