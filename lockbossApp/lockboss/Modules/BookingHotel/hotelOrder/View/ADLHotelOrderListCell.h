//
//  ADLHotelOrderListCell.h
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM (NSInteger,ADLHotelOrderCell){
     ADLHotelOrderistCell,//订单列表
    ADLHotelOrderDetailsCell,//退款cell订单列表
    ADLHotelOrderafterSaleCell,//未支付订单售后cell
    ADLHotelOrderaPayCell,//已支付订单售后cell
};


@class ADLHotelOrderModel;
@interface ADLHotelOrderListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView hotelOrderCell:(ADLHotelOrderCell)Cell;
@property (nonatomic ,strong)ADLHotelOrderModel *model;
@property (nonatomic ,strong)void(^clicBlock)(UIButton *btn);

@property (nonatomic, assign) ADLHotelOrderCell hotelOrderCell;
@end

NS_ASSUME_NONNULL_END
