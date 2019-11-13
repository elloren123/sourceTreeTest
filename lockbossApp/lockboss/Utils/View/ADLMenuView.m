//
//  ADLMenuView.m
//  lockboss
//
//  Created by Han on 2019/8/15.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLMenuView.h"
#import "ADLGlobalDefine.h"

@interface ADLMenuView ()
@property (nonatomic, copy) void (^finish) (NSInteger index, NSString *title);
@property (nonatomic, strong) UIView *coverView;
@end

@implementation ADLMenuView

+ (instancetype)showWithView:(UIView *)sView items:(NSArray<NSString *> *)itemArr finish:(void (^)(NSInteger, NSString *))finish {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect sRect = [sView.superview convertRect:sView.frame toView:window];
    return [self showWithRect:sRect items:itemArr finish:finish];
}

+ (instancetype)showWithRect:(CGRect)sRect items:(NSArray<NSString *> *)itemArr finish:(void (^)(NSInteger, NSString *))finish {
    return [[self alloc] initWithRect:sRect items:itemArr finish:finish];
}

- (instancetype)initWithRect:(CGRect)sRect items:(NSArray<NSString *> *)itemArr finish:(void (^)(NSInteger, NSString *))finish {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.finish = finish;
        if (itemArr.count > 0) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
            coverView.backgroundColor = [UIColor clearColor];
            [self addSubview:coverView];
            self.coverView = coverView;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView)];
            [coverView addGestureRecognizer:tap];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
            [coverView addGestureRecognizer:pan];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.backgroundColor = COLOR_333333;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.layer.cornerRadius = 5;
            scrollView.clipsToBounds = YES;
            [self addSubview:scrollView];
            
            CGFloat totalW = 0;
            for (int i = 0; i < itemArr.count; i++) {
                CGFloat itemW = [itemArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+32;
                
                UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                itemBtn.frame = CGRectMake(totalW, 0, itemW, 36);
                [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [itemBtn setTitle:itemArr[i] forState:UIControlStateNormal];
                itemBtn.tag = i;
                [itemBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:itemBtn];
                totalW = totalW + itemW;
                
                if (i < itemArr.count-1) {
                    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(totalW, 9, 0.5, 18)];
                    spView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
                    [scrollView addSubview:spView];
                }
            }
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [self addSubview:imgView];
            
            scrollView.contentSize = CGSizeMake(totalW, 36);
            if (totalW > SCREEN_WIDTH-36) {
                totalW = SCREEN_WIDTH-36;
            }
            
            //不考虑sRect太靠边导致imgView显示到scrollView Frame范围之外
            CGFloat scrollX = 0;
            if (sRect.origin.x+sRect.size.width/2 < SCREEN_WIDTH/2) {
                if (sRect.origin.x+sRect.size.width/2-18 > totalW/2) {
                    scrollX = sRect.origin.x+sRect.size.width/2-totalW/2;
                } else {
                    scrollX = 18;
                }
            } else {
                if (SCREEN_WIDTH-sRect.origin.x-sRect.size.width/2-18 > totalW/2) {
                    scrollX = sRect.origin.x+sRect.size.width/2-totalW/2;
                } else {
                    scrollX = SCREEN_WIDTH-totalW-18;
                }
            }
            
            if (sRect.origin.y-NAVIGATION_H > 50) {
                imgView.image = [UIImage imageNamed:@"menu_up"];
                imgView.frame = CGRectMake(sRect.origin.x+sRect.size.width/2-7, sRect.origin.y-7, 15, 7);
                scrollView.frame = CGRectMake(scrollX, sRect.origin.y-42, totalW, 36);
            } else {
                imgView.image = [UIImage imageNamed:@"menu_down"];
                imgView.frame = CGRectMake(sRect.origin.x+sRect.size.width/2-7, sRect.origin.y+sRect.size.height, 15, 7);
                scrollView.frame = CGRectMake(scrollX, sRect.origin.y+sRect.size.height+7, totalW, 36);
            }
            [window addSubview:self];
        }
    }
    return self;
}

- (void)clickItem:(UIButton *)sender {
    if (self.finish) {
        self.finish(sender.tag, sender.titleLabel.text);
    }
    [self removeFromSuperview];
}

- (void)clickCoverView {
    [self removeFromSuperview];
}

- (void)panGes:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self removeFromSuperview];
    }
}

@end
