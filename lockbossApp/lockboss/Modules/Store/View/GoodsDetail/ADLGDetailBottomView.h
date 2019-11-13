//
//  ADLGDetailBottomView.h
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLGDetailBottomViewDelegate <NSObject>

- (void)didClickCustomerService;

- (void)didClickCollection:(BOOL)collection;

- (void)didClickShoppingCar;

- (void)didClickAddShoppingCar;

- (void)didClickBuyNow;

@end

@interface ADLGDetailBottomView : UIView

+ (instancetype)bottomViewWithCollection:(BOOL)collection;

- (instancetype)initWithCollection:(BOOL)collection;

- (void)updateCollectionStatus:(BOOL)collection;

@property (nonatomic, weak) id<ADLGDetailBottomViewDelegate> delegate;

@property (nonatomic, strong) UIView *collectView;

@property (nonatomic, strong) UIImageView *collectImgView;

@property (nonatomic, strong) UILabel *collectLab;

@end
