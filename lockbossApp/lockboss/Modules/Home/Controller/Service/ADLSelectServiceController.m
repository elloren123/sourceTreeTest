//
//  ADLSelectServiceController.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectServiceController.h"
#import "ADLSelectServiceCell.h"
#import "ADLBlankView.h"

@interface ADLSelectServiceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLSelectServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"选择服务"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(8, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 86;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getServiceData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSelectServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" cellH:86];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.nameLab.text = dict[@"name"];
    cell.priceLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"startingPrice"] doubleValue]];
    int type = [dict[@"serviceTypeId"] intValue];
    if (type == 1) {
        cell.imgView.image = [UIImage imageNamed:@"service_wx"];
    } else if (type == 2) {
        cell.imgView.image = [UIImage imageNamed:@"service_az"];
    } else if (type == 3) {
        cell.imgView.image = [UIImage imageNamed:@"service_ks"];
    } else {
        cell.imgView.image = [UIImage imageNamed:@"service_sm"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickAction) {
        self.clickAction(self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 获取数据 ------
- (void)getServiceData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.areaId forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_query_all_service parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            for (NSDictionary *dict in resArr) {
                if ([dict[@"serviceTypeId"] integerValue] != 4) {
                    [self.dataArr addObject:dict];
                }
            }
        }
        if (self.dataArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"该地区没有服务" backgroundColor:nil];
    }
    return _blankView;
}

@end
