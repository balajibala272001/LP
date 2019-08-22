  
//
//  VTPinPadViewController.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinPadViewController.h"
#import "PPPinCircleView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SiteViewController.h"
#import "KeychainItemWrapper.h"

#import "CognitoHomeViewController.h"

#import "ServerUtility.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"


//Nsobject Class
#import "User.h"


#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
    settingMewPinStateFisrt   = 0,
    settingMewPinStateConfirm = 1
};
@interface PPPinPadViewController () {
    NSInteger _shakes;
    NSInteger _direction;
}
@property (nonatomic)                   settingNewPinState  newPinState;
@property (nonatomic,strong)            NSString            *fisrtPassCode;
@property (weak, nonatomic) IBOutlet    UILabel             *laInstructionsLabel;
@end

static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;
@implementation PPPinPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCircles];
    
    NSLog(@" username is :%@",self.userName);
    
    
    pinLabel.text = self.pinTitle ? :@"Enter PIN";
    pinErrorLabel.text = self.errorTitle ? : @"PIN number is not correct";
    cancelButton.hidden = self.cancelButtonHidden;
    if (self.backgroundImage) {
        backgroundImageView.hidden = NO;
        backgroundImageView.image = self.backgroundImage;
    }
    
//    if (self.backgroundColor && !self.backgroundImage) {
//        backgroundImageView.hidden = YES;
//        
//    }
    
    
    
   // if (_tintColor) [self tintSubviewsWithColor:_tintColor];
    
    
    
      
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tintSubviewsWithColor: (UIColor *)color
{
    
    
    for (PPCircleButton *number  in _numberButtons) {
        
        [number setTintColor:color];
        
        
    }
}

- (void) setCancelButtonHidden:(BOOL)cancelButtonHidden{
    _cancelButtonHidden = cancelButtonHidden;
    cancelButton.hidden = cancelButtonHidden;
}

- (void) setErrorTitle:(NSString *)errorTitle{
    _errorTitle = errorTitle;
    pinErrorLabel.text = errorTitle;
}

- (void) setPinTitle:(NSString *)pinTitle{
    _pinTitle = pinTitle;
    pinLabel.text = pinTitle;
}



//- (void) setBackgroundColor:(UIColor *)backgroundColor{
//    _backgroundColor = [UIColor greenColor];
//    self.view.backgroundColor = [UIColor greenColor];
//    
// 
//    backgroundImageView.hidden = YES;
//}


- (void)dismissPinPad {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadWillHide)]) {
        [self.delegate pinPadWillHide];
    }
    
    

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}





#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
}

-(BOOL)prefersStatusBarHidden
{
    return !_errorView.hidden;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setIsSettingPinCode:(BOOL)isSettingPinCode{
    _isSettingPinCode = isSettingPinCode;
    if (isSettingPinCode) {
        self.newPinState = settingMewPinStateFisrt;
    }
}
#pragma mark Actions

- (IBAction)cancelClick:(id)sender {
    
    
    
    [self.navigationController popViewControllerAnimated:YES];

    
}


- (IBAction)resetClick:(id)sender {
    [self addCircles];
    
    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PIN", @"");
    _inputPin = [NSMutableString string];
    
    
    self.newPinState    = settingMewPinStateFisrt;
}

- (IBAction)numberButtonClick:(id)sender {
    if(!_inputPin) {
        _inputPin = [NSMutableString new];
    }
    if(!_errorView.hidden) {
        [self changeStatusBarHidden:YES];
    }
    [_inputPin appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
    NSLog(@"%lu",(unsigned long)_inputPin.length);
    
    [self fillingCircle:_inputPin.length - 1];
    
    NSLog(@"%lu",(unsigned long)_inputPin.length);

    
    if (self.isSettingPinCode){
        if ([self pinLenght] == _inputPin.length){
            if (self.newPinState == settingMewPinStateFisrt) {
                self.fisrtPassCode  = _inputPin;
                // reset and prepare for confirmation stage
                [self resetClick:Nil];
                self.newPinState    = settingMewPinStateConfirm;
                // update instruction label
                self.laInstructionsLabel.text = NSLocalizedString(@"Confirm PassCode", @"");
            }else{
                // we are at confirmation stage check this pin with original one
                if ([self.fisrtPassCode isEqualToString:_inputPin]) {
                    // every thing is ok
                    if ([self.delegate respondsToSelector:@selector(userPassCode:)]) {
                        [self.delegate userPassCode:self.fisrtPassCode];
                    }
                    [self dismissPinPad];
                }else{
                    // reset to first stage
                    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PIN", @"");
                    _direction = 1;
                    _shakes = 0;
                   // [self shakeCircles:_pinCirclesView];
                    [self changeStatusBarHidden:NO];
                    [self resetClick:Nil];
                }
            }
        }
    }else{
        if ([self pinLenght] == _inputPin.length) {
           // double delayInSeconds = 0.3;
            
         
            [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
//           KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Login" accessGroup:nil];
//            [keyChain setObject:self.userName forKey:(__bridge id)(kSecAttrAccount)];
//        //    NSString *user = [keyChain objectForKey:
//                              (__bridge id)(kSecAttrAccount)];
//            
            
            NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"];
            
            NSLog(@"%@",user);
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            __weak typeof(self) weakSelf = self;

            [ServerUtility getUserNameAndUserPin:self.userName withUserPin:_inputPin andCompletion:^(NSError *error,id data){
                
            
                if (!error) {
                    NSLog(@" the second page data are:%@",data);
                    
                    NSString *strResType = [data objectForKey:@"res_type"];
                    
                    if ([strResType.lowercaseString isEqualToString:@"success"]) {
                        
                    NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                        [DictData addEntriesFromDictionary:data];
                        NSLog(@" my dict:%@",DictData);
                        
                      
                        //getting the user profile data
                      NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
                        
                       
                      //iterating user profile data
                        NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
                        
                        User *userData = [[User alloc]initWithDictionary:userProfileData];
                        
                        
                        AZCAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                        delegate.userProfiels = userData;
                       
                        
        

                   
                        UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NavigationBar"];
                        
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
                        [UIApplication sharedApplication].keyWindow.rootViewController = controller;
                        

                        
          
                        
                        
                        
                    }
                    else if ([strResType.lowercaseString isEqualToString:@"error"])
                    {
                        NSString *strMsg = [data objectForKey:@"msg"];
                        
                        _direction = 1;
                        _shakes = 0;
                        [self shakeCircles:_pinCirclesView];
                        [self.view makeToast:strMsg duration:1.0 position:CSToastPositionCenter];
                        
                        

                        
                    }
                    
                    
                }
                
                else
                {
                    _direction = 1;
                               _shakes = 0;
                        [self shakeCircles:_pinCirclesView];
                    [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
                    

                }
        
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        }];
            
            
            
                    }


    }
}



#pragma mark Delegate & methods


- (BOOL)checkPin:(NSString *)pinString {
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkPin:)]) {
        
        
        return [self.delegate checkPin:pinString];
        

        
    }
    return NO;
}

- (NSInteger)pinLenght {
    if([self.delegate respondsToSelector:@selector(pinLenght)]) {
        return [self.delegate pinLenght];
    }
    return 4;
}

#pragma mark Circles


- (void)addCircles {
    if([self isViewLoaded] && self.delegate) {
        [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_circleViewList removeAllObjects];
        _circleViewList = [NSMutableArray array];
        
        CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
        CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +2);
        CGFloat indent= 1.5* shiftBetweenCircle;
        if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f) {
            shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
            indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
        }
        for(int i=0; i < [self pinLenght]; i++) {
            PPPinCircleView * circleView = [PPPinCircleView circleView:kVTPinPadViewControllerCircleRadius];
            CGRect circleFrame = circleView.frame;
            circleFrame.origin.x = indent + i * kVTPinPadViewControllerCircleRadius + i*shiftBetweenCircle;
            circleFrame.origin.y = (CGRectGetHeight(_pinCirclesView.frame) - kVTPinPadViewControllerCircleRadius)/2.0f;
            circleView.frame = circleFrame;
            [_pinCirclesView addSubview:circleView];
            [_circleViewList addObject:circleView];
        }
    }
}

- (void)fillingCircle:(NSInteger)symbolIndex {
    
   // [self changeStatusBarHidden:YES];
    
    NSLog(@"%ld",(long)symbolIndex);
    
    
    if(symbolIndex>=_circleViewList.count)
        return;
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
    
   //circleView.backgroundColor = [UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
    circleView.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    
    //circleView.backgroundColor = [UIColor blackColor];
    
    
}


-(void)shakeCircles:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(_shakes >= 15)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             [self resetClick:nil];
             return;
         }
         _shakes++;
         _direction = _direction * -1;
         [self shakeCircles:theOneYouWannaShake];
     }];
}



@end
