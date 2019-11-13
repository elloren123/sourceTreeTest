//
//  ADLAddInvoiceController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAddInvoiceController.h"
#import "ADLLookInvoiceController.h"

@interface ADLAddInvoiceController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *bankTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNumTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) NSString *invoiceId;
@end
@implementation ADLAddInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"添加增票资质"];
    self.cellH.constant = ROW_HEIGHT;
    self.backH.constant = ROW_HEIGHT*6+3;
    self.topH.constant = NAVIGATION_H;
    self.btnH.constant = VIEW_HEIGHT;
    [self checkInvoice];
}

#pragma mark ------ 查询增票资质 ------
- (void)checkInvoice {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_qualification parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.companyTF.text = responseDict[@"data"][@"companyName"];
            self.numberTF.text = responseDict[@"data"][@"taxpayerId"];
            self.addressTF.text = responseDict[@"data"][@"address"];
            self.phoneTF.text = responseDict[@"data"][@"phone"];
            self.bankTF.text = responseDict[@"data"][@"depositBank"];
            self.bankNumTF.text = responseDict[@"data"][@"bankAccount"];
            self.invoiceId = responseDict[@"data"][@"id"];
            if (self.invoiceId.length > 3) {
                self.titleLab.text = @"修改增票资质";
                [self.confirmBtn setTitle:@"修改" forState:UIControlStateNormal];
            }
        }
    } failure:nil];
}

#pragma mark ------ 提交 ------
- (IBAction)clickConfirmBtn:(UIButton *)sender {
    if ([self checkInput]) {
        [self.view endEditing:YES];
        sender.enabled = NO;
        NSString *path = k_add_qualification;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.companyTF.text forKey:@"companyName"];
        [params setValue:self.numberTF.text forKey:@"taxpayerId"];
        [params setValue:self.addressTF.text forKey:@"address"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:self.bankTF.text forKey:@"depositBank"];
        [params setValue:self.bankNumTF.text forKey:@"bankAccount"];
        if (self.invoiceId.length > 3) {
            [params setValue:self.invoiceId forKey:@"id"];
            path = k_modify_qualification;
        }
        
        [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                if (self.invoiceId.length > 3) {
                    [ADLToast showMessage:@"修改成功"];
                } else {
                    [ADLToast showMessage:@"添加成功"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    }
}

#pragma mark ------ CheckBox ------
- (IBAction)clickCheckBoxBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark ------ 查看增票资质确认书 ------
- (IBAction)clickLookBtn:(UIButton *)sender {
    [self.navigationController pushViewController:[ADLLookInvoiceController new] animated:YES];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.companyTF) {
        [self.numberTF becomeFirstResponder];
    } else if (textField == self.numberTF) {
        [self.addressTF becomeFirstResponder];
    } else if (textField == self.addressTF) {
        [self.phoneTF becomeFirstResponder];
    } else if (textField == self.phoneTF) {
        [self.bankTF becomeFirstResponder];
    } else if (textField == self.bankTF) {
        [self.bankNumTF becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTF) {
        return [ADLUtils phoneTextField:textField replacementString:string];
    }
    return YES;
}

#pragma mark ------ 检查输入 ------
- (BOOL)checkInput {
    if (self.companyTF.text.length == 0) {
        [ADLToast showMessage:@"请输入单位名称"];
        return NO;
    }
    if (self.numberTF.text.length == 0) {
        [ADLToast showMessage:@"请输入纳税人识别号"];
        return NO;
    }
    if (self.addressTF.text.length == 0) {
        [ADLToast showMessage:@"请输入注册地址"];
        return NO;
    }
    if (self.phoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入注册电话"];
        return NO;
    }
    if (self.bankTF.text.length == 0) {
        [ADLToast showMessage:@"请输入开户银行"];
        return NO;
    }
    if (self.bankNumTF.text.length == 0) {
        [ADLToast showMessage:@"请输入银行账户"];
        return NO;
    }
    if (!self.checkBtn.selected) {
        [ADLToast showMessage:@"请勾选增票资质确认书"];
        return NO;
    }
    
    if ([ADLUtils hasEmoji:self.companyTF.text] ||
        [ADLUtils hasEmoji:self.numberTF.text] ||
        [ADLUtils hasEmoji:self.addressTF.text] ||
        [ADLUtils hasEmoji:self.bankTF.text] ||
        [ADLUtils hasEmoji:self.bankNumTF.text]) {
        
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
