//
//  ADLLocalImgPreView.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLocalImgPreView.h"
#import "ADLGlobalDefine.h"

@interface ADLLocalImgPreView ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLLocalImgPreView

+ (instancetype)showWithImageViews:(NSArray *)imageViews currentIndex:(NSInteger)currentIndex {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds imageViews:imageViews currentIndex:currentIndex];
}

- (instancetype)initWithFrame:(CGRect)frame imageViews:(NSArray *)imageViews currentIndex:(NSInteger)currentIndex {
    if (self = [super initWithFrame:frame]) {
        self.index = currentIndex > imageViews.count-1 ? 0 : currentIndex;
        [self initImagePreView:imageViews];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initImagePreView:(NSArray *)imageViews {
    if (imageViews.count == 0) return;
    self.imgViewArr = [[NSMutableArray alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frameArr = [[NSMutableArray alloc] init];
    for (UIImageView *imageView in imageViews) {
        CGRect rec = [window convertRect:imageView.frame fromView:imageView.superview];
        [self.frameArr addObject:[NSValue valueWithCGRect:rec]];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH+20, SCREEN_HEIGHT)];
    [scrollView setContentOffset:CGPointMake(self.index*(SCREEN_WIDTH+20), 0) animated:NO];
    scrollView.contentSize = CGSizeMake(imageViews.count*(SCREEN_WIDTH+20), 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.tag = 23;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    CGRect imgF = CGRectZero;
    for (int i = 0; i < imageViews.count; i++) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+20)*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.maximumZoomScale = 3;
        imageScrollView.minimumZoomScale = 1;
        imageScrollView.delegate = self;
        [scrollView addSubview:imageScrollView];
        
        UIImage *image = ((UIImageView *)imageViews[i]).image;
        CGFloat imgH = SCREEN_WIDTH/image.size.width*image.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-imgH)/2, SCREEN_WIDTH, imgH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.image = image;
        
        [self.imgViewArr addObject:imageView];
        [imageScrollView addSubview:imageView];
        imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, imgH);
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        singleTap.numberOfTapsRequired = 1;
        [imageScrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickImageView:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        if (self.index == i) {
            imgF = imageView.frame;
        }
    }
    
    if (imageViews.count > 1) {
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+10, SCREEN_WIDTH, 20)];
        countLab.text = [NSString stringWithFormat:@"%ld/%lu",self.index+1,imageViews.count];
        countLab.textAlignment = NSTextAlignmentCenter;
        countLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        countLab.textColor = [UIColor whiteColor];
        [self addSubview:countLab];
        self.countLab = countLab;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideCountLab) userInfo:nil repeats:NO];
    }
    [window addSubview:self];
    
    UIImageView *imgView = self.imgViewArr[self.index];
    imgView.frame = [self.frameArr[self.index] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 1;
        imgView.frame = imgF;
    }];
}

#pragma mark ------ 点击图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    UIImageView *imgView = scrollView.subviews[0];
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        scrollView.contentOffset = CGPointMake(0, 0);
        imgView.frame = [self.frameArr[self.index] CGRectValue];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ 双击图片 ------
- (void)doubleClickImageView:(UITapGestureRecognizer *)doubleTap {
    UIImageView *imageView = (UIImageView *)doubleTap.view;
    UIScrollView *scrollView = (UIScrollView *)imageView.superview;
    if (scrollView.zoomScale > 1) {
        [scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint point = [doubleTap locationInView:scrollView];
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        rect.origin.x = point.x-SCREEN_WIDTH/4;
        rect.origin.y = point.y-SCREEN_HEIGHT/4;
        [scrollView zoomToRect:rect animated:YES];
    }
}

#pragma mark ------ UIScrollView Delegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 23) {
        CGFloat width = scrollView.frame.size.width;
        self.index = (scrollView.contentOffset.x+0.5*width)/width;
        self.countLab.text = [NSString stringWithFormat:@"%ld/%lu",self.index+1,self.imgViewArr.count];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 23) {
        self.countLab.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.countLab.alpha = 1;
        } completion:^(BOOL finished) {
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideCountLab) userInfo:nil repeats:NO];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 23) {
        if (self.index-1 >= 0) {
            UIScrollView *preScrollView = (UIScrollView *)((UIImageView *)self.imgViewArr[self.index-1]).superview;
            [preScrollView setZoomScale:1.0 animated:NO];
        }
        if (self.index+1 <= self.imgViewArr.count-1) {
            UIScrollView *lasScrollView = (UIScrollView *)((UIImageView *)self.imgViewArr[self.index+1]).superview;
            [lasScrollView setZoomScale:1.0 animated:NO];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag != 23) {
        return scrollView.subviews[0];
    } else {
        return nil;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGRect frame = view.frame;
    frame = [self handleFrame:frame];
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = frame;
    }];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *imageView = scrollView.subviews[0];
    CGRect frame = imageView.frame;
    frame = [self handleFrame:frame];
    imageView.frame = frame;
}

- (CGRect)handleFrame:(CGRect)frame {
    if (frame.size.height < SCREEN_HEIGHT) {
        frame.origin.y = (SCREEN_HEIGHT-frame.size.height)/2;
    } else {
        frame.origin.y = 0;
    }
    return frame;
}

#pragma mark ------ 隐藏数量 ------
- (void)hideCountLab {
    [UIView animateWithDuration:0.3 animations:^{
        self.countLab.alpha = 0;
    } completion:^(BOOL finished) {
        self.countLab.hidden = YES;
    }];
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
