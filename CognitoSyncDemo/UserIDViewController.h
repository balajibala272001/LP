//
//  UserIDViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/24/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *sub_View;

@property (weak, nonatomic) IBOutlet UITextField *userid_txt;

- (IBAction)btn_ClickMe:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn1;


@end
