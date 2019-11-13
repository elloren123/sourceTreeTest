//
//  ADLSearchFakeView.m
//  lockboss
//
//  Created by Han on 2019/5/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSearchFakeView.h"

@implementation ADLSearchFakeView

+ (instancetype)searchFakeViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    return [[self alloc] initWithFrame:frame placeholder:placeholder];
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViewWithPlaceholder:placeholder];
    }
    return self;
}

- (void)initViewWithPlaceholder:(NSString *)placeholder {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, (hei-34)/2, wid-24, 34)];
    bgView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchView)];
    [bgView addGestureRecognizer:tap];
    
    UIImageView *sImgView = [[UIImageView alloc] initWithFrame:CGRectMake(22, (hei-16)/2, 16, 16)];
    sImgView.image = [UIImage imageNamed:@"home_search"];
    [self addSubview:sImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, (hei-24)/2, wid-70, 24)];
    label.text = placeholder;
    label.clipsToBounds = YES;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self addSubview:label];
}

- (void)clickSearchView {
    if (self.clickSearch) {
        self.clickSearch();
    }
}

@end
