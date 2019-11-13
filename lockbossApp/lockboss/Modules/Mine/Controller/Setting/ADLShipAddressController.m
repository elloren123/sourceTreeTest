//
//  ADLShipAddressController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLShipAddressController.h"
#import "ADLShipAddressCell.h"
#import "ADLAddShipController.h"
#import "ADLBlankView.h"
#import <Masonry.h>

@interface ADLShipAddressController ()<UITableViewDelegate,UITableViewDataSource,ADLShipAddressCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLShipAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"收货地址"];
    self.rowHArr = [[NSMutableArray alloc] init];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.backgroundColor = APP_COLOR;
    [addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [addBtn addTarget:self action:@selector(clickAddAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.cornerRadius = CORNER_RADIUS;
    [self.view addSubview:addBtn];
    self.addBtn = addBtn;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.equalTo(@(VIEW_HEIGHT));
        make.bottom.equalTo(self.view).offset(-20-BOTTOM_H);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVIGATION_H);
        make.bottom.equalTo(addBtn.mas_top).offset(-20);
    }];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [self getAddressList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] doubleValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLShipAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"shipAddress"];
    if (addressCell == nil) {
        addressCell = [[NSBundle mainBundle] loadNibNamed:@"ADLShipAddressCell" owner:nil options:nil].lastObject;
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addressCell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    addressCell.nameLab.text = dict[@"consignee"];
    addressCell.phoneLab.text = dict[@"phone"];
    addressCell.addressLab.text = dict[@"areaStr"];
    if ([dict[@"label"] integerValue] == 0) {
        addressCell.defaultLab.text = @"家";
        addressCell.tagLab.text = @"家";
    } else {
        addressCell.defaultLab.text = @"公司";
        addressCell.tagLab.text = @"公司";
    }
    if ([dict[@"isDefault"] integerValue] == 0) {
        addressCell.defaultLab.text = @"默认";
        addressCell.defaultLab.backgroundColor = APP_COLOR;
        addressCell.tagLab.hidden = NO;
    } else {
        addressCell.defaultLab.backgroundColor = COLOR_0083FD;
        addressCell.tagLab.hidden = YES;
    }
    return addressCell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteAddressAtIndexPath:indexPath];
    }];
    deleteAC.backgroundColor = APP_COLOR;
    NSArray *arr = @[deleteAC];
    return arr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickAddress) {
        self.clickAddress(self.dataArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        ADLAddShipController *addVC = [[ADLAddShipController alloc] init];
        addVC.addressId = self.dataArr[indexPath.row][@"id"];
        addVC.provinceArr = self.provinceArr;
        addVC.finish = ^(NSDictionary * _Nonnull addressDict) {
            [self getAddressList];
        };
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

#pragma mark ------ 编辑地址 ------
- (void)didClickEditBtn:(ADLShipAddressCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLAddShipController *addVC = [[ADLAddShipController alloc] init];
    addVC.addressId = self.dataArr[indexPath.row][@"id"];
    addVC.provinceArr = self.provinceArr;
    addVC.finish = ^(NSDictionary * _Nonnull addressDict) {
        [self getAddressList];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ------ 添加地址 ------
- (void)clickAddAddressBtn {
    ADLAddShipController *addVC = [[ADLAddShipController alloc] init];
    addVC.provinceArr = self.provinceArr;
    addVC.finish = ^(NSDictionary * _Nonnull addressDict) {
        [self getAddressList];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ------ 获取收货列表 ------
- (void)getAddressList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_address_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            [self.rowHArr removeAllObjects];
            NSArray *addArr = responseDict[@"data"];
            if (addArr.count != 0) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (NSMutableDictionary *dict in addArr) {
                        AddressInfo info = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"areaId"] stringValue]];
                        NSString *areaStr = [NSString stringWithFormat:@"%@%@",info.address,dict[@"address"]];
                        [dict setValue:info.cityId forKey:@"cityId"];
                        [dict setValue:areaStr forKey:@"areaStr"];
                        
                        CGFloat rowH = [areaStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
                        if (rowH > 33) rowH = 33;
                        
                        if ([dict[@"isDefault"] intValue] == 0) {
                            [self.dataArr insertObject:dict atIndex:0];
                            [self.rowHArr insertObject:@(rowH+56) atIndex:0];
                        } else {
                            [self.dataArr addObject:dict];
                            [self.rowHArr addObject:@(rowH+56)];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tableView.tableFooterView = [UIView new];
                        [self.tableView reloadData];
                    });
                });
            } else {
                self.tableView.tableFooterView = self.blankView;
                [self.tableView reloadData];
            }
        }
    } failure:nil];
}

#pragma mark ------ 删除地址 ------
- (void)deleteAddressAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_delete_address parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.rowHArr removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无收货地址" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
