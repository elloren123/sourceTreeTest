//
//  ADLChatBaseCell.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatBaseCell.h"
#import "ADLGlobalDefine.h"
#import "ADLChatModel.h"

#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGMessage.h>

@implementation ADLChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_F2F2F2;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.image = [UIImage imageNamed:@"user_head"];
        iconView.layer.cornerRadius = 3;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UIImageView *resendView = [[UIImageView alloc] init];
        resendView.image = [UIImage imageNamed:@"chat_fail"];
        resendView.contentMode = UIViewContentModeBottom;
        resendView.userInteractionEnabled = YES;
        [self.contentView addSubview:resendView];
        resendView.hidden = YES;
        self.resendView = resendView;
        
        UITapGestureRecognizer *tapResend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickResendMessage)];
        [resendView addGestureRecognizer:tapResend];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.contentView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        UILabel *readLab = [[UILabel alloc] init];
        readLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:readLab];
        self.readLab = readLab;
    }
    return self;
}

- (void)setModel:(ADLChatModel *)model {
    _model = model;
    self.readLab.hidden = YES;
    self.resendView.hidden = YES;
    
    [model.message.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data) {
            self.iconView.image = [UIImage imageWithData:data];
        } else {
            self.iconView.image = [UIImage imageNamed:@"user_head"];
        }
    }];
    
    if (model.receive) {
        self.iconView.frame = CGRectMake(12, 8, 44, 44);
    } else {
        self.iconView.frame = CGRectMake(SCREEN_WIDTH-56, 8, 44, 44);
        if (model.sending) {
            self.indicatorView.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-model.arrowW-94, model.contentSize.height-12, 20, 20);
            [self.indicatorView startAnimating];
        } else {
            [self.indicatorView stopAnimating];
            self.indicatorView.frame = CGRectZero;
        }
        
        if (model.failed) {
            self.resendView.hidden = NO;
            self.resendView.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-model.arrowW-100, model.contentSize.height-32, 36, 40);
        }
        
        if (!model.sending && !model.failed) {
            self.readLab.hidden = NO;
            if (model.read) {
                self.readLab.textColor = COLOR_999999;
                self.readLab.text = @"已读";
            } else {
                self.readLab.textColor = APP_COLOR;
                self.readLab.text = @"未读";
            }
            self.readLab.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-model.arrowW-100, model.contentSize.height-7, 36, 15);
        }
    }
}

#pragma mark ------ 重发 ------
- (void)clickResendMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickResendMessage:)]) {
        [self.delegate didClickResendMessage:self.model];
    }
}

#pragma mark ------ 更新未读状态 ------
- (void)updateReadStatus {
    if (!self.model.sending && !self.model.failed) {
        self.readLab.hidden = NO;
        if (self.model.read) {
            self.readLab.textColor = COLOR_999999;
            self.readLab.text = @"已读";
        } else {
            self.readLab.textColor = APP_COLOR;
            self.readLab.text = @"未读";
        }
        self.readLab.frame = CGRectMake(SCREEN_WIDTH-self.model.contentSize.width-self.model.arrowW-100, self.model.contentSize.height-7, 36, 15);
    }
}

@end
