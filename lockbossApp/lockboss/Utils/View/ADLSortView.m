//
//  ADLTransformView.m
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSortView.h"
#import "ADLGlobalDefine.h"

@interface ADLSortView ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *titleBtnArr;
@property (nonatomic, strong) NSMutableArray *upArr;
@property (nonatomic, strong) NSMutableArray *downArr;
@end

@implementation ADLSortView

+ (instancetype)sortViewWithFrame:(CGRect)frame titles:(NSArray *)titleArr {
    return [[self alloc] initWithFrame:frame titles:titleArr];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleArr = titleArr;
        [self initializationViews];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationViews {
    if (self.titleArr.count == 0) return;
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    self.upArr = [[NSMutableArray alloc] init];
    self.downArr = [[NSMutableArray alloc] init];
    self.titleBtnArr = [[NSMutableArray alloc] init];
    
    NSInteger titleCount = self.titleArr.count;
    CGFloat btnW = wid/titleCount;
    for (int i = 0; i < titleCount; i++) {
        NSString *title = self.titleArr[i];
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake((i%titleCount)*btnW, 0, btnW, hei)];
        [titleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.clipsToBounds = YES;
        titleBtn.tag = i;
        [self addSubview:titleBtn];
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        
        CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, hei) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.width;
        
        UIImageView *upImgView = [[UIImageView alloc] initWithFrame:CGRectMake((btnW+titleW)/2+1, hei/2-4, 5, 3)];
        upImgView.image = [UIImage imageNamed:@"act_up_normal"];
        [titleBtn addSubview:upImgView];
        
        UIImageView *downImgView = [[UIImageView alloc] initWithFrame:CGRectMake((btnW+titleW)/2+1, hei/2+1, 5, 3)];
        downImgView.image = [UIImage imageNamed:@"act_down_normal"];
        [titleBtn addSubview:downImgView];
        [_upArr addObject:upImgView];
        [_downArr addObject:downImgView];
        [_titleBtnArr addObject:titleBtn];
        
        if (i == 0) {
            [titleBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
            downImgView.image = [UIImage imageNamed:@"act_down_select"];
            titleBtn.selected = YES;
        }
    }
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, hei-0.5, wid, 0.5)];
    divisionView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:divisionView];
    self.divisionView = divisionView;
}

#pragma mark ------ 点击 ------
- (void)clickTitleBtn:(UIButton *)sender {
    if ([self.sortArr containsObject:@(sender.tag)]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTitle:ascending:)]) {
            [self.delegate didClickTitle:sender.tag ascending:sender.selected];
        }
    } else {
        if (!sender.selected) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTitle:ascending:)]) {
                [self.delegate didClickTitle:sender.tag ascending:NO];
            }
        }
    }
}

#pragma mark ------ 更新状态 ------
- (void)updateTitleWithIndex:(NSInteger)index ascending:(BOOL)ascending {
    [self.titleBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = !ascending;
            [obj setTitleColor:APP_COLOR forState:UIControlStateNormal];
        } else {
            obj.selected = NO;
            [obj setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
    }];
    if (ascending) {
        [self.upArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (index == idx) {
                imageView.image = [UIImage imageNamed:@"act_up_select"];
            } else {
                imageView.image = [UIImage imageNamed:@"act_up_normal"];
            }
        }];
        
        [self.downArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            imageView.image = [UIImage imageNamed:@"act_down_normal"];
        }];
        
    } else {
        [self.downArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (index == idx) {
                imageView.image = [UIImage imageNamed:@"act_down_select"];
            } else {
                imageView.image = [UIImage imageNamed:@"act_down_normal"];
            }
        }];
        
        [self.upArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            imageView.image = [UIImage imageNamed:@"act_up_normal"];
        }];
    }
}


- (void)setSortArr:(NSArray *)sortArr {
    _sortArr = sortArr;
    for (int index = 0; index < self.titleArr.count; index++) {
        [self.upArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sortArr containsObject:@(idx)]) {
                imageView.hidden = NO;
            } else {
                imageView.hidden = YES;
            }
        }];
        
        [self.downArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sortArr containsObject:@(idx)]) {
                imageView.hidden = NO;
            } else {
                imageView.hidden = YES;
            }
        }];
    }
}

@end
