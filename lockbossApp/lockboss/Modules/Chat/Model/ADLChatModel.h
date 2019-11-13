//
//  ADLChatModel.h
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADLMessageType) {
    ADLMessageTypeTime,
    ADLMessageTypeText,
    ADLMessageTypeVoice,
    ADLMessageTypeImage,
    ADLMessageTypeFile,
    ADLMessageTypePrompt
};

@class JMSGMessage;
@class JMSGAbstractContent;
@interface ADLChatModel : NSObject

///消息主体
@property (nonatomic, strong) JMSGMessage *message;

///消息类型
@property (nonatomic, assign) ADLMessageType type;

///时间、消息文本内容
@property (nonatomic, strong) NSString *content;

///消息尺寸
@property (nonatomic, assign) CGSize contentSize;

///消息高度
@property (nonatomic, assign) CGFloat rowHeight;

///箭头宽
@property (nonatomic, assign) CGFloat arrowW;

///是否正在发送
@property (nonatomic, assign) BOOL sending;

///是否发送失败
@property (nonatomic, assign) BOOL failed;

///是否是收到消息
@property (nonatomic, assign) BOOL receive;

///消息是否是已读
@property (nonatomic, assign) BOOL read;

///视频时长
@property (nonatomic, strong) NSString *duration;

///是否正在播放语音
@property (nonatomic, assign) BOOL playing;

///语音播放动画数组
@property (nonatomic, strong) NSArray *playArr;

///更新属性值
- (void)updateAttribute:(JMSGAbstractContent *)content type:(ADLMessageType)type;

@end
