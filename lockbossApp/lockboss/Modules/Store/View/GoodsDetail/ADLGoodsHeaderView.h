//
//  ADLGoodsHeaderView.h
//  lockboss
//
//  Created by Han on 2019/7/21.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ADLGoodsHeaderViewDelegate <NSObject>

- (void)didClickAttributeBtn;

- (void)didClickAddressBtn:(BOOL)add;

- (void)didClickLookEvaluateBtn;

- (void)didClickRelevantGoods:(NSString *)goodsId;

- (void)didClickEvaluateLikeBtn:(NSMutableDictionary *)evaDict index:(NSInteger)index;

- (void)didClickEvaluateCell:(NSMutableDictionary *)evaDict index:(NSInteger)index;

@end

@interface ADLGoodsHeaderView : UIView

///初始化
+ (instancetype)headerViewWithHeight:(CGFloat)height imgUrls:(NSArray *)imgUrls activity:(BOOL)activity;

///初始化
- (instancetype)initWithHeight:(CGFloat)height imgUrls:(NSArray *)imgUrls activity:(BOOL)activity;

///代理属性
@property (nonatomic, weak) id<ADLGoodsHeaderViewDelegate> delegate;

///活动结束的时间戳
@property (nonatomic, assign) double timestamp;

///更新商品名称
- (void)updateGoodsName:(NSString *)goodsName goodsTitle:(NSString *)goodsTitle;

///更新价格、库存
- (void)updatePrice:(double)price money:(double)money inventory:(NSString *)inventory;

///活动商品是否开始更新时间
- (void)updateActivityGoodsTime:(BOOL)update;

///更新属性视图
- (void)updateSelectAttribute:(NSString *)attribute;

///更新收货地址
- (void)updateShipAddress:(NSString *)address;

///更新评价数量
- (void)updateEvaluateCount:(NSDictionary *)dict;

///更新评价内容
- (void)updateEvaluateInfWithEvaluateArr:(NSMutableArray *)evaArr heiArr:(NSArray *)heiArr;

///更新评论点赞回复状态
- (void)updateEvaluateStatus:(NSMutableDictionary *)dict index:(NSInteger)index;

///更新评价数据
- (void)updateEvaluateData:(NSMutableDictionary *)dict;

///更新推荐商品
- (void)updateRelevantGoods:(NSArray *)goodsArr;

@end

