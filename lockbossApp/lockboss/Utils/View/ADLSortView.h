//
//  ADLSortView.h
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSortViewDelegate <NSObject>

- (void)didClickTitle:(NSInteger)index ascending:(BOOL)ascending;

@end

@interface ADLSortView : UIView

///初始化
+ (instancetype)sortViewWithFrame:(CGRect)frame titles:(NSArray *)titleArr;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr;
///更新选择
- (void)updateTitleWithIndex:(NSInteger)index ascending:(BOOL)ascending;
///显示上下箭头的Index，不设置默认全部显示
@property (nonatomic, strong) NSArray *sortArr;

@property (nonatomic, strong) UIView *divisionView;

@property (nonatomic, weak) id<ADLSortViewDelegate> delegate;

@end
