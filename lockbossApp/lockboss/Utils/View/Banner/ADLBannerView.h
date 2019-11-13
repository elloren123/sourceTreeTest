//
//  ADLBannerView.h
//  lockboss
//
//  Created by Adel on 2019/11/13.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADLPagePosition) {
    ADLPagePositionCenetr,
    ADLPagePositionRight,
    ADLPagePositionLeft
};

typedef NS_ENUM(NSInteger, ADLPageStyle) {
    ADLPageStyleRound,
    ADLPageStyleFlat
};

@interface ADLBannerView : UIView

///初始化
- (instancetype)initWithFrame:(CGRect)frame position:(ADLPagePosition)position style:(ADLPageStyle)style;

///dataArr:字典数组；imgKey:图片地址Key,默认为bannerImgUrl urlKey:跳转链接地址Key，默认为linkUrl
- (void)updateBanner:(NSArray *)dataArr imgKey:(NSString *)imgKey urlKey:(NSString *)urlKey;

///更新Banner，图片地址数组
- (void)updateBanner:(NSArray *)urlArr;

///开始轮播
- (void)startTimer;

///点击Banner
@property (nonatomic, copy) void(^clickBanner) (NSString *str);

///轮播间隔，默认3s
@property (nonatomic, assign) NSTimeInterval timeInterval;

///当前轮播图Item的数量
@property (nonatomic, assign) NSInteger itemCount;

///小圆点直径,默认6
@property (nonatomic, assign) CGFloat diameter;

///小圆点之间的间隔，默认6
@property (nonatomic, assign) CGFloat dotMargin;

///小圆点距左边距离，ADLPagePositionLeft有效
@property (nonatomic, assign) CGFloat leftMargin;

///小圆点距右边距离，ADLPagePositionRight有效
@property (nonatomic, assign) CGFloat rightMargin;

///小圆点距底部距离，默认
@property (nonatomic, assign) CGFloat bottomMargin;

///当前页page的颜色，默认白色
@property(nonatomic, strong) UIColor *selectColor;

///非当前页page的颜色,默认白色半透明
@property(nonatomic, strong) UIColor *unselectColor;

///Timer
@property (nonatomic, strong) NSTimer *timer;

@end
