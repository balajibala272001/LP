//

#import <UIKit/UIKit.h>

#import "SCLButton.h"

typedef NSAttributedString* (^SCLAttributedFormatBlock)(NSString *value);
typedef void (^SCLDismissBlock)(void);
typedef void (^SCLDismissAnimationCompletionBlock)(void);
typedef void (^SCLShowAnimationCompletionBlock)(void);
typedef void (^SCLForceHideBlock)(void);

@interface SCLAlertView : UIViewController 

typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    SCLAlertViewStyleSuccess
};
typedef NS_ENUM(NSInteger, SCLAlertViewHideAnimation)
{
    SCLAlertViewHideAnimationFadeOut
};
typedef NS_ENUM(NSInteger, SCLAlertViewShowAnimation)
{
    SCLAlertViewShowAnimationFadeIn};
typedef NS_ENUM(NSInteger, SCLAlertViewBackground)
{
    SCLAlertViewBackgroundShadow
};

@property CGFloat cornerRadius;
@property (assign, nonatomic) BOOL tintTopCircle;
@property (strong, nonatomic) UILabel *labelTitle;

@property (strong, nonatomic) UITextView *viewText;

@property (assign, nonatomic) BOOL shouldDismissOnTapOutside;
@property (copy, nonatomic) SCLAttributedFormatBlock attributedFormatBlock;
@property (copy, nonatomic) CompleteButtonFormatBlock completeButtonFormatBlock;

@property (copy, nonatomic) ButtonFormatBlock buttonFormatBlock;

@property (copy, nonatomic) SCLForceHideBlock forceHideBlock;
@property (nonatomic) SCLAlertViewHideAnimation hideAnimationType;

@property (nonatomic) SCLAlertViewShowAnimation showAnimationType;

@property (nonatomic) SCLAlertViewBackground backgroundType;

@property (strong, nonatomic) UIColor *customViewColor;

@property (strong, nonatomic) UIColor *backgroundViewColor;

@property (nonatomic) CGRect extensionBounds;

@property (nonatomic) BOOL statusBarHidden;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

@property (nonatomic) BOOL horizontalButtons;

- (instancetype)initWithNewWindow;

- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth;

- (void)alertIsDismissed:(SCLDismissBlock)dismissBlock;

- (void)alertDismissAnimationIsCompleted:(SCLDismissAnimationCompletionBlock)dismissAnimationCompletionBlock;

- (void)alertShowAnimationIsCompleted:(SCLShowAnimationCompletionBlock)showAnimationCompletionBlock;
- (void)hideView;

- (BOOL)isVisible;

- (void)removeTopCircle;

- (UIView *)addCustomView:(UIView *)customView;

- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size;

- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size;

- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size;

//- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action;
//
//- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector backgroundColor:(UIColor *)bg;

- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showSuccess:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

@end
