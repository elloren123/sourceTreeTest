//
//  ADLAccHistoryView.m
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAccHistoryView.h"
#import "ADLAccHistoryCell.h"
#import "ADLGlobalDefine.h"
#import "ADLUtils.h"

@interface ADLAccHistoryView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ADLAccHistoryCellDelegate>
@property (nonatomic, copy) void (^finish) (NSString *account, NSArray *historyArr);
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, assign) BOOL phone;
@end

@implementation ADLAccHistoryView

+ (instancetype)showWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr phone:(BOOL)phone finish:(void (^)(NSString *, NSArray *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds panelF:frame dataArr:dataArr phone:phone finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame panelF:(CGRect)panelF dataArr:(NSArray *)dataArr phone:(BOOL)phone finish:(void (^)(NSString *, NSArray *))finish {
    if (self = [super initWithFrame:frame]) {
        self.phone = phone;
        self.finish = finish;
        self.dataArr = [NSMutableArray arrayWithArray:dataArr];
        [self setupWithPanelF:panelF];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)setupWithPanelF:(CGRect)panelF {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHistoryView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(panelF.origin.x, SCREEN_HEIGHT, panelF.size.width, panelF.size.height)];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.clipsToBounds = YES;
    panelView.layer.borderWidth = 0.5;
    panelView.layer.cornerRadius = CORNER_RADIUS;
    panelView.layer.borderColor = COLOR_D3D3D3.CGColor;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, panelF.size.width, panelF.size.height)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    [panelView addSubview:tableView];
    self.tableView = tableView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        panelView.frame = panelF;
    }];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLAccHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
    if (cell == nil) {
        cell = [[ADLAccHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.accountLab.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *account = self.dataArr[indexPath.row];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [self.dataArr insertObject:account atIndex:0];
    NSString *fileName = self.phone ? HISTORY_PHONE : HISTORY_EMAIL;
    [ADLUtils saveObject:self.dataArr fileName:fileName permanent:YES];
    if (self.finish) {
        self.finish(account,self.dataArr);
    }
    [self remove];
}

#pragma mark ------ UIGestureRecognizerDelegate ------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    return  YES;
}

#pragma mark ------ 删除 ------
- (void)didClickDeleteBtn:(UIButton *)sender {
    ADLAccHistoryCell *cell = (ADLAccHistoryCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    NSString *fileName = self.phone ? HISTORY_PHONE : HISTORY_EMAIL;
    if (self.dataArr.count == 0) {
        [ADLUtils removeObjectWithFileName:fileName permanent:YES];
        if (self.finish) {
            self.finish(nil,nil);
        }
        [self remove];
    } else {
        [ADLUtils saveObject:self.dataArr fileName:fileName permanent:YES];
    }
}

#pragma mark ------ 移除 ------
- (void)clickHistoryView {
    if (self.finish) {
        self.finish(nil,self.dataArr);
    }
    [self remove];
}

- (void)remove {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
