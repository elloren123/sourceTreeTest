//
//  ADLSearchDatumController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchDatumController.h"
#import "ADLFileDetailController.h"
#import "ADLMineViewCell.h"
#import "ADLSearchView.h"

@interface ADLSearchDatumController ()<ADLSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLSearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *text;
@end

@implementation ADLSearchDatumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADLSearchView *searchView = [[ADLSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入要搜索的资料名称" instant:YES];
    searchView.delegate = self;
    searchView.divisionView.hidden = YES;
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+10, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-10)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf searchData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
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
    cell.imgView.image = [ADLUtils getFileTypeImageWithType:[dict[@"datumType"] stringValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    ADLFileDetailController *detailVC = [[ADLFileDetailController alloc] init];
    detailVC.fileName = dict[@"name"];
    detailVC.fileId = dict[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ------ 取消 ------
- (void)didClickCancleButton {
    [self customPopViewController];
}

- (void)textFieldTextDidChanged:(NSString *)text {
    if (self.dataArr.count != 0) {
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark ------ 搜索 ------
- (void)didClickSearchButton:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length == 0) {
        [ADLToast showMessage:@"请输入要搜索的资料名称"];
    } else {
        self.text = text;
        self.offset = 0;
        [ADLToast showLoadingMessage:@"搜索中..."];
        [textField resignFirstResponder];
        [self searchData];
    }
}

#pragma mark ------ 搜索数据 ------
- (void)searchData {
    if ([ADLUtils hasEmoji:self.text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.text forKey:@"name"];
    
    [ADLNetWorkManager postWithPath:k_datum_folder_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *listArr = responseDict[@"data"][@"rows"];
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
                if (listArr.count == 0) {
                    [ADLToast showMessage:@"没有搜索到资料"];
                } else {
                    [ADLToast hide];
                }
            }
            
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
    } failure:nil];
}

@end
