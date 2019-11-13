//
//  ADLGoodsAttrReuseView.m
//  lockboss
//
//  Created by adel on 2019/4/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsAttrFooter.h"
#import "ADLGlobalDefine.h"
#import "ADLUtils.h"

@interface ADLGoodsAttrFooter ()<UITextFieldDelegate>

@end

@implementation ADLGoodsAttrFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat hei = self.frame.size.height;
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-114, hei)];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textColor = COLOR_666666;
        titLab.text = @"购买数量";
        [self addSubview:titLab];
        self.titLab = titLab;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 0.5)];
        topView.backgroundColor = SEPARATOR_COLOR;
        [self addSubview:topView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(12, hei-0.5, SCREEN_WIDTH-24, 0.5)];
        bottomView.backgroundColor = SEPARATOR_COLOR;
        [self addSubview:bottomView];
        
        CGFloat H = 30;
        CGFloat Y1 = (hei-H)/2;
        CGFloat Y2 = (hei+H)/2;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(SCREEN_WIDTH-12, Y1)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12-H*3, Y1)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12-H*3, Y2)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12, Y2)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12, Y1)];
        [path moveToPoint:CGPointMake(SCREEN_WIDTH-12-H*2, Y1)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12-H*2, Y2)];
        [path moveToPoint:CGPointMake(SCREEN_WIDTH-12-H, Y1)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH-12-H, Y2)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 0.5;
        shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        shapeLayer.strokeColor = COLOR_D3D3D3.CGColor;
        [self.layer addSublayer:shapeLayer];
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        reduceBtn.frame = CGRectMake(SCREEN_WIDTH-12-H*3, Y1, H, H);
        [reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        reduceBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
        [reduceBtn addTarget:self action:@selector(clickReduceBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reduceBtn];
        self.reduceBtn = reduceBtn;
        
        UITextField *numTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-12-H*2, Y1, H, H)];
        numTF.font = [UIFont systemFontOfSize:FONT_SIZE];
        numTF.keyboardType = UIKeyboardTypeNumberPad;
        numTF.textAlignment = NSTextAlignmentCenter;
        numTF.returnKeyType = UIReturnKeyDone;
        numTF.textColor = COLOR_333333;
        [self addSubview:numTF];
        numTF.delegate = self;
        numTF.text = @"1";
        self.numTF = numTF;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        addBtn.frame = CGRectMake(SCREEN_WIDTH-12-H, Y1, H, H);
        [addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
    }
    return self;
}

#pragma mark ------ 减少 ------
- (void)clickReduceBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedCount:footerView:)]) {
        [self.delegate didChangedCount:[self.numTF.text integerValue]-1 footerView:self];
    }
}

#pragma mark ------ 增加 ------
- (void)clickAddBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedCount:footerView:)]) {
        [self.delegate didChangedCount:[self.numTF.text integerValue]+1 footerView:self];
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginEditing:)]) {
        [self.delegate didBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedCount:footerView:)]) {
        [self.delegate didChangedCount:[textField.text integerValue] footerView:self];
    }
}

@end
