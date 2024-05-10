

#import <Foundation/Foundation.h>

#ifdef USE_ON_FLY_LOCALIZATION

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

@end

#endif
