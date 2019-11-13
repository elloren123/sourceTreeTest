//
//  ADLGoodsEvaReplyView.m
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsEvaReplyView.h"

@interface ADLGoodsEvaReplyView ()<UITextFieldDelegate>

@end

@implementation ADLGoodsEvaReplyView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 3;
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.clickSendBtn) {
        self.clickSendBtn(textField);
    }
    return YES;
}

- (IBAction)clickPraiseBtn:(UIButton *)sender {
    if (self.clickPraiseBtn) {
        self.clickPraiseBtn();
    }
}

@end
