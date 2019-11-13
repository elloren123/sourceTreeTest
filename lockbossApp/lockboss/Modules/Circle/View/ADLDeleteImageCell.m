//
//  ADLDeleteImageCell.m
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDeleteImageCell.h"

@implementation ADLDeleteImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat wid = self.frame.size.width;
        CGFloat hei = self.frame.size.height;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, wid-5, hei-5)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-30, 0, 30, 30)];
        [deleteBtn setImage:[UIImage imageNamed:@"close_round"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 12, 0);
        [self.contentView addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
}

- (void)clickDeleteBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        [self.delegate didClickDeleteBtn:sender];
    }
}

@end
