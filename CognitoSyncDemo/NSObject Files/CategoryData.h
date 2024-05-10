//
//  CategoryData.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 12/04/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CategoryData : NSObject
-(instancetype)initWithDictionary:(NSDictionary *)catagoryDict;
@property (nonatomic,assign) int categoryId;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSMutableArray *categoryMetaArray;

@end

NS_ASSUME_NONNULL_END
