//
//  ADLBaseViewController.h
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

#import "ADLNetWorkManager.h"
#import "ADLRefreshHeader.h"
#import "ADLRefreshFooter.h"

#import "ADLToast.h"
#import "ADLUtils.h"
#import "ADELUrlpath.h"
#import "ADLAlertView.h"
#import "ADLApiDefine.h"
#import "ADLUserModel.h"

@interface ADLBaseViewController : UIViewController

///当前偏移量
@property (nonatomic, assign) NSInteger offset;

///单页大小
@property (nonatomic, assign) NSInteger pageSize;

///数据源数组
@property (nonatomic, strong) NSMutableArray *dataArr;

///自定义导航栏标题
@property (nonatomic, strong) UILabel *titleLab;

///导航栏视图
@property (nonatomic, strong) UIView *navigationView;

///是否显示返回按钮
@property (nonatomic, strong) UIButton *backBtn;

///分割线
@property (nonatomic, strong) UIView *spView;

///添加自定义导航栏视图
- (void)addNavigationView:(NSString *)title;

///添加红色的自定义导航栏视图
- (void)addRedNavigationView:(NSString *)title;

///跳转到登录控制器
- (void)pushLoginViewControllerHideTabbar:(BOOL)hideTabbar success:(void(^)(void))success;

///添加左边文字按钮,返回按钮会被替换
- (UIButton *)addLeftButtonWithTitle:(NSString *)title action:(SEL)action;

///添加右边文字按钮
- (UIButton *)addRightButtonWithTitle:(NSString *)title action:(SEL)action;

///添加左边图片按钮,返回按钮会被替换
- (UIButton *)addLeftButtonWithImageName:(NSString *)imageName action:(SEL)action;

///添加右边图片按钮
- (UIButton *)addRightButtonWithImageName:(NSString *)imageName action:(SEL)action;

///从下向上的Push动画
- (void)customPushViewController:(UIViewController *)controller;

///从上向下的Pop动画
- (void)customPopViewController;

- (void)clickBackBtn;
@end
