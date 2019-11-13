//
//  ADLOrderDinnerController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderDinnerController.h"
#import "ADLBannerView.h"
#import "ADLTableView.h"
#import "ADLDinnerListController.h"

#import "ADLCommentVController.h"

@interface ADLOrderDinnerController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *textfield;
@property (nonatomic, strong) UIScrollView  *scrollView;
//@property (nonatomic, strong) ADLBannerView *bannerView;    //轮播图view
@property (nonatomic, strong) ADLTableView  *TabView;
@property (nonatomic, assign) NSInteger     typeIndex;      //商家排列方式
@property (nonatomic, assign) NSInteger currentPage;    //当前页
@property (nonatomic, assign) NSInteger totalPage;      //总页数

@end

@implementation ADLOrderDinnerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavView];
    [self createScrollView];
    [self addBannerView];
    [self addTabView];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self LoadData];    //请求数据
}

- (void)createNavView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H+90)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, STATUS_HEIGHT, 60, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"点餐";
    titLab.text = (self.goodsType == 0)?@"美食":@"特产";
    [navView addSubview:titLab];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, NAVIGATION_H, 18, 24)];
    imgV.image = [UIImage imageNamed:@"icon_da"];
    [navView addSubview:imgV];
    
    
    //位置
    UILabel *posLab = [[UILabel alloc] initWithFrame:CGRectMake(40, NAVIGATION_H, SCREEN_WIDTH-45, 24)];
    posLab.textAlignment = NSTextAlignmentLeft;
    posLab.font = [UIFont systemFontOfSize:15];
    posLab.textColor = [UIColor whiteColor];
    //    posLab.text = ADLString(@"order");
    posLab.text = (self.hotalAddress.length != 0)?self.hotalAddress:@"未知酒店地址";
    [navView addSubview:posLab];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+37, SCREEN_WIDTH-40, 40)];
    bgView.layer.cornerRadius = 8.0;
    bgView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:bgView];
    
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-70, 8, 24, 24)];
    searchImg.image = [UIImage imageNamed:@"icon_rmsg_serach"];
    [bgView addSubview:searchImg];
    
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-40, 0, SCREEN_WIDTH*2/3+20, 40)];
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtField.font = [UIFont systemFontOfSize:FONT_SIZE];
    txtField.returnKeyType = UIReturnKeySearch;
    txtField.placeholder = @"请输入商家或者商品名称";
    [bgView addSubview:txtField];
    txtField.delegate = self;
    self.textfield = txtField;
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+90, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-90)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
//    __weak typeof(self)weakSelf = self;
//    scrollView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
//        NSLog(@"下拉刷新 !!!");
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([weakSelf.scrollView.mj_header isRefreshing]) {
//                [weakSelf.scrollView.mj_header endRefreshing];
//            }
//        });
//    }];
}
#pragma mark ------ 添加搜索、轮播图 ------
- (void)addBannerView {
    //轮播图
/*    ADLBannerView *bannerView = [ADLBannerView bannerViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.0) timeInterval:3];
    bannerView.broken = NO;
    [self.scrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    __weak typeof(self)weakSelf = self;
    bannerView.clickImage = ^(NSString *urlStr) {
        if (urlStr.length > 0) {
            if ([ADLUtils isPureInt:urlStr]) {
                
            } else {
                if ([urlStr hasPrefix:@"http"]) {
                    
                }
            }
        }
    };
    
    //判断本地是否缓存有轮播数据
    NSArray *cacheArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:HOME_BANNER permanent:NO]];
    NSMutableArray *imgArr = [ADLUtils dictArrayToArray:cacheArr key:@"bannerImgUrl"];
    //    NSLog(@"本地轮播图集合: imgArr = %@", imgArr);
    if (imgArr.count > 0) {
        [self.bannerView updateBanner:imgArr dataArr:cacheArr];
    }*/
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.0)];
    imgView.image = [UIImage imageNamed:@"banner"];
    [self.scrollView addSubview:imgView];
}
- (void)addTabView {
    self.currentPage = 1;
    self.totalPage   = 1;
    self.typeIndex   = 0;
    
    
    __weak typeof(self)WeakSelf = self;
    
    ADLTableView *tabView = [[ADLTableView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/3, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/3-NAVIGATION_H-90)];
    [self.scrollView addSubview:tabView];
    tabView.itemArray = [[NSMutableArray alloc] init];
    self.TabView = tabView;
    
    //下拉刷新
    tabView.tableViewHeaderRefreshBlock = ^{
        //清空数据
        [WeakSelf.TabView.itemArray removeAllObjects];
        [WeakSelf.TabView.table reloadData];
        
        //数据归零
        self.currentPage = 1;
        self.totalPage   = 1;
        [WeakSelf LoadData];//请求数据
    };
    
    //上拉刷新更多
    tabView.scrollToBottom = ^{
        [WeakSelf LoadData];//请求数据
    };
    
    tabView.didClickbtnBlock = ^(NSInteger index) {
//        NSLog(@"商家排列方式: index = %zd", index);
        [WeakSelf.TabView.itemArray removeAllObjects];
        [WeakSelf.TabView.table reloadData];
        
        //数据归零
        self.currentPage = 1;
        self.totalPage   = 1;
        
        WeakSelf.typeIndex = index;
        [WeakSelf LoadData];//请求数据
    };
    
    tabView.didSelectedRow = ^(NSInteger index) {
        ADLDinnerListController *vc = [[ADLDinnerListController alloc] init];
        vc.vcTitle = [WeakSelf.TabView.itemArray[index]   objectForKey:@"name"];
        vc.storeId = [WeakSelf.TabView.itemArray[index]   objectForKey:@"id"];
        vc.stoImgUrl = [[WeakSelf.TabView.itemArray[index] objectForKey:@"storeLogo"] stringValue];
        vc.businessStatus = [WeakSelf.TabView.itemArray[index] objectForKey:@"businessStatus"];
        [WeakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark ------ 获取商家列表信息 ------
- (void)LoadData {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.hotalAddress forKey:@"userAddress"];
    [params setValue:@(self.goodsType) forKey:@"goodsType"]; //0表示餐饮; 1表示特产
    [params setValue:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"page"];
    [params setValue:@"5" forKey:@"pageSize"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
   
    if (self.typeIndex != 0) {//设置商家排列方式
        [params setValue:[NSString stringWithFormat:@"%zd", self.typeIndex-1] forKey:@"sortWay"];
    }
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/store/queryAroundStoreList.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        if ([self.TabView.table.mj_header isRefreshing]) {
            [self.TabView.table.mj_header endRefreshing];
        }
        if ([self.TabView.table.mj_footer isRefreshing]) {
            [self.TabView.table.mj_footer endRefreshing];
        }
        
        [ADLToast hide];
        
        NSLog(@"请求商家数据返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            NSArray *storeArr = responseDict[@"data"];
            if (storeArr.count != 0) {//有数据
                self.currentPage += 1;
                self.totalPage = [responseDict[@"totalPage"] integerValue];
                
                for (NSDictionary *dict in storeArr) {
                    [self.TabView.itemArray addObject:dict];
                }
                [self.TabView.table reloadData];
            }
            
            self.TabView.table.mj_footer.hidden = (self.currentPage > self.totalPage)?YES:NO;
        }
    } failure:^(NSError *error) {
//        NSLog(@"error ---> %@", error);
        
        if ([self.TabView.table.mj_header isRefreshing]) {
            [self.TabView.table.mj_header endRefreshing];
        }
        if ([self.TabView.table.mj_footer isRefreshing]) {
            [self.TabView.table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
//    if (self.textfield.text.length != 0) {
//        [self.TabView.itemArray removeAllObjects];
//        [self.TabView.table reloadData];
//        
//        self.TabView.table.mj_footer.hidden = NO;
//        //数据归零
//        self.currentPage = 1;
//        self.totalPage   = 1;
//        
//        [self LoadData];//请求数据
//    }
    
    
    return YES;
}

//- (void)dealloc {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}


@end

