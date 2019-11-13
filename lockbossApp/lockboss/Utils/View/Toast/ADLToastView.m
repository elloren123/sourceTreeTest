//
//  ADLToastView.m
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLToastView.h"
#import "ADLGlobalDefine.h"

@interface ADLToastView ()
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

#define MARGIN_H 12
#define MARGIN_V 12
#define MARGIN_C 10

@implementation ADLToastView

+ (instancetype)toastViewWithLightMode:(BOOL)lightMode {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) lightMode:lightMode];
}

- (instancetype)initWithFrame:(CGRect)frame lightMode:(BOOL)lightMode {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViewsWithLightMode:lightMode];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)setupSubViewsWithLightMode:(BOOL)lightMode {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 6;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.numberOfLines = 0;
    [contentView addSubview:textLab];
    self.textLab = textLab;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    indicatorView.hidden = YES;
    [contentView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    if (lightMode) {
        textLab.textColor = [UIColor blackColor];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    } else {
        textLab.textColor = [UIColor whiteColor];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
}

#pragma mark ------ 显示 ------
- (void)show {
    CGSize textSize = CGSizeZero;
    if (self.contentText.length > 0) {
        textSize = [self.contentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-MARGIN_H*2-60, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    }
    
    if (self.type == ADLToastTypeText) {
        self.userInteractionEnabled = NO;
        if (self.indicatorView.hidden == NO) {
            self.indicatorView.hidden = YES;
            [self.indicatorView stopAnimating];
        }
        self.textLab.text = self.contentText;
        self.textLab.frame = CGRectMake(MARGIN_H, MARGIN_V, textSize.width, textSize.height);
        CGFloat contentY = (SCREEN_HEIGHT-textSize.height-MARGIN_V*2)/2;
        if (self.bottomGap > 0) {
            contentY = SCREEN_HEIGHT-textSize.height-MARGIN_V*2-self.bottomGap;
        }
        self.contentView.frame = CGRectMake((SCREEN_WIDTH-textSize.width-MARGIN_H*2)/2, contentY, textSize.width+MARGIN_H*2, textSize.height+MARGIN_V*2);
    } else {
        self.userInteractionEnabled = YES;
        if (self.indicatorView.hidden == YES) {
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
        }
        
        self.textLab.text = self.contentText;
        if (textSize.width < 28) {
            textSize.width = 28;
        }
        
        self.indicatorView.center = CGPointMake(textSize.width/2+MARGIN_H, MARGIN_V+14);
        self.textLab.frame = CGRectMake(MARGIN_H, MARGIN_V+28+MARGIN_C, textSize.width, textSize.height);
        self.contentView.frame = CGRectMake((SCREEN_WIDTH-MARGIN_H*2-textSize.width)/2, (SCREEN_HEIGHT-MARGIN_V*2-28-MARGIN_C-textSize.height)/2, textSize.width+MARGIN_H*2, 28+MARGIN_V*2+MARGIN_C+textSize.height);
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![self isDescendantOfView:window]) {
        [window addSubview:self];
    }
}

#pragma mark ------ 隐藏 ------
- (void)hide {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![self isDescendantOfView:window]) return;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.indicatorView.animating) {
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
        }
        [self removeFromSuperview];
    }];
}

@end
