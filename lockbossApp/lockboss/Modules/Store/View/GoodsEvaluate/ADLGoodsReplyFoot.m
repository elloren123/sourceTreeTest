//
//  ADLGoodsReplyFoot.m
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsReplyFoot.h"

@implementation ADLGoodsReplyFoot

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.bgView = bgView;
        
        UIImageView *foldImg = [[UIImageView alloc] init];
        foldImg.contentMode = UIViewContentModeCenter;
        [self addSubview:foldImg];
        self.foldImg = foldImg;
        
        UILabel *foldLab = [[UILabel alloc] init];
        foldLab.font = [UIFont systemFontOfSize:12];
        foldLab.userInteractionEnabled = YES;
        foldLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self addSubview:foldLab];
        self.foldLab = foldLab;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFoldLab)];
        [foldLab addGestureRecognizer:tap];
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [bgView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

- (void)clickFoldLab {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFoldLab:)]) {
        [self.delegate didClickFoldLab:self.foldLab];
    }
}

- (void)layoutSubviews {
    CGFloat hei = self.frame.size.height;
    CGFloat wid = self.frame.size.width;
    self.bgView.frame = CGRectMake(0, 0, wid, hei);
    if (hei == 12) {
        self.foldLab.hidden = YES;
        self.foldImg.hidden = YES;
        self.spView.frame = CGRectMake(12, 11.5, wid-12, 0.5);
    } else {
        self.foldLab.hidden = NO;
        self.foldImg.hidden = NO;
        self.foldLab.frame = CGRectMake(66, 0, 60, hei);
        self.foldImg.frame = CGRectMake(96, 0, 9, hei);
        self.spView.frame = CGRectMake(12, hei-0.5, wid-12, 0.5);
    }
}

@end
