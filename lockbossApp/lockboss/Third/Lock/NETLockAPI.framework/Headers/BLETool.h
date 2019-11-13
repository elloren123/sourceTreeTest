//
//  BLETool.h
//  text321
//
//  Created by adel on 17/3/29.
//  Copyright © 2017年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ADSingleton.h"

//门锁的通讯模式
typedef NS_ENUM(NSUInteger, ADOS_LockCommunicationModel){
    
    ADOS_BLEWorkModelThirdCmd  = 0,      //bit0:第三方指令使能
    ADOS_BLEWorkModelHandShake = 1 << 1, //bit1:身份验证/握手使能
    ADOS_BLEWorkModelSignature = 1 << 2, //bit2:签名使能
    ADOS_BLEWorkModelCrypt     = 1 << 3, //bit3:加密使能
    ADOS_BLEWorkModelSession   = 1 << 4  //bit4:会话密钥使能(动态密钥)
};

//门锁工作模式
typedef NS_ENUM(NSUInteger, ADOS_LockWorkModel) {
    
    ADOS_LockWorkModelDefault = 1,//默认模式(出厂)
    ADOS_LockWorkModelMaster,//主控模式
    ADOS_LockWorkModelNormal,//正常工作模式
    ADOS_LockWorkModelMaintain//维护模式
};

@interface BLETool : NSObject
ADSingletonH(BLETool)

@property (nonatomic, copy) NSString * currentVoltage;//电压
@property (nonatomic, copy) NSString * currentPower;//电量
@property (nonatomic, copy) NSString * currentDoorStatue;//当前门锁状态
@property (nonatomic, assign) ADOS_LockCommunicationModel currentLockCommunicationModel;//蓝牙通讯模式
@property (nonatomic, assign) ADOS_LockWorkModel currentLockWorkModel;//门锁工作模式
@property (nonatomic, copy) NSString * currentTime;//当前时间

/****************************主要功能类***************************/

/**
 *  蓝牙开门
 *
 *  @param p    外设
 *  @param dataStr 二维码
 */
+ (void)BLEOpendoorWithPeripheral:(CBPeripheral *)p dataStr:(NSString *)dataStr;

/**
 *  解析蓝牙返回数据
 *
 *  @param p     当前外设
 *  @param value 蓝牙返回数据
 *
 *  @return 解析后的数据
 */
+ (NSString *)didRecvValueWithPeripheral:(CBPeripheral *)p value:(NSString *)value;

/**
 *  订阅蓝牙通知
 *
 *  @param p       当前外设
 *  @param enabled 是否订阅通知
 */
+ (void)notification:(CBPeripheral *)p enabled:(BOOL)enabled;

@end
