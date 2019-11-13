//
//  ADLSelectImageCell.m
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectImageCell.h"

@implementation ADLSelectImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        CGFloat wid = self.frame.size.width;
        CGFloat hei = self.frame.size.height;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hei)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-30, 0, 30, 30)];
        [checkBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        checkBtn.imageEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, -6);
        [self.contentView addSubview:checkBtn];
        checkBtn.userInteractionEnabled = NO;
        self.checkBtn = checkBtn;
    }
    return self;
}

@end
