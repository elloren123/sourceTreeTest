//
//  ADLTextHeaderView.m
//  lockboss
//
//  Created by adel on 2019/5/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTextHeaderView.h"
#import "ADLGlobalDefine.h"

@implementation ADLTextHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat hei = self.frame.size.height;
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-114, hei)];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textColor = COLOR_666666;
        [self addSubview:titLab];
        self.titLab = titLab;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 0.5)];
        topView.backgroundColor = SEPARATOR_COLOR;
        [self addSubview:topView];
        self.topView = topView;
    }
    return self;
}

@end
