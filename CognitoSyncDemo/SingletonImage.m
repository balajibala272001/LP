 //
//  SingletonImage.m
//  CognitoSyncDemo
//
//  Created by mac on 10/3/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "SingletonImage.h"

@implementation SingletonImage

- (id)init
{
    self = [super init];
    if ( self )
    {
        //self.arrayDict = [[NSMutableArray alloc] init];
       self.imageDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

+(instancetype)singletonImage
{
    static SingletonImage *singletonImage;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singletonImage = [[SingletonImage alloc]init];
        
        
    });
    
    
    return singletonImage;
    
    
}


//Saving Image to array of dictionaries and nsdocument directory path

-(void)SaveImageInNSdocumentAndCache:(UIImage *)image  withImageName:(NSString *)str
{
  
    //Saving in Image in Local Dictionaries
    
    
    
     [self.imageDict setObject:image forKey:str];
    
   
    //Saving image in nsdocument directory path using nsoperation queue
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Your Background work

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:str];
        NSData* data = UIImageJPEGRepresentation(image,1);
        [data writeToFile:path atomically:YES];
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update your UI
            
            
        });
    });
    
  
    
}


//delete a picture in dictionary

-(NSMutableDictionary *)DeletePicture:(NSString *)text: (NSInteger)number
{
    
    NSMutableDictionary *dict;
    
    if ([self.imageDict objectForKey:text])
    
    {
    
        [self.imageDict removeObjectForKey:text];
        dict = self.imageDict;
        
        }
    
    return dict;
    
    
}


//Provide the image if it is in dictionary
- (UIImage *)ProvideImage:(NSString *)text {
    
    UIImage *Savedimage;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:text];
   
     if ([self.imageDict objectForKey:text])
    
    {
    
        Savedimage = [self.imageDict objectForKey:text];
        
    }
    
    else if([[NSFileManager defaultManager]fileExistsAtPath:filePath])
    {
        
        Savedimage = [UIImage imageWithContentsOfFile:filePath];
        
        
       [self.imageDict setObject:Savedimage forKey:text];

        // NSLog(@"File exists at the path");
    
        }
        else
    
        {
            NSLog(@"Image doesnot exist");
            
        }
    
    
    
  return Savedimage;
}



-(void)nilTheDictionary
{
    

    
    self.imageDict = [NSMutableDictionary dictionary];
    
    
}

@end
