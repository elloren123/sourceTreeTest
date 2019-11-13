//
//  ADLUserModel.m
//  lockboss
//
//  Created by adel on 2019/3/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLUserModel.h"

@implementation ADLUserModel

+ (instancetype)sharedModel {
    static ADLUserModel *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc] init];
    });
    return userModel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.headShot forKey:@"headShot"];
    [aCoder encodeObject:self.loginAccount forKey:@"loginAccount"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.isBindWeixin forKey:@"isBindWeixin"];
    [aCoder encodeObject:self.isBindQq forKey:@"isBindQq"];
     [aCoder encodeObject:self.Longitude forKey:@"Longitude"];
     [aCoder encodeObject:self.Latitude forKey:@"Latitude"];
     [aCoder encodeObject:self.city forKey:@"city"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.headShot = [aDecoder decodeObjectForKey:@"headShot"];
        self.loginAccount = [aDecoder decodeObjectForKey:@"loginAccount"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.isBindWeixin = [aDecoder decodeObjectForKey:@"isBindWeixin"];
        self.isBindQq = [aDecoder decodeObjectForKey:@"isBindQq"];
        self.Longitude = [aDecoder decodeObjectForKey:@"Longitude"];
        self.Latitude = [aDecoder decodeObjectForKey:@"Latitude"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict {
    [self setValuesForKeysWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.userId = value;
    }
}

- (void)setValueWithModel:(ADLUserModel *)model {
    self.userId = model.userId;
    self.headShot = model.headShot;
    self.loginAccount = model.loginAccount;
    self.nickName = model.nickName;
    self.phone = model.phone;
    self.email = model.email;
    self.token = model.token;
    self.isBindWeixin = model.isBindWeixin;
    self.isBindQq = model.isBindQq;
    self.userName = model.userName;
    self.password = model.password;
    self.login = YES;
    self.read = YES;
}

+ (void)saveUserModel:(ADLUserModel *)model {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"user_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (ADLUserModel *)readUserModel {
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_data"];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [[ADLUserModel alloc] init];
    }
}

+ (void)removeUserModel {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setHeadShot:(NSString *)headShot {
    if (headShot.length == 0) {
        _headShot = @"";
    } else {
        _headShot = headShot;
    }
}

- (void)resetUserModel {
    self.userId = nil;
    self.headShot = nil;
    self.loginAccount = nil;
    self.nickName = nil;
    self.userName = nil;
    self.password = nil;
    self.phone = nil;
    self.email = nil;
    self.token = nil;
    self.isBindQq = nil;
    self.isBindWeixin = nil;
    self.login = NO;
    self.read = YES;
}

@end
