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
    FieldAttributeBarcode,
    FieldAttributeDatePicker,
    FieldAttributeComments
};

@interface FieldData : NSObject

@property(nonatomic, assign) int fieldId;
@property(nonatomic, assign) FieldAttribute fieldAttribute;
@property(nonatomic,strong) NSMutableArray * fieldOptions;
@property(nonatomic,strong) NSMutableArray * dummyFieldOptions;
@property(nonatomic,strong) NSMutableArray *siteListId;
@property(nonatomic, assign) int fieldLength;
@property(nonatomic, strong) NSString *strFieldLabel;
@property(nonatomic, assign, getter=shouldDisplay) BOOL display;
@property(nonatomic,assign, getter=shouldActive) BOOL active;
@property(nonatomic, assign, getter=isCustomerId) BOOL customer_id;
@property(nonatomic, assign, getter=isMandatory) BOOL mandatory;
@property(nonatomic,assign, getter=loadCentric) BOOL load_centric;
<<<<<<< HEAD
@property(nonatomic,strong) NSMutableArray *qrMetaData;
=======
@property(nonatomic,assign, getter=fMatched) BOOL f_matched;
@property(nonatomic,strong) NSMutableArray *qrMetaData;
@property(nonatomic,strong) NSMutableArray *matched_f_id;
>>>>>>> main
@property(nonatomic, assign, getter=isAvailQRPrint) BOOL isAvailQRPrint;

-(instancetype)initWithDictionary:(NSDictionary *)dictFieldData;

@end
