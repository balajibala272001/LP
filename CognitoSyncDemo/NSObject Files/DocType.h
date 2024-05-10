//
//  DocType.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 13/09/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocType : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)docTypeDict;
@property (nonatomic,strong) NSString *doc_type_id;
@property (nonatomic,strong) NSString *docTypeName;


@end

NS_ASSUME_NONNULL_END
