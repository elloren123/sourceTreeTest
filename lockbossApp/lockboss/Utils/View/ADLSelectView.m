//
//  ADLSelectView.m
//  lockboss
//
//  Created by adel on 2019/5/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectView.h"

@implementation ADLSelectView {
    UILabel *_moneyLab;
}

+ (instancetype)selectViewWithFrame:(CGRect)frame title:(NSString *)title buttonH:(CGFloat)buttonH {
    return [[self alloc] initWithFrame:frame title:title buttonH:buttonH];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonH:(CGFloat)buttonH {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViewWithTitle:title buttonH:buttonH];
    }
    return self;
}

- (void)setupViewWithTitle:(NSString *)title buttonH:(CGFloat)buttonH {
    CGFloat wid = self.frame.size.width;
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wid-100, buttonH)];
    [selectBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectBtn setTitle:@"   全选" forState:UIControlStateNormal];
    selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [selectBtn addTarget:self action:@selector(clickSelectAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectBtn setAdjustsImageWhenHighlighted:NO];
    [self addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    titleBtn.frame = CGRectMake(wid-100, 0, 100, buttonH);
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleBtn];
    self.titleBtn = titleBtn;
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0.5, wid-218, buttonH-1)];
    moneyLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    moneyLab.textAlignment = NSTextAlignmentRight;
    moneyLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:moneyLab];
    _moneyLab = moneyLab;

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wid, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [self addSubview:topLine];
}

#pragma mark ------ 全选 ------
- (void)clickSelectAllBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectAllBtn:)]) {
        [self.delegate didClickSelectAllBtn:sender];
    }
}

#pragma mark ------ 标题 ------
- (void)clickTitleBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTitleBtn:)]) {
        [self.delegate didClickTitleBtn:sender];
    }
}

- (void)setMoney:(NSString *)money {
    _money = money;
    _moneyLab.text = money;
    if (self.selectBtn.frame.size.width != 90) {
        CGRect frame = self.selectBtn.frame;
        frame.size.width = 90;
        self.selectBtn.frame = frame;
    }
}

@end
