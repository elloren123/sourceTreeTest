//
//  ADLRMQConnection.m
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLRMQConnection.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"
#import "ADLUserModel.h"
#import "ADELUrlpath.h"

#import <RMQClient/RMQChannel.h>
#import <RMQClient/RMQConnection.h>

@interface ADLRMQConnection ()
@property (nonatomic, strong) RMQConnection *connection;
@end

@implementation ADLRMQConnection

+ (instancetype)sharedConnect {
    static ADLRMQConnection *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ADLRMQConnection alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startConnection) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeConnection) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeConnection) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

#pragma mark ------ 开始连接 ------
- (void)startConnection {
    if (self.connection != nil) {
        [self.connection close];
        self.connection = nil;
    }
    if ([ADLUserModel sharedModel].login) {
        NSString *queueName = [NSString stringWithFormat:@"%@%@",[ADLUserModel sharedModel].userId, [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN]];
        
        self.connection = [[RMQConnection alloc] initWithUri:RMQCURL delegate:nil];
        [self.connection start];
        id<RMQChannel> channel = [self.connection createChannel];
        RMQQueue *queue = [channel queue:queueName options:RMQQueueDeclareDurable];
        [queue subscribe:^(RMQMessage * _Nonnull message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *msgArr = [[[NSString alloc]initWithData:message.body encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"|"];
                NSString *msgStr = msgArr.firstObject;
                NSString *infStr = msgArr[1];
                NSData *infData = [infStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *infDict = nil;
                if (infData) {
                    infDict = [NSJSONSerialization JSONObjectWithData:infData options:NSJSONReadingMutableContainers error:nil];
                }
                
                if ([msgStr isEqualToString:@"D1"]) {//开锁
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELOpenLockreceiveMQNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D2"]) {//对时
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELOpenLockTitleMQNotification" object:nil userInfo:infDict];
                    
                } else if ([msgStr isEqualToString:@"D4"]) {//密码管理
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELLockPasswordMQNotification" object:nil userInfo:infDict];
                    
                } else if ([msgStr isEqualToString:@"D5"]) {//片管理,删除卡,删除指纹
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamilLocdDeleteCardNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D13"]) {//发卡
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamilLocCardNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D6"]) {//指纹管理
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamilFingerprintNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D7"]) {//恢复出厂设置
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamilRestoreSettingsNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D12"]) {//家庭版常开/常闭
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELLockHomeMedallionNotification" object:nil userInfo:infDict];
                    
                } else if ([msgStr isEqualToString:@"D13"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamilLocCardNotification" object:nil userInfo:infDict];
                    //D6 指纹管理
                }else  if ([msgStr isEqualToString:@"D15"]) {//升级成功失败返回
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpgradeStateNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D3"] || [msgStr isEqualToString:@"D20"]) {//酒店单个开门式设置
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELLocksecretManageMQNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D23"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpgradeNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D27"]) {//组合开门方式设置
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELLoccombinationMQNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"D28"]) {//修改秘钥时间管理
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELModifyPasswordTimeNotification" object:nil userInfo:infDict];
                } else if ([msgStr isEqualToString:@"U1"]) {//账号在别的设备登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_CHANGED object:@"logout" userInfo:infDict];
                }else if ([msgStr isEqualToString:@"D47"]) {//储物箱打开
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELOpenLockStorageBoxMQNotification" object:nil userInfo:infDict];
                }else if ([msgStr isEqualToString:@"D46"]) {//燃气阀打开
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELOpenLockGasValveMQNotification" object:nil userInfo:infDict];
                }else if ([msgStr isEqualToString:@"D52"]) {//燃气阀或储物箱,设备添加成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELAddGasValveStorageBoxMQNotification" object:nil userInfo:infDict];
                }else if ([msgStr isEqualToString:@"D45"]) {//燃气阀或储物箱,设备添加-->zib打开
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELAddGasValveStorageBoxZibOpenMQNotification" object:nil userInfo:infDict];
                }else {
                   
                }
            });
        }];
    }
}

- (void)closeConnection {
    if (self.connection != nil) {
        [self.connection close];
        self.connection = nil;
    }
}

@end
