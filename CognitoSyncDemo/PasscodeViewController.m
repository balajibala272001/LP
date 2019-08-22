//
//  PasscodeViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "PasscodeViewController.h"
#import "PasscodeButton.h"


#import "SiteViewController.h"

#import "CameraViewController.h"

#define animationLength 0.15
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height==568)
#define IS_IOS6_OR_LOWER (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)


CGFloat const ButtonHeight = 75;
CGFloat const ButtonWidth = 75;


@interface PasscodeViewController ()

- (void)prepareAppearance;


@end

@implementation PasscodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Started");
    

     [self prepareAppearance];
    [self updatePinTextfieldWithLength:0];
    
     
    _digitsTextField = [[UITextField alloc]init];
    _digitsTextField.enabled = NO;
    _digitsTextField.secureTextEntry = YES;
    _digitsTextField.textAlignment = NSTextAlignmentCenter;
    _digitsTextField.borderStyle = UITextBorderStyleNone;
    //_digitsTextField.backgroundColor = [UIColor blueColor];
    //_digitsTextField.frame = CGRectMake(0, 50, 20, 30);
    
    
    
    _digitsTextField.layer.borderWidth = 1.0f;
    _digitsTextField.layer.cornerRadius = 5.0f;
    
    //_digitsTextField.backgroundColor = [UIColor blueColor];
       _digitsTextField.frame = CGRectMake(120, 90, 100, 30);
    

    
    [_contentView addSubview:_digitsTextField];
    
    
    //_enterPasscodeLabel = [self TopLabel];
    
    [_enterPasscodeLabel setBackgroundColor:[UIColor blueColor]];
    _enterPasscodeLabel.text = NSLocalizedString(@"Enter Passcode", @"");
    _enterPasscodeLabel.frame = CGRectMake(120, 60, 100, 30);
    
    _enterPasscodeLabel.backgroundColor = [UIColor redColor];
    
    
    [_contentView addSubview:_enterPasscodeLabel];
    
    _detailLabel = [self standardLabel];
   _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, 320, MIN(self.view.frame.size.height, 568))];
    
  
    
    //_contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 1000, 320, 500)];

  //  _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _contentView.backgroundColor = [UIColor grayColor];
    
    _contentView.center = self.view.center;

     [self.view addSubview:_contentView];
    
    
    //    UITextField *textField = [[UITextField alloc]init];
//    textField.enabled = YES;
//    textField.secureTextEntry = YES;
//    textField.textAlignment = NSTextAlignmentCenter;
//    textField.borderStyle = UITextBorderStyleNone;
//    textField.layer.borderWidth = 1.0;
//    textField.layer.borderColor =[UIColor whiteColor].CGColor;
//    
//   // textField.backgroundColor = [UIColor blueColor];
//    textField.frame = CGRectMake(120, 90, 100, 30);

    
   // [_contentView addSubview:textField];
    
    [_contentView addSubview:_digitsTextField];
    
    
    
    _buttonOne = [[PasscodeButton alloc] initWithFrame:CGRectZero number:1];
    _buttonTwo = [[PasscodeButton alloc] initWithFrame:CGRectZero number:2 ];
    _buttonThree = [[PasscodeButton alloc] initWithFrame:CGRectZero number:3 ];
    
    _buttonFour = [[PasscodeButton alloc] initWithFrame:CGRectZero number:4 ];
    _buttonFive = [[PasscodeButton alloc] initWithFrame:CGRectZero number:5];
    _buttonSix = [[PasscodeButton alloc] initWithFrame:CGRectZero number:6 ];
    
    _buttonSeven = [[PasscodeButton alloc] initWithFrame:CGRectZero number:7 ];
    _buttonEight = [[PasscodeButton alloc] initWithFrame:CGRectZero number:8 ];
    _buttonNine = [[PasscodeButton alloc] initWithFrame:CGRectZero number:9];
    
    _buttonZero = [[PasscodeButton alloc] initWithFrame:CGRectZero number:0];
    UIButtonType buttonType = UIButtonTypeSystem;
    if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
    {
        buttonType = UIButtonTypeCustom;
    }
    
    _cancelButton = [UIButton buttonWithType:buttonType];
    [_cancelButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.font = [UIFont fontWithName:@"Helvetica" size:20.0];
   // _cancelButton.layer.cornerRadius = 2.0;
    //_cancelButton.layer.borderWidth =1.0;
   // _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //[_cancelButton.titleLabel setTextAlignment: NSTextAlignmentCenter];


   // [_cancelButton setBackgroundColor:[UIColor greenColor]];
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [UIButton buttonWithType:buttonType];
    [_deleteButton setTitle:NSLocalizedString(@"Delete", @"") forState:UIControlStateNormal];
    [_deleteButton setBackgroundColor:[UIColor redColor]];

    
    
    
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _deleteButton.alpha = 0.0f;
    
    _okButton = [UIButton buttonWithType:buttonType];
    [_okButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    _okButton.layer.cornerRadius = 2.0;
    _okButton.layer.borderWidth =1.0;
    
    
   // [_okButton setBackgroundColor:[UIColor greenColor]];

    _okButton.alpha = 0.0f;
    _okButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
       [self layoutButtonArea];
    
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _digitsTextField) {
        [textField setTextColor:[UIColor whiteColor]];
    }

}
-(IBAction)cancel:(id)sender

{
    
//    CameraViewController *CameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera_View_Controller"];
//    
//    [self.navigationController pushViewController:CameraVC animated:YES];
    
    SiteViewController *SiteVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SiteVC2"];
    
    [self.navigationController pushViewController:SiteVC2 animated:YES];
    
    
    
//    UIButton *btn = (UIButton *)sender;
//    [self.myimagearray removeObjectAtIndex:btn.tag];
//    
//    //[self.imageArray removeObjectAtIndex:btn.tag];
//    
//    if (self.myimagearray.count == 0) {
//        self.collection_View.hidden = YES;
//    }
//    else
//        
//    {
//        self.collection_View.hidden = NO;
//        
//    }
//    
//    
//    [self.collection_View reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareAppearance
{
    self.enterPasscodeLabel.textColor = self.labelColor;
    self.enterPasscodeLabel.font = self.enterPasscodeLabelFont;
    
    //self.digitsTextField.textColor = [(ABPadButton*)self.buttonZero borderColor];
   // self.digitsTextField.layer.borderColor = [(ABPadButton*)self.buttonZero borderColor].CGColor;
    
    [self updatePinTextfieldWithLength:0];
    
    self.detailLabel.textColor = self.labelColor;
    self.detailLabel.font = self.detailLabelFont;
    
    [self.cancelButton setTitleColor:self.labelColor forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = self.deleteCancelLabelFont;
    
    [self.deleteButton setTitleColor:self.labelColor forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = self.deleteCancelLabelFont;
    
    [self.okButton setTitleColor:self.labelColor forState:UIControlStateNormal];
}

#pragma mark - Orientation height helpers
- (CGFloat)correctWidth
{
    return _contentView.bounds.size.width;
}

- (CGFloat)correctHeight
{
    return _contentView.bounds.size.height;
}



- (void)layoutButtonArea
{
    CGFloat horizontalButtonPadding = 20;
    CGFloat verticalButtonPadding = 10;
    
    CGFloat buttonRowWidth = (ButtonWidth * 3) + (horizontalButtonPadding * 2);
    
    CGFloat lefButtonLeft = ([self correctWidth]/2) - (buttonRowWidth/2) + 0.5;
    CGFloat centerButtonLeft = lefButtonLeft + ButtonWidth + horizontalButtonPadding;
    CGFloat rightButtonLeft = centerButtonLeft + ButtonWidth + horizontalButtonPadding;
    
    CGFloat topRowTop = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 15;
    
    if (!IS_IPHONE5) topRowTop = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 10;
   
    //NSLog(@"toprow%f ",topRowTop);
    
    
    CGFloat middleRowTop = topRowTop + ButtonHeight+ verticalButtonPadding;
    CGFloat bottomRowTop = middleRowTop + ButtonHeight + verticalButtonPadding;
    CGFloat zeroRowTop = bottomRowTop + ButtonHeight + verticalButtonPadding;
    
    [self setUpButton:self.buttonOne left:lefButtonLeft top:topRowTop];
    [self setUpButton:self.buttonTwo left:centerButtonLeft top:topRowTop];
    [self setUpButton:self.buttonThree left:rightButtonLeft top:topRowTop];
    
    [self setUpButton:self.buttonFour left:lefButtonLeft top:middleRowTop];
    [self setUpButton:self.buttonFive left:centerButtonLeft top:middleRowTop];
    [self setUpButton:self.buttonSix left:rightButtonLeft top:middleRowTop];
    
    [self setUpButton:self.buttonSeven left:lefButtonLeft top:bottomRowTop];
    [self setUpButton:self.buttonEight left:centerButtonLeft top:bottomRowTop];
    [self setUpButton:self.buttonNine left:rightButtonLeft top:bottomRowTop];
    
    [self setUpButton:self.buttonZero left:centerButtonLeft top:zeroRowTop];
    
    CGRect deleteCancelButtonFrame = CGRectMake(rightButtonLeft, zeroRowTop + ButtonHeight + 25, ButtonWidth, 20);
    
    
    CGRect deleteButtonFrame = CGRectMake(0, 218, 75, 20);
    
    if(!IS_IPHONE5)
    {
        //Bring it higher for small device screens
        deleteCancelButtonFrame = CGRectMake(rightButtonLeft, zeroRowTop + ButtonHeight - 20, ButtonWidth, 20);
        
        
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //Center it with zero button
        deleteCancelButtonFrame = CGRectMake(rightButtonLeft, zeroRowTop + (ButtonHeight / 2 - 10), ButtonWidth, 20);
        CGRect deleteButtonFrame = CGRectMake(0, 218, 75, 20);

        
    }
    
    if (!self.cancelButtonDisabled)
    {
        self.cancelButton.frame = deleteCancelButtonFrame;
        [self.contentView addSubview:self.cancelButton];
    }
    
    self.deleteButton.frame = deleteButtonFrame;
    [self.contentView addSubview:self.deleteButton];
}


- (void)updatePinTextfieldWithLength:(NSUInteger)length
{
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        NSAttributedString* digitsTextFieldAttrStr = [[NSAttributedString alloc] initWithString:[@"" stringByPaddingToLength:length withString:@" " startingAtIndex:0]
                                                                                     attributes:@{NSKernAttributeName: @4,
                                                                                                  NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
        [UIView transitionWithView:self.digitsTextField duration:animationLength options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.digitsTextField.attributedText = digitsTextFieldAttrStr;
        } completion:nil];
    }
    else
    {
        self.digitsTextField.text = [@"" stringByPaddingToLength:length withString:@" " startingAtIndex:0];
    }
}

- (void)setUpButton:(UIButton *)button left:(CGFloat)left top:(CGFloat)top
{
    button.frame = CGRectMake(left, top, ButtonWidth, ButtonHeight);
    
   // NSLog(@"%@",button.frame);
    
//    NSLog(@" Height%f",button.frame.size.height);
//    NSLog(@" Width%f",button.frame.size.width);
//    NSLog(@" X%f",button.frame.origin.x);
//    NSLog(@" Y%f",button.frame.origin.y);
    

    
    [self.contentView addSubview:button];
    [self setRoundedView:button toDiameter:75];
}


//- (void)layoutSubviews
//{
//    //[super layoutSubviews];
//    //[self performLayout];
//    //[self prepareAppearance];
//}


#pragma mark -
#pragma mark -  View Methods
- (UILabel *)standardLabel
{
   // UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
    
    label.textColor = [UIColor yellowColor];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


- (UILabel *)TopLabel
{
    // UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
    
    label.textColor = [UIColor yellowColor];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
    return label;
}
- (void)setRoundedView:(UIView *)roundedView toDiameter:(CGFloat)newSize;
{
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.clipsToBounds = YES;
    roundedView.layer.cornerRadius = newSize / 2.0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


