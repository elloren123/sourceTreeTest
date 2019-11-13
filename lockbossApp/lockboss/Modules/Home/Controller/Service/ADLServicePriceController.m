//
//  ADLServicePriceController.m
//  lockboss
//
//  Created by Han on 2019/6/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLServicePriceController.h"
#import "ADLServicePriceCell.h"
#import "ADLBlankView.h"

@interface ADLServicePriceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation ADLServicePriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"服务价目表"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataArr[section][@"listService"];
    return sectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, 20, 3, 16)];
    redView.backgroundColor = APP_COLOR;
    [headerView addSubview: redView];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(22, 18, SCREEN_WIDTH-34, 20)];
    titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    titLab.textColor = COLOR_333333;
    titLab.text = self.dataArr[section][@"name"];
    [headerView addSubview:titLab];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLServicePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLServicePriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" cellH:ROW_HEIGHT];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = self.dataArr[indexPath.section][@"listService"][indexPath.row];
    cell.titLab.text = dict[@"name"];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f元 起",[dict[@"startingPrice"] doubleValue]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(priceStr.length-1, 1)];
    cell.priceLab.attributedText = attributeStr;
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    } else {
        cell.topLine.hidden = YES;
    }
    
    return cell;
}

- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.areaId forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_query_service_price parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
        }
        if (self.dataArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            self.tableView.tableFooterView = self.footerView;
        }
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark ------ footerView ------
- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *footerLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH-24, 18)];
        footerLab.font = [UIFont systemFontOfSize:13];
        footerLab.textColor = COLOR_999999;
        footerLab.numberOfLines = 2;
        footerLab.text = @"以上报价均为服务师傅3公里以内，超过3公里另外按距离计价";
        [_footerView addSubview:footerLab];
    }
    return _footerView;
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"该地区没有安装服务" backgroundColor:nil];
    }
    return _blankView;
}

@end
