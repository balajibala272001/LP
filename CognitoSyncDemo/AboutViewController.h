//
//  AboutViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 10/8/18.
//  Copyright © 2018 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController



- (IBAction)back_action_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back_btn;
@property (weak, nonatomic) IBOutlet UITextView *lbl;
@property (weak, nonatomic) IBOutlet UIView *Background_View;




@end
