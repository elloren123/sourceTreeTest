//
//  ADLMorningController.m
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMorningController.h"
#import "ADLHTMLCommentController.h"
#import "ADLDiscoveryCell.h"

@interface ADLMorningController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLMorningController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"商城早报"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H+10, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    CGFloat rowH = SCREEN_WIDTH/2+105;
    if (SCREEN_WIDTH > 500) {
        rowH = SCREEN_WIDTH/2+88;
    }
    tableView.rowHeight = rowH;
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf loadData];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self loadData];
}

#pragma mark ------ UITableViewDelegate && DataSources ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLDiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discovery"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLDiscoveryCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (SCREEN_WIDTH > 500)  cell.descLab.numberOfLines = 1;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"majorImg"]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    cell.titleLab.text = dict[@"title"];
    cell.descLab.text = dict[@"subTitle"];
    cell.dateLab.text = dict[@"addDatetime"];
    cell.seeLab.text = [NSString stringWithFormat:@"%@ 阅读",dict[@"readNum"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLHTMLCommentController *htmlVC = [[ADLHTMLCommentController alloc] init];
    htmlVC.contentId = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:htmlVC animated:YES];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_discovery_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
