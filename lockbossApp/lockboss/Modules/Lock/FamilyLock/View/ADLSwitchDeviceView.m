//
//  ADLSwitchDeviceView.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSwitchDeviceView.h"

#import "ADLSwitchDeviceCell.h"

#import "ADLLocalizedHelper.h"

#import "ADLNetWorkManager.h"

#import "ADLRefreshHeader.h"

#import "ADLGlobalDefine.h"

#import "ADLDeviceModel.h"

#import "ADELUrlpath.h"

#import "ADLUtils.h"

#import <NSObject+MJKeyValue.h>

@interface ADLSwitchDeviceView ()<UITableViewDelegate,UITableViewDataSource,ADLSwitchDeviceCellDelegate>

@property (nonatomic, copy) void (^finish) (ADLDeviceModel *model);

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) NSString *deviceId;
@end

@implementation ADLSwitchDeviceView

+ (instancetype)showWithFamilyDevice:(BOOL)family finish:(void (^)(ADLDeviceModel *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds family:family finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame family:(BOOL)family finish:(void (^)(ADLDeviceModel *))finish {
    if (self = [super initWithFrame:frame]) {
        
        self.finish = finish;
        self.deviceId = [ADLUtils valueForKey:FAMILY_DEVICE];
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
        [coverView addGestureRecognizer:tap];
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.6)];
        panelView.backgroundColor = [UIColor whiteColor];
        [self addSubview:panelView];
        self.panelView = panelView;
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH-88, 44)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.text = ADLString(@"my_lock");
        titLab.textColor = COLOR_333333;
        [panelView addSubview:titLab];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 44)];
        [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:closeBtn];
        
        self.dataArr = [[NSMutableArray alloc] init];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT*0.6-50)];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H+10, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = 90;
        tableView.delegate = self;
        tableView.dataSource = self;
        [panelView addSubview:tableView];
        self.tableView = tableView;
        
        __weak typeof(self)weakSelf = self;
        tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf familyDeviceData];
        }];
        [self familyDeviceData];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.4;
            panelView.frame = CGRectMake(0, SCREEN_HEIGHT*0.4, SCREEN_WIDTH, SCREEN_HEIGHT*0.6);
        }];
    }
    return self;
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSwitchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSwitchDeviceCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    ADLDeviceModel *model = self.dataArr[indexPath.row];
    cell.nameLab.text = model.deviceName;
    cell.lockView.image = [ADLUtils lockImageWithType:model.deviceType];
    if ([model.deviceId isEqualToString:self.deviceId]) {
        cell.lockBtn.backgroundColor = [UIColor whiteColor];
        [cell.lockBtn setTitle:ADLString(@"current_lock") forState:UIControlStateNormal];
        [cell.lockBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    } else {
        cell.lockBtn.backgroundColor = APP_COLOR;
        [cell.lockBtn setTitle:ADLString(@"switch_lock") forState:UIControlStateNormal];
        [cell.lockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([model.jurisdiction isEqualToString:@"1"]) {
        cell.shareView.hidden = YES;
    } else {
        cell.shareView.hidden = NO;
    }
    if ([model.isFirstConnection isEqualToString:@"1"]) {
        cell.stateLab.textColor = COLOR_0AAA00;
        cell.stateLab.text = ADLString(@"online");
    } else {
        cell.stateLab.textColor = COLOR_999999;
        cell.stateLab.text = ADLString(@"offline");
    }
    return cell;
}

#pragma mark ------ 切换门锁 ------
- (void)didClickLockBtn:(UIButton *)sender {
    ADLSwitchDeviceCell *cell = (ADLSwitchDeviceCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLDeviceModel *model = self.dataArr[indexPath.row];
    if (![model.deviceId isEqualToString:self.deviceId]) {
        [ADLUtils saveValue:model.deviceId forKey:FAMILY_DEVICE];
        if (self.finish) {
            self.finish(model);
        }
        [self clickClose];
    }
}

#pragma mark ------ 获取数据 ------
- (void)familyDeviceData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getUserDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSMutableArray *modelArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            NSString *deviceId = [ADLUtils valueForKey:FAMILY_DEVICE];
            for (ADLDeviceModel *model in modelArr) {
                if (![model.deviceType isEqualToString:@"21"] && ![model.deviceType isEqualToString:@"25"]) {
                    if ([model.deviceId isEqualToString:deviceId]) {
                        [self.dataArr insertObject:model atIndex:0];
                    } else {
                        [self.dataArr addObject:model];
                    }
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 关闭 ------
- (void)clickClose {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = frame;
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
