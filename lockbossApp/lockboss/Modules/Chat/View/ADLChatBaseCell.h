//
//  ADLChatBaseCell.h
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLChatModel;

@class JMSGMessage;

@protocol ADLChatCellDelegate <NSObject>

- (void)didClickResendMessage:(ADLChatModel *)model;

- (void)didClickImageMessage:(JMSGMessage *)message;

- (void)longPressMessage:(JMSGMessage *)message sourceView:(UIView *)sourceView;

- (void)playVoiceMessage:(JMSGMessage *)message;

@end

@interface ADLChatBaseCell : UITableViewCell

///代理
@property (nonatomic, weak) id<ADLChatCellDelegate> delegate;

///用户头像
@property (nonatomic, strong) UIImageView *iconView;

///加载动画
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

///重发
@property (nonatomic, strong) UIImageView *resendView;

///消息状态Label
@property (nonatomic, strong) UILabel *readLab;

///消息模型
@property (nonatomic, strong) ADLChatModel *model;

///更新未读状态
- (void)updateReadStatus;

@end
