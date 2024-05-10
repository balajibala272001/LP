//
//  SiteData.m
//  CognitoSyncDemo
//
//  Created by mac on 10/23/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//
#import "Add_on.h"
#import "SiteData.h"
#import "FieldData.h"
#import "AZCAppDelegate.h"
#import "InstructData.h"
#import "Add_on_8.h"

@implementation SiteData


-(instancetype)initWithDictionary:(NSDictionary *)dictSiteData
{
    if (self = [super init]) {
        
        self.siteId = [[dictSiteData objectForKey:@"s_id"]intValue];
        self.image_quality=[dictSiteData objectForKey:@"image_quality"];
        self.siteName = [dictSiteData objectForKey:@"site_name"];
        self.planname = [dictSiteData objectForKey:@"plan"];
        self.uploadC = [dictSiteData objectForKey:@"plancount"];
        
        //Custom-Category
        if ([dictSiteData valueForKey:@"addon_enable"])
        {
            NSMutableArray *dictionary= [dictSiteData objectForKey:@"addon_enable"];
            for (int i=0; i< dictionary.count; i++) {
                NSMutableDictionary *catagoryDict = [[dictionary objectAtIndex:i] mutableCopy];
                
                //pass data to obj class.
                Add_on *add_on = [[Add_on alloc]initWithDictionary:catagoryDict];
                if(!self.categoryAddon) {
                    self.categoryAddon = [NSMutableArray array];
                }
                [self.categoryAddon addObject: add_on] ;
            }
        }
        NSLog(@"categoryAddon:%@",self.categoryAddon);
        
        //Addon-8
        //self.categoryAddon valueForKey:
        if ([dictSiteData valueForKey:@"looping_metadata"] !=nil){
            NSMutableArray *looping_metadata= [dictSiteData objectForKey:@"looping_metadata"];
            for (int i=0; i< looping_metadata.count; i++) {
                NSMutableDictionary *looping_details = [[looping_metadata objectAtIndex:i] mutableCopy];
                //pass data to obj class.
                Add_on_8 *add_on_8 = [[Add_on_8 alloc] initWithDictionary: looping_details];
                if(!self.looping_data) {
                    self.looping_data = [NSMutableArray array];
                }
                [self.looping_data addObject: add_on_8] ;
            }
        }
        NSLog(@"looping_data:%@",self.looping_data);
//
        
        //GalleryMode
        if ([dictSiteData valueForKey:(@"addon_gallery_mode")] !=nil){
            self.addon_gallery_mode=[dictSiteData objectForKey:@"addon_gallery_mode"];
        }else{
            self.addon_gallery_mode=@"FALSE";
            NSLog(@"bool :%@--> %@",self.siteName,self.addon_gallery_mode);
        }
     
        
        
        if ([dictSiteData valueForKey:(@"add_on_name")]){
            self.addOn=[dictSiteData objectForKey:@"add_on_name"];
            if (self.addOn.boolValue) {
               self.addOnMail=[dictSiteData objectForKey:@"send_addon_email"];
            }
            
        }
        if ([self.planname  isEqual: @"Silver"]) {
            self.uploadCount = 50 ;
            NSLog(@"uploadCount1 %d",self.uploadCount);

        }else{
            self.uploadCount = [[dictSiteData objectForKey:@"plancount"] intValue];
            NSLog(@"uploadCount%d",self.uploadCount);

        }
        
    
        //Freetier-Suresh
        if ([self.planname isEqual:@"FreeTier"]) {
            
            if ([dictSiteData valueForKey:(@"RemainingImagecount")]  && [dictSiteData valueForKey:(@"RemainingVideocount")]  ) {

                self.RemainingVideocount=[[dictSiteData objectForKey:@"RemainingVideocount"]  intValue];
                self.RemainingImagecount=[[dictSiteData objectForKey:@"RemainingImagecount"] intValue];
                if (self.uploadCount>[[dictSiteData objectForKey:@"RemainingImagecount"] intValue]) {
                    if ([[dictSiteData objectForKey:@"RemainingImagecount"] intValue]>50) {
                        self.uploadCount=[[dictSiteData objectForKey:@"RemainingImagecount"] intValue];
                    }else{
                        self.uploadCount =[[dictSiteData objectForKey:@"RemainingImagecount"] intValue] + [[dictSiteData objectForKey:@"RemainingVideocount"] intValue];
                    }
                }
            }

        }else{
            if ([dictSiteData valueForKey:(@"RemainingSpacePercentage")]) {
                
                
                self.RemainingSpacePercentage=[[dictSiteData objectForKey:@"RemainingSpacePercentage"] doubleValue] ;


                if ((self.RemainingSpacePercentage>0 && self.RemainingSpacePercentage<5.0)) {
                   self.LowStorage=@"1";
                }else
                    self.LowStorage=@"0";
                
                NSLog(@"Storage %@ Percent %.2f",self.LowStorage,self.RemainingSpacePercentage);

            }
        }

        FieldData *fieldsData = [[FieldData alloc]init];
        NSLog(@"fieldId %d",fieldsData.fieldId);
        
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.siteName forKey:@"siteName"];
    [encoder encodeObject:self.image_quality forKey:@"image_quality"];
    
     [encoder encodeObject:self.planname forKey:@"plan"];
    [encoder encodeInt:self.siteId forKey:@"siteId"];
    [encoder encodeInt:self.networkId forKey:@"networkId"];
    [encoder encodeObject:self.arrFieldData forKey:@"arrFieldData"];
    

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.siteName = [decoder decodeObjectForKey:@"siteName"];
        self.image_quality = [decoder decodeObjectForKey:@"image_quality"];
         self.planname = [decoder decodeObjectForKey:@"plan"];
        self.siteId = [decoder decodeIntForKey:@"siteId"];
        self.networkId = [decoder decodeIntForKey:@"networkId"];
        self.arrFieldData = [decoder decodeObjectForKey:@"siteName"];
    }
    return self;
}

//+(void)saveCustomObject:(SiteData *)object key:(NSString *)key {
//
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:object forKey:key];
//    [defaults synchronize];
//}

//+(SiteData*)loadCustomObjectWithKey:(NSString *)key {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *encodedObject = [defaults rm_customObjectForKey:key];
//    SiteData *object = [defaults rm_customObjectForKey:key];
////    [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
//    return object;
//}

@end
