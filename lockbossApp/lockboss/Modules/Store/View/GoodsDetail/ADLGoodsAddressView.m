//
//  ADLGoodsAddressView.m
//  lockboss
//
//  Created by adel on 2019/5/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsAddressView.h"
#import "ADLGlobalDefine.h"

@interface ADLGoodsAddressView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^finish) (NSMutableDictionary *selectDict, BOOL addAddress);
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@end

@implementation ADLGoodsAddressView

+ (instancetype)addressViewWithArray:(NSMutableArray *)addressArr addressId:(NSString *)addressId finish:(void (^)(NSMutableDictionary *, BOOL))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds addressArr:addressArr addressId:addressId finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame addressArr:(NSMutableArray *)addressArr addressId:(NSString *)addressId finish:(void (^)(NSMutableDictionary *, BOOL))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        self.addressId = addressId;
        [self initializationView:addressArr];
    }
    return self;
}

- (void)initializationView:(NSMutableArray *)addressArr {
    self.dataArr = addressArr;
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [coverView addGestureRecognizer:tap];
    
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, hei, wid, hei*0.7)];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.layer.cornerRadius = 5;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, hei*0.7-VIEW_HEIGHT-BOTTOM_H, wid, VIEW_HEIGHT);
    addBtn.backgroundColor = APP_COLOR;
    [addBtn setTitle:@"选择其他地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAddAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:addBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_HEIGHT, 0, wid-VIEW_HEIGHT*2, VIEW_HEIGHT)];
    titleLab.text = @"选择配送地址";
    titleLab.textColor = COLOR_333333;
    titleLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [panelView addSubview:titleLab];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-VIEW_HEIGHT, 0, VIEW_HEIGHT, VIEW_HEIGHT)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:closeBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT, wid, hei*0.7-VIEW_HEIGHT*2-BOTTOM_H)];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [panelView addSubview:tableView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake(0, hei*0.3, wid, hei*0.7);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.textLabel.numberOfLines = 0;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([self.addressId isEqualToString:[dict[@"id"] stringValue]]) {
        cell.textLabel.textColor = APP_COLOR;
        cell.imageView.image = [UIImage imageNamed:@"shop_address_select"];
    } else {
        cell.textLabel.textColor = COLOR_333333;
        cell.imageView.image = [UIImage imageNamed:@"shop_address_normal"];
    }
    cell.textLabel.text = dict[@"fullAddress"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.finish) {
        self.finish(self.dataArr[indexPath.row], NO);
    }
    [self clickClose];
}

#pragma mark ------ 添加收货地址 ------
- (void)clickAddAddressBtn {
    if (self.finish) {
        self.finish(self.dataArr[0], YES);
    }
    [self clickClose];
}

#pragma mark ------ 关闭 ------
- (void)clickClose {
    CGRect frame = self.panelView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
