//
//  PinUserViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/25/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>


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
@interface PinUserViewController : UIViewController
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

@property (nonatomic,assign) id<PinPadPasswordProtocol> delegate;


@property (nonatomic, strong) NSString *errorTitle;
@property (nonatomic, strong) NSString *pinTitle;
@property (nonatomic, assign) BOOL cancelButtonHidden;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) BOOL isSettingPinCode;
@end
