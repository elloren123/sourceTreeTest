//
//  ADLTitleView.h
//  lockboss
//
//  Created by adel on 2019/4/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLTitleView : UIView

+ (instancetype)titleViewWithFrame:(CGRect)frame titles:(NSArray *)titleArr;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr;

- (void)updateTitle:(NSString *)title index:(NSInteger)index;

- (void)updateTitleWithArray:(NSArray *)titleArr;

- (void)selectTitleWithIndex:(NSInteger)index;

@property (nonatomic, strong) UIView *divisionView;

@property (nonatomic, copy) void (^clickTitle) (NSInteger index);

@end

