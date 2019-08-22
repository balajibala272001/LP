//
//  UIView+Toast.m
//  Toast
//
//  Copyright (c) 2011-2015 Charles Scalesse.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//                        for (NSDictionary *avatar in networkDict) {
//
//
//                            NSDictionary *a = [avatar objectForKey:@"sites_data"];
//
//
//
//
//                            for (NSDictionary *siteNameDict in a) {
//
//
//                                NSString *siteName = [siteNameDict objectForKey:@"site_name"];
//                                NSString *s_id = [siteNameDict objectForKey:@"s_id"];
//                                [SiteDataToSiteclass setObject:siteName forKey:@"site_name"];
//                                [SiteDataToSiteclass setObject:s_id forKey:@"s_id"];
//
//                                [[Site Site]saveSiteData:SiteDataToSiteclass];
//
//
//
//                            }
//                            NSLog(@"%@",a);
//
//
//                            // THE REST OF YOUR CODE
//                        }
//

#import "UIView+Toast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

NSString * CSToastPositionTop       = @"CSToastPositionTop";
NSString * CSToastPositionCenter    = @"CSToastPositionCenter";
NSString * CSToastPositionBottom    = @"CSToastPositionBottom";

// Keys for values associated with toast views
static const NSString * CSToastTimerKey             = @"CSToastTimerKey";
static const NSString * CSToastDurationKey          = @"CSToastDurationKey";
static const NSString * CSToastPositionKey          = @"CSToastPositionKey";
static const NSString * CSToastCompletionKey        = @"CSToastCompletionKey";

// Keys for values associated with self
static const NSString * CSToastActiveToastViewKey   = @"CSToastActiveToastViewKey";
static const NSString * CSToastActivityViewKey      = @"CSToastActivityViewKey";
static const NSString * CSToastQueueKey             = @"CSToastQueueKey";

@interface UIView (ToastPrivate)

/**
 These private methods are being prefixed with "cs_" to reduce the likelihood of non-obvious 
 naming conflicts with other UIView methods.
 
 @discussion Should the public API also use the cs_ prefix? Technically it should, but it
 results in code that is less legible. The current public method names seem unlikely to cause
 conflicts so I think we should favor the cleaner API for now.
 */
- (void)cs_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position;
- (void)cs_hideToast:(UIView *)toast;
- (void)cs_hideToast:(UIView *)toast fromTap:(BOOL)fromTap;
- (void)cs_toastTimerDidFinish:(NSTimer *)timer;
- (void)cs_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)cs_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (NSMutableArray *)cs_toastQueue;

@end

@implementation UIView (Toast)

#pragma mark - Make Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:[CSToastManager defaultDuration] position:[CSToastManager defaultPosition] style:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    [self makeToast:message duration:duration position:position style:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position style:(CSToastStyle *)style {
    UIView *toast = [self toastViewForMessage:message title:nil image:nil style:style];
    [self showToast:toast duration:duration position:position completion:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title image:(UIImage *)image style:(CSToastStyle *)style completion:(void(^)(BOOL didTap))completion {
    UIView *toast = [self toastViewForMessage:message title:title image:image style:style];
    [self showToast:toast duration:duration position:position completion:completion];
}

#pragma mark - Show Toast Methods

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:[CSToastManager defaultDuration] position:[CSToastManager defaultPosition] completion:nil];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position completion:(void(^)(BOOL didTap))completion {
    // sanity
    if (toast == nil) return;
    
    // store the completion block on the toast view
    objc_setAssociatedObject(toast, &CSToastCompletionKey, completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([CSToastManager isQueueEnabled] && objc_getAssociatedObject(self, &CSToastActiveToastViewKey) != nil) {
        // we're about to queue this toast view so we need to store the duration and position as well
        objc_setAssociatedObject(toast, &CSToastDurationKey, @(duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(toast, &CSToastPositionKey, position, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // enqueue
        [self.cs_toastQueue addObject:toast];
    } else {
        // present
        [self cs_showToast:toast duration:duration position:position];
    }
}

#pragma mark - Private Show/Hide Methods

- (void)cs_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    toast.center = [self cs_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if ([CSToastManager isTapToDismissEnabled]) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cs_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    // set the active toast
    objc_setAssociatedObject(self, &CSToastActiveToastViewKey, toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(cs_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                         objc_setAssociatedObject(toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

- (void)cs_hideToast:(UIView *)toast {
    [self cs_hideToast:toast fromTap:NO];
}
    
- (void)cs_hideToast:(UIView *)toast fromTap:(BOOL)fromTap {
    [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                         
                         // clear the active toast
                         objc_setAssociatedObject(self, &CSToastActiveToastViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         
                         // execute the completion block, if necessary
                         void (^completion)(BOOL didTap) = objc_getAssociatedObject(toast, &CSToastCompletionKey);
                         if (completion) {
                             completion(fromTap);
                         }
                         
                         if ([self.cs_toastQueue count] > 0) {
                             // dequeue
                             UIView *nextToast = [[self cs_toastQueue] firstObject];
                             [[self cs_toastQueue] removeObjectAtIndex:0];
                             
                             // present the next toast
                             NSTimeInterval duration = [objc_getAssociatedObject(nextToast, &CSToastDurationKey) doubleValue];
                             id position = objc_getAssociatedObject(nextToast, &CSToastPositionKey);
                             [self cs_showToast:nextToast duration:duration position:position];
                         }
                     }];
}

#pragma mark - View Construction

- (UIView *)toastViewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image style:(CSToastStyle *)style {
    // sanity
    if(message == nil && title == nil && image == nil) return nil;
    
    // default to the shared style
    if (style == nil) {
        style = [CSToastManager sharedStyle];
    }
    
    // dynamically build a toast view with any combination of message, title, & image
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = style.cornerRadius;
    
    if (style.displayShadow) {
        wrapperView.layer.shadowColor = style.shadowColor.CGColor;
        wrapperView.layer.shadowOpacity = style.shadowOpacity;
        wrapperView.layer.shadowRadius = style.shadowRadius;
        wrapperView.layer.shadowOffset = style.shadowOffset;
    }
    
    wrapperView.backgroundColor = style.backgroundColor;
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(style.horizontalPadding, style.verticalPadding, style.imageSize.width, style.imageSize.height);
    }
    
    CGRect imageRect = CGRectZero;
    
    if(imageView != nil) {
        imageRect.origin.x = style.horizontalPadding;
        imageRect.origin.y = style.verticalPadding;
        imageRect.size.width = imageView.bounds.size.width;
        imageRect.size.height = imageView.bounds.size.height;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = style.titleNumberOfLines;
        titleLabel.font = style.titleFont;
        titleLabel.textAlignment = style.titleAlignment;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = style.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * style.maxWidthPercentage) - imageRect.size.width, self.bounds.size.height * style.maxHeightPercentage);
        CGSize expectedSizeTitle = [titleLabel sizeThatFits:maxSizeTitle];
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSizeMake(MIN(maxSizeTitle.width, expectedSizeTitle.width), MIN(maxSizeTitle.height, expectedSizeTitle.height));
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = style.messageNumberOfLines;
        messageLabel.font = style.messageFont;
        messageLabel.textAlignment = style.messageAlignment;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        messageLabel.textColor = style.messageColor;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * style.maxWidthPercentage) - imageRect.size.width, self.bounds.size.height * style.maxHeightPercentage);
        CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    CGRect titleRect = CGRectZero;
    
    if(titleLabel != nil) {
        titleRect.origin.x = imageRect.origin.x + imageRect.size.width + style.horizontalPadding;
        titleRect.origin.y = style.verticalPadding;
        titleRect.size.width = titleLabel.bounds.size.width;
        titleRect.size.height = titleLabel.bounds.size.height;
    }
    
    CGRect messageRect = CGRectZero;
    
    if(messageLabel != nil) {
        messageRect.origin.x = imageRect.origin.x + imageRect.size.width + style.horizontalPadding;
        messageRect.origin.y = titleRect.origin.y + titleRect.size.height + style.verticalPadding;
        messageRect.size.width = messageLabel.bounds.size.width;
        messageRect.size.height = messageLabel.bounds.size.height;
    }
    
    CGFloat longerWidth = MAX(titleRect.size.width, messageRect.size.width);
    CGFloat longerX = MAX(titleRect.origin.x, messageRect.origin.x);
    
    // Wrapper width uses the longerWidth or the image width, whatever is larger. Same logic applies to the wrapper height.
    CGFloat wrapperWidth = MAX((imageRect.size.width + (style.horizontalPadding * 2.0)), (longerX + longerWidth + style.horizontalPadding));
    CGFloat wrapperHeight = MAX((messageRect.origin.y + messageRect.size.height + style.verticalPadding), (imageRect.size.height + (style.verticalPadding * 2.0)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = titleRect;
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = messageRect;
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

#pragma mark - Queue

- (NSMutableArray *)cs_toastQueue {
    NSMutableArray *cs_toastQueue = objc_getAssociatedObject(self, &CSToastQueueKey);
    if (cs_toastQueue == nil) {
        cs_toastQueue = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &CSToastQueueKey, cs_toastQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cs_toastQueue;
}

#pragma mark - Events

- (void)cs_toastTimerDidFinish:(NSTimer *)timer {
    [self cs_hideToast:(UIView *)timer.userInfo];
}

- (void)cs_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    UIView *toast = recognizer.view;
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(toast, &CSToastTimerKey);
    [timer invalidate];
    
    [self cs_hideToast:toast fromTap:YES];
}

#pragma mark - Activity Methods

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    CSToastStyle *style = [CSToastManager sharedStyle];
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, style.activitySize.width, style.activitySize.height)];
    activityView.center = [self cs_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = style.backgroundColor;
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = style.cornerRadius;
    
    if (style.displayShadow) {
        activityView.layer.shadowColor = style.shadowColor.CGColor;
        activityView.layer.shadowOpacity = style.shadowOpacity;
        activityView.layer.shadowRadius = style.shadowRadius;
        activityView.layer.shadowOffset = style.shadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:style.fadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)cs_centerPointForPosition:(id)point withToast:(UIView *)toast {
    CSToastStyle *style = [CSToastManager sharedStyle];
    
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:CSToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + style.verticalPadding);
        } else if([point caseInsensitiveCompare:CSToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - style.verticalPadding);
}

@end

@implementation CSToastStyle

#pragma mark - Constructors

- (instancetype)initWithDefaultStyle {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.titleColor = [UIColor whiteColor];
        self.messageColor = [UIColor whiteColor];
        self.maxWidthPercentage = 0.8;
        self.maxHeightPercentage = 0.8;
        self.horizontalPadding = 10.0;
        self.verticalPadding = 10.0;
        self.cornerRadius = 10.0;
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.messageFont = [UIFont systemFontOfSize:16.0];
        self.titleAlignment = NSTextAlignmentLeft;
        self.messageAlignment = NSTextAlignmentLeft;
        self.titleNumberOfLines = 0;
        self.messageNumberOfLines = 0;
        self.displayShadow = NO;
        self.shadowOpacity = 0.8;
        self.shadowRadius = 6.0;
        self.shadowOffset = CGSizeMake(4.0, 4.0);
        self.imageSize = CGSizeMake(80.0, 80.0);
        self.activitySize = CGSizeMake(100.0, 100.0);
        self.fadeDuration = 0.2;
    }
    return self;
}

- (void)setMaxWidthPercentage:(CGFloat)maxWidthPercentage {
    _maxWidthPercentage = MAX(MIN(maxWidthPercentage, 1.0), 0.0);
}

- (void)setMaxHeightPercentage:(CGFloat)maxHeightPercentage {
    _maxHeightPercentage = MAX(MIN(maxHeightPercentage, 1.0), 0.0);
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

@end

@interface CSToastManager ()

@property (strong, nonatomic) CSToastStyle *sharedStyle;
@property (assign, nonatomic, getter=isTapToDismissEnabled) BOOL tapToDismissEnabled;
@property (assign, nonatomic, getter=isQueueEnabled) BOOL queueEnabled;
@property (assign, nonatomic) NSTimeInterval defaultDuration;
@property (strong, nonatomic) id defaultPosition;

@end

@implementation CSToastManager

#pragma mark - Constructors

+ (instancetype)sharedManager {
    static CSToastManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sharedStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        self.tapToDismissEnabled = YES;
        self.queueEnabled = YES;
        self.defaultDuration = 3.0;
        self.defaultPosition = CSToastPositionBottom;
    }
    return self;
}

#pragma mark - Singleton Methods

+ (void)setSharedStyle:(CSToastStyle *)sharedStyle {
    [[self sharedManager] setSharedStyle:sharedStyle];
}

+ (CSToastStyle *)sharedStyle {
    return [[self sharedManager] sharedStyle];
}

+ (void)setTapToDismissEnabled:(BOOL)tapToDismissEnabled {
    [[self sharedManager] setTapToDismissEnabled:tapToDismissEnabled];
}

+ (BOOL)isTapToDismissEnabled {
    return [[self sharedManager] isTapToDismissEnabled];
}

+ (void)setQueueEnabled:(BOOL)queueEnabled {
    [[self sharedManager] setQueueEnabled:queueEnabled];
}

+ (BOOL)isQueueEnabled {
    return [[self sharedManager] isQueueEnabled];
}

+ (void)setDefaultDuration:(NSTimeInterval)duration {
    [[self sharedManager] setDefaultDuration:duration];
}

+ (NSTimeInterval)defaultDuration {
    return [[self sharedManager] defaultDuration];
}

+ (void)setDefaultPosition:(id)position {
    if ([position isKindOfClass:[NSString class]] || [position isKindOfClass:[NSValue class]]) {
        [[self sharedManager] setDefaultPosition:position];
    }
}

+ (id)defaultPosition {
    return [[self sharedManager] defaultPosition];
}


//SiteData *sites = self.siteData;
//self.metaDataArray = sites.arrFieldData;
//
//int x_btn =14;
//int width_btn = 150;
//int height_btn = 30;
//int heightofScreen_btn =self.sub_View.frame.size.height;
//int heightOfPadding_btn = 20;
//int noOfButton_btn = self.metaDataArray.count;
//int noOfPadding_btn  = noOfButton_btn + 1;
//int totalheightPadding_btn = noOfPadding_btn * heightOfPadding_btn;
//
//int hb_btn =(heightofScreen_btn - totalheightPadding_btn) /noOfButton_btn;
//
//
//
//
//int width_txt =120;
//int height_txt =30;
//int widthOfScreen =self.sub_View.frame.size.width;
//
//for (int i =0; i<self.metaDataArray.count; i++) {
//    int ypos_btn = (i+1) * (noOfPadding_btn + i * hb_btn);
//    int y_txt =ypos_btn;
//    int horizontalPadding = 20;
//    
//    int x_txt = horizontalPadding+ widthOfScreen-(width_btn+10);
//    
//    
//    UIButton *metaData_btn = [[UIButton alloc]init];
//    metaData_btn.frame = CGRectMake(x_btn,ypos_btn, width_btn, height_btn);
//    FieldData *fieldData = self.metaDataArray [i];
//    NSString *Label = fieldData.strFieldLabel;
//    [metaData_btn setTitle:Label forState:UIControlStateNormal];
//    [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];

//    [self.sub_View addSubview:metaData_btn];
//    
//    UITextField *metaData_txt = [[UITextField alloc]init];
//    metaData_txt.frame = CGRectMake(x_txt, y_txt, width_txt, height_txt);
//    metaData_txt.layer.cornerRadius = 5;
//    metaData_txt.layer.borderWidth =1.0;
//    metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    [self.sub_View addSubview:metaData_txt];
//    
//    
//    
//    int sub_viewHeight = ypos_btn+height_btn+heightOfPadding_btn;
//    CGRect newFrame = CGRectMake( 0, 0, 320, sub_viewHeight);
//    self.sub_View.frame = newFrame;
//    
//}

//newCode in stackoverflow postman
//working code with image in text
//+(void)uplaodingImageWithDetails:(NSDictionary *)dict imageresoure:(NSData *)imageResource andCompletion:(GFWebServiceHandler)completion
//{
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL,API_TO_UPLOAD_IMAGE];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict
//                                                       options:0
//                                                         error:nil];
//    
//    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    //convert image data  into string
//    
//    // NSString *imageString  = [[NSString alloc]initWithData:imageResource encoding:NSUTF8StringEncoding];
//    NSString *imageString = [imageResource base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    
//    NSArray *parameters = @[ @{ @"name": @"userDetails", @"value": jsonString },
//                             
//                             @{ @"name": @"userImage", @"fileName":imageString } ];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSString *boundary = @"---011000010111000001101001";
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
//                               
//                               @"cache-control": @"no-cache",
//                               @"postman-token": @"463bcf06-08f6-7611-c1fb-13b0dde79c5c"};
//    
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"\r\n--%@\r\n", boundary];
//        if (param[@"fileName"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], @"yourimage.jpg"];
//            [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//            [body appendFormat:@"%@", param[@"fileName"]];
//            
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPMethod:@"POST"];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
//    //  NSURLResponse *response;
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionUploadTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
//                                        {
//                                            
//                                            
//                                            //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                            //    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                            if (error) {
//                                                NSLog(@"%@", error);
//                                            } else {
//                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                NSLog(@"%@", httpResponse);
//                                                
//                                                NSString *stringFromData = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//                                                
//                                                NSLog(@"%@",stringFromData);
//                                                
//                                            }
//                                        }];
//    [dataTask resume];
//}
////postman
//+(void)uploadImagesAndDict:(NSDictionary *)dict imageresource:(NSData *)imageResource andCompletion:(GFWebServiceHandler)completion
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL,API_TO_UPLOAD_IMAGE];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict
//                                                       options:0
//                                                         error:nil];
//    
//    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    //NSString *imageString = [[NSString alloc]initWithData:imageResource encoding:NSUTF8StringEncoding];
//    
//    NSString *imageString = [imageResource base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
//                               @"authorization": @"Basic U2FyYXN3YXRoaTpodHRwOi8vbG9hZHByb29mLndpc2VseXNvZnQuY29tL2xvYWRwcm9vZi9hcGkvdjEvdXBsb2FkX2ltYWdlX2luX2J1Y2tldC5waHA/",
//                               @"cache-control": @"no-cache",
//                               @"postman-token": @"2531943a-9727-c589-8073-d9c2c0b2b464" };
//    //    NSArray *parameters = @[ @{ @"name": @"userDetails", @"value": jsonString },
//    //                             @{ @"name": @"userImage", @"value": imageResource}];
//    //
//    NSArray *parameters = @[ @{ @"name": @"userDetails", @"value": jsonString },
//                             @{ @"name": @"userImage", @"fileName": @{ @"0": @{  } } } ];
//    
//    NSString *boundary = @"---011000010111000001101001";
//    
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"userImage"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; userImage=\"%@\"\r\n", param[@"name"], param[@"userImage"]];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            //[body appendFormat:@"%@", stringImage];
//            [body appendFormat:@"%@",imageString];
//            //[body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loadproof.wiselysoft.com/loadproof/api/v1/upload_image_in_bucket.php"]
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:10.0];
//    [request setHTTPMethod:@"POST"];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if (error) {
//                                                        NSLog(@"%@", error);
//                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSLog(@"%@", httpResponse);
//                                                        
//                                                        NSString *stringFromData = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//                                                        
//                                                        NSLog(@"%@",stringFromData);
//                                                    }
//                                                }];
//    [dataTask resume];
//    
//}
//+(void)uploadImageAndString:(NSDictionary *)dict imageresource:(NSData *)imageResource andCompletion:(GFWebServiceHandler)completion
//{
//    //NSMutableDictionary *params =[NSMutableDictionary dictionary];
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL,API_TO_UPLOAD_IMAGE];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict
//                                                       options:0
//                                                         error:nil];
//    
//    AFHTTPRequestSerializer *serializerReq =[AFHTTPRequestSerializer serializer];
//    serializerReq.timeoutInterval = 60.f;
//    [serializerReq setValue:@"multipart/form-data" forHTTPHeaderField:@"Content_type"];
//    //[serializerReq setValue:[NSString stringWithFormat:@"Basic ]]
//    NSError *error;
//    
//    NSMutableURLRequest *request = [serializerReq multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//                                    {
//                                        [formData appendPartWithFormData:jsonData name:@"userDetails"];
//                                        
//                                        //         [formData appendPartWithFileData:imageResource name:@"file" fileName:[NSString stringWithFormat:@"%d.%@",UUID(),@"jpg"] mimeType:@"png"];
//                                        //
//                                        
//                                    } error:&error];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    AFHTTPResponseSerializer *serializerRes = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer = serializerRes;
//    
//    NSURLSessionUploadTask *datatask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        
//        NSLog(@"%@",response);
//        
//        NSString *stringFromData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",stringFromData);
//        
//        
//        
//        //do your own work
//    }];
//    [datatask resume];
//    
//    
//    
//}
//
//+(void)uploadImages:(NSDictionary *)dict imageresource:(NSData *)imageData andCompletion:(GFWebServiceHandler)completion
//{
//    //image to  file
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    
//    UIImage * imageToSave = [UIImage imageNamed:@"sticky.png"];
//    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
//    NSString *filePath = [basePath stringByAppendingPathComponent:@"sticky.png"];
//    BOOL success = [binaryImageData writeToFile:filePath atomically:YES];
//    
//    NSString *imgString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict
//                                                       options:0
//                                                         error:nil];
//    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //NSString *stringImage = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
//    //NSString *stringImage = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
//                               
//                               @"cache-control": @"no-cache",
//                               @"postman-token": @"f93b7bb9-040f-fa7c-8a65-5a4f8e057cfe" };
//    NSArray *parameters = @[ @{ @"name": @"userDetails", @"value":jsonString  }
//                             ,@{ @"name": @"userImage", @"fileName":@{@"0":@{}}}
//                             ];
//    NSString *boundary = @"---011000010111000001101001";
//    
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"fileName"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; fileName=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
//            //[body appendFormat:@"%@", imgString];
//            //[body appendFormat:[NSData dataWithData:binaryImageData]];
//            //[body appendFormat:@"%@", stringImage];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loadproof.wiselysoft.com/loadproof/api/v1/upload_image_in_bucket.php"]
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:10.0];
//    [request setHTTPMethod:@"POST"];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if (error) {
//                                                        NSLog(@"%@", error);
//                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSLog(@"%@", httpResponse);
//                                                        
//                                                        NSString *stringFromData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                        
//                                                        NSLog(@"%@",stringFromData);
//                                                    }
//                                                }];
//    [dataTask resume];
//    
//    
//    
//    
//    
//}
//
//newly created method

//+(void)UploadImageWithAlldetails:(NSDictionary *)string imageresource:(NSData *)imageResource andCompletion:(GFWebServiceHandler)completion
//{
//    NSString *createNoteUrl=[NSString stringWithFormat:@"%@/%@",BASE_URL,API_TO_UPLOAD_IMAGE];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: string
//                                                       options:0
//                                                         error:nil];
//    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:createNoteUrl]];
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:60];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    
//    NSString *boundary = @"unique-consistent-string";
//    //set conteent type in HTTP header
//    
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
//    //[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request addValue:contentType forHTTPHeaderField:@"Content_Type"];
//    
//    NSMutableData *body =[NSMutableData data];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition : form-data; name = %@\r\n\r\n",@"userDetails"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Type :application/octet-stream\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithFormat:@"%@\r\n",jsonString]
//                      dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    //image data
//    
//    if (imageResource) {
//        
//        //edited stackoverflow content type for image only
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\".png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        // [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.png\r\n", @"userImage"] dataUsingEncoding:NSUTF8StringEncoding]];
//        // [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        [body appendData:[NSData dataWithData:imageResource]];
//        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary ] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // set the content-length
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPBody:body];
//    
//    
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if(data.length > 0)
//        {
//            //success
//            NSLog(@"%@",response);
//            
//            NSString *stringFromData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"%@",stringFromData);
//            
//            
//        }
//    }];
//    
//}

@end
