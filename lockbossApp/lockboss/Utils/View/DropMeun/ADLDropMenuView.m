//
//  ADLDropMenuView.m
//  lockboss
//
//  Created by adel on 2019/8/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDropMenuView.h"
#import "ADLDropViewCell.h"
#import "ADLGlobalDefine.h"

@interface ADLDropMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^finish) (NSInteger index);
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) BOOL lightModel;
@property (nonatomic, assign) BOOL image;
@end

@implementation ADLDropMenuView

+ (instancetype)showWithView:(UIView *)sView imgNameArray:(NSArray *)imgNameArray titleArray:(NSArray *)titleArr lightMode:(BOOL)lightMode finish:(void (^)(NSInteger))finish {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect sRect = [sView.superview convertRect:sView.frame toView:window];
    return [[self alloc] initWithRect:sRect imgNameArray:imgNameArray titleArray:titleArr lightMode:lightMode finish:finish];
}

+ (instancetype)showWithRect:(CGRect)sRect imgNameArray:(NSArray *)imgNameArray titleArray:(NSArray *)titleArr lightMode:(BOOL)lightMode finish:(void (^)(NSInteger))finish {
    return [[self alloc] initWithRect:sRect imgNameArray:imgNameArray titleArray:titleArr lightMode:lightMode finish:finish];
}

- (instancetype)initWithRect:(CGRect)sRect imgNameArray:(NSArray *)imgNameArray titleArray:(NSArray *)titleArr lightMode:(BOOL)lightMode finish:(void (^)(NSInteger))finish {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        if (titleArr.count > 0) {
            self.finish = finish;
            self.titleArr = titleArr;
            self.lightModel = lightMode;
            if (imgNameArray.count == titleArr.count) {
                self.image = YES;
                self.imageArr = imgNameArray;
            } else {
                self.image = NO;
            }
            
            UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
            coverView.backgroundColor = [UIColor blackColor];
            coverView.alpha = 0;
            [self addSubview:coverView];
            self.coverView = coverView;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView)];
            [coverView addGestureRecognizer:tap];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewPanGes:)];
            [coverView addGestureRecognizer:pan];
            
            UIView *panelView = [[UIView alloc] init];
            [self addSubview:panelView];
            self.panelView = panelView;
            
            UITableView *tableView = [[UITableView alloc] init];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.layer.cornerRadius = 5;
            tableView.clipsToBounds = YES;
            tableView.rowHeight = 45;
            tableView.delegate = self;
            tableView.dataSource = self;
            [panelView addSubview:tableView];
            
            CGFloat panelX = 0;
            CGFloat panelY = 0;
            CGFloat panelH = (titleArr.count > 5 ? 225 : titleArr.count*45)+7;
            CGFloat rectBH = SCREEN_HEIGHT-sRect.origin.y-sRect.size.height;
            NSMutableString *position = [[NSMutableString alloc] init];
            CGFloat margin = 10;
            
            //这里不考虑sRect非常大导致超出屏幕
            if (sRect.origin.x+sRect.size.width/2 < SCREEN_WIDTH/2) {
                panelX = sRect.origin.x+sRect.size.width/2-margin-6;
                [position appendString:@"L"];
            } else {
                panelX = sRect.origin.x+sRect.size.width/2+margin-144;
                [position appendString:@"R"];
            }
            if (sRect.origin.y > rectBH) {
                panelY = sRect.origin.y-panelH;
                [position appendString:@"U"];
                tableView.frame = CGRectMake(0, 0, 150, panelH-7);
            } else {
                panelY = sRect.origin.y+sRect.size.height;
                [position appendString:@"D"];
                tableView.frame = CGRectMake(0, 7, 150, panelH-7);
            }
            panelView.frame = CGRectMake(panelX, panelY, 150, panelH);
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            if ([position isEqualToString:@"LU"]) {
                [bezierPath moveToPoint:CGPointMake(margin, panelH-7)];
                [bezierPath addLineToPoint:CGPointMake(margin+6, panelH)];
                [bezierPath addLineToPoint:CGPointMake(margin+12, panelH-7)];
            } else if ([position isEqualToString:@"LD"]) {
                [bezierPath moveToPoint:CGPointMake(margin, 7)];
                [bezierPath addLineToPoint:CGPointMake(margin+6, 0)];
                [bezierPath addLineToPoint:CGPointMake(margin+12, 7)];
            } else if ([position isEqualToString:@"RU"]) {
                [bezierPath moveToPoint:CGPointMake(138-margin, panelH-7)];
                [bezierPath addLineToPoint:CGPointMake(144-margin, panelH)];
                [bezierPath addLineToPoint:CGPointMake(150-margin, panelH-7)];
            } else {
                [bezierPath moveToPoint:CGPointMake(138-margin, 7)];
                [bezierPath addLineToPoint:CGPointMake(144-margin, 0)];
                [bezierPath addLineToPoint:CGPointMake(150-margin, 7)];
            }
            [bezierPath closePath];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = bezierPath.CGPath;
            if (lightMode) {
                tableView.backgroundColor = [UIColor whiteColor];
                shapeLayer.fillColor = [UIColor whiteColor].CGColor;
                shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            } else {
                tableView.backgroundColor = COLOR_333333;
                shapeLayer.fillColor = COLOR_333333.CGColor;
                shapeLayer.strokeColor = COLOR_333333.CGColor;
            }
            [panelView.layer addSublayer:shapeLayer];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self];
            [UIView animateWithDuration:0.3 animations:^{
                coverView.alpha = 0.1;
                panelView.alpha = 1;
            }];
        }
    }
    return self;
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLDropViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLDropViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" image:self.image lightMode:self.lightModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == self.titleArr.count-1) {
        cell.spView.hidden = YES;
    } else {
        cell.spView.hidden = NO;
    }
    cell.titleLab.text = self.titleArr[indexPath.row];
    if (self.image) {
        cell.iconView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.finish) {
        self.finish(indexPath.row);
    }
    [self closeWithAnimaton:NO];
}

#pragma mark ------ 点击遮罩 ------
- (void)clickCoverView {
    [self closeWithAnimaton:YES];
}

#pragma mark ------ 移除视图 ------
- (void)closeWithAnimaton:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.alpha = 0;
            self.panelView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)coverViewPanGes:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self closeWithAnimaton:YES];
    }
}

@end
