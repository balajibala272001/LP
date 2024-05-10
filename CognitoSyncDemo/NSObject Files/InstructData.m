//
//  InstructData.m
//  CognitoSyncDemo
//
//  Created by SG Apple on 07/09/21.
//  Copyright © 2021 Behroozi, David. All rights reserved.
//
#import "InstructData.h"

@implementation InstructData
-(instancetype)initWithDictionary:(NSDictionary *)arrCapture
{
    if (self = [super init])
    {
        
                self.sitee_Id  = [[arrCapture objectForKey:@"site_id"] intValue];
                self.instructData = [arrCapture objectForKey:@"instruction_data"];
                [[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"instructData"];
                for (NSDictionary *instDict in self.instructData) {

                    self.pictCountForStep = [instDict objectForKey:@"count_for_step_pics"];
                    //[[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"pictCountForStep"];

                    self.instnum = [instDict objectForKey:@"instruction_number"];
                    //[[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"instnum"];

                    self.instname = [instDict objectForKey:@"instruction_name"];
                    //[[NSUserDefaults standardUserDefaults]setObject:self.instructData forKey:@"instname"];

                    NSLog(@"instructData:%@",self.instructData);
                    NSLog(@"instnum:%@",self.instnum);
                    NSLog(@"instname:%@",self.instname);
                    NSLog(@"pictCountForStep:%@",self.pictCountForStep);
        }
    }

    return self;
}
@end
