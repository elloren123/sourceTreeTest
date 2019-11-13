//
//  ADLBottomView.m
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBottomView.h"
#import "ADLGlobalDefine.h"
#import "ADLSingleTextCell.h"

@interface ADLBottomView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^finish) (NSInteger index);
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@end

@implementation ADLBottomView

+ (instancetype)showWithTitles:(NSArray *)titles finish:(void(^)(NSInteger index))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds titles:titles finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles finish:(void (^)(NSInteger))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        [self initBottomView:titles];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initBottomView:(NSArray *)titles {
    if (titles.count == 0) return;
    self.titleArr = [[NSMutableArray alloc] initWithArray:titles];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancleBtn)];
    [coverView addGestureRecognizer:tap];
    
    CGFloat panelH = BOTTOM_H+8+ROW_HEIGHT*titles.count+VIEW_HEIGHT;
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, panelH)];
    panelView.backgroundColor = COLOR_F2F2F2;
    self.panelView = panelView;
    [self addSubview:panelView];
    
    //不考虑title过多超出屏幕
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT*titles.count)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [panelView addSubview:tableView];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ROW_HEIGHT*titles.count+8, SCREEN_WIDTH, VIEW_HEIGHT)];
    [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:cancleBtn];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake(0, SCREEN_HEIGHT-panelH, SCREEN_WIDTH, panelH);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.titLab.textAlignment = NSTextAlignmentCenter;
    }
    cell.titLab.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.finish) {
        self.finish(indexPath.row);
    }
    [self removeView];
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    if (self.finish) {
        self.finish(-1);
    }
    [self removeView];
}

#pragma mark ------ 移除 ------
- (void)removeView {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
