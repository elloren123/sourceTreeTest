//
//  ADLHotelListController.m
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelListController.h"
#import "ADLHomeSearchView.h"
#import "ADLHotelListHeadView.h"
#import "ADLBookingHotelTableViewCell.h"
#import "ADLListsortingView.h"
#import "ADLSearchHoterController.h"
#import "ADLHotelDetailsController.h"
#import "ADLBookingHotelModel.h"


@interface ADLHotelListController ()<ADLHomeSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,ADLListsortingViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,strong)ADLHomeSearchView *searchView;
@property (nonatomic ,strong)ADLHotelListHeadView *headView;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,copy)NSString *order;//1：距离优先，2：低价优先，3：高价优先，4：好评优先，5：推荐优先
@end

@implementation ADLHotelListController
//Longitude
//Latitude
//areaName
- (void)viewDidLoad {
    [super viewDidLoad];
    //searchType;//1模糊搜索  2精确搜索结果 3精品推荐
    if ([self.searchType isEqualToString:@"1"]) {
        self.order = @"1";
        [self.view addSubview:self.searchView];
        [self.view addSubview:self.headView];
        self.params[@"keyword"] = self.navTitle;
        self.params[@"order"] = self.order;//排序：1：距离优先，2：低价优先，3：高价优先，4：好评优先，5：推荐优先
        self.params[@"longitudes"] =self.cityDict[@"Longitude"];//经度
        self.params[@"latitudes"] =self.cityDict[@"Latitude"];//纬度
        self.params[@"cityName"] = self.cityDict[@"areaName"];//城市：默认北京
        self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.headView.frame),SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H - self.headView.height);
        
        [self searchHotendata];
        WS(ws);

        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws.dataArray removeAllObjects];
            ws.page = 0;
            ws.tableView.mj_footer.hidden = NO;
            [ws searchHotendata];
        }];
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.page ++;
            [ws searchHotendata];
        }];
        
        
        self.page = 0;

    }else   if ([self.searchType isEqualToString:@"2"]){
   
          [self addNavigationView:ADLString(@"搜索结果")];
          self.tableView.frame = CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H);
        
        [self searchHotendata];
        WS(ws);
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws.dataArray removeAllObjects];
            ws.page = 0;

          ws.tableView.mj_footer.hidden = NO;
            [ws searchHotendata];
        }];
        //  [self.tableView.mj_header beginRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.page ++;
            [ws searchHotendata];
        }];
        self.page = 0;
        
    }else   if ([self.searchType isEqualToString:@"3"]){
        
        [self addNavigationView:ADLString(@"精品推荐")];
        self.tableView.frame = CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H);
    }

    
    
    [self.view addSubview:self.tableView];
    
  
}

-(NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark ------ 按照条件搜索酒店-----
- (void)searchHotendata {
//    cityName = "\U6df1\U5733";
//    endtPrice = 2000;
//    keyword = "";
//    latitudes = "22.547000";
//    longitudes = "114.085947";
//    order = 1;
//    page = 0;
//    seq = 0253110600388040;
//    sign = BF64591142AED441112A98C7048CE0C1;
//    star = "1,2,3,4,5,6,7";
//    startPrice = 0;
//    timestamp = 1571900205213;
    self.params[@"page"] = @(self.page);//分页
    self.params[@"sign"] = [ADLUtils handleParamsSign:self.params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_searchcompany parameters:self.params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableArray *array =  [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (array.count > 0) {
                [ws.dataArray addObjectsFromArray:array];
                //                "currentPage": "int 当前页码",
                //                "totalPage": "int 总页数"
                if (ws.dataArray.count == [responseDict[@"totalPage"] integerValue]) {
                    ws.tableView.mj_footer.hidden = YES;
                    ws.tableView.tableFooterView.hidden = NO;
                }
                
            }else {
                ws.tableView.tableFooterView.hidden = YES;;
                ws.tableView.mj_footer.hidden = YES;
            }
                  // [ws.tableView reloadData];
        }
         [ws.tableView reloadData];
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLBookingHotelTableViewCell *cell = [ADLBookingHotelTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  180;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.searchView.textField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADLHotelDetailsController *vc = [[ADLHotelDetailsController alloc]init];
    vc.model =self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ------ ADLHomeSearchViewDelegate ------
- (void)didClickBackBtn {
    [self customPopViewController];
}
#pragma mark ------ ADLHomeSearchViewDelegate ------
- (void)didClickHomeSearchView:(NSInteger)index {
    WS(ws);
    if (index == 0) {
        ADLSearchHoterController *goodsVC = [[ADLSearchHoterController alloc] init];
        goodsVC.PopView = YES;
        goodsVC.searchContentBlock = ^(NSString * _Nonnull str) {
            ws.searchView.phLabel.text = str;
            //搜索
            [ws.tableView reloadData];
        };
        
        [self customPushViewController:goodsVC];
    } else {
        if ([ADLUserModel sharedModel].login) {
            
        } else {
            [self pushLoginViewControllerHideTabbar:YES success:nil];
        }
    }
}

-(ADLHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [ADLHomeSearchView searchViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, NAVIGATION_H) delegate:self];
        _searchView.phLabel.text = self.title;
        _searchView.phLabel.text = self.navTitle;
        _searchView.newsBtn.hidden = YES;
        [_searchView hideLogo];
        // _searchView.backgroundColor = [UIColor yellowColor];
    }
    return  _searchView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self.searchView.textField resignFirstResponder];
}

-(void)ListsortingView:(ADLListsortingView *)ListsortingView didSelectRowAtIndexPath:(NSIndexPath *)indexPath iphone:(NSString *)iphone {
    self.page = 1;
    self.order = [NSString stringWithFormat:@"%ld",indexPath.row + 1];//排序：1：距离优先，2：低价优先，3：高价优先，4：好评优先，5：推荐优先
        [self searchHotendata];
    
    
}
-(ADLHotelListHeadView *)headView {
    if (!_headView) {
       WS(ws);
        _headView = [[ADLHotelListHeadView alloc]initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 40)];
        _headView.blockBtn = ^(UIButton *btn) {
            
            __block ADLListsortingView *fameiyLockView = [[ADLListsortingView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT) navigheight:NAVIGATION_H+40];
            fameiyLockView.delegate = ws;
            fameiyLockView.array = @[ADLString(@"距离优先"),ADLString(@"低价优先"),ADLString(@"高价优先"),ADLString(@"好评优先"),ADLString(@"推荐优先")];
        };
    }
    return _headView;
}
-(UITableView *)tableView {
    if (!_tableView) {
           _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      //  _tableView.bounces = NO;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        //_tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        // _tableView.alpha = 0.7;
       // _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}

@end
