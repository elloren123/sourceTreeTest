//
//  ADLDownloadVideoView.m
//  lockboss
//
//  Created by Han on 2019/8/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLDownloadView.h"
#import "ADLGlobalDefine.h"
#import "ADLAlertView.h"
#import "ADLUtils.h"

#import <JMessage/JMSGFileContent.h>

@interface ADLDownloadView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, copy) void (^finish) (void);
@property (nonatomic, strong) JMSGFileContent *content;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLab;
@property (nonatomic, strong) NSString *msgId;
@end

@implementation ADLDownloadView

+ (instancetype)showWithContent:(JMSGFileContent *)content msgId:(NSString *)msgId finish:(void(^)(void))finish {
    return [[self alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) content:content msgId:msgId finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame content:(JMSGFileContent *)content msgId:(NSString *)msgId finish:(void (^)(void))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        self.content = content;
        self.msgId = msgId;
        
        self.backgroundColor = COLOR_F2F2F2;
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
        [closeBtn setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        closeBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [self addSubview:closeBtn];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, NAVIGATION_H+66, 70, 70)];
        imgView.image = [UIImage imageNamed:@"common_video"];
        [self addSubview:imgView];
        
        CGFloat nameH = [ADLUtils calculateString:content.fileName rectSize:CGSizeMake(SCREEN_WIDTH-30, SCREEN_HEIGHT-NAVIGATION_H-296) fontSize:FONT_SIZE].height+10;
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+142, SCREEN_WIDTH-30, nameH)];
        nameLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.textColor = COLOR_333333;
        nameLab.text = content.fileName;
        nameLab.numberOfLines = 0;
        [self addSubview:nameLab];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+nameH+166, SCREEN_WIDTH-60, 6)];
        progressView.transform = CGAffineTransformMakeScale(1, 1.5);
        progressView.trackTintColor = COLOR_D3D3D3;
        progressView.hidden = YES;
        [self addSubview:progressView];
        self.progressView = progressView;
        
        UILabel *progressLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+nameH+166, SCREEN_WIDTH-60, 40)];
        progressLab.textAlignment = NSTextAlignmentCenter;
        progressLab.font = [UIFont systemFontOfSize:13];
        progressLab.textColor = COLOR_333333;
        progressLab.hidden = YES;
        [self addSubview:progressLab];
        self.progressLab = progressLab;
        
        UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        downBtn.frame = CGRectMake(30, NAVIGATION_H+nameH+192, SCREEN_WIDTH-60, 45);
        [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        downBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [downBtn setTitle:[NSString stringWithFormat:@"下载（%.2fM）",[content.fSize doubleValue]/1048576.f] forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(clickDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        downBtn.backgroundColor = APP_COLOR;
        downBtn.layer.cornerRadius = 4;
        [self addSubview:downBtn];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    return self;
}


#pragma mark ------ 下载 ------
- (void)clickDownBtn:(UIButton *)sender {
    if (self.progressView.hidden) {
        self.progressView.hidden = NO;
        self.progressLab.hidden = NO;
        CGRect frame = sender.frame;
        frame.origin.y = frame.origin.y+50;
        sender.frame = frame;
        
        [sender setTitle:@"取消下载" forState:UIControlStateNormal];
        double fileSize = [self.content.fSize doubleValue]/1048576.f;
        [self.content fileDataWithProgress:^(float percent, NSString *msgId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = percent;
                self.progressLab.text = [NSString stringWithFormat:@"%.2fM/%.2fM",fileSize*percent,fileSize];
            });
        } completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSString *videoName = [NSString stringWithFormat:@"%@.mp4",self.msgId];
                    BOOL vWrite = [ADLUtils saveObject:data fileName:videoName permanent:NO];
                    if (vWrite) {
                        if (self.finish) {
                            self.finish();
                        }
                    } else {
                        [ADLUtils removeObjectWithFileName:videoName permanent:NO];
                    }
                    [self clickCloseBtn];
                } else {
                    [sender setTitle:[NSString stringWithFormat:@"下载（%.2fM）",fileSize] forState:UIControlStateNormal];
                    self.progressView.hidden = YES;
                    self.progressLab.hidden = YES;
                    self.progressView.progress = 0;
                    self.progressLab.text = @"";
                    CGRect frame = sender.frame;
                    frame.origin.y = frame.origin.y-50;
                    sender.frame = frame;
                }
            });
        }];
    } else {
        [ADLAlertView showWithTitle:@"提示" message:@"已下载的数据不会保存，是否取消？" confirmTitle:nil confirmAction:^{
            [self clickCloseBtn];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 关闭 ------
- (void)clickCloseBtn {
    [self.content cancelDownloadOriginMedia];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
