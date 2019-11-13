//
//  ADLTabBarController.m
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTabBarController.h"
#import "ADLNavigationController.h"
#import "ADLHomeController.h"
#import "ADLStoreController.h"
#import "ADLDiscoveryController.h"
#import "ADLShoppingCarController.h"
#import "ADLMineController.h"
#import "ADLRMQConnection.h"

#import "NSNull+ADLNull.h"
#import "NSString+ADLString.h"
#import "NSNumber+ADLNumber.h"

@interface ADLTabBarController ()
@property (nonatomic, strong) UILabel *numLab;
@end

CGFloat STATUS_HEIGHT = 20;
CGFloat NAVIGATION_H = 64;
CGFloat VIEW_HEIGHT = 46;
CGFloat ROW_HEIGHT = 48;
CGFloat BOTTOM_H = 0;
CGFloat NAV_H = 44;

@implementation ADLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializationUserModel];
    [self initializationConstant];
    
    self.tabBar.translucent = NO;
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    //添加子控制器
    [self setUpChildViewControllersWithController:[ADLHomeController new] Title:@"首页" ImageName:@"home_normal" SelectedImageName:@"home_selected"];
    [self setUpChildViewControllersWithController:[ADLStoreController new] Title:@"商城" ImageName:@"store_normal" SelectedImageName:@"store_selected"];
    [self setUpChildViewControllersWithController:[ADLDiscoveryController new] Title:@"发现" ImageName:@"discovery_normal" SelectedImageName:@"discovery_selected"];
    [self setUpChildViewControllersWithController:[ADLShoppingCarController new] Title:@"购物车" ImageName:@"shopcar_normal" SelectedImageName:@"shopcar_selected"];
    [self setUpChildViewControllersWithController:[ADLMineController new] Title:@"我的" ImageName:@"mine_normal" SelectedImageName:@"mine_selected"];
    
    UILabel *numLab = [[UILabel alloc] init];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.font = [UIFont systemFontOfSize:12];
    numLab.textColor = [UIColor whiteColor];
    numLab.backgroundColor = APP_COLOR;
    numLab.layer.cornerRadius = 8;
    numLab.clipsToBounds = YES;
    self.numLab = numLab;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBar addSubview:self.numLab];
        if ([ADLUserModel sharedModel].login) {
            [self queryGoodsCount];
        }
    });
}

///初始化子控制
- (void)setUpChildViewControllersWithController:(UIViewController *)controller Title:(NSString *)title ImageName:(NSString *)imageName SelectedImageName:(NSString *)selectedImageName {
    controller.tabBarItem.title = title;
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_333333} forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_COLOR} forState:UIControlStateSelected];
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ADLNavigationController *navigationVC = [[ADLNavigationController alloc] initWithRootViewController:controller];//使用UINavigationController侧滑手势会失效
    [self addChildViewController:navigationVC];
}

#pragma mark ------ 初始化用户模型 ------
- (void)initializationUserModel {
    ADLUserModel *model = [ADLUserModel readUserModel];
    ADLUserModel *shareModel = [ADLUserModel sharedModel];
    if (model.loginAccount == nil) {
        shareModel.login = NO;
        shareModel.read = YES;
    } else {
        [ADLNetWorkManager sharedManager].token = model.token;
        [shareModel setValueWithModel:model];
        [[ADLRMQConnection sharedConnect] startConnection];
    }
}

#pragma mark ------ 初始化常量 ------
- (void)initializationConstant {
    //状态栏高度
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (statusH != 40) STATUS_HEIGHT = statusH;
    if (statusH == 44) BOTTOM_H = 34;
    if (statusH == 24) BOTTOM_H = 22;
    
    //导航栏高度
    NAV_H = SCREEN_WIDTH < 500 ? 44 : 50;
    NAVIGATION_H = NAV_H+STATUS_HEIGHT;
    
    //视图高度
    if (SCREEN_WIDTH == 320) {
        ROW_HEIGHT = 42;
        VIEW_HEIGHT = 40;
    }
    if (SCREEN_WIDTH > 500) {
        ROW_HEIGHT = 52;
        VIEW_HEIGHT = 50;
    }
}

#pragma mark ------ 设置数量 ------
- (void)setNum:(NSInteger)num {
    _num = num;
    if (num > 0) {
        self.numLab.hidden = NO;
        if (num < 10) {
            self.numLab.text = [NSString stringWithFormat:@"%ld",num];
            self.numLab.frame = CGRectMake(SCREEN_WIDTH*0.7+10, 2, 16, 16);
        } else if (num < 99) {
            self.numLab.text = [NSString stringWithFormat:@"%ld",num];
            self.numLab.frame = CGRectMake(SCREEN_WIDTH*0.7+7, 2, 23, 16);
        } else {
            self.numLab.text = @"99+";
            self.numLab.frame = CGRectMake(SCREEN_WIDTH*0.7+3, 2, 30, 16);
        }
    } else {
        self.numLab.hidden = YES;
    }
}

#pragma mark ------ 查询购物车数量 ------
- (void)queryGoodsCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(0) forKey:@"offset"];
    [params setValue:@(10) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_query_car_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.num = [responseDict[@"data"][@"total"] integerValue];
        }
    } failure:nil];
}

@end
