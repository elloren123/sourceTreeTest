//
//  ADLAddressPickerView.h
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLAddressPickerView : UIView

/**
 选择地址

 @param dataArr 城市数据
 @param level 选择级别，最高4级，最低1级
 @param finish 完成的回调
 @return 地址选择器
 */
+ (instancetype)showWithArray:(NSArray *)dataArr level:(NSInteger)level finish:(void(^)(NSString *address, NSString *addressId))finish;

@end
