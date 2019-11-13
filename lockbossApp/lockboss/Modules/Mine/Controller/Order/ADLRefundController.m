//
//  ADLRefundController.m
//  lockboss
//
//  Created by adel on 2019/7/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRefundController.h"
#import "ADLStoreOrderController.h"

#import "ADLOrderDetailCell.h"
#import "ADLAttributeFlowLayout.h"
#import "ADLGoodsAttributeCell.h"
#import "ADLKeyboardMonitor.h"
#import "ADLTextView.h"

@interface ADLRefundController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ADLTextViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat collectH;
@property (nonatomic, strong) NSString *content;
@end

@implementation ADLRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"退款"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+8)];
    headerView.backgroundColor = COLOR_F2F2F2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, VIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 200, VIEW_HEIGHT)];
    titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    titLab.textColor = COLOR_333333;
    if (self.service) {
        titLab.text = @"申请退款的服务";
    } else {
        titLab.text = @"申请退款的商品";
    }
    [headerView addSubview:titLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT+7.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATOR_COLOR;
    [headerView addSubview:line];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableHeaderView = headerView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ADLAttributeFlowLayout *tagLayout = [[ADLAttributeFlowLayout alloc] init];
    tagLayout.minimumInteritemSpacing = 10;
    tagLayout.minimumLineSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, VIEW_HEIGHT+10, SCREEN_WIDTH-24, 10) collectionViewLayout:tagLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLGoodsAttributeCell class] forCellWithReuseIdentifier:@"cell"];
    [self initTags];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.collectH+VIEW_HEIGHT*2+400)];
    footerView.backgroundColor = COLOR_F2F2F2;
    
    UIView *reasonView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, self.collectH+VIEW_HEIGHT+20)];
    reasonView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:reasonView];
    
    UILabel *reaLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, VIEW_HEIGHT)];
    reaLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    reaLab.textColor = COLOR_333333;
    reaLab.text = @"申请原因";
    [reasonView addSubview:reaLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = SEPARATOR_COLOR;
    [reasonView addSubview:lineView];
    [reasonView addSubview:collectionView];
    
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectH+VIEW_HEIGHT+36, SCREEN_WIDTH, 135+VIEW_HEIGHT+12)];
    descView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:descView];
    
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, VIEW_HEIGHT)];
    desLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    desLab.textColor = COLOR_333333;
    desLab.text = @"原因说明";
    [descView addSubview:desLab];
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, VIEW_HEIGHT, SCREEN_WIDTH-24, 135) limitLength:200];
    textView.placeholder = @"请描述具体原因...";
    textView.bgColor = COLOR_F2F2F2;
    textView.delegate = self;
    [descView addSubview:textView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, self.collectH+VIEW_HEIGHT*2+300, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    tableView.tableFooterView = footerView;
    
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refundArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.refundArr[indexPath.row][@"service"]) {
        return 146;
    } else {
        return 116;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLOrderDetailCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (goodsCell == nil) {
        goodsCell = [[NSBundle mainBundle] loadNibNamed:@"ADLOrderDetailCell" owner:nil options:nil].lastObject;
        goodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        goodsCell.actionBtn.hidden = YES;
    }
    NSDictionary *dict = self.refundArr[indexPath.row];
    BOOL service = [dict[@"orderType"] boolValue];
    if (service) {
        [goodsCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"serviceImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        goodsCell.nameLab.text = dict[@"serviceName"];
        goodsCell.descLab.text = [NSString stringWithFormat:@"数量：%@",dict[@"num"]];
        goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"price"] doubleValue]];
    } else {
        [goodsCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"goodsImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        goodsCell.nameLab.text = dict[@"goodsName"];
        goodsCell.descLab.text = dict[@"attribute"];
        goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"price"] doubleValue]];
        goodsCell.serNameLab.text = dict[@"serviceStr"];
        goodsCell.serMoneyLab.text = dict[@"startingPrice"];
    }
    return goodsCell;
}

#pragma mark ------ UICollectionView Delegate && dataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.item];
    cell.text = dict[@"tagName"];
    if ([dict[@"selected"] boolValue]) {
        cell.attrLab.layer.borderColor = APP_COLOR.CGColor;
        cell.attrLab.textColor = APP_COLOR;
    } else {
        cell.attrLab.layer.borderColor = COLOR_D3D3D3.CGColor;
        cell.attrLab.textColor = COLOR_333333;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *muDict = self.dataArr[indexPath.item];
    if ([muDict[@"selected"] boolValue] == NO) {
        for (NSMutableDictionary *dict in self.dataArr) {
            [dict setValue:@(0) forKey:@"selected"];
        }
        [muDict setValue:@(1) forKey:@"selected"];
    }
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.item];
    CGFloat tagW = [ADLUtils calculateString:dict[@"tagName"] rectSize:CGSizeMake(SCREEN_WIDTH-24, 36) fontSize:13].width+20;
    return CGSizeMake(tagW, 36);
}

#pragma mark ------ 开始输入 ------
- (void)textViewDidBeginEdit:(UIView *)textView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

#pragma mark ------ 输入结束 ------
- (void)textViewDidEndEdit:(UITextView *)textView {
    self.content = textView.text;
}

#pragma mark ------ 初始化售后标签 ------
- (void)initTags {
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:@"不想要了" forKey:@"tagName"];
    [dict1 setValue:@(1) forKey:@"selected"];
    [dict1 setValue:@(7) forKey:@"tagId"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setValue:@"买多了" forKey:@"tagName"];
    [dict2 setValue:@(0) forKey:@"selected"];
    [dict2 setValue:@(8) forKey:@"tagId"];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setValue:@"七天无理由" forKey:@"tagName"];
    [dict3 setValue:@(0) forKey:@"selected"];
    [dict3 setValue:@(3) forKey:@"tagId"];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setValue:@"未按约定时间发货" forKey:@"tagName"];
    [dict4 setValue:@(0) forKey:@"selected"];
    [dict4 setValue:@(10) forKey:@"tagId"];
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
    [dict5 setValue:@"其他" forKey:@"tagName"];
    [dict5 setValue:@(0) forKey:@"selected"];
    [dict5 setValue:@(5) forKey:@"tagId"];
    
    if (self.service) {
        [self.dataArr addObjectsFromArray:@[dict1,dict2,dict5]];
    } else {
        [self.dataArr addObjectsFromArray:@[dict1,dict2,dict3,dict4,dict5]];
    }
    [self.collectionView reloadData];
    self.collectH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionView.frame = CGRectMake(12, VIEW_HEIGHT+10, SCREEN_WIDTH-24, self.collectH);
}

#pragma mark ------ 提交申请 ------
- (void)clickSubmitApplyBtn {
    if (self.content.length == 0) {
        [ADLToast showMessage:@"请输入申请原因"];
        return;
    }
    if ([ADLUtils hasEmoji:self.content]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.suborderId forKey:@"suborderId"];
    [params setValue:@(0) forKey:@"type"];
    
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"selected"] boolValue]) {
            [params setValue:dict[@"tagId"] forKey:@"tag"];
            break;
        }
    }
    NSInteger num = 0;
    for (NSDictionary *dict in self.refundArr) {
        if (self.service) {
            num = num+[dict[@"num"] integerValue];
        } else {
            num = num+[dict[@"goodsNum"] integerValue];
        }
    }
    [params setValue:@(num) forKey:@"num"];
    [params setValue:self.content forKey:@"reason"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_add_after_sale parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"售后申请添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[ADLStoreOrderController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            });
        }
    } failure:nil];
}

#pragma mark ------ 移除键盘监听 ------
- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
