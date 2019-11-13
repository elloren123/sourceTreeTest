//
//  ADLSearchView.m
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchView.h"
#import "ADLGlobalDefine.h"
#import "ADLLocalizedHelper.h"

@interface ADLSearchView ()<UITextFieldDelegate>

@end

@implementation ADLSearchView

+ (instancetype)searchViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder instant:(BOOL)instant {
    return [[self alloc] initWithFrame:frame placeholder:placeholder instant:instant];
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder instant:(BOOL)instant {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViewWithPlaceholder:placeholder instant:instant];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)setupViewWithPlaceholder:(NSString *)placeholder instant:(BOOL)instant {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height-STATUS_HEIGHT;
    
    CGFloat btnW = 55;
    if ([[ADLLocalizedHelper helper].currentLanguage isEqualToString:@"en"]) btnW = 73;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, STATUS_HEIGHT+6, wid-btnW-12, hei-12)];
    bgView.backgroundColor = COLOR_F2F2F2;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    UIImageView *sImgView = [[UIImageView alloc] initWithFrame:CGRectMake(22, STATUS_HEIGHT+(hei-16)/2, 16, 16)];
    sImgView.image = [UIImage imageNamed:@"home_search"];
    [self addSubview:sImgView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, STATUS_HEIGHT+10, wid-btnW-53, hei-20)];
    textField.placeholder = placeholder;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:FONT_SIZE];
    textField.textColor = COLOR_333333;
    [textField becomeFirstResponder];
    [self addSubview:textField];
    self.textField = textField;
    if (instant) {
        textField.tag = 33;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    } else {
        textField.returnKeyType = UIReturnKeySearch;
    }
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-btnW, STATUS_HEIGHT, btnW, hei)];
    [cancleBtn setTitle:ADLString(@"cancle") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [cancleBtn addTarget:self action:@selector(clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+hei-0.5, wid, 0.5)];
    divisionView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:divisionView];
    self.divisionView = divisionView;
}

#pragma mark ------ 取消 ------
- (void)clickCancleButton {
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancleButton)]) {
        [self.delegate didClickCancleButton];
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 33) {
        [textField resignFirstResponder];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSearchButton:)]) {
            [self.delegate didClickSearchButton:textField];
        }
    }
    return YES;
}

#pragma mark ------ 输入内容改变 ------
- (void)textChanged:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldTextDidChanged:)]) {
        [self.delegate textFieldTextDidChanged:textField.text];
    }
}

- (void)setDone:(BOOL)done {
    _done = done;
    if (done) {
        self.textField.tag = 33;
        self.textField.returnKeyType = UIReturnKeyDone;
    } else {
        self.textField.tag = 0;
        self.textField.returnKeyType = UIReturnKeySearch;
    }
}

@end
