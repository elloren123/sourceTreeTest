//
//  ADLGoodsReplyHead.m
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsReplyHead.h"
#import "ADLImagePreView.h"

@implementation ADLGoodsReplyHead

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView)];
    [self.imgView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentLab)];
    [self.contentLab addGestureRecognizer:contentTap];
}

- (void)clickImgView {
    if (self.headShot.length > 0) {
        [ADLImagePreView showWithImageViews:@[self.imgView] urlArray:@[self.headShot] currentIndex:0];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserIcon)]) {
        [self.delegate didClickUserIcon];
    }
}

- (void)clickContentLab {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickContentLab:)]) {
        [self.delegate didClickContentLab:self.contentLab];
    }
}

@end
