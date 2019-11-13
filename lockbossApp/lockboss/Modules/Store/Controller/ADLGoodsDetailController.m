//
//  ADLGoodsDetailController.m
//  lockboss
//
//  Created by adel on 2019/5/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsDetailController.h"
#import "ADLGoodsEvaDetailController.h"
#import "ADLGoodsEvaListController.h"
#import "ADLShoppingCarController.h"
#import "ADLSubmitOrderController.h"
#import "ADLLockServiceController.h"
#import "ADLAddShipController.h"
#import "ADLSessionController.h"

#import "ADLTitleView.h"
#import "ORSKUDataFilter.h"
#import "ADLGoodsAttriView.h"
#import "ADLGoodsHeaderView.h"
#import "ADLGoodsDetailView.h"
#import "ADLGoodsAddressView.h"
#import "ADLGDetailBottomView.h"
#import "ADLGoodsRelevantView.h"
#import "ADLGoodsEvaluateView.h"

#import <YYText.h>
#import <Masonry.h>
#import <AVKit/AVPlayerViewController.h>

@interface ADLGoodsDetailController ()<UIScrollViewDelegate,ORSKUDataFilterDataSource,ADLGoodsHeaderViewDelegate,ADLGDetailBottomViewDelegate,ADLGoodsEvaluateViewDelegate>
///ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
///标题
@property (nonatomic, strong) ADLTitleView *titleView;
///HeaderView
@property (nonatomic, strong) ADLGoodsHeaderView *headerView;
///商品视图
@property (nonatomic, strong) ADLGoodsDetailView *goodsView;
///底部视图
@property (nonatomic, strong) ADLGDetailBottomView *bottomView;
///单独详情视图
@property (nonatomic, strong) ADLGoodsDetailView *detailView;
///评价视图
@property (nonatomic, strong) ADLGoodsEvaluateView *evaluateView;
///推荐视图
@property (nonatomic, strong) ADLGoodsRelevantView *relevantView;
///商品SKU选择器
@property (nonatomic, strong) ORSKUDataFilter *filter;
///商品属性字典
@property (nonatomic, strong) NSMutableDictionary *attributeDict;
///当前选择的商品信息字典
@property (nonatomic, strong) NSMutableDictionary *selectDict;
///订单信息字典
@property (nonatomic, strong) NSMutableDictionary *orderDict;
///自定义导航栏视图
@property (nonatomic, strong) UIView *navView;
///圆形返回按钮
@property (nonatomic, strong) UIButton *rbackBtn;
///圆形加入购物车按钮
@property (nonatomic, strong) UIButton *rcarBtn;
///预约服务提示视图
@property (nonatomic, strong) UIView *promptView;
///是否已经售完
@property (nonatomic, assign) BOOL sellout;
///商品图片,sku图片为空时显示此图片
@property (nonatomic, strong) NSString *goodsImg;
///当前导航栏透明度
@property (nonatomic, assign) CGFloat alpha;
///商品推荐数组
@property (nonatomic, strong) NSArray *relevantArr;
///商品推荐高度数组
@property (nonatomic, strong) NSMutableArray *relevantHArr;
///收货地址数组
@property (nonatomic, strong) NSMutableArray *addressArr;
///当前选中的收货地址
@property (nonatomic, strong) NSDictionary *addressDict;
///省市数据
@property (nonatomic, strong) NSMutableArray *provinceArr;
///播放器
@property (nonatomic, strong) AVPlayer *player;
///下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ADLGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 0);
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    __weak typeof(self)weakSelf = self;
    ADLGoodsDetailView *goodsView = [[ADLGoodsDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_H-50)];
    [scrollView addSubview:goodsView];
    goodsView.hidden = YES;
    self.goodsView = goodsView;
    goodsView.clickVideo = ^(NSString *videoUrl) {
        [weakSelf playVideoWithUrl:videoUrl];
    };
    goodsView.contentOffsetChanged = ^(CGFloat offsetY) {
        CGFloat alpha = offsetY/NAVIGATION_H/2;
        if (alpha > 1) {
            alpha = 1;
        }
        if (alpha < 0) {
            alpha = 0;
        }
        weakSelf.navView.alpha = alpha;
        weakSelf.rbackBtn.alpha = 1-alpha;
        weakSelf.rcarBtn.alpha = 1-alpha;
        weakSelf.alpha = alpha;
    };
    
    [self setupNavigationView];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [self getGoodsData];
    [self getGoodsLSInformation];
}

#pragma mark ------ 导航栏 ------
- (void)setupNavigationView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    self.navView = navView;
    navView.alpha = 0;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [navView addSubview:backBtn];
    
    UIButton *carBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [carBtn setImage:[UIImage imageNamed:@"nav_car"] forState:UIControlStateNormal];
    carBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    carBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
    [carBtn addTarget:self action:@selector(didClickShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:carBtn];
    
    UIButton *rbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [rbackBtn setImage:[UIImage imageNamed:@"store_back"] forState:UIControlStateNormal];
    [rbackBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    rbackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5.5, 0, 0);
    [self.view addSubview:rbackBtn];
    self.rbackBtn = rbackBtn;
    
    UIButton *rcarBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [rcarBtn setImage:[UIImage imageNamed:@"store_car"] forState:UIControlStateNormal];
    rcarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rcarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.5);
    [rcarBtn addTarget:self action:@selector(didClickShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rcarBtn];
    self.rcarBtn = rcarBtn;
    
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(SCREEN_WIDTH/2-100, STATUS_HEIGHT, 200, NAV_H) titles:@[@"商品",@"详情",@"评价",@"推荐"]];
    titleView.divisionView.hidden = YES;
    titleView.clickTitle = ^(NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf.scrollView setContentOffset:CGPointZero animated:YES];
                break;
            case 1:
                [weakSelf.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                break;
            case 2:
                [weakSelf.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
                break;
            case 3:
                [weakSelf.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0) animated:YES];
                break;
        }
        if (index == 0) {
            weakSelf.navView.alpha = weakSelf.alpha;
            weakSelf.rbackBtn.alpha = 1-weakSelf.alpha;
            weakSelf.rcarBtn.alpha = 1-weakSelf.alpha;
        } else {
            [weakSelf.goodsView.tableView setContentOffset:CGPointMake(0, weakSelf.goodsView.tableView.contentOffset.y) animated:NO];
            weakSelf.navView.alpha = 1;
            weakSelf.rbackBtn.alpha = 0;
            weakSelf.rcarBtn.alpha = 0;
        }
        [weakSelf switchViewWithIndex:index];
    };
    [navView addSubview:titleView];
    self.titleView = titleView;
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-0.3, SCREEN_WIDTH, 0.3)];
    spView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [navView addSubview:spView];
}

#pragma mark ------ 预约服务提示视图 ------
- (void)setupPromptView {
    NSString *promptStr = @"尊敬的客户，您好！鉴于您对我们的产品感兴趣，由于智能门锁相对比较专业，建议您预约我们的服务师傅上门做专业的指导服务。预约服务>>";
    UIView *promptView = [[UIView alloc] init];
    promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    [self.view addSubview:promptView];
    self.promptView = promptView;
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14);
    [closeBtn addTarget:self action:@selector(clickClosePromptView) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:closeBtn];
    
    YYLabel *promptLab = [[YYLabel alloc] init];
    [promptView addSubview:promptLab];
    
    __weak typeof(self)weakSelf = self;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:promptStr];
    attributeStr.yy_lineSpacing = 7;
    attributeStr.yy_font = [UIFont systemFontOfSize:13];
    attributeStr.yy_color = [UIColor whiteColor];
    [attributeStr yy_setTextHighlightRange:NSMakeRange(promptStr.length-6, 6) color:APP_COLOR backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf clickBookingService];
    }];
    promptLab.numberOfLines = 0;
    promptLab.attributedText = attributeStr;
    
    CGFloat promptH = [ADLUtils calculateAttributeString:attributeStr rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT)].height;
    promptLab.frame = CGRectMake(12, 40, SCREEN_WIDTH-24, promptH);
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(50+promptH));
    }];
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 购物车 ------
- (void)didClickShoppingCar {
    ADLShoppingCarController *carVC = [[ADLShoppingCarController alloc] init];
    carVC.pushString = @"push";
    [self.navigationController pushViewController:carVC animated:YES];
}

#pragma mark ------ 关闭提示 ------
- (void)clickClosePromptView {
    [UIView animateWithDuration:0.3 animations:^{
        self.promptView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.promptView removeFromSuperview];
    }];
}

#pragma mark ------ 预约服务 ------
- (void)clickBookingService {
    if ([ADLUserModel sharedModel].login) {
        ADLLockServiceController *lockVC = [[ADLLockServiceController alloc] init];
        [self.navigationController pushViewController:lockVC animated:YES];
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 点击属性 ------
- (void)didClickAttributeBtn {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.attributeDict[@"propertyVOList"] forKey:@"propertyVOList"];
    [dict setValue:self.selectDict[@"skuImgUrl"] forKey:@"imageUrl"];
    [dict setValue:self.attributeDict[@"skuList"] forKey:@"skuList"];
    if (!self.sellout) {
        [dict setValue:self.selectDict[@"count"] forKey:@"count"];
        [dict setValue:self.selectDict[@"select"] forKey:@"select"];
        [dict setValue:self.selectDict[@"service"] forKey:@"service"];
        [dict setValue:self.attributeDict[@"serviceList"] forKey:@"serviceList"];
    }
    
    [ADLGoodsAttriView goodsAttributeViewWith:dict confirmAction:^(NSMutableDictionary *selectDict) {
        if (selectDict) {
            [self.headerView updateSelectAttribute:[NSString stringWithFormat:@"%@, %@件",selectDict[@"select"],selectDict[@"count"]]];
            if ([self.selectDict[@"id"] isEqualToString:selectDict[@"id"]]) {
                self.selectDict = selectDict;
                [self.orderDict setValue:selectDict[@"count"] forKey:@"num"];
            } else {
                self.selectDict = selectDict;
                [self updateSelectAttributes];
            }
            if ([selectDict[@"service"][@"id"] stringValue].length > 0) {
                [self.orderDict setValue:@[selectDict[@"service"]] forKey:@"services"];
                [self.orderDict setValue:[NSString stringWithFormat:@"服务    %@",selectDict[@"service"][@"name"]] forKey:@"service"];
                [self.orderDict setValue:selectDict[@"service"][@"startingPrice"] forKey:@"startingPrice"];
            } else {
                [self.orderDict setValue:@[] forKey:@"services"];
                [self.orderDict setValue:nil forKey:@"service"];
                [self.orderDict setValue:nil forKey:@"startingPrice"];
            }
        } else {
            if (![ADLUserModel sharedModel].login) {
               [self pushLoginViewController];
            }
        }
    }];
}

#pragma mark ------ 点击地址 ------
- (void)didClickAddressBtn:(BOOL)add {
    if ([ADLUserModel sharedModel].login) {
        if (self.addressArr.count == 0) {
            ADLAddShipController *shipVC = [[ADLAddShipController alloc] init];
            shipVC.provinceArr = self.provinceArr;
            shipVC.finish = ^(NSDictionary * _Nonnull addressDict) {
                [self getAddressData];
            };
            [self.navigationController pushViewController:shipVC animated:YES];
        } else {
            [ADLGoodsAddressView addressViewWithArray:self.addressArr addressId:[self.addressDict[@"id"] stringValue] finish:^(NSMutableDictionary *selectDict, BOOL addAddress) {
                if (addAddress) {
                    ADLAddShipController *shipVC = [[ADLAddShipController alloc] init];
                    shipVC.provinceArr = self.provinceArr;
                    shipVC.finish = ^(NSDictionary * _Nonnull addressDict) {
                        [self getAddressData];
                    };
                    [self.navigationController pushViewController:shipVC animated:YES];
                } else {
                    [self.headerView updateShipAddress:selectDict[@"fullAddress"]];
                    [self.orderDict setValue:selectDict[@"cityId"] forKey:@"cityId"];
                    if (![selectDict[@"cityId"] isEqualToString:self.addressDict[@"cityId"]]) {
                        self.addressDict = selectDict;
                        [self getLockServiceData];
                    } else {
                        self.addressDict = selectDict;
                    }
                }
            }];
        }
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 查看全部评价 ------
- (void)didClickLookEvaluateBtn {
    ADLGoodsEvaListController *listVC = [[ADLGoodsEvaListController alloc] init];
    listVC.goodsId = self.goodsId;
    listVC.deallocAction = ^{
        [self getEvaluateData];
    };
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark ------ 推荐商品 ------
- (void)didClickRelevantGoods:(NSString *)goodsId {
    ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
    detailVC.goodsId = goodsId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 联系客服 ------
- (void)didClickCustomerService {
    if ([ADLUserModel sharedModel].login) {
        ADLSessionController *sessionVC = [[ADLSessionController alloc] init];
        sessionVC.goodsId = self.goodsId;
        [self.navigationController pushViewController:sessionVC animated:YES];
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 收藏 ------
- (void)didClickCollection:(BOOL)collection {
    if ([ADLUserModel sharedModel].login) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.goodsId forKey:@"goodsId"];
        [params setValue:@(collection) forKey:@"isCollect"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_collect_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:responseDict[@"msg"]];
                [self.bottomView updateCollectionStatus:!collection];
            }
        } failure:nil];
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 加入购物车 ------
- (void)didClickAddShoppingCar {
    if ([ADLUserModel sharedModel].login) {
        if (self.sellout) {
            [ADLToast showMessage:@"商品库存不足"];
        } else {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.attributeDict[@"propertyVOList"] forKey:@"propertyVOList"];
            [dict setValue:self.attributeDict[@"serviceList"] forKey:@"serviceList"];
            [dict setValue:self.selectDict[@"skuImgUrl"] forKey:@"imageUrl"];
            [dict setValue:self.attributeDict[@"skuList"] forKey:@"skuList"];
            [dict setValue:self.selectDict[@"service"] forKey:@"service"];
            [dict setValue:self.selectDict[@"select"] forKey:@"select"];
            [dict setValue:self.selectDict[@"count"] forKey:@"count"];
            [dict setValue:self.orderId forKey:@"orderId"];
            
            [ADLGoodsAttriView goodsAttributeViewWith:dict confirmAction:^(NSMutableDictionary *selectDict) {
                if (selectDict) {
                    [self.headerView updateSelectAttribute:[NSString stringWithFormat:@"%@, %@件",selectDict[@"select"],selectDict[@"count"]]];
                    if ([self.selectDict[@"id"] isEqualToString:selectDict[@"id"]]) {
                        self.selectDict = selectDict;
                        [self.orderDict setValue:selectDict[@"count"] forKey:@"num"];
                    } else {
                        self.selectDict = selectDict;
                        [self updateSelectAttributes];
                    }
                    if ([selectDict[@"service"][@"id"] stringValue].length > 0) {
                        [self.orderDict setValue:@[selectDict[@"service"]] forKey:@"services"];
                        [self.orderDict setValue:[NSString stringWithFormat:@"服务    %@",selectDict[@"service"][@"name"]] forKey:@"service"];
                        [self.orderDict setValue:selectDict[@"service"][@"startingPrice"] forKey:@"startingPrice"];
                    } else {
                        [self.orderDict setValue:@[] forKey:@"services"];
                        [self.orderDict setValue:nil forKey:@"service"];
                        [self.orderDict setValue:nil forKey:@"startingPrice"];
                    }
                }
            }];
        }
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 立即购买 ------
- (void)didClickBuyNow {
    if ([ADLUserModel sharedModel].login) {
        if (self.sellout) {
            [ADLToast showMessage:@"商品库存不足"];
        } else {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.attributeDict[@"propertyVOList"] forKey:@"propertyVOList"];
            [dict setValue:self.attributeDict[@"serviceList"] forKey:@"serviceList"];
            [dict setValue:self.selectDict[@"skuImgUrl"] forKey:@"imageUrl"];
            [dict setValue:self.attributeDict[@"skuList"] forKey:@"skuList"];
            [dict setValue:self.selectDict[@"service"] forKey:@"service"];
            [dict setValue:self.selectDict[@"select"] forKey:@"select"];
            [dict setValue:self.selectDict[@"count"] forKey:@"count"];
            [dict setValue:self.orderId forKey:@"orderId"];
            [dict setValue:@(YES) forKey:@"confirm"];
            
            [ADLGoodsAttriView goodsAttributeViewWith:dict confirmAction:^(NSMutableDictionary *selectDict) {
                if (selectDict) {
                    [self.headerView updateSelectAttribute:[NSString stringWithFormat:@"%@, %@件",selectDict[@"select"],selectDict[@"count"]]];
                    if ([self.selectDict[@"id"] isEqualToString:selectDict[@"id"]]) {
                        self.selectDict = selectDict;
                        [self.orderDict setValue:selectDict[@"count"] forKey:@"num"];
                    } else {
                        self.selectDict = selectDict;
                        [self updateSelectAttributes];
                    }
                    if ([selectDict[@"service"][@"id"] stringValue].length > 0) {
                        [self.orderDict setValue:@[selectDict[@"service"]] forKey:@"services"];
                        [self.orderDict setValue:[NSString stringWithFormat:@"服务    %@",selectDict[@"service"][@"name"]] forKey:@"service"];
                        [self.orderDict setValue:selectDict[@"service"][@"startingPrice"] forKey:@"startingPrice"];
                    } else {
                        [self.orderDict setValue:@[] forKey:@"services"];
                        [self.orderDict setValue:nil forKey:@"service"];
                        [self.orderDict setValue:nil forKey:@"startingPrice"];
                    }
                    
                    ADLSubmitOrderController *submitVC = [[ADLSubmitOrderController alloc] init];
                    submitVC.provinceArr = self.provinceArr;
                    submitVC.goodsArr = @[self.orderDict];
                    submitVC.shoppingCar = NO;
                    [self.navigationController pushViewController:submitVC animated:YES];
                }
            }];
        }
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 详情评价点赞 ------
- (void)didClickEvaluateLikeBtn:(NSMutableDictionary *)evaDict index:(NSInteger)index {
    if ([ADLUserModel sharedModel].login) {
        if ([evaDict[@"isPraise"] boolValue]) {
            [ADLToast showMessage:@"已经点赞过了"];
        } else {
            if ([evaDict[@"buyerUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
                [ADLToast showMessage:@"不能点赞自己"];
            } else {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[ADLUserModel sharedModel].userId forKey:@"fromUserId"];
                [params setValue:evaDict[@"buyerUserId"] forKey:@"toUserId"];
                [params setValue:evaDict[@"id"] forKey:@"evaluateId"];
                [params setValue:@(2) forKey:@"type"];
                [ADLNetWorkManager postWithPath:k_goods_evaluate_reply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:evaDict];
                        [dict setValue:@([evaDict[@"praiseNum"] integerValue]+1) forKey:@"praiseNum"];
                        [dict setValue:@(1) forKey:@"isPraise"];
                        [self.headerView updateEvaluateStatus:dict index:index];
                    }
                } failure:nil];
            }
        }
    } else {
        [self pushLoginViewController];
    }
}

#pragma mark ------ 点击评价cell ------
- (void)didClickEvaluateCell:(NSMutableDictionary *)evaDict index:(NSInteger)index {
    ADLGoodsEvaDetailController *evaVC = [[ADLGoodsEvaDetailController alloc] init];
    evaVC.evaluateDict = evaDict;
    evaVC.finishBlock = ^(NSMutableDictionary *dict) {
        [self.headerView updateEvaluateStatus:dict index:index];
    };
    [self.navigationController pushViewController:evaVC animated:YES];
}

#pragma mark ------ 点击单独评价视图点赞 ------
- (void)didClickEvaluateViewLikeBtn:(NSMutableDictionary *)dict {
    [self.headerView updateEvaluateData:dict];
}

#pragma mark ------ 点击单独评价视图Cell ------
- (void)didClickEvaluateViewCell:(NSMutableDictionary *)evaDict index:(NSInteger)index {
    ADLGoodsEvaDetailController *evaVC = [[ADLGoodsEvaDetailController alloc] init];
    evaVC.evaluateDict = evaDict;
    evaVC.finishBlock = ^(NSMutableDictionary *dict) {
        [self.evaluateView updateEvaluateData:dict index:index];
        [self.headerView updateEvaluateData:dict];
    };
    [self.navigationController pushViewController:evaVC animated:YES];
}

#pragma mark ------ 点击单独评价视图Cell ------
- (void)evaluatePushLoginController {
    __weak typeof(self)weakSelf = self;
    [self pushLoginViewControllerHideTabbar:NO success:^{
        [weakSelf getGoodsData];
        [weakSelf getAddressData];
        [weakSelf getEvaluateData];
        [weakSelf.evaluateView updateEvaluateData];
    }];
}

#pragma mark ------ 处理视图切换 ------
- (void)switchViewWithIndex:(NSInteger)index {
    if (index == 1) {
        self.detailView.specArr = self.goodsView.specArr;
        self.detailView.specHArr = self.goodsView.specHArr;
        if (!self.detailView.cerUrl) {
            self.detailView.cerUrl = self.goodsView.cerUrl;
            self.detailView.videoUrl = self.goodsView.videoUrl;
            self.detailView.videoDuration = self.goodsView.videoDuration;
            self.detailView.previewImage = self.goodsView.previewImage;
            self.detailView.reportArr = self.goodsView.reportArr;
            self.detailView.detailArr = self.goodsView.detailArr;
        }
        [self.detailView.tableView reloadData];
    }
    if (index == 2) {
        [self.evaluateView updateEvaluateData];
    }
    if (index == 3) {
        if (self.relevantView.relevantArr.count == 0) {
            self.relevantView.relevantArr = self.relevantArr;
            self.relevantView.relevantHArr = self.relevantHArr;
            [self.relevantView.collectionView reloadData];
        }
    }
}

#pragma mark ------ 跳转登录 ------
- (void)pushLoginViewController {
    __weak typeof(self)weakSelf = self;
    [self pushLoginViewControllerHideTabbar:NO success:^{
        [weakSelf getGoodsData];
        [weakSelf getAddressData];
        [weakSelf getEvaluateData];
    }];
}

#pragma mark ------ ORSKUDataFilterDataSource ------
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    NSArray *propertyArr = self.attributeDict[@"propertyVOList"];
    return propertyArr.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    NSArray *propertyArr = self.attributeDict[@"propertyVOList"];
    if (propertyArr.count > 0) {
        NSArray *arr = propertyArr[section][@"values"];
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in arr) {
            [muArr addObject:dict[@"propertyValue"]];
        }
        return muArr;
    } else {
        return nil;
    }
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    NSArray *skuArr = self.attributeDict[@"skuList"];
    return skuArr.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    NSArray *arr = self.attributeDict[@"skuList"][row][@"propertyVOList"];
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [muArr addObject:dict[@"propertyValue"]];
    }
    return muArr;
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    return self.attributeDict[@"skuList"][row];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    [self.titleView selectTitleWithIndex:index];
    if (index == 0) {
        self.navView.alpha = self.alpha;
        self.rbackBtn.alpha = 1-self.alpha;
        self.rcarBtn.alpha = 1-self.alpha;
    } else {
        self.navView.alpha = 1;
        self.rbackBtn.alpha = 0;
        self.rcarBtn.alpha = 0;
    }
    [self switchViewWithIndex:index];
}

#pragma mark ------ 获取商品数据 ------
- (void)getGoodsData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    if ([ADLUserModel sharedModel].login) {
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    }
    [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *goodsDict = responseDict[@"data"];
            
            if (self.orderDict[@"goodsId"] == nil) {
                //商品图片
                NSMutableArray *goodsImgArr = goodsDict[@"goodsImgList"];
                if (goodsImgArr.count == 0) {
                    NSDictionary *imgDict = @{@"imgUrl":@""};
                    [goodsImgArr addObject:imgDict];
                }
                if ([[goodsDict[@"thumbnailUrl"] stringValue] hasPrefix:@"http"]) {
                    self.goodsImg = goodsDict[@"thumbnailUrl"];
                } else {
                    self.goodsImg = goodsImgArr.firstObject[@"imgUrl"];
                }
                
                NSString *goodsName = goodsDict[@"goodsName"];
                CGFloat nameH = [ADLUtils calculateString:goodsName rectSize:CGSizeMake(SCREEN_WIDTH-24, 40) fontSize:16].height;
                NSString *goodsTitle = goodsDict[@"goodsTitle"];
                CGFloat titleH = [ADLUtils calculateString:goodsTitle rectSize:CGSizeMake(SCREEN_WIDTH-24, 32) fontSize:13].height;
                
                double timestamp = [goodsDict[@"activity"][@"endTime"] doubleValue];
                ADLGoodsHeaderView *headerView;
                if (timestamp == 0) {
                    headerView = [ADLGoodsHeaderView headerViewWithHeight:titleH+nameH+SCREEN_WIDTH+59 imgUrls:[ADLUtils dictArrayToArray:goodsImgArr key:@"imgUrl"] activity:NO];
                } else {
                    headerView = [ADLGoodsHeaderView headerViewWithHeight:titleH+nameH+SCREEN_WIDTH+90 imgUrls:[ADLUtils dictArrayToArray:goodsImgArr key:@"imgUrl"] activity:YES];
                    headerView.timestamp = timestamp;
                    [headerView updateActivityGoodsTime:YES];
                }
                [headerView updateGoodsName:goodsName goodsTitle:goodsTitle];
                self.goodsView.tableView.tableHeaderView = headerView;
                self.headerView = headerView;
                headerView.delegate = self;
                
                [self getEvaluateCount];
                [self getEvaluateData];
                [self getRelevantGoods:goodsDict[@"classId"]];
                if ([ADLUserModel sharedModel].login) {
                    [self getAddressData];
                }
                
                //详情图片
                NSArray *imgArr = [goodsDict[@"goodsDetails"] componentsSeparatedByString:@","];
                NSMutableArray *detailArr = [[NSMutableArray alloc] init];
                for (NSString *url in imgArr) {
                    if ([url hasPrefix:@"http"]) {
                        [detailArr addObject:url];
                    }
                }
                self.goodsView.detailArr = detailArr;
                
                //商品SKU
                self.attributeDict = [[NSMutableDictionary alloc] init];
                NSArray *skuArr = goodsDict[@"skuList"];
                if (skuArr.count > 0) {
//                    NSMutableArray *validitySkuArr = [[NSMutableArray alloc] init];
//                    for (NSDictionary *skuDict in skuArr) {
//                        if ([skuDict[@"inventory"] intValue] > 0) {
//                            [validitySkuArr addObject:skuDict];
//                        }
//                    }
                    [self.attributeDict setValue:skuArr forKey:@"skuList"];
                    [self.attributeDict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                }
                
                //选择默认属性
                double price = 0.0;
                double money = 0.0;
                self.filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
                self.filter.needDefaultValue = YES;
                self.selectDict = [[NSMutableDictionary alloc] init];
                self.orderDict = [[NSMutableDictionary alloc] init];
                [self.orderDict setValue:goodsName forKey:@"goodsName"];
                [self.orderDict setValue:goodsDict[@"id"] forKey:@"goodsId"];
                [self.orderDict setValue:self.orderId forKey:@"serviceOrderId"];
                [self.orderDict setValue:@[] forKey:@"services"];
                if (self.filter.currentResult == nil) {
                    self.sellout = YES;
                    if (skuArr.count > 0) {
                        NSDictionary *firstSkuDict = skuArr.firstObject;
                        if ([firstSkuDict[@"activityInfo"][@"activityPrice"] doubleValue] > 0) {
                            price = [firstSkuDict[@"activityInfo"][@"activityPrice"] doubleValue];
                            money = [firstSkuDict[@"price"] doubleValue];
                        } else {
                            price = [firstSkuDict[@"nowPrice"] doubleValue];
                        }
                    }
                    [self.selectDict setValue:self.goodsImg forKey:@"skuImgUrl"];
                    [headerView updatePrice:price money:money inventory:@"剩余0件"];
                    [headerView updateSelectAttribute:@"该商品已全部售完"];
                    
                } else {
                    self.sellout = NO;
                    self.selectDict = self.filter.currentResult;
                    NSArray *selectArr = self.filter.selectedIndexPaths;
                    selectArr = [selectArr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
                        if (obj1.section < obj2.section) {
                            return NSOrderedAscending;
                        } else {
                            return NSOrderedDescending;
                        }
                    }];
                    
                    NSString *selectStr = @"";
                    for (NSIndexPath *indexPath in selectArr) {
                        selectStr = [NSString stringWithFormat:@"%@%@, ",selectStr,self.attributeDict[@"propertyVOList"][indexPath.section][@"values"][indexPath.row][@"propertyValue"]];
                    }
                    selectStr = [selectStr substringToIndex:selectStr.length-2];
                    [self.selectDict setValue:selectStr forKey:@"select"];
                    [self.selectDict setValue:@(1) forKey:@"count"];
                    [self updateSelectAttributes];
                }
                
                ADLGDetailBottomView *bottomView = [ADLGDetailBottomView bottomViewWithCollection:![goodsDict[@"isCollection"] boolValue]];
                [self.view addSubview:bottomView];
                bottomView.delegate = self;
                self.bottomView = bottomView;
                [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-BOTTOM_H);
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@(50));
                }];
                self.goodsView.hidden = NO;
                [self setupPromptView];
                
            } else {
                [self.bottomView updateCollectionStatus:![goodsDict[@"isCollection"] boolValue]];
            }
        }
    } failure:nil];
}

#pragma mark ------ 更新选择的商品 ------
- (void)updateSelectAttributes {
    double price = 0.0;
    double money = 0.0;
    int buyNum = 0;
    if ([self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue] > 0) {
        price = [self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue];
        buyNum = [self.selectDict[@"activityInfo"][@"userBuyNum"] intValue];
        money = [self.selectDict[@"price"] doubleValue];
    } else {
        price = [self.selectDict[@"nowPrice"] doubleValue];
    }
    
    if (!self.selectDict[@"skuImgUrl"]) {
        [self.selectDict setValue:self.goodsImg forKey:@"skuImgUrl"];
    }
    
//    NSString *inventory;
//    if (buyNum == 0) {
//        inventory = [NSString stringWithFormat:@"剩余%@件",self.selectDict[@"inventory"]];
//    } else {
//        inventory = [NSString stringWithFormat:@"剩余%@件,每人限购%d件",self.selectDict[@"inventory"],buyNum];
//    }

    [self.headerView updatePrice:price money:money inventory:@""];
    [self.headerView updateSelectAttribute:[NSString stringWithFormat:@"%@, %@件",self.selectDict[@"select"],self.selectDict[@"count"]]];
    
    [self.orderDict setValue:self.selectDict[@"activityInfo"] forKey:@"activityGoods"];
    [self.orderDict setValue:self.selectDict[@"nowPrice"] forKey:@"newPrice"];
    [self.orderDict setValue:self.selectDict[@"select"] forKey:@"attribute"];
    [self.orderDict setValue:self.selectDict[@"inventory"] forKey:@"nowNum"];
    [self.orderDict setValue:self.selectDict[@"skuImgUrl"] forKey:@"imgUrl"];
    [self.orderDict setValue:self.selectDict[@"price"] forKey:@"price"];
    [self.orderDict setValue:self.selectDict[@"count"] forKey:@"num"];
    [self.orderDict setValue:self.selectDict[@"id"] forKey:@"skuId"];
    
    [self getSkuDetail:self.selectDict[@"id"]];
}

#pragma mark ------ 查询所选SKU的规格详情 ------
- (void)getSkuDetail:(NSString *)skuId {
    if (skuId.length > 2) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.goodsId forKey:@"goodsId"];
        [params setValue:skuId forKey:@"skuId"];
        [ADLNetWorkManager postWithPath:k_goods_sku_detail parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSArray *specArr = responseDict[@"data"][@"propertyList"];
                NSArray *skuArr = responseDict[@"data"][@"sku"][@"propertyVOList"];
                NSMutableArray *specHArr = [[NSMutableArray alloc] init];
                if (specArr.count > 0) {
                    for (NSDictionary *dict in specArr) {
                        CGFloat specH = [ADLUtils calculateString:dict[@"propertyValue"] rectSize:CGSizeMake(SCREEN_WIDTH*0.7-48, MAXFLOAT) fontSize:FONT_SIZE].height+28;
                        [specHArr addObject:@(specH)];
                    }
                } else {
                    for (int i = 0; i < skuArr.count; i++) {
                        [specHArr addObject:@(VIEW_HEIGHT)];
                    }
                }
                
                if (specArr.count > 0) {
                    self.goodsView.specArr = specArr;
                } else {
                    self.goodsView.specArr = skuArr;
                }
                self.goodsView.specHArr = specHArr;
                [self.goodsView.tableView reloadData];
            }
        } failure:nil];
    }
}

#pragma mark ------ 获取推荐的商品 ------
- (void)getRelevantGoods:(NSString *)classId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:classId forKey:@"classId"];
    [ADLNetWorkManager postWithPath:k_goods_relevant parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *goodsArr = responseDict[@"data"];
            if (goodsArr.count > 0) {
                NSMutableArray *relevantArr = [[NSMutableArray alloc] init];
                NSMutableArray *relevantHArr = [[NSMutableArray alloc] init];
                for (NSMutableDictionary *dict in goodsArr) {
                    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
                    if ([[dict[@"thumbnailUrl"] stringValue] hasPrefix:@"http"]) {
                        [muDict setValue:dict[@"thumbnailUrl"] forKey:@"goodsImg"];
                    } else {
                        [muDict setValue:@"" forKey:@"goodsImg"];
                    }
                    [muDict setValue:dict[@"id"] forKey:@"goodsId"];
                    [muDict setValue:dict[@"goodsName"] forKey:@"goodsName"];
                    [muDict setValue:dict[@"advicePrice"] forKey:@"advicePrice"];
                    [relevantArr addObject:muDict];
                    
                    CGFloat nameH = [ADLUtils calculateString:dict[@"goodsName"] rectSize:CGSizeMake((SCREEN_WIDTH-28)/2-16, MAXFLOAT) fontSize:15].height;
                    if (nameH > 40) nameH = 36;
                    [relevantHArr addObject:@(nameH+(SCREEN_WIDTH-28)/2+39)];
                }
                self.relevantArr = relevantArr;
                self.relevantHArr = relevantHArr;
                [self.headerView updateRelevantGoods:relevantArr];
                self.goodsView.tableView.tableHeaderView = self.headerView;
            }
        }
    } failure:nil];
}

#pragma mark ------ LS-10认证信息 ------
- (void)getGoodsLSInformation {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [ADLNetWorkManager postWithPath:k_goods_ls_information parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSString *cerStr = responseDict[@"data"][@"imgUrl"];
            NSString *videoStr = responseDict[@"data"][@"videoUrl"];
            NSArray *repArr = [responseDict[@"data"][@"reportImgUrl"] componentsSeparatedByString:@","];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([cerStr hasPrefix:@"http"]) {
                    self.goodsView.cerUrl = cerStr;
                }
                if ([videoStr hasPrefix:@"http"]) {
                    VideoInfo videoInfo = [ADLUtils getVideoInfoWithUrlStr:videoStr orPathUrl:nil];//阻塞主线程
                    self.goodsView.previewImage = videoInfo.thumbnail;
                    self.goodsView.videoDuration = videoInfo.duration;
                    self.goodsView.videoUrl = videoStr;
                }
                if (repArr.count > 0) {
                    NSMutableArray *reportArr = [[NSMutableArray alloc] init];
                    for (NSString *url in repArr) {
                        if ([url hasPrefix:@"http"]) {
                            [reportArr addObject:url];
                        }
                    }
                    if (reportArr.count > 0) {
                        self.goodsView.reportArr = reportArr;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.goodsView.tableView reloadData];
                });
            });
        }
    } failure:nil];
}

#pragma mark ------ 获取评价数量 ------
- (void)getEvaluateCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [ADLNetWorkManager postWithPath:k_goods_evaluate_count parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.headerView updateEvaluateCount:responseDict[@"data"]];
        }
    } failure:nil];
}

#pragma mark ------ 获取评价内容 ------
- (void)getEvaluateData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    if ([ADLUserModel sharedModel].login) {
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    }
    [ADLNetWorkManager postWithPath:k_goods_evaluate_list parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *evaArr = responseDict[@"data"][@"rows"];
            if (evaArr.count > 0) {
                NSMutableArray *evaluateArr = [[NSMutableArray alloc] init];
                NSMutableArray *evaluateHArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < evaArr.count; i++) {
                    NSMutableDictionary *dict = evaArr[i];
                    CGFloat evaluateH = [ADLUtils calculateString:dict[@"evaluateInfo"] rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:14].height+100;
                    NSArray *imgUrlArr = [dict[@"imgUrl"] componentsSeparatedByString:@","];
                    evaluateH = evaluateH+[self calculateEvaluateCellHeight:imgUrlArr.count];
                    [dict setValue:imgUrlArr forKey:@"imgArr"];
                    [evaluateHArr addObject:@(evaluateH)];
                    [evaluateArr addObject:dict];
                    if (i == 1) {
                        break;
                    }
                }
                [self.headerView updateEvaluateInfWithEvaluateArr:evaluateArr heiArr:evaluateHArr];
                self.goodsView.tableView.tableHeaderView = self.headerView;
            }
        }
    } failure:nil];
}

#pragma mark ------ 计算评论cell高度 ------
- (CGFloat)calculateEvaluateCellHeight:(NSInteger)count {
    switch (count) {
        case 0:
            return 0;
            break;
        case 1:
        case 2:
            return 150;
            break;
        case 3:
            return 116;
            break;
        case 4:
            return 244;
            break;
        case 5:
        case 6:
            return 216;
            break;
        default:
            return 316;
            break;
    }
}

#pragma mark ------ 收货地址 ------
- (void)getAddressData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_address_list parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *addArr = responseDict[@"data"];
            [self.addressArr removeAllObjects];
            NSString *addressId = self.addressDict[@"id"];
            self.addressDict = nil;
            if (addArr.count > 0) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (NSMutableDictionary *dict in addArr) {
                        AddressInfo info = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"areaId"] stringValue]];
                        [dict setValue:info.cityId forKey:@"cityId"];
                        [dict setValue:[NSString stringWithFormat:@"%@%@",info.address,dict[@"address"]] forKey:@"fullAddress"];
                        if ([dict[@"isDefault"] integerValue] == 0) {
                            [self.addressArr insertObject:dict atIndex:0];
                        } else {
                            [self.addressArr addObject:dict];
                        }
                        if ([[dict[@"id"] stringValue] isEqualToString:addressId]) {
                            self.addressDict = dict;
                        }
                    }
                    if (self.addressDict == nil) {
                        self.addressDict = self.addressArr.firstObject;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.headerView updateShipAddress:self.addressDict[@"fullAddress"]];
                        [self getLockServiceData];
                    });
                });
            } else {
                [self.headerView updateShipAddress:@"请添加配送地址"];
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取服务信息 ------
- (void)getLockServiceData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.addressDict[@"cityId"] forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_install_lock_cost parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.attributeDict setValue:responseDict[@"data"] forKey:@"serviceList"];
        } else {
            [self.attributeDict setValue:nil forKey:@"serviceList"];
        }
        [self.selectDict setValue:nil forKey:@"service"];
    } failure:nil];
}

#pragma mark ------ 播放视频 ------
- (void)playVideoWithUrl:(NSString *)videoUrl {
    NSString *filename = [NSString stringWithFormat:@"%@.%@",[ADLUtils md5Encrypt:videoUrl lower:YES],[videoUrl componentsSeparatedByString:@"."].lastObject];
    NSString *filePath = [ADLUtils filePathWithName:filename permanent:NO];
    if (filePath) {
        self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    } else {
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoUrl]];
        self.downloadTask = [ADLNetWorkManager downloadFilePath:videoUrl progress:nil success:nil failure:nil];
    }
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = self.player;
    [self.player play];
    [self presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark ------ 懒加载 ------
- (ADLGoodsDetailView *)detailView {
    if (_detailView == nil) {
        _detailView = [[ADLGoodsDetailView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H-50)];
        [self.scrollView addSubview:_detailView];
        __weak typeof(self)weakSelf = self;
        _detailView.clickVideo = ^(NSString *videoUrl) {
            [weakSelf playVideoWithUrl:videoUrl];
        };
    }
    return _detailView;
}

- (ADLGoodsEvaluateView *)evaluateView {
    if (_evaluateView == nil) {
        _evaluateView = [[ADLGoodsEvaluateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H-50) goodsId:self.goodsId];
        [self.scrollView addSubview:_evaluateView];
        _evaluateView.delegate = self;
    }
    return _evaluateView;
}

- (ADLGoodsRelevantView *)relevantView {
    if (_relevantView == nil) {
        _relevantView = [[ADLGoodsRelevantView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H-50)];
        [self.scrollView addSubview:_relevantView];
        __weak typeof(self)weakSelf = self;
        _relevantView.clickRelevantGoods = ^(NSString *goodsId) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.goodsId = goodsId;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        };
    }
    return _relevantView;
}

- (NSMutableArray *)addressArr {
    if (_addressArr == nil) {
        _addressArr = [[NSMutableArray alloc] init];
    }
    return _addressArr;
}

- (void)dealloc {
    if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self.downloadTask cancel];
    }
}

@end
