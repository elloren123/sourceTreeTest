//
//  ADLAddDeviceStepTwoController.m
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddDeviceStepTwoController.h"
#import "ADLDeviceTypeModel.h"
#import "ADLGatewayAddDetailController.h"
@interface ADLAddDeviceStepTwoController ()

@property (nonatomic ,strong) UIView *headView;

@property (nonatomic ,strong) UIImageView *connectResultImgView;

@property (nonatomic ,strong) UILabel *connectResultLab;

@property (nonatomic ,strong) UIButton *sureBtn;

@property (nonatomic ,strong) NSTimer *connectTimer;

@property (nonatomic ,assign) NSInteger count;

@property (nonatomic ,assign) BOOL connectSuccess;

@end

@implementation ADLAddDeviceStepTwoController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.connectTimer) {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
    }
    if([ADLToast isShowLoading]){
        [ADLToast hide];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:@"连接设备"];
    [self setSubViews];
    self.count = 0;
    __weak typeof(self)weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
    [self openZib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDeviceZibOpenMQBack:) name:@"ADELAddGasValveStorageBoxZibOpenMQNotification" object:nil];
    //待增加设备连接逻辑  TODO 设备添加,就一个监听MQ消息;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDeviceMQBack:) name:@"ADELAddGasValveStorageBoxMQNotification" object:nil];
}

#pragma mark ------ openZib ------
-(void)openZib{
    NSString *gatewayCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADD_CHILD_GATEWAY_CODE"];
    NSString *gatewayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADD_CHILD_GATEWAY_ID"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:gatewayID forKey:@"gatewayId"];
    [params setValue:gatewayCode forKey:@"gatewayCode"];
    [params setValue:gatewayCode forKey:@"gatewayMac"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//ADEL_family_zigbee_open  @"http://172.18.0.215:8080/lockboss-mqtt/gecko2/zigbee/open.do"
    [ADLNetWorkManager postWithPath:ADEL_family_zigbee_open parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"打开zib == %@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLLog(@"设备正常联网");
        }else{
            [self connectFial];
        }
    } failure:^(NSError *error) {
        ADLLog(@"%@",error);
        [self connectFial];
    }];
    
}
//ADEL_family_zigbee_open


#pragma mark ------ View ------
-(void)setSubViews{
    UIView *hView = [[UIView alloc] init];
    hView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:hView];
    self.headView = hView;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(NAVIGATION_H);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT*200/667);
    }];
    NSString *deviceName = nil;
    NSString *devicePicName = nil;
    if ([self.deviceTypeModel.deviceType isEqualToString:@"51"]) {
        deviceName =@"储物箱";
        devicePicName = @"icon_device_boxoff";
    }else if([self.deviceTypeModel.deviceType isEqualToString:@"41"]){
        deviceName =@"燃气阀";
        devicePicName = @"icon_device_gason";
    }
    
    UIImageView *deviceImgView = [[UIImageView alloc]init];
    deviceImgView.contentMode = UIViewContentModeScaleAspectFit;
    deviceImgView.image = [UIImage imageNamed:devicePicName];
   
    [hView addSubview:deviceImgView];
    
    [deviceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(hView.mas_centerX).offset(0);
        make.centerY.mas_equalTo(hView.mas_centerY).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH*190/375);
    }];
    
    UILabel *deviceNamelab = [self.view createLabelFrame:CGRectZero font:12 text:deviceName texeColor:COLOR_333333];
    deviceNamelab.textAlignment = NSTextAlignmentCenter;
    [hView addSubview:deviceNamelab];
    [deviceNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hView.mas_left).offset(0);
        make.right.mas_equalTo(hView.mas_right).offset(0);
        make.bottom.mas_equalTo(hView.mas_bottom).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    UIImageView *connectResultView = [[UIImageView alloc] init];
    [self.view addSubview:connectResultView];
    connectResultView.hidden = YES;
    self.connectResultImgView = connectResultView;
    [connectResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.top.mas_equalTo(hView.mas_bottom).offset(SCREEN_HEIGHT*46/667);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *connectResultLabel = [self.view createLabelFrame:CGRectZero font:14 text:@"" texeColor:COLOR_333333];
    connectResultLabel.textAlignment = NSTextAlignmentCenter;
    connectResultLabel.hidden = YES;
    self.connectResultLab = connectResultLabel;
    [self.view addSubview:connectResultLabel];
    [connectResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(connectResultView.mas_bottom).offset(SCREEN_HEIGHT*30/667);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sBtn setTitle:@"返回" forState:UIControlStateNormal];
    [sBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0]];
    [sBtn addTarget:self action:@selector(clickAgainOrBackBtn) forControlEvents:UIControlEventTouchUpInside];
    sBtn.hidden = YES;
    [self.view addSubview:sBtn];
    self.sureBtn = sBtn;
    [sBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50-BOTTOM_H);
        make.height.mas_equalTo(40);
    }];
    [ADLToast showLoadingMessage:@"正在连接设备，请稍后..."];
}
#pragma mark ------ 重试/返回 ------
-(void)clickAgainOrBackBtn{
    if(self.connectSuccess){
        //返回ADLGatewayAddDetailController
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ADLGatewayAddDetailController class]]) {
                ADLGatewayAddDetailController *A =(ADLGatewayAddDetailController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
    }else{
        //重新连接
        self.connectResultImgView.hidden = YES;
        self.connectResultLab.hidden = YES;
        self.sureBtn.hidden = YES;
        self.count = 0;
        [ADLToast showLoadingMessage:@"正在连接设备，请稍后..."];
        [self openZib];
        __weak typeof(self)weakSelf = self;
        if (@available(iOS 10.0, *)) {
            self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf timerRun];
            }];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark ------ Timer ------
-(void)timerRun{
    self.count++;
    if (self.count >60) {
        [self connectFial];
    }
}

-(void)connectFial{
    if([ADLToast isShowLoading]){
        [ADLToast hide];
    }
    self.connectSuccess = NO;
    [self.connectTimer invalidate];
    self.connectResultImgView.hidden = NO;
    self.connectResultLab.hidden = NO;
    self.sureBtn.hidden = NO;
    self.connectResultImgView.image = [UIImage imageNamed:@"review_fail"];
    self.connectResultLab.text = @"连接失败";
    [self.sureBtn setTitle:@"重新连接" forState:UIControlStateNormal];
}


-(void)addDeviceMQBack:(NSNotification *)notifiaction{
    [self.connectTimer invalidate];
    if([ADLToast isShowLoading]){
        [ADLToast hide];
    }
    ADLLog(@"D52--MQ的返回 === %@",notifiaction.userInfo);
    self.connectResultImgView.hidden = NO;
    self.connectResultLab.hidden = NO;
    self.sureBtn.hidden = NO;
    if ([notifiaction.userInfo[@"resultCode"] integerValue] == 10000) {
        self.connectSuccess = YES;
        self.connectResultImgView.image = [UIImage imageNamed:@"review_success"];
        self.connectResultLab.text = @"连接成功";
        [self.sureBtn setTitle:@"返回" forState:UIControlStateNormal];
    } else {
        self.connectSuccess = NO;
        self.connectResultImgView.image = [UIImage imageNamed:@"review_fail"];
        self.connectResultLab.text = @"连接失败";
        [self.sureBtn setTitle:@"重新连接" forState:UIControlStateNormal];
    }
    
}
//zib打开 成功/失败
-(void)addDeviceZibOpenMQBack:(NSNotification *)notifiaction{
    ADLLog(@"MQ的返回 === %@",notifiaction.userInfo);
    if ([notifiaction.userInfo[@"resultCode"] integerValue] == 10000) {
        ADLLog(@"打开zib成功");
    } else {
        [self connectFial];
    }
    
}

-(void)dealloc{
    NSLog(@" 销毁 ===   %s", __func__);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"111");
}


@end
