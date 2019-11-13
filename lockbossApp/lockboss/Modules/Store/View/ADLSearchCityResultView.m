//
//  ADLSearchCityResultView.m
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchCityResultView.h"
#import "ADLSingleTextCell.h"
#import "ADLGlobalDefine.h"
#import "ADLBlankView.h"

@interface ADLSearchCityResultView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLSearchCityResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArr = [[NSMutableArray alloc] init];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = COLOR_F2F2F2;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = ROW_HEIGHT;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.leftMargin = 12;
    }
    cell.titLab.text = self.dataArr[indexPath.row][@"areaName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickCity) {
        self.clickCity(self.dataArr[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.willBeginDragging) {
        self.willBeginDragging();
    }
}

- (void)updateDataArray:(NSArray *)dataArr {
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:dataArr];
    if (dataArr.count == 0) {
        self.tableView.tableFooterView = self.blankView;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    [self.tableView reloadData];
}

- (void)resetDataArray {
    [self.dataArr removeAllObjects];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"搜索结果为空，换个关键词试试吧！" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
