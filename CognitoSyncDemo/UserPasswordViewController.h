//
//  UserPasswordViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/24/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *sub_View;




//buttons
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



- (NSArray *)buttonArray;

@end
