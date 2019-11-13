//
//  ADLMsgDetailController.m
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMsgDetailController.h"
#import "ADLMsgDetailCell.h"
#import "ADLSelectView.h"
#import "ADLBlankView.h"

@interface ADLMsgDetailController ()<ADLMsgDetailCellDelegate,ADLSelectViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@property (nonatomic, strong) NSMutableArray *editHArr;
@property (nonatomic, strong) NSMutableArray *unEditHArr;
@property (nonatomic, strong) ADLSelectView *selectView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger checkNum;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation ADLMsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:self.navTitle];
    self.rowHArr = [[NSMutableArray alloc] init];
    self.editHArr = [[NSMutableArray alloc] init];
    self.unEditHArr = [[NSMutableArray alloc] init];
    UIButton *editBtn = [self addRightButtonWithTitle:@"管理" action:@selector(clickManageBtn:)];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    editBtn.hidden = YES;
    self.editBtn = editBtn;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ADLSelectView *selectView = [[ADLSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ROW_HEIGHT-BOTTOM_H, SCREEN_WIDTH, ROW_HEIGHT+BOTTOM_H) title:@"删除" buttonH:ROW_HEIGHT];
    selectView.delegate = self;
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    self.selectView = selectView;
    
    self.checkNum = 0;
    self.currentPage = 1;
    self.pageSize = 10;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.unread) {
        [self setMessageTypeRead];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMsgDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgDetail"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMsgDetailCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titleLab.text = dict[@"title"];
    cell.descLab.text = dict[@"content"];
    cell.dateLab.text = dict[@"dateTime"];
    cell.checkBtn.selected = [dict[@"check"] boolValue];
    BOOL select = [dict[@"select"] boolValue];
    cell.pullTextBtn.selected = select;
    if (select) {
        cell.descLab.numberOfLines = 0;
        cell.pullBtn.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        cell.descLab.numberOfLines = 2;
        cell.pullBtn.transform = CGAffineTransformIdentity;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMsgDetailCell *detailCell = (ADLMsgDetailCell *)cell;
    if (self.editBtn.selected) {
        detailCell.pullBtn.hidden = YES;
        detailCell.conRight.constant = 41;
        detailCell.pullTextBtn.hidden = YES;
        detailCell.conView.transform = CGAffineTransformMakeTranslation(29, 0);
    } else {
        BOOL hidden = [self.dataArr[indexPath.row][@"hide"] boolValue];
        detailCell.pullBtn.hidden = NO;
        detailCell.conRight.constant = 12;
        detailCell.pullTextBtn.hidden = NO;
        detailCell.pullBtn.hidden = hidden;
        detailCell.pullTextBtn.hidden = hidden;
        detailCell.conView.transform = CGAffineTransformIdentity;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editBtn.selected) {
        ADLMsgDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = !cell.checkBtn.selected;
        [self setSelectedBtn:cell.checkBtn];
    }
}

#pragma mark ------ 编辑 ------
- (void)clickManageBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSArray *visibleArr = self.tableView.visibleCells;
    [self.rowHArr removeAllObjects];
    if (sender.selected) {
        self.selectView.hidden = NO;
        [self.rowHArr addObjectsFromArray:self.editHArr];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom+ROW_HEIGHT, 0);
        for (int i = 0; i < self.dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ADLMsgDetailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([visibleArr containsObject:cell]) {
                cell.conView.transform = CGAffineTransformMakeTranslation(29, 0);
                cell.conRight.constant = 41;
                cell.pullBtn.hidden = YES;
                cell.pullTextBtn.hidden = YES;
            }
        }
    } else {
        self.checkNum = 0;
        self.selectView.hidden = YES;
        self.selectView.selectBtn.selected = NO;
        [self.rowHArr addObjectsFromArray:self.unEditHArr];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom-ROW_HEIGHT, 0);
        for (int i = 0; i < self.dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ADLMsgDetailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSMutableDictionary *dict = self.dataArr[i];
            [dict setValue:@(0) forKey:@"check"];
            if ([visibleArr containsObject:cell]) {
                cell.conRight.constant = 12;
                cell.checkBtn.selected = NO;
                cell.pullBtn.hidden = [dict[@"hide"] boolValue];
                cell.pullTextBtn.hidden = [dict[@"hide"] boolValue];
                cell.conView.transform = CGAffineTransformIdentity;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark ------ 全选 ------
- (void)didClickSelectAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.checkNum = self.dataArr.count;
    } else {
        self.checkNum = 0;
    }
    for (int i = 0; i < self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ADLMsgDetailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = sender.selected;
        NSMutableDictionary *dict = self.dataArr[i];
        [dict setValue:@(sender.selected) forKey:@"check"];
    }
}

#pragma mark ------ 删除 ------
- (void)didClickTitleBtn:(UIButton *)sender {
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        NSMutableDictionary *dict = self.dataArr[i];
        if ([dict[@"check"] boolValue]) {
            [muArr addObject:dict[@"id"]];
        }
    }
    if (muArr.count == 0) {
        [ADLToast showMessage:@"请选择要删除的消息"];
        return;
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSString *paraStr = [muArr componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:paraStr forKey:@"infoId"];
    [ADLNetWorkManager postWithPath:k_delete_msg parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            self.selectView.selectBtn.selected = NO;
            self.currentPage = 1;
            self.checkNum = 0;
            [self loadData];
        }
    } failure:nil];
}

#pragma mark ------ 选中 ------
- (void)didClickCheckBtn:(UIButton *)sender {
    [self setSelectedBtn:sender];
}

#pragma mark ------ 计算选中数量 ------
- (void)setSelectedBtn:(UIButton *)sender {
    ADLMsgDetailCell *cell = (ADLMsgDetailCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    [dict setValue:@(sender.selected) forKey:@"check"];
    if (sender.selected) {
        self.checkNum++;
    } else {
        self.checkNum--;
    }
    if (self.checkNum == self.dataArr.count) {
        self.selectView.selectBtn.selected = YES;
    } else {
        self.selectView.selectBtn.selected = NO;
    }
}

#pragma mark ------ 点击展开收起 ------
- (void)didClickPullBtn:(ADLMsgDetailCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *contentStr = [self.dataArr[indexPath.row][@"content"] stringValue];
    CGFloat descH = [ADLUtils calculateString:contentStr rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:13].height;
    CGFloat rowH = [self.unEditHArr[indexPath.row] floatValue];
    
    CGFloat edescH = [ADLUtils calculateString:contentStr rectSize:CGSizeMake(SCREEN_WIDTH-53, MAXFLOAT) fontSize:13].height;
    CGFloat erowH = [self.editHArr[indexPath.row] floatValue];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    if (cell.pullTextBtn.selected) {
        rowH = rowH-descH+30;
        erowH = erowH-edescH+30;
        [dict setValue:@(0) forKey:@"select"];
    } else {
        rowH = rowH+descH-30;
        erowH = erowH+edescH-30;
        [dict setValue:@(1) forKey:@"select"];
    }
    [self.rowHArr replaceObjectAtIndex:indexPath.row withObject:@(rowH)];
    [self.editHArr replaceObjectAtIndex:indexPath.row withObject:@(erowH)];
    [self.unEditHArr replaceObjectAtIndex:indexPath.row withObject:@(rowH)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark ------ 获取数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.msgType forKey:@"typeId"];
    [params setValue:@(self.currentPage) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    
    [ADLNetWorkManager postWithPath:k_query_msg_type parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (self.currentPage == 1) {
                [self.dataArr removeAllObjects];
                [self.rowHArr removeAllObjects];
                [self.editHArr removeAllObjects];
                [self.unEditHArr removeAllObjects];
            }
            self.currentPage++;
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    NSString *title = dict[@"title"];
                    NSString *desc = dict[@"content"];
                    [dict setValue:[ADLUtils getDateFromTimestamp:[dict[@"addDatetime"] doubleValue] format:@"yyyy-MM-dd"] forKey:@"dateTime"];
                    CGFloat titH = [ADLUtils calculateString:title rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:15].height;
                    CGFloat descH = [ADLUtils calculateString:desc rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:13].height;
                    
                    CGFloat etitH = [ADLUtils calculateString:title rectSize:CGSizeMake(SCREEN_WIDTH-53, MAXFLOAT) fontSize:15].height;
                    CGFloat edescH = [ADLUtils calculateString:desc rectSize:CGSizeMake(SCREEN_WIDTH-53, MAXFLOAT) fontSize:13].height;
                    if (edescH > 42) {
                        edescH = 30;
                    }
                    if (descH > 42) {
                        descH = 30;
                        [dict setValue:@(0) forKey:@"hide"];
                    } else {
                        [dict setValue:@(1) forKey:@"hide"];
                    }
                    [dict setValue:@(0) forKey:@"select"];
                    [dict setValue:@(0) forKey:@"check"];
                    [self.unEditHArr addObject:@(titH+descH+59)];
                    [self.editHArr addObject:@(etitH+edescH+59)];
                    if (self.editBtn.selected) {
                        [self.rowHArr addObject:@(etitH+edescH+59)];
                    } else {
                        [self.rowHArr addObject:@(titH+descH+59)];
                    }
                    [self.dataArr addObject:dict];
                }
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.dataArr.count != self.checkNum) {
                self.selectView.selectBtn.selected = NO;
            }
            
            if (self.dataArr.count == 0) {
                self.selectView.hidden = YES;
                self.editBtn.selected = NO;
                self.editBtn.hidden = YES;
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.editBtn.hidden = NO;
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 设置消息为已读 ------
- (void)setMessageTypeRead {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.msgType forKey:@"typeId"];
    [ADLNetWorkManager postWithPath:k_set_msg_read parameters:params autoToast:YES success:nil failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无消息" backgroundColor:nil];
    }
    return _blankView;
}

@end
