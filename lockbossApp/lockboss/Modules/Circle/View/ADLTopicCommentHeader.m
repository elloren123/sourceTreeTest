//
//  ADLTopicCommentHeader.m
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTopicCommentHeader.h"

@implementation ADLTopicCommentHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeadImage:)];
    [self.imgView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentLabel:)];
    [self.contentLab addGestureRecognizer:tapContent];
}

- (void)clickUserHeadImage:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentHeadImage:)]) {
        [self.delegate didClickCommentHeadImage:(UIImageView *)tap.view];
    }
}

- (void)tapContentLabel:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentContentLab:)]) {
        UILabel *label = (UILabel *)tap.view;
        [UIView animateWithDuration:0.3 animations:^{
            label.alpha = 0.5;
        } completion:^(BOOL finished) {
            label.textColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1];
        }];
        [self.delegate didClickCommentContentLab:label];
    }
}

- (IBAction)clickPraiseBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentPraiseBtn:)]) {
        [self.delegate didClickCommentPraiseBtn:sender];
    }
}

- (IBAction)clickCommentBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentReplyBtn:contentLab:)]) {
        [self.delegate didClickCommentReplyBtn:sender contentLab:self.contentLab];
    }
}

@end
