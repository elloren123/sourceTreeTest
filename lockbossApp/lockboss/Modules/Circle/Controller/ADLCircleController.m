//
//  ADLCircleController.m
//  lockboss
//
//  Created by Han on 2019/5/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCircleController.h"
#import "ADLSearchCircleController.h"
#import "ADLCreatCircleController.h"
#import "ADLCircleDetailController.h"
#import "ADLReviewController.h"

#import "ADLCircleHomeCell.h"
#import "ADLCircleHeadView.h"
#import "ADLBottomView.h"
#import "ADLTitleView.h"
#import "ADLBlankView.h"

#import <Masonry.h>

@interface ADLCircleController ()<UITableViewDelegate,UITableViewDataSource,ADLCircleHeadViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLCircleHeadView *headView;
@property (nonatomic, strong) ADLTitleView *titleView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *joinArr;
@property (nonatomic, strong) NSMutableArray *creatArr;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ADLCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"群组"];
    [self addRightButtonWithImageName:@"nav_add" action:@selector(clickAddBtn)];
    
    ADLCircleHeadView *headView = [[ADLCircleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+176)];
    headView.delegate = self;
    self.headView = headView;
    
    self.index = 0;
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"我参与的群组",@"我创建的群组"]];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.index = index;
        [weakSelf.dataArr removeAllObjects];
        if (index == 0) {
            [weakSelf.dataArr addObjectsFromArray:weakSelf.joinArr];
        } else {
            [weakSelf.dataArr addObjectsFromArray:weakSelf.creatArr];
        }
        if (weakSelf.dataArr.count == 0) {
            weakSelf.tableView.tableFooterView = weakSelf.blankView;
        } else {
            weakSelf.tableView.tableFooterView = [UIView new];
        }
        [weakSelf.tableView reloadData];
    };
    self.titleView = titleView;
    
    self.joinArr = [[NSMutableArray alloc] init];
    self.creatArr = [[NSMutableArray alloc] init];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVIGATION_H);
    }];
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getCircleData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCircleData) name:REFRESH_CIRCLE_DATA object:nil];
    [self getCircleData];
}

#pragma mark ------ 搜索 ------
- (void)didClickSearchView {
    ADLSearchCircleController *searchVC = [[ADLSearchCircleController alloc] init];
    [self customPushViewController:searchVC];
}

#pragma mark ------ 点击精选圈子 ------
- (void)didClickImageView:(NSDictionary *)dataDict {
    ADLCircleDetailController *detailVC = [[ADLCircleDetailController alloc] init];
    detailVC.circleId = dataDict[@"groupId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 加 ------
- (void)clickAddBtn {
    [ADLBottomView showWithTitles:@[@"创建群组",@"申请审核"] finish:^(NSInteger index) {
        if (index == 0) {
            ADLCreatCircleController *creatVC = [[ADLCreatCircleController alloc] init];
            [self.navigationController pushViewController:creatVC animated:YES];
        }
        if (index == 1) {
            ADLReviewController *reviewVC = [[ADLReviewController alloc] init];
            [self.navigationController pushViewController:reviewVC animated:YES];
        }
    }];
}

#pragma mark ------ UItableView Delegate && DataSource ------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return VIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.titleView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCircleHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleHomeCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLCircleHomeCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]] placeholderImage:[UIImage imageNamed:@"group_head"]];
    cell.detailLab.text = dict[@"newTopic"];
    if ([dict[@"deleteFlag"] boolValue]) {
        cell.nameLab.text = dict[@"name"];
        cell.nameLab.textColor = COLOR_333333;
        cell.detailLab.textColor = COLOR_666666;
    } else {
        cell.nameLab.text = [NSString stringWithFormat:@"%@(已解散)",dict[@"name"]];
        cell.nameLab.textColor = COLOR_D3D3D3;
        cell.detailLab.textColor = COLOR_D3D3D3;
    }
    if ([dict[@"notRead"] integerValue] > 0) {
        cell.numLab.hidden = NO;
        if ([dict[@"notRead"] integerValue] > 99) {
            cell.numLab.text = @" 99+ ";
        } else {
            cell.numLab.text = [dict[@"notRead"] stringValue];
        }
    } else {
        cell.numLab.hidden = YES;
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"删除";
    if (self.index == 1) title = @"解散";
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteCircle:indexPath];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"deleteFlag"] boolValue]) {
        ADLCircleDetailController *detailVC = [[ADLCircleDetailController alloc] init];
        detailVC.circleId = dict[@"groupId"];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        [ADLToast showMessage:@"该群组已解散"];
    }
}

#pragma mark ------ 圈子数据 ------
- (void)getCircleData {
    [ADLNetWorkManager postWithPath:k_circle_homepage parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            [self.joinArr removeAllObjects];
            [self.creatArr removeAllObjects];
            
            NSArray *choiceArr = responseDict[@"data"][@"choices"];
            if (choiceArr.count == 0) {
                self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 58);
            } else {
                if (self.headView.dataArr.count == 0) {
                    self.headView.dataArr = choiceArr;
                }
            }
            
            NSArray *joinArr = responseDict[@"data"][@"partakes"];
            if (joinArr.count > 0) {
                [self.joinArr addObjectsFromArray:joinArr];
            }
            
            NSArray *creatArr = responseDict[@"data"][@"creates"];
            if (creatArr.count > 0) {
                [self.creatArr addObjectsFromArray:creatArr];
            }
            
            if (self.index == 0) {
                [self.dataArr addObjectsFromArray:joinArr];
            } else {
                [self.dataArr addObjectsFromArray:creatArr];
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 删除圈子 ------
- (void)deleteCircle:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.dataArr[indexPath.row][@"groupId"] forKey:@"groupId"];
    NSString *path = k_delete_circle;
    NSString *toastStr = @"删除成功";
    if (self.index == 1) {
        path = k_disband_circle;
        toastStr = @"解散成功";
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:toastStr];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            if (self.index == 0) {
                [self.joinArr removeObjectAtIndex:indexPath.row];
            } else {
                [self.creatArr removeObjectAtIndex:indexPath.row];
            }
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 369) imageName:nil prompt:@"还没有参与群组，赶紧去加入或者创建一个群组吧。" backgroundColor:nil];
        _blankView.topMargin = 90;
        _blankView.actionBtn.hidden = NO;
        [_blankView.actionBtn setTitle:@"创建群组" forState:UIControlStateNormal];
        [_blankView.actionBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        _blankView.actionBtn.layer.borderColor = APP_COLOR.CGColor;
        __weak typeof(self)weakSelf = self;
        _blankView.clickActionBtn = ^{
            ADLCreatCircleController *creatVC = [[ADLCreatCircleController alloc] init];
            [weakSelf.navigationController pushViewController:creatVC animated:YES];
        };
    }
    return _blankView;
}

@end
