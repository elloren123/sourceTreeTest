//
//  ADLImageListView.m
//  lockboss
//
//  Created by adel on 2019/7/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLImageListView.h"
#import "ADLImagePreView.h"
#import "ADLGlobalDefine.h"
#import <UIImageView+WebCache.h>

@interface ADLImageListView ()
@property (nonatomic, strong) NSMutableArray *imgHArr;
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, assign) UIEdgeInsets contentInserts;
@end

@implementation ADLImageListView

+ (instancetype)listViewWithContentInserts:(UIEdgeInsets)contentInserts {
    return [[self alloc] initWithContentInserts:contentInserts];
}

- (instancetype)initWithContentInserts:(UIEdgeInsets)contentInserts {
    if (self = [super init]) {
        self.contentInserts = contentInserts;
    }
    return self;
}

#pragma mark ------ 初始化图片 ------
- (void)setUrlArr:(NSArray *)urlArr {
    if (urlArr.count > 0) {
        _urlArr = urlArr;
        if (self.imgViewArr) {
            for (UIImageView *imgView in self.imgViewArr) {
                [imgView removeFromSuperview];
            }
            [self.imgHArr removeAllObjects];
        } else {
            self.imgHArr = [[NSMutableArray alloc] init];
            self.imgViewArr = [[NSMutableArray alloc] init];
        }
        
        for (int i = 0; i < urlArr.count; i++) {
            [self.imgHArr addObject:@(0)];
        }
        
        for (int i = 0; i < urlArr.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            [self addSubview:imgView];
            [self.imgViewArr addObject:imgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
            [imgView addGestureRecognizer:tap];
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [self.imgHArr replaceObjectAtIndex:i withObject:@((SCREEN_WIDTH-self.contentInserts.left-self.contentInserts.right)*image.size.height/image.size.width)];
                    [self updateImageViewFrame];
                }
            }];
        }
    }
}

#pragma mark ------ 更新图片Frame ------
- (void)updateImageViewFrame {
    CGFloat originalY = self.contentInserts.top;
    for (int i = 0; i < self.imgViewArr.count; i++) {
        UIImageView *imgView = self.imgViewArr[i];
        imgView.frame = CGRectMake(self.contentInserts.left, originalY, SCREEN_WIDTH-self.contentInserts.left-self.contentInserts.right, [self.imgHArr[i] floatValue]);
        originalY = originalY + [self.imgHArr[i] floatValue];
    }
    originalY = originalY + self.contentInserts.bottom;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, originalY);
    if (self.imageViewHeightChanged) {
        self.imageViewHeightChanged(originalY);
    }
}

#pragma mark ------ 点击图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    [ADLImagePreView showWithImageViews:nil urlArray:self.urlArr currentIndex:tap.view.tag];
}

@end
