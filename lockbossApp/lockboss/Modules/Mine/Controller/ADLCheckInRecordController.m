//
//  ADLCheckInRecordController.m
//  lockboss
//
//  Created by adel on 2019/7/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCheckInRecordController.h"
#import "ADLFeedbackController.h"
#import "ADLCheckInRecordCell.h"
#import "ADLImagePreView.h"
#import "ADLBlankView.h"

@interface ADLCheckInRecordController ()<UITableViewDelegate,UITableViewDataSource,ADLCheckInRecordCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation ADLCheckInRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:ADLString(@"check_record")];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(8, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 121;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    ADLRefreshHeader *header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithId:nil];
    }];
    header.ignoredScrollViewContentInsetTop = 8;
    tableView.mj_header = header;
    
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithId:weakSelf.lastId];
    }];
    tableView.mj_footer.hidden = YES;
    
    [self loadDataWithId:nil];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCheckInRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"check"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLCheckInRecordCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"companyImageUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.nameLab.text = dict[@"companyName"];
    cell.ruzhuLab.text = [NSString stringWithFormat:@"入住时间：%@",dict[@"startDatetime"]];
    cell.lidianLab.text = [NSString stringWithFormat:@"离店时间：%@",dict[@"checkOutDatetime"]];
    [cell.phoneBtn setTitle:[dict[@"companyPhone"] stringValue] forState:UIControlStateNormal];
    cell.addressLab.text = [NSString stringWithFormat:@"酒店地址：%@",dict[@"companyAddress"]];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [ADLAlertView showWithTitle:@"提示" message:@"确定要删除这条入住记录吗?" confirmTitle:nil confirmAction:^{
            [self deleteCheckinRecord:indexPath];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

#pragma mark ------ 删除入住记录 ------
- (void)deleteCheckinRecord:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_deleteCheckingIns parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (self.dataArr.count == 0) {
                self.lastId = nil;
                [self loadDataWithId:nil];
            } else {
                self.lastId = self.dataArr.lastObject[@"id"];
            }
        }
    } failure:nil];
}

#pragma mark ------ 酒店反馈 ------
- (void)didClickFeedbackBtn:(UIButton *)sender {
    ADLCheckInRecordCell *cell = (ADLCheckInRecordCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLFeedbackController *feedbackVC = [[ADLFeedbackController alloc] init];
    feedbackVC.hotelId = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

#pragma mark ------ 点击酒店图片 ------
- (void)didClickImgView:(UIImageView *)imgView {
    ADLCheckInRecordCell *cell = (ADLCheckInRecordCell *)imgView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([[dict[@"companyImageUrl"] stringValue] hasPrefix:@"http"]) {
        [ADLImagePreView showWithImageViews:@[imgView] urlArray:@[dict[@"companyImageUrl"]] currentIndex:0];
    }
}

#pragma mark ------ 拨打号码 ------
- (void)didClickPhoneBtn:(NSString *)phone {
    if (phone.length > 0) {
        NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
        [[UIApplication sharedApplication] openURL:callUrl];
    }
}

#pragma mark ------ 获取数据 ------
- (void)loadDataWithId:(NSString *)lastId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:lastId forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_getCheckingIns parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (lastId == nil) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
                self.lastId = resArr.lastObject[@"id"];
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            
            if (resArr.count == 0) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"您还没有入住记录" backgroundColor:nil];
    }
    return _blankView;
}

@end
