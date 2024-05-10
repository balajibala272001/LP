//
//  fieldclass.h
//  CognitoSyncDemo
//
//  Created by mac on 12/20/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, newFieldAttribute) {
    newFieldAttributeAlpha = 0,
    newFieldAttributeNumeric,
    newFieldAttributeAlphaNumeric,
    newFieldAttributeBarcode,
    newFieldAttributeDatePicker
};

@interface fieldclass : NSObject

@property(nonatomic, assign) int fieldId;
@property(nonatomic, assign) newFieldAttribute fieldAttribute;
@property(nonatomic, assign) int fieldLength;
@property (nonatomic, strong) NSString *strFieldLabel;
@property (nonatomic, assign, getter=shouldDisplay) BOOL display;
@property (nonatomic,assign, getter=shouldActive) BOOL active;

@property (nonatomic, assign, getter=isMandatory) BOOL mandatory;

-(instancetype)initWithDictionary:(NSDictionary *)dictFieldData;
@end
