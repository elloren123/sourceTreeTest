//
//  ADLDinnerListController.h
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLDinnerListController : ADLBaseViewController

@property (nonatomic, copy) NSString *storeId;     //商家Id
@property (nonatomic, copy) NSString *vcTitle;     //商家名
@property (nonatomic, copy) NSString *stoImgUrl;   //商家照片url
@property (nonatomic, copy) NSString *businessStatus;   //营业状态(0:正在营业，1:未营业)"

@end

NS_ASSUME_NONNULL_END
