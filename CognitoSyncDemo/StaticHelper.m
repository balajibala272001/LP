//
//  StaticHelper.m
//  gullyfood
//
//  Created by Milan Agarwal on 07/11/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "StaticHelper.h"

@implementation StaticHelper
//****************************************************
#pragma mark - Generic Helper Methods
//****************************************************

+(void)showAlertWithTitle:(NSString *)strTitle message:(NSString *)strMessage onViewController:(UIViewController *)viewController
{
    if ([UIAlertController class]) {
        ///Show UIAlertController
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            ///Do anything required on OK action
            
        }];
        
        [alertController addAction:okAction];
        [viewController presentViewController:alertController animated:YES completion:NULL];
        
    }
    else{
        
        ///Show UIAlertView
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
}


+(BOOL)canUseJsonObject:(id)jsonObject
{
    if(jsonObject && (![jsonObject isKindOfClass:[NSNull class]]))
    {
        if ([jsonObject isKindOfClass:[NSString class]] && ([[(NSString *)jsonObject lowercaseString]isEqualToString:@"null"])) {
            
            return NO;
        }
        return YES;
    }
    
    return NO;
}


// Assumes input like "00FF00" (RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    //[scanner setScanLocation:1]; //to bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


+(BOOL)validateResponse:(id)data andShowError:(BOOL)showError onViewController:(UIViewController *)viewController withCustomErrorMsg:(NSString *)strCustomErrMsg
{
 
    ///Check the response
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            ///Get value of success
            BOOL success = [[data objectForKey:@"success"]boolValue];
            if (success) {
                
                ///Get data Value
                return YES;
                
            }
            else{
                
                ///Show error message if exist
                NSString *errorMsg = [data objectForKey:@"errorMessage"];
                if (!([StaticHelper canUseJsonObject:errorMsg] && errorMsg.length > 0)) {
                    
                    ///Make a custom errorMsg, if not available
                    if (strCustomErrMsg.length > 0) {
                        
                        errorMsg = strCustomErrMsg;
                    }
                    else{
                        
                        errorMsg = NSLocalizedString(@"No results found", nil);
                    }
                    
                    
                }
                if (showError) {
                    
                    ///show alert
                    [StaticHelper showAlertWithTitle:nil message:errorMsg onViewController:viewController];
                }
                else{
                    
                    ///Log error
                    NSLog(@"#error:%@",errorMsg);
                }
               
            }
        }
        else{
            ///Invalid data, NSDictionary expected
            NSLog(@"#Invalid Data %@",data);
            
        }
        
    return NO;
    
}
+(void)setLocalizedBackButtonForViewController:(UIViewController *)parentViewController
{
    NSString *strLocalizedBackTitle = NSLocalizedString(@"Back", nil);
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:strLocalizedBackTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [parentViewController.navigationItem setBackBarButtonItem:backBarButton];
    
}



@end
