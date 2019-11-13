//
//  ADLSpeakLab.m
//  lockboss
//
//  Created by adel on 2019/8/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSpeakLab.h"
#import "ADLGlobalDefine.h"

@implementation ADLSpeakLab

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecording)]) {
        [self.delegate startRecording];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.recordView];
    [self.imgView startAnimating];
    self.text = @"松开 结束";
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] locationInView:self].y < -50) {
        if ([self.imgView isAnimating]) {
            [self.imgView stopAnimating];
            self.voiceLab.text = @"松开手指，取消发送";
            self.imgView.frame = CGRectMake(39, 32, 48, 50);
            self.imgView.image = [UIImage imageNamed:@"chat_voice_c"];
        }
    } else {
        if (![self.imgView isAnimating]) {
            [self.imgView startAnimating];
            self.voiceLab.text = @"手指上滑，取消发送";
            self.imgView.frame = CGRectMake(26, 29, 74, 56);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.text = @"按住 说话";
    [self.imgView stopAnimating];
    [self.recordView removeFromSuperview];
    self.imgView.frame = CGRectMake(26, 29, 74, 56);
    if ([[touches anyObject] locationInView:self].y < -50) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancleRecording)]) {
            [self.delegate cancleRecording];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(endRecording)]) {
            [self.delegate endRecording];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleRecording)]) {
        [self.delegate cancleRecording];
    }
}

- (UIView *)recordView {
    if (_recordView == nil) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-63, SCREEN_HEIGHT/2-63, 126, 126)];
        _recordView.backgroundColor = COLOR_666666;
        _recordView.layer.cornerRadius = 3;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 29, 74, 56)];
        imgView.animationImages = @[[UIImage imageNamed:@"chat_voice_0"],[UIImage imageNamed:@"chat_voice_1"],[UIImage imageNamed:@"chat_voice_2"],[UIImage imageNamed:@"chat_voice_3"],[UIImage imageNamed:@"chat_voice_4"]];
        imgView.animationRepeatCount = 0;
        imgView.animationDuration = 2.5;
        [_recordView addSubview:imgView];
        self.imgView = imgView;
        
        UILabel *voiceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 126, 36)];
        voiceLab.font = [UIFont boldSystemFontOfSize:12];
        voiceLab.textAlignment = NSTextAlignmentCenter;
        voiceLab.textColor = [UIColor whiteColor];
        voiceLab.text = @"手指上滑，取消发送";
        [_recordView addSubview:voiceLab];
        self.voiceLab = voiceLab;
    }
    return _recordView;
}

@end
