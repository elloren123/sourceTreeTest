//
//  ADLPageControl.m
//  lockboss
//
//  Created by Adel on 2019/11/13.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPageControl.h"

@interface ADLPageControl ()
@property (nonatomic, assign) BOOL flatStyle;
@property (nonatomic, strong) NSMutableArray *dotArr;
@end

@implementation ADLPageControl

- (instancetype)initWithFlatStyle:(BOOL)flatStyle {
    if (self = [super init]) {
        _currentPage = 0;
        _numberOfPages = 0;
        
        self.flatStyle = flatStyle;
        self.dotArr = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)setupSubViews {
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        UIView *dotView = [[UIView alloc] init];
        dotView.layer.cornerRadius = _diameter/2;
        if (self.flatStyle) {
            if (i == 0) {
                dotView.frame = CGRectMake(0, 0, _diameter+10, _diameter);
                dotView.backgroundColor = _selectColor;
            } else {
                dotView.frame = CGRectMake((_diameter+_margin)*i+10, 0, _diameter, _diameter);
                dotView.backgroundColor = _unselectColor;
            }
        } else {
            dotView.frame = CGRectMake((_diameter+_margin)*i, 0, _diameter, _diameter);
            if (i == 0) {
                dotView.backgroundColor = _selectColor;
            } else {
                dotView.backgroundColor = _unselectColor;
            }
        }
        [self addSubview:dotView];
        [self.dotArr addObject:dotView];
    }
}

#pragma mark ------ Setter ------
- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    if (self.dotArr.count > 0) {
        [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.flatStyle) {
                if (idx < self.currentPage) {
                    obj.frame = CGRectMake((self.diameter+margin)*idx, 0, self.diameter, self.diameter);
                } else if (idx == self.currentPage) {
                    obj.frame = CGRectMake((self.diameter+margin)*idx, 0, self.diameter+10, self.diameter);
                } else {
                    obj.frame = CGRectMake((self.diameter+margin)*idx+10, 0, self.diameter, self.diameter);
                }
            } else {
                obj.frame = CGRectMake((self.diameter+margin)*idx, 0, self.diameter, self.diameter);
            }
        }];
    }
}

- (void)setDiameter:(CGFloat)diameter {
    _diameter = diameter;
    if (self.dotArr.count > 0) {
        [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.flatStyle) {
                if (idx < self.currentPage) {
                    obj.frame = CGRectMake((diameter+self.margin)*idx, 0, diameter, diameter);
                } else if (idx == self.currentPage) {
                    obj.frame = CGRectMake((diameter+self.margin)*idx, 0, diameter+10, diameter);
                } else {
                    obj.frame = CGRectMake((diameter+self.margin)*idx+10, 0, diameter, diameter);
                }
            } else {
                obj.frame = CGRectMake((diameter+self.margin)*idx, 0, diameter, diameter);
            }
        }];
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    if (self.dotArr.count > 0) {
        [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == self.currentPage) {
                obj.backgroundColor = selectColor;
            }
        }];
    }
}

- (void)setUnselectColor:(UIColor *)unselectColor {
    _unselectColor = unselectColor;
    if (self.dotArr.count > 0) {
        [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != self.currentPage) {
                obj.backgroundColor = unselectColor;
            }
        }];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        if (self.flatStyle) {
            [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < currentPage) {
                    obj.frame = CGRectMake((self.diameter+self.margin)*idx, 0, self.diameter, self.diameter);
                    obj.backgroundColor = self.unselectColor;
                } else if (idx == currentPage) {
                    obj.frame = CGRectMake((self.diameter+self.margin)*idx, 0, self.diameter+10, self.diameter);
                    obj.backgroundColor = self.selectColor;
                } else {
                    obj.frame = CGRectMake((self.diameter+self.margin)*idx+10, 0, self.diameter, self.diameter);
                    obj.backgroundColor = self.unselectColor;
                }
            }];
        } else {
            [self.dotArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == currentPage) {
                    obj.backgroundColor = self.selectColor;
                } else {
                    obj.backgroundColor = self.unselectColor;
                }
            }];
        }
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        for (UIView *dot in self.dotArr) {
            [dot removeFromSuperview];
        }
        [self.dotArr removeAllObjects];
        [self setupSubViews];
    }
}

@end
