//
//  ADLBookingHotelController.m
//  lockboss
//
//  Created by adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBookingHotelController.h"
#import "ADLBookingHotelTableViewCell.h"
#import "ADLHomeSearchView.h"
#import "ADLBannerView.h"
#import "ADLScreeningTableView.h"
#import "ADLPreferentialHotelView.h"
#import "ADLSelectCityController.h"
#import "HZCalendarViewController.h"
#import "ADLScreeningStarView.h"
#import "ADLSearchHoterController.h"
#import "ADLHotelDetailsController.h"
#import "ADLHotelCollectController.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelListController.h"
#import "ADLHotelOrderListController.h"

@interface ADLBookingHotelController ()<ADLHomeSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,ADLScreeningTableViewDelegate,ADLPreferentialHotelViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,weak)UIView *headView;
@property (nonatomic ,strong)ADLHomeSearchView *searchView;
@property (nonatomic, strong) ADLBannerView *bannerView;
@property (nonatomic ,strong)ADLScreeningTableView *screeningView;
@property (nonatomic ,strong)ADLPreferentialHotelView *hotelView;
@property (nonatomic ,strong)NSMutableDictionary *cityDict;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSMutableArray *array;

@end

@implementation ADLBookingHotelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,self.bannerView.height + self.screeningView.height + self.hotelView.height)];
    self.headView = headView;
    self.tableView.tableHeaderView = self.headView;
    
    [self.headView addSubview:self.bannerView];
    [self.headView addSubview:self.screeningView];
    [self.headView addSubview:self.hotelView];
    
    self.page = 0;
    [self boutiquecompany];
    [self searchHotendata];
    [self getBannerData];
    
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.array removeAllObjects];
        ws.page = 0;
        ws.tableView.tableFooterView.hidden = YES;
        ws.tableView.mj_footer.hidden = NO;
        [ws searchHotendata];
        [ws boutiquecompany];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.page ++;
        [ws searchHotendata];
    }];
    
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(NSMutableDictionary *)cityDict {
    if (!_cityDict) {
        _cityDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Longitude":@"116.405285",
                                                                    @"Latitude":@"39.904989",
                                                                    @"areaName":@"北京"
                                                                    }];
    }
    return _cityDict;
}
#pragma mark ------ 精品推荐酒店------
- (void)boutiquecompany {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_boutiquecompan parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            ws.hotelView.array =  [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            
        }
    } failure:nil];
}
#pragma mark ------ 按照附近条件搜索酒店-----
- (void)searchHotendata {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *Price=[self.screeningView.contArray[2] componentsSeparatedByString:@"-"];
    params[@"keyword"] =@"";//关键字
    params[@"startPrice"] =[Price[0] stringByReplacingOccurrencesOfString:@"¥"withString:@""];//删除 ;//开始价格 startPrice和endtPrice 必须是成对出现
    params[@"endtPrice"] =[Price[1] stringByReplacingOccurrencesOfString:@"¥"withString:@""];//结束价格 startPrice和endtPrice 必须是成对出现
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int remainSecond =[[self.screeningView.titleArray[2] stringByTrimmingCharactersInSet:nonDigits] intValue];
    if (remainSecond == 0) {
        params[@"star"] =@"1,2,3,4,5,6,7";//星级
    }else {
        params[@"star"] =@(remainSecond);//星级
    }
    params[@"order"] =@"1";//排序：1：距离优先，2：低价优先，3：高价优先，4：好评优先，5：推荐优先
    
    ADLUserModel * mode= [ADLUserModel readUserModel];
    //选择当前定位地址
    if (mode.city.length > 0) {
        [self.cityDict setValue:mode.city forKey:@"areaName"];
        [self.cityDict setValue:mode.Longitude forKey:@"Longitude"];
        [self.cityDict setValue:mode.Latitude forKey:@"Latitude"];
    }
    params[@"longitudes"] =self.cityDict[@"Longitude"];//经度
    params[@"latitudes"] =self.cityDict[@"Latitude"];//纬度
    params[@"cityName"] = self.cityDict[@"areaName"];//城市：默认北京
    params[@"page"] = @(self.page);//分页
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_searchcompany parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableArray *array =  [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (array.count > 0) {
                [self.array addObjectsFromArray:array];
                
                if (array.count < 20)  {
                    ws.tableView.mj_footer.hidden = YES;
                    ws.tableView.tableFooterView.hidden = NO;
                }
            }else {
                ws.tableView.tableFooterView.hidden = YES;;
                ws.tableView.mj_footer.hidden = YES;
            }
        }
        [ws.tableView reloadData];
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLBookingHotelTableViewCell *cell = [ADLBookingHotelTableViewCell cellWithTableView:tableView];
    cell.model = self.array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  180;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADLHotelDetailsController *vc = [[ADLHotelDetailsController alloc]init];
    vc.model =self.array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma   mark ----ADLPreferentialHotelViewDelegate
-(void)ADLPreferentialHotelVie:(ADLPreferentialHotelView *)ListsortingView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLHotelDetailsController *vc = [[ADLHotelDetailsController alloc]init];
    vc.model =self.hotelView.array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ------ ADLHomeSearchViewDelegate ------
- (void)didClickHomeSearchView:(NSInteger)index {
    if (index == 0) {
        ADLSearchHoterController *goodsVC = [[ADLSearchHoterController alloc] init];
        goodsVC.cityDict = self.cityDict;
        [self customPushViewController:goodsVC];
    } else {
        if ([ADLUserModel sharedModel].login) {
            
        } else {
            [self pushLoginViewControllerHideTabbar:YES success:nil];
        }
    }
}

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)screeningTableView:(ADLScreeningTableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(ws);
    if (indexPath.row == 0) {
        
        ADLSelectCityController *VC = [[ADLSelectCityController alloc] init];
        VC.addresBlock = ^(NSMutableDictionary *addresDict)  {
            ws.cityDict = addresDict;
            ws.screeningView.contArray[0] =addresDict[@"areaName"];
            [ws.screeningView.tableView reloadData];
        };
        
        [self.navigationController pushViewController:VC animated:YES];
        
    } else if (indexPath.row == 1) {
        HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
            ws.screeningView.startTime =[goDay toString];
            ws.screeningView.endTime =[backDay toString];
            ws.screeningView.contArray[1] =[backDay getWeek];
            ws.screeningView.titleArray[1] =[goDay getWeek];
            
            [ws.screeningView.tableView reloadData];
            //self.label.text = [NSString stringWithFormat:@"%@/%@",[goDay toString],[backDay toString]];
        }];
        vc.showImageIndex = 30;
        vc.isGoBack = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        __block ADLScreeningStarView *screeningStarView = [[ADLScreeningStarView alloc]init];
        screeningStarView.screeningStarBlock = ^(NSString *price, NSString *price1, NSString *star) {
            ws.screeningView.contArray[2] =[NSString stringWithFormat:@"%@ - %@",price,price1];
            ws.screeningView.titleArray[2] =star;
            [ws.screeningView.tableView reloadData];
        };
        screeningStarView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
    }
}

-(ADLHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [ADLHomeSearchView searchViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, NAVIGATION_H) delegate:self];
        _searchView.phLabel.text = @"搜索酒店名称";
        [_searchView hideLogo];
    }
    return  _searchView;
}

-(ADLBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 200) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    }
    return _bannerView;
}

//酒店筛选
-(ADLScreeningTableView *)screeningView {
    if (!_screeningView) {
        _screeningView = [[ADLScreeningTableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bannerView.frame)+10,SCREEN_WIDTH-20, 270)];
        _screeningView.delegate  =self;
        WS(ws);
        _screeningView.blockBtn = ^(UIButton * _Nonnull btn) {
            if (btn.tag  == 0) {
                ADLHotelListController *vc = [[ADLHotelListController alloc]init];
                NSArray *Price=[ws.screeningView.contArray[2] componentsSeparatedByString:@"-"];
                vc.params[@"keyword"] =@"";//关键字
                vc.params[@"startPrice"] =[Price[0] stringByReplacingOccurrencesOfString:@"¥"withString:@""];//删除 ;//开始价格 startPrice和endtPrice 必须是成对出现
                vc.params[@"endtPrice"] =[Price[1] stringByReplacingOccurrencesOfString:@"¥"withString:@""];//结束价格 startPrice和endtPrice 必须是成对出现
                NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                int remainSecond =[[ws.screeningView.titleArray[2] stringByTrimmingCharactersInSet:nonDigits] intValue];
                if (remainSecond == 0) {
                    vc.params[@"star"] =@"1,2,3,4,5,6,7";//星级
                }else {
                    vc.params[@"star"] =@(remainSecond);//星级
                }
                
                vc.params[@"order"] =@"1";//排序：1：距离优先，2：低价优先，3：高价优先，4：好评优先，5：推荐优先
                vc.params[@"longitudes"] =ws.cityDict[@"Longitude"];//经度
                vc.params[@"latitudes"] =ws.cityDict[@"Latitude"];//纬度
                vc.params[@"cityName"] = ws.cityDict[@"areaName"];//城市：默认北京
                vc.searchType = @"2";
                
                [ws.navigationController pushViewController:vc animated:YES];
            }
            
            if (btn.tag  == 1) {
                ADLHotelCollectController *vc = [[ADLHotelCollectController alloc]init];
                vc.titleType = 0;
                [ws.navigationController pushViewController:vc animated:YES];
            }
            if (btn.tag  ==2) {
                ADLHotelOrderListController *vc = [[ADLHotelOrderListController alloc]init];
                [ws.navigationController pushViewController:vc animated:YES];
            }
            
        };
        //   _screeningView.backgroundColor = [UIColor yellowColor];
    }
    return  _screeningView;
}
//精品推荐
-(ADLPreferentialHotelView *)hotelView {
    WS(ws);
    if (!_hotelView) {
        _hotelView = [[ADLPreferentialHotelView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.screeningView.frame)+10,SCREEN_WIDTH-20, 200)];
        _hotelView.delegate = self;
        _hotelView.moreBlock = ^(UIButton * _Nonnull btn) {
            ADLHotelListController *vc = [[ADLHotelListController alloc]init];
            vc.dataArray =ws.hotelView.array;
            vc.cityDict = ws.cityDict;
            vc.searchType = @"3";
            [ws.navigationController pushViewController:vc animated:YES];
        };
    }
    return  _hotelView;
}

-(void)getBannerData {
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.searchView.frame),SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}

@end
