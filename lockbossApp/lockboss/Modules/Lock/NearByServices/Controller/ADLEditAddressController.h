//
//  ADLEditAddressController.h
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLEditAddressController : ADLBaseViewController

@property (nonatomic, assign) BOOL                addNewAddressFlag;    //添加地址标志: yes
@property (nonatomic, strong) NSMutableDictionary *addrDict;

@property (nonatomic, copy) void(^finishedAddAddrBlock) (NSString *address, BOOL genderFalg, NSString *contactName, NSString *phoneNumber);

@end

NS_ASSUME_NONNULL_END
