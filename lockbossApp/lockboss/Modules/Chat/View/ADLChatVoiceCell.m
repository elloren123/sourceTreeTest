//
//  ADLChatVoiceCell.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatVoiceCell.h"
#import "ADLGlobalDefine.h"
#import "ADLChatModel.h"

@interface ADLChatVoiceCell ()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *animView;
@property (nonatomic, strong) UILabel *durationLab;
@property (nonatomic, strong) UIView *bubbleView;
@end

@implementation ADLChatVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *arrowView = [[UIImageView alloc] init];
        [self.contentView addSubview:arrowView];
        self.arrowView = arrowView;
        
        UIView *bubbleView = [[UIView alloc] init];
        bubbleView.layer.cornerRadius = 6;
        [self.contentView addSubview:bubbleView];
        self.bubbleView = bubbleView;
        
        UILabel *durationLab = [[UILabel alloc] init];
        durationLab.font = [UIFont systemFontOfSize:13];
        [bubbleView addSubview:durationLab];
        self.durationLab = durationLab;
        
        UIImageView *animView = [[UIImageView alloc] init];
        animView.animationRepeatCount = MAXFLOAT;
        animView.animationDuration = 1.5;
        [bubbleView addSubview:animView];
        self.animView = animView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBubbleView)];
        [bubbleView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressContentLab:)];
        [bubbleView addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark ------ 点击 ------
- (void)clickBubbleView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVoiceMessage:)]) {
        [self.delegate playVoiceMessage:self.model.message];
    }
}

#pragma mark ------ 长按 ------
- (void)longPressContentLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressMessage:sourceView:)]) {
            [self.delegate longPressMessage:self.model.message sourceView:longPress.view];
        }
    }
}

#pragma mark ------ 赋值 ------
- (void)setModel:(ADLChatModel *)model {
    [super setModel:model];
    self.durationLab.text = model.content;
    if (model.receive) {
        self.arrowView.frame = CGRectMake(64, 23.5, 7, 13);
        self.arrowView.image = [UIImage imageNamed:@"chat_arow_w"];
        self.bubbleView.backgroundColor = [UIColor whiteColor];
        self.bubbleView.frame = CGRectMake(71, 8, model.contentSize.width, model.contentSize.height);
        self.animView.image = [UIImage imageNamed:@"chat_voice_b3"];
        self.animView.frame = CGRectMake(12, 13, 12, 16);
        
        self.durationLab.frame = CGRectMake(36, 10, model.contentSize.width-40, model.contentSize.height-20);
        self.durationLab.textAlignment = NSTextAlignmentLeft;
        self.durationLab.textColor = COLOR_333333;
    } else {
        self.arrowView.frame = CGRectMake(SCREEN_WIDTH-71, 23.5, 7, 13);
        self.arrowView.image = [UIImage imageNamed:@"chat_arow_r"];
        self.bubbleView.backgroundColor = [UIColor colorWithRed:1 green:81/255.0 blue:71/255.0 alpha:1];
        self.bubbleView.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-71, 8, model.contentSize.width, model.contentSize.height);
        self.animView.image = [UIImage imageNamed:@"chat_voice_w3"];
        self.animView.frame = CGRectMake(model.contentSize.width-24, 13, 12, 16);
        self.durationLab.frame = CGRectMake(0, 10, model.contentSize.width-36, model.contentSize.height-20);
        self.durationLab.textAlignment = NSTextAlignmentRight;
        self.durationLab.textColor = [UIColor whiteColor];
    }
    if (model.playing) {
        self.animView.animationImages = model.playArr;
        [self.animView startAnimating];
    } else {
        [self.animView stopAnimating];
    }
}

#pragma mark ------ 开始动画 ------
- (void)startImageAnimation {
    self.animView.animationImages = self.model.playArr;
    [self.animView startAnimating];
}

#pragma mark ------ 结束动画 ------
- (void)stopImageAnimation {
    [self.animView stopAnimating];
}

@end
