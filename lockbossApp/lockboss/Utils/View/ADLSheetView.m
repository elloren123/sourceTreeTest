//
//  ADLSheetView.m
//  lockboss
//
//  Created by Han on 2019/4/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSheetView.h"
#import "ADLGlobalDefine.h"
#import "ADLLocalizedHelper.h"

@interface ADLSheetView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSMutableArray *blockArr;
@property (nonatomic, assign) CGFloat sheetH;
@property (nonatomic, assign) CGFloat titleH;
@property (nonatomic, assign) CGFloat bottomH;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ADLSheetView

+ (instancetype)sheetViewWithTitle:(NSString *)title {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        [self initializationWithTitle:title];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationWithTitle:(NSString *)title {
    self.blockArr = [[NSMutableArray alloc] init];
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    [self addSubview:coverView];
    self.coverView = coverView;
    coverView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancleBtn)];
    [coverView addGestureRecognizer:tap];
    
    UIView *sheetView = [[UIView alloc] init];
    [self addSubview:sheetView];
    self.sheetView = sheetView;
    
    UIView *actionView = [[UIView alloc] init];
    actionView.backgroundColor = [UIColor whiteColor];
    actionView.layer.cornerRadius = 12;
    actionView.clipsToBounds = YES;
    [sheetView addSubview:actionView];
    self.actionView = actionView;
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn setTitle:ADLString(@"cancle") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:COLOR_0083FD forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.layer.cornerRadius = 12;
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [sheetView addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    
    CGFloat bottomH = BOTTOM_H+9;
    self.bottomH = bottomH;
    if (title != nil) {
        //这里不考虑title过长或添加Action过多超出屏幕的问题，开发中一般不会遇到
        CGFloat titleH = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-50, titleH+28)];
        titleLab.textColor = [UIColor colorWithWhite:0.56 alpha:1];
        titleLab.font = [UIFont boldSystemFontOfSize:13];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.numberOfLines = 0;
        titleLab.text = title;
        [actionView addSubview:titleLab];
        self.sheetH = titleH+bottomH+94;
        self.titleH = titleH+28;
    } else {
        self.sheetH = bottomH+66;
        self.titleH = 0;
    }
    self.index = 0;
}

#pragma mark ------ 添加Action ------
- (void)addActionWithTitle:(NSString *)title handler:(void (^)(void))handler {
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actionBtn.frame = CGRectMake(12, self.index*57+self.titleH, SCREEN_WIDTH-42, 57);
    [actionBtn setTitle:title forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_0083FD forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    actionBtn.backgroundColor = [UIColor whiteColor];
    actionBtn.layer.cornerRadius = 12;
    actionBtn.tag = self.index;
    actionBtn.titleLabel.minimumScaleFactor = 0.6;
    actionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [actionBtn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:actionBtn];
    if (handler) {
        [self.blockArr addObject:handler];
    } else {
        void (^block)(void) = ^{};
        [self.blockArr addObject:block];
    }
    if (self.titleH != 0 || self.index != 0) {
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, self.index*57+self.titleH, SCREEN_WIDTH-18, 0.5)];
        spView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [self.actionView addSubview:spView];
    }
    self.sheetH += 57;
    self.index++;
}

#pragma mark ------ 显示 ------
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

    self.sheetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.sheetH);
    self.actionView.frame = CGRectMake(9, 0, SCREEN_WIDTH-18, self.sheetH-self.bottomH-66);
    self.cancleBtn.frame = CGRectMake(9, self.sheetH-self.bottomH-57, SCREEN_WIDTH-18, 57);
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.5;
        self.sheetView.frame = CGRectMake(0, SCREEN_HEIGHT-self.sheetH, SCREEN_WIDTH, self.sheetH);
    }];
}

#pragma mark ------ Action ------
- (void)clickActionBtn:(UIButton *)sender {
    [self clickCancleBtn];
    void (^handler)(void) = self.blockArr[sender.tag];
    if (handler) {
        handler();
    }
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    CGRect frame = self.sheetView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = frame;
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
