//
//  ADLlockSetsController.m
//  lockboss
//
//  Created by adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLlockSetsController.h"
#import "ADLLockMode.h"
@interface ADLlockSetsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign)NSInteger password ;
@property (nonatomic, strong) UISwitch *switchBtn;
//@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) ADLLockMode *lockModel;
@end

@implementation ADLlockSetsController

static NSString *const reuseId = @"cell";
#pragma mark ~~~~~~~~~~ 页面加载 ~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
   [self addRedNavigationView:ADLString(@"秘钥管理")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    if ([self.model.deviceType isEqualToString:@"30"]) {
        [self getOpenType];
    }else {
        [self LockModeData];
    }
   
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([ws.model.deviceType isEqualToString:@"30"]) {
            [ws getOpenType];
        }else {
            [ws LockModeData];
        }
        
    } ];
}

// L3获取开门方式查询
-(void)getOpenType{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceType"] =  self.model.deviceType;
    params[@"checkingInId"] = self.model.checkingInId;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    //进行POST请求
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_getOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"%@",responseDict);
        [ws.tableView.mj_header endRefreshing];
         [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ws.titleArr removeAllObjects];
            ADLLockMode *model=[ADLLockMode mj_objectWithKeyValues:responseDict[@"data"]];
            ws.lockModel = model;
            if ([model.openApp integerValue] >= 0) {
                [ws.titleArr addObject:ADLString(@"APP开锁")];
            }
            if ([model.openPassword integerValue] >= 0) {
                [ws.titleArr addObject:ADLString(@"密码开锁")];
            }
            if ([model.openCard integerValue] >= 0) {
                [ws.titleArr addObject:ADLString(@"房卡开锁")];
            }
            if ([model.openFingerprint integerValue] >= 0) {
                [ws.titleArr addObject:ADLString(@"指纹开锁")];
            }
            
            if ([model.openFace integerValue] >= 0) {
                [ws.titleArr addObject:ADLString(@"人脸开锁")];
            }
            [ws.tableView reloadData];
        }else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
        
        
    } failure:^(NSError *error) {
        [ADLToast hide];
        [ws.tableView.mj_header endRefreshing];
 
    }];
}


-(void)LockModeData {
    self.password = 0;
    NSString *deviceCode =self.model.deviceCode;;
    if (deviceCode.length == 0) {
        [ADLToast showMessage:ADLString(@"该房间没有设备")];
        return ;
    }
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"checkingInId"] =  self.model.checkingInId;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    WS(ws);
    //进行POST请求
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_selectSecret parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            ws.titleArr =[ADLLockMode mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            [ws  openLockData];
            
        }else {
            [ws.tableView.mj_header endRefreshing];
             [ADLToast hide];
            [ADLToast showMessage:responseDict[@"msg"]];
            [ws.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        [ADLToast hide];
    }];
    
}
//指纹开门查询
-(void)openLockData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"checkingInId"] =  self.model.checkingInId;
   params[@"sign"] =  [ADLUtils handleParamsSign:params];
    
    WS(ws);
    //进行POST请求
    [ADLNetWorkManager postWithPath:ADEL_getOpenTyp parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (![responseDict[@"data"] isEqual:[NSNull null] ] ) {
             ADLLockMode *model =[ADLLockMode mj_objectWithKeyValues:responseDict[@"data"]];
                [ws.titleArr addObject:model];
                
                ws.password = 1;
                
            }else {
                [ADLToast showMessage:responseDict[@"msg"]];
            }
            [ws.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
        [ws.tableView.mj_header endRefreshing];
    }];
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
        
    }
    return _titleArr;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark ~~~~~~~~~~ TableViewDataSource ~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor =COLOR_333333;
    
    UISwitch *swithBtn = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 62, 10, 50, 30)];
    [swithBtn addTarget:self action:@selector(swithBtn:) forControlEvents:UIControlEventTouchUpInside];
    swithBtn.tag = indexPath.row;
    swithBtn.on = YES;
    [cell addSubview:swithBtn];
    
    
    
    UIView* bottomLine = [UIView new];
    bottomLine.frame = CGRectMake(16, 49.5 , SCREEN_WIDTH-32, 0.5);
    bottomLine.backgroundColor = COLOR_CCCCCC;
    [cell addSubview:bottomLine];
    
    if ([self.model.deviceType isEqualToString:@"30"]) {
        cell.textLabel.text = self.titleArr[indexPath.row];
        
        if ([cell.textLabel.text isEqualToString:ADLString(@"APP开锁")]) {
            if ([self.lockModel.openApp isEqualToString:@"1"]) {
                swithBtn.on = YES;
            }else {
                swithBtn.on = NO;
            }
        }else  if ([cell.textLabel.text isEqualToString:ADLString(@"密码开锁")]) {
            if ([self.lockModel.openPassword isEqualToString:@"1"]) {
                swithBtn.on = YES;
            }else {
                swithBtn.on = NO;
            }
        }else  if ([cell.textLabel.text isEqualToString:ADLString(@"指纹开锁")]) {
            if ([self.lockModel.openFingerprint isEqualToString:@"1"]) {
                swithBtn.on = YES;
            }else {
                swithBtn.on = NO;
            }
        }else  if ([cell.textLabel.text isEqualToString:ADLString(@"房卡开锁")]) {
            if ([self.lockModel.openCard isEqualToString:@"1"]) {
                swithBtn.on = YES;
            }else {
                swithBtn.on = NO;
            }
        }else  if ([cell.textLabel.text isEqualToString:ADLString(@"人脸开锁")]) {
            if ([self.lockModel.openFace isEqualToString:@"1"]) {
                swithBtn.on = YES;
            }else {
                swithBtn.on = NO;
            }
        }
        
        
    }else {
        ADLLockMode *model =self.titleArr[indexPath.row];
        if (self.password == 1) {
            if (self.titleArr.count ==indexPath.row+1 ) {
                
                if ([model.openApp isEqualToString:@"1"]) {
                    swithBtn.on = YES;
                } else {
                    swithBtn.on = NO;
                }
                cell.textLabel.text = ADLString(@"APP开锁");
                return cell;
            }
        }
        swithBtn.on = model.isOpen;
        //    if ([model.isOpen isEqualToString:@"true"]) {
        //        swithBtn.on = YES;
        //    } else {
        //        swithBtn.on = NO;
        //    }
        if ([model.type isEqualToString:@"1"]) {
            cell.textLabel.text = ADLString(@"密码开锁");
        }else   if ([model.type isEqualToString:@"2"]) {
            cell.textLabel.text =ADLString(@"房卡开锁");
        }else   if ([model.type isEqualToString:@"3"]) {
            cell.textLabel.text = ADLString(@"指纹开锁");
            cell.detailTextLabel.textColor = [UIColor grayColor];
            if(model.secretName.length > 0){
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"指纹名称"),model.secretName];
            }
            
        } else   if ([model.type isEqualToString:@"4"]) {
            cell.textLabel.text = ADLString(@"蓝牙开锁");
        }
    }
    return cell;
}
-(void)swithBtn:(UISwitch *)btn{
    self.switchBtn = btn;
    // L3门锁类型等于30
    if ([self.model.deviceType isEqualToString:@"30"]) {
        [self secretManage:btn.tag swithBtn:btn];
    }else {
        if (self.password == 1) {
            if (self.titleArr.count == btn.tag+1) {
                [self openTypeData:btn.tag swithBtn:btn];
            }else {
                [self secretManage:btn.tag swithBtn:btn];
            }
        }else {
            [self secretManage:btn.tag swithBtn:btn];
        }
    }
    
}

-(void)openTypeData:(NSInteger)tag swithBtn:(UISwitch *)btn{
    //  ADLLockMode *model =self.titleArr[btn.tag];
    
    NSInteger openStatus;
    if (btn.on == YES) {
        openStatus = 1;
        
    } else {
        openStatus = 0;
    }
    //openStatus ： 1是开，0:是关
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.titleArr.count == btn.tag+1) {
        params[@"checkingInGuestId"] =self.model.checkingInId;
        params[@"openType"] = @(1);
        params[@"openStatus"] =  @(openStatus);
        params[@"sign"] =  [ADLUtils handleParamsSign:params];
    }
    
    // ADLLog(@"%@%@",params);
    [ADLNetWorkManager postWithPath:ADEL_openType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        //ADLLog(@"%@",response);
        [ADLToast showMessage:responseDict[@"msg"]];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            btn.on = btn.on;
            
        }else {
            
            btn.on = !btn.on;
        }
    } failure:^(NSError *error) {
        btn.on = !btn.on;
       
    }];
    
}

-(void)secretManage:(NSInteger)tag swithBtn:(UISwitch *)btn{
    
    NSInteger openStatus;
    if (btn.on == YES) {
        openStatus = 1;
        
    } else {
        openStatus = 0;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *stringUrl;
    if ([self.model.deviceType isEqualToString:@"30"]) {
        stringUrl =ADEL_setOpenTypeL3;
        //开/关
        params[@"isUsing"] =@(openStatus);//开关 1是开，0:是关
        //openType开门方式1手机 2卡 3密码 4指纹 5人脸
        if ([self.titleArr[btn.tag] isEqualToString:ADLString(@"APP开锁")]) {
            params[@"openType"] =@(1);
        }else    if ([self.titleArr[btn.tag] isEqualToString:ADLString(@"房卡开锁")]) {
            params[@"openType"] =@(2);
        }else    if ([self.titleArr[btn.tag] isEqualToString:ADLString(@"密码开锁")]) {
            params[@"openType"] =@(3);
        }else    if ([self.titleArr[btn.tag] isEqualToString:ADLString(@"指纹开锁")]) {
            params[@"openType"] =@(4);
        }else    if ([self.titleArr[btn.tag] isEqualToString:ADLString(@"人脸开锁")]) {
            params[@"openType"] =@(5);
        }
    }else {
        stringUrl =ADEL_secretManage;
        ADLLockMode *model =self.titleArr[btn.tag];
        params[@"secretType"] =model.type;
        params[@"secretId"] = model.secretId;
        params[@"openType"] =@(openStatus);//开/关 1是开，0:是关
    }
    params[@"gatewayCode"] =self.model.gatewayCode;
    params[@"checkingInId"] =self.model.checkingInId;
    params[@"deviceCode"] = self.model.deviceCode;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    
   
    [ADLNetWorkManager postWithPath:stringUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        //ADLLog(@"%@",response);
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            
         //   [[NSNotificationCenter defaultCenter] addObserver:ws selector:@selector(MQNotiLockSecretManage:btn:) name:ADELLocksecretManageMQNotification object:nil];
            
        }else {
            
            btn.on = !btn.on;
            
            [ADLToast showMessage:responseDict[@"msg"]];
            
        }
    } failure:^(NSError *error) {
          btn.on = !btn.on;
    }];
    
    
}
-(void)MQNotiLockSecretManage:(NSNotification *)notification btn:(UISwitch *)btn{
    WS(ws);
    
    NSDictionary *dict = notification.userInfo;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ADLToast showMessage:dict[@"msg"]];
        if ([dict[@"resultCode"] integerValue] == 10000) {
            
            ws.switchBtn.on = ws.switchBtn.on;
            
        }else {
            
            ws.switchBtn.on = !ws.switchBtn.on;
            
            
        }
        
    });
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
