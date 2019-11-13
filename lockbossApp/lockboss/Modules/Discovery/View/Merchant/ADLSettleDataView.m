//
//  ADLSettleDataView.m
//  lockboss
//
//  Created by Han on 2019/6/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "ADLSettleDataView.h"
#import "ADLLocalImgPreView.h"
#import "ADLAddressPickerView.h"
#import "ADLSelectDateView.h"
#import "ADLImagePreView.h"
#import "ADLGlobalDefine.h"
#import "ADLAttachView.h"
#import "ADLModifyView.h"
#import "ADLApiDefine.h"
#import "ADLToast.h"
#import "ADLUtils.h"

@interface ADLSettleDataView ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *provinceArr;
@end

@implementation ADLSettleDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.licenseType = 999;
    self.documentType = 999;
    self.updateOffset = YES;
    self.submitBtn.layer.cornerRadius = CORNER_RADIUS;
    
    self.contactNameTF.delegate = self;
    self.contactPhoneTF.delegate = self;
    self.contactEmailTF.delegate = self;
    self.companyNameTF.delegate = self;
    self.creditCodeTF.delegate = self;
    self.licenseAddressTF.delegate = self;
    self.registerMoneyTF.delegate = self;
    self.brandTF.delegate = self;
    self.cropNameTF.delegate = self;
    self.cropIdNumTF.delegate = self;
    self.companyAddressTF.delegate = self;
    self.companyPhoneTF.delegate = self;
    self.personNameTF.delegate = self;
    self.personPhoneTF.delegate = self;
    self.bankNumberTF.delegate = self;
    self.rangeTV.delegate = self;
    
    self.licenseImgBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.idImgBtn1.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.idImgBtn2.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.bankImgBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleEditing)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *licenseLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLicenseTypeLab)];
    [self.licenseTypeLab addGestureRecognizer:licenseLabTap];
    
    UITapGestureRecognizer *licenseImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLicenseImageView)];
    [self.licenseImgView addGestureRecognizer:licenseImgTap];
    
    UITapGestureRecognizer *licenseAreaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLicenseAreaLab)];
    [self.licenseAreaLab addGestureRecognizer:licenseAreaTap];
    
    UITapGestureRecognizer *establishDateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCompanyEstablishDateLab)];
    [self.establishDateLab addGestureRecognizer:establishDateTap];
    
    UITapGestureRecognizer *openDueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOpenDueLab)];
    [self.openDueLab addGestureRecognizer:openDueTap];
    
    UITapGestureRecognizer *idTypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIdTypeLab)];
    [self.idTypeLab addGestureRecognizer:idTypeTap];
    
    UITapGestureRecognizer *idImgView1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIdImageView1)];
    [self.idImgView1 addGestureRecognizer:idImgView1Tap];
    
    UITapGestureRecognizer *idImgView2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIdImageView2)];
    [self.idImgView2 addGestureRecognizer:idImgView2Tap];
    
    UITapGestureRecognizer *effectDateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCropEffectDateLab)];
    [self.cropEffectDateLab addGestureRecognizer:effectDateTap];
    
    UITapGestureRecognizer *companyAreaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCompanyAreaLab)];
    [self.companyAreaLab addGestureRecognizer:companyAreaTap];
    
    UITapGestureRecognizer *bankImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBankImgView)];
    [self.bankImgView addGestureRecognizer:bankImgTap];
}

#pragma mark ------ 开始编辑 ------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:textField];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:textView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        if (textField.tag == 3) {
            return [ADLUtils numberTextField:textField replacementString:string maxLength:19 firstZero:YES];
        } else if (textField.tag == 6) {
            return [ADLUtils numberTextField:textField replacementString:string maxLength:5 firstZero:NO];
        } else if (textField.tag == 9) {
            return [ADLUtils phoneTextField:textField replacementString:string];
        } else {
            return YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0) {
        self.rangePlaceholder.text = @"";
    } else {
        self.rangePlaceholder.text = @"请输入经营范围";
    }
}

#pragma mark ------ 退出编辑 ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------ 修改手机号 ------
- (IBAction)clickModifyPhoneBtn:(UIButton *)sender {
    ///dataDict字段 title-标题 placeholder-提示文字  code-获取验证码地址 key-获取验证码参数key path-提交地址 param-参数字典input-code
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"修改联系人手机号" forKey:@"title"];
    [dict setValue:@"请输入联系人手机号" forKey:@"placeholder"];
    [dict setValue:k_send_msg_code forKey:@"code"];
    [dict setValue:@"phoneNumber" forKey:@"key"];
    [dict setValue:k_settle_modify_phone forKey:@"path"];
    [dict setValue:@{@"input":@"phone",@"code":@"code",@"id":self.settleId} forKey:@"param"];
    [ADLModifyView modifyViewWithType:ADLModifyTypePhone dataDict:dict confirmAction:^(NSString *input) {
        if (input) {
            self.contactPhoneTF.text = input;
        }
    }];
}

#pragma mark ------ 修改邮箱 ------
- (IBAction)clickModifyEmailBtn:(UIButton *)sender {
    ///dataDict字段 title-标题 placeholder-提示文字  code-获取验证码地址 key-获取验证码参数key path-提交地址 param-参数字典input-code
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"修改联系人邮箱" forKey:@"title"];
    [dict setValue:@"请输入联系人邮箱" forKey:@"placeholder"];
    [dict setValue:k_send_email_code forKey:@"code"];
    [dict setValue:@"email" forKey:@"key"];
    [dict setValue:k_settle_modify_email forKey:@"path"];
    [dict setValue:@{@"input":@"email",@"code":@"code",@"id":self.settleId} forKey:@"param"];
    [ADLModifyView modifyViewWithType:ADLModifyTypeEmail dataDict:dict confirmAction:^(NSString *input) {
        if (input) {
            self.contactEmailTF.text = input;
        }
    }];
}

#pragma mark ------ 营业执照类型 ------
- (void)clickLicenseTypeLab {
    [self clickLicenseType];
}

- (IBAction)clickLicenseTypeBtn:(UIButton *)sender {
    [self clickLicenseType];
}

- (void)clickLicenseType {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.licenseTypeBtn.superview convertRect:self.licenseTypeBtn.frame toView:window];
    NSArray *titArr = @[@"普通营业执照",@"多证合一营业执照（统一社会信用代码）",@"多证合一营业执照（非统一社会信用代码）"];
    [UIView animateWithDuration:0.3 animations:^{
        self.licenseTypeBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(110, frame.origin.y+frame.size.height, SCREEN_WIDTH-110, 132) titleArr:titArr finish:^(NSInteger index) {
        if (index != -1) {
            self.licenseType = index;
            self.licenseTypeLab.textColor = COLOR_333333;
            self.licenseTypeLab.text = titArr[index];
        }
        self.updateOffset = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.licenseTypeBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 点击营业执照图片 ------
- (void)clickLicenseImageView {
    [self endEditing:YES];
    if (self.licenseImgBtn.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClikImageViewWithIndex:)]) {
            [self.delegate didClikImageViewWithIndex:0];
        }
    } else {
        if (self.licenseImageUrl) {
            [ADLImagePreView showWithImageViews:@[self.licenseImgView] urlArray:@[self.licenseImageUrl] currentIndex:0];
        } else {
            [ADLLocalImgPreView showWithImageViews:@[self.licenseImgView] currentIndex:0];
        }
    }
}

#pragma mark ------ 删除营业执照图片 ------
- (IBAction)clickDeleteLicenseImgBtn:(UIButton *)sender {
    sender.hidden = YES;
    self.licenseImage = nil;
    self.licenseImageUrl = nil;
    self.licenseImgView.image = [UIImage imageNamed:@"img_upload"];
}

#pragma mark ------ 营业执照所在地 ------
- (void)clickLicenseAreaLab {
    [self clickSelectLicenseArea];
}

- (IBAction)clickLicenseAreaBtn:(UIButton *)sender {
    [self clickSelectLicenseArea];
}

- (void)clickSelectLicenseArea {
    [self endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
        self.licenseAreaLab.textColor = COLOR_333333;
        self.licenseAreaLab.text = address;
        self.licenseAreaId = addressId;
    }];
}

#pragma mark ------ 成立日期 ------
- (void)clickCompanyEstablishDateLab {
    [self clickCompanyEstablishDate];
}

- (IBAction)clickEstablishDateBtn:(UIButton *)sender {
    [self clickCompanyEstablishDate];
}

- (void)clickCompanyEstablishDate {
    [self endEditing:YES];
    [ADLSelectDateView showWithTitle:@"成立日期" period:NO longterm:NO posterior:NO finish:^(NSString *dateStr) {
        self.establishDateLab.textColor = COLOR_333333;
        self.establishDateLab.text = dateStr;
        self.createTime = dateStr;
    }];
}

#pragma mark ------ 营业期限 ------
- (void)clickOpenDueLab {
    [self clickOpenDueDate];
}

- (IBAction)clickOpenDueBtn:(UIButton *)sender {
    [self clickOpenDueDate];
}

- (void)clickOpenDueDate {
    [self endEditing:YES];
    [ADLSelectDateView showWithTitle:@"营业期限" period:YES longterm:YES posterior:NO finish:^(NSString *dateStr) {
        NSArray *dateArr = [dateStr componentsSeparatedByString:@","];
        self.licenseStartTime = dateArr.firstObject;
        if ([dateArr.lastObject isEqualToString:@"长期"]) {
            NSArray *endArr = [self.licenseStartTime componentsSeparatedByString:@"-"];
            self.licenseEndTime = [NSString stringWithFormat:@"%ld-%@-%@",[endArr.firstObject integerValue]+100,endArr[1],endArr.lastObject];
        } else {
            self.licenseEndTime = dateArr.firstObject;
        }
        self.openDueLab.textColor = COLOR_333333;
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        self.openDueLab.text = dateStr;
    }];
}

#pragma mark ------ 证件类型 ------
- (void)clickIdTypeLab {
    [self clickIdType];
}

- (IBAction)clickIdTypeBtn:(UIButton *)sender {
    [self clickIdType];
}

- (void)clickIdType {
    self.updateOffset = NO;
    [self endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self.idTypeBtn.superview convertRect:self.idTypeBtn.frame toView:window];
    NSArray *titArr = @[@"大陆身份证",@"港澳通行证",@"台湾居民通行证",@"护照"];
    [UIView animateWithDuration:0.3 animations:^{
        self.idTypeBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:CGRectMake(150, frame.origin.y+frame.size.height, SCREEN_WIDTH-150, 176) titleArr:titArr finish:^(NSInteger index) {
        if (index != -1) {
            self.documentType = index;
            self.idTypeLab.textColor = COLOR_333333;
            self.idTypeLab.text = titArr[index];
        }
        self.updateOffset = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.idTypeBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 身份证照片1 ------
- (void)clickIdImageView1 {
    [self endEditing:YES];
    if (self.idImgBtn1.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClikImageViewWithIndex:)]) {
            [self.delegate didClikImageViewWithIndex:1];
        }
    } else {
        if (self.idImage1Url) {
            [ADLImagePreView showWithImageViews:@[self.idImgView1] urlArray:@[self.idImage1Url] currentIndex:0];
        } else {
            [ADLLocalImgPreView showWithImageViews:@[self.idImgView1] currentIndex:0];
        }
    }
}

#pragma mark ------ 删除第一张证件照 ------
- (IBAction)clickDeleteIdImg1Btn:(UIButton *)sender {
    if (self.idImgBtn2.hidden) {
        sender.hidden = YES;
        self.idImage1 = nil;
        self.idImage1Url = nil;
        self.idImgView1.image = [UIImage imageNamed:@"img_upload"];
        self.idImgView2.hidden = YES;
    } else {
        self.idImage1 = [self.idImage2 copy];
        self.idImage1Url = [self.idImage2Url copy];
        self.idImgView1.image = [self.idImgView2.image copy];
        
        self.idImage2 = nil;
        self.idImage2Url = nil;
        self.idImgBtn2.hidden = YES;
        self.idImgView2.image = [UIImage imageNamed:@"img_upload"];
    }
}

#pragma mark ------ 身份证照片2 ------
- (void)clickIdImageView2 {
    [self endEditing:YES];
    if (self.idImgBtn2.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClikImageViewWithIndex:)]) {
            [self.delegate didClikImageViewWithIndex:2];
        }
    } else {
        if (self.idImage2Url) {
            [ADLImagePreView showWithImageViews:@[self.idImgView2] urlArray:@[self.idImage2Url] currentIndex:0];
        } else {
            [ADLLocalImgPreView showWithImageViews:@[self.idImgView2] currentIndex:0];
        }
    }
}

#pragma mark ------ 删除第二张证件照 ------
- (IBAction)clickDeleteIdImg2Btn:(UIButton *)sender {
    sender.hidden = YES;
    self.idImage2 = nil;
    self.idImage2Url = nil;
    self.idImgView2.image = [UIImage imageNamed:@"img_upload"];
}

#pragma mark ------ 证件有效期 ------
- (void)clickCropEffectDateLab {
    [self clickCropEffectDate];
}

- (IBAction)clickCropEffectDateBtn:(UIButton *)sender {
    [self clickCropEffectDate];
}

- (void)clickCropEffectDate {
    [self endEditing:YES];
    [ADLSelectDateView showWithTitle:@"证件有效期" period:YES longterm:YES posterior:NO finish:^(NSString *dateStr) {
        NSArray *dateArr = [dateStr componentsSeparatedByString:@","];
        self.legalPersonStartTime = dateArr.firstObject;
        if ([dateArr.lastObject isEqualToString:@"长期"]) {
            NSArray *endArr = [self.legalPersonStartTime componentsSeparatedByString:@"-"];
            self.legalPersonEndTime = [NSString stringWithFormat:@"%ld-%@-%@",[endArr.firstObject integerValue]+100,endArr[1],endArr.lastObject];
        } else {
            self.legalPersonEndTime = dateArr.lastObject;
        }
        self.cropEffectDateLab.textColor = COLOR_333333;
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        self.cropEffectDateLab.text = dateStr;
    }];
}

#pragma mark ------ 公司所在地 ------
- (void)clickCompanyAreaLab {
    [self clickCompanyArea];
}

- (IBAction)clickCompanyAreaBtn:(UIButton *)sender {
    [self clickCompanyArea];
}

- (void)clickCompanyArea {
    [self endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
        self.companyAreaLab.textColor = COLOR_333333;
        self.companyAreaLab.text = address;
        self.companyAreaId = addressId;
    }];
}

#pragma mark ------ 银行开户许可证图片 ------
- (void)clickBankImgView {
    [self endEditing:YES];
    if (self.bankImgBtn.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClikImageViewWithIndex:)]) {
            [self.delegate didClikImageViewWithIndex:3];
        }
    } else {
        if (self.bankImageUrl) {
            [ADLImagePreView showWithImageViews:@[self.bankImgView] urlArray:@[self.bankImageUrl] currentIndex:0];
        } else {
            [ADLLocalImgPreView showWithImageViews:@[self.bankImgView] currentIndex:0];
        }
    }
}

#pragma mark ------ 删除开户许可证图片 ------
- (IBAction)clickDeleteBankImgBtn:(UIButton *)sender {
    sender.hidden = YES;
    self.bankImage = nil;
    self.bankImageUrl = nil;
    self.bankImgView.image = [UIImage imageNamed:@"img_upload"];
}

#pragma mark ------ 提交 ------
- (IBAction)clickSubmitBtn:(UIButton *)sender {
    if (self.contactNameTF.text.length == 0) {
        [ADLToast showMessage:@"请输入联系人姓名"];
        return;
    }
    if (self.contactPhoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入联系人手机号"];
        return;
    }
    if (self.contactEmailTF.text.length == 0) {
        [ADLToast showMessage:@"请输入联系人邮箱"];
        return;
    }
    if (![ADLUtils verifyEmailAddress:self.contactEmailTF.text]) {
        [ADLToast showMessage:@"请输入正确的邮箱"];
        return;
    }
    if (self.licenseType == 999) {
        [ADLToast showMessage:@"请选择执照类型"];
        return;
    }
    if (self.licenseImgBtn.hidden) {
        [ADLToast showMessage:@"请选择营业执照图片"];
        return;
    }
    if (self.companyNameTF.text.length == 0) {
        [ADLToast showMessage:@"请输入公司名称"];
        return;
    }
    if (self.creditCodeTF.text.length == 0) {
        [ADLToast showMessage:@"请输入统一社会信用代码"];
        return;
    }
    if (self.licenseAreaId.length == 0) {
        [ADLToast showMessage:@"请选择营业执照所在地"];
        return;
    }
    if (self.licenseAddressTF.text.length == 0) {
        [ADLToast showMessage:@"请输入营业执照详细地址"];
        return;
    }
    if (self.createTime.length == 0) {
        [ADLToast showMessage:@"请选择成立日期"];
        return;
    }
    if (self.licenseStartTime.length == 0) {
        [ADLToast showMessage:@"请选择营业期限"];
        return;
    }
    if (self.registerMoneyTF.text.length == 0) {
        [ADLToast showMessage:@"请输入注册资本"];
        return;
    }
    if (self.rangeTV.text.length == 0) {
        [ADLToast showMessage:@"请输入经营范围"];
        return;
    }
    if ([ADLUtils hasEmoji:self.rangeTV.text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    if (self.brandTF.text.length == 0) {
        [ADLToast showMessage:@"请输入品牌名称"];
        return;
    }
    if (self.documentType == 999) {
        [ADLToast showMessage:@"请选择证件类型"];
        return;
    }
    if (self.idImgBtn1.hidden || self.idImgBtn2.hidden) {
        [ADLToast showMessage:@"请选择法人证件正反面照"];
        return;
    }
    if (self.cropNameTF.text.length == 0) {
        [ADLToast showMessage:@"请输入法定代表人姓名"];
        return;
    }
    if (self.cropIdNumTF.text.length == 0) {
        [ADLToast showMessage:@"请输入法定代表人证件号"];
        return;
    }
    if (self.legalPersonStartTime.length == 0) {
        [ADLToast showMessage:@"请选择证件有效期"];
        return;
    }
    if (self.companyAreaId.length == 0) {
        [ADLToast showMessage:@"请选择公司所在地"];
        return;
    }
    if (self.companyAddressTF.text.length == 0) {
        [ADLToast showMessage:@"请输入公司详细地址"];
        return;
    }
    if (self.companyPhoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入公司电话"];
        return;
    }
    if (self.personNameTF.text.length == 0) {
        [ADLToast showMessage:@"请输入紧急联系人姓名"];
        return;
    }
    if (self.personPhoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入紧急联系人手机号"];
        return;
    }
    if (self.bankImgBtn.hidden) {
        [ADLToast showMessage:@"请选择银行开户许可证图片"];
        return;
    }
    if (self.bankNumberTF.text.length == 0) {
        [ADLToast showMessage:@"请输入银行账号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.contactPhoneTF.text forKey:@"contactsPhone"];
    [params setValue:self.contactNameTF.text forKey:@"contactsName"];
    [params setValue:self.contactEmailTF.text forKey:@"contactsEmail"];
    [params setValue:@(self.licenseType) forKey:@"licenseType"];
    [params setValue:self.companyNameTF.text forKey:@"companyName"];
    [params setValue:self.creditCodeTF.text forKey:@"licenseRegisterNumber"];
    [params setValue:self.licenseAreaId forKey:@"licenseAreaId"];
    [params setValue:self.licenseAddressTF.text forKey:@"licenseDetailAddress"];
    [params setValue:self.createTime forKey:@"createTime"];
    [params setValue:self.licenseStartTime forKey:@"licenseStartTime"];
    [params setValue:self.licenseEndTime forKey:@"licenseEndTime"];
    [params setValue:self.registerMoneyTF.text forKey:@"licenseCapital"];
    [params setValue:self.rangeTV.text forKey:@"operationScope"];
    [params setValue:self.brandTF.text forKey:@"brand"];
    [params setValue:@(self.documentType) forKey:@"documentType"];
    [params setValue:self.cropNameTF.text forKey:@"legalPersonName"];
    [params setValue:self.cropIdNumTF.text forKey:@"legalPersonCardNumber"];
    [params setValue:self.legalPersonStartTime forKey:@"legalPersonStartTime"];
    [params setValue:self.legalPersonEndTime forKey:@"legalPersonEndTime"];
    [params setValue:self.companyAreaId forKey:@"companyAreaId"];
    [params setValue:self.companyAddressTF.text forKey:@"companyDetailAddress"];
    [params setValue:self.companyPhoneTF.text forKey:@"companyPhone"];
    [params setValue:self.personNameTF.text forKey:@"companyUrgentContacts"];
    [params setValue:self.personPhoneTF.text forKey:@"companyUrgentPhone"];
    [params setValue:self.bankNumberTF.text forKey:@"bankNumber"];
    if (self.licenseImageUrl) {
        [params setValue:self.licenseImageUrl forKey:@"licenseImgUrl"];
    }
    if (self.idImage1Url) {
        [params setValue:self.idImage1Url forKey:@"documentBefore"];
    }
    if (self.idImage2Url) {
        [params setValue:self.idImage2Url forKey:@"documentBack"];
    }
    if (self.bankImageUrl) {
        [params setValue:self.bankImageUrl forKey:@"bankLicence"];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSubmitBtn:)]) {
        [self.delegate didClickSubmitBtn:params];
    }
}

#pragma mark ------ 更新输入内容 ------
- (void)updateInputViewWithDictionary:(NSDictionary *)dict {
    self.contactPhoneTF.text = dict[@"contactsPhone"];
    self.contactNameTF.text = dict[@"contactsName"];
    self.contactEmailTF.text = dict[@"contactsEmail"];
    self.licenseType = [dict[@"licenseType"] integerValue];
    self.licenseTypeLab.textColor = COLOR_333333;
    if (self.licenseType == 0) {
        self.licenseTypeLab.text = @"普通营业执照";
    } else if (self.licenseType == 1) {
        self.licenseTypeLab.text = @"多证合一营业执照（统一社会信用代码）";
    } else {
        self.licenseTypeLab.text = @"多证合一营业执照（非统一社会信用代码）";
    }
    
    self.companyNameTF.text = dict[@"companyName"];
    self.creditCodeTF.text = dict[@"licenseRegisterNumber"];
    self.licenseAreaId = [dict[@"licenseAreaId"] stringValue];
    self.licenseAreaLab.textColor = COLOR_333333;
    self.licenseAreaLab.text = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:self.licenseAreaId].address;
    
    self.licenseAddressTF.text = dict[@"licenseDetailAddress"];
    self.createTime = [ADLUtils getDateFromTimestamp:[dict[@"createTime"] doubleValue] format:@"yyyy-MM-dd"];
    self.establishDateLab.textColor = COLOR_333333;
    self.establishDateLab.text = self.createTime;
    
    self.licenseStartTime = [ADLUtils getDateFromTimestamp:[dict[@"licenseStartTime"] doubleValue] format:@"yyyy-MM-dd"];
    self.licenseEndTime = [ADLUtils getDateFromTimestamp:[dict[@"licenseEndTime"] doubleValue] format:@"yyyy-MM-dd"];
    self.openDueLab.textColor = COLOR_333333;
    NSString *licenseStartStr = [self.licenseStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSInteger startY = [[licenseStartStr componentsSeparatedByString:@"."].firstObject integerValue];
    NSInteger endY = [[self.licenseEndTime componentsSeparatedByString:@"-"].firstObject integerValue];
    if (endY-startY == 100) {
        self.openDueLab.text = [NSString stringWithFormat:@"%@-长期",licenseStartStr];
    } else {
        NSString *licenseEndStr = [self.licenseEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.openDueLab.text = [NSString stringWithFormat:@"%@-%@",licenseStartStr,licenseEndStr];
    }
    
    self.registerMoneyTF.text = [dict[@"licenseCapital"] stringValue];
    self.rangeTV.text = dict[@"operationScope"];
    self.rangePlaceholder.text = @"";
    self.brandTF.text = dict[@"brand"];
    
    self.documentType = [dict[@"documentType"] integerValue];
    self.idTypeLab.textColor = COLOR_333333;
    if (self.documentType == 0) {
        self.idTypeLab.text = @"大陆身份证";
    } else if (self.documentType == 1) {
        self.idTypeLab.text = @"港澳通行证";
    } else if (self.documentType == 2) {
        self.idTypeLab.text = @"台湾居民通行证";
    } else {
        self.idTypeLab.text = @"护照";
    }
    
    self.cropNameTF.text = dict[@"legalPersonName"];
    self.cropIdNumTF.text = dict[@"legalPersonCardNumber"];
    
    self.legalPersonStartTime = [ADLUtils getDateFromTimestamp:[dict[@"legalPersonStartTime"] doubleValue] format:@"yyyy-MM-dd"];
    self.legalPersonEndTime = [ADLUtils getDateFromTimestamp:[dict[@"legalPersonEndTime"] doubleValue] format:@"yyyy-MM-dd"];
    self.cropEffectDateLab.textColor = COLOR_333333;
    NSString *legalPersonStartStr = [self.legalPersonStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSInteger lstartY = [[legalPersonStartStr componentsSeparatedByString:@"."].firstObject integerValue];
    NSInteger lendY = [[self.legalPersonEndTime componentsSeparatedByString:@"-"].firstObject integerValue];
    if (lendY-lstartY == 100) {
        self.cropEffectDateLab.text = [NSString stringWithFormat:@"%@-长期",legalPersonStartStr];
    } else {
        NSString *legalPersonEndStr = [self.legalPersonEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.cropEffectDateLab.text = [NSString stringWithFormat:@"%@-%@",legalPersonStartStr,legalPersonEndStr];
    }
    
    self.companyAreaId = [dict[@"companyAreaId"] stringValue];
    self.companyAreaLab.textColor = COLOR_333333;
    self.companyAreaLab.text = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:self.companyAreaId].address;
    
    self.companyAddressTF.text = dict[@"companyDetailAddress"];
    self.companyPhoneTF.text = dict[@"companyPhone"];
    self.personNameTF.text = dict[@"companyUrgentContacts"];
    self.personPhoneTF.text = dict[@"companyUrgentPhone"];
    self.bankNumberTF.text = dict[@"bankNumber"];
    
    self.licenseImageUrl = dict[@"licenseImgUrl"];
    self.idImage1Url = dict[@"documentBefore"];
    self.idImage2Url = dict[@"documentBack"];
    self.bankImageUrl = dict[@"bankLicence"];
    
    [self.licenseImgView sd_setImageWithURL:[NSURL URLWithString:self.licenseImageUrl] placeholderImage:[UIImage imageNamed:@"img_rectangle"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.licenseImgBtn.hidden = NO;
    }];
    
    [self.idImgView1 sd_setImageWithURL:[NSURL URLWithString:self.idImage1Url] placeholderImage:[UIImage imageNamed:@"img_rectangle"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.idImgBtn1.hidden = NO;
    }];
    
    self.idImgView2.hidden = NO;
    [self.idImgView2 sd_setImageWithURL:[NSURL URLWithString:self.idImage2Url] placeholderImage:[UIImage imageNamed:@"img_rectangle"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.idImgBtn2.hidden = NO;
    }];
    
    [self.bankImgView sd_setImageWithURL:[NSURL URLWithString:self.bankImageUrl] placeholderImage:[UIImage imageNamed:@"img_rectangle"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.bankImgBtn.hidden = NO;
    }];
}

#pragma mark ------ 设置不可编辑 ------
- (void)setInputViewUneditable {
    self.contactPhoneTF.enabled = NO;
    self.contactNameTF.enabled = NO;
    self.contactEmailTF.enabled = NO;
    
    self.licenseTypeLab.userInteractionEnabled = NO;
    self.licenseTypeBtn.enabled = NO;
    self.companyNameTF.enabled = NO;
    self.creditCodeTF.enabled = NO;
    self.licenseAreaLab.userInteractionEnabled = NO;
    self.licenseAreaBtn.enabled = NO;
    self.licenseAddressTF.enabled = NO;
    self.establishDateLab.userInteractionEnabled = NO;
    self.establishDateBtn.enabled = NO;
    self.openDueLab.userInteractionEnabled = NO;
    self.openDueBtn.enabled = NO;
    self.registerMoneyTF.enabled = NO;
    self.rangeTV.userInteractionEnabled = NO;
    self.brandTF.enabled = NO;
    
    self.idTypeLab.userInteractionEnabled = NO;
    self.idTypeBtn.enabled = NO;
    self.cropNameTF.enabled = NO;
    self.cropIdNumTF.enabled = NO;
    self.cropEffectDateLab.userInteractionEnabled = NO;
    self.cropEffectDateBtn.enabled = NO;
    self.companyAreaLab.userInteractionEnabled = NO;
    self.companyAreaBtn.enabled = NO;
    self.companyAddressTF.enabled = NO;
    self.companyPhoneTF.enabled = NO;
    self.personNameTF.enabled = NO;
    self.personPhoneTF.enabled = NO;
    self.bankNumberTF.enabled = NO;
    self.submitBtn.enabled = NO;
    
    self.licenseImgView.userInteractionEnabled = NO;
    self.idImgView1.userInteractionEnabled = NO;
    self.idImgView2.userInteractionEnabled = NO;
    self.bankImgView.userInteractionEnabled = NO;
    [self.licenseImgBtn removeFromSuperview];
    [self.idImgBtn1 removeFromSuperview];
    [self.idImgBtn2 removeFromSuperview];
    [self.bankImgBtn removeFromSuperview];
    
    self.contactPhoneTF.alpha = 0.5;
    self.contactNameTF.alpha = 0.5;
    self.contactEmailTF.alpha = 0.5;
    
    self.licenseTypeLab.alpha = 0.5;
    self.licenseTypeBtn.alpha = 0.5;
    self.companyNameTF.alpha = 0.5;
    self.creditCodeTF.alpha = 0.5;
    self.licenseAreaLab.alpha = 0.5;
    self.licenseAreaBtn.alpha = 0.5;
    self.licenseAddressTF.alpha = 0.5;
    self.establishDateLab.alpha = 0.5;
    self.establishDateBtn.alpha = 0.5;
    self.openDueLab.alpha = 0.5;
    self.openDueBtn.alpha = 0.5;
    self.registerMoneyTF.alpha = 0.5;
    self.rangeTV.alpha = 0.5;
    self.brandTF.alpha = 0.5;
    
    self.idTypeLab.alpha = 0.5;
    self.idTypeBtn.alpha = 0.5;
    self.cropNameTF.alpha = 0.5;
    self.cropIdNumTF.alpha = 0.5;
    self.cropEffectDateLab.alpha = 0.5;
    self.cropEffectDateBtn.alpha = 0.5;
    self.companyAreaLab.alpha = 0.5;
    self.companyAreaBtn.alpha = 0.5;
    self.companyAddressTF.alpha = 0.5;
    self.companyPhoneTF.alpha = 0.5;
    self.personNameTF.alpha = 0.5;
    self.personPhoneTF.alpha = 0.5;
    self.bankNumberTF.alpha = 0.5;
    self.submitBtn.alpha = 0.5;
    
    self.licenseImgView.alpha = 0.5;
    self.idImgView1.alpha = 0.5;
    self.idImgView2.alpha = 0.5;
    self.bankImgView.alpha = 0.5;
}

#pragma mark ------ 退出编辑 ------
- (void)cancleEditing {
    [self endEditing:YES];
}

#pragma mark ------ 地区数据 ------
- (NSMutableArray *)provinceArr {
    if (_provinceArr == nil) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        _provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return _provinceArr;
}

@end
