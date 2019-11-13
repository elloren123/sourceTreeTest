//
//  ADLNewUserView.m
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNewUserView.h"
#import "ADLNewUserCell.h"
#import "ADLGlobalDefine.h"
#import "ADLUserModel.h"
#import "ADLApiDefine.h"
#import "ADLNetWorkManager.h"

@interface ADLNewUserView ()<UITableViewDelegate,UITableViewDataSource,ADLNewUserCellDelegate>
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ADLNewUserView

+ (instancetype)nerUserViewWithArr:(NSArray *)dataArr {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds dataArr:dataArr];
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr {
    if (self = [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray arrayWithArray:dataArr];
        [self initializationSubView];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationSubView {
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    CGFloat imageW = 360;
    if (SCREEN_WIDTH == 320) imageW = 320;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imageW)/2, (SCREEN_HEIGHT-imageW*1.26)/2-35, imageW, imageW*1.26)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"new_user" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    [self addSubview:imageView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-18, imageView.frame.origin.y+imageView.frame.size.height+30, 36, 36)];
    [closeBtn setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.alpha = 0.5;
    [self addSubview:closeBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imageW*0.7)/2, imageView.frame.origin.y+imageW*0.543, imageW*0.7,  imageW*0.673)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 78;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLNewUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newuser"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLNewUserCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.monLab.text = [NSString stringWithFormat:@"满%@可用",dict[@"orderAmount"]];
    cell.moneyLab.text = dict[@"amount"];
    cell.titLab.text = dict[@"name"];
    if ([dict[@"enable"] intValue] == 1) {
        [cell.useBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        cell.useBtn.backgroundColor = APP_COLOR;
        cell.useBtn.enabled = YES;
    } else {
        [cell.useBtn setTitle:@"已领取" forState:UIControlStateNormal];
        cell.useBtn.backgroundColor = COLOR_999999;
        cell.useBtn.enabled = NO;
    }
    return cell;
}

#pragma mark ------ 领取优惠券 ------
- (void)didClickLingQuBtn:(UIButton *)sender {
    sender.enabled = NO;
    ADLNewUserCell *cell = (ADLNewUserCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"couponId"];
    [ADLNetWorkManager postWithPath:k_draw_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableDictionary *muDict = self.dataArr[indexPath.row];
            [muDict setValue:@(0) forKey:@"enable"];
            [self.tableView reloadData];
        }
        sender.enabled = YES;
    } failure:^(NSError *error) {
        sender.enabled = YES;
    }];
}

#pragma mark ------ 关闭 ------
- (void)clickCloseBtn {
    [self removeFromSuperview];
}

@end
