//
//  NewPasswordScreenViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 11/16/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCircleButton.h"
#import "User.h"
#import "FieldData.h"
#import "SiteData.h"

@protocol PinPadPasswordProtocol <NSObject>

@required
- (BOOL)checkPin:(NSString *)pin;
- (NSInteger)pinLenght;
@optional
- (void)pinPadSuccessPin;
- (void)pinPadWillHide;
- (void)pinPadDidHide;
- (void)userPassCode:(NSString *)newPassCode;
@end


@interface NewPasswordScreenViewController : UIViewController
{
__weak IBOutlet UIView *_pinCirclesView;
__weak IBOutlet UIView *_errorView;
__weak IBOutlet UILabel *pinLabel;
__weak IBOutlet UILabel *pinErrorLabel;
__weak IBOutlet UIImageView *backgroundImageView;
__weak IBOutlet UIButton *resetButton;
__weak IBOutlet UIButton *cancelButton;
NSMutableString *_inputPin;
NSMutableArray *_circleViewList;

}

//__weak IBOutlet UIView *_pinCirclesView;
//__weak IBOutlet UIView *_errorView;
//__weak IBOutlet UILabel *pinLabel;
//__weak IBOutlet UILabel *pinErrorLabel;
//__weak IBOutlet UIImageView *backgroundImageView;
//__weak IBOutlet UIButton *resetButton;
//__weak IBOutlet UIButton *cancelButton;
//NSMutableString *_inputPin;
//NSMutableArray *_circleViewList;
@end
