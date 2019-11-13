//
//  ADLSwitchDeviceView.h
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLDeviceModel;

@interface ADLSwitchDeviceView : UIView

+ (instancetype)showWithFamilyDevice:(BOOL)family finish:(void(^)(ADLDeviceModel *model))finish;

@end
