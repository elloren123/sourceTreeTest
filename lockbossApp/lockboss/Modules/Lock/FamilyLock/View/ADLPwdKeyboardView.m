//
//  ADLPwdKeyboardView.m
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPwdKeyboardView.h"

@implementation ADLPwdKeyboardView

+ (instancetype)keyboardView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_F2F2F2;
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        spView.backgroundColor = COLOR_E5E5E5;
        [self addSubview:spView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 44)];
        [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tag = 4;
        [self addSubview:closeBtn];
        
        NSArray *imgArr = @[@"keyboard_0",@"keyboard_1",@"keyboard_2",@"keyboard_3"];
        for (int i = 0; i < 4; i++) {
            UIButton *numBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-292)/2+(i%4)*77, 60, 61, 40)];
            [numBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [numBtn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
            numBtn.tag = i;
            [self addSubview:numBtn];
        }
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-61)/2, 160, 61, 40)];
        [delBtn setImage:[UIImage imageNamed:@"keyboard_del"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        delBtn.tag = 5;
        [self addSubview:delBtn];
    }
    return self;
}

- (void)clickActionBtn:(UIButton *)sender {
    if (self.clickAction) {
        self.clickAction(sender.tag);
    }
}

@end
