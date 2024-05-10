//
//  StaticHelper.h
//  gullyfood
//
//  Created by Milan Agarwal on 07/11/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface StaticHelper : NSObject

//****************************************************
#pragma mark - Generic Helper Methods
//****************************************************

/*!
 * @description Helper method to show UIAlertView
 * @param strTitle Takes NSString or localizedString to be used as title of Alert View. It can be nil
 * @param strMessage Takes NSString or localizedString to be used to show message to user.
 * @param viewController the top view controller
 */
+(void)showAlertWithTitle:(NSString *)strTitle message:(NSString *)strMessage onViewController:(UIViewController *)viewController;




/*!
 * @description Helper method to validate JSON object specially fetched from a web service API for NULL and nil.
 * @param jsonObject Any json object to be validated for Not NULL and nil.
 * @result YES if the object is neither nil nor of NSNULL type otherwise NO.
 */
+(BOOL)canUseJsonObject:(id)jsonObject;


// Assumes input like "00FF00" (RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;


+(BOOL)validateResponse:(id)data andShowError:(BOOL)showError onViewController:(UIViewController *)viewController withCustomErrorMsg:(NSString *)strCustomErrMsg;


@end
