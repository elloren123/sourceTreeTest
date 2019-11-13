//
//  ADLSelectPhoneView.m
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectNationView.h"
#import "ADLSearchAnimateView.h"
#import "ADLSelectNationCell.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"
#import "ADLSearchView.h"

@interface ADLSelectNationView ()<ADLSearchAnimateViewDelegate,ADLSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^finish) (NSDictionary *dict);
@property (nonatomic, strong) ADLSearchAnimateView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSDictionary *selectDict;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *nationArr;
@property (nonatomic, strong) NSString *key;
@end

@implementation ADLSelectNationView

+ (instancetype)showWithFrame:(CGRect)frame finish:(void (^)(NSDictionary *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds contentViewRect:frame finish:finish];
}

+ (instancetype)showWithFinish:(void (^)(NSDictionary *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds contentViewRect:CGRectZero finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame contentViewRect:(CGRect)rect finish:(void (^)(NSDictionary *))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        [self initializationView:rect];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationView:(CGRect)contentRect {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    self.contentView = contentView;
    CGRect contentF = contentRect;
    CGFloat top = 0;
    
    if (contentRect.size.height == 0) {
        top = STATUS_HEIGHT+NAV_H-50;
        contentF = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        ADLSearchView *seaView = [ADLSearchView searchViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:ADLString(@"search") instant:YES];
        [seaView.textField resignFirstResponder];
        seaView.delegate = self;
        [contentView addSubview:seaView];
        
    } else {
        contentView.layer.borderWidth = 0.5;
        contentView.layer.cornerRadius = CORNER_RADIUS;
        contentView.layer.borderColor = COLOR_D3D3D3.CGColor;
        contentView.frame = CGRectMake(contentRect.origin.x, SCREEN_HEIGHT, contentRect.size.width, contentRect.size.height);
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = [UIColor clearColor];
        [self addSubview:coverView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverview)];
        [coverView addGestureRecognizer:tap];
        
        ADLSearchAnimateView *searchView = [ADLSearchAnimateView searchAnimateViewWithFrame:CGRectMake(0, 0, contentRect.size.width, 50) placeholder:ADLString(@"search") verticalMargin:8 instant:YES];
        searchView.delegate = self;
        [contentView addSubview:searchView];
        self.searchView = searchView;
    }
    [self addSubview:contentView];
    
    self.dataArr = [[NSMutableArray alloc] init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"phone" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.nationArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    [self.dataArr addObjectsFromArray:self.nationArr];
    
    self.key = [ADLLocalizedHelper helper].currentLanguage;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+top, contentF.size.width, contentF.size.height-top-50)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 36;
    tableView.delegate = self;
    tableView.dataSource = self;
    [contentView addSubview:tableView];
    self.tableView = tableView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        contentView.frame = contentF;
    }];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectNationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nation"];
    if (cell == nil) {
        cell = [[ADLSelectNationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nation" cellW:self.contentView.frame.size.width cellH:36];
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titLab.text = dict[self.key];
    cell.codeLab.text = dict[@"locale"];
    cell.phoneLab.text = dict[@"code"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.finish) {
        self.finish(self.dataArr[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self removeView];
}

#pragma mark ------ ADLSearchAnimateViewDelegate ------
- (void)didClickCancleButton {
    if (self.searchView) {
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.nationArr];
        [self.tableView reloadData];
    } else {
        [self removeView];
    }
}

- (void)textFieldTextDidChanged:(NSString *)text {
    [self.dataArr removeAllObjects];
    if (text.length == 0) {
        [self.dataArr addObjectsFromArray:self.nationArr];
    } else {
        for (NSDictionary *dict in self.nationArr) {
            if ([[[dict[self.key] stringValue] lowercaseString] containsString:[text lowercaseString]] || [dict[@"code"] containsString:text]) {
                [self.dataArr addObject:dict];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)didClickSearchDoneButton:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark ------ 点击遮罩 ------
- (void)clickCoverview {
    if ([self.searchView editing]) {
        [self.searchView endEditing];
    } else {
        if (self.finish) {
            self.finish(nil);
        }
        [self removeView];
    }
}

#pragma mark ------ 移除 ------
- (void)removeView {
    CGRect frame = self.contentView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
