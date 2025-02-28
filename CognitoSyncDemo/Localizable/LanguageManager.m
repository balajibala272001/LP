//
//  LanguageManager.m
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "LanguageManager.h"
#import "NSBundle+Language.h"

static NSString * const LanguageCodes[] = { @"en", @"es", @"fr", @"de", @"zh-Hans", @"pt-BR", @"ar", @"hi", @"ur", @"fil", @"nl"};
static NSString * const LanguageStrings[] = { @"English", @"Spanish", @"French", @"German", @"Chinese", @"Portugese", @"Arabic", @"Hindi", @"Urdu", @"Phillipines", @"Dutch"};
static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageManager

+ (void)setupCurrentLanguage
{
    NSString* selected_lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    NSString *currentLanguage;
    if([selected_lang isEqualToString:@"English"]){
        currentLanguage = @"en";
    }else if([selected_lang isEqualToString:@"Spanish"]){
        currentLanguage = @"es";
    }else if([selected_lang isEqualToString:@"French"]){
        currentLanguage = @"fr";
    }else if([selected_lang isEqualToString:@"German"]){
        currentLanguage = @"de";
    }else if([selected_lang isEqualToString:@"Chinese"]){
        currentLanguage = @"zh-Hans";
    }else if([selected_lang isEqualToString:@"Portugese"]){
        currentLanguage = @"pt-BR";
    }else if([selected_lang isEqualToString:@"Arabic"]){
        currentLanguage = @"ar";
    }else if([selected_lang isEqualToString:@"Hindi"]){
        currentLanguage = @"hi";
    }else if([selected_lang isEqualToString:@"Urdu"]){
        currentLanguage = @"ur";
    }else if([selected_lang isEqualToString:@"Phillipines"]){
        currentLanguage = @"fil";
    }else if([selected_lang isEqualToString:@"Dutch"]){
        currentLanguage = @"nl";
    }else{
        currentLanguage = @"en";
    }
    if (!currentLanguage) {
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if (languages.count > 0) {
            currentLanguage = languages[0];
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:LanguageSaveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }	
#ifndef USE_ON_FLY_LOCALIZATION
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [NSBundle setLanguage:currentLanguage];
#endif
}

+ (NSArray *)languageStrings
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        [array addObject:NSLocalizedString(LanguageStrings[i], @"")];
    }
    return [array copy];
}

+ (NSString *)currentLanguageString
{
    NSString *string = @"";
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]]) {
            string = NSLocalizedString(LanguageStrings[i], @"");
            break;
        }
    }
    return string;
}

+ (NSString *)currentLanguageCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
}

+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

+ (void)saveLanguageByIndex:(NSInteger)index
{
    if (index >= 0 && index < ELanguageCount) {
        NSString *code = LanguageCodes[index];
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LanguageSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef USE_ON_FLY_LOCALIZATION
        [NSBundle setLanguage:code];
#endif
    }
}

+ (BOOL)isCurrentLanguageRTL
{
	NSInteger currentLanguageIndex = [self currentLanguageIndex];
	return ([NSLocale characterDirectionForLanguage:LanguageCodes[currentLanguageIndex]] == NSLocaleLanguageDirectionRightToLeft);
}

@end
