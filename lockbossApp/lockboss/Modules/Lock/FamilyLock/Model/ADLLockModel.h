//
//  ADLLockModel.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/12/28.
//

#import <Foundation/Foundation.h>

@interface ADLLockModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *isFirstConnection;//1上线 0下线
@property (nonatomic, strong) NSString *battery;
@property (nonatomic, strong) NSString *isBing;//0未绑定 1绑定
@property (nonatomic, strong) NSString *firmwareVersion;//固件版本
@property (nonatomic, strong) NSString *hardwareVersion;//硬件版本
@property (nonatomic, strong) NSString *NEWFirmwareVersion;//硬件对应固件版本号
@property (nonatomic, strong) NSString *model;//硬件版本
@end

