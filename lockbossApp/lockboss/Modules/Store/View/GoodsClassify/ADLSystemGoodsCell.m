//
//  ADLSystemGoodsCell.m
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSystemGoodsCell.h"
#import "ADLImagePreView.h"

@implementation ADLSystemGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImgView:(UITapGestureRecognizer *)tap {
    if (self.imgUrl) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[self.imgUrl] currentIndex:0];
    }
}

@end
