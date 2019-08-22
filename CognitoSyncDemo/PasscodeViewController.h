//
//  PasscodeViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeViewController : UIViewController
@property (nonatomic, strong, readonly) UITextField *digitsTextField;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_Pin;

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong, readonly) UILabel *detailLabel;

//@property (weak, nonatomic) IBOutlet UIView *view_Passcode;

@property (nonatomic, assign) BOOL cancelButtonDisabled;

@property (nonatomic, strong) UIFont *enterPasscodeLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *detailLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *deleteCancelLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *labelColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, readonly) UILabel *enterPasscodeLabel;
@property (nonatomic, strong, readonly) UIButton *buttonOne;
@property (nonatomic, strong, readonly) UIButton *buttonTwo;
@property (nonatomic, strong, readonly) UIButton *buttonThree;

@property (nonatomic, strong, readonly) UIButton *buttonFour;
@property (nonatomic, strong, readonly) UIButton *buttonFive;
@property (nonatomic, strong, readonly) UIButton *buttonSix;

@property (nonatomic, strong, readonly) UIButton *buttonSeven;
@property (nonatomic, strong, readonly) UIButton *buttonEight;
@property (nonatomic, strong, readonly) UIButton *buttonNine;

@property (nonatomic, strong, readonly) UIButton *buttonZero;

@property (nonatomic, strong, readonly) UIButton *cancelButton;
@property (nonatomic, strong, readonly) UIButton *deleteButton;

@property (nonatomic, strong, readonly) UIButton *okButton;
- (void)updatePinTextfieldWithLength:(NSUInteger)length;
 
@end
