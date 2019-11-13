//
//  ADLPayViewController.h  //支付订单vc
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLPayViewController : ADLBaseViewController

@property (nonatomic, copy) NSString   *stoImgUrl;              //商家照片url
@property (nonatomic,   copy) NSString *storeId;                //商家Id
@property (nonatomic,   copy) NSString *shopName;               //商家名
@property (nonatomic,   copy) NSString *sendBill;               //配送费
@property (nonatomic,   copy) NSString *totalMoney;             //订单总金额
@property (nonatomic, strong) NSMutableDictionary *orderDict;   //订单附加信息
@property (nonatomic,   copy) NSString *storeLocation; //商家位置经纬度:('经度,纬度'组合的字串)
@property (nonatomic, assign) BOOL     FromOrdersVCFlag;    //从'我的订单'界面跳转标志

@end

NS_ASSUME_NONNULL_END
