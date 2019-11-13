//
//  ADLMsgSettingController.m
//  lockboss
//
//  Created by adel on 2019/4/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMsgSettingController.h"
#import "ADLMsgSettingCell.h"

@interface ADLMsgSettingController ()<UITableViewDelegate,UITableViewDataSource,ADLMsgSettingCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UISwitch *swc;
@end

@implementation ADLMsgSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"消息设置"];
    [self initHeadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = self.headView;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMsgSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell == nil) {
        cell = [[ADLMsgSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titleLab.text = dict[@"typeName"];
    cell.swc.on = ![dict[@"status"] boolValue];
    return cell;
}

#pragma mark ------ ADLMsgSettingCellDelegate ------
- (void)switchValueChanged:(UISwitch *)sender cell:(ADLMsgSettingCell *)cell {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    int num = 1;
    if (sender.on) num = 0;
    [params setValue:@(num) forKey:@"status"];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [params setValue:self.dataArr[indexPath.row][@"typeId"] forKey:@"typeId"];
    [ADLNetWorkManager postWithPath:k_update_msg_setting parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"设置成功"];
            NSMutableDictionary *dict = self.dataArr[indexPath.row];
            [dict setValue:@(num) forKey:@"status"];
            self.swc.on = NO;
            for (NSDictionary *dict in self.dataArr) {
                if ([dict[@"status"] boolValue] == NO) {
                    self.swc.on = YES;
                    break;
                }
            }
        } else {
            [sender setOn:!sender.on animated:YES];
        }
    } failure:^(NSError *error) {
        [sender setOn:!sender.on animated:YES];
    }];
}

#pragma mark ------ 获取数据 ------
- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_msg_setting parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.dataArr removeAllObjects];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *msgArr = responseDict[@"data"];
            if (msgArr.count > 0) {
                for (NSDictionary *dict in msgArr) {
                    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [self.dataArr addObject:muDict];
                    if ([dict[@"status"] boolValue] == NO) {
                        self.swc.on = YES;
                    }
                }
            }
            [self.tableView reloadData];
            if ([ADLToast isShowLoading]) [ADLToast showMessage:@"设置成功"];
        }
    } failure:nil];
}

#pragma mark ------ HeadView ------
- (void)initHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT*2-4)];
    headView.backgroundColor = COLOR_F2F2F2;
    self.headView = headView;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-80, ROW_HEIGHT)];
    lab.textColor = COLOR_333333;
    lab.font = [UIFont systemFontOfSize:FONT_SIZE];
    lab.text = @"新消息通知";
    [headView addSubview:lab];
    
    UISwitch *swc = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-59, (ROW_HEIGHT-31)/2, 47, 31)];
    [swc addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:swc];
    self.swc = swc;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT, SCREEN_WIDTH-24, ROW_HEIGHT-4)];
    label.textColor = COLOR_666666;
    label.font = [UIFont systemFontOfSize:FONT_SIZE-2];
    label.text = @"允许通知的消息类型";
    [headView addSubview:label];
}

#pragma mark ------ 新消息通知开关 ------
- (void)switchValueChanged:(UISwitch *)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    int num = 1;
    if (sender.on) num = 0;
    [params setValue:@(num) forKey:@"status"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"status"] intValue] != num ) {
            [muArr addObject:dict[@"typeId"]];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i < muArr.count; i++) {
            [params setValue:muArr[i] forKey:@"typeId"];
            [ADLNetWorkManager postWithPath:k_update_msg_setting parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                dispatch_semaphore_signal(sema);
            } failure:^(NSError *error) {
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getData];
        });
    });
}

@end
