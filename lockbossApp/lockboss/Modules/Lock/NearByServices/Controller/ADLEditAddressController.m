//
//  ADLEditAddressController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEditAddressController.h"
#import "ADLAddressPickerView.h"

@interface ADLEditAddressController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray       *provinceArr;
@property (nonatomic, strong) UILabel       *zoneLabel;
@property (nonatomic, strong) UITextField   *detailAddrTextField;
@property (nonatomic, strong) UITextField   *contactTextField;
@property (nonatomic, strong) UITextField   *phoneTextField;
@property (nonatomic, assign) BOOL          genderFlag;//性别flag: yes: male; no: female;
@property (nonatomic, strong) UIImageView   *maleIcon;
@property (nonatomic, strong) UIImageView   *femaleIcon;
@property (nonatomic, strong) UIButton      *labelBtn1;
@property (nonatomic, strong) UIButton      *labelBtn2;
@property (nonatomic, strong) UIButton      *labelBtn3;
@property (nonatomic, strong) UIButton      *labelBtn4;
@property (nonatomic, assign) NSInteger     labelBtnTag;  //地址标签Tag: 1表示'家'; 2表示'学校'; 3表示'酒店'; 4表示'公司'

@end

@implementation ADLEditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentView];
    
    //获取地区数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
}

- (void)createNavigationView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"新增收货地址";
    [navView addSubview:titLab];
    if (!self.addNewAddressFlag) {
        titLab.text = @"修改收货地址";
    }
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    NSLog(@"sender.tag = %zd", sender.tag);
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 201:   //选择地区
            [self.view endEditing:YES];
            [self selectAddress];
            break;
            
        case 301:
        case 302:
            [self updateGenderImage:sender.tag];
            break;
            
        case 401:   //'家'
        case 402:   //'学校'
        case 403:   //'酒店'
        case 404:   //'公司'
            if (self.labelBtnTag != sender.tag-400) {
                self.labelBtnTag = sender.tag-400;
            } else {
                self.labelBtnTag = 0;
            }
            [self updateLabelbtns];
            break;
            
        case 501:   //保存地址
            [self saveAddressAction];
            break;
            
            
            
        default:
            break;
    }
}
- (void)selectAddress {
    [self.view endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
//        NSLog(@"address : %@, ID: %@", address, addressId);
        self.zoneLabel.text = address;
        if (self.zoneLabel.hidden == YES) {
            self.zoneLabel.hidden = NO;
        }
    }];
}
- (void)updateGenderImage:(NSInteger)tag {
    if (tag == 301) {
        self.genderFlag = YES;
        self.maleIcon.image = [UIImage imageNamed:@"icon-xuanz"];
        self.femaleIcon.image = [UIImage imageNamed:@"icon_wei"];
    } else {
        self.genderFlag = NO;
        self.maleIcon.image = [UIImage imageNamed:@"icon_wei"];
        self.femaleIcon.image = [UIImage imageNamed:@"icon-xuanz"];
    }
}
- (void)updateLabelbtns {
    if (self.labelBtnTag == 1) {
        self.labelBtn1.layer.borderColor = [UIColor clearColor].CGColor;
        self.labelBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.labelBtn1.backgroundColor = COLOR_E0212A;
        self.labelBtn2.backgroundColor = [UIColor clearColor];
        self.labelBtn3.backgroundColor = [UIColor clearColor];
        self.labelBtn4.backgroundColor = [UIColor clearColor];
        
        [self.labelBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.labelBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (self.labelBtnTag == 2) {
        self.labelBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn2.layer.borderColor = [UIColor clearColor].CGColor;
        self.labelBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.labelBtn1.backgroundColor = [UIColor clearColor];
        self.labelBtn2.backgroundColor = COLOR_E0212A;
        self.labelBtn3.backgroundColor = [UIColor clearColor];
        self.labelBtn4.backgroundColor = [UIColor clearColor];
        
        [self.labelBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.labelBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (self.labelBtnTag == 3) {
        self.labelBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn3.layer.borderColor = [UIColor clearColor].CGColor;
        self.labelBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.labelBtn1.backgroundColor = [UIColor clearColor];
        self.labelBtn2.backgroundColor = [UIColor clearColor];
        self.labelBtn3.backgroundColor = COLOR_E0212A;
        self.labelBtn4.backgroundColor = [UIColor clearColor];
        
        [self.labelBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.labelBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (self.labelBtnTag == 4) {
        self.labelBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn4.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.labelBtn1.backgroundColor = [UIColor clearColor];
        self.labelBtn2.backgroundColor = [UIColor clearColor];
        self.labelBtn3.backgroundColor = [UIColor clearColor];
        self.labelBtn4.backgroundColor = COLOR_E0212A;
        
        [self.labelBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {    //self.labelBtnTag = 0
        self.labelBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.labelBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.labelBtn1.backgroundColor = [UIColor clearColor];
        self.labelBtn2.backgroundColor = [UIColor clearColor];
        self.labelBtn3.backgroundColor = [UIColor clearColor];
        self.labelBtn4.backgroundColor = [UIColor clearColor];
        
        [self.labelBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.labelBtn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}
- (void)saveAddressAction {
    if (self.zoneLabel.hidden == YES) {
        [ADLToast showMessage:@"您还未选择收货地址!" duration:2.0];
   
    } else if (self.detailAddrTextField.text.length == 0) {
        [ADLToast showMessage:@"您还未输入门牌号!" duration:2.0];
    
    } else if (self.contactTextField.text.length == 0) {
        [ADLToast showMessage:@"您还未输入联系人姓名!" duration:2.0];
        
    } else if (self.phoneTextField.text.length == 0) {
        [ADLToast showMessage:@"您还未输入收货人手机号!" duration:2.0];
        
    } else {
        if (self.addNewAddressFlag) {   //添加地址
            [self addAddressData];
        } else {    //修改地址
            [self editAddressData];
        }
    }
}
- (void)finishedEditAddress {
    if (self.addNewAddressFlag) {//添加地址
        self.addrDict = [NSMutableDictionary dictionary];
    }
    [self.addrDict setValue:self.zoneLabel.text forKey:@"area"];    //地区
    [self.addrDict setValue:self.detailAddrTextField.text forKey:@"address"]; //具体地址
    [self.addrDict setValue:self.contactTextField.text forKey:@"consignee"];  //收货人名称
    [self.addrDict setValue:self.phoneTextField.text forKey:@"phone"];   //收货人手机号
    if (self.genderFlag) {
        [self.addrDict setValue:@"2" forKey:@"sex"]; //男士
    } else {
        [self.addrDict setValue:@"1" forKey:@"sex"]; //女士
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHED_EDIT_ADDRESS_NOTICATION" object:nil userInfo:self.addrDict];
//
//    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)createContentView {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 250)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    
    NSArray *array = @[@"收货地址:", @"门牌号:", @"联系人:", @"", @"手机号:"];
    for (int i = 0 ; i < 5; i++) {
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 50*i, 80, 50)];
        titLab.textAlignment = NSTextAlignmentLeft;
        titLab.font = [UIFont systemFontOfSize:16];
        titLab.textColor = [UIColor blackColor];
        titLab.text = array[i];
        [whiteView addSubview:titLab];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49+50*i, SCREEN_WIDTH, 1)];
        line.backgroundColor = SEPARATOR_COLOR;
        [whiteView addSubview:line];
        
        if (i == 2) {
            line.hidden = YES;
        }
    }
    
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-130, 44)];
    selectBtn.tag = 201;
    [selectBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:selectBtn];
    
    UIImageView *locImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 15, 20)];
    locImg.image = [UIImage imageNamed:@"icon_diz"];
    [selectBtn addSubview:locImg];
    
    UILabel *selectLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 50)];
    selectLab.textAlignment = NSTextAlignmentLeft;
    selectLab.font = [UIFont systemFontOfSize:16];
    selectLab.textColor = [UIColor grayColor];
    selectLab.text = @"点击选择";
    [selectBtn addSubview:selectLab];
    
    
    
    //------ *** ------ 地区地址label
    UILabel *zoneLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-120, 49)];
    zoneLab.backgroundColor = [UIColor whiteColor];
    zoneLab.textAlignment = NSTextAlignmentLeft;
    zoneLab.font = [UIFont systemFontOfSize:15];
    zoneLab.textColor = [UIColor blackColor];
    zoneLab.hidden = YES;
    [whiteView addSubview:zoneLab];
    self.zoneLabel = zoneLab;
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 17, 8, 16)];
    nextImg.image = [UIImage imageNamed:@"icon_xiao"];
    [whiteView addSubview:nextImg];
    
    
    
    for (int i = 0 ; i < 3; i++) {
        int count = i;
        if (i == 2) {
            count = 3;
        }
        UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(100, 50*(count+1), SCREEN_WIDTH-100, 50)];
        txtField.tag = 101+i;
        txtField.textAlignment = NSTextAlignmentLeft;
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField.font = [UIFont systemFontOfSize:FONT_SIZE];
        txtField.returnKeyType = UIReturnKeyDone;
        txtField.delegate = self;
        [whiteView addSubview:txtField];
        
        if (i == 0) {
            txtField.placeholder = @"详细地址: 例如10栋4楼410室";
            self.detailAddrTextField = txtField;
        
        } else if (i == 1) {
            txtField.placeholder = @"请填写收货人姓名";
            self.contactTextField = txtField;
        
        } else if (i == 2) {
            txtField.placeholder = @"请填写收获手机号码";
            self.phoneTextField = txtField;
        }
    }
    
    
    self.genderFlag = YES;
    for (int i = 0 ; i < 2; i++) {
        UIButton *genderBtn = [[UIButton alloc] initWithFrame:CGRectMake(100*(i+1), 160, 80, 30)];
        genderBtn.tag = 301+i;
        [genderBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:genderBtn];
        
        UIImageView *genderImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
        genderImg.image = [UIImage imageNamed:@"icon-xuanz"];
        [genderBtn addSubview:genderImg];
        
        UILabel *genderLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
        genderLab.textAlignment = NSTextAlignmentLeft;
        genderLab.font = [UIFont systemFontOfSize:14];
        genderLab.textColor = [UIColor grayColor];
        genderLab.text = @"先生";
        [genderBtn addSubview:genderLab];
        
        if (i == 0) {
            self.maleIcon = genderImg;
        } else {
            genderImg.image = [UIImage imageNamed:@"icon_wei"];
            genderLab.text  = @"女士";
            self.femaleIcon = genderImg;
        }
    }
    
    
    
    UILabel *labelLab = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+250, 40, 50)];
    labelLab.textAlignment = NSTextAlignmentLeft;
    labelLab.font = [UIFont systemFontOfSize:15];
    labelLab.textColor = [UIColor blackColor];
    labelLab.text = @"标签";
    [self.view addSubview:labelLab];
    
    self.labelBtnTag = 0;
    for (int i = 0 ; i < 4; i++) {
        UIButton *labelBtn = [[UIButton alloc] initWithFrame:CGRectMake(65*(i+1), NAVIGATION_H+260, 50, 30)];
        labelBtn.layer.cornerRadius = 2.0;
        labelBtn.layer.borderWidth = 1.0;
        labelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelBtn.tag = 401+i;
        labelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [labelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [labelBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:labelBtn];
        
        if (i == 0) {
            [labelBtn setTitle:@"家" forState:UIControlStateNormal];
            self.labelBtn1 = labelBtn;
        
        } else if (i == 1) {
            [labelBtn setTitle:@"学校" forState:UIControlStateNormal];
            self.labelBtn2 = labelBtn;
        
        } else if (i == 2) {
            [labelBtn setTitle:@"公司" forState:UIControlStateNormal];
            self.labelBtn3 = labelBtn;
        
        } else if (i == 3) {
            [labelBtn setTitle:@"酒店" forState:UIControlStateNormal];
            self.labelBtn4 = labelBtn;
        }
    }
    
    
    
    //------ *** ------ 保存地址
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, NAVIGATION_H+320, SCREEN_WIDTH-50, 44)];
    saveBtn.backgroundColor = COLOR_E0212A;
    saveBtn.layer.cornerRadius = 4.0;
    saveBtn.tag = 501;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    //修改地址时更新信息
    if (!self.addNewAddressFlag) {
        self.zoneLabel.text = self.addrDict[@"area"];
        self.zoneLabel.hidden = NO;
        self.detailAddrTextField.text = self.addrDict[@"address"];
        self.contactTextField.text = self.addrDict[@"consignee"];
        self.phoneTextField.text = self.addrDict[@"phone"];
        
        if ([self.addrDict[@"sex"] intValue] == 1) {    //女士
            self.genderFlag = NO;
            self.maleIcon.image = [UIImage imageNamed:@"icon_wei"];
            self.femaleIcon.image = [UIImage imageNamed:@"icon-xuanz"];
        }
        
        //地址标签
        if (self.addrDict[@"label"]) {
            self.labelBtnTag = [self.addrDict[@"label"] integerValue];
            [self updateLabelbtns];
        }
    }
}


#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark ------ 添加地址 ------
- (void)addAddressData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.contactTextField.text     forKey:@"consignee"];
    [params setValue:self.phoneTextField.text       forKey:@"phone"];
    [params setValue:self.zoneLabel.text            forKey:@"area"];
    [params setValue:self.detailAddrTextField.text  forKey:@"address"];
    [params setValue:@"1"                           forKey:@"isDefault"];//是否默认地址 0：是，1：不是
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    NSString *gender = @"1";
    if (self.genderFlag) {
        gender = @"2";
    }
    [params setValue:gender forKey:@"sex"]; //性别
    
    if (self.labelBtnTag == 1) {
        [params setValue:@"1" forKey:@"label"]; //标签: 1家 2学校 3公司 4酒店
    } else if (self.labelBtnTag == 2) {
        [params setValue:@"2" forKey:@"label"];
    } else if (self.labelBtnTag == 3) {
        [params setValue:@"3" forKey:@"label"];
    } else if (self.labelBtnTag == 4) {
        [params setValue:@"4" forKey:@"label"];
    }
    
    
    __weak typeof(self)WeakSelf = self;
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/address/save.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"添加收货地址返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            WeakSelf.addrDict = [NSMutableDictionary dictionary];   //初始化集合
            [WeakSelf.addrDict setValue:responseDict[@"data"] forKey:@"id"];    //地址id
            [WeakSelf.addrDict setValue:WeakSelf.zoneLabel.text forKey:@"area"];    //地区
            [WeakSelf.addrDict setValue:WeakSelf.detailAddrTextField.text forKey:@"address"]; //具体地址
            [WeakSelf.addrDict setValue:WeakSelf.contactTextField.text forKey:@"consignee"];  //收货人名称
            [WeakSelf.addrDict setValue:WeakSelf.phoneTextField.text forKey:@"phone"];   //收货人手机号
            [WeakSelf.addrDict setValue:params[@"sex"] forKey:@"sex"]; //性别
            if (WeakSelf.labelBtnTag != 0) { //标签: 1家 2学校 3公司 4酒店
                [WeakSelf.addrDict setValue:params[@"label"] forKey:@"label"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHED_EDIT_ADDRESS_NOTICATION" object:nil userInfo:WeakSelf.addrDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHED_ADD_OR_DELETE_ADDRESS_NOTICATION" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        }
    }];
}
#pragma mark ------ 修改地址 ------
- (void)editAddressData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.addrDict[@"id"]              forKey:@"id"];
    [params setValue:self.contactTextField.text     forKey:@"consignee"];
    [params setValue:self.phoneTextField.text       forKey:@"phone"];
    [params setValue:self.zoneLabel.text            forKey:@"area"];
    [params setValue:self.detailAddrTextField.text  forKey:@"address"];
    [params setValue:@"1"                           forKey:@"isDefault"];//是否默认地址 0：是，1：不是
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    NSString *gender = @"1";
    if (self.genderFlag) {
        gender = @"2";
    }
    [params setValue:gender forKey:@"sex"]; //性别
    
    if (self.labelBtnTag == 1) {
        [params setValue:@"1" forKey:@"label"]; //标签: 1家 2学校 3公司 4酒店
    } else if (self.labelBtnTag == 2) {
        [params setValue:@"2" forKey:@"label"];
    } else if (self.labelBtnTag == 3) {
        [params setValue:@"3" forKey:@"label"];
    } else if (self.labelBtnTag == 4) {
        [params setValue:@"4" forKey:@"label"];
    }
    
     
    __weak typeof(self)WeakSelf = self;
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/address/update.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"修改收货地址返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [WeakSelf.addrDict setValue:WeakSelf.zoneLabel.text forKey:@"area"];    //地区
            [WeakSelf.addrDict setValue:WeakSelf.detailAddrTextField.text forKey:@"address"]; //具体地址
            [WeakSelf.addrDict setValue:WeakSelf.contactTextField.text forKey:@"consignee"];  //收货人名称
            [WeakSelf.addrDict setValue:WeakSelf.phoneTextField.text forKey:@"phone"];   //收货人手机号
            [WeakSelf.addrDict setValue:params[@"sex"] forKey:@"sex"]; //性别
            if (WeakSelf.labelBtnTag != 0) {    //标签: 1家 2学校 3公司 4酒店
                [WeakSelf.addrDict setValue:params[@"label"] forKey:@"label"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHED_EDIT_ADDRESS_NOTICATION" object:nil userInfo:WeakSelf.addrDict];
        
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        }
    }];
}

@end
