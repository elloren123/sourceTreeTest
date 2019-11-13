//
//  ADLHorseView.m
//  lockboss
//
//  Created by adel on 2019/3/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLHorseView.h"
#import "ADLGlobalDefine.h"

@interface ADLHorseView ()
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *contentLab1;
@property (nonatomic, strong) UILabel *contentLab2;
@property (nonatomic, strong) UIImageView *imgView;
@end

#define DEFAULT_PADDING 12
#define DEFAULT_IMAGE_SIZE 18

@implementation ADLHorseView

+ (instancetype)horseViewWithFrame:(CGRect)frame image:(UIImage *)image timeInterval:(NSTimeInterval)timeInterval {
    return [[self alloc] initWithFrame:frame image:image timeInterval:timeInterval];
}
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image timeInterval:(NSTimeInterval)timeInterval {
    if (self = [super initWithFrame:frame]) {
        _image = image;
        _imgSize = CGSizeMake(DEFAULT_IMAGE_SIZE, DEFAULT_IMAGE_SIZE);
        if (timeInterval < 1) self.timeInterval = 2.5;
        else self.timeInterval = timeInterval+1.5;
        [self setDefaultData];
    }
    return self;
}

#pragma mark ------ 设置默认数据 ------
- (void)setDefaultData {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHorseView:)];
    [self addGestureRecognizer:tap];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(DEFAULT_PADDING, (self.frame.size.height-_imgSize.height)/2, _imgSize.width, _imgSize.height)];
    imgView.image = _image;
    [self addSubview:imgView];
    self.imgView = imgView;
}

#pragma mark ------ 点击事件 ------
- (void)clickHorseView:(UITapGestureRecognizer *)tap {
    if (self.clickHorseView) {
        self.clickHorseView(self.currentIndex);
    }
}

#pragma mark ------ 更新滚动内容 ------
- (void)setContentData {
    self.currentIndex = 0;
    if ([self.timer isValid]) [self.timer invalidate];
    if (self.contentArr.count > 0) {
        self.imgView.hidden = NO;
        CGFloat wid = self.frame.size.width;
        CGFloat hei = self.frame.size.height;
        if (self.contentLab1 == nil) {
            self.contentLab1 = [self createLabelWithFrame:CGRectMake(DEFAULT_PADDING*2+_imgSize.width, 0, wid-DEFAULT_PADDING*3-_imgSize.width, hei) text:_contentArr[0]];
        } else {
            self.contentLab1.text = _contentArr[0];
        }
        
        if (_contentArr.count > 1) {
            if (self.contentLab2 == nil) {
                self.contentLab2 = [self createLabelWithFrame:CGRectMake(DEFAULT_PADDING*2+_imgSize.width, hei, wid-DEFAULT_PADDING*3-_imgSize.width, hei) text:_contentArr[1]];
            } else {
                self.contentLab2.text = _contentArr[1];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(updateContentData) userInfo:nil repeats:YES];
        }
    } else {
        self.imgView.hidden = YES;
        self.contentLab1.text = @"";
        self.contentLab2.text = @"";
    }
}

- (void)updateContentData {
    self.currentIndex++;
    if (self.currentIndex == _contentArr.count) {
        self.currentIndex = 0;
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        self.contentLab1.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
        self.contentLab2.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {
        self.contentLab1.text = self.contentArr[self.currentIndex];
        if (self.currentIndex == self.contentArr.count-1) {
            self.contentLab2.text = self.contentArr[0];
        } else {
            self.contentLab2.text = self.contentArr[self.currentIndex+1];
        }
        self.contentLab1.transform = CGAffineTransformIdentity;
        self.contentLab2.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark ------ 快速创建 UILabel ------
- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text {
    UILabel *descLab = [[UILabel alloc] initWithFrame:frame];
    descLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    descLab.textColor = COLOR_333333;
    descLab.text = text;
    [self addSubview:descLab];
    return descLab;
}

#pragma mark ------ Setter ------
- (void)setContentArr:(NSMutableArray<NSString *> *)contentArr {
    _contentArr = contentArr;
    [self setContentData];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (self.imgView != nil) self.imgView.image = image;
}

- (void)setImgSize:(CGSize)imgSize {
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    if (imgSize.width > wid/2 || imgSize.height > hei) return;
    _imgSize = imgSize;
    
    if (self.imgView != nil) self.imgView.frame = CGRectMake(DEFAULT_PADDING, (hei-imgSize.height)/2, imgSize.width, imgSize.height);
    if (self.contentLab1 != nil) self.contentLab1.frame = CGRectMake(DEFAULT_PADDING*2+imgSize.width, 0, wid-DEFAULT_PADDING*3-imgSize.width, hei);
    if (self.contentLab2 != nil) self.contentLab2.frame = CGRectMake(DEFAULT_PADDING*2+imgSize.width, hei, wid-DEFAULT_PADDING*3-imgSize.width, hei);
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (self.contentLab1 != nil) self.contentLab1.textColor = textColor;
    if (self.contentLab2 != nil) self.contentLab2.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (self.contentLab1 != nil) self.contentLab1.font = textFont;
    if (self.contentLab2 != nil) self.contentLab2.font = textFont;
}

@end
