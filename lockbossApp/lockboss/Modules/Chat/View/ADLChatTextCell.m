//
//  ADLChatTextCell.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatTextCell.h"
#import "ADLGlobalDefine.h"
#import "ADLChatModel.h"

@interface ADLChatTextCell ()
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *bubbleView;
@end

@implementation ADLChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIImageView *arrowView = [[UIImageView alloc] init];
        [self.contentView addSubview:arrowView];
        self.arrowView = arrowView;
        
        UIView *bubbleView = [[UIView alloc] init];
        bubbleView.layer.cornerRadius = 6;
        [self.contentView addSubview:bubbleView];
        self.bubbleView = bubbleView;
        
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        contentLab.numberOfLines = 0;
        [bubbleView addSubview:contentLab];
        self.contentLab = contentLab;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressContentLab:)];
        [bubbleView addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark ------ 长按 ------
- (void)longPressContentLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressMessage:sourceView:)]) {
            [self.delegate longPressMessage:self.model.message sourceView:longPress.view];
        }
    }
}

#pragma mark ------ 赋值 ------
- (void)setModel:(ADLChatModel *)model {
    [super setModel:model];
    self.contentLab.text = model.content;
    self.contentLab.frame = CGRectMake(11, 10, model.contentSize.width-22, model.contentSize.height-20);
    if (model.receive) {
        self.arrowView.frame = CGRectMake(64, 23.5, 7, 13);
        self.arrowView.image = [UIImage imageNamed:@"chat_arow_w"];
        self.bubbleView.backgroundColor = [UIColor whiteColor];
        self.bubbleView.frame = CGRectMake(71, 8, model.contentSize.width, model.contentSize.height);
        self.contentLab.textColor = COLOR_333333;
    } else {
        self.arrowView.frame = CGRectMake(SCREEN_WIDTH-71, 23.5, 7, 13);
        self.arrowView.image = [UIImage imageNamed:@"chat_arow_r"];
        self.bubbleView.backgroundColor = [UIColor colorWithRed:1 green:81/255.0 blue:71/255.0 alpha:1];
        self.bubbleView.frame = CGRectMake(SCREEN_WIDTH-model.contentSize.width-71, 8, model.contentSize.width, model.contentSize.height);
        self.contentLab.textColor = [UIColor whiteColor];
    }
}

@end
