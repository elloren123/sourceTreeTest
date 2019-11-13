//
//  ADLAttachView.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAttachView.h"
#import "ADLGlobalDefine.h"
#import "ADLSingleTextCell.h"

@interface ADLAttachView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^finish) (NSInteger index);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation ADLAttachView

+ (instancetype)showWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr finish:(void (^)(NSInteger))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds attachFrame:frame titleArr:titleArr finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame attachFrame:(CGRect)attachFrame titleArr:(NSArray *)titleArr finish:(void (^)(NSInteger))finish {
    if (self = [super initWithFrame:frame]) {
        CGFloat residueH = SCREEN_HEIGHT-attachFrame.origin.y-BOTTOM_H;
        if (residueH > 20 && residueH < attachFrame.size.height) {
            attachFrame.size.height = residueH;
        }
        self.finish = finish;
        self.titleArr = titleArr;
        [self initializationView:attachFrame];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationView:(CGRect)aframe {
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor clearColor];
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRemove)];
    [coverView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [coverView addGestureRecognizer:pan];
    
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(aframe.origin.x, aframe.origin.y, aframe.size.width, 1)];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.layer.shadowRadius = 3;
    panelView.layer.shadowOpacity = 0.2;
    panelView.layer.shadowOffset = CGSizeZero;
    panelView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, aframe.size.width, 1)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    [panelView addSubview:tableView];
    self.tableView = tableView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        panelView.frame = aframe;
        tableView.frame = CGRectMake(0, 0, aframe.size.width, aframe.size.height);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == self.titleArr.count-1) {
        cell.spView.hidden = YES;
    } else {
        cell.spView.hidden = NO;
    }
    cell.titLab.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.finish) {
        self.finish(indexPath.row);
    }
    [self removeView];
}

#pragma mark ------ 移除 ------
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self clickRemove];
    }
}

- (void)clickRemove {
    if (self.finish) {
        self.finish(-1);
    }
    [self removeView];
}

- (void)removeView {
    CGRect frame = self.panelView.frame;
    frame.size.height = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = frame;
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, 1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
