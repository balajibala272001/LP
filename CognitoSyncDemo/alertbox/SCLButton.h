
#import <UIKit/UIKit.h>


@class SCLTimerDisplay;

@interface SCLButton : UIButton

typedef void (^SCLActionBlock)(void);
typedef BOOL (^SCLValidationBlock)(void);
typedef NSDictionary* (^CompleteButtonFormatBlock)(void);
typedef NSDictionary* (^ButtonFormatBlock)(void);

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    SCLNone,
    SCLSelector,
    SCLBlock
};
@property (strong, nonatomic) SCLTimerDisplay *timer;
@property SCLActionType actionType;
@property (copy, nonatomic) SCLActionBlock actionBlock;
@property (copy, nonatomic) SCLValidationBlock validationBlock;
@property (copy, nonatomic) CompleteButtonFormatBlock completeButtonFormatBlock;
@property (copy, nonatomic) ButtonFormatBlock buttonFormatBlock;
@property (strong, nonatomic) UIColor *defaultBackgroundColor UI_APPEARANCE_SELECTOR;
@property id target;
@property SEL selector;

//- (void)parseConfig:(NSDictionary *)buttonConfig;

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth;


- (void)adjustWidthWithWindowWidth:(CGFloat)windowWidth numberOfButtons:(NSUInteger)numberOfButtons;

@end
