//
//  ADLDeviceTypeModel.h
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLDeviceTypeModel : NSObject

@property (nonatomic, strong) NSString *deviceType;//设备类型
@property (nonatomic, strong) NSString *url;//图标url
@property (nonatomic, strong) NSString *deviceTypeName;//设备类型名称
@property (nonatomic, strong) NSString *deviceCategoryId;//设备类别id
@property (nonatomic, strong) NSString *deviceCategoryName;//设备类别名称
@property (nonatomic, strong) NSString *linkType;//int 设备联网类型 1蓝牙（app连接设备），2zigbee（这个类型就请求后台接口）

@end

NS_ASSUME_NONNULL_END
