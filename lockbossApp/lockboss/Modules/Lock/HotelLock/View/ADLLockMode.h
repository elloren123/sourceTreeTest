//
//  ADLLockMode.h
//  lockboss
//
//  Created by adel on 2019/11/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLLockMode : NSObject
@property (nonatomic, strong) NSString *secretId;//密钥id"
@property (nonatomic, strong) NSString *secretName;//密钥名称
@property (nonatomic, strong) NSString *checkingInId;//入住id
@property (nonatomic, strong) NSString *deviceId;//设备Id
@property (nonatomic, strong) NSString *code;//密钥Code
@property (nonatomic, strong) NSString *type;//1 密码，2卡 3指纹 4蓝牙",
@property (nonatomic, strong) NSString *startDatetime;//开始时间
@property (nonatomic, strong) NSString *endDatetime;//结束时间
@property (nonatomic, strong) NSString *dataSource;//数据来源1：自己平台，2：433"
@property (nonatomic, assign) BOOL isOpen;//"true:开 false 关"
@property (nonatomic, strong) NSString *id;


@property (nonatomic, copy) NSString * openFingerprint; //指纹//0 否，1 是-1没有对应开门方式,
@property (nonatomic, assign) NSString *openApp;//0否，1 是-1没有对应开门方式,
@property (nonatomic, copy) NSString * openCard;//0否，1 是-1没有对应开门方式,
@property (nonatomic, copy) NSString * openPassword;//0否，1 是-1没有对应开门方式，
@property (nonatomic, copy) NSString * openFace;//0否，1 是-1没有对应开门方式，
@property (nonatomic, copy) NSString * openStatus;// 0否，1 是-1没有对应开门方式，
@property (nonatomic, copy) NSString * openGroup;//是-1没有对应开门方式,
@property (nonatomic, copy) NSString * securityLevel;//安全等级 默认4"
@end


/**
*总统等级: 人脸,指纹,RF卡,密码,手机app
*总理级:5选3
*部长级:级:5选2
*局长级:级:任意一种
*州长级:只支持RF卡
*/
NS_ASSUME_NONNULL_END
