//
//  ADLCommentView.m
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCommentView.h"
#import "ADLGlobalDefine.h"
#import "ADLToast.h"

@interface ADLCommentView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeLab;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation ADLCommentView

+ (instancetype)commentViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializationSubView];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)initializationSubView {
    self.placeHolder = @"请输入留言";
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wid, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    [self addSubview:lineView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 8, wid-96, hei-16)];
    textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 3);
    textView.font = [UIFont systemFontOfSize:FONT_SIZE];
    textView.backgroundColor = COLOR_F2F2F2;
    textView.textColor = COLOR_333333;
    textView.layer.cornerRadius = 3;
    textView.delegate = self;
    [self addSubview:textView];
    self.textView = textView;
    
    UILabel *placeLab = [[UILabel alloc] initWithFrame:CGRectMake(21, 15, wid-105, 20)];
    placeLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    placeLab.textColor = PLACEHOLDER_COLOR;
    placeLab.text = @"请输入留言";
    [self addSubview:placeLab];
    self.placeLab = placeLab;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame = CGRectMake(wid-72, 8, 60, hei-16);
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sendBtn.backgroundColor = APP_COLOR;
    sendBtn.layer.cornerRadius = CORNER_RADIUS;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ------ UITextViewDelegate ------
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0) {
        self.placeLab.text = @"";
    } else {
        self.placeLab.text = self.placeHolder;
    }
}

#pragma mark ------ 键盘将要显示 ------
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardH = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (keyboardH > 0) {
        self.transform = CGAffineTransformMakeTranslation(0, -keyboardH-self.frame.size.height);
    }
}

#pragma mark ------ 键盘将要隐藏 ------
- (void)keyboardWillHide:(NSNotification *)notification {
    self.transform = CGAffineTransformIdentity;
    self.textView.text = @"";
}

#pragma mark ------ 发送 ------
- (void)clickSendBtn:(UIButton *)sender {
    NSString *textStr = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    textStr = [textStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (textStr.length == 0) {
        [ADLToast showMessage:self.placeHolder];
    } else {
        if (self.clickSendBtn) {
            self.clickSendBtn(sender, self.textView.text);
        }
        [self.textView resignFirstResponder];
    }
}

#pragma mark ------ 开始编辑 ------
- (void)beginEditing {
    [self.textView becomeFirstResponder];
}

#pragma mark ------ 退出编辑 ------
- (void)endEditing {
    [self.textView resignFirstResponder];
}

#pragma mark ------ 是否正在编辑 ------
- (BOOL)isEditing {
    return [self.textView isFirstResponder];
}

#pragma mark ------ Setter ------
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeLab.text = placeHolder;
}

@end
