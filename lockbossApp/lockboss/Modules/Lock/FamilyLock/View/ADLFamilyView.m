//
//  ADLFamilyView.m
//  lockboss
//
//  Created by Adel on 2019/8/27.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilyView.h"

#import "ADLGlobalDefine.h"

#import "ADLNetWorkManager.h"

#import "ADLLocalizedHelper.h"

#import "ADLDeviceModel.h"

#import "ADELUrlpath.h"

#import "ADLUtils.h"

#import "ADLToast.h"

#import <MJRefreshHeader.h>

#import <NSObject+MJKeyValue.h>

#import "ADLStorageBoxPayView.h"//储物箱付费View

#import "ADLGuestRoomsModel.h"

#import "ADLTimeOrStamp.h"

#import "ADLFTTEncryption.h"

#import "ADLBluetoothTool.h" //蓝牙开锁

#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"

#import "ADLAlertView.h"

#import "ADLApiDefine.h"

@interface ADLFamilyView ()
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *unlockView;
@property (nonatomic, strong) UIImageView *lockView;

@property (nonatomic, strong) UIImageView *deviceImgView;//增加一个储物箱和燃气阀的图片显示

@property (nonatomic, strong) UIButton *batteryBtn;

@property (nonatomic, strong) UILabel *deviceNameLab;//添加一个当前操作的设备的名称

@property (nonatomic, strong) UILabel *patternLab;
@property (nonatomic, strong) UILabel *offlineLab;
@property (nonatomic, strong) UILabel *promptLab;

@property (nonatomic, strong) UILabel *isOpenOrCloseLab;//增加一个储物箱与燃气阀的当前打开关闭状态显示;不准确,因为后台没有设备打开关闭的状态返回
@property (nonatomic, strong) UISegmentedControl *onOffSegmentC;//增加一个燃气阀和储物箱的开关控制

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL RMQLock;

@property (nonatomic ,strong) ADLGuestRoomsModel *roomMessageModel;//433系列的房间信息

@property (nonatomic, strong) ADLBluetoothTool *bluetoothTool;



@end

@implementation ADLFamilyView




- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

#pragma mark ------ set ------
-(void)setCheckingInId:(NSString *)checkingInId{
    _checkingInId = checkingInId;
    if ([checkingInId isEqualToString:@"0"]) {
        _checkingInId = nil;
    }
    ADLLog(@"_roomID === %@",_checkingInId);
    [self getSelectDeviceData];
}
-(void)setIsFTT:(BOOL)isFTT {
    _isFTT = isFTT;
    NSData *hotelData = [ADLUtils valueForKey:HOTEL_SEL_ROOM_MESSAGE];
    ADLGuestRoomsModel *hotelRoomModel = (ADLGuestRoomsModel *)[NSKeyedUnarchiver unarchiveObjectWithData:hotelData];
    self.roomMessageModel = hotelRoomModel;
    [self setUIForFTT];
}

#pragma mark ------ 初始化View ------
- (void)setupView {
    CGFloat contentH = NAVIGATION_H+569;
    if (SCREEN_HEIGHT > contentH) contentH = SCREEN_HEIGHT+1;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = COLOR_E0212A;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    //刷新  TODO  是否需要处理一下  ??
    __weak typeof(self)weakSelf = self;
    scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshUserPattern)]) {
            [weakSelf.delegate refreshUserPattern];
        }
        [weakSelf getSelectDeviceData];
    }];
    
    //背景图片
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H+306)];
    backView.image = [UIImage imageNamed:@"lock_home_bg"];
    [scrollView addSubview:backView];
    
    //添加一个当前操作的设备的名称
    UILabel *deviceNameLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, NAVIGATION_H+20, 100, 16)];
    deviceNameLab.textAlignment = NSTextAlignmentCenter;
    deviceNameLab.font = [UIFont boldSystemFontOfSize:12];
    deviceNameLab.textColor = [UIColor whiteColor];
    deviceNameLab.text = @"";
    [scrollView addSubview:deviceNameLab];
    self.deviceNameLab = deviceNameLab;
    
    //************解锁图片************
    //白圈
    UIImageView *unlockView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, NAVIGATION_H+66, 160, 160)];
    unlockView.image = [UIImage imageNamed:@"unlock_bg"];
    [scrollView addSubview:unlockView];
    self.unlockView = unlockView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUnlock)];
    [unlockView addGestureRecognizer:tap];
    
    //当前锁的状态ImageView
    //锁的图片/打开的/关闭的
    UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, NAVIGATION_H+111, 60, 60)];
    lockView.image = [UIImage imageNamed:@"lock_status"];
    [scrollView addSubview:lockView];
    self.lockView = lockView;
    
    //当前状态提示label
    //锁的打开和关闭/点击开锁,开锁中...,开锁成功,开锁失败
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, NAVIGATION_H+179, 80, 16)];
    promptLab.textAlignment = NSTextAlignmentCenter;
    promptLab.font = [UIFont boldSystemFontOfSize:12];
    promptLab.textColor = [UIColor whiteColor];
    promptLab.text = ADLString(@"tap_unlock");
    [scrollView addSubview:promptLab];
    self.promptLab = promptLab;
    
    //************燃气阀和储物箱图片显示************
    UIImageView *deviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, NAVIGATION_H+66, 200, 160)];
    deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"]; //图片待定,需要根据用户选中设备情况更改,储物箱两种图片,燃气阀一种; TODO
    deviceImgView.contentMode = UIViewContentModeScaleAspectFit;
    deviceImgView.hidden = YES;//默认是隐藏的,搭建UI时先屏蔽
    [scrollView addSubview:deviceImgView];
    self.deviceImgView = deviceImgView;
    
    //电池Button
    UIButton *batteryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+249, SCREEN_WIDTH, 15)];
    batteryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    batteryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [batteryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollView addSubview:batteryBtn];
    self.batteryBtn = batteryBtn;
    
    //设备离线Label
    UILabel *offlineLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+265, SCREEN_WIDTH-60, 20)];
    offlineLab.textAlignment = NSTextAlignmentCenter;
    offlineLab.font = [UIFont boldSystemFontOfSize:12];
    offlineLab.textColor = [UIColor whiteColor];
    offlineLab.text = ADLString(@"device_offline");
    offlineLab.hidden = YES;  //TODO
    [scrollView addSubview:offlineLab];
    self.offlineLab = offlineLab;
    
    //当前模式Label (开门方式和常开常闭)
    UILabel *patternLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+285, SCREEN_WIDTH-60, 16)];
    patternLab.textAlignment = NSTextAlignmentCenter;
    patternLab.font = [UIFont boldSystemFontOfSize:12];
    patternLab.textColor = [UIColor whiteColor];
    [scrollView addSubview:patternLab];
    self.patternLab = patternLab;
    
    //这里还需要添加一个用于显示储物箱和燃气阀的打开和关闭状态,离线情况下隐藏;  TODO
    UILabel *isOpenOrCloseLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+285, SCREEN_WIDTH-60, 16)];
    isOpenOrCloseLab.textAlignment = NSTextAlignmentCenter;
    isOpenOrCloseLab.font = [UIFont boldSystemFontOfSize:12];
    isOpenOrCloseLab.textColor = [UIColor whiteColor];
    isOpenOrCloseLab.text = @""; //TODO  测试给死,后面要设置成 "";
    [scrollView addSubview:isOpenOrCloseLab];
    self.isOpenOrCloseLab = isOpenOrCloseLab;

    
    //添加一个OFF/NO的开关
    UISegmentedControl *onOffSegmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"OFF",@"NO", nil]];
    onOffSegmentC.frame = CGRectMake((SCREEN_WIDTH-220)/2,NAVIGATION_H+330, 220, 44);
    onOffSegmentC.layer.borderColor = [UIColor colorWithRed:225/255.0 green:177/255.0 blue:60/255.0 alpha:1.0].CGColor;
    onOffSegmentC.layer.borderWidth = 1;
    onOffSegmentC.tintColor = [UIColor blackColor];
    onOffSegmentC.backgroundColor = [UIColor whiteColor];
    NSDictionary *normal_title_dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:49/255.0 green:49/255.0 blue:66/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont systemFontOfSize:22],NSFontAttributeName,nil];
    [onOffSegmentC setTitleTextAttributes:normal_title_dic forState:UIControlStateNormal];
    NSDictionary *select_title_dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:225/255.0 green:177/255.0 blue:60/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont systemFontOfSize:22],NSFontAttributeName,nil];
    [onOffSegmentC setTitleTextAttributes:select_title_dic forState:UIControlStateSelected];
    onOffSegmentC.layer.cornerRadius = 22.0f;
    onOffSegmentC.layer.masksToBounds = YES;
    onOffSegmentC.hidden = YES;
    [onOffSegmentC addTarget:self action:@selector(clickOnOffSegment:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:onOffSegmentC];
    self.onOffSegmentC = onOffSegmentC;
    onOffSegmentC.selectedSegmentIndex = 0;
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-120-BOTTOM_H, SCREEN_WIDTH, 120+BOTTOM_H)];
    bottomView.backgroundColor = [UIColor whiteColor];
    //TODO,要设置左上右上角
     UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = bottomView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    bottomView.layer.mask = maskLayer;
    [scrollView addSubview:bottomView];
    self.bottomView = bottomView;
    
    //添加写死的头部
    UILabel *bottom_title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 30)];
    bottom_title.text = @"智能客房";//TODO  没有英文
    bottom_title.font = [UIFont systemFontOfSize:12];
    bottom_title.textColor = COLOR_333333;
    [bottomView addSubview:bottom_title];
    
    UIButton *bottom_moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottom_moreBtn.frame = CGRectMake(SCREEN_WIDTH-60-18, 0, 60, 30);
    [bottom_moreBtn setTitle:@"更多" forState:UIControlStateNormal];//TODO  没有英文
    [bottom_moreBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [bottom_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    bottom_moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bottom_moreBtn addTarget:self action:@selector(clickMoreDevice) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottom_moreBtn];
    
    CGFloat imgW = 60;//设置图片的大小
    CGFloat titW = 80;//对应的设备标题长度
    //因为UI默认就显示四个,所以,直接使用uiview填充;
    CGFloat imgGap = (SCREEN_WIDTH - 60*4)/8;
    CGFloat titGap = (SCREEN_WIDTH - 80*4)/8;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgGap+(i%4)*(imgGap*2+imgW), 30, imgW, imgW)];
        imgView.userInteractionEnabled = NO;
        imgView.tag = i+1000;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomView addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [imgView addGestureRecognizer:tap];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(titGap+(i%4)*(titGap*2+titW), 30+imgW+10, titW, 20)];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.font = [UIFont systemFontOfSize:12];
        titLab.tag = 100 +i;
        [bottomView addSubview:titLab];
        
        UIView *payV = [self payView];
        [bottomView addSubview:payV];
        payV.hidden = YES;
        payV.tag = 9999+i;
        payV.frame = CGRectMake(ceilf(imgGap+(i%4)*(imgGap*2+imgW)+imgW-28),30,28,14);
        [bottomView bringSubviewToFront:payV];
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectDeviceData) name:@"ADELfamillockUpdateDeviceNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockNotification:) name:@"ADELOpenLockreceiveMQNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StorageBoxMQNotification:) name:@"ADELOpenLockStorageBoxMQNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GasValveMQNotification:) name:@"ADELOpenLockGasValveMQNotification" object:nil];
    
    //蓝牙开锁停止通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockFailed) name:@"ADELMsgRemindOpenLockNotification" object:nil];
    //更换设备刷新  TODO ,蓝牙中没有看到这个通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LreplaceDevick:) name:@"ADELreplaceDevickNotification" object:nil];
    //蓝牙开锁开成功self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLockSuccessful) name:@"ADELOpenLockSuccessfulNotification" object:nil];
    
    //支付宝返回通知结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResultOrder:) name:PAY_RESULT_ORDER object:nil];
    //微信返回通知结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResultOrderWX:) name:PAY_RESULT_STATUS object:nil];
    
}
#pragma mark ------ 付费 item view ------
-(UIView *)payView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
    view.layer.cornerRadius = 7;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0].CGColor;
    UILabel *lab = [view createLabelFrame:view.frame font:9 text:@"付费" texeColor:[UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0]];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}

#pragma mark ------ 点击更多设备 ------
-(void)clickMoreDevice {
    //433系列要处理 TODO
    if (self.isFTT) {
        [ADLToast showMessage:@"没有更多的设备了!" duration:2];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(goAllUserDeviceVC)]) {
        [self.delegate goAllUserDeviceVC];
    }
}

#pragma mark ------ 开锁 ------
- (void)clickUnlock {
    self.unlockView.userInteractionEnabled = NO;
    self.promptLab.text = ADLString(@"unlocking");
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0.9);
    animation.toValue = @(1.1);
    animation.duration = 1;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.unlockView.layer addAnimation:animation forKey:@"scale"];
    
    
    //*********************添加433的网络锁和蓝牙锁判断************************
    if (self.isFTT) {
        //酒店
        //1.判断是否超出入住时间
        if ([ADLTimeOrStamp compareDateseconds:self.roomMessageModel.endDatetime] == 1) {//你已经超出入住时间
            [ADLToast showMessage:@"你已经超出入住时间!" duration:2];
            return ;
        }
        NSString *bluetoothName = self.roomMessageModel.bluetoothName;
        NSString *bluetoothKey = self.roomMessageModel.bluetoothKey;
        //2.ifh蓝牙开锁
        if (bluetoothName.length > 0 && bluetoothKey.length >1) {
            [self openLockFTTBluetooth];
        }else {
        //3.F433网络开锁
            [self openlockFTTWifi];
        }
        return ;
    }
    
    //---继续原来的开锁流程---
    self.RMQLock = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    
    NSString *url = nil;
    if (self.checkingInId) {
        [params setValue:self.checkingInId forKey:@"checkingInId"];
        url = ADEL_openLock;
        
    }else{
        url = ADEL_family_openLock;
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //开锁的状态已MQ返回的为准,会接收到MQ推送的消息 --->开锁通知,如果获取到的服务器消息是设备的,就一定失败
    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"开锁请求返回=== %@ \n",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.RMQLock == NO) {
                    [self unlockFailed];
                }
            });
        } else {
            [self unlockFailed];
        }
    } failure:^(NSError *error) {
        [self unlockFailed];
    }];
}

#pragma mark ------ 开锁MQ通知 ------
- (void)unlockNotification:(NSNotification *)notifiaction {
    self.RMQLock = YES;
    ADLLog(@"一般锁的-- MQ的返回 === %@",notifiaction.userInfo);
    if ([notifiaction.userInfo[@"resultCode"] integerValue] == 10000) {
        
//        if ([notifiaction.userInfo[@"openGroup"] boolValue]) {
//            self.promptLab.text = ADLString(@"unlock_failed");
//        } else {
            self.promptLab.text = ADLString(@"unlock_success");
            self.lockView.image = [UIImage imageNamed:@"unlock_status"];
//        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopUnlockAnimation];
        });
      } else {
        [self unlockFailed];
    }
}

-(void)StorageBoxMQNotification:(NSNotification *)notifiaction {
    self.RMQLock = YES;
    ADLLog(@"MQ的返回 === %@",notifiaction.userInfo);
    if ([notifiaction.userInfo[@"resultCode"] integerValue] == 10000) {
        
        self.isOpenOrCloseLab.text = ADLString(@"unlock_success");
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxon"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isOpenOrCloseLab.text = @"";
            self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
            self.onOffSegmentC.userInteractionEnabled = YES;
            self.onOffSegmentC.selectedSegmentIndex = 0;
        });
    } else {
        [self boxCliqueunlockFailed];
    }
    
}

-(void)GasValveMQNotification:(NSNotification *)notification {
    self.RMQLock = YES;
    ADLLog(@"MQ的返回 === %@",notification.userInfo);
    if ([notification.userInfo[@"resultCode"] integerValue] == 10000) {
        self.isOpenOrCloseLab.text = ADLString(@"unlock_success");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isOpenOrCloseLab.text = @"";
            self.onOffSegmentC.userInteractionEnabled = YES;
            self.onOffSegmentC.selectedSegmentIndex = 0;
        });
    } else {
        [self GasValveOpenFaild];
    }
}
#pragma mark ------ 开锁失败 ------
//储物箱开锁失败
-(void)boxCliqueunlockFailed{
    self.isOpenOrCloseLab.text = ADLString(@"unlock_failed");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isOpenOrCloseLab.text = @"";
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
        self.onOffSegmentC.userInteractionEnabled = YES;
        self.onOffSegmentC.selectedSegmentIndex = 0;
    });
}
//燃气阀开锁失败
-(void)GasValveOpenFaild {
    self.isOpenOrCloseLab.text = ADLString(@"unlock_failed");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isOpenOrCloseLab.text = @"";
        self.onOffSegmentC.userInteractionEnabled = YES;
        self.onOffSegmentC.selectedSegmentIndex = 0;
    });
}

- (void)unlockFailed {
    self.promptLab.text = ADLString(@"unlock_failed");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopUnlockAnimation];
    });
}
#pragma mark ------ OFF/NO的开关点击 ------
//我们的设备,都是只能远程开,关闭是用户手动关闭的
-(void)clickOnOffSegment:(UISegmentedControl *)sender {
    if ([self.model.isFirstConnection isEqualToString:@"1"] || [self.model.deviceStatus isEqualToString:@"1"] ){
        //在线
    }else{
        [ADLToast showMessage:@"设备离线,操作失败!" duration:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.onOffSegmentC.selectedSegmentIndex = 0;
        });
        return;
    }
    
    
    self.onOffSegmentC.userInteractionEnabled = NO;
    self.isOpenOrCloseLab.hidden = NO;
    self.RMQLock = NO;
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
//    [params setValue:self.model.deviceId forKey:@"deviceId"];
//    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
//    [params setValue:self.checkingInId forKey:@"checkingInId"];
//    [params setValue:@(1) forKey:@"cmd"];
//    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    if([self.model.deviceType isEqualToString:@"51"]){
        //储物箱
        BOOL ispayde = [[[NSUserDefaults standardUserDefaults] objectForKey:self.model.deviceId] boolValue];
        if(self.checkingInId && (!ispayde)){//酒店,付费开箱
            [self openStorageBox];
            return;
        }

        NSString *url = nil;
        if (self.checkingInId) {
            url = ADEL_hotel_storageBox_open;
        }else{
            url = ADEL_Family_StorageBox_Open;
        }
        [self openBoxValveWithURL:url deviceType:@"51"];
//        [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//            if ([responseDict[@"code"] integerValue] == 10000) {
//                ADLLog(@"储物箱打开返回==== %@",responseDict);
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.RMQLock == NO) {
//                        [self boxCliqueunlockFailed];
//                    }
//                });
//            } else {
//                [self boxCliqueunlockFailed];
//            }
//        } failure:^(NSError *error) {
//            ADLLog(@"error == \n %@ \n",error)
//            [self boxCliqueunlockFailed];
//        }];
        
    }else if ([self.model.deviceType isEqualToString:@"41"]){
        //燃气阀
        self.isOpenOrCloseLab.text = ADLString(@"unlocking");
        NSString *url = nil;
        if (self.checkingInId) {
            url = ADEL_hotel_gasValve_open;
        }else{
            url = ADEL_Family_GasValve_Open;
        }
        [self openBoxValveWithURL:url deviceType:@"41"];
//        [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//            if ([responseDict[@"code"] integerValue] == 10000) {
//                ADLLog(@"燃气阀打开返回==== %@",responseDict);
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.RMQLock == NO) {
//                        [self GasValveOpenFaild];
//                    }
//                });
//            } else {
//                [self GasValveOpenFaild];
//            }
//        } failure:^(NSError *error) {
//            ADLLog(@"error == \n %@ \n",error)
//            [self GasValveOpenFaild];
//        }];
        
    }
}
//开箱的AF
-(void)openBoxValveWithURL:(NSString *)url deviceType:(NSString *)type{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.checkingInId forKey:@"checkingInId"];
    [params setValue:@(1) forKey:@"cmd"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLLog(@" 储物箱/燃气阀 打开返回==== %@",responseDict);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.RMQLock == NO) {
                    if([type isEqualToString:@"51"]){
                        [self boxCliqueunlockFailed];
                    }else{
                        [self GasValveOpenFaild];
                    }
                }
            });
        } else {
            if([type isEqualToString:@"51"]){
                [self boxCliqueunlockFailed];
            }else{
                [self GasValveOpenFaild];
            }
        }
    } failure:^(NSError *error) {
        ADLLog(@"error == \n %@ \n",error)
        if([type isEqualToString:@"51"]){
            [self boxCliqueunlockFailed];
        }else{
            [self GasValveOpenFaild];
        }
    }];
}


#pragma mark ------ 储物箱开箱前的支付 ------
-(void)openStorageBox{
  
    //1.请求储物箱的支付数据,判断需要支付的金额,支付方式,是否已支付; 已支付--直接开箱; 未支付--支付View
    NSMutableDictionary *params_pay = [[NSMutableDictionary alloc] init];
    [params_pay setValue:[ADLUtils handleParamsSign:params_pay] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_storageBox_price parameters:params_pay autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"储物箱价格信息==== %@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.RMQLock == NO) {
//                    [self boxCliqueunlockFailed];
//                }
//            });
            NSDictionary *data = responseDict[@"data"];
            __weak typeof(self)weakSelf = self;
            [ADLStorageBoxPayView showPayViewWithMessage:data finishBlock:^(NSString * _Nonnull payway) {
                ADLLog(@"选择的支付方式== %@",payway);
                //吊起支付  TODO
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf payMoneyWith:data payway:payway];
                
                
            }];
        }
    } failure:^(NSError *error) {
        ADLLog(@"error == \n %@ \n",error);
         [self boxCliqueunlockFailed];
    }];
    
    
    
}

#pragma mark ------ 调起支付 ------
-(void)payMoneyWith:(NSDictionary *)priceDic payway:(NSString *)way{
    //ADEL_storageBox_pay
    NSMutableDictionary *params_pay = [[NSMutableDictionary alloc] init];
    [params_pay setValue:way forKey:@"payType"];
    [params_pay setValue:[priceDic objectForKey:@"box_price"] forKey:@"price"];
    [params_pay setValue:@(1) forKey:@"buyType"];
    [params_pay setValue:[ADLUtils handleParamsSign:params_pay] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_storageBox_pay parameters:params_pay autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"储物箱支付信息==== %@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            if([way isEqualToString:@"1"]){//wx
                [self wechatPayWithDict:responseDict[@"data"]];
            }else{//支付宝
                [self alipayWithString:responseDict[@"data"][@"bizContent"]];
            }
            
        }
    } failure:^(NSError *error) {
        ADLLog(@"error == \n %@ \n",error)
    }];
    
    
}
#pragma mark ------ 微信支付 ------
- (void)wechatPayWithDict:(NSDictionary *)dict {
    if ([WXApi isWXAppInstalled]) {
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appId"];
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerId"];
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  =  dict[@"prepayId"];
        // 根据财付通文档填写的数据和签名
        req.package  = dict[@"wxPackage"];
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  =  dict[@"noncestr"];
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        NSString * stamp =  dict[@"timestamp"];
        req.timeStamp = stamp.intValue;
        // 这个签名也是后台做的
        req.sign =  dict[@"sign"];
        //发送请求到微信，等待微信返回onResp
        
//        [WXApi sendReq:req completion:^(BOOL success) {
//            if (success == YES) {
////                [self paySuccesstype:@"1" result:nil];
//                //支付成功,执行开箱操作 TODO
//                self.isOpenOrCloseLab.text = ADLString(@"unlocking");
//                NSString *url = nil;
//                if (self.checkingInId) {
//                    url = ADEL_hotel_storageBox_open;
//                }else{
//                    url = ADEL_Family_StorageBox_Open;
//                }
//                [self openBoxValveWithURL:url deviceType:@"51"];
//                //同时需要更新客房的 isBox 数值
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"BOX_PAY_SUCCESS" object:nil];
//            }
//
//        }];
          [WXApi sendReq:req completion:nil];
        
    } else {
        NSURL *wechatUrl = [NSURL URLWithString:k_wechat_download_string];
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"你还未安装微信客户端，是否前去下载？" confirmTitle:@"下载" confirmAction:^{
            [[UIApplication sharedApplication] openURL:wechatUrl];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 支付宝支付 ------
- (void)alipayWithString:(NSString *)orderStr {
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"alipay2018052560266007" callback:^(NSDictionary *resultDic) {
        //未安装支付宝网页支付完成回调此方法
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
//        self.result =resultDic[@"result"];
        NSString *messageStr = @"支付失败";
        if ([resultCodeStr isEqualToString:@"9000"]) messageStr = @"支付成功";
        else if ([resultCodeStr isEqualToString:@"5000"]) messageStr = @"重复请求";
        else if ([resultCodeStr isEqualToString:@"6001"]) messageStr = @"支付已取消";
        else if ([resultCodeStr isEqualToString:@"8000"]) messageStr = @"订单处理中，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6002"]) messageStr = @"网络连接出错，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6004"]) messageStr = @"支付结果未知，请稍后查看订单状态";
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![messageStr isEqualToString:@"支付成功"]) {
                [ADLToast showMessage:messageStr];
                [self boxCliqueunlockFailed];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_ORDER object:resultDic userInfo:nil];
        });
    }];
}
#pragma mark ------ 支付宝处理支付结果 ------
- (void)dealwithPayResultOrder:(NSNotification *)notification {
    NSDictionary *dict = notification.object;
    if ([dict[@"resultStatus"] isEqualToString:@"9000"]){
//        [self paySuccesstype:@"2" result:dict[@"result"]];
        //支付成功,开箱  TODO
        self.isOpenOrCloseLab.text = ADLString(@"unlocking");
        NSString *url = nil;
        if (self.checkingInId) {
            url = ADEL_hotel_storageBox_open;
        }else{
            url = ADEL_Family_StorageBox_Open;
        }
        [self openBoxValveWithURL:url deviceType:@"51"];
        //同时需要更新客房的 isBox 数值
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOX_PAY_SUCCESS" object:nil];
    }else{
        [self boxCliqueunlockFailed];
    }
}
#pragma mark ------ 微信处理支付结果 ------
-(void)dealwithPayResultOrderWX:(NSNotification *)notification {
    
    NSString *result = notification.object;
    if ([result containsString:@"成功"]) {
//        [self paySuccesstype:@"1" result:nil];
        //支付成功,开箱  TODO
        self.isOpenOrCloseLab.text = ADLString(@"unlocking");
        NSString *url = nil;
        if (self.checkingInId) {
            url = ADEL_hotel_storageBox_open;
        }else{
            url = ADEL_Family_StorageBox_Open;
        }
        [self openBoxValveWithURL:url deviceType:@"51"];
        //同时需要更新客房的 isBox 数值
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOX_PAY_SUCCESS" object:nil];
    }else{
        [self boxCliqueunlockFailed];
    }
}

#pragma mark ------ 获取数据 ------
- (void)getSelectDeviceData {
    if (self.checkingInId == nil) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_family_getUserDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            [self.scrollView.mj_header endRefreshing];
            ADLLog(@"获取到的用户设备信息------ %@",responseDict);
            if ([responseDict[@"code"] integerValue] == 10000) {
                [self.dataArr removeAllObjects];
                self.dataArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
                NSMutableArray *modelArray = [NSMutableArray array];
                
                if (self.dataArr.count > 0) {
                    //有设备,去除 网关 ,内外机,壁虎233
                    NSArray *deleteDeviceTypeArr = @[@"21",@"25",@"30",@"31",@"233"];
                    for (ADLDeviceModel *model in self.dataArr) {
                        if (![deleteDeviceTypeArr containsObject:model.deviceType]){
                            [modelArray addObject:model];
                        }
                    }
                    if (modelArray.count > 0) {
                        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:FAMILY_DEVICE]; //这里是把用户选中的设备进行了保存,现在取出
                        self.model = modelArray.firstObject;//获取到设备后,把第一个设备设置为当前的操作设备
                        for (ADLDeviceModel *model in modelArray) {
                            if ([model.deviceId isEqualToString:deviceId]) {
                                self.model = model;
                                break;
                            }
                        }
                        //如果之前没有已选择的设备,把第一个设置成默认选中的设备
                        if (![self.model.deviceId isEqualToString:deviceId]) {
                            [ADLUtils saveValue:self.model.deviceId forKey:FAMILY_DEVICE];
                        }
                        
                        //更新界面的设备信息,这里需要修改:更改界面的UI显示,和添加 设备列表的4个设备显示; TODO
                        [self updateDeviceData];
                        
                    }
                }
            }
        } failure:^(NSError *error) {
            [self.scrollView.mj_header endRefreshing];
        }];
    }else {
        //酒店
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.checkingInId forKey:@"checkingInId"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        __weak typeof(self) weakself = self;
        
        [ADLNetWorkManager postWithPath:ADEL_getDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
             [weakself.scrollView.mj_header endRefreshing];
            if ([responseDict[@"code"] integerValue] == 10000) {
                ADLLog(@" 用户的客房设备 ---------  /n %@",responseDict[@"data"]);
                NSString *str = responseDict[@"data"];
                if ([str isKindOfClass:[NSNull class]] || [str isEqual:[NSNull null]] || str == nil) {
                    //TODO  添加一个无设备View覆盖
                    
                    return ;
                }
                NSMutableArray *allDeviceArr = [NSMutableArray array];
                allDeviceArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
               NSMutableArray *modelArray = [NSMutableArray array];
                
                if (allDeviceArr.count>0) {
                    NSArray *deleteDeviceTypeArr = @[@"21",@"233",@"t20",@"t80"];
                    for (ADLDeviceModel *model in allDeviceArr) {
                        if (![deleteDeviceTypeArr containsObject:model.deviceType]) {
                            [modelArray addObject:model];
                        }
                    }
                    if (modelArray.count > 0) {
                        [self.dataArr removeAllObjects];
                        self.dataArr = [modelArray mutableCopy];
                        
                        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:HOTEL_DEVICE_SELECT];
                        self.model = modelArray.firstObject;
                        for (ADLDeviceModel *model in modelArray) {
                            if ([model.deviceId isEqualToString:deviceId]) {
                                self.model = model;
                                break;
                            }
                        }
                        //如果之前没有已选择的设备,把第一个设置成默认选中的设备
                        if (![self.model.deviceId isEqualToString:deviceId]) {
                            [ADLUtils saveValue:self.model.deviceId forKey:HOTEL_DEVICE_SELECT];
                        }
                        
                        //更新界面的设备信息,这里需要修改:更改界面的UI显示,和添加 设备列表的4个设备显示; TODO
                        [self updateDeviceData];
                        
                    } else {
//                        [self removeDeviceInfo];
                    }
                    
                }
                
            }
        } failure:^(NSError *error) {
            [self.scrollView.mj_header endRefreshing];
        }];
        
    }
}

#pragma  mark ---清除设备缓存
- (void)removeDeviceInfo {
    //获取到的设备列表为空时,清除缓存 TODO ,处理UI界面  TODO
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFamilyTitle:)]) {
        [self.delegate updateFamilyTitle:nil];
    }
    self.batteryBtn.hidden = YES;
    self.patternLab.hidden = YES;
    self.unlockView.userInteractionEnabled = NO;
    
}

#pragma mark ------ 更新当前设备信息 和 添加智能客房中的4个设备信息 ------
- (void)updateDeviceData {
    [self stopUnlockAnimation];
    [self setDevicePowerOnlineOpen];
    [self changeDeviceUIWithType:self.model.deviceType];
    //添加智能客房中的4个设备信息
    [self setfourDeviceMessage];
}
#pragma mark ------ 设备在线,离线,电量 ,任意开门,常开常闭的显示------
-(void)setDevicePowerOnlineOpen{
    
    if ([self.model.isFirstConnection isEqualToString:@"1"] || [self.model.deviceStatus isEqualToString:@"1"] ) {//1在线 0离线
        self.batteryBtn.hidden = NO;
        self.patternLab.hidden = NO;
        self.offlineLab.text = @"设备在线";//添加一个,测试  TODO
        self.offlineLab.hidden = YES;//暂时屏蔽,后面要打开  TODO
        self.unlockView.userInteractionEnabled = YES;
        
        self.onOffSegmentC.userInteractionEnabled = YES;
        
        NSString *str1 = @"";
        NSString *str2 = @"";
        if ([self.model.openGroup isEqualToString:@"1"]) {//1组合 0任意
            str1 = ADLString(@"multi_factor_unlock");
        } else {
            str1 = ADLString(@"custom_unlock");
        }
        if ([self.model.openStatus isEqualToString:@"1"]) {
            str2 = ADLString(@"passage");
        } else {
            str2 = ADLString(@"locked");
        }
        //这个是任意开门,常开常闭的显示
        self.patternLab.text = [NSString stringWithFormat:@"%@ / %@",str1,str2];
        
        NSInteger percent = (self.model.battery-4000)*100.0f/2400;
        if (percent < 0) percent = 0;
        if (percent > 100) percent = 100;
        [self.batteryBtn setTitle:[NSString stringWithFormat:@"%ld%%",percent] forState:UIControlStateNormal];
        if (percent < 20) {
            [self.batteryBtn setImage:[UIImage imageNamed:@"battery_20"] forState:UIControlStateNormal];
        } else if (percent < 40) {
            [self.batteryBtn setImage:[UIImage imageNamed:@"battery_40"] forState:UIControlStateNormal];
        } else if (percent < 60) {
            [self.batteryBtn setImage:[UIImage imageNamed:@"battery_60"] forState:UIControlStateNormal];
        } else if (percent < 80) {
            [self.batteryBtn setImage:[UIImage imageNamed:@"battery_80"] forState:UIControlStateNormal];
        } else {
            [self.batteryBtn setImage:[UIImage imageNamed:@"battery_100"] forState:UIControlStateNormal];
        }
    } else {
        self.offlineLab.hidden = NO;
        self.offlineLab.text = @"设备离线";
        self.batteryBtn.hidden = YES;
        self.patternLab.hidden = YES;
        self.unlockView.userInteractionEnabled = NO;
    }
    
}


#pragma mark ------ 设备显示控制UI的切换 ------
-(void)changeDeviceUIWithType:(NSString *)deviceType{
    //15 为储物箱; 燃气阀待定;其他为锁--- UI给定的
    //这里需要处理下UI的显示--->储物箱  显示图片,电量,已打开还是已关闭,OFF/NO 开关; 燃气阀  则相对于储物箱,没有电量的显示;  其他的显示锁的控制界面;
    
    self.deviceNameLab.text = self.model.deviceName;
    
  //TODO  测试
    if([deviceType isEqualToString:@"51"]){//储物箱
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
        self.deviceImgView.hidden = NO;
        self.onOffSegmentC.hidden = NO;
        self.batteryBtn.hidden = NO;
        self.isOpenOrCloseLab.hidden = NO;

        self.lockView.hidden = YES;
        self.promptLab.hidden = YES;
        self.unlockView.hidden = YES;
        self.patternLab.hidden = YES;
    }else if([deviceType isEqualToString:@"41"]){//
       //燃气阀
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_gason"];
        self.deviceImgView.hidden = NO;
        self.onOffSegmentC.hidden = NO;
        self.isOpenOrCloseLab.hidden = NO;

        self.lockView.hidden = YES;
        self.promptLab.hidden = YES;
        self.unlockView.hidden = YES;
        self.patternLab.hidden = YES;
        //屏蔽电量
        self.batteryBtn.hidden = YES;

    }else {
        //锁
        self.deviceImgView.hidden = YES;
        self.onOffSegmentC.hidden = YES;
        self.isOpenOrCloseLab.hidden = YES;
        self.lockView.hidden = NO;
        self.promptLab.hidden = NO;
        self.unlockView.hidden = NO;
    }
}

//添加智能客房中的4个设备信息,多的不显示;
-(void)setfourDeviceMessage{
    NSArray *bottom_deviceArr = [NSArray array];
    if (self.dataArr.count>4) {
        bottom_deviceArr = [self.dataArr subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        bottom_deviceArr = [self.dataArr copy];
    }
    for (int i = 0; i <4; i++) {
        UIView *payView = [self.bottomView viewWithTag:i+9999];
        UIImageView *imgView = [self.bottomView viewWithTag:i+1000];
        UILabel *titLab = [self.bottomView viewWithTag:100+i];
        if (i<bottom_deviceArr.count) {
            ADLDeviceModel *bottom_model = bottom_deviceArr[i];
            imgView.image = [ADLUtils lockImageWithType:bottom_model.deviceType];
            imgView.userInteractionEnabled = YES;
            if ([self.model.deviceId isEqualToString:bottom_model.deviceId]) {
                titLab.textColor = [UIColor colorWithRed:223/255.0 green:42/255.0 blue:45/255.0 alpha:1.0];
            }else {
                titLab.textColor = COLOR_333333;
            }
            titLab.text = bottom_model.deviceName;
            if ([bottom_model.deviceType isEqualToString:@"51"]) {
                payView.hidden = NO;
            }
        }else{
            imgView.userInteractionEnabled = NO;
            imgView.image = nil;
            titLab.text = @"";
        }
        
    }
    
}
#pragma mark ------ 点击Item ------
- (void)clickItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag-1000;
    self.model = self.dataArr[index];
    if (self.checkingInId == nil) {
        [ADLUtils saveValue:self.model.deviceId forKey:FAMILY_DEVICE];//更改了需要保存到NSUserDefaults
    }else {
         [ADLUtils saveValue:self.model.deviceId forKey:HOTEL_DEVICE_SELECT];//更改了需要保存到NSUserDefaults
    }
    
    
    //处理tit变红
    NSArray *bottom_deviceArr = [NSArray array];
    if (self.dataArr.count>4) {
        bottom_deviceArr = [self.dataArr subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        bottom_deviceArr = [self.dataArr copy];
    }
    for (int i = 0; i < bottom_deviceArr.count; i++) {
        UILabel *titLab = [self.bottomView viewWithTag:100+i];
        if (i == index) {
            titLab.textColor = [UIColor colorWithRed:223/255.0 green:42/255.0 blue:45/255.0 alpha:1.0];
        }else{
            titLab.textColor = COLOR_333333;
        }
    }
    [self setDevicePowerOnlineOpen];
    
    [self changeDeviceUIWithType:self.model.deviceType];
    
}


#pragma mark ------ 停止开锁动画 ------
- (void)stopUnlockAnimation {
    self.unlockView.userInteractionEnabled = YES;
    self.lockView.image = [UIImage imageNamed:@"lock_status"];
    self.promptLab.text = ADLString(@"tap_unlock");
    [self.unlockView.layer removeAllAnimations];
}

#pragma mark ------ Getter ------
- (CGFloat)offsetY {
    return self.scrollView.contentOffset.y;
}

#pragma mark ------ 433 设备的处理 ------

-(void)setUIForFTT{
    [self stopUnlockAnimation];
    [self setShowHiddenForFTT];
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [self.bottomView viewWithTag:i+1000];
        UILabel *titLab = [self.bottomView viewWithTag:100+i];
        if (i==0) {
            imgView.image = [UIImage imageNamed:@"lock_other"];
            imgView.userInteractionEnabled = YES;
            titLab.textColor = [UIColor colorWithRed:223/255.0 green:42/255.0 blue:45/255.0 alpha:1.0];
            titLab.text = self.roomMessageModel.bluetoothName.length> 0?self.roomMessageModel.bluetoothName:@"网络锁";
        }else {
            imgView.image = nil;
            imgView.userInteractionEnabled = NO;
            titLab.text = @"";
        }
    }
}
-(void)setShowHiddenForFTT{
    self.batteryBtn.hidden = YES;
    self.patternLab.hidden = YES;
    self.offlineLab.text = @"";
    self.offlineLab.hidden = YES;
    self.patternLab.text = @"";
    self.unlockView.userInteractionEnabled = YES;
    self.deviceImgView.hidden = YES;
    self.onOffSegmentC.hidden = YES;
    self.isOpenOrCloseLab.hidden = YES;
    self.lockView.hidden = NO;
    self.promptLab.hidden = NO;
    self.unlockView.hidden = NO;
    self.deviceNameLab.text =  self.roomMessageModel.bluetoothName.length> 0?self.roomMessageModel.bluetoothName:@"网络锁";
}

#pragma mark ------ 打开网络锁 ------
-(void)openlockFTTWifi {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"qrcode"] = [ADLFTTEncryption encryptAES:self.roomMessageModel.qrcode];
    params[@"roomId"] = [ADLFTTEncryption encryptAES:self.roomMessageModel.roomId];
    
    NSString *url;
    if ([self.roomMessageModel.version isEqualToString:@"former"]) {//啥意思这? TODO
        url = @"http://adelshop.com/adel-admin/app/member/openByQRCode.do";
    }else {
        url = @"http://adelcloud.com/adel-admin/app/member/openByQRCode.do";
    }
    
    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"433开锁返回=====\n%@\n",responseDict);

        if ([responseDict[@"status"] integerValue] == 10000) {
            self.promptLab.text = ADLString(@"unlock_success");
            self.lockView.image = [UIImage imageNamed:@"unlock_status"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopUnlockAnimation];
            });
        }else  if ([responseDict[@"status"] integerValue] == 100092){
            ADLLog(@"已退房");
            [ADLToast showMessage:@"已退房,操作失败!" duration:3];
            [self unlockFailed];
        }else {
            ADLLog(@"开锁失败");
            [ADLToast showMessage:@"开锁失败!" duration:3];
            [self unlockFailed];
        }
    } failure:^(NSError *error) {
        [self unlockFailed];
    }];    
}

#pragma mark ------ 打开蓝牙锁 ------

-(ADLBluetoothTool *)bluetoothTool {
    if (!_bluetoothTool) {
        _bluetoothTool = [[ADLBluetoothTool alloc] init];
    }
    return _bluetoothTool;
}

-(void)openLockFTTBluetooth {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"memberRoomId"] =[ADLFTTEncryption encryptAES:self.roomMessageModel.roomId];
    
    NSString *url;
    if ([self.roomMessageModel.version isEqualToString:@"former"]) {
        url = @"http://adelshop.com/adel-admin/app/member/bluetoothOpenDoor.do";
    }else {
        url = @"http://adelcloud.com/adel-admin/app/member/bluetoothOpenDoor.do";
    }

    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"status"] integerValue] == 10000) {
            self.bluetoothTool.BLEName = self.roomMessageModel.bluetoothName;//[ADLEFdaluts objectForKey:ADLUSER_bluetoothName];
            self.bluetoothTool.mBLEKey = self.roomMessageModel.bluetoothKey;//[ADLEFdaluts objectForKey:ADLUSER_bluetoothKey];
            [self.bluetoothTool BLEOpendoor];
        } else {
            [self unlockFailed];
        }
    } failure:^(NSError *error) {
        [self unlockFailed];
    }];
}
-(void)openLockSuccessful{
    self.promptLab.text = ADLString(@"unlock_success");
    self.lockView.image = [UIImage imageNamed:@"unlock_status"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopUnlockAnimation];
    });
}

@end
