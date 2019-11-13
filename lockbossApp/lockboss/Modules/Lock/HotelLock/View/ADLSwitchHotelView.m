//
//  ADLSwitchHotelView.m
//  lockboss
//
//  Created by adel on 2019/10/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSwitchHotelView.h"

#import "ADLSwitchDeviceCell.h"

#import "ADLLocalizedHelper.h"

#import "ADLNetWorkManager.h"

#import "ADLRefreshHeader.h"

#import "ADLGlobalDefine.h"

#import "ADLGuestRoomsModel.h"

#import "ADELUrlpath.h"

#import "ADLUtils.h"

#import <NSObject+MJKeyValue.h>

@interface ADLSwitchHotelView ()<UITableViewDelegate,UITableViewDataSource,ADLSwitchDeviceCellDelegate>

@property (nonatomic, copy) void (^finish) (ADLGuestRoomsModel *model);

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) NSString *checkingInId;

@end

@implementation ADLSwitchHotelView



+ (instancetype)showWithSelectHotelMessage:(ADLGuestRoomsModel *)selHotelModel allHotelMeesage:(NSArray *)allHotelArray finish:(void (^)(ADLGuestRoomsModel * _Nonnull))finish{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds HotelMes:selHotelModel allMesage:allHotelArray finish:finish];
}
- (instancetype)initWithFrame:(CGRect)frame HotelMes:(ADLGuestRoomsModel *)hotelModel allMesage:(NSArray *)allDataArray finish:(void (^)(ADLGuestRoomsModel *))finish {
    if (self = [super initWithFrame:frame]) {
        
        self.finish = finish;
        self.dataArr = [allDataArray mutableCopy];
        self.checkingInId = hotelModel.checkingInId;//[hotelDic objectForKey:@"checkingInId"];//[ADLUtils valueForKey:FAMILY_DEVICE];
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
        [coverView addGestureRecognizer:tap];
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.6)];
        panelView.backgroundColor = [UIColor whiteColor];
        [self addSubview:panelView];
        self.panelView = panelView;
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH-88, 44)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.text = @"切换房间";//ADLString(@"my_lock");
        titLab.textColor = COLOR_333333;
        [panelView addSubview:titLab];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 44)];
        [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:closeBtn];
        
//        self.dataArr = [[NSMutableArray alloc] init];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT*0.6-50)];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H+10, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = 90;
        tableView.delegate = self;
        tableView.dataSource = self;
        [panelView addSubview:tableView];
        self.tableView = tableView;
        
//        __weak typeof(self)weakSelf = self;
//        tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
//            [weakSelf familyDeviceData];
//        }];
//        [self familyDeviceData];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.4;
            panelView.frame = CGRectMake(0, SCREEN_HEIGHT*0.4, SCREEN_WIDTH, SCREEN_HEIGHT*0.6);
        }];
    }
    return self;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSwitchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSwitchDeviceCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    ADLGuestRoomsModel *model = self.dataArr[indexPath.row];
    cell.nameLab.text = model.name;//酒店名称
    //酒店图片,后台接口没返回  TODO
    //cell.lockView.image = [ADLUtils lockImageWithType:model.deviceType];
    //房间号
    cell.stateLab.textColor = COLOR_999999;
    cell.stateLab.text = [NSString stringWithFormat:@"房号:%@",model.roomName];//ADLString(@"online");
    

    if ([model.checkingInId isEqualToString:self.checkingInId]) {
        cell.lockBtn.backgroundColor = [UIColor whiteColor];
        [cell.lockBtn setTitle:@"当前房间" forState:UIControlStateNormal];
        [cell.lockBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    } else {
        cell.lockBtn.backgroundColor = APP_COLOR;
        [cell.lockBtn setTitle:@"切换房间" forState:UIControlStateNormal];
        [cell.lockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    cell.shareView.hidden = YES;//设备的是否共享标识,直接屏蔽;

    return cell;
}

#pragma mark ------ 切换酒店 ------
- (void)didClickLockBtn:(UIButton *)sender {
    ADLSwitchDeviceCell *cell = (ADLSwitchDeviceCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLGuestRoomsModel *model = self.dataArr[indexPath.row];
    if (![model.checkingInId isEqualToString:self.checkingInId]) {
        if (self.finish) {
            self.finish(model);
        }
        [self clickClose];
    }else {
        ADLLog(@"点击了已选择的酒店,不处理");
        [self clickClose];
    }

}

#pragma mark ------ 获取数据 ------
//- (void)familyDeviceData {
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//    [ADLNetWorkManager postWithPath:ADEL_family_getUserDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//        [self.tableView.mj_header endRefreshing];
//        if ([responseDict[@"code"] integerValue] == 10000) {
//            [self.dataArr removeAllObjects];
//            NSMutableArray *modelArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
//            NSString *deviceId = [ADLUtils valueForKey:FAMILY_DEVICE];
//            for (ADLDeviceModel *model in modelArr) {
//                if (![model.deviceType isEqualToString:@"21"] && ![model.deviceType isEqualToString:@"25"]) {
//                    if ([model.deviceId isEqualToString:deviceId]) {
//                        [self.dataArr insertObject:model atIndex:0];
//                    } else {
//                        [self.dataArr addObject:model];
//                    }
//                }
//            }
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//    }];
//}

#pragma mark ------ 关闭 ------
- (void)clickClose {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = frame;
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
