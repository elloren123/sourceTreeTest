//
//  ADLUserModel.h
//  lockboss
//
//  Created by adel on 2019/3/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADLUserModel : NSObject<NSCoding>

///单例
+ (instancetype)sharedModel;

///字典赋值
- (void)setValueWithDict:(NSDictionary *)dict;

///模型赋值
- (void)setValueWithModel:(ADLUserModel *)model;

///保存userModel到本地
+ (void)saveUserModel:(ADLUserModel *)model;

///从本地取出userModel
+ (ADLUserModel *)readUserModel;

///删除本地保存的userModel
+ (void)removeUserModel;

///重置当前userModel的值
- (void)resetUserModel;

///用户id
@property (nonatomic, strong) NSString *userId;

///用户头像地址
@property (nonatomic, strong) NSString *headShot;

///登录账号
@property (nonatomic, strong) NSString *loginAccount;

///用户昵称
@property (nonatomic, strong) NSString *nickName;

///IM账号
@property (nonatomic, strong) NSString *userName;

///IM密码
@property (nonatomic, strong) NSString *password;

///用户手机号
@property (nonatomic, strong) NSString *phone;

///用户邮箱
@property (nonatomic, strong) NSString *email;

///用户token
@property (nonatomic, strong) NSString *token;

///是否绑定微信
@property (nonatomic, strong) NSNumber *isBindWeixin;

///是否绑定QQ
@property (nonatomic, strong) NSNumber *isBindQq;

///用户是否登录
@property (nonatomic, assign) BOOL login;

///是否有未读消息
@property (nonatomic, assign) BOOL read;


///经度
@property (nonatomic,  strong) NSString *Longitude;

///纬度
@property (nonatomic,  strong) NSString *Latitude;


///城市
@property (nonatomic, strong) NSString *city;
@end
