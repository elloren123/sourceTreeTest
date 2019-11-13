//
//  ADLHomeCellView.m
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLHomeCellView.h"
#import "ADLGlobalDefine.h"

@implementation ADLHomeCellView

+ (instancetype)cellViewWithFrame:(CGRect)frame gap:(CGFloat)gap cellW:(CGFloat)cellW {
    return [[self alloc] initWithFrame:frame gap:gap cellW:cellW];
}

- (instancetype)initWithFrame:(CGRect)frame gap:(CGFloat)gap cellW:(CGFloat)cellW {
    if (self = [super initWithFrame:frame]) {
        NSArray *titleArr = @[@"手机开门",@"酒店预订",@"商城",@"开锁换锁",@"进圈子",@"敬请期待"];
        NSArray *imageArr = @[@"home_sjkm",@"home_msgn",@"home_sc",@"home_kshs",@"home_jqz",@"home_jqqd"];
        for (int i = 0; i < 6; i++) {
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(gap+(cellW+gap)*(i%3), gap+(cellW+gap)*(i/3), cellW, cellW)];
            cellView.backgroundColor = [UIColor whiteColor];
            cellView.layer.cornerRadius = 5;
            cellView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCellView:)];
            [cellView addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArr[i]]];
            CGRect imgViewF = imageView.frame;
            imgViewF.origin.x = (cellW-imgViewF.size.width)/2;
            imgViewF.origin.y = (cellW-imgViewF.size.height)/2-13;
            imageView.frame = imgViewF;
            [cellView addSubview:imageView];
            
            CGFloat labelH = cellW-imgViewF.size.height-imgViewF.origin.y;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gap, cellW-labelH , cellW-gap*2, labelH)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:FONT_SIZE];
            if (SCREEN_WIDTH == 320) {
                label.font = [UIFont systemFontOfSize:14];
            }
            label.textColor = COLOR_333333;
            label.numberOfLines = 0;
            label.text = titleArr[i];
            [cellView addSubview:label];
            [self addSubview:cellView];
        }
    }
    return self;
}

- (void)clickCellView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCellAtIndex:)]) {
        [self.delegate didClickCellAtIndex:tap.view.tag];
    }
}

@end
