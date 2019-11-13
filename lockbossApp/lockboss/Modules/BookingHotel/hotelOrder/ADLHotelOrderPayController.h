//
//  ADLHotelOrderPayController.h
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"



@interface ADLHotelOrderPayController : ADLBaseViewController
@property (nonatomic ,strong)NSMutableDictionary *dict;

@property (nonatomic ,copy)NSString *roomSellOrderId;

@property (nonatomic ,assign)NSInteger payType; //1 区块链支付 2酒店预订支付 3未支付订单
@end


