//
//  ADLAddressPickerView.m
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAddressPickerView.h"
#import "ADLSearchGoodsCell.h"
#import "ADLGlobalDefine.h"

#import <Masonry.h>

@interface ADLAddressPickerView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^finish) (NSString *address, NSString *addressId);
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *provArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *streArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *titBtn1;
@property (nonatomic, strong) UIButton *titBtn2;
@property (nonatomic, strong) UIButton *titBtn3;
@property (nonatomic, strong) UIButton *titBtn4;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger level;
@end

@implementation ADLAddressPickerView

+ (instancetype)showWithArray:(NSArray *)dataArr level:(NSInteger)level finish:(void (^)(NSString *, NSString *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds dataArray:dataArr level:level finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr level:(NSInteger)level finish:(void (^)(NSString *, NSString *))finish {
    if (self = [super initWithFrame:frame]) {
        self.level = level;
        self.finish = finish;
        if (self.level < 1) self.level = 1;
        [self initSubViewsWithDataArray:dataArr];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)initSubViewsWithDataArray:(NSArray *)dataArr {
    if (dataArr == nil) return;
    self.index = 0;
    self.provArr = [NSMutableArray arrayWithArray:dataArr];
    self.dataArr = [NSMutableArray arrayWithArray:dataArr];
    self.cityArr = [[NSMutableArray alloc] init];
    self.areaArr = [[NSMutableArray alloc] init];
    self.streArr = [[NSMutableArray alloc] init];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [coverView addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-60, 44)];
    titleLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    titleLab.textColor = [UIColor blackColor];
    titleLab.text = @"选择地区";
    [contentView addSubview:titleLab];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    UIButton *titBtn1 = [[UIButton alloc] init];
    [titBtn1 setTitle:@"请选择" forState:UIControlStateNormal];
    [titBtn1 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [titBtn1 setTitleColor:APP_COLOR forState:UIControlStateSelected];
    titBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
    titBtn1.tag = 0;
    titBtn1.selected = YES;
    [titBtn1 addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:titBtn1];
    self.titBtn1 = titBtn1;
    [titBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom);
        make.left.equalTo(contentView).offset(12);
        make.height.equalTo(@30);
    }];
    
    UIButton *titBtn2 = [[UIButton alloc] init];
    [titBtn2 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [titBtn2 setTitleColor:APP_COLOR forState:UIControlStateSelected];
    titBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
    titBtn2.tag = 1;
    [contentView addSubview:titBtn2];
    self.titBtn2 = titBtn2;
    titBtn2.hidden = YES;
    [titBtn2 addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom);
        make.left.equalTo(titBtn1.mas_right).offset(12);
        make.height.equalTo(@30);
    }];
    
    UIButton *titBtn3 = [[UIButton alloc] init];
    [titBtn3 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [titBtn3 setTitleColor:APP_COLOR forState:UIControlStateSelected];
    titBtn3.titleLabel.font = [UIFont systemFontOfSize:14];
    titBtn3.tag = 2;
    [contentView addSubview:titBtn3];
    self.titBtn3 = titBtn3;
    titBtn3.hidden = YES;
    [titBtn3 addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom);
        make.left.equalTo(titBtn2.mas_right).offset(12);
        make.height.equalTo(@30);
    }];
    
    UIButton *titBtn4 = [[UIButton alloc] init];
    [titBtn4 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [titBtn4 setTitleColor:APP_COLOR forState:UIControlStateSelected];
    titBtn4.titleLabel.font = [UIFont systemFontOfSize:14];
    titBtn4.tag = 3;
    [contentView addSubview:titBtn4];
    self.titBtn4 = titBtn4;
    titBtn4.hidden = YES;
    [titBtn4 addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom);
        make.left.equalTo(titBtn3.mas_right).offset(12);
        make.height.equalTo(@30);
    }];
    
    self.btnArr = [[NSMutableArray alloc] initWithObjects:titBtn1,titBtn2,titBtn3,titBtn4, nil];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COLOR_E5E5E5;
    [contentView addSubview:line];
    
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 73, 44, 2)];
    indicatorView.backgroundColor = APP_COLOR;
    [contentView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT*0.7-75)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 44;
    [contentView addSubview:tableView];
    self.tableView = tableView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.3;
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT*0.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.7);
    }];
}

#pragma mark ------ UITableViewDelegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city"];
    if (cell == nil) {
        cell = [[ADLSearchGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
    }
    NSString *nameStr = self.dataArr[indexPath.row][@"areaName"];
    cell.titLab.text = nameStr;
    UIButton *titBtn = self.btnArr[self.index];
    if ([titBtn.titleLabel.text isEqualToString:nameStr]) {
        cell.titLab.textColor = APP_COLOR;
    } else {
        cell.titLab.textColor = COLOR_333333;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (self.index == 0) {
        if (self.level == 1) {
            if (self.finish) {
                self.finish(dict[@"areaName"], [dict[@"areaId"] stringValue]);
            }
            [self clickClose];
        } else {
            [self.cityArr removeAllObjects];
            [self.cityArr addObjectsFromArray:self.provArr[indexPath.row][@"areaTemps"]];
            if (self.cityArr.count == 0) {
                if (self.finish) {
                    self.finish(dict[@"areaName"], [dict[@"areaId"] stringValue]);
                }
                [self clickClose];
            } else {
                [self updateTitleBtn:dict[@"areaName"]];
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:self.cityArr];
            }
        }
    } else if (self.index == 1) {
        if (self.level == 2) {
            if (self.finish) {
                self.finish([NSString stringWithFormat:@"%@%@",self.titBtn1.titleLabel.text,dict[@"areaName"]], [dict[@"areaId"] stringValue]);
            }
            [self clickClose];
        } else {
            [self.areaArr removeAllObjects];
            [self.areaArr addObjectsFromArray:self.cityArr[indexPath.row][@"areaTemps"]];
            if (self.areaArr.count == 0) {
                if (self.finish) {
                    self.finish([NSString stringWithFormat:@"%@%@",self.titBtn1.titleLabel.text,dict[@"areaName"]], [dict[@"areaId"] stringValue]);
                }
                [self clickClose];
            } else {
                [self updateTitleBtn:dict[@"areaName"]];
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:self.areaArr];
            }
        }
    } else if (self.index == 2) {
        if (self.level == 3) {
            if (self.finish) {
                NSString *address = self.titBtn1.titleLabel.text;
                if (![self.titBtn2.titleLabel.text isEqualToString:address]) {
                    address = [NSString stringWithFormat:@"%@%@",address,self.titBtn2.titleLabel.text];
                }
                if (![dict[@"areaName"] isEqualToString:self.titBtn2.titleLabel.text]) {
                    address = [NSString stringWithFormat:@"%@%@",address,dict[@"areaName"]];
                }
                self.finish(address, [dict[@"areaId"] stringValue]);
            }
            [self clickClose];
        } else {
            [self.streArr removeAllObjects];
            [self.streArr addObjectsFromArray:self.areaArr[indexPath.row][@"areaTemps"]];
            if (self.streArr.count == 0) {
                if (self.finish) {
                    NSString *address = self.titBtn1.titleLabel.text;
                    if (![self.titBtn2.titleLabel.text isEqualToString:address]) {
                        address = [NSString stringWithFormat:@"%@%@",address,self.titBtn2.titleLabel.text];
                    }
                    if (![dict[@"areaName"] isEqualToString:self.titBtn2.titleLabel.text]) {
                        address = [NSString stringWithFormat:@"%@%@",address,dict[@"areaName"]];
                    }
                    self.finish(address, [dict[@"areaId"] stringValue]);
                }
                [self clickClose];
            } else {
                [self updateTitleBtn:dict[@"areaName"]];
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:self.streArr];
            }
        }
    } else {
        if (self.finish) {
            NSString *address = self.titBtn1.titleLabel.text;
            if (![self.titBtn2.titleLabel.text isEqualToString:address]) {
                address = [NSString stringWithFormat:@"%@%@",address,self.titBtn2.titleLabel.text];
            }
            if (![self.titBtn3.titleLabel.text isEqualToString:self.titBtn2.titleLabel.text]) {
                address = [NSString stringWithFormat:@"%@%@",address,self.titBtn3.titleLabel.text];
            }
            if (![dict[@"areaName"] isEqualToString:self.titBtn3.titleLabel.text]) {
                address = [NSString stringWithFormat:@"%@%@",address,dict[@"areaName"]];
            }
            self.finish(address, [dict[@"areaId"] stringValue]);
        }
        [self clickClose];
    }
    if (self.index < 4) {
        [tableView setContentOffset:CGPointMake(0, 0)];
        [tableView reloadData];
    }
}

#pragma mark ------ 点击cell更新 ------
- (void)updateTitleBtn:(NSString *)title {
    if (self.index == 3) return;
    CGRect frame = self.indicatorView.frame;
    UIButton *btn1 = self.btnArr[self.index];
    UIButton *btn2 = self.btnArr[self.index+1];
    [btn1 setTitle:title forState:UIControlStateNormal];
    [btn2 setTitle:@"请选择" forState:UIControlStateNormal];
    [self setBtnSelect:btn2];
    btn2.hidden = NO;
    [btn1 sizeToFit];
    [btn2 sizeToFit];
    frame.origin.x = btn1.frame.origin.x+btn1.frame.size.width+12;
    frame.size.width = btn2.frame.size.width;
    self.indicatorView.frame = frame;
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag > self.index+1) {
            obj.hidden = YES;
        }
    }];
    self.index++;
}

#pragma mark ------ 点击标题按钮 ------
- (void)clickTitleBtn:(UIButton *)sender {
    if (sender.selected) return;
    self.index = sender.tag;
    [self setBtnSelect:sender];
    CGRect frame = sender.frame;
    self.indicatorView.frame = CGRectMake(frame.origin.x, 73, frame.size.width, 2);
    [self.dataArr removeAllObjects];
    
    if (self.index == 0) {
        [self.dataArr addObjectsFromArray:self.provArr];
    } else if (self.index == 1) {
        [self.dataArr addObjectsFromArray:self.cityArr];
    } else if (self.index == 2) {
        [self.dataArr addObjectsFromArray:self.areaArr];
    } else {
        [self.dataArr addObjectsFromArray:self.streArr];
    }
    [self.tableView reloadData];
}

#pragma mark ------ 处理选中 ------
- (void)setBtnSelect:(UIButton *)sender {
    [self.tableView setContentOffset:CGPointZero];
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sender == obj) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
}

#pragma mark ------ 关闭 ------
- (void)clickClose {
    CGRect frame = self.contentView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
