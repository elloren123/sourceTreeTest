//
//  ADLSearchView.h
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSearchViewDelegate <NSObject>

@optional

///点击取消
- (void)didClickCancleButton;

///输入框内容改变
- (void)textFieldTextDidChanged:(NSString *)text;

///点击搜索
- (void)didClickSearchButton:(UITextField *)textField;

@end

@interface ADLSearchView : UIView

///初始化
+ (instancetype)searchViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder instant:(BOOL)instant;

///初始化
- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder instant:(BOOL)instant;

///代理属性
@property (nonatomic, weak) id<ADLSearchViewDelegate> delegate;

///return键是否是完成
@property (nonatomic, assign) BOOL done;

///输入框
@property (nonatomic, strong) UITextField *textField;

///分割线
@property (nonatomic, strong) UIView *divisionView;

@end
