//
//  ADLLocalizedHelper.m
//  lockboss
//
//  Created by adel on 2019/7/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLocalizedHelper.h"

@implementation ADLLocalizedHelper {
    NSBundle *bundle;
}

+ (instancetype)helper {
    static ADLLocalizedHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ADLLocalizedHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *userLanguage = [[NSUserDefaults standardUserDefaults] valueForKey:@"userLanguage"];
        if (userLanguage.length == 0) {
            userLanguage = [[NSBundle mainBundle] preferredLocalizations].firstObject;
        }
        if (![userLanguage isEqualToString:@"en"] && ![userLanguage isEqualToString:@"zh-Hant"] && ![userLanguage isEqualToString:@"zh-Hans"]) {
            userLanguage = @"en";
        }
        self.currentLanguage = userLanguage;
        NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];
    }
    return self;
}

#pragma mark ------ 保存语言 ------
- (void)setUserLanguage:(NSString *)language {
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:@"userLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentLanguage = language;
}

#pragma mark ------ 获取当前语言对应的值 ------
- (NSString *)stringWithKey:(NSString *)key {
    return [bundle localizedStringForKey:key value:nil table:@"Localizable"];
}

@end
