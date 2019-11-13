//
//  ADLMerchantPayView.m
//  lockboss
//
//  Created by adel on 2019/6/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMerchantPayView.h"
#import "ADLUtils.h"

@interface ADLMerchantPayView ()<UITextFieldDelegate>

@end

@implementation ADLMerchantPayView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dueTF.delegate = self;
    self.wechatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    self.alipayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.dueTF addTarget:self action:@selector(textFieldTextDidfChanged:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleEditing)];
    [self addGestureRecognizer:tap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [ADLUtils numberTextField:textField replacementString:string maxLength:5 firstZero:NO];
}

- (void)textFieldTextDidfChanged:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contractPeriodDidChanged:)]) {
        [self.delegate contractPeriodDidChanged:[textField.text integerValue]];
    }
}

- (IBAction)clickWechatBtn:(UIButton *)sender {
    sender.selected = YES;
    self.alipayBtn.selected = NO;
    sender.userInteractionEnabled = NO;
    self.alipayBtn.userInteractionEnabled = YES;
}

- (IBAction)clickAlipayBtn:(UIButton *)sender {
    sender.selected = YES;
    self.wechatBtn.selected = NO;
    sender.userInteractionEnabled = NO;
    self.wechatBtn.userInteractionEnabled = YES;
}

- (IBAction)clickPayBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPayBtn:)]) {
        [self.delegate didClickPayBtn:sender];
    }
}

- (void)cancleEditing {
    if ([self.dueTF isFirstResponder]) {
        [self.dueTF resignFirstResponder];
    }
}

@end
