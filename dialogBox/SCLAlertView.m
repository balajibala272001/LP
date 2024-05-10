
#import "SCLAlertView.h"
#import "SCLAlertViewResponder.h"

#import <AVFoundation/AVFoundation.h>

#define PREDICTION_BAR_HEIGHT 40
#define ADD_BUTTON_PADDING 10.0f
#define DEFAULT_WINDOW_WIDTH 280

@interface SCLAlertView ()
@property (strong, nonatomic) NSMutableArray *customViews;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) NSString *titleFontFamily;
@property (strong, nonatomic) NSString *bodyTextFontFamily;
@property (strong, nonatomic) NSString *buttonsFontFamily;
@property (strong, nonatomic) UIWindow *previousWindow;
@property (strong, nonatomic) UIWindow *SCLAlertWindow;
@property (copy, nonatomic) SCLDismissBlock dismissBlock;
@property (copy, nonatomic) SCLDismissAnimationCompletionBlock dismissAnimationCompletionBlock;
@property (copy, nonatomic) SCLShowAnimationCompletionBlock showAnimationCompletionBlock;
@property (weak, nonatomic) UIViewController *rootViewController;
@property (assign, nonatomic) BOOL usingNewWindow;
@property (nonatomic) CGFloat backgroundOpacity;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat bodyFontSize;
@property (nonatomic) CGFloat buttonsFontSize;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) CGFloat subTitleHeight;
@property (nonatomic) CGFloat subTitleY;

@end

@implementation SCLAlertView


CGFloat kTitleTop;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"NSCoding not supported"
                                 userInfo:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:DEFAULT_WINDOW_WIDTH];
    }
    return self;
}

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:windowWidth];
    }
    return self;
}

- (instancetype)initWithNewWindow
{
    self = [self initWithWindowWidth:DEFAULT_WINDOW_WIDTH];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}

- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth
{
    self = [self initWithWindowWidth:windowWidth];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}



#pragma mark - Setup view

- (void)setupViewWindowWidth:(CGFloat)windowWidth
{
    self.titleHeight = 10.0f;
    self.subTitleY = 40.0f;
    self.subTitleHeight = 110.0f;
    self.windowWidth = windowWidth;
    self.windowHeight = 178.0f;
    self.shouldDismissOnTapOutside = NO;
    self.usingNewWindow = NO;
    self.hideAnimationType =  SCLAlertViewHideAnimationFadeOut;
    self.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    self.backgroundType = SCLAlertViewBackgroundShadow;
    self.tintTopCircle = YES;
    
    // Font
    _titleFontFamily = @"HelveticaNeue-Bold";
    _bodyTextFontFamily = @"HelveticaNeue";
    _buttonsFontFamily = @"HelveticaNeue-Bold";
    _titleFontSize = 20.0f;
    _bodyFontSize = 14.0f;
    _buttonsFontSize = 14.0f;
    
    // Init
    _labelTitle = [[UILabel alloc] init];
    _viewText = [[UITextView alloc] init];
    _viewText.accessibilityTraits = UIAccessibilityTraitStaticText;
    _contentView = [[UIView alloc] init];
  _backgroundView = [[UIImageView alloc] initWithFrame:[self mainScreenFrame]];
    _buttons = [[NSMutableArray alloc] init];
    _customViews = [[NSMutableArray alloc] init];
    self.view.accessibilityViewIsModal = YES;
    
    // Add Subviews
    [self.view addSubview:_contentView];
    // Background View
    _backgroundView.userInteractionEnabled = YES;
    
    // Title
    _labelTitle.numberOfLines = 1;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
    _labelTitle.textColor =  [UIColor whiteColor]; //Dark Grey
    _labelTitle.backgroundColor =[UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.00];
    
    // View text
    _viewText.editable = NO;
    _viewText.allowsEditingTextAttributes = YES;
    _viewText.textAlignment = NSTextAlignmentCenter;
    _viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
    _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
    _viewText.textContainerInset = UIEdgeInsetsZero;
    _viewText.textContainer.lineFragmentPadding = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Content View
    _contentView.backgroundColor = [UIColor greenColor];
    _contentView.layer.cornerRadius = 0.0f;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.borderWidth = 0.5f;
    [_contentView addSubview:_viewText];    
    [_contentView addSubview:_labelTitle];
    
    // Colors
    self.backgroundViewColor = [UIColor whiteColor];
    
    

}

- (void)setupNewWindow {
    // Save previous window
    self.previousWindow = [UIApplication sharedApplication].keyWindow;
    
    // Create a new one to show the alert
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[self mainScreenFrame]];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.rootViewController = [UIViewController new];
    alertWindow.accessibilityViewIsModal = YES;
    self.SCLAlertWindow = alertWindow;
    self.usingNewWindow = YES;
}

#pragma mark - Modal Validation

- (BOOL)isModal {
    return (_rootViewController != nil && _rootViewController.presentingViewController);
}

#pragma mark - View Cycle

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize sz = [self mainScreenFrame].size;
    
    if ([self isModal] && !_usingNewWindow) {
        sz = _rootViewController.view.frame.size;
    }
    
    // Set new main frame
    CGRect r;
    if (self.view.superview != nil) {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-_windowWidth)/2, (sz.height-_windowHeight)/2, _windowWidth, _windowHeight);
    } else {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-_windowWidth)/2, -_windowHeight, _windowWidth, _windowHeight);
    }
    self.view.frame = r;
    
    // Set new background frame
    CGRect newBackgroundFrame = self.backgroundView.frame;
    newBackgroundFrame.size = sz;
    self.backgroundView.frame = newBackgroundFrame;
    
    // Set frames
    _contentView.frame = CGRectMake(0.0f, 0.0f, _windowWidth, _windowHeight);
    _labelTitle.frame = CGRectMake(0.0f, kTitleTop, _windowWidth - 0.0f, 70);
    
    // Text fields
    CGFloat y = (_labelTitle.text == nil) ? kTitleTop : (_titleHeight - 10.0f) + _labelTitle.frame.size.height;
    _viewText.frame = CGRectMake(6.0f, y, _windowWidth - 18.0f, _subTitleHeight);
    
    if (!_labelTitle && !_viewText) {
        y = 0.0f;
    }

    y += _subTitleHeight + 14.0f;
 
    
    // Buttons
    CGFloat x = 12.0f;
    CGFloat btnheight=90.0f;
    for (SCLButton *btn in _buttons) {
        
        btn.frame = CGRectMake(x, y, btn.frame.size.width, btn.frame.size.height);
        
        // Add horizontal or vertical offset acording on _horizontalButtons parameter
        if (_horizontalButtons) {
            x += btn.frame.size.width + 10.0f;
        } else {
            btnheight*= _buttons.count;
            y += btn.frame.size.height + 10.0f;
        }
    }
    
    // Adapt window height according to icon size
    //self.windowHeight = 180;
    self.windowHeight = btnheight+_labelTitle.frame.size.height+_viewText.frame.size.height;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _windowWidth, _windowHeight);
    
    // Adjust corner radius, if a value has been passed
    _contentView.layer.cornerRadius = self.cornerRadius ? self.cornerRadius : 15.0f;
}

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - Custom Fonts

- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size
{
    self.titleFontFamily = titleFontFamily;
    self.titleFontSize = size;
    self.labelTitle.font = [UIFont fontWithName:_titleFontFamily size:20];
}

- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size
{
    self.bodyTextFontFamily = bodyTextFontFamily;
    self.bodyFontSize = size;
    self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
}

- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size
{
    self.buttonsFontFamily = buttonsFontFamily;
    self.buttonsFontSize = size;
}

#pragma mark - Background Color

- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    _backgroundViewColor = backgroundViewColor;

    _contentView.backgroundColor = _backgroundViewColor;
    
    _viewText.backgroundColor = [UIColor whiteColor];
;
    
}

#pragma mark - Buttons

- (SCLButton *)addButton:(NSString *)title
{
    // Add button
    SCLButton *btn = [[SCLButton alloc] initWithWindowWidth:self.windowWidth];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:_buttonsFontFamily size:_buttonsFontSize];
    
    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    if (_horizontalButtons) {
        // Update buttons width according to the number of buttons
        for (SCLButton *bttn in _buttons) {
            [bttn adjustWidthWithWindowWidth:self.windowWidth numberOfButtons:[_buttons count]];
        }
        
        // Update view height
        if (!([_buttons count] > 1)) {
            self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING);
        }
    } else {
        // Update view height
        self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING);
    }
    
    return btn;
}

- (SCLButton *)addDoneButtonWithTitle:(NSString *)title
{
    SCLButton *btn = [self addButton:title];
    
    if (_completeButtonFormatBlock != nil)
    {
        btn.completeButtonFormatBlock = _completeButtonFormatBlock;
    }
    btn.backgroundColor= [UIColor redColor];
    [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title];
    
    if (_buttonFormatBlock != nil)
    {
        btn.buttonFormatBlock = _buttonFormatBlock;
    }
    
    btn.actionType = SCLBlock;
    btn.actionBlock = action;
    
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title actionBlock:action];
    btn.validationBlock = validationBlock;
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector backgroundColor:(UIColor *)bg
{
    SCLButton *btn = [self addButton:title];
    btn.actionType = SCLSelector;
    btn.backgroundColor=[UIColor greenColor];
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(SCLButton *)btn
{
    if (btn.validationBlock && !btn.validationBlock()) {
        return;
    }
    
    if (btn.actionType == SCLBlock)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == SCLSelector)
    {
        UIControl *ctrl = [[UIControl alloc] init];
        [ctrl sendAction:btn.selector to:btn.target forEvent:nil];
    }
    else
    {
        NSLog(@"Unknown action type for button");
    }
    
//    if([self isVisible])
//    {
//        [self hideView];
//    }
}

#pragma mark - Show Alert

- (SCLAlertViewResponder *)showTitle:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle duration:(NSTimeInterval)duration completeText:(NSString *)completeText style:(SCLAlertViewStyle)style
{
    if(_usingNewWindow) {

        self.backgroundView.frame = _SCLAlertWindow.bounds;
        
        // Add window subview
        [_SCLAlertWindow.rootViewController addChildViewController:self];
        [_SCLAlertWindow.rootViewController.view addSubview:_backgroundView];
        [_SCLAlertWindow.rootViewController.view addSubview:self.view];
    } else {
        _rootViewController = vc;
        

        self.backgroundView.frame = vc.view.bounds;
        
        // Add view controller subviews
        [_rootViewController addChildViewController:self];
        [_rootViewController.view addSubview:_backgroundView];
        [_rootViewController.view addSubview:self.view];
    }
    
    self.view.alpha = 0.0f;
    [self setBackground];
    
    // Alert color/icon
    UIColor *viewColor;
    
    
    // Custom Alert color
    if(_customViewColor)
    {
        viewColor = _customViewColor;
    }
    
    // Title
    if ([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        self.labelTitle.text = title;
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(_windowWidth - 24.0f, CGFLOAT_MAX);

        CGSize size = [_labelTitle sizeThatFits:sz];

        CGFloat ht = ceilf(size.height);
        if (ht > _titleHeight) {
            self.windowHeight += (ht - _titleHeight);
            self.titleHeight = ht;
            self.subTitleY += 20;
        }
    } else {
        // Title is nil, we can move the body message to center and remove it from superView
        self.windowHeight -= _labelTitle.frame.size.height;
        [_labelTitle removeFromSuperview];
        _labelTitle = nil;
        
    }
    
    // Subtitle
    if ([subTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        
        // No custom text
        if (_attributedFormatBlock == nil) {
            _viewText.text = subTitle;
        } else {
            self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
            _viewText.attributedText = self.attributedFormatBlock(subTitle);
        }
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(_windowWidth - 24.0f, CGFLOAT_MAX);
        
        CGSize size = [_viewText sizeThatFits:sz];
        
        CGFloat ht = ceilf(size.height);
        if (ht < _subTitleHeight) {
            self.windowHeight -= (_subTitleHeight - ht);
            self.subTitleHeight = ht;
        } else {
            self.windowHeight += (ht - _subTitleHeight);
            self.subTitleHeight = ht;
        }
    } else {
        // Subtitle is nil, we can move the title to center and remove it from superView
        self.subTitleHeight = 0.0f;
        self.windowHeight -= _viewText.frame.size.height;
        [_viewText removeFromSuperview];
        _viewText = nil;
        
        // Move up
        _labelTitle.frame = CGRectMake(12.0f, 37.0f, _windowWidth - 24.0f, _titleHeight);
    }
    
    if (!_labelTitle && !_viewText) {
        self.windowHeight -= kTitleTop;
    }
    
    // Add button, if necessary
    if(completeText != nil)
    {
        [self addDoneButtonWithTitle:completeText];
    }
    
    
      for (SCLButton *btn in _buttons)
    {
        
        if (!btn.defaultBackgroundColor) {
            btn.defaultBackgroundColor = viewColor;
        }
        
    }
    
    
    if(_usingNewWindow)
    {
        [_SCLAlertWindow makeKeyAndVisible];
    }
    
    // Show the alert view
    [self showView];
    
    // Chainable objects
    return [[SCLAlertViewResponder alloc] init:self];
}

#pragma mark - Show using UIViewController

- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    _backgroundViewColor=[UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.00];

    [self showTitle:vc image:nil color:_backgroundViewColor title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleSuccess];
}

#pragma mark - Show using new window

- (void)showSuccess:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    _backgroundViewColor=[UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.00];

    [self showTitle:nil image:nil color:_backgroundViewColor title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleSuccess];
}

#pragma mark - Visibility


- (BOOL)isVisible
{
    return (self.view.alpha);
}

- (CGRect)mainScreenFrame
{
    return [self isAppExtension] ? _extensionBounds : [UIApplication sharedApplication].keyWindow.bounds;
}

- (BOOL)isAppExtension
{
    return [[NSBundle mainBundle].executablePath rangeOfString:@".appex/"].location != NSNotFound;
}

#pragma mark - Background Effects

- (void)makeShadowBackground
{
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.7f;
    _backgroundOpacity = 0.7f;
}

- (void)setBackground
{
    _backgroundType=SCLAlertViewBackgroundShadow;
    [self makeShadowBackground];
}

#pragma mark - Show Alert

- (void)showView
{
    _showAnimationType= SCLAlertViewShowAnimationFadeIn;
    [self fadeIn];
}

#pragma mark - Hide Alert

- (void)hideView
{
    _hideAnimationType=SCLAlertViewHideAnimationFadeOut;
    [self fadeOut];
}

#pragma mark - Hide Animations

- (void)fadeOut
{
    [self fadeOutWithDuration:0.3f];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.backgroundView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (self.usingNewWindow) {
            // Remove current window
            [self.SCLAlertWindow setHidden:YES];
            self.SCLAlertWindow = nil;
        }
        if ( self.dismissAnimationCompletionBlock ){
            self.dismissAnimationCompletionBlock();
        }
    }];
}

#pragma mark - Show Animations

- (void)fadeIn
{
    self.backgroundView.alpha = 0.0f;
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundView.alpha = self.backgroundOpacity;
                         self.view.alpha = 1.0f;
                                    }
                     completion:^(BOOL finished) {
                         if ( self.showAnimationCompletionBlock ){
                             self.showAnimationCompletionBlock();
                                    }
    }];
}

@end
