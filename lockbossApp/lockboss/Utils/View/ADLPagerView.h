//
//  ADLPagerView.h
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLPagerViewDelegate <NSObject>

@optional

- (void)didChangedPageViewPage:(NSInteger)index;

- (void)didClickPagerButton:(NSInteger)tag;

@end

@interface ADLPagerView : UIView

///初始化
+ (instancetype)pagerViewWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views;

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views;

///添加标题
- (void)addTitles:(NSArray *)titleArr titleSize:(CGSize)titleSize statusH:(CGFloat)statusH fontSize:(CGFloat)fontSize;

///添加文字按钮
- (void)addTextButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag fontSize:(CGFloat)fontSize;

///添加图片按钮
- (void)addImageButton:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag;

///设置默认选中哪个，默认为0
- (void)setDefaultSelectAtIndex:(NSInteger)index;

///更新PagerView Frame
- (void)updatePagerViewFrame:(CGRect)pagerFrame;

///代理属性
@property (nonatomic, weak) id<ADLPagerViewDelegate> delegate;

///ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;

///视图数组
@property (nonatomic, strong) NSArray *viewsArr;

///标题栏背景颜色，默认#F6F6F6
@property (nonatomic, strong) UIColor *titleBgColor;

///是否显示指示线,默认显示
@property (nonatomic, assign) BOOL hideIndicateLine;

///分割线
@property (nonatomic, strong) UIView *divisionView;

///是否支持左右滑动,默认支持
@property (nonatomic, assign) BOOL canScroll;

@end
