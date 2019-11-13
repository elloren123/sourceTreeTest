//
//  ADLHomeController.m
//  lockboss
//
//  Created by adel on 2019/3/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLHomeController.h"
#import "ADLNoNetworkController.h"
#import "ADLSearchGoodsController.h"
#import "ADLGoodsDetailController.h"
#import "ADLLockServiceController.h"
#import "ADLAnnoDetailController.h"
#import "ADLLockHomeController.h"
#import "ADLMessageController.h"
#import "ADLWebViewController.h"
#import "ADLCircleController.h"
#import "ADLBookingHotelController.h"

#import "ADLHomeSearchView.h"
#import "ADLRMQConnection.h"
#import "ADLHomeCellView.h"
#import "ADLBannerView.h"
#import "ADLHorseView.h"
#import <AFNetworking.h>
#import <JMessage/JMSGUser.h>

@interface ADLHomeController ()<ADLHomeSearchViewDelegate,ADLHomeCellViewDelegate>
@property (nonatomic, strong) ADLHomeSearchView *searchView;
@property (nonatomic, strong) ADLBannerView *bannerView;
@property (nonatomic, strong) ADLHorseView *horseView;
@property (nonatomic, strong) UIView *networkView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *announcementArr;
@property (nonatomic, assign) BOOL logout;//防止重复提示登录超时
@end

@implementation ADLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logout = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-self.tabBarController.tabBar.frame.size.height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    __weak typeof(self)weakSelf = self;
    scrollView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getBannerData];
        [weakSelf getAnnouncementData];
    }];
    
    //初始化视图
    [self addBannerView];
    [self addAnnouncementView];
    [self monitorNetworkStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageUnreadChangedNotification:) name:MESSAGE_UNREAD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUnreadMessage) name:REFRESH_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlayVideo) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    if ([ADLUserModel sharedModel].login) [self queryUnreadMessage];
    
    [self checkUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark ------ ADLHomeSearchViewDelegate ------
- (void)didClickHomeSearchView:(NSInteger)index {
    if (index == 0) {
        ADLSearchGoodsController *goodsVC = [[ADLSearchGoodsController alloc] init];
        goodsVC.hidesBottomBarWhenPushed = YES;
        [self customPushViewController:goodsVC];
    } else {
        if ([ADLUserModel sharedModel].login) {
            ADLMessageController *messageVC = [[ADLMessageController alloc] init];
            messageVC.hidesBottomBarWhenPushed = YES;
            messageVC.finishBlock = ^{
                [self queryUnreadMessage];
            };
            [self.navigationController pushViewController:messageVC animated:YES];
        } else {
            [self pushLoginViewControllerHideTabbar:YES success:nil];
        }
    }
}

#pragma mark ------ ADLHomeCellViewDelegate ------
- (void)didClickCellAtIndex:(NSInteger)index {
    if (index == 2) {
        [self.tabBarController setSelectedIndex:1];
    } else {
        if ([ADLUserModel sharedModel].login) {
            switch (index) {
                case 0:{
                    ADLLockHomeController *lockVC = [[ADLLockHomeController alloc] init];
                    lockVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lockVC animated:YES];
                }
                    break;
                case 1:{
                    ADLBookingHotelController *bookingVC = [[ADLBookingHotelController alloc] init];
                    bookingVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bookingVC animated:YES];
                }
                    break;
                case 3:{
                    ADLLockServiceController *serviceVC = [[ADLLockServiceController alloc] init];
                    serviceVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:serviceVC animated:YES];
                }
                    break;
                case 4:{
                    ADLCircleController *groupVC = [[ADLCircleController alloc] init];
                    groupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:groupVC animated:YES];
                }
                    break;
                case 5:{
                    
                }
                    break;
            }
        } else {
            [self pushLoginViewControllerHideTabbar:YES success:nil];
        }
    }
}

#pragma mark ------ 添加搜索、轮播图 ------
- (void)addBannerView {
    ADLHomeSearchView *searchView = [ADLHomeSearchView searchViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) delegate:self];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    //轮播图
    ADLBannerView *bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    [self.scrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    __weak typeof(self)weakSelf = self;
    bannerView.clickBanner = ^(NSString *str) {
        if ([ADLUtils isPureInt:str]) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.goodsId = str;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        } else {
            if ([str hasPrefix:@"http"]) {
                ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
                webVC.hidesBottomBarWhenPushed = YES;
                webVC.urlString = str;
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            }
        }
    };
    
    //判断本地是否缓存有轮播数据
    NSArray *cacheArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:HOME_BANNER permanent:NO]];
    if (cacheArr.count > 0) [bannerView updateBanner:cacheArr imgKey:nil urlKey:nil];
    
    [self getBannerData];
}

#pragma mark ------ 获取轮播图数据 ------
- (void)getBannerData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(3) forKey:@"type"];
    [ADLNetWorkManager postWithPath:k_query_banner parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count == 0) {
                [ADLUtils removeObjectWithFileName:HOME_BANNER permanent:NO];
            } else {
                [ADLUtils saveObject:resArr fileName:HOME_BANNER permanent:NO];
            }
            [self.bannerView updateBanner:resArr imgKey:nil urlKey:nil];
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

#pragma mark ------ 添加公告、六宫格 ------
- (void)addAnnouncementView {
    ADLHorseView *horseView = [ADLHorseView horseViewWithFrame:CGRectMake(0, SCREEN_WIDTH/2, SCREEN_WIDTH, VIEW_HEIGHT) image:[UIImage imageNamed:@"home_notice"] timeInterval:2];
    [self.scrollView addSubview:horseView];
    self.horseView = horseView;
    
    __weak typeof(self)weakSelf = self;
    horseView.clickHorseView = ^(NSInteger index) {
        ADLAnnoDetailController *detailVC = [[ADLAnnoDetailController alloc] init];
        detailVC.dict = weakSelf.announcementArr[index];
        detailVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    NSArray *annArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:HOME_ANNOUNCEMENT permanent:NO]];
    NSMutableArray *muArr = [ADLUtils dictArrayToArray:annArr key:@"title"];
    if (muArr.count > 0) {
        horseView.contentArr = muArr;
        self.announcementArr = [NSMutableArray arrayWithArray:annArr];
    }
    
    //六宫格
    CGFloat gap = 9;
    if (SCREEN_WIDTH > 500) gap = 18;
    if (SCREEN_WIDTH < 360) gap = 6;
    CGFloat cellW = (SCREEN_WIDTH-gap*4)/3;
    ADLHomeCellView *cellView = [[ADLHomeCellView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2+VIEW_HEIGHT, SCREEN_WIDTH, cellW*2+gap*3) gap:gap cellW:cellW];
    cellView.delegate = self;
    [self.scrollView addSubview:cellView];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+VIEW_HEIGHT+cellW*2+gap*3);
    [self getAnnouncementData];
}

#pragma mark ------ 获取公告数据 ------
- (void)getAnnouncementData {
    [ADLNetWorkManager postWithPath:k_query_announcement parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                if (resArr.count == 1) {
                    self.announcementArr = [NSMutableArray arrayWithObjects:resArr[0],resArr[0], nil];
                } else {
                    self.announcementArr = [NSMutableArray arrayWithArray:resArr];
                }
                [ADLUtils saveObject:self.announcementArr fileName:HOME_ANNOUNCEMENT permanent:NO];
                self.horseView.contentArr = [ADLUtils dictArrayToArray:self.announcementArr key:@"title"];
            } else {
                self.horseView.contentArr = nil;
                [ADLUtils removeObjectWithFileName:HOME_ANNOUNCEMENT permanent:NO];
            }
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

#pragma mark ------ 查询是否有未读消息 ------
- (void)queryUnreadMessage {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(0) forKey:@"stype"];
    [ADLNetWorkManager postWithPath:k_query_unread_msg parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLUserModel sharedModel].read = [responseDict[@"data"][@"isRead"] boolValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_CHANGED object:nil userInfo:nil];
        }
    } failure:nil];
}

#pragma mark ------ 监听网络状态 ------
- (void)monitorNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                [ADLNetWorkManager sharedManager].wifi = YES;
            } else {
                [ADLNetWorkManager sharedManager].wifi = NO;
            }
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    [self.view addSubview:self.networkView];
                    [ADLNetWorkManager sharedManager].connent = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_CHANGED object:nil userInfo:nil];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    if ([ADLNetWorkManager sharedManager].connent == NO) {
                        [self getBannerData];
                        [self getAnnouncementData];
                        [self.networkView removeFromSuperview];
                        [ADLNetWorkManager sharedManager].connent = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_CHANGED object:@"connected" userInfo:nil];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_CHANGED object:nil userInfo:nil];
                    }
                    break;
                default:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_CHANGED object:nil userInfo:nil];
                    break;
            }
        });
    }];
    [manager startMonitoring];
}

#pragma mark ------ 未读消息改变通知 ------
- (void)messageUnreadChangedNotification:(NSNotification *)notification {
    if (self.searchView.pointView.hidden != [ADLUserModel sharedModel].read) {
        self.searchView.pointView.hidden = [ADLUserModel sharedModel].read;
    }
    
    //退出登录
    if ([[notification.object stringValue] hasPrefix:@"logout"] && self.logout == NO) {
        self.logout = YES;
        [ADLUserModel removeUserModel];
        [[ADLUserModel sharedModel] resetUserModel];
        [ADLNetWorkManager sharedManager].token = nil;
        [[ADLRMQConnection sharedConnect] closeConnection];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"exit" userInfo:nil];
        [JMSGUser logout:^(id resultObject, NSError *error) {
            
        }];
        
        if ([[notification.object stringValue] isEqualToString:@"logout"]) {
            NSString *message = [notification.userInfo[@"msg"] stringValue];
            UIViewController *controller = [ADLUtils getCurrentViewController];
            if (message.length > 0) {
                [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:message confirmTitle:nil confirmAction:^{
                    if (controller.navigationController) {
                        [controller.navigationController popToRootViewControllerAnimated:YES];
                    }
                } cancleTitle:nil cancleAction:nil showCancle:NO];
            } else {
                [ADLToast showMessage:ADLString(@"login_expired")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (controller.navigationController) {
                        [controller.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }
        }
        [self performSelector:@selector(logoutNO) withObject:nil afterDelay:10];
    }
}

#pragma mark ------ 设置退出登录标识 ------
- (void)logoutNO {
    self.logout = NO;
}

#pragma mark ------ WebView视频播放结束通知 ------
- (void)endPlayVideo {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark ------ 检查更新 ------
- (void)checkUpdate {
    [ADLNetWorkManager postNormalPath:@"https://itunes.apple.com/lookup?id=1460566050" parameters:nil success:^(NSDictionary *responseDict) {
        NSArray *resultArr = responseDict[@"results"];
        if (resultArr.count > 0) {
            NSArray *appStoreArr = [resultArr[0][@"version"] componentsSeparatedByString:@"."];
            NSArray *localArr = [[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
            if (appStoreArr.count == localArr.count) {
                for (NSInteger i = 0; i < 3; i++) {
                    if ([appStoreArr[i] intValue] != [localArr[i] intValue]) {
                        [ADLAlertView showWithTitle:@"更新提示" message:@"发现新版本，为保证各项功能正常使用，请您尽快更新。" confirmTitle:@"更新" confirmAction:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:k_lockboss_download_string]];
                        } cancleTitle:nil cancleAction:nil showCancle:YES];
                        break;
                    }
                }
            }
        }
    } failure:nil];
}

#pragma mark ------ 断网视图 ------
- (UIView *)networkView {
    if (_networkView == nil) {
        CGFloat h = 40;
        _networkView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, h)];
        _networkView.backgroundColor = [UIColor colorWithRed:253/255.0 green:228/255.0 blue:229/255.0 alpha:1];
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, h-12, h-12)];
        imgView1.image = [UIImage imageNamed:@"home_net_warning"];
        [_networkView addSubview:imgView1];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-h, 0, h, h)];
        [closeBtn setImage:[UIImage imageNamed:@"close_round"] forState:UIControlStateNormal];
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [closeBtn addTarget:self action:@selector(clickCloseNetworkView) forControlEvents:UIControlEventTouchUpInside];
        [_networkView addSubview:closeBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(h+8, 0, 300, h)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"当前网络不可用，请检查你的网络设置";
        label.textAlignment = NSTextAlignmentLeft;
        [_networkView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNoNetworkView)];
        [_networkView addGestureRecognizer:tap];
    }
    return _networkView;
}

#pragma mark ------ 点击断网视图 ------
- (void)tapNoNetworkView {
    ADLNoNetworkController *networkVC = [[ADLNoNetworkController alloc] init];
    networkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:networkVC animated:YES];
}

#pragma mark ------ 关闭断网视图 ------
- (void)clickCloseNetworkView {
    [self.networkView removeFromSuperview];
}

@end
