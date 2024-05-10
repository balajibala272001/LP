//
//  AboutViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 10/8/18.
//  Copyright © 2018 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLTextView.h"
#import "SCLAlertView.h"

@interface AboutViewController : UIViewController<UIGestureRecognizerDelegate>

- (IBAction)back_action_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *lbl;
@property (weak, nonatomic) IBOutlet UILabel *VersionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *logoimg;
@property (strong, nonatomic) IBOutlet UIView *stack;
@property (strong, nonatomic) IBOutlet UILabel *uuid;
@property(nonatomic,strong) SCLTextView *textField ;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property(nonatomic,strong) IBOutlet UIImageView *img ;
@end
