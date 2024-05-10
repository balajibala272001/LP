//
//  Add_on_8.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 25/08/2022.
//  Copyright © 2022 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Add_on_8 : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)looping_details;
@property (nonatomic,strong) NSMutableArray *base_meta;
@property (nonatomic,strong) NSMutableArray *child_meta;
@property (nonatomic,strong) NSMutableArray *baseMetaData;
@property (nonatomic,strong) NSMutableArray *loopingMetaData;

@end

NS_ASSUME_NONNULL_END
