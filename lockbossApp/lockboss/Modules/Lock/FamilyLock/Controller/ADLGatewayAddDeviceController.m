//
//  ADLGatewayAddDeviceController.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayAddDeviceController.h"

#import "ADLDeviceModel.h"

#import "ADLGatewayAddDeviceCell.h"

#import "ADLDropMenuView.h"

#import "ADLLockHomeController.h"

#import "ADLGatewayHelpController.h"

#import "ADLFamilyNewSettingController.h"

#import "ADLFamilySettingController.h"

#import "ADLGatewayAddDetailController.h" //绑定设备

#import "ADLBlankView.h"

@interface ADLGatewayAddDeviceController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *gatewayNameLab;//网关名称

@property (nonatomic ,strong) UIButton *moreBtn;

@property (nonatomic ,strong) ADLBlankView *blackView;//无数据视图

@end

static CGFloat headViewH = 240;

@implementation ADLGatewayAddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRedNavigationView:self.gatewayModel.name];
    [self setRightMoreBtn];
    [self.view addSubview:self.tableView];
    [self addHeadForTableView];
    [self getGatewayDataSource];
    
}
-(void)setRightMoreBtn {
    UIButton *rightImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [rightImageBtn setImage:[UIImage imageNamed:@"lock_set"] forState:UIControlStateNormal];
    rightImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [rightImageBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    self.moreBtn = rightImageBtn;
    [self.navigationView addSubview:rightImageBtn];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_H+headViewH, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableFooterView.hidden = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return  _tableView ;
}
-(void)addHeadForTableView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, headViewH)];
    headView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    UIImageView *deviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 70, 80, 80)];
    deviceImgView.image = [ADLUtils lockImageWithType:self.gatewayModel.deviceType];
    [headView addSubview:deviceImgView];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 14)];
    titLab.text = self.gatewayModel.name?self.gatewayModel.name:@"";
    titLab.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    titLab.font = [UIFont systemFontOfSize:14];
    titLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titLab];
    self.gatewayNameLab = titLab;
    [self.view addSubview:headView];
    
}

#pragma mark ------ 网关子设备数据源 ------
-(void)getGatewayDataSource {
    
    NSArray *allDeviceArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:self.gatewayChildDeviceArray];
    for (ADLDeviceModel *model in allDeviceArr) {
        if ([model.isBing isEqualToString:@"1"]) {
            [self.dataArr addObject:model];
        }
    }
    if (self.dataArr.count == 0) {
        self.tableView.tableFooterView = self.blackView;
        self.tableView.scrollEnabled = NO;
    }else{
        self.tableView.tableFooterView = [UIView new];
        self.tableView.scrollEnabled = YES;
    }
    [self.tableView reloadData];
}

#pragma mark ------  网关更多 ------
- (void)clickMoreBtn {
    [ADLDropMenuView showWithView:self.moreBtn imgNameArray:@[@"chat_more",@"family_setting",@"topic_write"] titleArray:@[@"绑定设备",ADLString(@"general_setting"),@"使用帮助"] lightMode:YES finish:^(NSInteger index) {
        if (index == 0) {
            //进入到添加设备界面
            ADLGatewayAddDetailController *addDeviceDetailVC = [[ADLGatewayAddDetailController alloc] init];
            [self.navigationController pushViewController:addDeviceDetailVC animated:YES];
        } else if(index == 1){
            ADLFamilySettingController *settingVC = [[ADLFamilySettingController alloc] init];
            settingVC.model = self.gatewayModel;
            settingVC.type = 1;
            settingVC.familyNameChanged = ^(NSString *name) {
                [self updateGatewayTitle:name];//TODO
            };
            [self.navigationController pushViewController:settingVC animated:YES];
            
        } else {
            //帮助界面,目前写死  TODO
            ADLGatewayHelpController *helpVC = [[ADLGatewayHelpController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
    }];
}
-(void)updateGatewayTitle:(NSString *)name{
    //更改网关名称后,更改数据源
    self.gatewayModel.deviceName = name;
    self.gatewayModel.name = name;
    self.gatewayNameLab.text = name;
}

#pragma mark ------ tableView Delegate ------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ADLGatewayAddDeviceCell *cell = [ADLGatewayAddDeviceCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLDeviceModel *model = self.dataArr[indexPath.row];
    [ADLUtils saveValue:model.id forKey:FAMILY_DEVICE]; //这里用的又是ID,麻蛋
    [self.navigationController pushViewController:[[ADLLockHomeController alloc] init] animated:YES];
}

#pragma mark ------ 空数据视图 ------
-(ADLBlankView *)blackView {
    if (!_blackView) {
        _blackView = [ADLBlankView blankViewWithFrame:CGRectMake(0, NAVIGATION_H+headViewH, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H) imageName:@"data_blank" prompt:@"该设备没有绑定的子设备!" backgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    }
    return _blackView;
}

@end
