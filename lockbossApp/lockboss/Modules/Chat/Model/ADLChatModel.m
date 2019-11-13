//
//  ADLChatModel.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatModel.h"
#import "ADLGlobalDefine.h"
#import "ADLNetWorkManager.h"
#import "ADLUtils.h"

#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGFileContent.h>
#import <JMessage/JMSGTextContent.h>
#import <JMessage/JMSGImageContent.h>
#import <JMessage/JMSGVoiceContent.h>
#import <JMessage/JMSGAbstractContent.h>

@implementation ADLChatModel

- (void)updateAttribute:(JMSGAbstractContent *)content type:(ADLMessageType)type {
    self.type = type;
    if (type == ADLMessageTypeText) {
        self.arrowW = 7;
        JMSGTextContent *textContent = (JMSGTextContent *)content;
        self.content = textContent.text;
        CGSize size = [ADLUtils calculateString:self.content rectSize:CGSizeMake(SCREEN_WIDTH-202, MAXFLOAT) fontSize:FONT_SIZE];
        self.contentSize = CGSizeMake(size.width+24, size.height+24);
        self.rowHeight = size.height+40;
        
    } else if (type == ADLMessageTypeImage) {
        self.arrowW = 0;
        JMSGImageContent *imgContent = (JMSGImageContent *)content;
        if (imgContent.imageSize.width == imgContent.imageSize.height) {
            if (SCREEN_WIDTH < 360) {
                self.contentSize = CGSizeMake(100, 100);
                self.rowHeight = 116;
            } else {
                self.contentSize = CGSizeMake(120, 120);
                self.rowHeight = 136;
            }
        } else if (imgContent.imageSize.width > imgContent.imageSize.height) {
            CGFloat imgW = imgContent.imageSize.width*120/imgContent.imageSize.height;
            if (imgW+220 > SCREEN_WIDTH) {
                imgW = SCREEN_WIDTH-220;
            }
            self.contentSize = CGSizeMake(imgW, 120);
            self.rowHeight = 136;
        } else {
            CGFloat imgH = imgContent.imageSize.height*110/imgContent.imageSize.width;
            if (imgH > 160) {
                imgH = 160;
            }
            self.contentSize = CGSizeMake(110, imgH);
            self.rowHeight = imgH+16;
        }
        
    } else if (type == ADLMessageTypeFile) {
        self.arrowW = 0;
        JMSGFileContent *fileContent = (JMSGFileContent *)content;
        NSString *videoName = [NSString stringWithFormat:@"%@.mp4",self.message.msgId];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",self.message.msgId];
        NSString *filePath = [ADLUtils filePathWithName:videoName permanent:NO];
        if (filePath) {
            VideoInfo videoInf = [ADLUtils getVideoInfoWithUrlStr:nil orPathUrl:[NSURL fileURLWithPath:filePath]];
            self.content = [ADLUtils filePathWithName:imgName permanent:NO];
            self.duration = videoInf.duration;
            [self dealwithVideoSize:CGSizeMake(videoInf.thumbnail.size.width, videoInf.thumbnail.size.height)];
        } else {
            [self dealwithVideoSize:CGSizeMake(110, 160)];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:fileContent.mediaID forKey:@"mediaId"];
            [ADLNetWorkManager getNormalPath:@"https://api.im.jpush.cn/v1/resource" parameters:params success:^(NSDictionary *responseDict) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *videoUrl = responseDict[@"url"];
                    if (videoUrl) {
                        VideoInfo videoInfo = [ADLUtils getVideoInfoWithUrlStr:videoUrl orPathUrl:nil];
                        if (videoInfo.thumbnail) {
                            self.content = [ADLUtils filePathWithName:imgName permanent:NO];
                            self.duration = videoInfo.duration;
                            if (![ADLUtils filePathWithName:imgName permanent:NO]) {
                                [ADLUtils saveObject:UIImageJPEGRepresentation(videoInfo.thumbnail, 0.01) fileName:imgName permanent:NO];
                            }
                            [self dealwithVideoSize:CGSizeMake(videoInfo.thumbnail.size.width, videoInfo.thumbnail.size.height)];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatModel" object:self.message.msgId userInfo:nil];
                            });
                        }
                    }
                });
            } failure:nil];
        }
    } else {
        self.arrowW = 7;
        self.playing = NO;
        self.rowHeight = 58;
        JMSGVoiceContent *voiceContent = (JMSGVoiceContent *)content;
        NSInteger duration = [voiceContent.duration integerValue];
        self.content = [NSString stringWithFormat:@"%ld\"",duration];
        CGFloat increase = (SCREEN_WIDTH-272)/5;
        if (duration < 10) {
            self.contentSize = CGSizeMake(70, 42);
        } else if (duration < 20) {
            self.contentSize = CGSizeMake(70+increase, 42);
        } else if (duration < 30) {
            self.contentSize = CGSizeMake(70+increase*2, 42);
        } else if (duration < 40) {
            self.contentSize = CGSizeMake(70+increase*3, 42);
        } else if (duration < 50) {
            self.contentSize = CGSizeMake(70+increase*4, 42);
        } else {
            self.contentSize = CGSizeMake(70+increase*5, 42);
        }
        if (self.receive) {
            self.playArr = @[[UIImage imageNamed:@"chat_voice_b1"],[UIImage imageNamed:@"chat_voice_b2"],[UIImage imageNamed:@"chat_voice_b3"]];
        } else {
            self.playArr = @[[UIImage imageNamed:@"chat_voice_w1"],[UIImage imageNamed:@"chat_voice_w2"],[UIImage imageNamed:@"chat_voice_w3"]];
        }
    }
}

#pragma mark ------ 处理视频尺寸 ------
- (void)dealwithVideoSize:(CGSize)videoSize {
    if (videoSize.width == videoSize.height) {
        if (SCREEN_WIDTH < 360) {
            self.contentSize = CGSizeMake(100, 100);
            self.rowHeight = 116;
        } else {
            self.contentSize = CGSizeMake(120, 120);
            self.rowHeight = 136;
        }
    } else if (videoSize.width > videoSize.height) {
        CGFloat videoW = videoSize.width*120/videoSize.height;
        if (videoW+220 > SCREEN_WIDTH) {
            videoW = SCREEN_WIDTH-220;
        }
        self.contentSize = CGSizeMake(videoW, 120);
        self.rowHeight = 136;
    } else {
        CGFloat videoH = videoSize.height*110/videoSize.width;
        if (videoH > 160) {
            videoH = 160;
        }
        self.contentSize = CGSizeMake(110, videoH);
        self.rowHeight = videoH+16;
    }
}

@end
