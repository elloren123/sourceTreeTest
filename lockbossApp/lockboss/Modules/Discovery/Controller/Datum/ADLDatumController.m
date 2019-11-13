//
//  ADLDatumController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDatumController.h"
#import "ADLSearchDatumController.h"
#import "ADLFileDetailController.h"
#import "ADLFileListController.h"
#import "ADLSearchFakeView.h"
#import "ADLMineViewCell.h"

@interface ADLDatumController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLDatumController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"资料库"];
    
    __weak typeof(self)weakSelf = self;
    ADLSearchFakeView *fakeView = [ADLSearchFakeView searchFakeViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 52) placeholder:@"搜索资料"];
    [self.view addSubview:fakeView];
    fakeView.clickSearch = ^{
        ADLSearchDatumController *searchVC = [[ADLSearchDatumController alloc] init];
        [weakSelf customPushViewController:searchVC];
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+60, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-60)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getData];
    }];
    
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    tableView.mj_footer.hidden = YES;
    
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mine"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMineViewCell" owner:nil options:nil].lastObject;
        cell.left.constant = 52;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.label.text = dict[@"name"];
    if ([dict[@"datumType"] stringValue].length > 0) {
        cell.imgView.image = [ADLUtils getFileTypeImageWithType:[dict[@"datumType"] stringValue]];
    } else {
        cell.imgView.image = [UIImage imageNamed:@"datum_folder"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"datumType"] stringValue].length > 0) {
        ADLFileDetailController *detailVC = [[ADLFileDetailController alloc] init];
        detailVC.fileName = dict[@"name"];
        detailVC.fileId = dict[@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        ADLFileListController *listVC = [[ADLFileListController alloc] init];
        listVC.docId = dict[@"id"];
        listVC.docName = dict[@"name"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_datum_folder_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            
            NSArray *listArr = responseDict[@"data"][@"rows"];
            if (listArr.count > 0) {
                [self.dataArr addObjectsFromArray:listArr];
            }
            if (listArr.count < self.pageSize) {
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
