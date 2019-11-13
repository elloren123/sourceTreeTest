//
//  ADLAddShipController.m
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAddShipController.h"
#import "ADLAddressPickerView.h"

@interface ADLAddShipController ()<UITextFieldDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *postTF;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *compBtn;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;
@property (nonatomic, strong) NSMutableDictionary *addressDict;
@property (nonatomic, strong) NSArray *tagArr;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *areaId;
@end

@implementation ADLAddShipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topH.constant = NAVIGATION_H;
    self.compBtn.layer.borderWidth = 0.5;
    self.homeBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
    self.compBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
    self.tagArr = [NSArray arrayWithObjects:self.homeBtn, self.compBtn, nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAreaLab)];
    [self.areaLab addGestureRecognizer:tap];
    
    [self addNavigationView:@"新增收货地址"];
    if (self.addressId != nil) {
        self.titleLab.text = @"修改收货地址";
        [self getAddressData];
    }
}

#pragma mark ------ 选择城市 ------
- (void)clickAreaLab {
    [self clickSelectAera];
}

- (IBAction)clickAeraBtn {
    [self clickSelectAera];
}

#pragma mark ------ 选择地址 ------
- (void)clickSelectAera {
    [self.view endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
        self.areaLab.textColor = COLOR_333333;
        self.areaLab.text = address;
        self.areaId = addressId;
    }];
}

#pragma mark ------ 家 标签 ------
- (IBAction)clickHomeBtn:(UIButton *)sender {
    [self setSelectedButton:sender];
}

#pragma mark ------ 公司 标签 ------
- (IBAction)clickCompanyBtn:(UIButton *)sender {
    [self setSelectedButton:sender];
}

#pragma mark ------ 设置选中 ------
- (void)setSelectedButton:(UIButton *)sender {
    if (sender.selected) return;
    [self.tagArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == sender) {
            obj.selected = YES;
            obj.layer.borderWidth = 0;
            obj.backgroundColor = COLOR_0083FD;
            [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            obj.selected = NO;
            obj.layer.borderWidth = 0.5;
            obj.backgroundColor = [UIColor whiteColor];
            [obj setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
    }];
}

#pragma mark ------ 默认地址开关 ------
- (IBAction)clickdefaultSwitch:(UISwitch *)sender {
    sender.on = !sender.on;
}

#pragma mark ------ 保存 ------
- (IBAction)clickSaveBtn:(UIButton *)sender {
    if (self.nameTF.text.length == 0) {
        [ADLToast showMessage:@"请填写收货人姓名"];
        return;
    }
    if (self.phoneTF.text.length == 0) {
        [ADLToast showMessage:@"请填写手机号码"];
        return;
    }
    if ([self.areaLab.text hasPrefix:@"请"]) {
        [ADLToast showMessage:@"请选择所在地址"];
        return;
    }
    if (self.addressTF.text.length == 0) {
        [ADLToast showMessage:@"请填写详细地址"];
        return;
    }
    
    if ([ADLUtils hasEmoji:self.nameTF.text] || [ADLUtils hasEmoji:self.addressTF.text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.nameTF.text forKey:@"consignee"];
    [params setValue:self.phoneTF.text forKey:@"phone"];
    [params setValue:self.areaId forKey:@"areaId"];
    [params setValue:self.addressTF.text forKey:@"address"];
    [params setValue:self.postTF.text forKey:@"postalCode"];
    if (self.homeBtn.selected) {
        [params setValue:@(0) forKey:@"label"];
    } else {
        [params setValue:@(2) forKey:@"label"];
    }
    if (self.defaultSwitch.on) {
        [params setValue:@(0) forKey:@"isDefault"];
    } else {
        [params setValue:@(1) forKey:@"isDefault"];
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSString *path = @"";
    NSString *toastStr = @"添加成功";
    if (_addressId == nil) {
        path = k_add_address;
        self.cityId = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:self.areaId].cityId;
    } else {
        [params setValue:self.addressId forKey:@"id"];
        path = k_modify_address;
        toastStr = @"修改成功";
    }
    
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.addressDict = params;
            [self.addressDict setValue:self.cityId forKey:@"cityId"];
            [self.addressDict setValue:[NSString stringWithFormat:@"%@%@",self.areaLab.text,self.addressTF.text] forKey:@"areaStr"];
            NSString *adrsId = [responseDict[@"data"] stringValue];
            if (adrsId.length < 4) adrsId = self.addressId;
            [self.addressDict setValue:adrsId forKey:@"id"];
            
            [ADLToast showMessage:toastStr];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"address" userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 获取收货地址信息 ------
- (void)getAddressData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.addressId forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_query_address_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.nameTF.text = responseDict[@"data"][@"consignee"];
            self.phoneTF.text = responseDict[@"data"][@"phone"];
            self.addressTF.text = responseDict[@"data"][@"address"];
            self.postTF.text = responseDict[@"data"][@"postalCode"];
            if ([responseDict[@"data"][@"label"] intValue] == 0) {
                [self setSelectedButton:self.homeBtn];
            } else {
                [self setSelectedButton:self.compBtn];
            }
            self.defaultSwitch.on = ![responseDict[@"data"][@"isDefault"] boolValue];
            self.areaId = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"areaId"]];
            AddressInfo info = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:self.areaId];
            self.areaLab.textColor = COLOR_333333;
            self.areaLab.text = info.address;
            self.cityId = info.cityId;
        }
    } failure:nil];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameTF) {
        [self.phoneTF becomeFirstResponder];
    } else if (textField == self.addressTF) {
        [self.postTF becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTF) {
        return [ADLUtils phoneTextField:textField replacementString:string];
    } else if (textField == self.postTF) {
        return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:YES];
    } else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    if (self.finish) {
        self.finish(self.addressDict);
    }
}

@end
