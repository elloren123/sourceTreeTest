//
//  ADLEditImageController.m
//  lockboss
//
//  Created by Han on 2018/4/1.
//  Copyright © 2018年 Titanium. All rights reserved.
//

#import "ADLEditImageController.h"

@interface ADLEditImageController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat originalImageW;
@property (nonatomic, assign) CGFloat originalImageH;
@property (nonatomic, strong) UIButton *originalBtn;
@property (nonatomic, assign) CGFloat overViewY;
@end

@implementation ADLEditImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGFloat botH = 48;
    CGFloat overlayerY = (SCREEN_HEIGHT-BOTTOM_H-botH-SCREEN_WIDTH)*0.5;
    self.overViewY = overlayerY;
    
    if (self.image == nil) {
        UIColor *color = [self generateRandomColor];
        self.image = [self imageWithColor:color andSize:self.view.bounds.size];
    } else {
        self.image = [self fixImageOrientation:self.image];
    }
    
    self.originalImageW = self.image.size.width;
    self.originalImageH = self.image.size.height;
    
    CGFloat imageW = SCREEN_WIDTH;
    CGFloat imageH = SCREEN_WIDTH*self.originalImageH/self.originalImageW;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale = 1;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (imageH < SCREEN_WIDTH) {
        imageW = SCREEN_WIDTH/imageH*imageW;
        imageH = SCREEN_WIDTH;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, self.view.center.y-(botH+BOTTOM_H)/2);
    imageView.image = self.image;
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self.view addGestureRecognizer:pan];
    
    ///遮罩
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIBezierPath *opacityPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, overlayerY, SCREEN_WIDTH, SCREEN_WIDTH)];
    [path appendPath:opacityPath];
    path.usesEvenOddFillRule = YES;
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    [self.view.layer addSublayer:fillLayer];
    
    ///边框
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, overlayerY)];
    [borderPath addLineToPoint:CGPointMake(SCREEN_WIDTH, overlayerY)];
    [borderPath addLineToPoint:CGPointMake(SCREEN_WIDTH, overlayerY+SCREEN_WIDTH)];
    [borderPath addLineToPoint:CGPointMake(0, overlayerY+SCREEN_WIDTH)];
    [borderPath closePath];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = borderPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = 1;
    [self.view.layer addSublayer:borderLayer];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-botH, SCREEN_WIDTH, botH+BOTTOM_H)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:bottomView];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, botH)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancleBtn];
    
    UIButton *originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 0, 90, botH)];
    [originalBtn setTitle:@"使用原图" forState:UIControlStateNormal];
    [originalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    originalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [originalBtn addTarget:self action:@selector(clickOriginalBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:originalBtn];
    self.originalBtn = originalBtn;
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 66, botH)];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
}

#pragma mark ------ 禁用侧滑手势 ------
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect frame = self.imageView.frame;
    if (frame.size.width > SCREEN_WIDTH || frame.size.height > SCREEN_HEIGHT) {
        frame = [self handleBorderOverflow:frame];
        self.imageView.frame = frame;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGRect frame = self.imageView.frame;
    frame = [self handleBorderOverflow:frame];
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = frame;
    }];
}

#pragma mark ------ 拖动手势 ------
- (void)panGes:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.imageView.frame;
        frame.origin.x += point.x;
        frame.origin.y += point.y;
        self.imageView.frame = frame;
        [pan setTranslation:CGPointZero inView:self.view];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGRect frame = self.imageView.frame;
        frame = [self handleBorderOverflow:frame];
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = frame;
        }];
    }
}

#pragma mark ------ 处理边框溢出 ------
- (CGRect)handleBorderOverflow:(CGRect)frame {
    CGFloat offX = self.scrollView.contentOffset.x;
    CGFloat offY = self.scrollView.contentOffset.y;
    
    if (frame.origin.x-offX > 0) {
        frame.origin.x = offX;
    }
    if (frame.origin.x-offX < SCREEN_WIDTH-frame.size.width) {
        frame.origin.x = offX+SCREEN_WIDTH-frame.size.width;
    }
    if (frame.origin.y-offY > self.overViewY) {
        frame.origin.y = offY+self.overViewY;
    }
    if (frame.origin.y-offY < self.overViewY+SCREEN_WIDTH-frame.size.height) {
        frame.origin.y = offY+self.overViewY+SCREEN_WIDTH-frame.size.height;
    }
    if (frame.size.height < SCREEN_WIDTH) {
        frame.origin.y = self.overViewY+(SCREEN_WIDTH-frame.size.height)*0.5;
    }
    return frame;
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------ 原图 ------
- (void)clickOriginalBtn {
    if (self.finishBlock) self.finishBlock(self.image);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------ 确认 ------
- (void)clickConfirmBtn {
    UIImage *image= [self getSubImage];
    if (self.finishBlock) self.finishBlock(image);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------ 获取编辑后的图片 ------
- (UIImage *)getSubImage {
    CGRect squareFrame = CGRectMake(0, self.overViewY, SCREEN_WIDTH, SCREEN_WIDTH);
    CGFloat scaleRatio = self.imageView.frame.size.width/self.originalImageW;
    CGFloat x = (squareFrame.origin.x-self.imageView.frame.origin.x+self.scrollView.contentOffset.x)/scaleRatio;
    CGFloat y = (squareFrame.origin.y-self.imageView.frame.origin.y+self.scrollView.contentOffset.y)/scaleRatio;
    CGFloat w = squareFrame.size.width/scaleRatio;
    CGFloat h = squareFrame.size.height/scaleRatio;
    
    if (self.imageView.frame.size.height < SCREEN_WIDTH) {
        CGFloat newH = self.originalImageH;
        CGFloat newW = newH;
        x = x+(w-newW)/2;
        y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

#pragma mark ------ 处理图片方向 ------
- (UIImage *)fixImageOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(ctx);
    CGImageRelease(cgImage);
    return img;
}

#pragma mark ------ 获取随机颜色 ------
- (UIColor *)generateRandomColor {
    CGFloat r = arc4random_uniform(255)/255.0;
    CGFloat g = arc4random_uniform(255)/255.0;
    CGFloat b = arc4random_uniform(255)/255.0;
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
    return color;
}

#pragma mark ------ 颜色转图片 ------
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setOriginal:(BOOL)original {
    _original = original;
    self.originalBtn.hidden = !original;
}

@end
