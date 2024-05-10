//
//  InstructData.h
//  CognitoSyncDemo
//
//  Created by SG Apple on 07/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface InstructData : NSObject
@property (nonatomic,assign) int sitee_Id;
-(instancetype)initWithDictionary:(NSDictionary *)arrCapture;
@property (nonatomic,strong) NSMutableArray *instructData;
@property (nonatomic,assign) NSMutableArray *pictCountForStep;
@property (nonatomic,strong) NSMutableArray *instnum;
@property (nonatomic,strong) NSMutableArray *instname;


@end

NS_ASSUME_NONNULL_END
