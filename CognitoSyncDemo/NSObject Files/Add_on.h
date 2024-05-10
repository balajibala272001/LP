//
//  Add_on.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 21/06/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Add_on : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)addonDict;
@property (nonatomic,assign) int addonId;
@property (assign) NSString *addonStatus;
@property (nonatomic,strong) NSString *addonName;
@property (nonatomic,strong) NSString *lastUpdatedTime;


@end

NS_ASSUME_NONNULL_END
