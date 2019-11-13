//
//  ADLDeviceModel.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/12/27.
//

#import <Foundation/Foundation.h>

@class ADLLockModel;
@interface ADLDeviceModel : NSObject
@property (nonatomic, strong) NSString *deviceName;//设备名称
@property (nonatomic, strong) NSString *deviceCode;//设备code
@property (nonatomic, strong) NSString *deviceId;//设备ID
@property (nonatomic, strong) NSString *deviceType;//设备类型21是网关
@property (nonatomic, strong) NSString *gatewayCode;//网关code
@property (nonatomic, assign) NSInteger battery;//电量
@property (nonatomic, strong) NSString *isFirstConnection;//1在线 0离线
@property (nonatomic, strong) NSString *jurisdiction;//"权限 1管理员，2家人"
@property (nonatomic, strong) NSString *openStatus;//1常开，0||null非常开",
@property (nonatomic, strong) NSString *deviceMac;//设备mac地址
@property (nonatomic, strong) NSString *isBing;
@property (nonatomic, strong) NSString *id;//设备ID
@property (nonatomic, strong) NSString *name;//设备ID
@property (nonatomic, strong) NSString *mac;//设备mac
@property (nonatomic, strong) NSString *ip;//设备ip
@property (nonatomic, strong) NSString *code;//设备序列号
@property (nonatomic, strong) NSString *status;//1常开，0||null非常开"
@property (nonatomic, strong) NSString *openGroup;//1组合 0任意
@property (nonatomic, strong) NSString *checkingInId;
@property (nonatomic, strong) NSMutableArray<ADLLockModel *> *devices;//门锁数组
@property (nonatomic ,strong) NSString *deviceStatus;//酒店设备的设备状态
@property (nonatomic, copy) NSString * passwordId;// 密码ID
@end
