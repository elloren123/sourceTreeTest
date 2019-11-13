//
//  ADLCircleHeadView.m
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCircleHeadView.h"
#import "ADLSearchFakeView.h"
#import "ADLGlobalDefine.h"
#import "ADLLocalizedHelper.h"
#import <UIImageView+WebCache.h>

@interface ADLCircleHeadView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) NSMutableArray *nameLabArr;
@end

@implementation ADLCircleHeadView

+ (instancetype)groupHeadViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_F2F2F2;
        self.clipsToBounds = YES;
        [self chuShiHuaShiTu];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)chuShiHuaShiTu {
    __weak typeof(self)weakSelf = self;
    ADLSearchFakeView *fakeView = [ADLSearchFakeView searchFakeViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) placeholder:@"搜索群组名称"];
    fakeView.clickSearch = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickSearchView)]) {
            [weakSelf.delegate didClickSearchView];
        }
    };
    [self addSubview:fakeView];
    
    UIView *choicenessView = [[UIView alloc] initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, VIEW_HEIGHT+109)];
    choicenessView.backgroundColor = [UIColor whiteColor];
    [self addSubview:choicenessView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, VIEW_HEIGHT)];
    lab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    lab.textColor = COLOR_333333;
    lab.text = @"精选群组";
    [choicenessView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATOR_COLOR;
    [choicenessView addSubview:line];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT+1, SCREEN_WIDTH, 109)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [choicenessView addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat imgW = 60;
    CGFloat gap = 20;
    NSInteger count = floor((SCREEN_WIDTH)/(imgW+gap));
    self.imageViewArr = [[NSMutableArray alloc] init];
    self.nameLabArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12+(imgW+gap)*(i%count), 12, imgW, imgW)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"group_head"];
        imgView.layer.cornerRadius = imgW/2;
        imgView.clipsToBounds = YES;
        [scrollView addSubview:imgView];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12+(i%count)*(imgW+gap), 82, imgW, 16)];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.textColor = COLOR_333333;
        nameLab.text = ADLString(@"loading");
        [scrollView addSubview:nameLab];
        
        [self.imageViewArr addObject:imgView];
        [self.nameLabArr addObject:nameLab];
    }
}

#pragma mark ------ 点击图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageView:)]) {
        [self.delegate didClickImageView:self.dataArr[tap.view.tag]];
    }
}

#pragma mark ------ Setter ------
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.imageViewArr removeAllObjects];
    [self.nameLabArr enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.nameLabArr removeAllObjects];
    
    CGFloat imgW = 60;
    CGFloat gap = 20;
    NSInteger count = dataArr.count;
    self.scrollView.contentSize = CGSizeMake((imgW+gap)*count-gap+24, 109);
    for (int i = 0; i < count; i++) {
        NSDictionary *dict = dataArr[i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12+(imgW+gap)*(i%count), 12, imgW, imgW)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"group_head"];
        imgView.userInteractionEnabled = YES;
        imgView.layer.cornerRadius = imgW/2;
        imgView.clipsToBounds = YES;
        imgView.tag = i;
        [imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
        [self.scrollView addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imgView addGestureRecognizer:tap];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12+(i%count)*(imgW+gap), 82, imgW, 16)];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.textColor = COLOR_333333;
        nameLab.text = dict[@"name"];
        [self.scrollView addSubview:nameLab];
        
        [self.imageViewArr addObject:imgView];
        [self.nameLabArr addObject:nameLab];
    }
}

@end
