//
//  ADLLockRecordModel.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/6/27.
//

#import <Foundation/Foundation.h>

@interface ADLLockRecordModel : NSObject
@property (nonatomic, copy) NSString * id;//记录id
@property (nonatomic, copy) NSString * openDatetime;//开锁时间 date
@property (nonatomic, assign) NSInteger  openType;//1 开门类型255:无 1:前室外 2:后室内 3:前室外（常开）  4:钥匙",

@property (nonatomic ,assign) NSInteger openDirection;//1 开门类型255:无 1:前室外 2:后室内 3:前室外（常开）  4:钥匙", 8月9号周伟说给酒店组合开门方式增加
@property (nonatomic, copy) NSString * userName;//开锁人
@property (nonatomic, assign) NSInteger cylinderType;//锁芯状态
@property (nonatomic, copy) NSString *result;//开锁成功/失败，0失败 1成功
@property (nonatomic, copy) NSString *remarkName;
@property (nonatomic, copy) NSString *deleteStatus;

@property (nonatomic, copy) NSString *frontCylinder;//前把手
@property (nonatomic, copy) NSString *rearCylinder;//后把手

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;//h10-s 极品锁",
@property (nonatomic, copy) NSString *headShot;
@property (nonatomic, copy) NSString *openGroup;//0 是否组合",
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *fingerprintValidation;// "指纹验证状态 0 未验证，1验证成功，2验证失败 int",
@property (nonatomic, copy) NSString *cardValidation;//卡验证状态 int" 0 卡0未验证,1验证成功,2验证失败",
@property (nonatomic, copy) NSString *passwordValidation;//"密码验证状态0 密码0未验证,1验证成功,2验证失败",
@property (nonatomic, copy) NSString *phoneValidation;//"手机验证状态手机0未验证,1验证成功,2验证失败",

@property (nonatomic, copy) NSString *securityLevel;//1总统 2副总统 3部长安全等级 4局长安全等级 5州长安全等级
@end
