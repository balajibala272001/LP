//
//  ServerUtility.m
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//

#import "ServerUtility.h"

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <objc/runtime.h>

@interface ServerUtility()

@end
@implementation ServerUtility


#pragma mark - Public Methods


+(void)getUserName:(NSString *)strUserName andCompletion:(GFWebServiceHandler)completion
{
    NSDictionary *getUserName =@{@"user_name":strUserName
                                
                                };
    NSString *strGetUserName = [NSString stringWithFormat:@"%@/%@",BASE_URL,API_GET_USER_NAME];
    
     [self createGETRequestWithParams:getUserName urlString:strGetUserName andCompletion:completion];
    }

+(void)getUserNameAndUserPin:(NSString *)strUserName withUserPin:(NSString *)strUserPin andCompletion:(GFWebServiceHandler)completion
{
    
    NSDictionary *getUserNameAndPin =@{@"user_name":strUserName,
                                       @"user_pin": strUserPin                                       };
    
    NSString *strUserNameAndUserPin = [NSString stringWithFormat:@"%@/%@",BASE_URL,API_GET_USER_NAME_AND_USER_PIN];
    
    [self createGETRequestWithParams:getUserNameAndPin urlString:strUserNameAndUserPin andCompletion:completion];
    
}


//code given by milan sir
+(void)uploadImageWithAllDetails:(NSDictionary *)dictNoteDetails noteResource:(NSData *)noteResource andCompletion:(GFWebServiceHandler)completion
{
    NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",BASE_URL,API_TO_UPLOAD_IMAGE];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictNoteDetails
                                                       options:0
                     
                                                         error:nil];
   
     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString:%@",jsonString);
    
    
    [manager POST:createNoteUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        
        [formData appendPartWithFormData:jsonData name:@"userDetails"];
        
        
        
        if (noteResource) {
            
            [formData appendPartWithFileData:noteResource name:@"userImage" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
            
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];

        completion(nil,responseObject);
        
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation  *operation, NSError  *error) {
        completion(error,nil);
        NSLog(@"Error: %@", error);
    }];
    
}

+(void)SendAllDetails:(NSString *)usertype withEmail:(NSString *)strEmail withFirstName:(NSString *)strFirstName withLastName:(NSString *)strLastName withSiteName:(NSString *)strSiteName withLoadId:(NSString *)strLoadId andCompletion:(GFWebServiceHandler)completion
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://52.87.170.191/loadproof/api/v1/quality_email.php"]];
    
   // NSString *userUpdate =[NSString stringWithFormat:@"user_type=%@&email_id=%@&first_name_load=%@&last_name_load=%@&site_name=%@&load_Id=%@",usertype,strEmail,strFirstName,strLastName,strSiteName,strLoadId,nil];
    
  
     NSString *userUpdate =[NSString stringWithFormat:@"user_type=%@&email_id=%@&first_name_load=%@&last_name_load=%@&site_name=%@&last_insert_load_id=%@",usertype,strEmail,strFirstName,strLastName,strSiteName,strLoadId,nil];
    
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
       NSLog(@"url request%@",urlRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                NSLog(@"Login SUCCESS");
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
    
    
    
}





//****************************************************
#pragma mark - Helper Method for POST and GET request
//****************************************************



+(AFHTTPRequestOperationManager *)createPOSTRequestWithParams:(NSDictionary *)dictParams urlString:(NSString *)strUrl andCompletion:(GFWebServiceHandler)completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = responseSerializer;
    
    NSString *strEncodedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:strEncodedUrl parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil);
    }];
    
    return manager;
}

+(AFHTTPRequestOperationManager *)createGETRequestWithParams:(NSDictionary *)dictParams urlString:(NSString *)strUrl andCompletion:(GFWebServiceHandler)completion
{
    NSString *strUrlWithParams = [self stringByAppendingParams:dictParams toUrlString:strUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
   //responseSerializer.removesKeysWithNullValues = YES;
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    NSString *strEncodedUrl = [strUrlWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:strEncodedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        
        NSLog(@"%@",responseObject);
        
        completion(nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error,nil);
    }];
    
    return manager;
}

+(NSString *)stringByAppendingParams:(NSDictionary *)dictParams toUrlString:(NSString *)strUrl
{
    if (strUrl.length > 0) {
        
        NSMutableString *strUrlWithParams = [NSMutableString stringWithString:strUrl];
        if (dictParams.count > 0) {
            ///Append ? for first param
            [strUrlWithParams appendString:@"?"];
            
            for (id paramName in [dictParams allKeys]) {
                
                ///Get value associated to param name
                id paramVal = [dictParams objectForKey:paramName];
                
                ///Append Param
                [strUrlWithParams appendFormat:@"%@=%@&",paramName,paramVal];
            }
            
            ///Remove & from last
            NSRange lastCharRange = NSMakeRange(strUrlWithParams.length - 1, 1);
            [strUrlWithParams deleteCharactersInRange:lastCharRange];
            
        }
        
        return strUrlWithParams;
    }
    
    return nil;
}



@end
