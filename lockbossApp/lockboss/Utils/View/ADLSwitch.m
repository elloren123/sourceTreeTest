//
//  ADLSwitch.m
//  lockboss
//
//  Created by Adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSwitch.h"

@interface ADLSwitch ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) UIView *roundView;
@end

@implementation ADLSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _on = YES;
        _open = YES;
        _roundColor = [UIColor whiteColor];
        _openColor = [UIColor colorWithRed:71/255.0 green:229/255.0 blue:0 alpha:1];
        _closeColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.backgroundColor = _openColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicSwitchView)];
        [self addGestureRecognizer:tap];
        
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height+1.5, 1.5, frame.size.height-3, frame.size.height-3)];
        roundView.layer.cornerRadius = (frame.size.height-3)/2;
        roundView.backgroundColor = _roundColor;
        [self addSubview:roundView];
        self.roundView = roundView;
    }
    return self;
}

#pragma mark ------ 添加点击事件 ------
- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

#pragma mark ------ 点击事件 ------
- (void)clicSwitchView {
    if (_target && _action) {
        [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:NO];
    }
}

#pragma mark ------ 赋值 ------
- (void)setOn:(BOOL)on {
    if (_on != on) {
        _on = on;
        _open = on;
        CGFloat wid = self.frame.size.width;
        CGFloat hei = self.frame.size.height;
        if (on) {
            [UIView animateWithDuration:0.25 animations:^{
                self.backgroundColor = self->_openColor;
                self.roundView.frame = CGRectMake(wid-hei+1.5, 1.5, hei-3, hei-3);
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.backgroundColor = self->_closeColor;
                self.roundView.frame = CGRectMake(1.5, 1.5, hei-3, hei-3);
            }];
        }
    }
}

- (void)setOpen:(BOOL)open {
    if (_open != open) {
        _open = open;
        _on = open;
        CGFloat wid = self.frame.size.width;
        CGFloat hei = self.frame.size.height;
        if (open) {
            self.backgroundColor = _openColor;
            self.roundView.frame = CGRectMake(wid-hei+1.5, 1.5, hei-3, hei-3);
        } else {
            self.backgroundColor = _closeColor;
            self.roundView.frame = CGRectMake(1.5, 1.5, hei-3, hei-3);
        }
    }
}

- (void)setCloseColor:(UIColor *)closeColor {
    _closeColor = closeColor;
    if (_on == NO) {
        self.backgroundColor = closeColor;
    }
}

- (void)setOpenColor:(UIColor *)openColor {
    _openColor = openColor;
    if (_on == YES) {
        self.backgroundColor = openColor;
    }
}

- (void)setRoundColor:(UIColor *)roundColor {
    _roundColor = roundColor;
    self.roundView.backgroundColor = roundColor;
}

@end
