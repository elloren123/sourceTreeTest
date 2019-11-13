//
//  ADSington.h
//  ADEL_Lock
//
//  Created by adel on 16/8/12.
//  Copyright © 2016年 adel. All rights reserved.
//


// .h文件
#define ADSingletonH(name) + (instancetype)shared##name;

// .m文件
#define ADSingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}