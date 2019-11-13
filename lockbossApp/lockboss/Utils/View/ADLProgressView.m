//
//  ADLProgressView.m
//  lockboss
//
//  Created by Adel on 2019/9/17.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLProgressView.h"

@interface ADLProgressView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation ADLProgressView

+ (instancetype)progressViewWithFrame:(CGRect)frame type:(ADLProgressViewType)type {
    return [[self alloc] initWithFrame:frame type:type];
}

- (instancetype)initWithFrame:(CGRect)frame type:(ADLProgressViewType)type {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        if (type == ADLProgressViewTypeHorizontal) {
            [path moveToPoint:CGPointMake(0, frame.size.height/2)];
            [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height/2)];
            shapeLayer.lineWidth = frame.size.height;
        } else {
            [path moveToPoint:CGPointMake(frame.size.width/2, frame.size.height)];
            [path addLineToPoint:CGPointMake(frame.size.width/2, 0)];
            shapeLayer.lineWidth = frame.size.width;
        }
        
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = nil;
        shapeLayer.strokeEnd = 0;
        [self.layer addSublayer:shapeLayer];
        self.shapeLayer = shapeLayer;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    self.shapeLayer.strokeEnd = progress;
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(_progress);
        animation.toValue = @(progress);
        animation.duration = 0.3;
        [self.shapeLayer addAnimation:animation forKey:nil];
    }
    _progress = progress;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    self.backgroundColor = trackColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.shapeLayer.strokeColor = progressColor.CGColor;
}

@end
