//
//  ADLSearchCircleController.m
//  lockboss
//
//  Created by adel on 2019/5/31.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchCircleController.h"
#import "ADLCircleDetailController.h"

#import "ADLCircleHomeCell.h"
#import "ADLSearchView.h"
#import "ADLBlankView.h"

@interface ADLSearchCircleController ()<ADLSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSString *text;
@end

@implementation ADLSearchCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADLSearchView *searchView = [ADLSearchView searchViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入群组名称" instant:YES];
    searchView.textField.returnKeyType = UIReturnKeyDone;
    searchView.delegate = self;
    [self.view addSubview:searchView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCircleHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleHomeCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLCircleHomeCell" owner:nil options:nil].lastObject;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]] placeholderImage:[UIImage imageNamed:@"group_head"]];
    cell.nameLab.text = dict[@"name"];
    cell.detailLab.text = dict[@"newTopic"];
    cell.numLab.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCircleDetailController *detailVC = [[ADLCircleDetailController alloc] init];
    detailVC.circleId = self.dataArr[indexPath.row][@"groupId"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.dataArr.count > 0) {
        [self.view endEditing:YES];
    }
}

#pragma mark ------ 取消 ------
- (void)didClickCancleButton {
    [self customPopViewController];
}

#pragma mark ------ 搜索 ------
- (void)didClickSearchButton:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark ------ 文字改变 ------
- (void)textFieldTextDidChanged:(NSString *)text {
    NSString *inputStr = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (inputStr.length > 0) {
        if ([ADLUtils hasEmoji:inputStr]) {
            [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        } else {
            self.text = inputStr;
            [self loadData];
        }
    } else {
        [self.dataArr removeAllObjects];
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
    }
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.text forKey:@"groupName"];
    [ADLNetWorkManager postWithPath:k_search_circle parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:responseDict[@"data"]];
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"搜索内容不存在，换个关键词试试。" backgroundColor:nil];
    }
    return _blankView;
}

@end
