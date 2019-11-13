//
//  ADLAboutUsController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAboutUsController.h"
#import "ADLSettingViewCell.h"

@interface ADLAboutUsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"关于我们"];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 50, 70, 70)];
    logoImgView.image = [UIImage imageNamed:@"login_logo"];
    [headView addSubview:logoImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, SCREEN_WIDTH-60, 26)];
    label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_333333;
    label.text = @"锁老大";
    [headView addSubview:label];
    
    UILabel *verLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 152, SCREEN_WIDTH-60, 18)];
    verLab.font = [UIFont systemFontOfSize:FONT_SIZE-2];
    verLab.textAlignment = NSTextAlignmentCenter;
    verLab.textColor = COLOR_999999;
    verLab.text = [NSString stringWithFormat:@"版本号: v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [headView addSubview:verLab];
    
    [self.dataArr addObject:@"服务条款"];
    [self.dataArr addObject:@"隐私政策"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
    }
    cell.firstLab.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ADLToast showMessage:@"敬请期待！"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
