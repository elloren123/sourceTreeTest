//
//  ADLStoreHeaderView.m
//  lockboss
//
//  Created by adel on 2019/4/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreHeaderView.h"
#import "ADLGlobalDefine.h"
#import "ADLBannerView.h"

@interface ADLStoreHeaderView ()
@property (nonatomic, strong) ADLBannerView *bannerView;
@end

@implementation ADLStoreHeaderView

+ (instancetype)headViewWithImageArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr title:(NSString *)title {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2+VIEW_HEIGHT*2+58) imageArr:imgArr titleArr:titleArr title:title];
}

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_F2F2F2;
        [self setupViewWithImageArr:imgArr titleArr:titleArr title:title];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)setupViewWithImageArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr title:(NSString *)title {
    CGFloat width = SCREEN_WIDTH;
    
    //轮播图
    ADLBannerView *bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, 0, width, width/2) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    [self addSubview:bannerView];
    self.bannerView = bannerView;
    
    __weak typeof(self)weakSelf = self;
    bannerView.clickBanner = ^(NSString *str) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickBannerView:)]) {
            [weakSelf.delegate didClickBannerView:str];
        }
    };
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, width/2, width, VIEW_HEIGHT+64)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnBgView];
    
    CGFloat imgS = 50;
    CGFloat gap = (width-imgS*4)/8;
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(gap+(imgS+gap*2)*(i%4), 14, imgS, imgS)];
        imgView.userInteractionEnabled = YES;
        imgView.image = [UIImage imageNamed:imgArr[i]];
        [btnBgView addSubview:imgView];
        imgView.tag = i;
        
        UILabel *imgLab = [[UILabel alloc] initWithFrame:CGRectMake(width/4*(i%4), imgS+14, width/4, VIEW_HEIGHT)];
        imgLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        imgLab.textAlignment = NSTextAlignmentCenter;
        imgLab.textColor = COLOR_333333;
        imgLab.userInteractionEnabled = YES;
        imgLab.text = titleArr[i];
        imgLab.tag = i;
        [btnBgView addSubview:imgLab];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imgView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imgLab addGestureRecognizer:tap2];
    }
    
    UIView *titView = [[UIView alloc] initWithFrame:CGRectMake(0, width/2+VIEW_HEIGHT+72, width, VIEW_HEIGHT)];
    titView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, 14, 3, VIEW_HEIGHT-28)];
    redView.backgroundColor = APP_COLOR;
    [titView addSubview:redView];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, SCREEN_WIDTH-36, VIEW_HEIGHT)];
    titLab.text = title;
    titLab.textColor = COLOR_333333;
    titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    [titView addSubview:titLab];
}

#pragma mark ------ 点击 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeadView:)]) {
        [self.delegate didClickHeadView:tap.view.tag];
    }
}

#pragma mark ------ 更新Banner ------
- (void)updateBanner:(NSArray *)bannerArr dataArr:(NSArray *)dataArr {
    [self.bannerView updateBanner:dataArr imgKey:nil urlKey:nil];
}

@end
