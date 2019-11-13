//
//  ADLGDetailBottomView.m
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGDetailBottomView.h"
#import "ADLGlobalDefine.h"

@implementation ADLGDetailBottomView

+ (instancetype)bottomViewWithCollection:(BOOL)collection {
    return [[self alloc] initWithCollection:collection];
}

- (instancetype)initWithCollection:(BOOL)collection {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *csView = [[UIView alloc] init];
        [self addSubview:csView];
        UITapGestureRecognizer *csTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCustomerServiceView)];
        [csView addGestureRecognizer:csTap];
        
        UIImageView *csImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7, 17, 16)];
        csImgView.image = [UIImage imageNamed:@"customer_service"];
        [csView addSubview:csImgView];
        
        UILabel *csLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 49, 17)];
        csLab.font = [UIFont systemFontOfSize:12];
        csLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        csLab.textAlignment = NSTextAlignmentCenter;
        csLab.text = @"客服";
        [csView addSubview:csLab];
        
        UIView *collectView = [[UIView alloc] init];
        [self addSubview:collectView];
        UITapGestureRecognizer *collectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCollectView:)];
        [collectView addGestureRecognizer:collectTap];
        self.collectView = collectView;
        
        UIImageView *collectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7, 17, 16)];
        [collectView addSubview:collectImgView];
        self.collectImgView = collectImgView;
        
        UILabel *collectLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 49, 17)];
        collectLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        collectLab.textAlignment = NSTextAlignmentCenter;
        collectLab.font = [UIFont systemFontOfSize:12];
        [collectView addSubview:collectLab];
        self.collectLab = collectLab;
        
        if (collection) {
            collectImgView.image = [UIImage imageNamed:@"goods_collect_select"];
            collectLab.text = @"已收藏";
            collectView.tag = 1;
        } else {
            collectImgView.image = [UIImage imageNamed:@"goods_collect_normal"];
            collectLab.text = @"收藏";
            collectView.tag = 0;
        }
        
        UIView *carView = [[UIView alloc] init];
        [self addSubview:carView];
        UITapGestureRecognizer *carTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCarView)];
        [carView addGestureRecognizer:carTap];
        
        UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7, 17, 16)];
        carImgView.image = [UIImage imageNamed:@"nav_car"];
        [carView addSubview:carImgView];
        
        UILabel *carLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 49, 17)];
        carLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        carLab.textAlignment = NSTextAlignmentCenter;
        carLab.font = [UIFont systemFontOfSize:12];
        carLab.text = @"购物车";
        [carView addSubview:carLab];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self addSubview:topView];
        
        UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [carBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [carBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [carBtn addTarget:self action:@selector(clickAddShoppingCarBtn) forControlEvents:UIControlEventTouchUpInside];
        carBtn.backgroundColor = [UIColor colorWithRed:1 green:187/255.0 blue:51/255.0 alpha:1];
        [self addSubview:carBtn];
        
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(clickBuyNowBtn) forControlEvents:UIControlEventTouchUpInside];
        buyBtn.backgroundColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1];
        [self addSubview:buyBtn];
        
        if (SCREEN_WIDTH < 350) {
            csView.frame = CGRectMake(0, 0, 49, 50);
            collectView.frame = CGRectMake(50, 0, 49, 50);
            carView.frame = CGRectMake(100, 0, 49, 50);
            carBtn.frame = CGRectMake(SCREEN_WIDTH-170, 0, 85, 50);
            carBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            buyBtn.frame = CGRectMake(SCREEN_WIDTH-85, 0, 85, 50);
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        } else if (SCREEN_WIDTH < 400) {
            CGFloat gap = (SCREEN_WIDTH-359)/4;
            csView.frame = CGRectMake(0, 0, 49, 50);
            collectView.frame = CGRectMake(50+gap, 0, 49, 50);
            carView.frame = CGRectMake(100+gap*2, 0, 49, 50);
            carBtn.frame = CGRectMake(SCREEN_WIDTH-212, 0, 106, 50);
            carBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            buyBtn.frame = CGRectMake(SCREEN_WIDTH-106, 0, 106, 50);
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (SCREEN_WIDTH < 500) {
            CGFloat gap = (SCREEN_WIDTH-371)/4;
            csView.frame = CGRectMake(0, 0, 49, 50);
            collectView.frame = CGRectMake(50+gap, 0, 49, 50);
            carView.frame = CGRectMake(100+gap*2, 0, 49, 50);
            carBtn.frame = CGRectMake(SCREEN_WIDTH-224, 0, 112, 50);
            carBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            buyBtn.frame = CGRectMake(SCREEN_WIDTH-112, 0, 112, 50);
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        } else {
            csView.frame = CGRectMake(20, 0, 49, 50);
            collectView.frame = CGRectMake(90, 0, 49, 50);
            carView.frame = CGRectMake(160, 0, 49, 50);
            carBtn.frame = CGRectMake(SCREEN_WIDTH-280, 0, 140, 50);
            carBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            buyBtn.frame = CGRectMake(SCREEN_WIDTH-140, 0, 140, 50);
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    return self;
}

#pragma mark ------ 更新收藏状态 ------
- (void)updateCollectionStatus:(BOOL)collection {
    if (collection) {
        self.collectImgView.image = [UIImage imageNamed:@"goods_collect_select"];
        self.collectLab.text = @"已收藏";
        self.collectView.tag = 1;
    } else {
        self.collectImgView.image = [UIImage imageNamed:@"goods_collect_normal"];
        self.collectLab.text = @"收藏";
        self.collectView.tag = 0;
    }
}

#pragma mark ------ 客服 ------
- (void)clickCustomerServiceView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCustomerService)]) {
        [self.delegate didClickCustomerService];
    }
}

#pragma mark ------ 收藏 ------
- (void)clickCollectView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCollection:)]) {
        [self.delegate didClickCollection:tap.view.tag];
    }
}

#pragma mark ------ 购物车 ------
- (void)clickCarView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShoppingCar)]) {
        [self.delegate didClickShoppingCar];
    }
}

#pragma mark ------ 加入购物车 ------
- (void)clickAddShoppingCarBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddShoppingCar)]) {
        [self.delegate didClickAddShoppingCar];
    }
}

#pragma mark ------ 立即购买 ------
- (void)clickBuyNowBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBuyNow)]) {
        [self.delegate didClickBuyNow];
    }
}

@end
