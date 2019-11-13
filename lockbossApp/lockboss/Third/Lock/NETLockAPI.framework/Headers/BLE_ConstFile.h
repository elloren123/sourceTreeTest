//
//  BLE_ConstFile.h
//  BLDemo
//
//  Created by adel on 17/3/10.
//  Copyright © 2017年 adel. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


/**
 *  蓝牙串口UUID
 */

UIKIT_EXTERN NSString * const KBLEServiceUUID;//服务UUID
UIKIT_EXTERN NSString * const KBLEWriteUUID;//写 Write Without Response
UIKIT_EXTERN NSString * const KBLENotifyUUID; //订阅消息


/**
 *  默认签名秘钥
 */

UIKIT_EXTERN unsigned char const ADEL_DEFAULTKEY_SIGNATURE [];

/**
 *  默认加密秘钥
 */

UIKIT_EXTERN unsigned char const ADEL_DEFAULTKEY_ENCRYPT [];

/**
 *  默认的根秘钥
 */

UIKIT_EXTERN unsigned char const ADEL_DEFAULTKEY_ROOT [];

