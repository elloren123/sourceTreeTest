//
//  ADLHotelOrderListController.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderListController.h"
#import "ADLHotelOrderListCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelOrderDetailsController.h"
#import "ADLTitleView.h"
#import "ADLHotelOrderModel.h"
#import "ADLHotelOrderCommentController.h"
#import "ADLHotelOrderDetailsController.h"
#import "ADLHotelDetailsController.h"

@interface ADLHotelOrderListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,copy)NSString *OrderId;

@end

@implementation ADLHotelOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView:ADLString(@"订单")];

    self.index = 0;
    
    WS(ws);
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"全部",@"待支付",@"已支付",@"已完成",@"已取消"]];
    [self.view addSubview:titleView];
    titleView.clickTitle = ^(NSInteger index) {
        [ws.array removeAllObjects];
        [ws.tableView reloadData];
        ws.index = index;
        [ws HotenRoomDataIndex:index OrderId:@""];
    };

      [self.view addSubview:self.tableView];
    self.tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
           [ws.array removeAllObjects];
          ws.tableView.mj_footer.hidden = NO;
        //重新刷新(从0开始)
        [ws HotenRoomDataIndex:ws.index OrderId:@""];
        
    }];
    self.tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        ADLHotelOrderModel *model = ws.array.lastObject;
          [ws HotenRoomDataIndex:ws.index OrderId:model.roomSellOrderId];
    }];

          [ws HotenRoomDataIndex:self.index OrderId:@""];
    
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

#pragma mark ------获取用户订单列表 -----
- (void)HotenRoomDataIndex:(NSInteger)index OrderId:(NSString *)OrderId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] =OrderId;
    params[@"status"] =@(index);
    params[@"sign"] = [ADLUtils handleParamsSign:params];
     [ADLToast showLoadingMessage:ADLString(@"加载数据")];
    //0：全部，1：待支付，2：已支付，3：已完成，4：已取消
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellOrder_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
           [ADLToast hide];
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
             NSMutableArray *array = [ADLHotelOrderModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];

            if (array.count > 0) {
                [self.array addObjectsFromArray:array];
              if (array.count < 19)  {
                    ws.tableView.mj_footer.hidden = YES;
                  
                }
                
            }else {

                ws.tableView.mj_footer.hidden = YES;
            }
        }
        [ws.tableView reloadData];
    } failure:^(NSError *error) {
           [ADLToast hide];
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLHotelOrderListCell *cell = [ADLHotelOrderListCell cellWithTableView:tableView hotelOrderCell:ADLHotelOrderistCell];
    cell.model = self.array[indexPath.row];
    WS(ws);
    cell.clicBlock = ^(UIButton * _Nonnull btn) {
        [ws cellBlock:btn index:indexPath.row];
    };
    return cell;
    
}
//删除 ,退款,取消,去支付,去评论,再次预订,处理中
-(void)cellBlock:(UIButton *)btn index:(NSInteger )index{
    ADLHotelOrderModel *model = self.array[index];
    NSString *strUrl;
    WS(ws);
    if ([btn.titleLabel.text isEqualToString:ADLString(@"删除")]) {
        strUrl = ADEL_hotel_roomSellOrder_cancel;
        [ADLAlertView showWithTitle:ADLString(@"你确定要删除订单吗?") message:nil confirmTitle:nil confirmAction:^{
           [ws cancel:model strUrl:strUrl];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
        
    }else   if ([btn.titleLabel.text isEqualToString:ADLString(@"退款")]) {
        ADLHotelOrderCommentController *vc = [[ADLHotelOrderCommentController alloc]init];
        vc.afterType = 2;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else   if ([btn.titleLabel.text isEqualToString:ADLString(@"取消")]) {
        strUrl =ADEL_hotel_roomSellOrder_cancel;
     
        [ADLAlertView showWithTitle:ADLString(@"你确定要取消订单吗?") message:nil confirmTitle:nil confirmAction:^{
            [ws cancel:model strUrl:strUrl];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"去支付")]) {
        ADLHotelOrderDetailsController *VC= [[ADLHotelOrderDetailsController alloc]init];
         VC.payType = 1;
         VC.model = model;
        [self.navigationController pushViewController:VC animated:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"去评论")]) {
        
        ADLHotelOrderCommentController *VC= [[ADLHotelOrderCommentController alloc]init];
        VC.afterType = 1;
        VC.model = model;
        [self.navigationController pushViewController:VC animated:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"再次预订")]) {
        ADLHotelDetailsController *vc = [[ADLHotelDetailsController alloc]init];
        NSMutableDictionary *dict = [model mj_keyValues];
        vc.model = [ADLBookingHotelModel mj_objectWithKeyValues:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"处理中")]) {
        
    }else {
        [ADLToast showMessage:btn.titleLabel.text];
    }
}
#pragma mark ------ 取消 -----
- (void)cancel:(ADLHotelOrderModel *)model strUrl:(NSString *)strUrl{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = model.roomSellOrderId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
        }
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return  210;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADLHotelOrderModel *model= self.array[indexPath.row];;
        ADLHotelOrderDetailsController *VC= [[ADLHotelOrderDetailsController alloc]init];
    //status 1：正常(完成)、2：取消（取消订单）(完成)，3：退款(完成)，4：待处理，5：待入住，6：售后，7 代付款，8 待分配房间，9支付失败",
    //payType 1待支付  2已经支付 3已完成 4已取消 5退款处理中
    switch (model.status) {
        case 1:
        VC.payType = 3;
            break;
        case 2:
            VC.payType = 4;
            break;
        case 3:
            VC.payType = 3;
            break;
        case 4:
           VC.payType = 5;
            break;
        case 5:
            VC.payType = 2;
            break;
        case 6:
            VC.payType = 3;
            break;
        case 7:
            VC.payType = 1;
            break;
        case 8:
            VC.payType = 2;
            break;
        case 9:
            VC.payType = 4;
            break;
        default:
            break;
    }
    VC.model = model;
    [self.navigationController pushViewController:VC animated:YES];
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H+VIEW_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H-VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // _tableView.bounces = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}
@end
