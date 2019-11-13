//
//  ADLAfterRecordCell.m
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAfterRecordCell.h"
#import "ADLImagePreView.h"

@implementation ADLAfterRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImageView {
    if (self.imgUrl) {
        [ADLImagePreView showWithImageViews:@[self.imgView] urlArray:@[self.imgUrl] currentIndex:0];
    }
}

@end
