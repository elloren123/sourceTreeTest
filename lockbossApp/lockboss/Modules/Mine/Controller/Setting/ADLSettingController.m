//
//  ADLSettingController.m
//  lockboss
//
//  Created by adel on 2019/4/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSettingController.h"
#import "ADLAccountSecController.h"
#import "ADLLinkedAccountController.h"
#import "ADLShipAddressController.h"
#import "ADLAddInvoiceController.h"
#import "ADLLanguageController.h"
#import "ADLAboutUsController.h"
#import "ADLSettingViewCell.h"
#import "ADLRMQConnection.h"

#import <SDImageCache.h>

@interface ADLSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *cacheStr;
@end

@implementation ADLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:ADLString(@"setting")];
    
    [self.dataArr addObjectsFromArray:@[@"账户安全",@"关联账号",@"收货地址",@"添加增票资质",@"清除本地缓存",@"切换语言",@"关于我们"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-VIEW_HEIGHT-48)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *outBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    outBtn.frame = CGRectMake(12, SCREEN_HEIGHT-20-VIEW_HEIGHT-BOTTOM_H, SCREEN_WIDTH-24, VIEW_HEIGHT);
    outBtn.backgroundColor = APP_COLOR;
    outBtn.layer.cornerRadius = CORNER_RADIUS;
    outBtn.titleLabel.font= [UIFont systemFontOfSize:FONT_SIZE];
    [outBtn setTitle:ADLString(@"logout") forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(clickLoginOutBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *cachePath = [docPath stringByAppendingPathComponent:@"myCache"];
        long long folderSize = 0;
        if ([manager fileExistsAtPath:cachePath]) {
            NSEnumerator *enumerator = [[manager subpathsAtPath:cachePath] objectEnumerator];
            NSString *fileName;
            while ((fileName = [enumerator nextObject]) != nil){
                NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
                folderSize = [manager attributesOfItemAtPath:filePath error:nil].fileSize+folderSize;
            }
        }
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            self.cacheStr = [NSString stringWithFormat:@"%.2fM", (totalSize+folderSize)*1.0/1048576];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    footView.backgroundColor = COLOR_F2F2F2;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
    }
    if (indexPath.section == 0) {
        cell.firstLab.text = self.dataArr[indexPath.row];
        cell.secondLab.text = @"";
    } else {
        cell.firstLab.text = self.dataArr[indexPath.row+2];
        if (indexPath.row == 2) {
            cell.secondLab.text = self.cacheStr;
        } else {
            cell.secondLab.text = @"";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[ADLAccountSecController new] animated:YES];
        } else {
            [self.navigationController pushViewController:[ADLLinkedAccountController new] animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[ADLShipAddressController new] animated:YES];
        } else if (indexPath.row == 1) {
            [self.navigationController pushViewController:[ADLAddInvoiceController new] animated:YES];
        } else if (indexPath.row == 2) {
            if ([self.cacheStr isEqualToString:@"0.00M"]) {
                [ADLToast showMessage:@"暂无缓存"];
            } else {
                [ADLAlertView showWithTitle:@"清理缓存" message:@"本地缓存包含加载过的图片、视频等，清理后再次加载需重新下载，是否清理？" confirmTitle:nil confirmAction:^{
                    [ADLUtils removeAllCache];
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [ADLToast showMessage:ADLString(@"clean_cache")];
                        self.cacheStr = @"0.00M";
                        [tableView reloadData];
                    }];
                } cancleTitle:nil cancleAction:nil showCancle:YES];
            }
        } else if (indexPath.row == 3) {
            [self.navigationController pushViewController:[ADLLanguageController new] animated:YES];
        } else {
            [self.navigationController pushViewController:[ADLAboutUsController new] animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ------ 退出登录 ------
- (void)clickLoginOutBtn {
    [ADLAlertView showWithTitle:ADLString(@"log_out") message:nil confirmTitle:nil confirmAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_CHANGED object:@"logouts" userInfo:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

@end
