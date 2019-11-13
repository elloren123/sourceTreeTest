//
//  ADLLockModeController.m
//  lockboss
//
//  Created by adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLockModeController.h"
#import "ADLLockMode.h"
#import "ADLFTTEncryption.h"
#import "ADLResurrectionCardController.h"

@interface ADLLockModeController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIButton *addbutton;
@property (nonatomic, strong) ADLLockMode *lockModel;
@property (nonatomic, strong) UISwitch *switchBtn;

@property (nonatomic, strong) UIButton *combinationBtn;
@property (nonatomic, strong) UIButton *basisBtn;
@property (nonatomic, strong) UIButton *ministerBtn;
@property (nonatomic, strong) UIButton *directorBtn;
@property (nonatomic, strong) UIButton *governorBtn;

@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *passBtn;
@property (nonatomic, strong) UIButton *fingerprintBtn;
@property (nonatomic, strong) UIButton *CardBtn;
@property (nonatomic, strong) UIButton *faceBtn;

@property (nonatomic, copy) NSString * dateStr;


@property (nonatomic, strong) UIButton *dateBtn;

@property (nonatomic, copy) NSString * openFingerprint;//是否开启指纹
@property (nonatomic, copy) NSString * openApp;//是否开启app
@property (nonatomic, copy) NSString * openCard;//是否开启卡
@property (nonatomic, copy) NSString * openPassword;//是否开启密码
@property (nonatomic, copy) NSString * openGroup;// 是否开启组合

@property (nonatomic, assign) NSInteger  number;
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
@end

@implementation ADLLockModeController


#pragma mark ~~~~~~~~~~ 页面加载 ~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.translucent = NO;
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //        self.extendedLayoutIncludesOpaqueBars = NO;
    //        self.modalPresentationCapturesStatusBarAppearance = NO;
    //    }
 
    self.view.backgroundColor = COLOR_F7F7F7;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.button];
    [self.scrollView addSubview:self.dateBtn];
   [self addRedNavigationView:ADLString(@"开门方式管理")];
    
    if ([self.model.jurisdiction isEqualToString:@"2"]) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H)];
        [self.view addSubview:backView];
        self.dateBtn.hidden = YES;
    }
    //查询开门方式
    [self getOpenType];
    //校验密码
    [self verifyIsPasswrod];
    //开门方式查询
    // [self getGroupOpenType];
    
    
}

-(void)AlterPassword{
    
    //    if ([self.openGroup isEqualToString:@"1"]) {
    //        NSInteger number = [self.openFingerprint integerValue] + [self.openPassword integerValue]+[self.openCard integerValue]+[self.openApp integerValue];
    //        if (number < 2) {
    //            [ADLPromptMwssage showErrorMessage:ADLString(@"当前选中的是组合开门方式,最少要选两项以上") inView:self.view time:3];
    //            return ;
    //        }
    //    }
    WS(ws);
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ADLString(@"管理员认证") message:ADLString(@"请输入登录密码") preferredStyle:UIAlertControllerStyleAlert];
    
    [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = ADLString(@"请输入密码");
        textField.secureTextEntry = YES;
        [textField addTarget:ws action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    
    [alerVC addAction:[UIAlertAction actionWithTitle:ADLString(@"取消") style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    
    [alerVC addAction:[UIAlertAction actionWithTitle:ADLString(@"确定") style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield1 = alerVC.textFields[0];
        if (textfield1.text.length < 6 || textfield1.text.length > 18) {
            [ADLToast showMessage:ADLString(@"密码长度6 - 18 位")];
        }else {
            [ws verifyPasswrod:textfield1.text];
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
    return;
    
}

// 获取开门方式
-(void)getOpenType{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceType"] =  self.model.deviceType;
    params[@"checkingInId"] = self.model.checkingInId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    //进行POST请求
  [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
 [ADLNetWorkManager postWithPath:ADEL_getOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
     
       [ADLToast hide];
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
     
     if ([responseDict[@"code"] integerValue] == 10000) {
         self.lockModel=[ADLLockMode mj_objectWithKeyValues:responseDict[@"data"]];
         
         if ([self.lockModel.openApp integerValue] >= 0) {
             [self.array addObject:ADLString(@"手机")];
         }
         if ([self.lockModel.openPassword integerValue] >= 0) {
             [self.array addObject:ADLString(@"密码")];
         }
         if ([self.lockModel.openFingerprint integerValue] >= 0) {
             [self.array addObject:ADLString(@"指纹")];
         }
         if ([self.lockModel.openCard integerValue] >= 0) {
             [self.array addObject:ADLString(@"房卡")];
         }
         if ([self.lockModel.openCard integerValue] >= 0) {
             [self.array addObject:ADLString(@"人脸")];
         }
         
         [ws combinationView];
     }else {
         [ADLToast showMessage:responseDict[@"msg"]];
     }
     
    } failure:^(NSError *error) {
        [ADLToast hide];
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

// 校验是否存在密码
-(void)verifyIsPasswrod{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    //进行POST请求
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_verifyIsPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            NSDictionary *dict = responseDict[@"data"];
            if ([dict[@"isExist"] integerValue] == 1) {
                
                ws.button.hidden = YES;
                
            }else {
                
                ws.button.hidden = NO;
                
            }
        }
    } failure:^(NSError *error) {
       [ADLToast hide];
    }];
}

//校验密码
-(void)verifyPasswrod:(NSString *)password{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"password"] = [ADLFTTEncryption MD5ForLower32Bate:password];
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    //进行POST请求
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_verifyPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            [ws dataOpenType:dict[@"validateCode"]];
        }else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
        
    } failure:^(NSError *error) {
       [ADLToast hide];
    }];
}

//查询密钥情况
-(void)adddate:(UIButton *)btn{
    //dict[@"F0FE6BF23EBA"];
    [self selectSecretCase:btn];
    
}

-(void)isSecretCasedata:(UIButton *)btn{
    
    if (self.securityLevel == 4 || self.securityLevel == 5) {
        
        btn.selected = !btn.selected;
        return;
    }
    if (btn.selected == YES) {
        [btn setSelected:NO];
        self.number--;
        
        if (self.securityLevel == 1) {
            [self numberstr:4];
        }
        if (self.securityLevel == 2) {
            [self numberstr:3];
        }
        if (self.securityLevel == 3) {
            [self numberstr:2];
        }
        
        return;
    }
    self.addbutton.hidden = YES;
    
    if (self.securityLevel == 2) {
        
        if (self.number >= 3) {
        
               [ADLToast showMessage:ADLString(@"最多三种开门方式")];
            return;
        }
        
        
    }
    
    if (self.securityLevel == 3) {
        
        if (self.number >= 2) {
         [ADLToast showMessage:ADLString(@"最多两种开门方式")];
           
            return;
        }
        
    }
    //type: null 全部，1密码，2卡，3指纹
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"checkingInId"] =  self.model.checkingInId;
    params[@"deviceId"] =  self.model.deviceId;
    params[@"deviceCode"] = self.model.deviceCode;
    params[@"deviceType"] = self.model.deviceType;
    if ([btn.titleLabel.text isEqualToString:ADLString(@"密码")]) {
        params[@"type"] = @"1";
        self.addbutton.tag = 1;
    }else     if ([btn.titleLabel.text isEqualToString:ADLString(@"房卡")]) {
        params[@"type"] = @"2";
        self.addbutton.tag = 2;
    }else     if ([btn.titleLabel.text isEqualToString:ADLString(@"指纹")]) {
        params[@"type"] = @"3";
        self.addbutton.tag = 3;
    }else if ([btn.titleLabel.text isEqualToString:ADLString(@"人脸")]) {
        params[@"type"] = @"4";
        self.addbutton.tag = 4;
    }else{
        self.number++;
        [btn setSelected:YES];
        
        if (self.securityLevel == 1) {
            [self numberstr:4];
        }else   if (self.securityLevel == 2) {
            [self numberstr:3];
        }else  if (self.securityLevel == 3) {
            [self numberstr:2];
        }
        
        return;
    }
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    
    [ADLNetWorkManager postWithPath:ADEL_selectSecretCase parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            NSDictionary *dict =responseDict[@"data"];
            
            if ([btn.titleLabel.text  isEqualToString:ADLString(@"密码")]) {
                if ([dict[@"isPassword"] integerValue] == 1) {
                    [ws.passBtn setSelected:YES];
                    ws.addbutton.hidden = YES;
                    ws.number++;
                    
                }else {
                    ws.addbutton.hidden = NO;
                    [ws.addbutton setAttributedTitle:[self string:ADLString(@"对不起,当前门锁未获取密码,点击获取密码")] forState:UIControlStateNormal];
                }
            }else     if ([btn.titleLabel.text  isEqualToString:ADLString(@"房卡")]) {
                if ([dict[@"isCard"] integerValue] == 1) {
                    [ws.CardBtn setSelected:YES];
                    ws.addbutton.hidden = YES;
                    ws.number++;
                }else {
                    ws.addbutton.hidden = NO;
                    [ws.addbutton setAttributedTitle:[self string:ADLString(@"对不起,当前门锁未添加房卡,前去添加房卡")] forState:UIControlStateNormal];
                }
            }else     if ([btn.titleLabel.text  isEqualToString:ADLString(@"指纹")]) {
                if ([dict[@"isFingerprint"] integerValue] == 1) {
                    [ws.fingerprintBtn setSelected:YES];
                    ws.addbutton.hidden = YES;
                    ws.number++;
                }else {
                    ws.addbutton.hidden = NO;
                    [ws.addbutton setAttributedTitle:nil forState:UIControlStateNormal];
                    [ws.addbutton setTitle:ADLString(@"对不起,当前门锁没有你的指纹,请找酒店人员添加指纹") forState:UIControlStateNormal];
                }
            }else     if ([btn.titleLabel.text  isEqualToString:ADLString(@"人脸")]) {
                if ([dict[@"isFace"] integerValue] == 1) {
                    [ws.faceBtn setSelected:YES];
                    ws.addbutton.hidden = YES;
                    ws.number++;
                }else {
                    ws.addbutton.hidden = NO;
                    [ws.addbutton setAttributedTitle:nil forState:UIControlStateNormal];
                    [ws.addbutton setAttributedTitle:[self string:ADLString(@"对不起,当前门锁未添加人脸,前去添加人脸")] forState:UIControlStateNormal];
                }
            }
            
            if (ws.securityLevel == 1) {
                [ws numberstr:4];
            }else   if (ws.securityLevel == 2) {
                [ws numberstr:3];
            }else  if (ws.securityLevel == 3) {
                [ws numberstr:2];
            }
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}
//开门方式管理
-(void)dataOpenType:(NSString *)validateCode{
    
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gatewayCode"] =  self.model.gatewayCode;
    params[@"deviceCode"] =  self.model.deviceCode;
    params[@"deviceType"] =   self.model.deviceType;
    params[@"validateCode"] = validateCode;
    params[@"openFingerprint"] = @(self.fingerprintBtn.selected);
    params[@"openPassword"] = @(self.passBtn.selected);
    params[@"openFace"] = @(self.faceBtn.selected);
    
    if ([self.phoneBtn.titleLabel.text isEqualToString:ADLString(@"手机")]) {
        params[@"openApp"] = @(self.phoneBtn.selected);
        params[@"openCard"] = (@(self.CardBtn.selected));
    }else  if ([self.phoneBtn.titleLabel.text isEqualToString:ADLString(@"房卡")]){
        params[@"openCard"] = @(self.phoneBtn.selected);
        params[@"openApp"] = @(0);
    }
    
    params[@"openGroup"] = self.openGroup;
    params[@"securityLevel"] =  @(self.securityLevel);
    params[@"checkingInId"] =   self.model.checkingInId;
    params[@"sign"] =  [ADLUtils handleParamsSign:params] ;
    //进行POST请求
  
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_setOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
     
        if ([responseDict[@"code"] integerValue] == 10000) {
            ws.timer =  [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(addtimer:) userInfo:nil repeats:NO];
      [[NSNotificationCenter defaultCenter] addObserver:ws selector:@selector(MQNotiLockSecretManage:) name:@"ADELLoccombinationMQNotification" object:nil];
            
        }else {
            [ADLToast hide];
            [ADLToast showMessage:responseDict[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}
-(void)MQNotiLockSecretManage:(NSNotification *)notification{
    WS(ws);
    
    NSDictionary *dict = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ws addtimer:nil];
       [ADLToast hide];
        if ([dict[@"resultCode"] integerValue] == 10000) {
            
            [ADLToast showMessage:ADLString(@"设置成功") duration:2];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:ADELfamillockUpdateDeviceNotification object:nil userInfo:nil];
            //刷新客房设备接口
         //   [[NSNotificationCenter defaultCenter] postNotificationName:ADELockrRefreshNotification object:nil userInfo:nil];
            [ws.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            [ADLToast showMessage:dict[@"msg"]];
        }
        
    });
    
}

-(NSArray *)levelArray {
    if (!_levelArray) {
        _levelArray = @[ADLString(@"总统级安全"),ADLString(@"总理级安全"),ADLString(@"部长级安全"),ADLString(@"局长级安全"),ADLString(@"州长级安全")];
    }
    return _levelArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        // 2.初始化、配置scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = COLOR_F7F7F7;
        _scrollView.frame = CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H);
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+NAVIGATION_H);
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _scrollView;
}
-(void)combinationView{
    UIView *subView= [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 360)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:subView];
    self.subView = subView;
    [subView addSubview:self.addbutton];
    UILabel *title = [self.view createLabelFrame:CGRectMake(11,  30, SCREEN_WIDTH, 17) font:16 text:ADLString(@"选择开门方式") texeColor:COLOR_333333];
    [subView addSubview:title];
    
    CGFloat btnX = 32;
    CGFloat btnW = (SCREEN_WIDTH - btnX*3)/2;
    CGFloat btnH = 80/2;
    
    
    UIButton *combinationBtn = [self createButtonFrame:CGRectMake(btnX, CGRectGetMaxY(title.frame)+19,btnW, btnH) title:self.levelArray[0] target:self tag:4 action:@selector(adddate:)];
    //  combinationBtn.backgroundColor = [UIColor yellowColor];
    self.combinationBtn = combinationBtn;
    [subView addSubview:self.combinationBtn];
    self.securityLevel = [self.lockModel.securityLevel integerValue];
    UIButton *basisBtn =  [self createButtonFrame:CGRectMake(CGRectGetMaxX(self.combinationBtn.frame)+btnX, CGRectGetMaxY(title.frame)+19,btnW, btnH) title:self.levelArray[1] target:self tag:5 action:@selector(adddate:)];
    self.basisBtn = basisBtn;
    [subView addSubview:self.basisBtn];
    
    
    UIButton *ministerBtn =  [self createButtonFrame:CGRectMake(btnX, CGRectGetMaxY(basisBtn.frame)+19,btnW, btnH) title:self.levelArray[2] target:self tag:6 action:@selector(adddate:)];
    self.ministerBtn = ministerBtn;
    [subView addSubview:self.ministerBtn];
    
    
    
    UIButton *directorBtn =  [self createButtonFrame:CGRectMake(CGRectGetMaxX(self.ministerBtn.frame)+btnX, CGRectGetMaxY(basisBtn.frame)+19,btnW, btnH) title:self.levelArray[3] target:self tag:7 action:@selector(adddate:)];
    self.directorBtn = directorBtn;
    [subView addSubview:self.directorBtn];
    
    
    
    UIButton *governorBtn =  [self createButtonFrame:CGRectMake(btnX, CGRectGetMaxY(directorBtn.frame)+19,btnW, btnH) title:self.levelArray[4] target:self tag:8 action:@selector(adddate:)];
    self.governorBtn = governorBtn;
    [subView addSubview:self.governorBtn];
    
    
    
    UILabel *combinationtitle = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(self.governorBtn.frame)+20, 200, 17) font:14 text:ADLString(@"选择组合") texeColor:COLOR_333333];
    [subView addSubview:combinationtitle];
    self.combinationtitle = combinationtitle;
    
    
    
    
    UILabel *freeLabel = [self.view createLabelFrame:CGRectMake(SCREEN_WIDTH - 80, CGRectGetMaxY(self.combinationtitle.frame)+5, 70, 17) font:14 text:ADLString(@"免费体验") texeColor:COLOR_E0212A];
    //freeLabel.backgroundColor = COLOR_E0212A;
    [freeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    freeLabel.textAlignment = NSTextAlignmentRight;
    [subView addSubview:freeLabel];
    self.freeLabel = freeLabel;
    
    UILabel *priceNumber = [self.view createLabelFrame:CGRectMake(SCREEN_WIDTH - 150, CGRectGetMaxY(self.combinationtitle.frame)+5, 70, 17) font:16 text:ADLString(@"原价:") texeColor:COLOR_E0212A];
    [priceNumber setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [subView addSubview:priceNumber];
    self.priceNumber = priceNumber;
    NSMutableArray *addopenArray = [NSMutableArray array];
    NSInteger X = (SCREEN_WIDTH-self.array.count*60)/(self.array.count+1);
    for (int i = 0 ; i < self.array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(isSecretCasedata:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        // btn.backgroundColor = COLOR_E0212A;
        [btn setTitleColor:COLOR_CCCCCC forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_press"] forState:UIControlStateSelected];
        btn.tag = i;
        // NSInteger btnX = 75*i+32;
        
        NSInteger btnX = ((60+X)*i)+X;
        
        btn.frame = CGRectMake(btnX, CGRectGetMaxY(combinationtitle.frame)+30, 60, 30);
        [subView addSubview:btn];
        
        [btn setTitle:self.array[i] forState:UIControlStateNormal];
        if ([self.array[i] isEqualToString:ADLString(@"手机")]) {
            self.phoneBtn = btn;
            if ([self.lockModel.openApp isEqualToString:@"1"]) {
                [self.phoneBtn setSelected:YES];
                self.number ++;
                [addopenArray addObject:self.array[i]];
            }
        }else     if ([self.array[i] isEqualToString:ADLString(@"密码")]) {
            
            self.passBtn = btn;
            
            if ([self.lockModel.openPassword isEqualToString:@"1"]) {
                [self.passBtn setSelected:YES];
                self.number ++;
                [addopenArray addObject:self.array[i]];
            }
        }else       if ([self.array[i] isEqualToString:ADLString(@"指纹")]) {
            
            self.fingerprintBtn = btn;
            
            if ([self.lockModel.openFingerprint isEqualToString:@"1"]) {
                [self.fingerprintBtn setSelected:YES];
                self.number ++;
                [addopenArray addObject:self.array[i]];
            }
        }else     if ([self.array[i] isEqualToString:ADLString(@"房卡")]) {
            
            self.CardBtn = btn;
            
            if ([self.lockModel.openCard isEqualToString:@"1"]) {
                [self.CardBtn setSelected:YES];
                self.number ++;
                [addopenArray addObject:self.array[i]];
                
            }
            
        }else     if ([self.array[i] isEqualToString:ADLString(@"人脸")]) {
            
            self.faceBtn = btn;
            
            if ([self.lockModel.openFace isEqualToString:@"1"]) {
                [self.faceBtn setSelected:YES];
                self.number ++;
                [addopenArray addObject:self.array[i]];
                
            }
            
        }
        
    }
    
    UILabel *openType = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(priceNumber.frame)+90, SCREEN_WIDTH- 22, 17) font:12 text:ADLString(@"当前开门方式:任意开门方式") texeColor:COLOR_333333];
    [self.subView addSubview:openType];
    self.openType = openType;
    
    UILabel *addopenType = [self.view createLabelFrame:CGRectMake(11, CGRectGetMaxY(openType.frame)+10, SCREEN_WIDTH- 22, 17) font:12 text:ADLString(@"") texeColor:COLOR_E0212A];
    [self.subView addSubview:addopenType];
    self.addopenType = addopenType;
    
    
    self.openGroup =self.lockModel.openGroup;
    if ([self.lockModel.securityLevel  isEqualToString:@"1"]) {
        self.combinationBtn.selected = YES;
        
        NSArray *array  =@[@"22",@"24"];
        if ([array containsObject:self.model.deviceType]) {
            self.combinationtitle.text  = ADLString(@"选择五种为一组的组合开门方式");
        }else {
           self.combinationtitle.text  = ADLString(@"选择四种为一组的组合开门方式");
        }
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:3¥")];
        self.addopenType.text = [addopenArray componentsJoinedByString:@"+"];
        self.openType.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"当前开门方式"),self.levelArray[0]];
        [self numberstr:4];
    }
    if ([self.lockModel.securityLevel  isEqualToString:@"2"]) {
        self.basisBtn.selected = YES;
        self.combinationtitle.text   = ADLString(@"选择三种为一组的组合开门方式");
        
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:2¥")];
        self.addopenType.text = [addopenArray componentsJoinedByString:@"+"];
        self.openType.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"当前开门方式"),self.levelArray[1]];
        self.openGroup =self.lockModel.openGroup;
        [self numberstr:3];
    }
    if ([self.lockModel.securityLevel  isEqualToString:@"3"]) {
        self.ministerBtn.selected = YES;
        self.combinationtitle.text   =ADLString(@"选择两种为一组的组合开门方式");
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:1¥")];
        self.addopenType.text = [addopenArray componentsJoinedByString:@"+"];
        self.openType.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"当前开门方式"),self.levelArray[2]];
        [self numberstr:2];
    }
    if ([self.lockModel.securityLevel  isEqualToString:@"4"]) {
        [self.directorBtn setSelected:YES];
        self.combinationtitle.text  = ADLString(@"选择任意几种开门方式");
        self.priceNumber.hidden = YES;
        self.addopenType.text = [addopenArray componentsJoinedByString:@"   "];
        self.openType.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"当前开门方式"),self.levelArray[3]];
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
    }
    if ([self.lockModel.securityLevel  isEqualToString:@"5"]) {
        self.governorBtn.selected = YES;
        self.combinationtitle.text  = @"选择开门方式";
        self.priceNumber.hidden = YES;
        self.addopenType.text = [addopenArray componentsJoinedByString:@"   "];
        self.openType.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"当前开门方式"),self.levelArray[4]];
        if ([self.lockModel.openCard isEqualToString:@"1"]) {
            [self.phoneBtn setSelected:YES];
            
        }
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
        self.CardBtn.hidden = YES;
        self.passBtn.hidden = YES;
         self.faceBtn.hidden = YES;
        self.fingerprintBtn.hidden = YES;
        [self.phoneBtn setTitle:ADLString(@"房卡") forState:UIControlStateNormal];
        
    }
}

-(void)selectSecretCase:(UIButton *)btn {
    // self.dateStr = btn.titleLabel.text;
    //openGroup =1 组合 0代表任意  点击1组合开门方式要判断是否开启了密码,指纹,卡,没有开启要提示用户开启
    [self isOpenLock];
    self.number = 0;
    if ([self.lockModel.securityLevel integerValue] == btn.tag-3) {
        [self viewOpenType];
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
    }
    
    //选择开门方式
    if (btn.tag == 4) {
        
        [self numberstr:4];
        self.securityLevel = 1;
        [self.combinationBtn setSelected:YES];
        [self.basisBtn setSelected:NO];
        [self.ministerBtn setSelected:NO];
        [self.directorBtn setSelected:NO];
        [self.governorBtn setSelected:NO];
         [self.faceBtn setSelected:NO];
       [self.faceBtn setSelected:NO];
        NSArray *array  =@[@"22",@"24"];
        if ([array containsObject:self.model.deviceType]) {
     self.combinationtitle.text  = ADLString(@"选择五种为一组的组合开门方式");
        }else {
      self.combinationtitle.text = ADLString(@"选择四种为一组的组合开门方式");
        }
       
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:3¥")];
        self.priceNumber.hidden = NO;
        self.openGroup =@"1";
        return ;
    }else  if (btn.tag == 5) {
        
        [self numberstr:3];
        self.securityLevel = 2;
        [self.basisBtn setSelected:YES];
        [self.combinationBtn setSelected:NO];
        [self.ministerBtn setSelected:NO];
        [self.directorBtn setSelected:NO];
        [self.governorBtn setSelected:NO];
         [self.faceBtn setSelected:NO];
        self.combinationtitle.text= ADLString(@"选择三种为一组的组合开门方式");
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:2¥")];
        self.priceNumber.hidden = NO;
        self.openGroup =@"1";
        return ;
    }else  if (btn.tag == 6) {
        [self numberstr:2];
        self.securityLevel = 3;
        [self.basisBtn setSelected:NO];
        [self.combinationBtn setSelected:NO];
        [self.ministerBtn setSelected:YES];
        [self.directorBtn setSelected:NO];
        [self.governorBtn setSelected:NO];
         [self.faceBtn setSelected:NO];
        self.combinationtitle.text= ADLString(@"选择两种为一组的组合开门方式");
        self.priceNumber.attributedText = [self attribtDic:ADLString(@"原价:1¥")];
        self.priceNumber.hidden = NO;
        self.openGroup =@"1";
        return ;
    }else  if (btn.tag == 7) {
        self.securityLevel = 4;
        [self.basisBtn setSelected:NO];
        [self.combinationBtn setSelected:NO];
        [self.ministerBtn setSelected:NO];
        [self.directorBtn setSelected:YES];
        [self.governorBtn setSelected:NO];
        self.combinationtitle.text =ADLString(@"选择任意几种单一开门方式");
        self.priceNumber.hidden = YES;
        self.openGroup =@"0";
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
        return ;
    }else  if (btn.tag == 8) {
        self.securityLevel = 5;
        [self.basisBtn setSelected:NO];
        [self.combinationBtn setSelected:NO];
        [self.ministerBtn setSelected:NO];
        [self.directorBtn setSelected:NO];
        [self.governorBtn setSelected:YES];
        self.combinationtitle.text= ADLString(@"选择单一开门方式");
        self.priceNumber.hidden = YES;
        self.CardBtn.hidden = YES;
        self.passBtn.hidden = YES;
        self.fingerprintBtn.hidden = YES;
         self.faceBtn.hidden = YES;
        [self.phoneBtn setTitle:ADLString(@"房卡") forState:UIControlStateNormal];
        
        [self.CardBtn setSelected:NO];
        [self.faceBtn setSelected:NO];
        [self.passBtn setSelected:NO];
        [self.fingerprintBtn setSelected:NO];
        [self.phoneBtn setSelected:NO];
        self.openGroup =@"0";
        self.addbutton.hidden = YES;
        
        if ([self.lockModel.securityLevel  isEqualToString:@"5"]) {
            if ([self.lockModel.openCard isEqualToString:@"1"]) {
                [self.phoneBtn setSelected:YES];
                
            }
        }
        
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
        return ;
    }
    
}

-(void)numberstr:(NSInteger)number{
    if (self.number == number ) {
        self.dateBtn.backgroundColor = COLOR_E0212A;
        self.dateBtn.userInteractionEnabled = YES;
    }else {
        _dateBtn.backgroundColor = COLOR_CCCCCC;
        _dateBtn.userInteractionEnabled = NO;
    }
}
-(void)viewOpenType{
    
    if ([self.lockModel.openApp isEqualToString:@"1"]) {
        [self.phoneBtn setSelected:YES];
        self.number ++;
    }else {
        [self.phoneBtn setSelected:NO];
    }
    
    if ([self.lockModel.openPassword isEqualToString:@"1"]) {
        [self.passBtn setSelected:YES];
        self.number ++;
    }else {
        [self.passBtn setSelected:NO];
    }
    
    if ([self.lockModel.openFingerprint isEqualToString:@"1"]) {
        [self.fingerprintBtn setSelected:YES];
        self.number ++;
    }else {
        [self.fingerprintBtn setSelected:NO];
    }
    if ([self.lockModel.openCard isEqualToString:@"1"]) {
        [self.CardBtn setSelected:YES];
        self.number ++;
        
    }else {
        [self.CardBtn setSelected:NO];
    }
    
    if ([self.lockModel.openFace isEqualToString:@"1"]) {
        [self.faceBtn setSelected:YES];
        self.number ++;
        
    }else {
        [self.faceBtn setSelected:NO];
    }
    
    
    
    
}
-(void)isOpenLock{
    
    self.CardBtn.hidden = NO;
    self.faceBtn.hidden = NO;
    self.passBtn.hidden = NO;
    self.fingerprintBtn.hidden = NO;
    [self.phoneBtn setTitle:ADLString(@"手机") forState:UIControlStateNormal];
    
    
    [self.CardBtn setSelected:NO];
      [self.faceBtn setSelected:NO];
    [self.passBtn setSelected:NO];
    [self.fingerprintBtn setSelected:NO];
    [self.phoneBtn setSelected:NO];
    
    self.addbutton.hidden = YES;
}

-(void)addOpenTypbutton:(UIButton*)btn{
    
    if (btn.tag == 1) {
        //密码
        [self changePassword];
    }else   if (btn.tag == 2) {
        
        //房卡
        ADLResurrectionCardController *vc = [[ADLResurrectionCardController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else   if (btn.tag == 3) {
        //指纹
        
    }
    
}

//更换密码
-(void)changePassword{
    [self isdeviceLock];
    WS(ws);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceCode"] =self.model.deviceCode;
    params[@"gatewayCode"] = self.model.gatewayCode;
    params[@"passwordId"] =self.model.passwordId;
    params[@"checkingInId"] =self.model.checkingInId;// 入住id
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    //进行POST请求

    [ADLNetWorkManager postWithPath:ADEL_resetPassword parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            ws.time =  [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(addtimer:) userInfo:nil repeats:NO];
            
          //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MQNotiLockPassword:) name:ADELLockPasswordMQNotification object:nil];
            
        }else {
            [ADLToast hide];
            [ADLToast showMessage:responseDict[@"msg"]];
            
        }
    
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
    
    
}
//判断是否超出入住时间/判断设备是否在线
-(BOOL)isdeviceLock {
    
    //判断s是否超出入住时间
//    if ([ADLHomeServiceModel showErrorMessage] == NO) {
//        return NO;
//    }
    //判断设备是否在线
    if (self.model.deviceStatus != 1) {
        [ADLToast showMessage:ADLString(@"设备未上线")];
        return NO;
    }
    return YES;
}
-(void)addtimer:(NSTimer *)isTime {
    
    [ADLToast hide];
    if (isTime.valid == YES) {
        [ADLToast showMessage:ADLString(@"获取秘钥超时")];
    }
    //取消定时器
    [self.time invalidate];
    self.time = nil;
    
}

-(void)MQNotiLockPassword:(NSNotification *)noit{
    
    WS(ws);
    NSDictionary *dict = noit.userInfo;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ws addtimer:nil];
        [ADLToast showMessage:dict[@"msg"]];
        if ([dict[@"resultCode"] integerValue] == 10000) {
            
            //刷新客房设备接口
          //  [[NSNotificationCenter defaultCenter] postNotificationName:ADELockrRefreshNotification object:nil userInfo:nil];
            
        }
    });
    
}

-(UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 30);
        //  [_button setTitle:ADLString(@"警告:修改开门方式需要验证管理员密码,此账号为验证码登录,请前去设置密码") forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorWithRed:255/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_button setAttributedTitle:[self string:ADLString(@"警告:修改开门方式需要密码,此账号为验证码登录,请前去设置密码")] forState:UIControlStateNormal];//这个状态要加上
        _button.titleLabel.font = [UIFont systemFontOfSize:10];
        _button.hidden = YES;
    }
    return  _button;
}
-(UIButton *)addbutton {
    if (!_addbutton) {
        _addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addbutton.frame = CGRectMake(50,self.subView.height - 25, SCREEN_WIDTH - 60, 20);
        [_addbutton addTarget:self action:@selector(addOpenTypbutton:) forControlEvents:UIControlEventTouchUpInside];
        [_addbutton setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        _addbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        // [_addbutton setAttributedTitle:[self string:ADLString(@"对不起,当前门锁没有密码,点击获取密码")] forState:UIControlStateNormal];//这个状态要加上
        _addbutton.titleLabel.font = [UIFont systemFontOfSize:12];
        _addbutton.hidden = YES;
    }
    return  _addbutton;
}
-(UIButton *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setTitle:ADLString(@"确定") forState:UIControlStateNormal];
        _dateBtn.frame = CGRectMake(20, SCREEN_HEIGHT-NAVIGATION_H -120, SCREEN_WIDTH - 40, 45);
        [_dateBtn addTarget:self action:@selector(AlterPassword) forControlEvents:UIControlEventTouchUpInside];
        _dateBtn.titleLabel.font =[UIFont systemFontOfSize:12];
        _dateBtn.layer.masksToBounds = YES;
        _dateBtn.layer.cornerRadius = 5;
        _dateBtn.backgroundColor = COLOR_CCCCCC;
        _dateBtn.userInteractionEnabled = NO;
    }
    return _dateBtn;
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(UIButton *)createButtonFrame:(CGRect)frame  title:(NSString *)title  target:(id)target tag:(NSInteger)tag action:(SEL)action{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (tag) {
        btn.tag = tag;
    }
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];;
    
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_unlock_alone"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_unlock_more"] forState:UIControlStateSelected];
    
    if (self.array.count  == 3) {
        if (tag == 4) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateSelected];
            [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            
        }
    }
    if (self.array.count  == 2) {
        if (tag == 5) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_lockpass_erro"] forState:UIControlStateSelected];
            [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        
    }
    
    return btn;
    
    
}
-(NSMutableAttributedString *)string:(NSString *)attributedString {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange strRange = {str.length - 4,4};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    return str;
}


-(NSMutableAttributedString *)attribtDic:(NSString *)str{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    return attribtStr;
}
-(void)dealloc{
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end


