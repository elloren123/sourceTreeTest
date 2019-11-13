//
//  ADLStoreController.m
//  lockboss
//
//  Created by adel on 2019/3/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreController.h"
#import "ADLLimitedController.h"
#import "ADLNewUserController.h"
#import "ADLMorningController.h"
#import "ADLWebViewController.h"
#import "ADLMessageController.h"
#import "ADLActivityController.h"

#import "ADLGoodsClassController.h"
#import "ADLSearchGoodsController.h"
#import "ADLGoodsDetailController.h"

#import "ADLHomeSearchView.h"
#import "ADLStoreClassCell.h"
#import "ADLStoreHeaderView.h"

#import <Masonry.h>

@interface ADLStoreController ()<ADLHomeSearchViewDelegate,ADLStoreHeaderViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADLHomeSearchView *searchView;
@property (nonatomic, strong) ADLStoreHeaderView *headView;
@end

@implementation ADLStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADLHomeSearchView *searchView = [ADLHomeSearchView searchViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) delegate:self];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    if (self.push) {
        [searchView hideLogo];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    ///添加头部视图
    [self addHeadView];
    
    ///UICollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+VIEW_HEIGHT*2+58);
    layout.minimumInteritemSpacing = 2;
    if (SCREEN_WIDTH > 500) {
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-80)/3, (SCREEN_WIDTH-80)/3*0.69+FONT_SIZE+15);
    } else {
        layout.sectionInset = UIEdgeInsetsMake(15, 12, 15, 12);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-40)/3, (SCREEN_WIDTH-40)/3*0.69+FONT_SIZE+15);
    }
    //头部悬停
    //    layout.sectionHeadersPinToVisibleBounds = YES;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.showsVerticalScrollIndicator = NO;
    collectView.delegate = self;
    collectView.dataSource = self;
    [collectView registerClass:[ADLStoreClassCell class] forCellWithReuseIdentifier:@"cell"];
    [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:collectView];
    self.collectionView = collectView;
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    __weak typeof(self)weakSelf = self;
    collectView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageUnreadChangedNotification) name:MESSAGE_UNREAD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChanged:) name:NETWORK_STATUS_CHANGED object:nil];
    
    //查询未读消息
    [self messageUnreadChangedNotification];
    //加载商城数据
    [self loadData];
}

#pragma mark ------ 返回 ------
- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark ------ UICollectionViewDelegate && DataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (headerView.subviews.count == 0) {
        [headerView addSubview:self.headView];
    }
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLStoreClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"iconUrl"]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    cell.titleLab.text = dict[@"className"];
    cell.dxtView.hidden = ![dict[@"systemLock"] boolValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    ADLGoodsClassController *classVC = [[ADLGoodsClassController alloc] init];
    classVC.hidesBottomBarWhenPushed = YES;
    classVC.className = dict[@"className"];
    classVC.classId = dict[@"id"];
    classVC.systemLock = [dict[@"systemLock"] boolValue];
    [self.navigationController pushViewController:classVC animated:YES];
}

#pragma mark ------ 添加头部视图 ------
- (void)addHeadView {
    ADLStoreHeaderView *headView = [ADLStoreHeaderView headViewWithImageArr:@[@"store_xsqg",@"store_xyhzx",@"store_hdpd",@"store_sczb"] titleArr:@[@"限时抢购",@"新用户专享",@"活动频道",@"商城早报"] title:@"分类"];
    headView.delegate = self;
    self.headView = headView;
    
    //判断本地是否缓存有轮播数据
    NSArray *localArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:STORE_BANNER permanent:NO]];
    NSMutableArray *imgArr = [ADLUtils dictArrayToArray:localArr key:@"bannerImgUrl"];
    if (imgArr.count > 0) {
        [headView updateBanner:imgArr dataArr:localArr];
    }
    
    //判断本地是否缓存有分类数据
    NSArray *classArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:STORE_CLASS permanent:NO]];
    if (classArr.count > 0) {
        [self.dataArr addObjectsFromArray:classArr];
    }
}

#pragma mark ------ ADLStoreHeaderViewDelegate ------
- (void)didClickHeadView:(NSInteger)tag {
    switch (tag) {
        case 0: {
            ADLLimitedController *limitVC = [[ADLLimitedController alloc] init];
            limitVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:limitVC animated:YES];
        }
            break;
        case 1: {
            ADLNewUserController *newVC = [[ADLNewUserController alloc] init];
            newVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newVC animated:YES];
        }
            break;
        case 2: {
            ADLActivityController *activityVC = [[ADLActivityController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
        case 3: {
            ADLMorningController *morningVC = [[ADLMorningController alloc] init];
            morningVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morningVC animated:YES];
        }
            break;
    }
}

- (void)didClickBannerView:(NSString *)urlStr {
    if (urlStr.length > 0) {
        if ([ADLUtils isPureInt:urlStr]) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.goodsId = urlStr;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            if ([urlStr hasPrefix:@"http"]) {
                ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
                webVC.hidesBottomBarWhenPushed = YES;
                webVC.urlString = urlStr;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    ///请求商城数据
    [ADLNetWorkManager postWithPath:k_store_page parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        [self.collectionView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *banArr = responseDict[@"data"][@"bannerList"];
            if (banArr.count == 0) {
                [ADLUtils removeObjectWithFileName:STORE_BANNER permanent:NO];
                [self.headView updateBanner:nil dataArr:nil];
            } else {
                [ADLUtils saveObject:banArr fileName:STORE_BANNER permanent:NO];
                [self.headView updateBanner:[ADLUtils dictArrayToArray:banArr key:@"bannerImgUrl"] dataArr:banArr];
            }
            
            NSArray *classArr = responseDict[@"data"][@"classList"];
            if (classArr.count == 0) {
                [ADLUtils removeObjectWithFileName:STORE_CLASS permanent:NO];
            } else {
                NSArray *nonullArr = [ADLUtils dealwithNullDictArr:classArr];
                [self.dataArr addObjectsFromArray:nonullArr];
                [ADLUtils saveObject:nonullArr fileName:STORE_CLASS permanent:NO];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 查询是否有未读消息 ------
- (void)queryUnreadMessage {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(0) forKey:@"stype"];
    [ADLNetWorkManager postWithPath:k_query_unread_msg parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLUserModel sharedModel].read = [responseDict[@"data"][@"isRead"] boolValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_CHANGED object:nil userInfo:nil];
        }
    } failure:nil];
}

#pragma mark ------ 未读消息改变通知 ------
- (void)messageUnreadChangedNotification {
    if (self.searchView.pointView.hidden != [ADLUserModel sharedModel].read) {
        self.searchView.pointView.hidden = [ADLUserModel sharedModel].read;
    }
}

#pragma mark ------ 网络状态改变通知 ------
- (void)networkStateChanged:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"connected"]) {
        [self loadData];
    }
}

@end
