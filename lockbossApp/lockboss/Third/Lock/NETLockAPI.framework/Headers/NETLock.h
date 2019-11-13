//
//  NETLock.h
//  NETLock_Interface
//
//  Created by adel on 17/4/17.
//  Copyright © 2017年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSingleton.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface NETLock : NSObject

ADSingletonH(NETLock)


/**
 *  网络锁开门
 *
 *  @param code 二维码信息
 */

+ (void)networkOpendoorWithQRCode:(NSString *)code complete:(void(^)(NSString * result))complete;


/**
 *  蓝牙开门
 *
 *  @param code       要发送的数据
 *  @param peripheral 当前外设
 *  @complete 是否成功发送数据到蓝牙
 
 CONNECT_ERROR        连接失败
 SEND_ERROR           发送失败
 GETOPENDOORKEY_ERROR 获取开门秘钥失败
 BLESEND_SUCCESS      向蓝牙发送数据成功
 
 */

+ (void)BLEOpendoorWithPeripheral:(CBPeripheral *)peripheral QRCode:(NSString *)code complete:(void(^)(NSString * result))complete;



/**
 *  解析二维码信息
 *
 *  @param code 扫描到的二维码
 *
 *  @return 解析出的二维码字段
 */
+ (NSDictionary *)DecodeQRCode:(NSString *)code;

/**
 *  获取蓝牙房间号(蓝牙名称)
 *
 *  @param code 二维码信息
 *
 *  @return 返回值(成功返回解析出来的字典信息,错误返回错误信息)
 *  注:此方法需要连接服务器获取蓝牙名称,即房名
 
 
 CONNECT_ERROR      连接失败
 SEND_ERROR         发送失败
 RECVROOMNAME_ERROR 接收蓝牙名称失败
 GETROOMNAME_ERROR  获取蓝牙名称失败
 */
+ (void)getBLERoomNameWithQRCode:(NSString *)code complete:(void(^)(NSString * roomName))complete;


@end
