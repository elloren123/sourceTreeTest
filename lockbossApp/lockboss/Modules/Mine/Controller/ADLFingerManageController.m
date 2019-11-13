//
//  ADLFingerManageController.m
//  lockboss
//
//  Created by adel on 2019/7/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLFingerManageController.h"
#import "ADLSingleTextCell.h"
#import "ADLBlankView.h"

@interface ADLFingerManageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) CGRect attachF;
@end

@implementation ADLFingerManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:ADLString(@"finger_setting")];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self loadData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 1) {
         self.attachF = cell.frame;
    }
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftMargin = 12;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titLab.text = [NSString stringWithFormat:@"指纹名称：%@",dict[@"name"]];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self editFingerName:indexPath];
    }];
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteFinger:indexPath];
    }];
    editAC.backgroundColor = COLOR_D3D3D3;
    NSArray *arr = @[deleteAC,editAC];
    return arr;
}

#pragma mark ------ 编辑指纹名称 ------
- (void)editFingerName:(NSIndexPath *)indexPath {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改指纹名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertVC.textFields[0];
        NSString *name = textField.text;
        if (name.length > 0) {
            if (name.length > 18) {
                name = [name substringToIndex:18];
            }
            if ([ADLUtils hasEmoji:name]) {
                [ADLToast showMessage:@"暂时不支持表情或特殊符号"];
            } else {
                NSMutableDictionary *dict = self.dataArr[indexPath.row];
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:dict[@"id"] forKey:@"id"];
                [params setValue:name forKey:@"name"];
                [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
                [ADLNetWorkManager postWithPath:ADEL_updateMyFingerName parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        [ADLToast showMessage:@"修改成功"];
                        [dict setValue:name forKey:@"name"];
                        [dict setValue:[NSString stringWithFormat:@"指纹名称：%@",name] forKey:@"fn"];
                        [self.tableView reloadData];
                    }
                } failure:nil];
            }
        }
    }]];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = self.dataArr[indexPath.row][@"name"];
        textField.placeholder = @"请输入指纹名称";
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ------ 删除指纹 ------
- (void)deleteFinger:(NSIndexPath *)indexPath {
    [ADLAlertView showWithTitle:@"提示" message:@"确定要删除这条指纹数据吗?" confirmTitle:nil confirmAction:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"id"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_deleteMyFingerName parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"删除成功"];
                [self.dataArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (self.dataArr.count == 0) {
                    self.tableView.tableFooterView = self.blankView;
                }
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 获取指纹数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_searchMyFingers parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
                self.tableView.tableFooterView = [UIView new];
            } else {
                self.tableView.tableFooterView = self.blankView;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"您还没有添加指纹" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
