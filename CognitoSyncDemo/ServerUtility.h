//
//  ServerUtility.h
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "CognitoHomeViewController.h"
#import "Constants.h"
#import "PPPinPadViewController.h"
#import "PasscodePinViewController.h"



typedef void (^GFWebServiceHandler)(NSError *error, id data);

@interface ServerUtility : NSObject


+(void)getUserName:(NSString *)strUserName andCompletion:(GFWebServiceHandler)completion;

+(void)getUserNameAndUserPin:(NSString *)strUserName withUserPin:(NSString *)strUserPin andCompletion:(GFWebServiceHandler)completion;

+(void)uploadImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource  andCompletion:(GFWebServiceHandler)completion;
+(void)SendAllDetails:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withLoadId:(NSString *)strLoadId andCompletion:(GFWebServiceHandler)completion;


@end
