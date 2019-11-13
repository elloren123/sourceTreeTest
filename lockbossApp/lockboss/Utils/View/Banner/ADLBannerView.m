//
//  ADLBannerView.m
//  lockboss
//
//  Created by Adel on 2019/11/13.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBannerView.h"
#import "ADLPageControl.h"
#import "ADLBannerCell.h"

#import <UIImageView+WebCache.h>

@interface ADLBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADLPageControl *pageControl;
@property (nonatomic, assign) ADLPagePosition position;
@property (nonatomic, assign) ADLPageStyle pageStyle;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *urlKey;
@end

@implementation ADLBannerView

- (instancetype)initWithFrame:(CGRect)frame position:(ADLPagePosition)position style:(ADLPageStyle)style {
    if (self = [super initWithFrame:frame]) {
        _timeInterval = 3;
        _leftMargin = 13;
        _rightMargin = 13;
        _bottomMargin = 13;
        _selectColor = [UIColor whiteColor];
        _unselectColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        
        if (style == ADLPageStyleRound) {
            _diameter = 8;
            _dotMargin = 9;
        } else {
            _diameter = 6;
            _dotMargin = 6;
        }
        
        self.pageStyle = style;
        self.position = position;
        self.urlKey = @"linkUrl";
        self.backgroundColor = [UIColor whiteColor];
        self.urlArr = [[NSMutableArray alloc] init];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        layout.minimumLineSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.scrollEnabled = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView registerClass:[ADLBannerCell class] forCellWithReuseIdentifier:@"banner"];
        
        ADLPageControl *pageControl = [[ADLPageControl alloc] initWithFlatStyle:style];
        pageControl.unselectColor = _unselectColor;
        pageControl.selectColor = _selectColor;
        pageControl.diameter = _diameter;
        pageControl.margin = _dotMargin;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

#pragma mark ------ UICollectionViewDelegate && UICollectionViewDataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.urlArr.count > 1 ? 60 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"banner" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count > indexPath.item) {
        NSString *linkUrl = self.dataArr[indexPath.item][self.urlKey];
        linkUrl = [linkUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.clickBanner && linkUrl.length > 0) {
            self.clickBanner(linkUrl);
        }
    }
}

#pragma mark ------ 更新Banner ------
- (void)updateBanner:(NSArray *)dataArr imgKey:(NSString *)imgKey urlKey:(NSString *)urlKey {
    if (dataArr.count > 0) {
        NSString *imageKey = @"bannerImgUrl";
        if (imgKey.length > 0) imageKey = imgKey;
        if (urlKey.length > 0) self.urlKey = urlKey;
        
        NSString *currentStr = [self.urlArr componentsJoinedByString:@","];
        [self.urlArr removeAllObjects];
        for (NSDictionary *dict in dataArr) {
            [self.urlArr addObject:[dict[imageKey] stringValue]];
        }
        
        NSString *updateStr = [self.urlArr componentsJoinedByString:@","];
        if (![currentStr isEqualToString:updateStr]) {
            [self refreshBanner];
        }
    } else {
        if (self.urlArr.count > 0) {
            [self.urlArr removeAllObjects];
            [self refreshBanner];
        }
    }
    self.dataArr = dataArr;
    self.itemCount = dataArr.count;
}

- (void)updateBanner:(NSArray *)urlArr {
    if (urlArr.count > 0) {
        NSString *currentStr = [self.urlArr componentsJoinedByString:@","];
        NSString *updateStr = [urlArr componentsJoinedByString:@","];
        if (![currentStr isEqualToString:updateStr]) {
            [self.urlArr removeAllObjects];
            [self.urlArr addObjectsFromArray:urlArr];
            [self refreshBanner];
        }
    } else {
        if (self.urlArr.count > 0) {
            [self.urlArr removeAllObjects];
            [self refreshBanner];
        }
    }
    self.dataArr = nil;
    self.itemCount = urlArr.count;
}

#pragma mark ------ 刷新Banner ------
- (void)refreshBanner {
    [self.collectionView reloadData];
    
    if (self.urlArr.count > 1) {
        self.pageControl.hidden = NO;
        self.collectionView.scrollEnabled = YES;
        [self.collectionView setContentOffset:CGPointMake(self.urlArr.count*self.frame.size.width*29, 0) animated:NO];
        
        self.pageControl.numberOfPages = self.urlArr.count;
        [self updatePageControlFrame];
        [self startTimer];
    } else {
        [self.timer invalidate];
        self.collectionView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
    }
}

#pragma mark ------ Timer ------
- (void)startTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark ------ 切换图片 ------
- (void)switchImage {
    double index = floor(self.collectionView.contentOffset.x/self.frame.size.width);
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width*(index+1), 0) animated:YES];
}

#pragma mark ------ 更新PageControl Frame ------
- (void)updatePageControlFrame {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    CGFloat pageW = self.urlArr.count*(_diameter+_dotMargin)-_dotMargin;
    if (self.pageStyle == ADLPageStyleFlat) {
        pageW = pageW+10;
    }
    if (self.position == ADLPagePositionLeft) {
        self.pageControl.frame = CGRectMake(_leftMargin, hei-_bottomMargin-_diameter, pageW, _diameter);
    } else if (self.position == ADLPagePositionRight) {
        self.pageControl.frame = CGRectMake(wid-_rightMargin-pageW, hei-_bottomMargin-_diameter, pageW, _diameter);
    } else {
        self.pageControl.frame = CGRectMake((wid-pageW)/2, hei-_bottomMargin-_diameter, pageW, _diameter);
    }
}

#pragma mark ------ ScrollView代理 ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = 0;
    CGFloat middleX = scrollView.contentOffset.x+self.frame.size.width/2;
    NSInteger index = middleX/self.frame.size.width;
    if (index < 0) {
        index = 0;
    }
    if (index >= self.urlArr.count*60) {
        index = self.urlArr.count*60-1;
    }
    currentIndex = index%self.urlArr.count;
    self.pageControl.currentPage = currentIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = 0;
    CGFloat middleX = scrollView.contentOffset.x+self.frame.size.width/2;
    NSInteger index = middleX/self.frame.size.width;
    if (index < 0) {
        index = 0;
    }
    if (index >= self.urlArr.count*60) {
        index = self.urlArr.count*60-1;
    }
    currentIndex = index%self.urlArr.count;
    if (currentIndex == 0) {
        [self.collectionView setContentOffset:CGPointMake(self.urlArr.count*self.frame.size.width*29, 0) animated:NO];
    }
    if (currentIndex == self.urlArr.count-1) {
        [self.collectionView setContentOffset:CGPointMake((self.urlArr.count*29-1)*self.frame.size.width, 0) animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark ------ Setter ------
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval > 1.99 && _timeInterval != timeInterval) {
        _timeInterval = timeInterval;
        if (self.urlArr.count > 1) {
            [self startTimer];
        }
    }
}

- (void)setDiameter:(CGFloat)diameter {
    if (diameter > 2 && _diameter != diameter) {
        _diameter = diameter;
        self.pageControl.diameter = diameter;
        if (self.urlArr.count > 1) {
            [self updatePageControlFrame];
        }
    }
}

- (void)setDotMargin:(CGFloat)dotMargin {
    if (dotMargin > 2 && _dotMargin != dotMargin) {
        _dotMargin = dotMargin;
        self.pageControl.margin = dotMargin;
        if (self.urlArr.count > 1) {
            [self updatePageControlFrame];
        }
    }
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    if (self.urlArr.count > 1 && self.position == ADLPagePositionLeft) {
        CGRect frame = self.pageControl.frame;
        frame.origin.x = leftMargin;
        self.pageControl.frame = frame;
    }
}

- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    if (self.urlArr.count > 1 && self.position == ADLPagePositionRight) {
        CGRect frame = self.pageControl.frame;
        frame.origin.x = self.frame.size.width-frame.size.width-rightMargin;
        self.pageControl.frame = frame;
    }
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    if (self.urlArr.count > 1) {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = self.frame.size.height-frame.size.height-bottomMargin;
        self.pageControl.frame = frame;
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    self.pageControl.selectColor = selectColor;
}

- (void)setUnselectColor:(UIColor *)unselectColor {
    _unselectColor = unselectColor;
    self.pageControl.unselectColor = unselectColor;
}

#pragma mark ------ 销毁Timer ------
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
