//
//  ADLHotelCollectController.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelCollectController.h"
#import "ADLBookingHotelTableViewCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelDetailsController.h"

@interface ADLHotelCollectController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nameArr;

@property (nonatomic, strong) NSMutableArray *temporaryArr;

@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * deleUrl;

@property (nonatomic, assign) NSInteger integer;

@end

@implementation ADLHotelCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   [self addNavigationView:ADLString(@"收藏夹/历史记录")];
    self.titleType = 0;
     self.view.backgroundColor =COLOR_F7F7F7;
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ADLString(@"收藏夹"),ADLString(@"浏览记录")]];
    segmentedControl.frame = CGRectMake(40, NAVIGATION_H + 20, SCREEN_WIDTH - 80, 45);
    segmentedControl.selectedSegmentIndex = self.titleType;
    segmentedControl.tintColor = COLOR_E0212A;
    self.integer = segmentedControl.selectedSegmentIndex;
    // 设置点击按钮是否选中
    // segmentedControl.momentary = YES;
    [segmentedControl addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    [self.view addSubview:self.tableView];
     [self HotenCommentData:@""];

    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws HotenCommentData:@""];
        [ws.temporaryArr  removeAllObjects];
    } ];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (ws.temporaryArr > 0) {
            ADLBookingHotelModel *model = ws.temporaryArr.lastObject;
            [ws HotenCommentData:model.id];
        }else {
            [ws HotenCommentData:@""];
        }
    }];
    
    
}
#pragma mark ------ 收藏记录  -  浏览记录  ----
- (void)HotenCommentData:(NSString *)strid {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //0收藏夹 1 浏览记录
    NSString *strUrl;
    if (self.titleType == 0) {
      strUrl =ADEL_hotel_favorite_list;
    }else if (self.titleType == 1) {
    strUrl =ADEL_hotel_browsing_list;
    }
      params[@"id"] = strid;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
    
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableArray *array = [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            
            if (array.count > 0) {
                [ws.temporaryArr addObjectsFromArray:array];
                if (array.count < 20) {
                    ws.tableView.tableFooterView.hidden = YES;;
                    ws.tableView.mj_footer.hidden = YES;
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
#pragma mark ------ 删除浏览记录 收藏记录-----
- (void)deleteHotenRecord:(NSIndexPath *)indexPath {
    ADLBookingHotelModel *model = self.temporaryArr[indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //0收藏夹 1 浏览记录
    NSString *strUrl;
    if (self.titleType == 0) {
        strUrl =ADEL_hotel_favorite_delete;
    }else if (self.titleType == 1) {
        strUrl =ADEL_hotel_browsing_delete;
    }
    params[@"id"] =model.id;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
     
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            [ws.temporaryArr removeObjectAtIndex:indexPath.row];
            [ws.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(NSError *error) {
        
        
    }];
}
-(void)segmentedControl:(UISegmentedControl *)segmented{
    self.titleType = segmented.selectedSegmentIndex;
    
    
  
    [self.temporaryArr removeAllObjects];
   
    [self HotenCommentData:@""];
    [self.tableView reloadData];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
  
}

-(void)addtag {

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.temporaryArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLBookingHotelTableViewCell *cell = [ADLBookingHotelTableViewCell cellWithTableView:tableView];
    cell.model = self.temporaryArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ADLHotelDetailsController *VC = [[ADLHotelDetailsController alloc]init];
    VC.model =self.temporaryArr[indexPath.row];
//    VC.model.companyName  = self.model.companyName;
//    VC.model.address  = self.model.address;
//    VC.model.policyDes = self.model.policyDes;
//    VC.model.reserveDes = self.model.reserveDes;
//    VC.model.notes = self.model.notes;
    [self.navigationController pushViewController:VC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title;
    if (self.titleType == 0) {
        title = ADLString(@"取消收藏");
    }else {
        title =ADLString(@"删除");
    }

    WS(ws);
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [ws deleteHotenRecord:indexPath];
            }];
    deleteAction.backgroundColor = COLOR_E0212A;
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
-(NSMutableArray *)temporaryArr {
    if (!_temporaryArr) {
        _temporaryArr = [NSMutableArray array];
    }
    return  _temporaryArr;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_H + 75,SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-75) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR_F7F7F7;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //_tableView.contentInset = UIEdgeInsetsMake(438/2, 0, 0, 0);
        
    }
    return _tableView;
}
@end
