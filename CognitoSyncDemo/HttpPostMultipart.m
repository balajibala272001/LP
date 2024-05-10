//
//  HttpPostMultipart.m
//  CognitoSyncDemo
//
//  Created by smartgladiator on 24/07/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import "HttpPostMultipart.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation HttpPostMultipart

-(id)initWithUrl:(NSString *)urlString{
  self.request = [[NSMutableURLRequest alloc]init];
  self.urlString = urlString;
  self.headers = [[NSMutableDictionary alloc]init];
  self.fields = [[NSMutableDictionary alloc]init];
  self.files = [[NSMutableDictionary alloc]init];
  return self;
}

-(void)addHeader:(NSString *)key value:(NSString *)value{
  [self.headers setObject:value forKey:key];
}

-(void)addFormField:(NSString *)key value:(NSString *)value{
  [self.fields setObject:value forKey:key];
}

-(void)addFormFile:(NSString *)key path:(NSString *)path{
  [self.files setObject:path forKey:key];
}

- (void)finish:(void (^)(NSData *, NSURLResponse *, NSError *))callback{
  NSURL *url = [[NSURL alloc]initWithString:self.urlString];
  [self.request setURL:url];
  [self.request setHTTPMethod:@"POST"];
  // Add haders
  for (NSString *key in self.headers){
    NSString *value = self.headers[key];
    [self.request setValue:value forHTTPHeaderField:key];
  }
  // Add Content-Type
  NSString *boundary = @"unique-consistent-string";
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [self.request setValue:contentType forHTTPHeaderField:@"Content-Type"];
  // Add fields
  NSMutableData *body = [NSMutableData data];
  for (NSString *key in self.fields){
    NSString *value = self.fields[key];
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  // Add file
  for (NSString *key in self.files){
    NSString *path = self.files[key];
    NSString *fileName = [path lastPathComponent];
    
    NSString *fileExtension = [path pathExtension];
    NSString *contentType = [self getMimeType:fileExtension];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", key, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithContentsOfFile:path]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  if ([body length] > 0) {
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [self.request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%ld", [body length]];
    [self.request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  }
  
  void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
    if (callback) {
      callback(data, response, error);
    }
  };
  
  [[[NSURLSession sharedSession] dataTaskWithRequest:self.request completionHandler:completionHandler] resume];
}

/// Get mime type of the file
/// @param fileExtension file extension
- (NSString *)getMimeType:(NSString *)fileExtension{
  NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
  NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
  return mimeType;
}

@end

