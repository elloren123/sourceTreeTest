//
//  ADLGoodsEvaluateView.h
//  lockboss
//
//  Created by adel on 2019/7/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLGoodsEvaluateViewDelegate <NSObject>

- (void)didClickEvaluateViewLikeBtn:(NSMutableDictionary *)dict;

- (void)didClickEvaluateViewCell:(NSMutableDictionary *)evaDict index:(NSInteger)index;

- (void)evaluatePushLoginController;

@end

@interface ADLGoodsEvaluateView : UIView

- (instancetype)initWithFrame:(CGRect)frame goodsId:(NSString *)goodsId;

- (void)updateEvaluateData:(NSMutableDictionary *)dict index:(NSInteger)index;

- (void)updateEvaluateData;

@property (nonatomic, weak) id<ADLGoodsEvaluateViewDelegate> delegate;

@end
