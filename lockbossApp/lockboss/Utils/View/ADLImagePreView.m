//
//  ADLImagePreView.m
//  lockboss
//
//  Created by adel on 2019/4/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLImagePreView.h"
#import "ADLGlobalDefine.h"
#import "ADLSheetView.h"
#import "ADLAlertView.h"
#import "ADLToast.h"

#import <SDImageCache.h>
#import <UIImageView+WebCache.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetCreationRequest.h>

@interface ADLImagePreView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLImagePreView

+ (instancetype)showWithImageViews:(NSArray *)imageViews urlArray:(NSArray *)urlArr currentIndex:(NSInteger)currentIndex {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds imageViews:imageViews urlArray:urlArr currentIndex:currentIndex];
}

- (instancetype)initWithFrame:(CGRect)frame imageViews:(NSArray *)imageViews urlArray:(NSArray *)urlArr currentIndex:(NSInteger)currentIndex {
    if (self = [super initWithFrame:frame]) {
        self.index = currentIndex > urlArr.count-1 ? 0 : currentIndex;
        self.urlArr = [[NSMutableArray alloc] initWithArray:urlArr];
        [self initializationSubViews:imageViews];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationSubViews:(NSArray *)imageViews {
    if (self.urlArr.count == 0) return;
    if (imageViews.count > 1 && self.urlArr.count != imageViews.count) return;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.imgViewArr = [[NSMutableArray alloc] init];
    
    if (imageViews.count > 0) {
        self.frameArr = [[NSMutableArray alloc] init];
        for (UIImageView *imageView in imageViews) {
            CGRect rec = [window convertRect:imageView.frame fromView:imageView.superview];
            [self.frameArr addObject:[NSValue valueWithCGRect:rec]];
        }
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT)];
    [scrollView setContentOffset:CGPointMake(self.index*(SCREEN_WIDTH+10), 0) animated:NO];
    scrollView.contentSize = CGSizeMake(self.urlArr.count*(SCREEN_WIDTH+10), 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.tag = 23;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    __block CGRect imgF;
    for (int i = 0; i < self.urlArr.count; i++) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+10)*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.maximumZoomScale = 3;
        imageScrollView.minimumZoomScale = 1;
        imageScrollView.delegate = self;
        [scrollView addSubview:imageScrollView];
        
        UIImage *placeImage = [UIImage imageNamed:@"black_bg"];
        if (imageViews.count > 1 || imageViews.count == self.urlArr.count) {
            placeImage = ((UIImageView *)imageViews[i]).image;
        }
        CGFloat imgH = SCREEN_WIDTH;
        if (placeImage.size.height != 0) {
            imgH = SCREEN_WIDTH/placeImage.size.width*placeImage.size.height;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-imgH)/2, SCREEN_WIDTH, imgH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.image = placeImage;
        [self.imgViewArr addObject:imageView];
        [imageScrollView addSubview:imageView];
        
        if (i == self.index) {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
            indicatorView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            indicatorView.center = self.center;
            [indicatorView startAnimating];
            [self addSubview:indicatorView];
            self.indicatorView = indicatorView;
            
            imgF = CGRectMake(0, (SCREEN_HEIGHT-imgH)/2, SCREEN_WIDTH, imgH);
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArr[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [indicatorView stopAnimating];
                indicatorView.hidden = YES;
                if (image == nil) {
                    image = [UIImage imageNamed:@"img_square"];
                    imageView.image = image;
                }
                
                CGFloat imgW = SCREEN_WIDTH;
                CGFloat imgH = SCREEN_WIDTH/image.size.width*image.size.height;
                imageScrollView.contentSize = CGSizeMake(imgW, imgH);
                if (imgH > SCREEN_HEIGHT) {
                    imageView.frame = CGRectMake(0, 0, imgW, imgH);
                } else {
                    imageView.frame = CGRectMake(0, (SCREEN_HEIGHT-imgH)/2, imgW, imgH);
                }
                imgF = imageView.frame;
            }];
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        singleTap.numberOfTapsRequired = 1;
        [imageScrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickImageView:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
        [imageView addGestureRecognizer:longPress];
    }
    
    if (self.urlArr.count > 1) {
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+10, SCREEN_WIDTH, 20)];
        countLab.text = [NSString stringWithFormat:@"%ld/%lu",self.index+1,self.urlArr.count];
        countLab.textAlignment = NSTextAlignmentCenter;
        countLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        countLab.textColor = [UIColor whiteColor];
        [self addSubview:countLab];
        self.countLab = countLab;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideCountLab) userInfo:nil repeats:NO];
    }
    
    [window addSubview:self];
    
    UIImageView *imgView = (UIImageView *)self.imgViewArr[self.index];
    if (imageViews.count > 1 || imageViews.count == self.urlArr.count) {
        imgView.frame = [self.frameArr[self.index] CGRectValue];
    } else {
        imgView.frame = CGRectMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT/2, 0, 0);
    }
    
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
    
    if (self.frameArr.count == 1 || self.frameArr.count == self.urlArr.count) {
        NSInteger currentIndex = self.index;
        if (self.frameArr.count == 1) currentIndex = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.alpha = 0;
            scrollView.contentOffset = CGPointMake(0, 0);
            imgView.frame = [self.frameArr[currentIndex] CGRectValue];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.alpha = 0;
            imgView.alpha = 0;
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
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

#pragma mark ------ 长按图片 ------
- (void)longPressGes:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:nil];
        [sheetView addActionWithTitle:@"保存图片到相册" handler:^{
            [self clickSaveImageBtn];
        }];
        [sheetView show];
    }
}

#pragma mark ------ 保存图片 ------
- (void)clickSaveImageBtn {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == 1 || status == 2) {
                [ADLAlertView showWithTitle:@"无法保存" message:@"请在“设置-隐私-照片”选项中，允许锁老大访问你的照片，是否前去设置？" confirmTitle:nil confirmAction:^{
                    [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
                } cancleTitle:nil cancleAction:nil showCancle:YES];
            } else {
                [ADLToast showLoadingMessage:@"保存中..."];
                NSData *data = [[SDImageCache sharedImageCache] diskImageDataForKey:self.urlArr[self.index]];
                if (data == nil) {
                    data = UIImageJPEGRepresentation([UIImage imageNamed:@"img_square"], 1.0);
                }
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            [ADLToast showMessage:@"保存成功"];
                        } else {
                            [ADLToast showMessage:@"保存失败"];
                        }
                    });
                }];
            }
        });
    }];
}

#pragma mark ------ UIScrollView Delegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 23) {
        CGFloat width = scrollView.frame.size.width;
        self.index = (scrollView.contentOffset.x+0.5*width)/width;
        self.countLab.text = [NSString stringWithFormat:@"%ld/%lu",self.index+1,self.urlArr.count];
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
        UIImageView *imageView = (UIImageView *)self.imgViewArr[self.index];
        UIScrollView *imgScrollView = (UIScrollView *)imageView.superview;
        if (self.index-1 >= 0) {
            UIScrollView *preScrollView = (UIScrollView *)((UIImageView *)self.imgViewArr[self.index-1]).superview;
            [preScrollView setZoomScale:1.0 animated:NO];
        }
        if (self.index+1 <= self.imgViewArr.count-1) {
            UIScrollView *lasScrollView = (UIScrollView *)((UIImageView *)self.imgViewArr[self.index+1]).superview;
            [lasScrollView setZoomScale:1.0 animated:NO];
        }
        
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArr[self.index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            if (image == nil) {
                image = [UIImage imageNamed:@"img_square"];
                imageView.image = image;
            }
            CGFloat imgW = SCREEN_WIDTH;
            CGFloat imgH = SCREEN_WIDTH/image.size.width*image.size.height;
            imgScrollView.contentSize = CGSizeMake(imgW, imgH);
            CGRect imgFrame;
            if (imgH > SCREEN_HEIGHT) {
                imgFrame = CGRectMake(0, 0, imgW, imgH);
            } else {
                imgFrame = CGRectMake(0, (SCREEN_HEIGHT-imgH)/2, imgW, imgH);
            }
            imageView.frame = imgFrame;
        }];
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
