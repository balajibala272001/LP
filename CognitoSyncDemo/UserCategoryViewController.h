//
//  UserCategoryViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/15/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (strong, nonatomic) IBOutlet UIView *cloudView;



- (IBAction)btn_Load:(id)sender;
- (IBAction)btn_Safetyincident:(id)sender;

- (IBAction)btn_GembaWalk:(id)sender;

- (IBAction)btn_miscellaneous:(id)sender;

- (IBAction)btn_OqualityIssue:(id)sender;


@property (nonatomic,strong) NSMutableArray *arrayOfImagesWithNotes;

@property (nonatomic,strong) NSMutableArray *dictMetaData;
- (IBAction)back_action_btn:(id)sender;
@property (weak,nonatomic) NSString *sitename;


@property  BOOL isEdit;

@property (strong,nonatomic) NSDictionary *wholeDictionar;


@end
