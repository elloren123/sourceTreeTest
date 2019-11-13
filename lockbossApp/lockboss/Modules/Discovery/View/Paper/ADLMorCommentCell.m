//
//  ADLMorCommentCell.m
//  lockboss
//
//  Created by adel on 2019/5/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMorCommentCell.h"

@implementation ADLMorCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconView:)];
    [self.iconView addGestureRecognizer:tap];
}

- (void)clickIconView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickIconImageView:)]) {
        [self.delegate didClickIconImageView:(UIImageView *)tap.view];
    }
}

- (IBAction)clickLikeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLikeButton:)]) {
        [self.delegate didClickLikeButton:sender];
    }
}

@end
