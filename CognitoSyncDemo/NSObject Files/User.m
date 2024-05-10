    //
    //  User.m
    //  CognitoSyncDemo
    //
    //  Created by mac on 10/20/16.
    //  Copyright © 2016 Behroozi, David. All rights reserved.
    //

#import "User.h"
#import "AZCAppDelegate.h"

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictUserData
{
    if (self =[super init]) {
        
        self.corporateEntity = [dictUserData objectForKey:@"corporate_entity"];
        
        self.userName = [dictUserData objectForKey:@"user_name"];
        self.userId = [[dictUserData objectForKey:@"user_id"]intValue];
        self.userACustomer = [[dictUserData objectForKey:@"user_a_customer"]intValue];
        self.firstName = [dictUserData objectForKey:@"firstname"];
        self.lastName = [dictUserData objectForKey:@"lastname"];
        self.userType = [dictUserData objectForKey:@"user_type"];
        self.userLevel = [[dictUserData objectForKey:@"user_level"]intValue];
        self.cId = [[dictUserData objectForKey:@"c_id"]intValue];
        self.Device_id=[[dictUserData objectForKey:@"device_id"] intValue];
        [[NSUserDefaults standardUserDefaults]setInteger:self.cId forKey:@"cID"];
        [[NSUserDefaults standardUserDefaults]setInteger:self.userId forKey:@"uID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
            //iterate the dictionary and pass it overheree
        NSArray *arrNetworkData = [dictUserData objectForKey:@"network-data"];
        
        if([dictUserData valueForKey:@"profile_capture_details"] )
        {
            NSDictionary* arrCapture = [dictUserData objectForKey:@"profile_capture_details"];
            NSLog(@"arrCapture %@:",arrCapture);
            if([arrCapture valueForKey:@"site_id"] && ([arrCapture count] != 0)){
            InstructData * instruct = [[InstructData alloc]  initWithDictionary:arrCapture];
            self.instruct = instruct;
           
            NSLog(@"instruct:%@",instruct);
            }
        }
        
        for (NSDictionary *dictNetworkData in arrNetworkData) {
            int networkId = [[dictNetworkData objectForKey:@"n_id"] intValue];
                ///Create the array of field data
            NSArray *arrRawFieldData = [dictNetworkData objectForKey:@"field_data"];
                ///iterate the array and create field data objects array
            NSMutableArray *arrFieldsData = nil;
            for (NSDictionary *dictFieldData in arrRawFieldData) {
                if (!arrFieldsData) {
                    arrFieldsData = [NSMutableArray array];
                }
                FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                if (fieldData.active) {
                    [arrFieldsData addObject:fieldData];
                }
                NSLog(@" arrFieldsData%@",arrFieldsData);
            }
            
                //Get the raw site data objects
            NSArray *arrRawSiteData = [dictNetworkData objectForKey:@"site_data"];
            
                ///Iterate the sites data and create the site data objects to it
            for (NSDictionary *dictSiteData in arrRawSiteData) {
                SiteData *siteData = [[SiteData alloc]initWithDictionary:dictSiteData];
                siteData.networkId = networkId;
                siteData.arrFieldData = arrFieldsData;
                
                if (!self.arrSites) {
                    self.arrSites = [NSMutableArray array];
                }
                [self.arrSites addObject:siteData];
            }
        }
 
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"siteName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        self.arrSites = [[self.arrSites sortedArrayUsingDescriptors:@[sortDescriptor]]mutableCopy];
        
        NSLog(@"self.instruct1:%d",self.instruct.sitee_Id);
        NSLog(@"self.instruct1:%@",self.instruct.instructData);
    }
    

    return self;
}


@end
