//
//  ADLBlockchainQueryView.h
//  ADEL-APP
//
//  Created by adel on 2019/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADLBlockchainpriceModel;

@interface ADLBlockchainQueryView : UIView

@property (nonatomic ,weak)UITextField *dataField;//数量

@property (nonatomic ,weak)UILabel *priceLabel;//原价
@property (nonatomic ,strong)UILabel *preferential;//优惠价
@property (nonatomic ,weak)UILabel *preferentialLabel;//优惠后价 最后成交价


@property (nonatomic ,weak)UIButton *startBtn;//开始时间
@property (nonatomic ,weak)UIButton *endBtn;//结束时间

@property (nonatomic ,copy)void(^blockdate)(UIButton*btn);

@property (nonatomic ,copy)void(^blockTime)(UIButton*btn);

@property (nonatomic , assign)CGFloat price;//原单价
@property (nonatomic , assign)CGFloat discountsPrice;//优惠单价

@property (nonatomic , assign)NSInteger buyUnit;// 购买单位 1：天，2：周，3：月，4：季，5：年    ，6：永久
@property (nonatomic , assign)NSInteger giveNum;//赠送数量
@property (nonatomic , assign)NSInteger giveUnit;//赠送单位 1：天，2：周，3：月，4：季，5：年    ，6：永久

@property (nonatomic ,strong)  ADLBlockchainpriceModel *model;

@end

NS_ASSUME_NONNULL_END
