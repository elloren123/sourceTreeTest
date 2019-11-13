//
//  ADLSearchNewsView.h
//  lockboss
//
//  Created by adel on 2019/3/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLHomeSearchViewDelegate <NSObject>

@optional

- (void)didClickHomeSearchView:(NSInteger)index;

- (void)didClickBackBtn;

@end

@interface ADLHomeSearchView : UIView

///delegate遵不遵循ADLHomeSearchViewDelegate都是没问题的，只要实现代理方法和设置代理就可以
+ (instancetype)searchViewWithFrame:(CGRect)frame delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

- (void)hideLogo;

@property (nonatomic, weak) id<ADLHomeSearchViewDelegate> delegate;

@property (nonatomic, strong) UIView *pointView;

@property (nonatomic, weak) UILabel *phLabel;

@property (nonatomic ,weak)UIButton *newsBtn;

@end
