//
//  ADLKeyboardMonitor.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLKeyboardMonitor.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"

@interface ADLKeyboardMonitor ()
@property (nonatomic, assign) CGFloat keyboardH;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) CGFloat originY;
@end

@implementation ADLKeyboardMonitor

+ (instancetype)monitor {
    static ADLKeyboardMonitor *kbMonitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kbMonitor = [[self alloc] init];
    });
    return kbMonitor;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setGap:8];
        [self setupToolView];
        [self setShowDone:YES];
        self.needUpdate = YES;
    }
    return self;
}

#pragma mark ------ 键盘将要显示 ------
- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardH = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.keyboardTransform) {
        self.keyboardTransform(_keyboardH+_gap);
    }
}

- (void)getKeyboardHeight {
    if (_keyboardH > 60 && self.keyboardHeightChanged && self.needUpdate) {
        self.needUpdate = NO;
        self.keyboardHeightChanged(_keyboardH+_gap);
        [self performSelector:@selector(setNeedUpdateKeyboard) withObject:nil afterDelay:0.5];
    }
}

- (void)setNeedUpdateKeyboard {
    self.needUpdate = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.originY = [self.inputView.superview convertRect:self.inputView.frame toView:window].origin.y;
}

#pragma mark ------ 键盘将要隐藏 ------
- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.inputView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGFloat inputRectY = [self.inputView.superview convertRect:self.inputView.frame toView:window].origin.y;
        if (fabs(inputRectY-self.originY) < 36 && self.keyboardHeightChanged) {
            self.keyboardHeightChanged(0);
        }
    } else {
        if (self.keyboardHeightChanged) {
            self.keyboardHeightChanged(0);
        }
    }
    if (self.keyboardTransform) {
        self.keyboardTransform(0);
    }
    _keyboardH = 0;
    self.originY = 0;
    self.inputView = nil;
}

#pragma mark ------ 开始编辑 ------
- (void)textFieldDidEditing:(NSNotification *)notification {
    UITextField *currentTF = notification.object;
    self.inputView = currentTF;
    if (self.showDone) currentTF.inputAccessoryView = self.toolView;
    [self performSelector:@selector(getKeyboardHeight) withObject:nil afterDelay:0.02];
}

- (void)textViewDidEditing:(NSNotification *)notification {
    UITextView *currentTV = notification.object;
    self.inputView = currentTV;
    [self performSelector:@selector(getKeyboardHeight) withObject:nil afterDelay:0.02];
}

#pragma mark ------ 键盘高度发生变化 ------
- (void)keyboardWillChangeFrame {
    [self performSelector:@selector(getKeyboardHeight) withObject:nil afterDelay:0.02];
}

#pragma mark ------ 初始化工具栏视图 ------
- (void)setupToolView {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolView.backgroundColor = SEPARATOR_COLOR;
    self.toolView = toolView;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [toolView addSubview:line];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 44);
    [doneBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [doneBtn setTitle:ADLString(@"done") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBtn];
    self.doneBtn = doneBtn;
}

- (void)clickDoneBtn {
    if (self.inputView) {
        [self.inputView resignFirstResponder];
    }
}

#pragma mark ------ Setter ------
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    if (enable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    } else {
        [self setGap:8];
        self.inputView = nil;
        [self setShowDone:YES];
        self.keyboardTransform = nil;
        self.keyboardHeightChanged = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setGap:(CGFloat)gap {
    _gap = MAX(gap, 0);
}

@end
