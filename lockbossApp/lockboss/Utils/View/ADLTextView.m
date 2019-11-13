//
//  ADLTextView.m
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTextView.h"
#import "ADLGlobalDefine.h"
#import "ADLLocalizedHelper.h"

@interface ADLTextView ()<UITextViewDelegate>
@property (nonatomic, assign) NSInteger limitLength;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeLab;
@property (nonatomic, strong) UILabel *numLab;
@end

@implementation ADLTextView

+ (instancetype)textViewWithFrame:(CGRect)frame limitLength:(NSInteger)limitLength {
    return [[self alloc] initWithFrame:frame limitLength:limitLength];
}

- (instancetype)initWithFrame:(CGRect)frame limitLength:(NSInteger)limitLength {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.limitLength = limitLength;
        [self initTextView:limitLength];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initTextView:(NSInteger)limitLength {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    CGFloat countLabH = 30;
    CGRect textViewFrame = CGRectMake(0, 0, wid, hei-countLabH);
    if (limitLength == 0) textViewFrame = self.bounds;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 3);
    textView.font = [UIFont systemFontOfSize:FONT_SIZE];
    textView.inputAccessoryView = [self setupToolView];
    textView.showsHorizontalScrollIndicator = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.textColor = COLOR_333333;
    textView.delegate = self;
    [self addSubview:textView];
    self.textView = textView;
    
    UILabel *placeLab = [[UILabel alloc] init];
    placeLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    placeLab.textColor = PLACEHOLDER_COLOR;
    placeLab.numberOfLines = 0;
    [self addSubview:placeLab];
    self.placeLab = placeLab;
    
    if (limitLength > 0) {
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(wid-110, hei-countLabH, 100, countLabH)];
        numLab.text = [NSString stringWithFormat:@"0/%ld",limitLength];
        numLab.textAlignment = NSTextAlignmentRight;
        numLab.font = [UIFont systemFontOfSize:13];
        numLab.textColor = COLOR_999999;
        [self addSubview:numLab];
        self.numLab = numLab;
    }
}

#pragma mark ------ UITextViewDelegate ------
- (void)textViewDidChange:(UITextView *)textView {
    if (self.limitLength > 0) {
        UITextRange *range = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position) {
            if (textView.text.length > self.limitLength-1) {
                self.numLab.textColor = APP_COLOR;
                textView.text = [textView.text substringToIndex:self.limitLength];
            } else {
                self.numLab.textColor = COLOR_999999;
            }
            self.numLab.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,self.limitLength];
            if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeText:)]) {
                [self.delegate textViewDidChangeText:textView.text];
            }
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeText:)]) {
            [self.delegate textViewDidChangeText:textView.text];
        }
    }
    if (textView.text.length != 0) {
        self.placeLab.text = @"";
    } else {
        self.placeLab.text = self.placeholder;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidBeginEdit:)]) {
        [self.delegate textViewDidBeginEdit:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEdit:)]) {
        [self.delegate textViewDidEndEdit:textView];
    }
}

#pragma mark ------ 初始化工具栏视图 ------
- (UIView *)setupToolView {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolView.backgroundColor = SEPARATOR_COLOR;
    
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
    return toolView;
}

#pragma mark ------ 退出编辑 ------
- (void)clickDoneBtn {
    [self.textView resignFirstResponder];
}

#pragma mark ------ Setter ------
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    CGFloat hei = [placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width-22, CGRectGetHeight(self.textView.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.height+2;
    self.placeLab.frame = CGRectMake(11, 7, self.frame.size.width-22, hei);
    if (self.textView.text.length == 0) {
        self.placeLab.text = placeholder;
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.textView.backgroundColor = bgColor;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    if (text.length > 0) {
        self.textView.text = text;
        self.placeLab.text = @"";
    } else {
        self.textView.text = @"";
        self.placeLab.text = self.placeholder;
    }
    if (self.numLab) {
        if (text.length >= self.limitLength) {
            self.numLab.textColor = APP_COLOR;
            self.textView.text = [text substringToIndex:self.limitLength];
        } else {
            self.numLab.textColor = COLOR_999999;
        }
        self.numLab.text = [NSString stringWithFormat:@"%ld/%ld",self.textView.text.length,self.limitLength];
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
    self.placeLab.font = font;
}

- (BOOL)editing {
    return [self.textView isFirstResponder];
}

@end
