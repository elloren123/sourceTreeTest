//
//  ADLSearchNewsView.m
//  lockboss
//
//  Created by adel on 2019/3/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLHomeSearchView.h"
#import "ADLGlobalDefine.h"

@interface ADLHomeSearchView ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ADLHomeSearchView

+ (instancetype)searchViewWithFrame:(CGRect)frame delegate:(id)delegate {
    return [[self alloc] initWithFrame:frame delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        [self setupWithStatusHeight:STATUS_HEIGHT];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)setupWithStatusHeight:(CGFloat)height {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height-height;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, wid, hei)];
    [self addSubview:contentView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (hei-24)/2, 49, 24)];
    logoView.image = [UIImage imageNamed:@"home_sld"];
    [contentView addSubview:logoView];
    self.logoView = logoView;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(73, 6, wid-119, hei-12)];
    bgView.backgroundColor = COLOR_F2F2F2;
    bgView.layer.cornerRadius = 5;
    [contentView addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchView)];
    [bgView addGestureRecognizer:tap];
    
    UIImageView *shView = [[UIImageView alloc] initWithFrame:CGRectMake(8, hei/2-14, 16, 16)];
    shView.image = [UIImage imageNamed:@"home_search"];
    [bgView addSubview:shView];
    
    UILabel *phLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 150, hei-12)];
    phLabel.text = @"输入您要的商品名称";
    phLabel.clipsToBounds = YES;
    phLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    phLabel.textColor = PLACEHOLDER_COLOR;
    [bgView addSubview:phLabel];
    self.phLabel = phLabel;
    
    UIButton *newsBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-46, 0, 46, hei)];
    [newsBtn setImage:[UIImage imageNamed:@"home_news"] forState:UIControlStateNormal];
    newsBtn.imageEdgeInsets = UIEdgeInsetsMake((hei-19)/2, 12, (hei-19)/2, 12);
    [newsBtn addTarget:self action:@selector(clickNewsBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:newsBtn];
    self.newsBtn  = newsBtn;
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(wid-16, (hei-19)/2-3, 7, 7)];
    pointView.backgroundColor = APP_COLOR;
    pointView.layer.cornerRadius = 3.5;
    [contentView addSubview:pointView];
    pointView.hidden = YES;
    self.pointView = pointView;
}

#pragma mark ------ 隐藏Logo ------
- (void)hideLogo {
    if (self.logoView.hidden == NO) {
        self.logoView.hidden = YES;
        
        CGRect bgF = self.bgView.frame;
        bgF.origin.x = 40;
        bgF.size.width = SCREEN_WIDTH-86;
        self.bgView.frame = bgF;
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, 40, NAV_H)];
        [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [self addSubview:backBtn];
    }
}

#pragma mark ------ 返回 ------
- (void)clickBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackBtn)]) {
        [self.delegate didClickBackBtn];
    }
}

#pragma mark ------ 点击搜索框 ------
- (void)clickSearchView {
    /*其实只用判断[self.delegate respondsToSelector:@selector(didClickHomeSearchView:)]就可以
     如果self.delegate为nil,则[self.delegate respondsToSelector:@selector(didClickHomeSearchView:)]
     返回NO，也不会调用代理方法，甚至代理控制器可以不遵循协议，只用实现对应代理方法也是完全没问题的
     只要确定实现了代理方法，这里不判断也是没问题的，这样写只是更严谨一些
     */
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeSearchView:)]) {
        [self.delegate didClickHomeSearchView:0];
    }
}

#pragma mark ------ 点击消息 ------
- (void)clickNewsBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeSearchView:)]) {
        [self.delegate didClickHomeSearchView:1];
    }
}

@end
