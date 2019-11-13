//
//  NSNull+ADLNull.m
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "NSNull+ADLNull.h"

@implementation NSNull (ADLNull)

- (NSUInteger)length {
    return 0;
}

- (NSUInteger)count {
    return 0;
}

- (NSString *)description {
    return @"null";
}

- (NSArray *)allKeys {
    return @[];
}

- (id)objectForKey:(id)key {
    return nil;
}

- (BOOL)boolValue {
    return NO;
}

- (int)intValue {
    return 0;
}

- (float)floatValue {
    return 0;
}

- (double)doubleValue {
    return 0;
}

- (NSInteger)integerValue {
    return 0;
}

- (NSString *)stringValue {
    return @"";
}

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)searchSet {
    return NSMakeRange(0, 0);
}

- (BOOL)isNaturallyRTL {
    return NO;
}

- (NSArray<NSString *> *)componentsSeparatedByString:(NSString *)separator {
    return nil;
}

- (BOOL)isEqualToString:(NSString *)aString {
    return NO;
}

- (BOOL)containsString:(NSString *)str {
    return NO;
}

- (BOOL)hasPrefix:(NSString *)str {
    return NO;
}

- (BOOL)hasSuffix:(NSString *)str {
    return NO;
}

- (id)objectForKeyedSubscript:(id)key {
    return @"";
}

@end
