//
//  ADLTopicCommentCell.m
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTopicCommentCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLTopicCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.userInteractionEnabled = YES;
        contentLab.textColor = COLOR_666666;
        [self.contentView addSubview:contentLab];
        contentLab.numberOfLines = 0;
        self.contentLab = contentLab;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentLab:)];
        [contentLab addGestureRecognizer:tap];
    }
    return self;
}

- (void)clickContentLab:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReplyLabel:)]) {
        [self.delegate didClickReplyLabel:(UILabel *)tap.view];
    }
}

- (void)layoutSubviews {
    self.contentLab.frame = CGRectMake(73, 0, SCREEN_WIDTH-85, self.frame.size.height);
    self.bgView.frame = CGRectMake(66, 0, SCREEN_WIDTH-78, self.frame.size.height);
}

@end
