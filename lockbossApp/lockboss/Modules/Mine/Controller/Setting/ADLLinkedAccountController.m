//
//  ADLLinkedAccountController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLinkedAccountController.h"
#import "ADLSettingViewCell.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ADLLinkedAccountController ()<UITableViewDelegate,UITableViewDataSource,TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *detailArr;
@end

@implementation ADLLinkedAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"账号关联"];
    [self.dataArr addObject:@"微信"];
    [self.dataArr addObject:@"QQ"];
    self.detailArr = [[NSMutableArray alloc] initWithObjects:@"未关联",@"未关联", nil];
    if ([[ADLUserModel sharedModel].isBindWeixin intValue] == 1) {
        [self.detailArr replaceObjectAtIndex:0 withObject:@"已关联"];
    }
    if ([[ADLUserModel sharedModel].isBindQq intValue] == 1) {
        [self.detailArr replaceObjectAtIndex:1 withObject:@"已关联"];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWechatToken:) name:@"wechatLogin" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.firstLab.text = self.dataArr[indexPath.row];
    cell.secondLab.text = self.detailArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.detailArr[indexPath.row] isEqualToString:@"已关联"]) {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要取消关联吗？" confirmTitle:nil confirmAction:^{
            [self unbindingThird:indexPath.row];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    } else {
        if (indexPath.row == 0) {
            if ([WXApi isWXAppInstalled]) {
                SendAuthReq *req = [[SendAuthReq alloc]init];
                req.scope = @"snsapi_userinfo";
                [WXApi sendReq:req completion:nil];
            } else {
                [ADLToast showMessage:@"请安装微信后再试"];
            }
        } else {
            if ([QQApiInterface isQQInstalled] || [QQApiInterface isTIMInstalled]) {
                TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
                NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", nil];
                [tencentOAuth authorize:permissions];
                self.tencentOAuth = tencentOAuth;
            } else {
                [ADLToast showMessage:@"请安装QQ后再试"];
            }
        }
    }
}

#pragma mark ------ 获取微信Token ------
- (void)getWechatToken:(NSNotification *)notification {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSString *preStr = @"https://api.weixin.qq.com/sns/oauth2/access_token?grant_type=authorization_code&appid=";
    NSString *path = [NSString stringWithFormat:@"%@%@&secret=%@&code=%@",preStr,WEACHAT_APPID,WEACHAT_SECRET,notification.object];
    [ADLNetWorkManager getNormalPath:path parameters:nil success:^(NSDictionary *responseDict) {
        if (responseDict[@"unionid"]) {
            [self bindingAccountWithUnionId:responseDict[@"unionid"] type:2];
        } else {
            [ADLToast showMessage:@"关联失败，请重试！"];
        }
    } failure:^(NSError *error) {
        [ADLToast showMessage:@"关联失败，请重试！"];
    }];
}

#pragma mark ------ QQ登录成功 ------
- (void)tencentDidLogin {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSString *path = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",_tencentOAuth.accessToken];
    [ADLNetWorkManager getNormalPath:path parameters:nil success:^(NSDictionary *responseDict) {
        if (responseDict[@"unionid"]) {
            [self bindingAccountWithUnionId:responseDict[@"unionid"] type:1];
        } else {
            [ADLToast showMessage:@"关联失败，请重试！"];
        }
    } failure:^(NSError *error) {
        [ADLToast showMessage:@"关联失败，请重试！"];
    }];
}

#pragma mark ------ QQ登录失败 ------
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [ADLToast showMessage:@"取消关联"];
    } else {
        [ADLToast showMessage:@"关联失败，请重试！"];
    }
}

#pragma mark ------ QQ登录时网络有问题 ------
- (void)tencentDidNotNetWork {
    [ADLToast showMessage:@"关联失败，请重试！"];
}

#pragma mark ------ 绑定第三方 ------
- (void)bindingAccountWithUnionId:(NSString *)unionId type:(NSInteger)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:unionId forKey:@"thirdPartyKey"];
    [params setValue:@(type) forKey:@"thirdPartyType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_thirdPartyBind parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLUserModel *model = [ADLUserModel sharedModel];
            if (type == 1) {
                model.isBindQq = @(1);
                [self.detailArr replaceObjectAtIndex:1 withObject:@"已关联"];
            } else {
                model.isBindWeixin = @(1);
                [self.detailArr replaceObjectAtIndex:0 withObject:@"已关联"];
            }
            [ADLUserModel saveUserModel:model];
            [self.tableView reloadData];
            [ADLToast showMessage:@"关联成功"];
        }
    } failure:nil];
}

#pragma mark ------ 解绑第三方 ------
- (void)unbindingThird:(NSInteger)index {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (index == 0) {
        [params setValue:@(2) forKey:@"thirdPartyType"];
    } else {
        [params setValue:@(1) forKey:@"thirdPartyType"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_removeunbind parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLUserModel *model = [ADLUserModel sharedModel];
            if (index == 0) {
                model.isBindWeixin = @(0);
            } else {
                model.isBindQq = @(0);
            }
            [ADLUserModel saveUserModel:model];
            [self.detailArr replaceObjectAtIndex:index withObject:@"未关联"];
            [self.tableView reloadData];
            [ADLToast showMessage:@"取消关联成功"];
        }
    } failure:nil];
}

@end
