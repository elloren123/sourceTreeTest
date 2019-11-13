//
//  ADLGoodsLSReportCell.m
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsLSReportCell.h"
#import "ADLImagePreView.h"
#import "ADLGlobalDefine.h"

#import <UIImageView+WebCache.h>

@interface ADLGoodsLSReportCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ADLGoodsLSReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgSize:(CGSize)imgSize {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imgSize.width)/2, 0, imgSize.width, imgSize.height)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center = CGPointMake(self.center.x, imgSize.height+15);
        pageControl.pageIndicatorTintColor = SEPARATOR_COLOR;
        pageControl.currentPageIndicatorTintColor = APP_COLOR;
        pageControl.transform = CGAffineTransformMakeScale(1.3, 1.3);
        pageControl.currentPage = 0;
        [self.contentView addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setUrlArr:(NSArray *)urlArr {
    if (urlArr.count == 0) return;
    if (_urlArr.count == 0) {
        _urlArr = urlArr;
        NSInteger count = urlArr.count;
        CGFloat scrollW = self.scrollView.frame.size.width;
        CGFloat scrollH = self.scrollView.frame.size.height;
        self.scrollView.contentSize = CGSizeMake(scrollW*count, scrollH);
        self.pageControl.numberOfPages = count;
        for (int i = 0; i < count; i++) {
            [self creatImageimgWithFrame:CGRectMake(i*scrollW, 0, scrollW, scrollH) urlStr:urlArr[i] tag:i];
        }
    }
}

#pragma mark ------ 创建UIImageView ------
- (void)creatImageimgWithFrame:(CGRect)frame urlStr:(NSString *)urlStr tag:(NSInteger)tag {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.userInteractionEnabled = YES;
    imgView.clipsToBounds = YES;
    imgView.tag = tag;
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [imgView addGestureRecognizer:tap];
    [self.scrollView addSubview:imgView];
}

#pragma mark ------ 点击图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    [ADLImagePreView showWithImageViews:@[imageView] urlArray:self.urlArr currentIndex:imageView.tag];
}

#pragma mark ------ ScrollView代理 ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger index = (scrollView.contentOffset.x+0.5*width)/width;
    self.pageControl.currentPage = index;
}

@end
