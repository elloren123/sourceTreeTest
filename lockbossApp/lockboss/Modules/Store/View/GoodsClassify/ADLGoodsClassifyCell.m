//
//  ADLGoodsClassifyCell.m
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsClassifyCell.h"
#import "ADLImagePreView.h"

@implementation ADLGoodsClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImgView:(UITapGestureRecognizer *)tap {
    if (self.imgUrl.length > 0) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[self.imgUrl] currentIndex:0];
    }
}

@end
