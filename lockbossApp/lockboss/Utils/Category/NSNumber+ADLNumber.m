//
//  NSNumber+ADLNumber.m
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "NSNumber+ADLNumber.h"

@implementation NSNumber (ADLNumber)

- (NSUInteger)length {
    return [self stringValue].length;
}

- (NSUInteger)count {
    return 0;
}

- (BOOL)isNaturallyRTL {
    return NO;
}

- (BOOL)isEqualToString:(NSString *)aString {
    return [[self stringValue] isEqualToString:aString];
}

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)searchSet {
    return NSMakeRange(0, 0);
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self stringValue];
}

- (void)drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes context:(NSStringDrawingContext *)context {
    [[self stringValue] drawWithRect:rect options:options attributes:attributes context:context];
}

- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes context:(NSStringDrawingContext *)context {
    return [[self stringValue] boundingRectWithSize:size options:options attributes:attributes context:context];
}

@end
