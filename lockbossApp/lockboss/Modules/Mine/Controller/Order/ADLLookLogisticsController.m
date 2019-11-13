//
//  ADLLookLogisticsController.m
//  lockboss
//
//  Created by adel on 2019/7/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLookLogisticsController.h"
#import "ADLLogisticsCell.h"
#import <YYText.h>

@interface ADLLookLogisticsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@end

@implementation ADLLookLogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"物流信息"];
    self.rowHArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H+12, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.logisticsDict[@"expressName"] && self.logisticsDict[@"shipCode"]) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *comLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, SCREEN_WIDTH-24, 20)];
        comLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        comLab.textColor = COLOR_333333;
        comLab.text = [NSString stringWithFormat:@"快递公司：%@",self.logisticsDict[@"expressName"]];
        [headerView addSubview:comLab];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 52, SCREEN_WIDTH-24, 20)];
        numLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        numLab.textColor = COLOR_333333;
        numLab.userInteractionEnabled = YES;
        numLab.text = [NSString stringWithFormat:@"快递单号：%@",self.logisticsDict[@"shipCode"]];
        [headerView addSubview:numLab];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressExpNumberGes:)];
        [numLab addGestureRecognizer:longPress];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = COLOR_F2F2F2;
        [headerView addSubview:bottomView];
        
        if ([self.logisticsDict[@"expressPhone"] stringValue].length > 0) {
            YYLabel *contactLab = [[YYLabel alloc] initWithFrame:CGRectMake(12, 88, SCREEN_WIDTH-24, 20)];
            [headerView addSubview:contactLab];
            NSString *contactStr = [NSString stringWithFormat:@"快递公司电话：%@",self.logisticsDict[@"expressPhone"]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:contactStr];
            attributeStr.yy_font = [UIFont systemFontOfSize:FONT_SIZE];
            attributeStr.yy_color = COLOR_333333;
            __weak typeof(self)weakSelf = self;
            [attributeStr yy_setTextHighlightRange:NSMakeRange(7, contactStr.length-7) color:COLOR_0083FD backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",weakSelf.logisticsDict[@"expressPhone"]]];
                    [[UIApplication sharedApplication] openURL:callUrl];
                });
            }];
            contactLab.attributedText = attributeStr;
            
            bottomView.frame = CGRectMake(0, 124, SCREEN_WIDTH, 8);
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 132);
            
        } else {
            bottomView.frame = CGRectMake(0, 88, SCREEN_WIDTH, 8);
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 96);
        }
        tableView.tableHeaderView = headerView;
    }
    [self getLogisticsData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLLogisticsCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.infLab.text = dict[@"context"];
    cell.timeLab.text = dict[@"time"];
    if (indexPath.row == 0) {
        cell.imgView.hidden = NO;
        cell.topView.hidden = YES;
    } else {
        cell.imgView.hidden = YES;
        cell.topView.hidden = NO;
    }
    if (indexPath.row == self.dataArr.count-1) {
        cell.bottomView.hidden = YES;
    } else {
        cell.bottomView.hidden = NO;
    }
    return cell;
}

#pragma mark ------ 复制快递单号 ------
- (void)longPressExpNumberGes:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.logisticsDict[@"shipCode"];
        [ADLToast showMessage:@"快递单号复制成功"];
    }
}

#pragma mark ------ 获取物流信息 ------
- (void)getLogisticsData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.logisticsDict[@"suborderId"] forKey:@"suborderId"];
    [ADLNetWorkManager postWithPath:k_query_logistics parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            for (NSDictionary *dict in resArr) {
                CGFloat contentH = [ADLUtils calculateString:dict[@"context"] rectSize:CGSizeMake(SCREEN_WIDTH-54, MAXFLOAT) fontSize:13].height+39;
                [self.rowHArr addObject:@(contentH)];
            }
            [self.dataArr addObjectsFromArray:resArr];
            [self.tableView reloadData];
        }
    } failure:nil];
}

@end
