//
//  ADLFileListController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLFileListController.h"
#import "ADLFileDetailController.h"
#import "ADLMineViewCell.h"
#import "ADLBlankView.h"

@interface ADLFileListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLFileListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:self.docName];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
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
        listVC.docName = dict[@"name"];
        listVC.docId = dict[@"id"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.docId forKey:@"parentId"];
    
    [ADLNetWorkManager postWithPath:k_datum_file_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *listArr = responseDict[@"data"][@"rows"];
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            if (listArr.count > 0) {
                [self.dataArr addObjectsFromArray:listArr];
            }
            if (listArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无文件" backgroundColor:nil];
    }
    return _blankView;
}

@end
