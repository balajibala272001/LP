//
//  ImageHelper.m
//  CognitoSyncDemo
//
//  Created by mac on 10/3/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper


+(void)SaveImage:(UIImage *)image
{
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths.firstObject;
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imageFolder = @"Photos";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyMMddHHmmss"];
    NSDate *now = [NSDate date];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *myUniqueName = [NSString stringWithFormat:@"Photo-%@.png",theDate];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,imageFolder];
    
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imagePath isDirectory:&isDir])
        if(![fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: folder creation failed %@", documentDirectory);
    
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@", imagePath, myUniqueName] contents:nil attributes:nil];
    [imageData writeToFile:[NSString stringWithFormat:@"%@/%@", imagePath, myUniqueName] atomically:YES];
}


@end
