//
//  ADLSearchAnimateView.m
//  lockboss
//
//  Created by Han on 2019/5/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSearchAnimateView.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"

@interface ADLSearchAnimateView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ADLSearchAnimateView

+ (instancetype)searchAnimateViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder verticalMargin:(CGFloat)verticalMargin instant:(BOOL)instant {
    return [[self alloc] initWithFrame:frame placeholder:placeholder verticalMargin:verticalMargin instant:instant];
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder verticalMargin:(CGFloat)verticalMargin instant:(BOOL)instant {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViewWithPlaceholder:placeholder gap:verticalMargin instant:instant];
    }
    return self;
}

- (void)setupViewWithPlaceholder:(NSString *)placeholder gap:(CGFloat)gap instant:(BOOL)instant {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    CGFloat btnW = 55;
    if ([[ADLLocalizedHelper helper].currentLanguage isEqualToString:@"en"]) btnW = 73;
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid, 0, btnW, hei)];
    cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancleBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [cancleBtn setTitle:ADLString(@"cancle") forState:UIControlStateNormal];
    cancleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [cancleBtn addTarget:self action:@selector(clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, gap, wid-24, hei-gap*2)];
    bgView.backgroundColor = COLOR_F2F2F2;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIImageView *sImgView = [[UIImageView alloc] initWithFrame:CGRectMake(22, (hei-16)/2, 16, 16)];
    sImgView.image = [UIImage imageNamed:@"home_search"];
    [self addSubview:sImgView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(36, 0, wid-66, hei-gap*2)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:FONT_SIZE];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = COLOR_333333;
    textField.placeholder = placeholder;
    [bgView addSubview:textField];
    textField.delegate = self;
    self.textField = textField;
    if (instant) {
        [textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeySearch;
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, hei-0.5, wid, 0.5)];
    bottomView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)textFieldTextChanged:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldTextDidChanged:)]) {
        [self.delegate textFieldTextDidChanged:textField.text];
    }
}

#pragma mark ------ 点击取消按钮 ------
- (void)clickCancleButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancleButton)]) {
        [self.delegate didClickCancleButton];
    }
    [self cancleSearch];
}

#pragma mark ------ 取消 ------
- (void)cancleSearch {
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    
    CGFloat wid = self.frame.size.width;
    CGRect tfFrame = self.textField.frame;
    tfFrame.size.width = wid-66;
    CGRect bgFrame = self.bgView.frame;
    bgFrame.size.width = wid-24;
    CGRect cbFrame = self.cancleBtn.frame;
    cbFrame.origin.x = wid;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = bgFrame;
        self.cancleBtn.frame = cbFrame;
        self.textField.frame = tfFrame;
    }];
}

#pragma mark ------ 是否正在编辑 ------
- (BOOL)editing {
    return [self.textField isFirstResponder];
}

#pragma mark ------ 退出编辑 ------
- (void)endEditing {
    [self.textField resignFirstResponder];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSearchDoneButton:)]) {
        [self.delegate didClickSearchDoneButton:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat wid = self.frame.size.width;
    CGRect cbFrame = self.cancleBtn.frame;
    cbFrame.origin.x = wid-cbFrame.size.width;
    CGRect tfFrame = textField.frame;
    tfFrame.size.width = wid-53-cbFrame.size.width;
    CGRect bgFrame = self.bgView.frame;
    bgFrame.size.width = wid-12-cbFrame.size.width;

    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEdit:)]) {
        [self.delegate textFieldDidBeginEdit:textField];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = bgFrame;
        self.cancleBtn.frame = cbFrame;
        self.textField.frame = tfFrame;
    }];
}

- (void)setHideBottomView:(BOOL)hideBottomView {
    _hideBottomView = hideBottomView;
    self.bottomView.hidden = hideBottomView;
}

@end
