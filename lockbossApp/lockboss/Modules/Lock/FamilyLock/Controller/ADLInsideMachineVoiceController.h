//
//  ADLInsideMachineVoiceController.h
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
/*
 居里富人音量vc
 */

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLInsideMachineVoiceController : ADLBaseViewController

@property (nonatomic,   copy) NSString *deviceId;
@property (nonatomic,   copy) NSString *deviceCode;
@property (nonatomic, assign) CGFloat  volumeValue;   //音量值

@end

NS_ASSUME_NONNULL_END
