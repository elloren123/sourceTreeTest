//
//  ADLChatToolView.m
//  lockboss
//
//  Created by adel on 2019/8/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatToolView.h"
#import "ADLGlobalDefine.h"
#import "ADLEmojiInputView.h"
#import "ADLMoreInputView.h"
#import "ADLSpeakLab.h"

@interface ADLChatToolView ()<UITextViewDelegate,ADLSpeakLabDelegate,ADLEmojiInputViewDelegate,ADLMoreInputViewDelegate>
@property (nonatomic, strong) UIButton *multiBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat textH;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) ADLSpeakLab *speakLab;
@property (nonatomic, strong) ADLEmojiInputView *emojiView;
@property (nonatomic, strong) ADLMoreInputView *moreView;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation ADLChatToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)setupView {
    self.textH = 34;
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    spView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:spView];
    
    UIButton *multiBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 50)];
    multiBtn.contentMode = UIViewContentModeCenter;
    [multiBtn setImage:[UIImage imageNamed:@"chat_voice"] forState:UIControlStateNormal];
    [multiBtn addTarget:self action:@selector(clickMultiBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:multiBtn];
    multiBtn.tag = 1;
    self.multiBtn = multiBtn;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(44, 8, SCREEN_WIDTH-120, 34)];
    textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 0);
    textView.font = [UIFont systemFontOfSize:FONT_SIZE];
    textView.enablesReturnKeyAutomatically = YES;
    textView.showsHorizontalScrollIndicator = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.backgroundColor = COLOR_F2F2F2;
    textView.returnKeyType = UIReturnKeySend;
    textView.layer.cornerRadius = 3;
    textView.delegate = self;
    [self addSubview:textView];
    self.textView = textView;
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton *emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-76, 0, 32, 50)];
    emojiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [emojiBtn setImage:[UIImage imageNamed:@"chat_emoji"] forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(clickEmojiBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emojiBtn];
    self.emojiBtn = emojiBtn;
    emojiBtn.tag = 1;
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 50)];
    moreBtn.contentMode = UIViewContentModeCenter;
    [moreBtn setImage:[UIImage imageNamed:@"chat_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
    moreBtn.tag = 1;
    
    ADLSpeakLab *speakLab = [[ADLSpeakLab alloc] init];
    speakLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    speakLab.textAlignment = NSTextAlignmentCenter;
    speakLab.backgroundColor = COLOR_F2F2F2;
    speakLab.textColor = COLOR_333333;
    speakLab.userInteractionEnabled = YES;
    speakLab.layer.cornerRadius = 3;
    speakLab.clipsToBounds = YES;
    speakLab.text = @"按住 说话";
    speakLab.delegate = self;
    [self addSubview:speakLab];
    self.speakLab = speakLab;
}

#pragma mark ------ 点击语音或键盘 ------
- (void)clickMultiBtn {
    if (self.moreBtn.tag == 2) {
        self.moreBtn.tag = 1;
        self.textView.inputView = nil;
        self.textView.tintColor = APP_COLOR;
        [self.coverView removeFromSuperview];
    }
    
    if (self.multiBtn.tag == 1) {
        self.multiBtn.tag = 2;
        self.content = self.textView.text;
        [self.multiBtn setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateNormal];
        
        self.speakLab.frame = CGRectMake(44, 8, SCREEN_WIDTH-120, 34);
        [self.textView resignFirstResponder];
        self.textView.hidden = YES;
        self.textView.text = @"";
        
        if (self.emojiBtn.tag == 2) {
            self.emojiBtn.tag = 1;
            [self.emojiBtn setImage:[UIImage imageNamed:@"chat_emoji"] forState:UIControlStateNormal];
            self.textView.inputView = nil;
        }
    } else {
        self.multiBtn.tag = 1;
        [self.multiBtn setImage:[UIImage imageNamed:@"chat_voice"] forState:UIControlStateNormal];
        self.speakLab.frame = CGRectZero;
        [self.textView becomeFirstResponder];
        self.textView.text = self.content;
        self.textView.hidden = NO;
    }
}

#pragma mark ------ ADLSpeakLabDelegate ------
- (void)startRecording {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRecording)]) {
        [self.delegate didStartRecording];
    }
}

- (void)cancleRecording {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancleRecording)]) {
        [self.delegate didCancleRecording];
    }
}

- (void)endRecording {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndRecording)]) {
        [self.delegate didEndRecording];
    }
}

#pragma mark ------ 点击表情 ------
- (void)clickEmojiBtn {
    if (self.moreBtn.tag == 2) {
        self.moreBtn.tag = 1;
        self.textView.tintColor = APP_COLOR;
        [self.coverView removeFromSuperview];
    }
    
    if (self.emojiBtn.tag == 1) {
        self.emojiBtn.tag = 2;
        [self.emojiBtn setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateNormal];
        self.textView.inputView = self.emojiView;
        
        if (self.multiBtn.tag == 2) {
            self.multiBtn.tag = 1;
            [self.multiBtn setImage:[UIImage imageNamed:@"chat_voice"] forState:UIControlStateNormal];
            self.speakLab.frame = CGRectZero;
            self.textView.text = self.content;
            self.textView.hidden = NO;
        }
        if (![self.textView isFirstResponder]) {
            [self.textView becomeFirstResponder];
        }
    } else {
        self.emojiBtn.tag = 1;
        [self.emojiBtn setImage:[UIImage imageNamed:@"chat_emoji"] forState:UIControlStateNormal];
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
}

#pragma mark ------ ADLEmojiInputViewDelegate ------
- (void)didClickEmoji:(NSString *)emoji {
    NSInteger location = self.textView.selectedRange.location;
    if (emoji.length == 0) {
        if (self.textView.selectedTextRange.empty) {
            if (location > 0) {
                NSString *head = [self.textView.text substringToIndex:location];
                NSRange range = [head rangeOfComposedCharacterSequenceAtIndex:head.length-1];
                self.textView.text = [NSString stringWithFormat:@"%@%@",[head substringToIndex:range.location],[self.textView.text substringFromIndex:location]];
                self.textView.selectedRange = NSMakeRange(range.location, 0);
            }
        } else {
            [self.textView replaceRange:self.textView.selectedTextRange withText:@""];
        }
    } else {
        NSString *head = [self.textView.text substringToIndex:location];
        self.textView.text = [NSString stringWithFormat:@"%@%@%@",head,emoji,[self.textView.text substringFromIndex:location]];
        self.textView.selectedRange = NSMakeRange(location+emoji.length, 0);
    }
}

- (void)didClickSend {
    if (self.textView.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSendBtn:)]) {
            NSString *text = self.textView.text;
            self.textView.text = @"";
            [self.delegate didClickSendBtn:text];
        }
    }
}

#pragma mark ------ 点击更多 ------
- (void)clickMoreBtn {
    if (self.moreBtn.tag == 1) {
        self.moreBtn.tag = 2;
        self.textView.inputView = self.moreView;
        self.textView.tintColor = [UIColor clearColor];
        
        self.coverView.frame = self.textView.frame;
        [self addSubview:self.coverView];
        
        if (self.multiBtn.tag == 2) {
            self.multiBtn.tag = 1;
            [self.multiBtn setImage:[UIImage imageNamed:@"chat_voice"] forState:UIControlStateNormal];
            self.speakLab.frame = CGRectZero;
            self.textView.text = self.content;
            self.textView.hidden = NO;
        }
        
        if (self.emojiBtn.tag == 2) {
            self.emojiBtn.tag = 1;
            [self.emojiBtn setImage:[UIImage imageNamed:@"chat_emoji"] forState:UIControlStateNormal];
        }
        if (![self.textView isFirstResponder]) {
            [self.textView becomeFirstResponder];
        }
    } else {
        self.moreBtn.tag = 1;
        self.textView.inputView = nil;
        self.textView.tintColor = APP_COLOR;
        [self.coverView removeFromSuperview];
    }
    [self.textView reloadInputViews];
}

#pragma mark ------ 更多模式下点击TextView ------
- (void)clickCoverView {
    self.moreBtn.tag = 1;
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    self.textView.tintColor = APP_COLOR;
    [self.coverView removeFromSuperview];
}

#pragma mark ------ ADLMoreInputViewDelegate ------
- (void)didClickCamera {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTakePhoto)]) {
        [self.textView resignFirstResponder];
        [self.delegate didClickTakePhoto];
    }
}

- (void)didClickPhoto {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPhotoLibrary)]) {
        [self.textView resignFirstResponder];
        [self.delegate didClickPhotoLibrary];
    }
}

- (void)didClickVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRecordingVideo)]) {
        [self.textView resignFirstResponder];
        [self.delegate didClickRecordingVideo];
    }
}

#pragma mark ------ 输入改变 ------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSendBtn:)]) {
                NSString *text = self.textView.text;
                textView.text = @"";
                [self.delegate didClickSendBtn:text];
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark ------ TextView ContentSize 改变 ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat height = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height;
    if (self.textH == 34 && height > 90) {
        height = 88;
    }
    if (height < 90) {
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y-height+self.textH;
        frame.size.height = height+16;
        self.frame = frame;
        
        self.multiBtn.frame = CGRectMake(0, height-34, 44, 50);
        self.textView.frame = CGRectMake(44, 8, SCREEN_WIDTH-120, height);
        self.emojiBtn.frame = CGRectMake(SCREEN_WIDTH-76, height-34, 32, 50);
        self.moreBtn.frame = CGRectMake(SCREEN_WIDTH-44, height-34, 44, 50);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeFrame:)]) {
            [self.delegate didChangeFrame:self.textH-height];
        }
        self.textH = height;
    }
}

#pragma mark ------ 取消编辑 ------
- (void)endEditing {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark ------ 懒加载 ------
- (ADLEmojiInputView *)emojiView {
    if (_emojiView == nil) {
        _emojiView = [ADLEmojiInputView emojiViewWithDelegate:self];
    }
    return _emojiView;
}

- (ADLMoreInputView *)moreView {
    if (_moreView == nil) {
        _moreView = [ADLMoreInputView moreViewWithDelegate:self];
    }
    return _moreView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

@end
