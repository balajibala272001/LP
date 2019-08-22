//
//  FieldData.h
//  CognitoSyncDemo
//
//  Created by mac on 10/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FieldAttribute) {
    FieldAttributeAlpha = 0,
    FieldAttributeNumeric,
    FieldAttributeAlphaNumeric,
    FieldAttributeRadio,
    FieldAttributeCheckbox,
};

@interface FieldData : NSObject

@property(nonatomic, assign) int fieldId;
@property(nonatomic, assign) FieldAttribute fieldAttribute;
@property(nonatomic,strong) NSMutableArray * fieldOptions;
@property(nonatomic,strong) NSMutableArray * dummyFieldOptions;
@property(nonatomic, assign) int fieldLength;
@property (nonatomic, strong) NSString *strFieldLabel;
@property (nonatomic, assign, getter=shouldDisplay) BOOL display;
@property (nonatomic,assign, getter=shouldActive) BOOL active;

@property (nonatomic, assign, getter=isMandatory) BOOL mandatory;

-(instancetype)initWithDictionary:(NSDictionary *)dictFieldData;



@end
