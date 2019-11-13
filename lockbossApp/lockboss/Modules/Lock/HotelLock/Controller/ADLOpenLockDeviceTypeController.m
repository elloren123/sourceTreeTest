//
//  ADLOpenLockDeviceTypeController.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
/*
 
 酒店版中的设备的开门方式管理;
 
 */

#import "ADLOpenLockDeviceTypeController.h"

//#import "ADLAddDevicePasswordController.h"  //这个应该对接的是设置密码界面,x在我的--设置--修改密码中
#import "ADLLockMode.h"

//#import "ADLResurrectionCardController.h"

#import "ADLFTTEncryption.h"

#import "ADLForgetPwdController.h"

@interface ADLOpenLockDeviceTypeController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIButton *addbutton;
@property (nonatomic, strong) ADLLockMode *lockModel;
@property (nonatomic, strong) UISwitch *switchBtn;

@property (nonatomic, strong) UIButton *combinationBtn;
@property (nonatomic, strong) UIButton *basisBtn;
//@property (nonatomic, strong) UIButton *ministerBtn;
//@property (nonatomic, strong) UIButton *directorBtn;
//@property (nonatomic, strong) UIButton *governorBtn;

@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *passBtn;
@property (nonatomic, strong) UIButton *fingerprintBtn;
@property (nonatomic, strong) UIButton *CardBtn;

@property (nonatomic, copy) NSString * dateStr;


@property (nonatomic, strong) UIButton *dateBtn;

@property (nonatomic, copy) NSString * openFingerprint;//是否开启指纹
@property (nonatomic, copy) NSString * openApp;//是否开启app
@property (nonatomic, copy) NSString * openCard;//是否开启卡
@property (nonatomic, copy) NSString * openPassword;//是否开启密码
@property (nonatomic, copy) NSString * openGroup;// 是否开启组合

//@property (nonatomic, assign) NSInteger  number;//选中的开门的种类
@property (nonatomic, assign) NSInteger securityLevel;// 安全等级

@property (nonatomic, strong)UILabel *openType;
@property (nonatomic, strong)UILabel *addopenType;

@property (nonatomic, strong)    NSDictionary *dict;
@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, weak) UILabel *combinationtitle;
@property (nonatomic, weak) UILabel *priceNumber;
@property (nonatomic, weak) UILabel *freeLabel;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSArray *levelArray;

@property (nonatomic, strong) NSTimer *time;


@property (nonatomic ,strong)NSMutableArray *choiceOpenWayArr;//保存所有选中的开门的方式

@end

@implementation ADLOpenLockDeviceTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"unlock_method_setting")];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
   
    [self.view addSubview:self.scrollView];
    //TODO  --> 增加刷新
    
    
    [self.view addSubview:self.button];//警告:修改开门方式需要密码,此账号为验证码登录,请前去设置密码
    [self.view addSubview:self.dateBtn];//确定

    //查询开门方式
    [self getOpenType];
    //校验密码
    [self verifyIsPasswrod];

}
#pragma mark ------ 获取开门方式 ------
-(void)getOpenType{
    //---------给1800锁写死 2个 手机  和  RF卡------------
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceType"] =  self.model.deviceType;
    params[@"checkingInId"] = self.model.checkingInId;
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    //进行POST请求
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);

    [ADLNetWorkManager postWithPath:ADEL_getOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        [ADLToast hide];
        ADLLog(@"获取开门方式 == %@ ",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.lockModel = [ADLLockMode mj_objectWithKeyValues:responseDict[@"data"]];

//            if ([self.lockModel.openApp integerValue] >= 0) {
//                [self.array addObject:@"手机"];
//            }
//            if ([self.lockModel.openPassword integerValue] >= 0) {
//                [self.array addObject:@"密码"];
//            }
//            if ([self.lockModel.openFingerprint integerValue] >= 0) {
//                [self.array addObject:@"指纹"];
//            }
//            if ([self.lockModel.openCard integerValue] >= 0) {
//                [self.array addObject:@"RF卡"];
//            }
            
            [self.array addObjectsFromArray:@[@"手机",@"RF卡"]];
            
            [ws combinationView];
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

#pragma mark ------ 视图VIew ------
-(void)combinationView{
    UIView *subView= [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 360)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:subView];
    self.subView = subView;
    [subView addSubview:self.addbutton];
    UILabel *title = [self.view createLabelFrame:CGRectMake(11,  30, SCREEN_WIDTH, 17) font:16 text:@"选择开门方式" texeColor:UIColorFromRGB(0x222222)];
    [subView addSubview:title];
    
    CGFloat btnX = 32;
    CGFloat btnW = (SCREEN_WIDTH - btnX*3)/2;
    CGFloat btnH = 80/2;
    UIButton *combinationBtn = [self createButtonFrame:CGRectMake(btnX, CGRectGetMaxY(title.frame)+19,btnW, btnH) title:self.levelArray[0] target:self tag:4 action:@selector(adddate:)];
    self.combinationBtn = combinationBtn;
    [subView addSubview:self.combinationBtn];
    self.securityLevel = [self.lockModel.securityLevel integerValue];
    
    UIButton *basisBtn =  [self createButtonFrame:CGRectMake(btnX, CGRectGetMaxY(combinationBtn.frame)+19,btnW, btnH) title:self.levelArray[1] target:self tag:5 action:@selector(adddate:)];
    self.basisBtn = basisBtn;
    [subView addSubview:self.basisBtn];
   
    
    UILabel *combinationtitle = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(self.basisBtn.frame)+20, SCREEN_WIDTH-22, 17) font:14 text:@"选择组合" texeColor:UIColorFromRGB(0x222222)];
    [subView addSubview:combinationtitle];
    self.combinationtitle = combinationtitle;

    UILabel *freeLabel = [self.view createLabelFrame:CGRectMake(SCREEN_WIDTH - 80, CGRectGetMaxY(self.combinationtitle.frame)+5, 70, 17) font:14 text:@"免费体验" texeColor:UIColorFromRGB(0xad2f2d)];
    [freeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    freeLabel.textAlignment = NSTextAlignmentRight;
    [subView addSubview:freeLabel];
    self.freeLabel = freeLabel;

    UILabel *priceNumber = [self.view createLabelFrame:CGRectMake(SCREEN_WIDTH - 150, CGRectGetMaxY(self.combinationtitle.frame)+5, 70, 17) font:16 text:@"" texeColor:UIColorFromRGB(0xad2f2d)];
    [priceNumber setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [subView addSubview:priceNumber];
    self.priceNumber = priceNumber;


    NSMutableArray *addopenArray = [NSMutableArray array];
    NSInteger X = (SCREEN_WIDTH-4*60)/5;
    for (int i = 0 ; i < self.array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(isSecretCasedata:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [btn setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xad2f2d) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_press"] forState:UIControlStateSelected];
        btn.tag = i;
        // NSInteger btnX = 75*i+32;

        NSInteger btnX = ((60+X)*i)+X;

        btn.frame = CGRectMake(btnX, CGRectGetMaxY(combinationtitle.frame)+30, 70, 30);
        [subView addSubview:btn];

        [btn setTitle:self.array[i] forState:UIControlStateNormal];
        if ([self.array[i] isEqualToString: @"手机"]) {
            self.phoneBtn = btn;
            if ([self.lockModel.openApp isEqualToString:@"1"]) {
                [self.phoneBtn setSelected:YES];
//                self.number ++;
                [addopenArray addObject:self.array[i]];
            }
        }else if ([self.array[i] isEqualToString: @"RF卡"]) {
            self.CardBtn = btn;
            if ([self.lockModel.openCard isEqualToString:@"1"]) {
                [self.CardBtn setSelected:YES];
//                self.number ++;
                [addopenArray addObject:self.array[i]];
            }
        }
    }
    
    self.choiceOpenWayArr = [addopenArray mutableCopy];//保存服务器获取的开门方式; TODO
    
    UILabel *openType = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(priceNumber.frame)+90, SCREEN_WIDTH- 22, 17) font:12 text: @"当前开门方式:任意开门方式" texeColor: UIColorFromRGB(0x222222)];
    [self.subView addSubview:openType];
    self.openType = openType;
    
    UILabel *addopenType = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(openType.frame)+10, SCREEN_WIDTH- 22, 17) font:12 text: @"" texeColor: UIColorFromRGB(0xad2f2d)];
    [self.subView addSubview:addopenType];
    self.addopenType = addopenType;

    self.openGroup =self.lockModel.openGroup;
    if ([self.lockModel.openGroup  isEqualToString:@"0"]) {
        self.combinationtitle.text  =  @"选择任意几种单一开门方式";
        [self.combinationBtn setSelected:YES];
        self.priceNumber.hidden = YES;
        self.addopenType.text = [addopenArray componentsJoinedByString:@"   "];
        self.openType.text =[NSString stringWithFormat:@"%@:%@", @"当前开门方式",self.levelArray[0]];
        self.dateBtn.backgroundColor =  UIColorFromRGB(0xad2f2d);
        self.dateBtn.userInteractionEnabled = YES;
    }
    if ([self.lockModel.openGroup  isEqualToString:@"1"]) {
        self.combinationtitle.text  = @"选择任意几种为一组的组合开门方式";
        [self.basisBtn setSelected:YES];
        self.priceNumber.hidden = YES;
        self.addopenType.text = [addopenArray componentsJoinedByString:@"  "];
        self.openType.text =[NSString stringWithFormat:@"%@:%@", @"当前开门方式",self.levelArray[1]];
        self.dateBtn.backgroundColor =  UIColorFromRGB(0xad2f2d);
        self.dateBtn.userInteractionEnabled = YES;
    }
}

#pragma mark ------  校验是否存在密码 ------
-(void)verifyIsPasswrod{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    //进行POST请求
    [ADLNetWorkManager postWithPath:ADEL_verifyIsPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            if ([dict[@"isExist"] integerValue] == 1) {
                self.button.hidden = YES;
            }else {
                self.button.hidden = NO;
            }
           
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}
#pragma mark ------ 验证码登录用户-->设置密码 ------
-(void)goSetPassword{
    ADLForgetPwdController *forgetVC = [[ADLForgetPwdController alloc] init];
    forgetVC.titleName = @"设置密码";
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark ------ 确定后密码输入 ------
-(void)AlterPassword{
    __weak typeof(self)weakSelf = self;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"管理员认证" message:@"请输入登录密码" preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = YES;
        __strong typeof(self) strongSelf = weakSelf;
        [textField addTarget:strongSelf action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield1 = alerVC.textFields[0];
        __strong typeof(self) strongSelf = weakSelf;
        if (textfield1.text.length < 6 || textfield1.text.length > 18) {
            [ADLToast showMessage:@"密码长度6 - 18 位"];
        }else {
            [strongSelf verifyPasswrod:textfield1.text];
        }
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
}
-(void)textFieldChange:(UITextField*)textField{
    NSString *toBeString = textField.text;
    if (toBeString.length > 18)  {
        toBeString =[textField.text substringToIndex:18];
        textField.text =toBeString;
    }
}
#pragma mark ------ 校验密码是否正确 ------
-(void)verifyPasswrod:(NSString *)password{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"password"] = [ADLFTTEncryption MD5ForLower32Bate:password];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    __weak typeof(self)weakSelf = self;
    [ADLNetWorkManager postWithPath:ADEL_verifyPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            [strongSelf dataOpenType:dict[@"validateCode"]];
        }else{
             [ADLToast hide];
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}

#pragma mark ------ 确定后保存开门方式 ------
-(void)dataOpenType:(NSString *)validateCode{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gatewayCode"] =  self.model.gatewayCode;
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"deviceType"] =   self.model.deviceType;
    params[@"validateCode"] = validateCode;//校验码
    params[@"openFingerprint"] = @(0);//@(self.fingerprintBtn.selected);
    params[@"openPassword"] = @(0);//@(self.passBtn.selected);
    
    if ([self.phoneBtn.titleLabel.text isEqualToString:@"手机"]) {
        params[@"openApp"] = @(self.phoneBtn.selected);
        params[@"openCard"] = (@(self.CardBtn.selected));
    }else  if ([self.phoneBtn.titleLabel.text isEqualToString:@"RF卡"]){
        params[@"openCard"] = @(self.phoneBtn.selected);
        params[@"openApp"] = @(0);
    }
    
    params[@"openGroup"] = self.openGroup;
    params[@"securityLevel"] =  @(self.securityLevel);
    params[@"checkingInId"] =   self.model.checkingInId;
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    __weak typeof(self)weakSelf = self;
    [ADLNetWorkManager postWithPath:ADEL_setOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        __strong typeof(self) strongSelf = weakSelf;
        if ([responseDict[@"code"] integerValue] == 10000) {
            strongSelf.timer =  [NSTimer scheduledTimerWithTimeInterval:20.0 target:strongSelf selector:@selector(addtimer:) userInfo:nil repeats:NO];
            [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(MQNotiLockSecretManage:) name:@"ADELLoccombinationMQNotification" object:nil];
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}
#pragma mark ------ 修改成功的MQ消息 ------
-(void)MQNotiLockSecretManage:(NSNotification *)notification{
    WS(ws);
    NSDictionary *dict = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ws addtimer:nil];
        [ADLToast hide];
        if ([dict[@"resultCode"] integerValue] == 10000) {
            [ADLToast showMessage:@"设置成功"];
            //刷新客房设备接口
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELockrRefreshNotification" object:nil userInfo:nil];
            [ws.navigationController popViewControllerAnimated:YES];
        }
    });
}
#pragma mark ------ 保存开门方式失败 ------
-(void)addtimer:(NSTimer *)isTime {
    [ADLToast hide];
    if (isTime.valid == YES) {
        [ADLToast showMessage:@"获取秘钥超时"];
    }
    //取消定时器
    if(self.time){
        [self.time invalidate];
        self.time = nil;
    }
}

#pragma mark ------ *************选择开门方式************* ------
#pragma mark ------ 查询密钥情况 ------
-(void)adddate:(UIButton *)btn{
    [self selectSecretCase:btn];
}
#pragma mark ------ 方式 ------
-(void)selectSecretCase:(UIButton *)btn {
    //openGroup =1 组合 0代表任意  点击1组合开门方式要判断是否开启了密码,指纹,卡,没有开启要提示用户开启
//    self.number = 0;
    //选择开门方式
    if (btn.tag == 4) {
        
        self.securityLevel = 4;
        [self.combinationBtn setSelected:YES];
        [self.basisBtn setSelected:NO];
        self.combinationtitle.text =  @"选择任意几种单一开门方式";
        self.openType.text = @"当前开门方式:任意开门方式";
        self.priceNumber.attributedText = [self attribtDic: @""];
        self.priceNumber.hidden = NO;
        self.openGroup =@"0";
        return ;
    }else  if (btn.tag == 5) {
        
        self.securityLevel = 5;
        [self.basisBtn setSelected:YES];
        [self.combinationBtn setSelected:NO];
        self.combinationtitle.text=  @"选择任意几种为一组的组合开门方式";
        self.openType.text = @"当前开门方式:组合开门方式";
        self.priceNumber.attributedText = [self attribtDic: @""];
        self.priceNumber.hidden = NO;
        self.openGroup =@"1";
        return ;
    }
    
}
#pragma mark ------ 具体的开门组合选择 ------
-(void)isSecretCasedata:(UIButton *)btn{
    //1.----取消选中----
    if (btn.selected == YES) {
        [btn setSelected:NO];
//        self.number--;
       
        for (int i=0;i<self.choiceOpenWayArr.count; i++) {
            NSString *name = self.choiceOpenWayArr[i];
            if ([name isEqualToString:btn.titleLabel.text]) {
                [self.choiceOpenWayArr removeObjectAtIndex:i];
                break;
            }
        }
        self.addopenType.text = [self.choiceOpenWayArr componentsJoinedByString:@"   "];
        if (self.choiceOpenWayArr.count >0 ) {
            self.dateBtn.backgroundColor = UIColorFromRGB(0xad2f2d);
            self.dateBtn.userInteractionEnabled = YES;
        }else {
            self.dateBtn.backgroundColor = UIColorFromRGB(0xe5e5e5);
            self.dateBtn.userInteractionEnabled = NO;
        }
        return;
    }
    
    //2.----选中----
    //需要请求后台判断是否已经开卡
    self.addbutton.hidden = YES;
    //就两个按钮,只有RF卡需要验证 TODO
    BOOL isAddPhone = NO;
    
    if ([btn.titleLabel.text isEqualToString:@"手机"]) {
        for (NSString *name in self.choiceOpenWayArr) {
            if ([name isEqualToString:@"手机"]) {
                isAddPhone = YES;
                break;
            }
        }
        if (!isAddPhone) {
            [self.choiceOpenWayArr addObject:@"手机"];
        }
        [btn setSelected:YES];
        self.dateBtn.backgroundColor = UIColorFromRGB(0xad2f2d);
        self.dateBtn.userInteractionEnabled = YES;
         self.addopenType.text = [self.choiceOpenWayArr componentsJoinedByString:@"   "];
        return;
    }
    
    
    //type: null 全部，1密码，2卡，3指纹
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"checkingInId"] =  self.model.checkingInId;
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceCode"] = self.model.deviceCode;
    params[@"deviceType"] = self.model.deviceType;
    if ([btn.titleLabel.text isEqualToString:@"密码"]) {
        params[@"type"] = @"1";
        self.addbutton.tag = 1;
    }else if ([btn.titleLabel.text isEqualToString:@"RF卡"]) {
        params[@"type"] = @"2";
        self.addbutton.tag = 2;
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_selectSecretCase parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict =responseDict[@"data"];
            if ([btn.titleLabel.text  isEqualToString:@"RF卡"]) {
                if ([dict[@"isCard"] integerValue] == 1) {
                    [ws.CardBtn setSelected:YES];
                    ws.addbutton.hidden = YES;
//                    ws.number++;
                    
                    [self.choiceOpenWayArr addObject:@"RF卡"];
                    self.addopenType.text = [self.choiceOpenWayArr componentsJoinedByString:@"   "];
                   
                    self.dateBtn.backgroundColor = UIColorFromRGB(0xad2f2d);
                    self.dateBtn.userInteractionEnabled = YES;
                   
                }else {
                    ws.addbutton.hidden = NO;
                    [ws.addbutton setAttributedTitle:[self string:@"对不起,当前门锁未添加RF卡,前去添加RF卡"] forState:UIControlStateNormal];
                }
            }
            
        }
    } failure:^(NSError *error) {
       [ADLToast hide];
    }];
}

#pragma mark ------ 给btn副文本添加下划线 ------
-(NSMutableAttributedString *)string:(NSString *)attributedString {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange strRange = {str.length - 4,4};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    return str;
}


//-(void)viewOpenType{
//    if ([self.lockModel.openApp isEqualToString:@"1"]) {
//        [self.phoneBtn setSelected:YES];
//        self.number ++;
//    }else {
//        [self.phoneBtn setSelected:NO];
//    }
//
//    if ([self.lockModel.openPassword isEqualToString:@"1"]) {
//        [self.passBtn setSelected:YES];
//        self.number ++;
//    }else {
//        [self.passBtn setSelected:NO];
//    }
//
//    if ([self.lockModel.openFingerprint isEqualToString:@"1"]) {
//        [self.fingerprintBtn setSelected:YES];
//        self.number ++;
//    }else {
//        [self.fingerprintBtn setSelected:NO];
//    }
//
//    if ([self.lockModel.openCard isEqualToString:@"1"]) {
//        [self.CardBtn setSelected:YES];
//        self.number ++;
//
//    }else {
//        [self.CardBtn setSelected:NO];
//    }
//
//}

//-(void)isOpenLock{
//    self.passBtn.hidden = NO;
//    self.CardBtn.hidden = NO;
//    self.fingerprintBtn.hidden = NO;
//    [self.phoneBtn setTitle: @"手机" forState:UIControlStateNormal];
//
//
//    [self.CardBtn setSelected:NO];
//    [self.passBtn setSelected:NO];
//    [self.fingerprintBtn setSelected:NO];
//    [self.phoneBtn setSelected:NO];
//
//    self.addbutton.hidden = YES;
//}

#pragma mark ------ 添加RF卡操作 ------
-(void)addOpenTypbutton:(UIButton*)btn{
    
    //    if (btn.tag == 1) {
    //        //密码
    //        [self changePassword];
    //    }else   if (btn.tag == 2) {
    //
    //        //RF卡  TODO
    //        ADLResurrectionCardController *vc = [[ADLResurrectionCardController alloc]init];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }else   if (btn.tag == 3) {
    //        //指纹
    //    }
    
    
    //*********当没有RF卡时,点击添加RF卡********
    
    //    RF卡  TODO
//    ADLResurrectionCardController *vc = [[ADLResurrectionCardController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

//判断是否超出入住时间/判断设备是否在线
//-(BOOL)isdeviceLock {
//    //判断是否超出入住时间  TODO,前端这个判断不合理,没有意义
////    if ([ADLTimeOrStamp compareDateseconds:self.roomMessageModel.endDatetime] == 1) {
////        return NO;
////    }
//    //判断设备是否在线
//    if (![self.model.deviceStatus isEqualToString:@"1"]) {
//        [ADLToast showMessage:@"设备未上线"];
//        return NO;
//    }
//    return YES;
//}

//
//
//-(void)MQNotiLockPassword:(NSNotification *)noit{
//    WS(ws);
//    NSDictionary *dict = noit.userInfo;
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [ws addtimer:nil];
//        [ADLToast showMessage:dict[@"msg"]];
//        if ([dict[@"resultCode"] integerValue] == 10000) {
//            //刷新客房设备接口
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELockrRefreshNotification" object:nil userInfo:nil];
//
//        }
//    });
//}



-(UIButton *)createButtonFrame:(CGRect)frame  title:(NSString *)title  target:(id)target tag:(NSInteger)tag action:(SEL)action{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (title){
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (tag) {
        btn.tag = tag;
    }
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitleColor: UIColorFromRGB(0xad2f2d) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_unlock_alone"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_unlock_more"] forState:UIControlStateSelected];
    
//    if (self.array.count  == 3) {
//        if (tag == 4) {
//            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateSelected];
//            [btn setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
//            btn.userInteractionEnabled = NO;
//
//        }
//    }
//    if (self.array.count  == 2) {
//        if (tag == 5) {
//            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateNormal];
//            btn.userInteractionEnabled = NO;
//            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateSelected];
//            [btn setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
//        }
//
//    }
    return btn;
    
}
-(NSMutableAttributedString *)attribtDic:(NSString *)str{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    return attribtStr;
}

#pragma mark ------ 懒加载 ------
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
        _scrollView.backgroundColor = UIColorFromRGB(0xeeeeee);
//        _scrollView.frame = ;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _scrollView;
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, 30);
        //  [_button setTitle: @"警告:修改开门方式需要验证管理员密码,此账号为验证码登录,请前去设置密码") forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorWithRed:255/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_button setAttributedTitle:[self string: @"警告:修改开门方式需要密码,此账号为验证码登录,请前去设置密码"] forState:UIControlStateNormal];//这个状态要加上
        _button.titleLabel.font = [UIFont systemFontOfSize:10];
        _button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        _button.hidden = YES;
        [_button addTarget:self action:@selector(goSetPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _button;
}
-(UIButton *)addbutton {
    if (!_addbutton) {
        _addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addbutton.frame = CGRectMake(50,self.subView.height - 25, SCREEN_WIDTH - 60, 20);
        [_addbutton addTarget:self action:@selector(addOpenTypbutton:) forControlEvents:UIControlEventTouchUpInside];
        [_addbutton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
        _addbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        // [_addbutton setAttributedTitle:[self string: @"对不起,当前门锁没有密码,点击获取密码")] forState:UIControlStateNormal];//这个状态要加上
        _addbutton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        _addbutton.hidden = YES;
    }
    return  _addbutton;
}
-(UIButton *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setTitle: @"确定" forState:UIControlStateNormal];
        _dateBtn.frame = CGRectMake(20, SCREEN_HEIGHT-NAVIGATION_H -BOTTOM_H-20, SCREEN_WIDTH - 40, 45);
        [_dateBtn addTarget:self action:@selector(AlterPassword) forControlEvents:UIControlEventTouchUpInside];
        _dateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _dateBtn.layer.masksToBounds = YES;
        _dateBtn.layer.cornerRadius = 5;
        _dateBtn.backgroundColor =  UIColorFromRGB(0x5e5e5);
        _dateBtn.userInteractionEnabled = NO;
    }
    return _dateBtn;
}
-(NSArray *)levelArray {
    if (!_levelArray) {
        _levelArray = @[@"任意开门方式",@"组合开门方式"];//@[@"总统级安全",@"总理级安全",@"部长级安全",@"局长级安全",@"州长级安全"];
    }
    return _levelArray;
}
-(NSMutableArray *)choiceOpenWayArr{
    if (!_choiceOpenWayArr) {
        _choiceOpenWayArr = [NSMutableArray array];
    }
    return _choiceOpenWayArr;
}

#pragma mark ------ END ------

@end
