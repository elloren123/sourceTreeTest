//
//  ADLSessionController.m
//  lockboss
//
//  Created by adel on 2019/8/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSessionController.h"
#import "ADLChatToolView.h"

#import "ADLChatModel.h"
#import "ADLChatBaseCell.h"
#import "ADLChatTimeCell.h"
#import "ADLChatTextCell.h"
#import "ADLChatImageCell.h"
#import "ADLChatVoiceCell.h"

#import "ADLKeyboardMonitor.h"
#import "ADLChatImgPreView.h"
#import "ADLDownloadView.h"
#import "ADLMenuView.h"

#import "LameTool.h"
#import <JMessage/JMessage.h>
#import <AVKit/AVPlayerViewController.h>

@interface ADLSessionController ()
<JMessageDelegate,
ADLChatCellDelegate,
UITableViewDelegate,
AVAudioPlayerDelegate,
UITableViewDataSource,
ADLChatToolViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imgMsgArr;
@property (nonatomic, strong) ADLChatToolView *toolView;
@property (nonatomic, strong) JMSGConversation *conversation;
@property (nonatomic, strong) NSMutableDictionary *messageDict;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIButton *emptyBtn;
@property (nonatomic, strong) NSString *msgId;
@end

@implementation ADLSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.messageDict = [[NSMutableDictionary alloc] init];
    self.imgMsgArr = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    CGFloat hei = self.view.frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, hei-NAVIGATION_H-BOTTOM_H-50)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self addNavigationView:@"客服服务"];
    self.emptyBtn = [self addRightButtonWithTitle:@"清空" action:@selector(clickEmptyBtn)];
    self.emptyBtn.hidden = YES;
    
    ADLChatToolView *toolView = [[ADLChatToolView alloc] initWithFrame:CGRectMake(0, hei-BOTTOM_H-50, SCREEN_WIDTH, 50)];
    toolView.delegate = self;
    [self.view addSubview:toolView];
    self.toolView = toolView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viodeImageChanged:) name:@"chatModel" object:nil];
    
    __weak typeof(self)weakSelf = self;
    [[ADLKeyboardMonitor monitor] setEnable:YES];
    [[ADLKeyboardMonitor monitor] setShowDone:NO];
    [[ADLKeyboardMonitor monitor] setGap:0];
    [ADLKeyboardMonitor monitor].keyboardTransform = ^(CGFloat keyboardH) {
        CGFloat bottomH = 0;
        if (keyboardH == 0) {
            bottomH = BOTTOM_H;
            weakSelf.toolView.transform = CGAffineTransformIdentity;
        } else {
            weakSelf.toolView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+BOTTOM_H);
        }
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, hei-NAVIGATION_H-keyboardH-bottomH-weakSelf.toolView.frame.size.height);
        }];
    };
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH > 0 && weakSelf.dataArr.count > 0) {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    };
    [self customerInf];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.toolView endEditing];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLChatModel *model = self.messageDict[self.dataArr[indexPath.row]];
    return model.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLChatModel *model = self.messageDict[self.dataArr[indexPath.row]];
    if (model.type == ADLMessageTypeTime || model.type == ADLMessageTypePrompt) {
        ADLChatTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"time"];
        if (timeCell == nil) {
            timeCell = [[ADLChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"time"];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        timeCell.timeLab.text = model.content;
        timeCell.timeLab.frame = CGRectMake((SCREEN_WIDTH-model.contentSize.width)/2, 16, model.contentSize.width, 20);
        return timeCell;
        
    } else if (model.type == ADLMessageTypeText) {
        ADLChatTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"text"];
        if (textCell == nil) {
            textCell = [[ADLChatTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.delegate = self;
        }
        textCell.model = model;
        return textCell;
        
    } else if (model.type == ADLMessageTypeVoice) {
        ADLChatVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:@"voice"];
        if (voiceCell == nil) {
            voiceCell = [[ADLChatVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voice"];
            voiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            voiceCell.delegate = self;
        }
        voiceCell.model = model;
        return voiceCell;
    } else {
        ADLChatImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"image"];
        if (imageCell == nil) {
            imageCell = [[ADLChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image"];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            imageCell.delegate = self;
        }
        imageCell.model = model;
        return imageCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.toolView endEditing];
}

#pragma mark ------ ADLChatToolViewDelegate ------
- (void)didChangeFrame:(CGFloat)height {
    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height+height;
    self.tableView.frame = frame;
}

#pragma mark ------ 发送 ------
- (void)didClickSendBtn:(NSString *)content {
    if (self.conversation) {
        JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:content];
        JMSGMessage *message = [self.conversation createMessageWithContent:textContent];
        [self sendMessage:message type:ADLMessageTypeText];
    } else {
        [ADLToast showMessage:@"会话创建失败，请返回重试！"];
    }
}

#pragma mark ------ 开始录音 ------
- (void)didStartRecording {
    if ([self.player isPlaying]) {
        [self.player stop];
        if (self.msgId) {
            ADLChatModel *model = self.messageDict[self.msgId];
            model.playing = NO;
            NSInteger row = [self.dataArr indexOfObject:self.msgId];
            ADLChatVoiceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell stopImageAnimation];
            self.msgId = nil;
        }
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [self.recorder record];
}

#pragma mark ------ 取消录音 ------
- (void)didCancleRecording {
    [self.recorder stop];
    [self.recorder deleteRecording];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

#pragma mark ------ 结束录音 ------
- (void)didEndRecording {
    if (self.recorder.currentTime > 1) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lockboss.caf"];
        NSString *voicePath = [LameTool audioToMP3:filePath];
        JMSGVoiceContent *content = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath] voiceDuration:@(self.recorder.currentTime)];
        JMSGMessage *message = [self.conversation createMessageWithContent:content];
        [self sendMessage:message type:ADLMessageTypeVoice];
    }
    [self.recorder stop];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

#pragma mark ------ 播放录音 ------
- (void)playVoiceMessage:(JMSGMessage *)message {
    JMSGVoiceContent *content = (JMSGVoiceContent *)message.content;
    [content voiceData:^(NSData *data, NSString *objectId, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *verror;
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&verror];
            self.player.delegate = self;
            if (verror) {
                [ADLToast showMessage:@"播放错误"];
            } else {
                if (self.msgId) {
                    ADLChatModel *lastModel = self.messageDict[self.msgId];
                    lastModel.playing = NO;
                    NSInteger lastRow = [self.dataArr indexOfObject:self.msgId];
                    ADLChatVoiceCell *lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
                    [lastCell stopImageAnimation];
                }
                [self.player prepareToPlay];
                [self.player play];
                
                self.msgId = message.msgId;
                ADLChatModel *model = self.messageDict[self.msgId];
                model.playing = YES;
                NSInteger row = [self.dataArr indexOfObject:self.msgId];
                ADLChatVoiceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                [cell startImageAnimation];
            }
        });
    }];
}

#pragma mark ------ 语音播放完成 ------
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.msgId) {
        ADLChatModel *model = self.messageDict[self.msgId];
        model.playing = NO;
        NSInteger row = [self.dataArr indexOfObject:self.msgId];
        ADLChatVoiceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell stopImageAnimation];
        self.msgId = nil;
    }
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

#pragma mark ------ 拍照 ------
- (void)didClickTakePhoto {
    ADLCameraStatus status = [ADLUtils getCameraStatus];
    if (status == ADLCameraStatusDenied) {
        [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
            [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    } else if (status == ADLCameraStatusAllow) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
    } else {
        [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
    }
}

#pragma mark ------ 图片 ------
- (void)didClickPhotoLibrary {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.mediaTypes = @[@"public.image", @"public.movie"];
    pickerVC.navigationBar.tintColor = [UIColor blackColor];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark ------ 视频 ------
- (void)didClickRecordingVideo {
    ADLCameraStatus status = [ADLUtils getCameraStatus];
    if (status == ADLCameraStatusDenied) {
        [ADLAlertView showWithTitle:ADLString(@"photo_video") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
            [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    } else if (status == ADLCameraStatusAllow) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVC.mediaTypes = @[@"public.movie"];
        pickerVC.videoMaximumDuration = 120;
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
    } else {
        [ADLAlertView showWithTitle:ADLString(@"photo_video") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
    }
}

#pragma mark ------ 消息重发 ------
- (void)didClickResendMessage:(ADLChatModel *)model {
    model.sending = YES;
    model.failed = NO;
    ADLChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:model.message.msgId] inSection:0]];
    cell.model = model;
    [model.message.content addNumberExtra:@(1) forKey:@"resend"];
    [self.conversation sendMessage:model.message];
}

#pragma mark ------ 点击图片或视频 ------
- (void)didClickImageMessage:(JMSGMessage *)message {
    [self.toolView endEditing];
    if (message.contentType == kJMSGContentTypeFile) {
        NSString *filePath = [ADLUtils filePathWithName:[NSString stringWithFormat:@"%@.mp4",message.msgId] permanent:NO];
        if (filePath) {
            AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
            playerVC.player = player;
            [player play];
            [self presentViewController:playerVC animated:YES completion:nil];
        } else {
            [ADLDownloadView showWithContent:(JMSGFileContent *)message.content msgId:message.msgId finish:^{
                NSString *videoPath = [ADLUtils filePathWithName:[NSString stringWithFormat:@"%@.mp4",message.msgId] permanent:NO];
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
                playerVC.player = player;
                [player play];
                [self presentViewController:playerVC animated:YES completion:nil];
            }];
        }
    } else {
        [ADLChatImgPreView showWithContent:self.imgMsgArr index:[self.imgMsgArr indexOfObject:message.content]];
    }
}

#pragma mark ------ 长按消息 ------
- (void)longPressMessage:(JMSGMessage *)message sourceView:(UIView *)sourceView {
    NSInteger second = [ADLUtils getSecondFromStartTimestamp:[message.timestamp doubleValue] endTimestamp:0];
    NSArray *titArr = nil;
    if (second < 175) {
        if (message.contentType == kJMSGContentTypeText) {
            titArr = @[@"复制",@"撤回",@"删除"];
        } else {
            titArr = @[@"撤回",@"删除"];
        }
    } else {
        if (message.contentType == kJMSGContentTypeText) {
            titArr = @[@"复制",@"删除"];
        } else {
            titArr = @[@"删除"];
        }
    }
    
    NSInteger msgIndex = [self.dataArr indexOfObject:message.msgId];
    [ADLMenuView showWithView:sourceView items:titArr finish:^(NSInteger index, NSString *title) {
        if ([title isEqualToString:@"复制"]) {
            JMSGTextContent *textContent = (JMSGTextContent *)message.content;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = textContent.text;
            [ADLToast showMessage:@"复制成功"];
        } else if ([title isEqualToString:@"撤回"]) {
            [self.conversation retractMessage:message completionHandler:^(id resultObject, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [ADLToast showMessage:@"撤回失败"];
                    } else {
                        if (self.msgId && [message.msgId isEqualToString:self.msgId]) {
                            self.msgId = nil;
                            [self.player stop];
                        }
                        if (message.contentType == kJMSGContentTypeImage) {
                            [self.imgMsgArr removeObject:message.content];
                        }
                        
                        JMSGMessage *proMessage = resultObject;
                        ADLChatModel *model = [[ADLChatModel alloc] init];
                        model.type = ADLMessageTypePrompt;
                        model.content = ((JMSGPromptContent *)proMessage.content).promptText;
                        CGFloat contentW = [ADLUtils calculateString:model.content rectSize:CGSizeMake(SCREEN_WIDTH-100, 20) fontSize:12].width+20;
                        model.contentSize = CGSizeMake(contentW, 20);
                        model.rowHeight = 42;
                        [self.messageDict removeObjectForKey:message.msgId];
                        [self.dataArr replaceObjectAtIndex:msgIndex withObject:proMessage.msgId];
                        [self.messageDict setValue:model forKey:proMessage.msgId];
                        
                        NSString *previousId = self.dataArr[msgIndex-1];
                        if ([ADLUtils isPureInt:previousId]) {
                            [self.dataArr removeObject:previousId];
                            [self.messageDict removeObjectForKey:previousId];
                        }
                        [self.tableView reloadData];
                    }
                });
            }];
            
        } else {
            if (self.msgId && [message.msgId isEqualToString:self.msgId]) {
                self.msgId = nil;
                [self.player stop];
            }
            [self.conversation deleteMessageWithMessageId:message.msgId];
            NSString *previousId = self.dataArr[msgIndex-1];
            [self.dataArr removeObject:message.msgId];
            [self.messageDict removeObjectForKey:message.msgId];
            if (message.contentType == kJMSGContentTypeImage) {
                [self.imgMsgArr removeObject:message.content];
            }
            if ([ADLUtils isPureInt:previousId]) {
                [self.dataArr removeObject:previousId];
                [self.messageDict removeObjectForKey:previousId];
            }
            [self.tableView reloadData];
            if (self.dataArr.count == 0) {
                self.emptyBtn.hidden = YES;
            }
        }
    }];
}

#pragma mark ------ 清空消息 ------
- (void)clickEmptyBtn {
    [ADLAlertView showWithTitle:@"提示" message:@"确定要删除所有消息吗？" confirmTitle:nil confirmAction:^{
        [self.conversation deleteAllMessages];
        [self.dataArr removeAllObjects];
        [self.imgMsgArr removeAllObjects];
        [self.messageDict removeAllObjects];
        [self getAllMessage:NO];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.conversation) {
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.movie"]) {
            NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
                if (videoData.length > 31457280) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADLToast showMessage:@"视频最大不能超过30M"];
                    });
                } else {
                    NSString *suffixName = [videoUrl.absoluteString componentsSeparatedByString:@"."].lastObject;
                    if ([suffixName.lowercaseString isEqualToString:@"mp4"]) {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyyMMddHHmmss"];
                        [self dealwithVideoInfo:videoUrl fileName:[formatter stringFromDate:[NSDate date]]];
                    } else {
                        [ADLUtils convertVideoToMp4FromURL:videoUrl finish:^(NSURL *fileUrl, NSString *fileName) {
                            [self dealwithVideoInfo:fileUrl fileName:fileName];
                        }];
                    }
                }
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                JMSGImageContent *imgContent = [[JMSGImageContent alloc] initWithImageData:[ADLUtils compressImageQuality:image maxLength:IMAGE_MAX_LENGTH]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    JMSGMessage *message = [self.conversation createMessageWithContent:imgContent];
                    [self sendMessage:message type:ADLMessageTypeImage];
                    [self.imgMsgArr addObject:message.content];
                });
            });
        }
    } else {
        [ADLToast showMessage:@"会话创建失败，请返回重试！"];
    }
}

#pragma mark ------ 处理选择的视频 ------
- (void)dealwithVideoInfo:(NSURL *)videoUrl fileName:(NSString *)fileName {
    VideoInfo videoInfo = [ADLUtils getVideoInfoWithUrlStr:nil orPathUrl:videoUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (videoUrl) {
            [ADLToast hide];
            NSData *mp4Data = [NSData dataWithContentsOfURL:videoUrl];
            JMSGFileContent *fileContent = [[JMSGFileContent alloc] initWithFileData:mp4Data fileName:[NSString stringWithFormat:@"%@.mp4",fileName]];
            [fileContent addStringExtra:@"mp4" forKey:@"video"];
            JMSGMessage *message = [self.conversation createMessageWithContent:fileContent];
            
            NSString *videoName = [NSString stringWithFormat:@"%@.mp4",message.msgId];
            NSString *thumbnailName = [NSString stringWithFormat:@"%@.jpg",message.msgId];
            BOOL vWrite = [ADLUtils saveObject:mp4Data fileName:videoName permanent:NO];
            BOOL iWrite = [ADLUtils saveObject:UIImageJPEGRepresentation(videoInfo.thumbnail, 0.01) fileName:thumbnailName permanent:NO];
            if (!vWrite || !iWrite) {
                [ADLUtils removeObjectWithFileName:videoName permanent:NO];
                [ADLUtils removeObjectWithFileName:thumbnailName permanent:NO];
            }
            [self sendMessage:message type:ADLMessageTypeFile];
        } else {
            [ADLToast showMessage:@"视频处理失败"];
        }
    });
}

#pragma mark ------ 视频下载完成通知 ------
- (void)viodeImageChanged:(NSNotification *)notification {
    if (notification.object) {
        NSInteger row = [self.dataArr indexOfObject:notification.object];
        ADLChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        ADLChatModel *model = self.messageDict[notification.object];
        if (model && cell) {
            cell.model = model;
        }
    }
}

#pragma mark ------ 发送消息 ------
- (void)sendMessage:(JMSGMessage *)message type:(ADLMessageType)type {
    [self addTimeModelWithTimestamp:[message.timestamp doubleValue] add:YES];
    JMSGOptionalContent *option = [[JMSGOptionalContent alloc] init];
    option.needReadReceipt = YES;
    [self.conversation sendMessage:message optionalContent:option];
    
    ADLChatModel *model = [[ADLChatModel alloc] init];
    model.message = message;
    model.read = NO;
    model.receive = NO;
    model.failed = NO;
    model.sending = YES;
    
    [model updateAttribute:message.content type:type];
    [self.dataArr addObject:message.msgId];
    [self.messageDict setValue:model forKey:message.msgId];
    [self insertRow];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.emptyBtn.hidden = NO;
}

#pragma mark ------ 获取客服信息 ------
- (void)customerInf {
    if (self.goodsId) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.goodsId forKey:@"goodsId"];
        [ADLNetWorkManager postWithPath:k_merchant_im_info parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [self createConversationWithUsername:responseDict[@"data"][@"userName"]];
            }
        } failure:nil];
    } else {
        if (self.userName) {
            [self createConversationWithUsername:self.userName];
        } else {
            [ADLToast showMessage:@"会话创建失败！"];
        }
    }
}

#pragma mark ------ 创建会话 ------
- (void)createConversationWithUsername:(NSString *)userName {
    [JMSGConversation createSingleConversationWithUsername:userName completionHandler:^(id resultObject, NSError *error) {
        if (error) {
            [ADLToast showMessage:@"会话创建失败！"];
        } else {
            self.conversation = [JMSGConversation singleConversationWithUsername:userName];
            [JMessage addDelegate:self withConversation:nil];
            [self getAllMessage:NO];
        }
    }];
}

#pragma mark ------ 获取消息 ------
- (void)getAllMessage:(BOOL)animated {
    NSArray *messageArr = [self.conversation messageArrayFromNewestWithOffset:nil limit:nil];
    for (NSInteger i = messageArr.count-1; i > -1; i--) {
        JMSGMessage *message = messageArr[i];
        if (message.contentType != kJMSGContentTypePrompt) {
            [self addTimeModelWithTimestamp:[message.timestamp doubleValue] add:NO];
        }
        ADLChatModel *model = [[ADLChatModel alloc] init];
        model.message = message;
        if (message.status == kJMSGMessageStatusSendFailed ||
            message.status == kJMSGMessageStatusSendUploadFailed ||
            message.status == kJMSGMessageStatusSending) {
            model.failed = YES;
        } else {
            model.failed = NO;
        }
        model.sending = NO;
        model.receive = message.isReceived;
        model.read = [message getMessageUnreadCount] == 0 ? YES : NO;
        if (message.contentType == kJMSGContentTypeText) {
            [model updateAttribute:message.content type:ADLMessageTypeText];
        } else if (message.contentType == kJMSGContentTypeImage) {
            [self.imgMsgArr addObject:message.content];
            [model updateAttribute:message.content type:ADLMessageTypeImage];
        } else if (message.contentType == kJMSGContentTypeFile) {
            [model updateAttribute:message.content type:ADLMessageTypeFile];
        } else if (message.contentType == kJMSGContentTypeVoice) {
            [model updateAttribute:message.content type:ADLMessageTypeVoice];
        } else if (message.contentType == kJMSGContentTypePrompt) {
            model.type = ADLMessageTypePrompt;
            model.content = ((JMSGPromptContent *)message.content).promptText;
            CGFloat contentW = [ADLUtils calculateString:model.content rectSize:CGSizeMake(SCREEN_WIDTH-100, 20) fontSize:12].width+20;
            model.contentSize = CGSizeMake(contentW, 20);
            model.rowHeight = 42;
        } else {
            
        }
        [self.dataArr addObject:message.msgId];
        [self.messageDict setValue:model forKey:message.msgId];
    }
    [self.tableView reloadData];
    if (self.dataArr.count > 0) {
        self.emptyBtn.hidden = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    } else {
        self.emptyBtn.hidden = YES;
    }
}

#pragma mark ------ 判断消息间隔 ------
- (void)addTimeModelWithTimestamp:(double)timestamp add:(BOOL)add {
    if (self.dataArr.count == 0) {
        [self dealwithTime:timestamp add:add];
    } else {
        ADLChatModel *lastModel = self.messageDict[self.dataArr.lastObject];
        NSInteger second = labs([ADLUtils getSecondFromStartTimestamp:[lastModel.message.timestamp doubleValue] endTimestamp:timestamp]);
        if (second > 300) {
            [self dealwithTime:timestamp add:add];
        }
    }
}

#pragma mark ------ 处理时间 ------
- (void)dealwithTime:(double)timestamp add:(BOOL)add {
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:fromDate]) {
        formatter.dateFormat = @"HH:mm";
    } else if ([calendar isDateInYesterday:fromDate]) {
        formatter.dateFormat = @"昨天 HH:mm";
    } else {
        formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    
    NSString *msgId = [NSString stringWithFormat:@"%08d",arc4random_uniform(99999999)];
    ADLChatModel *model = [[ADLChatModel alloc] init];
    model.type = ADLMessageTypeTime;
    model.content = [formatter stringFromDate:fromDate];
    CGFloat contentW = [ADLUtils calculateString:model.content rectSize:CGSizeMake(SCREEN_WIDTH-100, 20) fontSize:12].width+20;
    model.contentSize = CGSizeMake(contentW, 20);
    model.rowHeight = 42;
    [self.dataArr addObject:msgId];
    [self.messageDict setValue:model forKey:msgId];
    if (add) {
        [self insertRow];
    }
}

#pragma mark ------ 插入行 ------
- (void)insertRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark ------ 发送消息代理 ------
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    ADLChatModel *model = self.messageDict[message.msgId];
    model.read = [message getMessageUnreadCount] == 0 ? YES : NO;
    model.message = message;
    model.sending = NO;
    if (error) {
        model.failed = YES;
    } else {
        model.failed = NO;
    }
    ADLChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:message.msgId] inSection:0]];
    cell.model = model;
    
    if ([message.content.extras[@"resend"] intValue] == 1) {
        [self.dataArr removeAllObjects];
        [self.imgMsgArr removeAllObjects];
        [self.messageDict removeAllObjects];
        [self getAllMessage:YES];
    }
}

#pragma mark ------ 收到消息 ------
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    [self addTimeModelWithTimestamp:[message.timestamp doubleValue] add:YES];
    ADLChatModel *model = [[ADLChatModel alloc] init];
    model.message = message;
    model.receive = YES;
    model.failed = NO;
    model.sending = NO;
    
    JMSGContentType type = message.contentType;
    if (type == kJMSGContentTypeText) {
        [model updateAttribute:message.content type:ADLMessageTypeText];
    } else if (type == kJMSGContentTypeImage) {
        [self.imgMsgArr addObject:message.content];
        [model updateAttribute:message.content type:ADLMessageTypeImage];
    } else if (type == kJMSGContentTypeFile) {
        [model updateAttribute:message.content type:ADLMessageTypeFile];
    } else if (type == kJMSGContentTypeVoice) {
        [model updateAttribute:message.content type:ADLMessageTypeVoice];
    } else {
        
    }
    [self.dataArr addObject:message.msgId];
    [self.messageDict setValue:model forKey:message.msgId];
    [self insertRow];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.emptyBtn.hidden = NO;
}

#pragma mark ------ 消息状态改变 ------
- (void)onReceiveMessageReceiptStatusChangeEvent:(JMSGMessageReceiptStatusChangeEvent *)receiptEvent {
    NSArray *msgArr = receiptEvent.messages;
    for (JMSGMessage *msg in msgArr) {
        ADLChatModel *model = self.messageDict[msg.msgId];
        model.read = [msg getMessageUnreadCount] == 0 ? YES : NO;;
        ADLChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:msg.msgId] inSection:0]];
        [cell updateReadStatus];
    }
}

#pragma mark ------ 懒加载 ------
- (AVAudioRecorder *)recorder {
    if (_recorder == nil) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lockboss.caf"];
        NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatLinearPCM),AVSampleRateKey:@(11025.0),AVNumberOfChannelsKey:@(2),AVEncoderAudioQualityKey:@(AVAudioQualityMin)};
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:settings error:nil];
        [_recorder prepareToRecord];
    }
    return _recorder;
}

#pragma mark ------ 隐藏键盘 ------
- (void)hideKeyboard {
    [self.toolView endEditing];
}

- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
    [JMessage removeDelegate:self withConversation:nil];
}

@end
