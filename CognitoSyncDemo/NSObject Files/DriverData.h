//
//  DriverData.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 23/05/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldData.h"
#import "SiteData.h"
#import "InstructData.h"

@interface DriverData : NSObject
@property(nonatomic,strong) NSString *corporateEntity;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *nid;
@property(nonatomic,strong) NSString *loadid;
@property(nonatomic,strong) NSString *plancount;
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
@property (nonatomic, strong) NSMutableArray *arrFieldsData;
@property (nonatomic, strong) InstructData *instruct;
@property (nonatomic, strong) NSMutableArray *qrArrFieldsData;

//instructData
-(instancetype)initWithDictionary:(NSDictionary *)dictUserData;
@property (nonatomic, assign)int InstructContValue;
@property (nonatomic, strong) NSMutableArray *instructArray;

@end

