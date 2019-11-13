//
//  ADLLocalizedHelper.h
//  lockboss
//
//  Created by adel on 2019/7/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADLString(key) [[ADLLocalizedHelper helper] stringWithKey:key]

@interface ADLLocalizedHelper : NSObject

+ (instancetype)helper;

- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;

@property (nonatomic, strong) NSString *currentLanguage;

@end
