//
//  ADLMessageController.m
//  lockboss
//
//  Created by adel on 2019/4/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMessageController.h"
#import "ADLMsgCenterCell.h"
#import "ADLMsgSettingController.h"
#import "ADLMsgDetailController.h"

@interface ADLMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"消息中心"];
    [self addRightButtonWithImageName:@"msg_setting" action:@selector(clickMessageSetting)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = FONT_SIZE*2+34;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMsgCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgCenter"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMsgCenterCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titleLab.text = dict[@"name"];
    cell.descLab.text = dict[@"latestInformationTitle"];
    cell.dateLab.text = [ADLUtils getDateFromTimestamp:[dict[@"latestInformationDate"] doubleValue] format:@"yyyy-MM-dd"];
    cell.redView.hidden = [dict[@"isRead"] boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    ADLMsgDetailController *detailVC = [[ADLMsgDetailController alloc] init];
    detailVC.unread = ![dict[@"isRead"] boolValue];
    detailVC.navTitle = dict[@"name"];
    detailVC.msgType = dict[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 消息设置 ------
- (void)clickMessageSetting {
    [self.navigationController pushViewController:[[ADLMsgSettingController alloc] init] animated:YES];
}

#pragma mark ------ 获取数据 ------
- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(0) forKey:@"stype"];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_all_msg parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.dataArr removeAllObjects];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *msgArr = responseDict[@"data"];
            if (msgArr.count > 0) {
                [self.dataArr addObjectsFromArray:msgArr];
            }
        }
        [self.tableView reloadData];
    } failure:nil];
}

- (void)dealloc {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
