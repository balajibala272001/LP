//
//  SingletonImage.h
//  CognitoSyncDemo
//
//  Created by mac on 10/3/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonImage : NSObject
{
    NSOperationQueue *operationQueue;
    
}

-(void)saveImageInDocument:(UIImage *)image withImageName:(NSString *)str;



@property (nonatomic,strong)NSMutableDictionary *imageDict;
//@property (nonatomic,strong)NSMutableArray *arrayDict;





//methods
+(instancetype)singletonImage;

-(void)SaveImageInNSdocumentAndCache:(UIImage *)image  withImageName:(NSString *)str;
- (UIImage *)ProvideImage:(NSString *)text;




-(NSMutableDictionary *)DeletePicture:(NSString *) text: (NSInteger)number;

-(void)nilTheDictionary;




@end
