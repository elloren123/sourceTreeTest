//
//  ADLPayOrdersViewController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPayOrdersViewController.h"


#import "ADLSearchOrderController.h"
#import "ADLOrderPayController.h"
#import "ADLOrderDetailController.h"
#import "ADLGoodsEvaluateController.h"
#import "ADLServiceEvaluateController.h"

#import "ADLTitleView.h"
#import "ADLSearchFakeView.h"
#import "ADLOrderListCell.h"
#import "ADLBlankView.h"
#import "ADLCommentVController.h"
#import "ADLDinnerOrderTableCell.h"
#import "ADLPayViewController.h"
#import "ADLDinnerListController.h"
#import "ADLDinnerOrderDetailController.h"

@interface ADLPayOrdersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray    *ordersArray;  //订单集合
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) ADLBlankView      *blankView;
@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, strong) UIView            *dinnerOrderView;    //餐饮订单view
@property (nonatomic, assign) NSInteger   currentPage;    //请求页
@property (nonatomic, assign) NSInteger   currentsize;    //请求到的数量
@property (nonatomic, assign) NSInteger   totalSize;      //总数量
@property (nonatomic, assign) BOOL        successToPayFlag; //'去支付'成功标志
@end

@implementation ADLPayOrdersViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orderStatusChanged:(NSNotification *)noti {
    NSLog(@"订单列表界面通知信息: %@", noti.userInfo);
    
    self.currentPage = 1;
    self.currentsize = 0;
    self.totalSize   = 0;
    [self.ordersArray removeAllObjects];
    [self.tableView reloadData];
    
    //获取订单数据
    [self getOrdersDataWithIndex:self.index showLoading:YES];
}
- (void)didToPaySuccess {
    self.successToPayFlag = YES;
}
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:) name:@"ORDER_STATUS_CHANGED_NOTICATION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didToPaySuccess) name:@"DID_TO_PAY_SUCCESS_NOTICATION" object:nil];
}

#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
            
        default:
            NSLog(@"default: sender.tag = %zd", sender.tag);
            [self pushToTargetViewContrlWith:sender.tag];
            break;
    }
}

- (void)createNavigationView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"餐饮订单";
    [navView addSubview:titLab];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentView];
    [self addNotifications];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.successToPayFlag) {
        self.successToPayFlag = NO;
        self.currentPage = 1;
        self.currentsize = 0;
        self.totalSize   = 0;
        [self.ordersArray removeAllObjects];
        [self.tableView reloadData];
        
        //重新获取数据
        [self getOrdersDataWithIndex:self.index showLoading:YES];
    }
}

- (void)createContentView {
    
    
    //------ *** ------ 餐饮订单view
    self.dinnerOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    [self.view addSubview:self.dinnerOrderView];
    
    
    self.index = 0;
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"全部",@"待支付",@"已支付",@"已完成",@"已取消", @"已退款"]];
    [self.dinnerOrderView addSubview:titleView];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.currentPage = 1;
        weakSelf.currentsize = 0;
        weakSelf.totalSize   = 0;
        [weakSelf.ordersArray removeAllObjects];
        [weakSelf.tableView reloadData];
        
        weakSelf.index = index;
        [weakSelf getOrdersDataWithIndex:index showLoading:YES];
    };
    
    
    //初始化集合
    self.ordersArray = [NSMutableArray array];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.rowHeight = 170;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        //重新刷新(从0开始)
        weakSelf.currentPage = 1;
        weakSelf.currentsize = 0;
        weakSelf.totalSize   = 0;
        [weakSelf.ordersArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf getOrdersDataWithIndex:weakSelf.index showLoading:NO];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getOrdersDataWithIndex:weakSelf.index showLoading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    [self.dinnerOrderView addSubview:tableView];
    self.tableView = tableView;
    
    
    //请求数据
    self.currentPage = 1;
    self.currentsize = 0;
    self.totalSize   = 0;
    self.successToPayFlag = NO;
    [self getOrdersDataWithIndex:0 showLoading:YES];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ordersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headView.backgroundColor = COLOR_F2F2F2;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*
    ADLDinnerOrderTableCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"dinnerOrderCell"];
    if (orderCell == nil) {
        orderCell = [[ADLDinnerOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dinnerOrderCell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [orderCell createCellGoodLabel:dict[@"orderGoods"]];
    }
    
    orderCell.shopName.text = dict[@"shopName"];
    [orderCell.shopImgV sd_setImageWithURL:[NSURL URLWithString:dict[@"shopImg"]] placeholderImage:[UIImage imageNamed:@"icon_chanpjiemian"]];
    orderCell.orderStatus.text = [self getOrderStatusString:dict[@"status"]];
    orderCell.goodLeadLbl.text = [NSString stringWithFormat:@"%@ 等%zd件商品", dict[@"orderGoods"][0][@"goodsName"], [dict[@"orderGoods"] count]];
    orderCell.deleteBtn.tag = 1000*indexPath.section+1;
    orderCell.cancelBtn.tag = 1000*indexPath.section+2;
    orderCell.toPayBtn.tag = 1000*indexPath.section+3;
    orderCell.againBtn.tag = 1000*indexPath.section+4;
    orderCell.refundBtn.tag = 1000*indexPath.section+5;
    orderCell.appraiseBtn.tag = 1000*indexPath.section+6;
    
    [orderCell updateCellSubviewFrame:dict[@"status"]];
    
    __weak typeof(self)WeakSelf = self;
    orderCell.BtnClickedBlock = ^(NSInteger tag) {
        NSLog(@"tag = %zd", tag);
        [WeakSelf pushToTargetViewContrlWith:tag];
    };
    
    return orderCell;*/
    
    UITableViewCell *ordersCell = [tableView dequeueReusableCellWithIdentifier:@"ordersCell"];
    if (ordersCell == nil) {
        ordersCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        ordersCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([ordersCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[ordersCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    [ordersCell.contentView addSubview:contentView];
    
    NSDictionary *dict = self.ordersArray[indexPath.section];
    
    //商家名称
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH/2, 40)];
    shopName.font = [UIFont systemFontOfSize:15];
    shopName.textAlignment = NSTextAlignmentLeft;
    shopName.textColor = [UIColor blackColor];
    shopName.text = dict[@"shopName"];
    [contentView addSubview:shopName];
    
    //订单状态
    UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-12, 0, SCREEN_WIDTH/2, 40)];
    statusLbl.font = [UIFont systemFontOfSize:14];
    statusLbl.textAlignment = NSTextAlignmentRight;
    statusLbl.textColor = COLOR_E0212A;
    statusLbl.text = [self getOrderStatusString:dict[@"status"]];
    [contentView addSubview:statusLbl];
    
    //商家图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 80, 80)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"shopImg"]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    [contentView addSubview:imgView];
    
    //商品等...
    UILabel *leadTextLab = [[UILabel alloc] initWithFrame:CGRectMake(96, 40, SCREEN_WIDTH/2, 24)];
    leadTextLab.font = [UIFont systemFontOfSize:15];
    leadTextLab.textAlignment = NSTextAlignmentLeft;
    leadTextLab.textColor = [UIColor blackColor];
    leadTextLab.text = [NSString stringWithFormat:@"%@ 等%zd件商品", dict[@"orderGoods"][0][@"goodsName"], [dict[@"orderGoods"] count]];
    [contentView addSubview:leadTextLab];
    
    //总金额
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-12, 40, SCREEN_WIDTH/2, 32)];
    moneyLbl.font = [UIFont systemFontOfSize:14];
    moneyLbl.textAlignment = NSTextAlignmentRight;
    moneyLbl.textColor = [UIColor blackColor];
    moneyLbl.text = [NSString stringWithFormat:@"￥%@", dict[@"payAmount"]];
    [contentView addSubview:moneyLbl];
    
    
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(96, 64, SCREEN_WIDTH/2, 56)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, [dict[@"orderGoods"] count]*20.0);
    [contentView addSubview:scrollView];
    for (int i = 0 ; i < [dict[@"orderGoods"] count]; i++) {
        UILabel *goodLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*i, SCREEN_WIDTH/2, 20)];
        goodLbl.font = [UIFont systemFontOfSize:13.5];
        goodLbl.textAlignment = NSTextAlignmentLeft;
        goodLbl.textColor = [UIColor lightGrayColor];
        [scrollView addSubview:goodLbl];
        
        NSDictionary *gdict = dict[@"orderGoods"][i];
        goodLbl.text = [NSString stringWithFormat:@"%@(%@) x%@", gdict[@"goodsName"], gdict[@"goodsProperty"], gdict[@"goodsNum"]];
    }
        
    
    //'删除'button
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/5-30, 127, SCREEN_WIDTH/5, 34)];
    deleteBtn.layer.cornerRadius = 18.0;
    deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    deleteBtn.layer.borderWidth = 1.0;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = 1000*indexPath.section+1;
    [contentView addSubview:deleteBtn];
    
    
    //'取消'button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34)];
    cancelBtn.layer.cornerRadius = 18.0;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 1000*indexPath.section+2;
    [contentView addSubview:cancelBtn];
    
    
    //'去支付'button
    UIButton *toPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
    toPayBtn.layer.cornerRadius = 18.0;
    toPayBtn.layer.borderColor = COLOR_E0212A.CGColor;
    toPayBtn.layer.borderWidth = 1.0;
    toPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [toPayBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
    [toPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [toPayBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    toPayBtn.tag = 1000*indexPath.section+3;
    [contentView addSubview:toPayBtn];
    
    
    //'再来一单'button
    UIButton *againBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
    againBtn.layer.cornerRadius = 18.0;
    againBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    againBtn.layer.borderWidth = 1.0;
    againBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [againBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [againBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    againBtn.tag = 1000*indexPath.section+4;
    [contentView addSubview:againBtn];
    
    
    //'退款'button
    UIButton *refundBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
    refundBtn.layer.cornerRadius = 18.0;
    refundBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    refundBtn.layer.borderWidth = 1.0;
    refundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [refundBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
    [refundBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    refundBtn.tag = 1000*indexPath.section+5;
    [contentView addSubview:refundBtn];
    
    
    //'去评价'button
    UIButton *appraiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
    appraiseBtn.layer.cornerRadius = 18.0;
    appraiseBtn.layer.borderColor = COLOR_E0212A.CGColor;
    appraiseBtn.layer.borderWidth = 1.0;
    appraiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [appraiseBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
    [appraiseBtn setTitle:@"去评价" forState:UIControlStateNormal];
    [appraiseBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    appraiseBtn.tag = 1000*indexPath.section+6;
    [contentView addSubview:appraiseBtn];
    
    if ([dict[@"status"] intValue] == 0) {//待支付
        deleteBtn.hidden = YES;
        cancelBtn.frame  = CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34);
        toPayBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        againBtn.hidden  = YES;
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 1) {//待接单(已支付)
        deleteBtn.hidden = YES;
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.hidden  = YES;
        refundBtn.frame  = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 2) {//待处理
        deleteBtn.hidden = YES;
        cancelBtn.frame  = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        toPayBtn.hidden  = YES;
        againBtn.hidden  = YES;
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 3) { //配送中
        deleteBtn.hidden = YES;
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 4) { //已完成
        deleteBtn.frame  = CGRectMake(SCREEN_WIDTH*2/5-30, 127, SCREEN_WIDTH/5, 34);
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.frame   = CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34);
        refundBtn.hidden = YES;
        appraiseBtn.frame = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        
    } else if ([dict[@"status"] intValue] == 5) { //已取消
        deleteBtn.frame  = CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34);
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 6) { //已关闭
        deleteBtn.frame  = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.hidden  = YES;
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
        
    } else if ([dict[@"status"] intValue] == 7) { //退款申请中
        deleteBtn.hidden = YES;
        cancelBtn.hidden = YES;
        toPayBtn.hidden  = YES;
        againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        refundBtn.hidden = YES;
        appraiseBtn.hidden = YES;
    }
    
    //若订单已评价过
    if ([dict[@"evaluate"] floatValue] > 0) {
        appraiseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [appraiseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [appraiseBtn setTitle:@"已评价" forState:UIControlStateNormal];
        appraiseBtn.enabled = NO;
    }
    
    
    return ordersCell;
}
- (NSString *)getOrderStatusString:(NSString *)status {
//    NSLog(@"订单状态status : %@", status);
    NSString *staString = @"待支付";//status为0时
    if (status.intValue == 1) {
        staString = @"待接单";
    } else if (status.intValue == 2) {
        staString = @"待处理";
    } else if (status.intValue == 3) {
        staString = @"配送中";
    } else if (status.intValue == 4) {
        staString = @"已完成";
    } else if (status.intValue == 5) {
        staString = @"已取消";
    } else if (status.intValue == 6) {
        staString = @"已关闭";
    } else if (status.intValue == 7) {
        staString = @"退款申请中";
    }
    return staString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLDinnerOrderDetailController *vc = [[ADLDinnerOrderDetailController alloc] init];
    vc.orderInfos = self.ordersArray[indexPath.section];
//    NSLog(@"订单详情: %@", vc.orderInfos);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ 跳转界面 ------
- (void)pushToTargetViewContrlWith:(NSInteger)tag {
    NSInteger index = tag%1000;
    if (index == 1) {   //删除订单
        NSInteger section = tag/1000;
        NSDictionary *dict = self.ordersArray[section];
        [self deleteOrder:dict[@"id"] section:section];
        
    } else if (index == 2) { //取消订单
        NSInteger section = tag/1000;
        [self cancelOrder:[self.ordersArray[section] objectForKey:@"id"]];
        
    } else if (index == 3) { //去支付 
        NSInteger section = tag/1000;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.ordersArray[section]];
        
        
        ADLPayViewController *vc = [[ADLPayViewController alloc] init];
        vc.stoImgUrl = [dict[@"shopImg"] stringValue];//防止为null;
        vc.storeId   = dict[@"shopId"];
        vc.shopName  = dict[@"shopName"];
        vc.sendBill  = dict[@"freight"];
        vc.totalMoney = dict[@"payAmount"];
        vc.orderDict  = [NSMutableDictionary dictionaryWithDictionary:dict];
        vc.FromOrdersVCFlag = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == 4) { //再来一单
        NSInteger section = tag/1000;
        ADLDinnerListController *vc = [[ADLDinnerListController alloc] init];
        vc.vcTitle = [self.ordersArray[section] objectForKey:@"shopName"];
        vc.storeId = [self.ordersArray[section] objectForKey:@"shopId"];
        vc.stoImgUrl = [[self.ordersArray[section] objectForKey:@"shopImg"] stringValue];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == 5) { //退款
        NSInteger section = tag/1000;
        NSDictionary *dict = self.ordersArray[section];
        [self orderRefund:dict[@"id"]];
        
    } else if (index == 6) { //去评价
        NSInteger section = tag/1000;
        
        ADLCommentVController *vc = [[ADLCommentVController alloc] init];
        vc.orderDict = [NSMutableDictionary dictionaryWithDictionary:self.ordersArray[section]];
//        NSLog(@"vc.orderDict = %@", vc.orderDict);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ------ 获取所有订单数据 ------
- (void)getOrdersDataWithIndex:(NSInteger)index showLoading:(BOOL)showLoading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self dealwithOrderTypeWithIndex:index] forKey:@"status"];
    [params setValue:@(self.currentPage) forKey:@"page"];
    NSLog(@"请求参数: params = %@", params);
  
    if (showLoading){
        [ADLToast showLoadingMessage:ADLString(@"loading")];
    }
    
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/listForUser.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (showLoading){
            [ADLToast hide];
        }
        
//        NSLog(@"请求所有订单数据返回: %@", responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {//成功
            
            self.currentsize += [responseDict[@"pageSize"] integerValue];
            self.totalSize = [responseDict[@"total"] integerValue];//订单总数
            NSLog(@"self.currentsize = %zd", self.currentsize);
            NSLog(@"self.totalSize = %zd", self.totalSize);
            
            NSArray *orderList = responseDict[@"data"];
            if (orderList.count != 0) {
                self.currentPage += 1;//页码+1
                
                for (NSDictionary *dict in orderList) {
                    [self.ordersArray addObject:dict];
                }
            }
            NSLog(@"订单数量: ordersArray.count = %zd", (NSInteger)self.ordersArray.count);
            [self.tableView reloadData];
            
            [self dealwithTableViewFooterWithCount:self.ordersArray.count];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (showLoading){
            [ADLToast hide];
        }
    }];
}

#pragma mark ------ 处理订单类型Index ------
- (NSNumber *)dealwithOrderTypeWithIndex:(NSInteger)index {
    if (index == 0) {
        return nil;
    } else if (index == 1) {
        return @(0);
    } else if (index == 2) {
        return @(1);
    } else if (index == 3) {
        return @(4);
    } else if (index == 4) {
        return @(5);
    } else if (index == 5) {
        return @(7);
    } else {
        return @(0);
    }
}

#pragma mark ------ 处理订单类型空视图 ------
- (void)dealwithTableViewFooterWithCount:(NSInteger)count {
    if (self.totalSize <= self.currentsize) {
        self.tableView.mj_footer.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = NO;
    }
    
    if (count == 0) {
        switch (self.index) {
            case 0:
                self.blankView.promptLab.text = @"暂无订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_all"];
                break;
                 
            case 1:
                self.blankView.promptLab.text = @"暂无待支付订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dzf"];
                break;
                
            case 2:
                self.blankView.promptLab.text = @"暂无已支付订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dfh"];
                break;
                
            case 3:
                self.blankView.promptLab.text = @"暂无已完成订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dfh"];
                break;
                
            case 4:
                self.blankView.promptLab.text = @"暂无已取消订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"data_blank"];
                break;
                
            case 5:
                self.blankView.promptLab.text = @"暂无已退款订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"data_blank"];
                break;
        }
        self.tableView.tableFooterView = self.blankView;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无订单" backgroundColor:COLOR_F2F2F2];
        _blankView.imageView.image = [UIImage imageNamed:@"blank_order_all"];
    }
    return _blankView;
}

#pragma mark ------ 删除订单 ------
-(void)deleteOrder:(NSString *)orderId section:(NSInteger)section {
//    NSLog(@"待删除订单号: %@", orderId);
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/deleteForUser.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求删除订单返回: %@", responseDict);
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast showMessage:@"删除订单成功"];
            
            [self.ordersArray removeObjectAtIndex:section];
            [self.tableView reloadData];
            
        } else {
            [ADLToast showMessage:@"删除订单失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时" duration:2.0];
        } else {
            [ADLToast hide];
        }
    }];
}

#pragma mark ------ 取消订单 ------
-(void)cancelOrder:(NSString *)orderId {
//    NSLog(@"待取消的订单号: %@", orderId);
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"id"];
    [params setValue:@"5"    forKey:@"status"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/changeStatus.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求取消订单返回: %@", responseDict);
        
        NSString *title = @"取消订单失败";
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            title = @"取消订单成功";

        }
        [ADLToast showMessage:title];
        if ([title containsString:@"成功"]) {
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_STATUS_CHANGED_NOTICATION" object:nil];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时" duration:2.0];
        } else {
            [ADLToast hide];
        }
    }];
}
#pragma mark ------ 订单退款 ------
-(void)orderRefund:(NSString *)orderId {
//    NSLog(@"待退款订单号: %@", orderId);
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/orderRefund.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求退款返回: %@", responseDict);
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast showMessage:@"退款申请提交成功"];
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_STATUS_CHANGED_NOTICATION" object:nil];
            
        } else {
            [ADLToast showMessage:@"退款申请提交失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时" duration:2.0];
        } else {
            [ADLToast hide];
        }
    }];
}

#pragma mark ------ 再来一单 ------
-(void)orderAgain:(NSString *)orderId {
    NSLog(@"再来一单订单号: %@", orderId);
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/orderAgain.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求再来一单返回: %@", responseDict);
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];

        } else {
            [ADLToast showMessage:@"失败!"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        } else {
            [ADLToast hide];
        }
    }];
}

@end
