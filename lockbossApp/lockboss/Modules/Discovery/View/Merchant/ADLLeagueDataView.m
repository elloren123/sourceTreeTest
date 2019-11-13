//
//  ADLLeagueDataView.m
//  lockboss
//
//  Created by adel on 2019/6/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLeagueDataView.h"
#import "ADLAddressPickerView.h"
#import "ADLGlobalDefine.h"
#import "ADLModifyView.h"
#import "ADLAttachView.h"
#import "ADLUserModel.h"
#import "ADLApiDefine.h"
#import "ADLTextView.h"
#import "ADLUtils.h"
#import "ADLToast.h"

@interface ADLLeagueDataView ()<UITextFieldDelegate,ADLTextViewDelegate>
@property (nonatomic, strong) NSMutableArray *provinceArr;
@end

@implementation ADLLeagueDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ADLTextView *textView = [[ADLTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-24, 128) limitLength:0];
    textView.placeholder = @"请输入申请原因";
    textView.delegate = self;
    [self.reasonView addSubview:textView];
    self.textView = textView;
    
    self.reasonView.layer.borderWidth = 0.5;
    self.reasonView.layer.borderColor = COLOR_D3D3D3.CGColor;
    self.confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    self.companyTF.delegate = self;
    self.personTF.delegate = self;
    self.businessTF.delegate = self;
    self.taxTF.delegate = self;
    self.addressTF.delegate = self;
    self.mobileTF.delegate = self;
    self.faxTF.delegate = self;
    self.mailTF.delegate = self;
    self.meterTF.delegate = self;
    self.moneyTF.delegate = self;
    self.totalTF.delegate = self;
    self.salesmanTF.delegate = self;
    self.techniqueTF.delegate = self;
    self.otherTF.delegate = self;
    
    self.type = 999;
    self.money = 999;
    self.industry = 999;
    self.advantage = 999;
    self.updateOffset = YES;
    
    self.phoneLab.text = [ADLUserModel sharedModel].phone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleEditing)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *lockTypeLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLockTypeLab)];
    [self.lockTypeLab addGestureRecognizer:lockTypeLabTap];
    
    UITapGestureRecognizer *areaLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAreaLab)];
    [self.areaLab addGestureRecognizer:areaLabTap];
    
    UITapGestureRecognizer *energyLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnergyLab)];
    [self.energyLab addGestureRecognizer:energyLabTap];
    
    UITapGestureRecognizer *fundLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFundLab)];
    [self.fundLab addGestureRecognizer:fundLabTap];
    
    UITapGestureRecognizer *meritLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMeritLab)];
    [self.meritLab addGestureRecognizer:meritLabTap];
}

#pragma mark ------ 开始编辑 ------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leagueInputViewDidBeginEditing:)]) {
        [self.delegate leagueInputViewDidBeginEditing:textField];
    }
}

- (void)textViewDidBeginEdit:(UIView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leagueInputViewDidBeginEditing:)]) {
        [self.delegate leagueInputViewDidBeginEditing:textView];
    }
}

#pragma mark ------ 退出编辑 ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        if (textField.tag == 4) {
            return [ADLUtils phoneTextField:textField replacementString:string];
        } else if (textField.tag == 6) {
            return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:NO];
        } else {
            return YES;
        }
    }
}

#pragma mark ------ 修改手机号 ------
- (IBAction)clickModifyPhoneBtn:(UIButton *)sender {
    ///dataDict字段 title-标题 placeholder-提示文字  code-获取验证码地址 key-获取验证码参数key path-提交地址 param-参数字典input-code
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"修改手机号" forKey:@"title"];
    [dict setValue:@"请输入手机号" forKey:@"placeholder"];
    [dict setValue:k_send_msg_code forKey:@"code"];
    [dict setValue:@"phoneNumber" forKey:@"key"];
    [dict setValue:k_recorder_modify_phone forKey:@"path"];
    if (self.leagueId.length > 0) {
        [dict setValue:@{@"input":@"phone",@"code":@"code",@"recordId":self.leagueId} forKey:@"param"];
    } else {
        [dict setValue:@{@"input":@"phone",@"code":@"code"} forKey:@"param"];
    }
    [ADLModifyView modifyViewWithType:ADLModifyTypePhone dataDict:dict confirmAction:^(NSString *input) {
        if (input) {
            self.phoneLab.text = input;
        }
    }];
}

#pragma mark ------ 申请行业 ------
- (void)clickLockTypeLab {
    [self clickSelectLockType];
}

- (IBAction)clickLockTypeBtn:(UIButton *)sender {
    [self clickSelectLockType];
}

- (void)clickSelectLockType {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.lockTypeBtn.superview convertRect:self.lockTypeBtn.frame toView:window];
    NSArray *titArr = @[@"酒店门锁",@"家庭门锁"];
    [UIView animateWithDuration:0.3 animations:^{
        self.lockTypeBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(140, frame.size.height+frame.origin.y, SCREEN_WIDTH-140, 88) titleArr:titArr finish:^(NSInteger index) {
        self.updateOffset = YES;
        if (index != -1) {
            self.industry = index;
            self.lockTypeLab.textColor = COLOR_333333;
            self.lockTypeLab.text = titArr[index];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.lockTypeBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 申请地区 ------
- (void)clickAreaLab {
    [self clickApplyArea];
}

- (IBAction)clickAreaBtn:(UIButton *)sender {
    [self clickApplyArea];
}

- (void)clickApplyArea {
    [self endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
        self.areaLab.textColor = COLOR_333333;
        self.areaLab.text = address;
        self.areaId = addressId;
    }];
}

#pragma mark ------ 投入精力 ------
- (void)clickEnergyLab {
    [self clickIntoEnergy];
}

- (IBAction)clickEnergyBtn:(UIButton *)sender {
    [self clickIntoEnergy];
}

- (void)clickIntoEnergy {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.energyBtn.superview convertRect:self.energyBtn.frame toView:window];
    NSArray *titArr = @[@"自己经营",@"合作经营",@"他人代理经营"];
    [UIView animateWithDuration:0.3 animations:^{
        self.energyBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(140, frame.size.height+frame.origin.y, SCREEN_WIDTH-140, 132) titleArr:titArr finish:^(NSInteger index) {
        self.updateOffset = YES;
        if (index != -1) {
            self.type = index+1;
            self.energyLab.textColor = COLOR_333333;
            self.energyLab.text = titArr[index];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.energyBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 投入资金 ------
- (void)clickFundLab {
    [self clickIntoFund];
}

- (IBAction)clickFundBtn:(UIButton *)sender {
    [self clickIntoFund];
}

- (void)clickIntoFund {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.fundBtn.superview convertRect:self.fundBtn.frame toView:window];
    NSArray *titArr = @[@"10万元以下",@"10~20万元",@"20~30万元",@"30~40万元",@"40~50万元",@"50万元以上"];
    [UIView animateWithDuration:0.3 animations:^{
        self.fundBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(140, frame.size.height+frame.origin.y, SCREEN_WIDTH-140, 264) titleArr:titArr finish:^(NSInteger index) {
        self.updateOffset = YES;
        if (index != -1) {
            self.money = index+1;
            self.fundLab.textColor = COLOR_333333;
            self.fundLab.text = titArr[index];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.fundBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 自有 ------
- (IBAction)clickHaveBtn:(UIButton *)sender {
    sender.selected = YES;
    self.rentBtn.selected = NO;
}

#pragma mark ------ 自租 ------
- (IBAction)clickRentBtn:(UIButton *)sender {
    sender.selected = YES;
    self.haveBtn.selected = NO;
}

#pragma mark ------ 公司优势 ------
- (void)clickMeritLab {
    [self clickCompanyMerit];
}

- (IBAction)clickMeritBtn:(UIButton *)sender {
    [self clickCompanyMerit];
}

- (void)clickCompanyMerit {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.meritBtn.superview convertRect:self.meritBtn.frame toView:window];
    NSArray *titArr = @[@"足够的资金",@"好的销售渠道",@"在当地的公共关系",@"合适的从业人员",@"其他"];
    [UIView animateWithDuration:0.3 animations:^{
        self.meritBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(140, frame.size.height+frame.origin.y, SCREEN_WIDTH-140, 220) titleArr:titArr finish:^(NSInteger index) {
        self.updateOffset = YES;
        if (index != -1) {
            self.advantage = index+1;
            self.meritLab.textColor = COLOR_333333;
            self.meritLab.text = titArr[index];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.meritBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateScrollViewContentOffset)]) {
                [self.delegate updateScrollViewContentOffset];
            }
        }];
    }];
}

#pragma mark ------ 提交 ------
- (IBAction)clickConfirmBtn:(UIButton *)sender {
    if (self.companyTF.text.length == 0) {
        [ADLToast showMessage:@"请输入申请单位"];
        return;
    }
    if (self.personTF.text.length == 0) {
        [ADLToast showMessage:@"请输入单位负责人"];
        return;
    }
    if (self.businessTF.text.length == 0) {
        [ADLToast showMessage:@"请输入工商登记号"];
        return;
    }
    if (self.taxTF.text.length == 0) {
        [ADLToast showMessage:@"请输入税务登记号"];
        return;
    }
    if (self.addressTF.text.length == 0) {
        [ADLToast showMessage:@"请输入联系地址"];
        return;
    }
    if (self.mailTF.text.length == 0) {
        [ADLToast showMessage:@"请输入邮箱"];
        return;
    }
    if (![ADLUtils verifyEmailAddress:self.mailTF.text]) {
        [ADLToast showMessage:@"请输入正确的邮箱"];
        return;
    }
    if (self.industry == 999) {
        [ADLToast showMessage:@"请选择申请行业"];
        return;
    }
    if (self.areaId.length < 3) {
        [ADLToast showMessage:@"请选择申请地区"];
        return;
    }
    if (self.type == 999) {
        [ADLToast showMessage:@"请选择计划投入精力"];
        return;
    }
    if (self.money == 999) {
        [ADLToast showMessage:@"请选择计划投入资金"];
        return;
    }
    
    if ([ADLUtils hasEmoji:self.textView.text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.companyTF.text forKey:@"company"];
    [params setValue:self.personTF.text forKey:@"responsibleMen"];
    [params setValue:self.addressTF.text forKey:@"companyAddress"];
    [params setValue:self.businessTF.text forKey:@"businessRegisterNumber"];
    [params setValue:self.taxTF.text forKey:@"taxRegisterNumber"];
    [params setValue:self.phoneLab.text forKey:@"companyPhone"];
    [params setValue:self.mobileTF.text forKey:@"phone"];
    [params setValue:self.faxTF.text forKey:@"fax"];
    [params setValue:self.mailTF.text forKey:@"email"];
    [params setValue:@(self.industry) forKey:@"industry"];
    [params setValue:self.areaId forKey:@"area"];
    [params setValue:@(self.type) forKey:@"type"];
    [params setValue:@(self.money) forKey:@"money"];
    [params setValue:self.meterTF.text forKey:@"acreage"];
    if (self.haveBtn.selected) {
        [params setValue:@(1) forKey:@"nature"];
    }
    if (self.rentBtn.selected) {
        [params setValue:@(2) forKey:@"nature"];
    }
    [params setValue:self.moneyTF.text forKey:@"turnover"];
    [params setValue:self.totalTF.text forKey:@"numberMens"];
    if (self.advantage != 999) {
        [params setValue:@(self.advantage) forKey:@"advantage"];
    }
    [params setValue:self.textView.text forKey:@"desc"];
    [params setValue:self.salesmanTF.text forKey:@"salesMan"];
    [params setValue:self.otherTF.text forKey:@"other"];
    [params setValue:self.techniqueTF.text forKey:@"technician"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSubmitBtn:)]) {
        [self.delegate didClickSubmitBtn:params];
    }
}

#pragma mark ------ 更新输入信息 ------
- (void)updateInputViewWithDictionary:(NSDictionary *)dict {
    self.leagueId = dict[@"id"];
    self.companyTF.text = dict[@"company"];
    self.personTF.text = dict[@"responsibleMen"];
    self.phoneLab.text = dict[@"companyPhone"];
    self.businessTF.text = dict[@"businessRegisterNumber"];
    self.taxTF.text = dict[@"taxRegisterNumber"];
    self.addressTF.text = dict[@"companyAddress"];
    self.mobileTF.text = dict[@"phone"];
    self.faxTF.text = dict[@"fax"];
    self.mailTF.text = dict[@"email"];
    self.industry = [dict[@"industry"] integerValue];
    self.lockTypeLab.textColor = COLOR_333333;
    if (self.industry == 0) {
        self.lockTypeLab.text = @"酒店门锁";
    } else {
        self.lockTypeLab.text = @"家庭门锁";
    }
    self.areaId = [dict[@"area"] stringValue];
    self.areaLab.textColor = COLOR_333333;
    self.areaLab.text = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:self.areaId].address;
    
    self.energyLab.textColor = COLOR_333333;
    self.type = [dict[@"type"] integerValue];
    if (self.type == 1) {
        self.energyLab.text = @"自己经营";
    } else if (self.type == 2) {
        self.energyLab.text = @"合作经营";
    } else {
        self.energyLab.text = @"他人代理经营";
    }
    
    self.fundLab.textColor = COLOR_333333;
    self.money = [dict[@"money"] integerValue];
    if (self.money == 1) {
        self.fundLab.text = @"10万元以下";
    } else if (self.money == 2) {
        self.fundLab.text = @"10~20万元";
    } else if (self.money == 3) {
        self.fundLab.text = @"20~30万元";
    } else if (self.money == 4) {
        self.fundLab.text = @"30~40万元";
    } else if (self.money == 5) {
        self.fundLab.text = @"40~50万元";
    } else {
        self.fundLab.text = @"50万元以上";
    }
    
    NSInteger nature = [dict[@"nature"] integerValue];
    if (nature == 1) {
        self.haveBtn.selected = YES;
    }
    if (nature == 2) {
        self.rentBtn.selected = YES;
    }
    self.meterTF.text = [dict[@"acreage"] stringValue];
    self.moneyTF.text = [dict[@"turnover"] stringValue];
    self.totalTF.text = [dict[@"numberMens"] stringValue];
    self.salesmanTF.text = [dict[@"salesMan"] stringValue];
    self.techniqueTF.text = [dict[@"technician"] stringValue];
    self.otherTF.text = [dict[@"other"] stringValue];
    
    if ([dict[@"advantage"] integerValue] != 0) {
        self.meritLab.textColor = COLOR_333333;
        self.advantage = [dict[@"advantage"] integerValue];
        if (self.advantage == 1) {
            self.meritLab.text = @"足够的资金";
        } else if (self.advantage == 2) {
            self.meritLab.text = @"好的销售渠道";
        } else if (self.advantage == 3) {
            self.meritLab.text = @"在当地的公众关系";
        } else if (self.advantage == 4) {
            self.meritLab.text = @"合适的从业人员";
        } else {
            self.meritLab.text = @"其它";
        }
    }
    self.textView.text = dict[@"desc"];
}

#pragma mark ------ 设置不可编辑 ------
- (void)setInputViewUneditable {
    self.companyTF.enabled = NO;
    self.personTF.enabled = NO;
    self.businessTF.enabled = NO;
    self.taxTF.enabled = NO;
    self.addressTF.enabled = NO;
    self.mobileTF.enabled = NO;
    self.faxTF.enabled = NO;
    self.mailTF.enabled = NO;
    self.lockTypeLab.userInteractionEnabled = NO;
    self.lockTypeBtn.enabled = NO;
    self.areaLab.userInteractionEnabled = NO;
    self.areaBtn.enabled = NO;
    self.energyLab.userInteractionEnabled = NO;
    self.energyBtn.enabled = NO;
    self.fundLab.userInteractionEnabled = NO;
    self.fundBtn.enabled = NO;
    self.haveBtn.userInteractionEnabled = NO;
    self.rentBtn.userInteractionEnabled = NO;
    self.meterTF.enabled = NO;
    self.moneyTF.enabled = NO;
    self.totalTF.enabled = NO;
    self.salesmanTF.enabled = NO;
    self.techniqueTF.enabled = NO;
    self.otherTF.enabled = NO;
    self.meritLab.userInteractionEnabled = NO;
    self.meritBtn.enabled = NO;
    self.textView.userInteractionEnabled = NO;
    self.confirmBtn.enabled = NO;
    
    self.companyTF.alpha = 0.5;
    self.personTF.alpha = 0.5;
    self.businessTF.alpha = 0.5;
    self.taxTF.alpha = 0.5;
    self.addressTF.alpha = 0.5;
    self.mobileTF.alpha = 0.5;
    self.faxTF.alpha = 0.5;
    self.mailTF.alpha = 0.5;
    self.lockTypeLab.alpha = 0.5;
    self.lockTypeBtn.alpha = 0.5;
    self.areaLab.alpha = 0.5;
    self.areaBtn.alpha = 0.5;
    self.energyLab.alpha = 0.5;
    self.energyBtn.alpha = 0.5;
    self.fundLab.alpha = 0.5;
    self.fundBtn.alpha = 0.5;
    self.haveBtn.alpha = 0.5;
    self.rentBtn.alpha = 0.5;
    self.meterTF.alpha = 0.5;
    self.moneyTF.alpha = 0.5;
    self.totalTF.alpha = 0.5;
    self.salesmanTF.alpha = 0.5;
    self.techniqueTF.alpha = 0.5;
    self.otherTF.alpha = 0.5;
    self.meritLab.alpha = 0.5;
    self.meritBtn.alpha = 0.5;
    self.textView.alpha = 0.5;
    self.confirmBtn.alpha = 0.5;
    if ([self.meritLab.text isEqualToString:@"请选择"]) {
        self.meritLab.textColor = COLOR_333333;
    }
}

#pragma mark ------ 取消编辑 ------
- (void)cancleEditing {
    [self endEditing:YES];
}

#pragma mark ------ 懒加载 ------
- (NSMutableArray *)provinceArr {
    if (_provinceArr == nil) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        _provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return _provinceArr;
}

@end
