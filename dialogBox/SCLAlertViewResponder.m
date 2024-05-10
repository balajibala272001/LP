
//

#import "SCLAlertViewResponder.h"

@interface SCLAlertViewResponder ()

@property SCLAlertView *alertview;

@end

@implementation SCLAlertViewResponder
- (instancetype)init:(SCLAlertView *)alertview
{
    self.alertview = alertview;
    return self;
}

@end
