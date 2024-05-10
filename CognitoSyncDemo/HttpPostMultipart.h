//
//  HttpPostMultipart.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 24/07/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpPostMultipart:NSObject
-(id)initWithUrl:(NSString *)urlString;

@property(nonatomic) NSMutableURLRequest *request;
@property(nonatomic) NSString *urlString;
@property(nonatomic) NSMutableDictionary *headers;
@property(nonatomic) NSMutableDictionary *fields;
@property(nonatomic) NSMutableDictionary *files;

/// Adds a header to the request
/// @param key Header key
/// @param value Header value
-(void)addHeader:(NSString *)key value:(NSString *)value;

/// Adds a form field to the request
/// @param key Field name
/// @param value Field value
-(void)addFormField:(NSString *)key value:(NSString *)value;

/// Adds a upload file section to the request
/// @param key Field name of the upload file
/// @param path File path
-(void)addFormFile:(NSString *)key path:(NSString *)path;

/// Completes the request
/// @param callback The callback block
- (void)finish:(void(^)(NSData *, NSURLResponse *, NSError *))callback;

@end
