//
//  ADLTitleView.m
//  lockboss
//
//  Created by adel on 2019/4/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTitleView.h"
#import "ADLGlobalDefine.h"

@interface ADLTitleView ()
@property (nonatomic, strong) NSMutableArray *titleWArr;
@property (nonatomic, strong) NSMutableArray *titleBtnArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicateView;
@end

@implementation ADLTitleView

+ (instancetype)titleViewWithFrame:(CGRect)frame titles:(NSArray *)titleArr {
    return [[self alloc] initWithFrame:frame titles:titleArr];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        [self initializationWithTitles:titleArr];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationWithTitles:(NSArray *)titleArr {
    if (titleArr.count == 0) return;
    self.backgroundColor = [UIColor whiteColor];
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    self.titleWArr = [[NSMutableArray alloc] init];
    self.titleBtnArr = [[NSMutableArray alloc] init];
    CGFloat totalW = 24;
    CGFloat gap = 30;
    NSInteger titleCount = titleArr.count;
    for (int i = 0; i < titleCount; i++) {
        NSString *title = titleArr[i];
        CGFloat singleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, hei) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.width;
        totalW = totalW+singleW+gap;
        [self.titleWArr addObject:@(singleW)];
    }
    BOOL scroll = YES;
    if (totalW < SCREEN_WIDTH) {
        scroll = NO;
    }
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, hei-0.5, wid, 0.5)];
    divisionView.backgroundColor = SEPARATOR_COLOR;
    self.divisionView = divisionView;
    
    UIView *indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.titleWArr[0] floatValue]+12, 2)];
    indicateView.backgroundColor = APP_COLOR;
    indicateView.layer.cornerRadius = 1;
    self.indicateView = indicateView;
    
    if (scroll) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wid, hei)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(totalW-15, 0);
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        CGFloat originalX = 12;
        for (int i = 0; i < titleCount; i++) {
            UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX, 0, [self.titleWArr[i] floatValue]+2, hei)];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
            [titleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            [titleBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
            [titleBtn addTarget:self action:@selector(clcikTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:titleBtn];
            [self.titleBtnArr addObject:titleBtn];
            originalX = originalX+[self.titleWArr[i] floatValue]+gap;
            titleBtn.tag = i;
            if (i == 0) {
                titleBtn.selected = YES;
                indicateView.center = CGPointMake(titleBtn.center.x, hei-1);
            }
        }
        [self addSubview:divisionView];
        [scrollView addSubview:indicateView];
    } else {
        CGFloat titleW = wid/titleCount;
        for (int i = 0; i < titleCount; i++) {
            UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleW*(i%titleCount), 0, titleW, hei)];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
            [titleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            [titleBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
            [titleBtn addTarget:self action:@selector(clcikTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn];
            [self.titleBtnArr addObject:titleBtn];
            titleBtn.tag = i;
            if (i == 0) {
                titleBtn.selected = YES;
                indicateView.center = CGPointMake(titleBtn.center.x, hei-1);
            }
        }
        [self addSubview:divisionView];
        [self addSubview:indicateView];
    }
}

#pragma mark ------ 点击标题 ------
- (void)clcikTitleButton:(UIButton *)sender {
    if (sender.selected) return;
    [self updateIndicateViewFrame:sender];
    [self.titleBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
    
    if (self.scrollView) {
        CGFloat offsetX = sender.center.x-CGRectGetWidth(self.scrollView.frame)*0.5;
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.scrollView.contentSize.width-CGRectGetWidth(self.scrollView.frame);
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    if (self.clickTitle) {
        self.clickTitle(sender.tag);
    }
}

#pragma mark ------ 更新单个标题 ------
- (void)updateTitle:(NSString *)title index:(NSInteger)index; {
    if (index < self.titleBtnArr.count) {
        UIButton *btn = self.titleBtnArr[index];
        [btn setTitle:title forState:UIControlStateNormal];
        CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.width;
        [self.titleWArr replaceObjectAtIndex:index withObject:@(titleW)];
        if (btn.selected) {
            [self updateIndicateViewFrame:btn];
        }
    }
}

#pragma mark ------ 更新所有标题 ------
- (void)updateTitleWithArray:(NSArray *)titleArr {
    if (titleArr.count == self.titleBtnArr.count) {
        for (int i = 0; i < self.titleBtnArr.count; i++) {
            UIButton *btn = self.titleBtnArr[i];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            CGFloat titleW = [titleArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.width;
            [self.titleWArr replaceObjectAtIndex:i withObject:@(titleW)];
            if (btn.selected) {
                [self updateIndicateViewFrame:btn];
            }
        }
    }
}

#pragma mark ------ 设置选中 ------
- (void)selectTitleWithIndex:(NSInteger)index {
    if (index > self.titleBtnArr.count-1) return;
    UIButton *btn = self.titleBtnArr[index];
    if (!btn.selected) {
        [self.titleBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        btn.selected = YES;
        [self updateIndicateViewFrame:btn];
    }
}

#pragma mark ------ 更新IndicateView Frame ------
- (void)updateIndicateViewFrame:(UIButton *)sender {
    CGRect frame = self.indicateView.frame;
    //这里不考虑按钮标题宽大于按钮宽的问题
    frame.size.width = [self.titleWArr[sender.tag] floatValue]+12;
    frame.origin.x = sender.center.x-frame.size.width/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.indicateView.frame = frame;
    }];
}

@end
