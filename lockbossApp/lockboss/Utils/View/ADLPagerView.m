//
//  ADLPagerView.m
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPagerView.h"
#import "ADLGlobalDefine.h"

@interface ADLPagerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *titleBtnArr;
@property (nonatomic, strong) NSMutableArray *titleWArr;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat per;
@end

@implementation ADLPagerView

+ (instancetype)pagerViewWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views {
    return [[self alloc] initWithFrame:frame views:views];
}

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views {
    if (self = [super initWithFrame:frame]) {
        self.viewsArr = views;
    }
    return self;
}

#pragma mark ------ 添加标题 ------
- (void)addTitles:(NSArray *)titleArr titleSize:(CGSize)titleSize statusH:(CGFloat)statusH fontSize:(CGFloat)fontSize {
    if (self.viewsArr.count == 0 || titleArr.count == 0) return;
    if (self.viewsArr.count != titleArr.count) return;
    CGFloat titleH = titleSize.height;
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    self.titleWArr = [[NSMutableArray alloc] init];
    self.titleBtnArr = [[NSMutableArray alloc] init];
    
    NSInteger titleCount = titleArr.count;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wid, titleH+statusH)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    self.titleView = titleView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleH+statusH, wid, hei-titleH-statusH)];
    scrollView.contentSize = CGSizeMake(wid*titleCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int i = 0; i < titleArr.count; i++) {
        NSString *title = titleArr[i];
        CGFloat singleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
        [self.titleWArr addObject:@(singleW)];
    }
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH+statusH-0.5, wid, 0.5)];
    divisionView.backgroundColor = SEPARATOR_COLOR;
    [titleView addSubview:divisionView];
    self.divisionView = divisionView;
    
    UIView *indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.titleWArr[0] floatValue]+12, 2)];
    indicateView.backgroundColor = APP_COLOR;
    indicateView.layer.cornerRadius = 1;
    self.indicateView = indicateView;
    
    CGFloat titleW = titleSize.width/titleCount;
    CGFloat originalX = (wid-titleSize.width)/2;
    for (int i = 0; i < titleCount; i++) {
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX+(i%titleCount)*titleW, statusH, titleW, titleH)];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [titleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(clcikTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleBtn];
        [self.titleBtnArr addObject:titleBtn];
        titleBtn.tag = i;
        if (i == 0) {
            titleBtn.userInteractionEnabled = NO;
            [titleBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
            indicateView.center = CGPointMake(titleBtn.center.x, titleH+statusH-1);
        }
        
        UIView *view = self.viewsArr[i];
        view.frame = CGRectMake(wid*i, 0, wid, hei-titleH-statusH);
        [scrollView addSubview:view];
    }
    [titleView addSubview:indicateView];
}

#pragma mark ------ 点击标题 ------
- (void)clcikTitleButton:(UIButton *)sender {
    UIButton *btn = self.titleBtnArr[self.index];
    [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [sender setTitleColor:APP_COLOR forState:UIControlStateNormal];
    self.index = sender.tag;
    self.per = -1;
    CGRect frame = self.indicateView.frame;
    frame.size.width = [self.titleWArr[self.index] floatValue]+12;
    frame.origin.x = sender.center.x-frame.size.width/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.indicateView.frame = frame;
    }];
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*sender.tag, 0) animated:YES];
    [self updateTitleState:sender.tag];
}

#pragma mark ------ ScrollView Delegate ------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = scrollView.contentOffset.x/self.frame.size.width;
    [self updateTitleState:self.index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.per >= 0) {
        CGFloat per = scrollView.contentOffset.x/self.frame.size.width;
        CGFloat progress = per-self.per;
        if (progress < 0) {
            NSInteger index = ceil(per);
            if (index == 0 || progress == -1) return;
            progress = fabs(index-per);
            UIButton *btn1 = self.titleBtnArr[index];
            UIButton *btn2 = self.titleBtnArr[index-1];
            if (!self.hideIndicateLine) {
                CGFloat fromFrameX = btn1.center.x-([self.titleWArr[index] floatValue]+12)/2;
                CGFloat toFrameX = btn2.center.x-([self.titleWArr[index-1] floatValue]+12)/2;
                CGFloat fromWidth = [self.titleWArr[index] floatValue]+12;
                CGFloat toWidth = fromWidth+([self.titleWArr[index-1] floatValue]+12-fromWidth)*progress;
                CGFloat progressX = fromFrameX-(fromFrameX-toFrameX)*progress;
                self.indicateView.frame = CGRectMake(progressX,self.indicateView.frame.origin.y, toWidth, 2);
            }
            [btn1 setTitleColor:[self getColorWithColor:APP_COLOR endColor:COLOR_333333 percent:progress] forState:UIControlStateNormal];
            [btn2 setTitleColor:[self getColorWithColor:COLOR_333333 endColor:APP_COLOR percent:progress] forState:UIControlStateNormal];
        } else {
            NSInteger index = floor(per);
            if (index == self.titleWArr.count-1 || progress == 1) return;
            progress = fabs(per-index);
            UIButton *btn1 = self.titleBtnArr[index];
            UIButton *btn2 = self.titleBtnArr[index+1];
            if (!self.hideIndicateLine) {
                CGFloat fromFrameX = btn1.center.x-([self.titleWArr[index] floatValue]+12)/2;
                CGFloat toFrameX = btn2.center.x-([self.titleWArr[index+1] floatValue]+12)/2;
                CGFloat fromWidth = [self.titleWArr[index] floatValue]+12;
                CGFloat toWidth = fromWidth+([self.titleWArr[index+1] floatValue]+12-fromWidth)*progress;
                CGFloat progressX = fromFrameX+(toFrameX-fromFrameX)*progress;
                self.indicateView.frame = CGRectMake(progressX,self.indicateView.frame.origin.y, toWidth, 2);
            }
            [btn1 setTitleColor:[self getColorWithColor:APP_COLOR endColor:COLOR_333333 percent:progress] forState:UIControlStateNormal];
            [btn2 setTitleColor:[self getColorWithColor:COLOR_333333 endColor:APP_COLOR percent:progress] forState:UIControlStateNormal];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.per = scrollView.contentOffset.x/self.frame.size.width;
}

#pragma mark ------ 更新标题状态 ------
- (void)updateTitleState:(NSInteger)index {
    [self.titleBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.userInteractionEnabled = NO;
            if (!self.hideIndicateLine) {
                self.indicateView.center = CGPointMake(obj.center.x, self.titleView.frame.size.height-1);
            }
        } else {
            obj.userInteractionEnabled = YES;
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedPageViewPage:)]) {
        [self.delegate didChangedPageViewPage:index];
    }
}

#pragma mark ------ 更新PagerFrame ------
- (void)updatePagerViewFrame:(CGRect)pagerFrame {
    self.frame = pagerFrame;
    CGRect scrollF = self.scrollView.frame;
    CGFloat wid = pagerFrame.size.width;
    CGFloat hei = pagerFrame.size.height-scrollF.origin.y;
    scrollF.size.height = hei;
    scrollF.size.width = wid;
    self.scrollView.frame = scrollF;
    for (int i = 0; i < self.viewsArr.count; i++) {
        UIView *view = self.viewsArr[i];
        view.frame = CGRectMake(wid*i, 0, wid, hei);
    }
}

#pragma mark ------ 获取颜色 ------
- (UIColor *)getColorWithColor:(UIColor *)beginColor endColor:(UIColor *)endColor percent:(double)per {
    CGFloat br = 0, bg = 0, bb = 0, ba = 0;
    CGFloat er = 0, eg = 0, eb = 0, ea = 0;
    [beginColor getRed:&br green:&bg blue:&bb alpha:&ba];
    [endColor getRed:&er green:&eg blue:&eb alpha:&ea];
    double red = (er-br)*per+br;
    double green = (eg-bg)*per+bg;
    double blue = (eb-bb)*per+bb;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark ------ 设置默认选中 ------
- (void)setDefaultSelectAtIndex:(NSInteger)index {
    if (index <= self.titleWArr.count-1) {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*index, 0) animated:YES];
        [self updateTitleState:index];
    }
}

#pragma mark ------ 添加文字按钮 ------
- (void)addTextButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag fontSize:(CGFloat)fontSize {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:button];
}

#pragma mark ------ 添加图片按钮 ------
- (void)addImageButton:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:button];
}

#pragma mark ------ 点击按钮 ------
- (void)clickBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPagerButton:)]) {
        [self.delegate didClickPagerButton:sender.tag];
    }
}

#pragma mark ------ Setter 方法 ------
- (void)setTitleBgColor:(UIColor *)titleBgColor {
    _titleBgColor = titleBgColor;
    self.titleView.backgroundColor = titleBgColor;
}

- (void)setHideIndicateLine:(BOOL)hideIndicateLine {
    _hideIndicateLine = hideIndicateLine;
    self.indicateView.hidden = hideIndicateLine;
    if (!hideIndicateLine) {
        UIButton *btn = self.titleBtnArr[self.index];
        self.indicateView.center = CGPointMake(btn.center.x, self.titleView.frame.size.height-1);
    }
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    self.scrollView.scrollEnabled = canScroll;
}

@end
