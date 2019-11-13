//
//  ADLProgressDetailController.m
//  lockboss
//
//  Created by adel on 2019/7/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLProgressDetailController.h"
#import "ADLAfterProDetailCell.h"

@interface ADLProgressDetailController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ADLProgressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"进度详情"];
    
    for (NSDictionary *dict in self.progArr) {
        CGFloat cellH = [ADLUtils calculateString:dict[@"handleInfo"] rectSize:CGSizeMake(SCREEN_WIDTH-46, MAXFLOAT) fontSize:14].height+78;
        [self.dataArr addObject:@(cellH)];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(8, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.progArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLAfterProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLAfterProDetailCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.progArr[indexPath.row];
    cell.timeLab.text = dict[@"handleTime"];
    cell.descLab.text = dict[@"handleInfo"];
    cell.personLab.text = [NSString stringWithFormat:@"操作人：%@",dict[@"handleMan"]];
    return cell;
}

@end
