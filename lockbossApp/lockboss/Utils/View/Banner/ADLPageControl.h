//
//  ADLPageControl.h
//  lockboss
//
//  Created by Adel on 2019/11/13.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLPageControl : UIView

///初始化
- (instancetype)initWithFlatStyle:(BOOL)flatStyle;

///圆点之间间隔
@property (nonatomic, assign) CGFloat margin;

///圆点直径
@property (nonatomic, assign) CGFloat diameter;

///选中颜色
@property (nonatomic, strong) UIColor *selectColor;

///未选中颜色
@property (nonatomic, strong) UIColor *unselectColor;

///当前页
@property (nonatomic, assign) NSInteger currentPage;

///总页数
@property (nonatomic, assign) NSInteger numberOfPages;

@end
