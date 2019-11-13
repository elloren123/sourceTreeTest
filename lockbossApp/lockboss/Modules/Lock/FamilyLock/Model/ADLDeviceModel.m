//
//  ADLDeviceModel.m
//  ADEL-APP
//
//  Created by bailun91 on 2018/12/27.
//

#import "ADLDeviceModel.h"
#import "ADLLockModel.h"

@implementation ADLDeviceModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"deviceId":@"id",
             @"deviceCode":@"code",
             @"deviceMac":@"mac",
             @"devices":@"ADLLockModel",
             @"deviceType":@"type"
             };
}

@end
