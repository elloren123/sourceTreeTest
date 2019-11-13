//
//  ADLChatImageCell.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatImageCell.h"
#import "ADLGlobalDefine.h"
#import "ADLChatModel.h"
#import "ADLUtils.h"

#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGFileContent.h>
#import <JMessage/JMSGImageContent.h>

@interface ADLChatImageCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *videoView;
@property (nonatomic, strong) UILabel *durationLab;
@end

@implementation ADLChatImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.backgroundColor = COLOR_D3D3D3;
        imgView.layer.cornerRadius = 6;
        imgView.clipsToBounds = YES;
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView)];
        [imgView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
        [imgView addGestureRecognizer:longPress];
        
        UIImageView *videoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_play"]];
        [self.contentView addSubview:videoView];
        self.videoView = videoView;
        
        UILabel *durationLab = [[UILabel alloc] init];
        durationLab.font = [UIFont systemFontOfSize:12];
        durationLab.textColor = [UIColor whiteColor];
        durationLab.textAlignment = NSTextAlignmentRight;
        [imgView addSubview:durationLab];
        self.durationLab = durationLab;
    }
    return self;
}

- (void)setModel:(ADLChatModel *)model {
    [super setModel:model];
    
    self.imgView.image = nil;
    if (model.receive) {
        self.imgView.frame = CGRectMake(64, 8, model.contentSize.width, model.contentSize.height);
    } else {
        self.imgView.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-64, 8, model.contentSize.width, model.contentSize.height);
    }
    
    if (model.message.contentType == kJMSGContentTypeImage) {
        self.videoView.hidden = YES;
        self.durationLab.hidden = YES;
        JMSGImageContent *imgContent = (JMSGImageContent *)model.message.content;
        [imgContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            self.imgView.image = [UIImage imageWithData:data];
        }];
    } else {
        self.videoView.hidden = NO;
        self.videoView.center = self.imgView.center;
        if (model.content) {
            self.durationLab.hidden = NO;
            self.durationLab.text = model.duration;
            self.durationLab.frame = CGRectMake(10, model.contentSize.height-23, model.contentSize.width-20, 20);
            self.imgView.image = [UIImage imageWithContentsOfFile:model.content];
        } else {
            self.durationLab.hidden = YES;
        }
    }
}

- (void)clickImgView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageMessage:)]) {
        [self.delegate didClickImageMessage:self.model.message];
    }
}

- (void)longPressGes:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressMessage:sourceView:)]) {
            [self.delegate longPressMessage:self.model.message sourceView:longPress.view];
        }
    }
}

@end
