//
//  ADLDinnerListController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerListController.h"
#import "ADLListTableCell.h"
#import "ADLDinnerTableCell.h"
#import "ADLDinnerModel.h"
#import "ADLDinnerSizeView.h"
#import "ADLSelectedGoodsView.h"
#import "ADLStoreInfoView.h"
#import "ADLStoreCommentView.h"
#import "ADLStoreOtherInfoView.h"
#import "ADLTitleView.h"

#import "ADLAddNotesController.h"
#import "ADLPayViewController.h"
#import "ADLOrderViewController.h"
#import "ADLNYCommetViewModel.h"
#import "ADLNYOtherInfoViewModel.h"
#import "ADLTimeOrStamp.h"

#define  ADD_BUTTON_TAG     100000
#define  DEL_BUTTON_TAG     1000

@interface ADLDinnerListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ADLStoreInfoView *baseInfoView;
@property (nonatomic, assign) NSInteger        index;
@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UIView         *menuView;     //商家菜单view
@property (nonatomic, strong) UITableView    *listTable;
@property (nonatomic, strong) NSMutableArray *listArray;        //商品品类集合
@property (nonatomic, assign) NSInteger      listTableIndex;    //选中的商品品类编号
@property (nonatomic, strong) UITableView    *dinnerTable;
@property (nonatomic, strong) NSMutableArray *dinnerArray;      //商品列表集合
@property (nonatomic, strong) NSMutableArray *intArray;         //初始化商品集合(当用户清空购物车时, 用此集合进行数据归零)
@property (nonatomic, strong) UIView                *darkView;
@property (nonatomic, strong) ADLDinnerSizeView     *selectView;//商品规格选择view
@property (nonatomic, strong) ADLSelectedGoodsView  *goodView;  //已选商品view

@property (nonatomic, strong) UIView         *grayView;
@property (nonatomic, assign) BOOL           tapDidFlag;        //grayView手势识别flag
@property (nonatomic, strong) UIImageView    *carImg;           //购物车图标imgv
@property (nonatomic, strong) UILabel        *totalSumLab;      //总金额label
@property (nonatomic, strong) UILabel        *goodNumLab;       //总数量label
@property (nonatomic, strong) UIButton       *toPayBtn;         //'去结算'btn

@property (nonatomic, strong) NSMutableDictionary     *storeInfo;           //商家基本信息集合

@property (nonatomic, strong) ADLStoreCommentView     *commetView;     //评论view
@property (nonatomic, assign) NSInteger               cmtTypeIndex;    //评价信息类型index
@property (nonatomic, assign) NSInteger               totalCmtSize;    //总评价数
@property (nonatomic, assign) NSInteger               getCmtSize;      //已获取的评价数
@property (nonatomic, assign) NSInteger               pageIndex;       //待获取的评价页码
@property (nonatomic, assign) BOOL               getCmtDataFlag;       //获取过评价信息数据标志


@property (nonatomic, strong) ADLStoreOtherInfoView   *otherInfoView;       //商家view
@property (nonatomic, assign) BOOL                    getLisenceDataFlag;   //获取过资质信息数据标志

@end

@implementation ADLDinnerListController

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrDeleteItemAction:) name:@"ADD_OR_DELETE_ITEM_NOTICATION" object:nil];
}
//更新已选商品信息
- (void)updateGrayViewUI {
    NSInteger total = 0;
    CGFloat   money = 0;
    for (NSDictionary *dict in self.dinnerArray) {
        NSString *key = [dict allKeys].lastObject;
        
        for (ADLDinnerModel *model in dict[key]) {
            if (model.number.integerValue != 0) {
                total += model.number.integerValue;
                money += model.price.floatValue*model.number.integerValue;
            }
        }
    }
    
    if (total != 0) {
        self.grayView.hidden = NO;
        self.carImg.image = [UIImage imageNamed:@"icon_honggouwuche"];
        self.goodNumLab.hidden = NO;
        self.goodNumLab.text   = [NSString stringWithFormat:@"%zd", total];
        self.totalSumLab.hidden = NO;
        self.totalSumLab.text   = [NSString stringWithFormat:@"￥%.2f", money];
        if (!self.toPayBtn.enabled) {
            self.toPayBtn.backgroundColor = COLOR_E0212A;
            self.toPayBtn.enabled = YES;
            [self.toPayBtn setTitle:@"去结算" forState:UIControlStateNormal];
        }
    } else {
        self.carImg.image = [UIImage imageNamed:@"icon_gouwu"];
        self.goodNumLab.hidden = YES;
        self.goodNumLab.text   = @"0";
        self.totalSumLab.hidden = YES;
        self.totalSumLab.text   = @"￥0";
        if (self.toPayBtn.enabled) {
            self.toPayBtn.backgroundColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
            self.toPayBtn.enabled = NO;
            [self.toPayBtn setTitle:[NSString stringWithFormat:@"%@元起送", self.storeInfo[@"startPrice"]] forState:UIControlStateNormal];
        }
    }
}
//更新已选商品view
- (void)updateGoodView {
    NSMutableArray *itemArr = [NSMutableArray array];
    for (NSDictionary *dict in self.dinnerArray) {
        NSString *key = [dict allKeys].lastObject;
        
        for (ADLDinnerModel *model in dict[key]) {
            if (model.number.integerValue != 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:model.dinnerName forKey:@"goodName"];
                [dict setObject:model.price      forKey:@"goodPrice"];
                [dict setObject:model.number     forKey:@"goodNumber"];
                [itemArr addObject:dict];
            }
        }
    }
    
    self.goodView.itemArray = [NSMutableArray arrayWithArray:itemArr];
    [self.goodView updateUI];
    
    if (itemArr.count == 0) {
        self.darkView.hidden = YES;
        self.tapDidFlag = NO;
        [UIView animateWithDuration:0.5 animations:^{
            //调整frame
            self.goodView.frame = CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-310, SCREEN_WIDTH, 220);
        }];
    }
}

#pragma mark ------ tableView中按钮增减商品数量处理 ------
- (void)addOrDeleteItemAction:(NSNotification *)notification {
    if (self.businessStatus.intValue == 1) {
        [ADLToast showMessage:@"商家未营业"];
        return ;
    }
    
//    NSLog(@"收到通知: %@", notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"Flag"] isEqualToString:@"YES"]) {   //添加
        NSInteger tag = [dict[@"Tag"] integerValue];
        NSInteger section = (tag/ADD_BUTTON_TAG)-1;
        NSInteger row     = tag%ADD_BUTTON_TAG;
        NSString *key = [self.dinnerArray[section] allKeys].firstObject;
        
        //拿到目标字典
        NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
        //拿到目标数组
        NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
        //拿到目标model
        ADLDinnerModel *model = tagArray[row];
        
        //修改购物车
        NSString *num = [NSString stringWithFormat:@"%zd", model.number.integerValue+1];
        [self updateShoppingCart:[model.skuList[0] objectForKey:@"id"] Number:num section:section row:row flag:YES];
        
    } else {//删除
        NSInteger tag = [dict[@"Tag"] integerValue];
        NSInteger section = (tag/DEL_BUTTON_TAG)-1;
        NSInteger row     = tag%DEL_BUTTON_TAG;
        NSString *key = [self.dinnerArray[section] allKeys].firstObject;
        
        //拿到目标字典
        NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
        //拿到目标数组
        NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
        //拿到目标model
        ADLDinnerModel *model = tagArray[row];
        
        //修改购物车
        NSString *num = [NSString stringWithFormat:@"%zd", model.number.integerValue-1];
        [self updateShoppingCart:[model.skuList[0] objectForKey:@"id"] Number:num section:section row:row flag:YES];
    } 
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.storeId = @"123456";
    
    [self createNavigationView];
    [self createStoreInfoView];
    [self createStoreMenuView];
    [self createStoreCommetView];
    [self createStoreOtherInfoView];
    [self createDarkView];
////    [self createSelectView];//暂时不考虑商品分量
    [self addNotifications];
    [self getStoreInfo:@"1"];    //请求商家基本信息
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
    titLab.text = self.vcTitle;
    [navView addSubview:titLab];
}

#pragma mark ------ 按钮点击事件 ------
- (NSMutableArray *)getItemArray {
    NSMutableArray *itemArr = [NSMutableArray array];
    for (NSDictionary *dict in self.dinnerArray) {
        NSString *key = [dict allKeys].lastObject;
        
        for (ADLDinnerModel *model in dict[key]) {
            if (model.number.integerValue != 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:model.goodId     forKey:@"goodId"];
                [dict setValue:model.ImgUrl     forKey:@"goodImg"];
                [dict setValue:model.dinnerName forKey:@"goodName"];
                [dict setValue:model.price      forKey:@"goodPrice"];
                [dict setValue:model.number     forKey:@"goodNumber"];
                [itemArr addObject:dict];
            }
        }
    }
    return itemArr;
}
- (void)clickBtnAction:(UIButton *)sender {
    if (sender.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    
    } else {
        ADLOrderViewController *vc = [[ADLOrderViewController alloc] init];
        vc.stoImgUrl = self.stoImgUrl;
        vc.sendBill = self.storeInfo[@"freight"];//配送费
        vc.storeId  = self.storeId;  //商家Id
        vc.shopName = self.vcTitle; //商家名称
        vc.itemArray = [NSMutableArray arrayWithArray:[self getItemArray]];
        vc.storeLocation = self.storeInfo[@"nowLocation"];
        NSLog(@"商家位置经纬度: %@", vc.storeLocation);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)createStoreInfoView {
    ADLStoreInfoView *infoView = [[ADLStoreInfoView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 164)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    infoView.storeName.text = self.vcTitle;
    [infoView.storeImg sd_setImageWithURL:[NSURL URLWithString:self.stoImgUrl] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    self.baseInfoView = infoView;
    
    
    
    self.index = 0;
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, 164+NAVIGATION_H, SCREEN_WIDTH, 45) titles:@[@"点餐",@"评论",@"商家"]];
    [self.view addSubview:titleView];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.index = index;
        [weakSelf.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        
        if (index == 1 && !weakSelf.getCmtDataFlag) {
            [weakSelf getOrderCommetsInfo];//获取评论信息列表
        }
        
        if (index == 2 && !weakSelf.getLisenceDataFlag) {
            [weakSelf getStoreInfo:@"2"];//获取商家资质信息数据
        }
    };
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+210, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-210)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)createStoreMenuView {
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-210)];
    [self.scrollView addSubview:menuView];
    self.menuView = menuView;
    
    
    //品类view
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_HEIGHT-NAVIGATION_H-210)];
    grayView.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [self.menuView addSubview:grayView];
    
    
    //tableviews
    [self createTableviews];
    
    //grayview
    [self createGrayView];
}

- (void)createTableviews {
    //初始化数据
    self.listTableIndex = 0;    //开始默认为1
    self.listArray   = [NSMutableArray array];
    self.dinnerArray = [NSMutableArray array];
    self.intArray    = [NSMutableArray array];
    
    
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4.0, SCREEN_HEIGHT-NAVIGATION_H-310)];
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.rowHeight = 45;
    listTable.tag = 101;
    [self.menuView addSubview:listTable];
    listTable.backgroundColor = [UIColor clearColor];
    self.listTable = listTable;
    
    

    UITableView *dinnerTable = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH*3/4.0, SCREEN_HEIGHT-NAVIGATION_H-310)];
    dinnerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    dinnerTable.delegate = self;
    dinnerTable.dataSource = self;
    dinnerTable.rowHeight = 74;
    dinnerTable.tag = 201;
    [self.menuView addSubview:dinnerTable];
    self.dinnerTable = dinnerTable;
}

#pragma mark ------ darkView 手势识别 ------
- (void)darkViewTapAction {
    self.tapDidFlag = !self.tapDidFlag;
    
    self.darkView.hidden = YES;
    
    __weak typeof(self)WeakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        WeakSelf.goodView.frame = CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-310, SCREEN_WIDTH, 220);
    }];
}
- (void)createDarkView {
    self.darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-280)];
    self.darkView.backgroundColor = [UIColor clearColor];
//    self.darkView.alpha = 0.4;
    self.darkView.hidden = YES;
    [self.view addSubview:self.darkView];
    
    UITapGestureRecognizer *dvtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(darkViewTapAction)];
    [self.darkView addGestureRecognizer:dvtap];//添加手势
}
//商品规格选择view
- (void)createSelectView {
    self.selectView = [[ADLDinnerSizeView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-100, SCREEN_WIDTH-60, 200)];
    self.selectView.backgroundColor = [UIColor whiteColor];
    self.selectView.layer.cornerRadius = 20;
    [self.view addSubview:self.selectView];
    self.selectView.hidden = YES;
    
    __weak typeof(self)WeakSelf = self;
    //弹窗消失
    self.selectView.dismissBtnAction = ^(NSInteger index, NSString *price) {
        WeakSelf.darkView.hidden = YES;
        WeakSelf.selectView.hidden = YES;
    };
    
    //添加一份商品
    self.selectView.didSelectedBlock = ^(NSInteger dinnerIndex, NSInteger btnTag, NSString * _Nonnull price) {
        NSLog(@"dinnerIndex = %zd, btnTag = %zd, price = %@", dinnerIndex, btnTag, price);
        WeakSelf.darkView.hidden = YES;
        WeakSelf.selectView.hidden = YES;
        [WeakSelf updateGoodCell:dinnerIndex btnTag:btnTag price:price];
    };
}
- (void)updateGoodCell:(NSInteger )index btnTag:(NSInteger)tag price:(NSString *)price {
    
    NSInteger section = (index/ADD_BUTTON_TAG)-1;
    NSInteger row     = index%ADD_BUTTON_TAG;
    NSString *key = [self.dinnerArray[section] allKeys].firstObject;
    
    //拿到目标字典
    NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
    //拿到目标数组
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
    //拿到目标model
    ADLDinnerModel *model = tagArray[row];
    model.number = [NSString stringWithFormat:@"%zd", model.number.integerValue+1];//总数+1;
    if (tag == 1) {
        model.bigNumber = [NSString stringWithFormat:@"%zd", model.bigNumber.integerValue+1];//大份数量+1;
    } else if (tag == 2) {
        model.midNumber = [NSString stringWithFormat:@"%zd", model.midNumber.integerValue+1];//中份数量+1;
    } else if (tag == 3) {
        model.litNumber = [NSString stringWithFormat:@"%zd", model.litNumber.integerValue+1];//小份数量+1;
    }
    
    //替换目标
    [tagArray replaceObjectAtIndex:row withObject:model];
    [tagDict setObject:tagArray forKey:key];
    [self.dinnerArray replaceObjectAtIndex:section withObject:tagDict];
    
    //刷新cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.dinnerTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ------ grayView 手势识别 ------
- (void)grayViewTapAction {
    if (self.goodView.itemArray.count != 0) {//已添加商品到购物车
        
        self.tapDidFlag = !self.tapDidFlag;
        
        if (self.tapDidFlag) {
            self.darkView.hidden = NO;
        } else {
            self.darkView.hidden = YES;
        }
        
        __weak typeof(self)WeakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            if (WeakSelf.tapDidFlag) {
                WeakSelf.goodView.frame = CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-490, SCREEN_WIDTH, 220);
            } else {
                WeakSelf.goodView.frame = CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-310, SCREEN_WIDTH, 220);
            }
        }];
    }
}

#pragma mark ------ 已选商品view中按钮增减商品数量处理 ------
- (void)updateGoodViewAndTableView:(NSString *)goodName flag:(BOOL)flag {
    if (flag) { //增加
        NSInteger section = 0;
        NSInteger row     = 0;
        for (int i = 0 ; i < self.dinnerArray.count; i++) {
            NSString *key = [self.dinnerArray[i] allKeys].firstObject;
            
            //拿到目标字典
            NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[i]];
            //拿到目标数组
            NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
            for (int j = 0 ; j < tagArray.count; j++) {
                //拿到目标model
                ADLDinnerModel *model = tagArray[j];
                if ([model.dinnerName isEqualToString:goodName]) {
                    section = i;
                    row     = j;
                    break;
                }
            }
        }
        NSLog(@"section = %zd, row = %zd", section, row);
        
        NSString *tagKey = [self.dinnerArray[section] allKeys].firstObject;
        NSLog(@"tagKey = %@", tagKey);
        //拿到目标字典
        NSMutableDictionary *tagD = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
        //拿到目标数组
        NSMutableArray *tagArr = [NSMutableArray arrayWithArray:tagD[tagKey]];
        //拿到目标model
        ADLDinnerModel *model = tagArr[row];
//        model.number = [NSString stringWithFormat:@"%zd", model.number.integerValue+1];
//        //替换目标
//        [tagArr replaceObjectAtIndex:row withObject:model];
//        [tagD setObject:tagArr forKey:tagKey];
//        [self.dinnerArray replaceObjectAtIndex:section withObject:tagD];
//
//        //刷新cell
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//        [self.dinnerTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        //修改购物车
        NSString *num = [NSString stringWithFormat:@"%zd", model.number.integerValue+1];
        [self updateShoppingCart:[model.skuList[0] objectForKey:@"id"] Number:num section:section row:row flag:NO];
        
    } else {
        NSInteger section = 0;
        NSInteger row     = 0;
        for (int i = 0 ; i < self.dinnerArray.count; i++) {
            NSString *key = [self.dinnerArray[i] allKeys].firstObject;
            //拿到目标字典
            NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[i]];
            //拿到目标数组
            NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
            for (int j = 0 ; j < tagArray.count; j++) {
                //拿到目标model
                ADLDinnerModel *model = tagArray[j];
                if ([model.dinnerName isEqualToString:goodName]) {
                    section = i;
                    row     = j;
                    break;
                }
            }
        }
        NSLog(@"section = %zd, row = %zd", section, row);
        
        NSString *tagKey = [self.dinnerArray[section] allKeys].firstObject;
        NSLog(@"tagKey = %@", tagKey);
        //拿到目标字典
        NSMutableDictionary *tagD = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
        //拿到目标数组
        NSMutableArray *tagArr = [NSMutableArray arrayWithArray:tagD[tagKey]];
        //拿到目标model
        ADLDinnerModel *model = tagArr[row];
//        model.number = [NSString stringWithFormat:@"%zd", model.number.integerValue-1];
//        //替换目标
//        [tagArr replaceObjectAtIndex:row withObject:model];
//        [tagD setObject:tagArr forKey:tagKey];
//        [self.dinnerArray replaceObjectAtIndex:section withObject:tagD];
//
//        //刷新cell
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//        [self.dinnerTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        
        //修改购物车
        NSString *num = [NSString stringWithFormat:@"%zd", model.number.integerValue-1];
        [self updateShoppingCart:[model.skuList[0] objectForKey:@"id"] Number:num section:section row:row flag:NO];
    }
    
//    [self updateGrayViewUI];
}
- (void)createGrayView {
    ADLSelectedGoodsView *goodV = [[ADLSelectedGoodsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-310, SCREEN_WIDTH, 220)];
    goodV.backgroundColor = COLOR_E0212A;
    [self.menuView addSubview:goodV];
    goodV.hidden = YES;
    self.goodView = goodV;
    
    __weak typeof(self)WeakSelf = self;
    goodV.goodNumChangedBlock = ^(NSString * _Nonnull goodName, BOOL flag) {//当增删商品数量时触发block
        NSLog(@"goodName = %@, flag = %d", goodName, flag);
        [WeakSelf updateGoodViewAndTableView:goodName flag:flag];
    };
    
    goodV.didCleanAllBlock = ^(NSInteger index) {//当点击清空购物车时触发block
//        NSLog(@"清空购物车: %zd", index);
        [ADLAlertView showWithTitle:nil message:@"确定清空购物车?" confirmTitle:@"确定" confirmAction:^{
            [WeakSelf cleanAllGoods];
            
        } cancleTitle:@"取消" cancleAction:nil showCancle:YES];
    };
    
    
    // ------ *** ------
    self.tapDidFlag = NO;
    
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-270, SCREEN_WIDTH, BOTTOM_H+60)];
    self.grayView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    self.grayView.hidden = YES;
    [self.menuView addSubview:self.grayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grayViewTapAction)];
    [self.grayView addGestureRecognizer:tap];//添加手势
    
    
    self.carImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 40, 36)];
    self.carImg.image = [UIImage imageNamed:@"icon_gouwu"];
    [self.grayView addSubview:self.carImg];
    
    
    self.goodNumLab = [[UILabel alloc] initWithFrame:CGRectMake(54, 7   , 19, 19)];
    self.goodNumLab.backgroundColor = COLOR_E0212A;
    self.goodNumLab.layer.cornerRadius = 9.5;
    self.goodNumLab.layer.masksToBounds = YES;
    self.goodNumLab.textAlignment = NSTextAlignmentCenter;
    self.goodNumLab.font = [UIFont systemFontOfSize:12];
    self.goodNumLab.textColor = [UIColor whiteColor];
    self.goodNumLab.text = @"99";
    self.goodNumLab.hidden = YES;
    [self.grayView addSubview:self.goodNumLab];
    
    
    self.totalSumLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 27, SCREEN_WIDTH/2, 28)];
    self.totalSumLab.textAlignment = NSTextAlignmentLeft;
    self.totalSumLab.font = [UIFont systemFontOfSize:20];
    self.totalSumLab.textColor = COLOR_E0212A;
    self.totalSumLab.text = @"￥0";
    self.totalSumLab.hidden = YES;
    [self.grayView addSubview:self.totalSumLab];
    
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-20, 10, SCREEN_WIDTH/4, 40)];
    payBtn.backgroundColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    payBtn.layer.cornerRadius = 5.0;
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = 102;
    payBtn.enabled = NO;
    [self.grayView addSubview:payBtn];
    self.toPayBtn = payBtn;
}

- (void)createStoreCommetView {
    self.totalCmtSize = 0;
    self.getCmtSize   = 0;
    self.pageIndex    = 1;
    self.cmtTypeIndex = 1;
    
    ADLStoreCommentView *comView = [[ADLStoreCommentView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-210)];
    comView.dataArray = [[NSMutableArray alloc] init];
    [self.scrollView addSubview:comView];
    self.commetView = comView;
    
    
    __weak typeof(self)WeakSelf = self;
    comView.didSelectedSegmentedControl = ^(NSInteger index) {
        //清空数据
        [WeakSelf.commetView.dataArray removeAllObjects];
        [WeakSelf.commetView.table reloadData];
        
        self.totalCmtSize = 0;
        self.getCmtSize   = 0;
        self.pageIndex    = 1;
        
        //获取新的评论数据
        WeakSelf.cmtTypeIndex = index+1;
        [WeakSelf getOrderCommetsInfo];
    };
    
    //下拉刷新
    comView.tableViewHeaderRefreshBlock = ^{
        //清空数据
        [WeakSelf.commetView.dataArray removeAllObjects];
        [WeakSelf.commetView.table reloadData];
        
        self.totalCmtSize = 0;
        self.getCmtSize   = 0;
        self.pageIndex    = 1;
        
        //获取新的评论数据
        [WeakSelf getOrderCommetsInfo];
    };
    
    //上拉刷新
    comView.tableViewFooterRefreshBlock = ^{
        //获取新的评论数据
        [WeakSelf getOrderCommetsInfo];
    };
}

- (void)createStoreOtherInfoView {
    ADLStoreOtherInfoView *otherView = [[ADLStoreOtherInfoView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-210)];
    [self.scrollView addSubview:otherView];
    self.otherInfoView = otherView;
}

#pragma mark ------ UITableView ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 101) {
        return 1;
    } else {
        return self.dinnerArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return self.listArray.count;
    
    } else {
        NSInteger countNumber = 0;
        
        NSDictionary *dict = self.dinnerArray[section];
        NSString *key = [dict allKeys].firstObject;
        countNumber = [dict[key] count];
        
        
        return countNumber;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headHeight = 0;
    if (tableView.tag == 201) {
        headHeight = 40;
    }
    return headHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 201) {
        self.listTableIndex = section;
        [self.listTable reloadData];
        
        
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4, 40)];
        
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH*3/4, 30)];
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = [UIFont systemFontOfSize:15.5];
        textLbl.textAlignment = NSTextAlignmentLeft;
        textLbl.text = [self.listArray[section] objectForKey:@"className"];
        [headview addSubview:textLbl];
        
//        NSLog(@"当前section: %zd", section);
        
        return headview;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        ADLListTableCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
        if (listCell == nil) {
            listCell = [[ADLListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
            listCell.selectionStyle = UITableViewCellSelectionStyleNone;
            listCell.listName.text = [self.listArray[indexPath.row] objectForKey:@"className"];
        }
        
        if (indexPath.row == self.listTableIndex) {
            listCell.backgroundColor = [UIColor whiteColor];
            listCell.listName.textColor = COLOR_E0212A;

        } else {
            listCell.backgroundColor = [UIColor clearColor];
            listCell.listName.textColor = [UIColor darkGrayColor];
        }
        
        return listCell;
        
    } else {
        ADLDinnerTableCell *dinnerCell = [tableView dequeueReusableCellWithIdentifier:@"dinnerCell"];
        if (dinnerCell == nil) {
            dinnerCell = [[ADLDinnerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dinnerCell"];
            dinnerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        dinnerCell.addButton.tag = ADD_BUTTON_TAG*(indexPath.section+1)+indexPath.row;   //'+'按钮100000+
        dinnerCell.deleteBtn.tag = DEL_BUTTON_TAG*(indexPath.section+1)+indexPath.row;   //'-'按钮1000+
        
        //设置信息
        NSDictionary *dict = self.dinnerArray[indexPath.section];
        NSString *key = [dict allKeys].firstObject;
        ADLDinnerModel *dModel = dict[key][indexPath.row];
        dinnerCell.dinnerName.text = dModel.dinnerName;
        dinnerCell.soldLbl.text = [NSString stringWithFormat:@"月售:%@份", dModel.soldNumber];
        dinnerCell.leadLbl.text = dModel.leadString;
        dinnerCell.priceLbl.text = [NSString stringWithFormat:@"￥%@", dModel.price];
        dinnerCell.dinnerNum.text = dModel.number;
        //设置产品图片
        [dinnerCell.dinnerImg sd_setImageWithURL:[NSURL URLWithString:dModel.ImgUrl] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
        
        if (dModel.number.intValue == 0) {//当还未选取菜品时
            dinnerCell.deleteBtn.hidden = YES;
            dinnerCell.dinnerNum.hidden = YES;
        } else {
            dinnerCell.deleteBtn.hidden = NO;
            dinnerCell.dinnerNum.hidden = NO;
        }
        
        
        return dinnerCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        if (self.listTableIndex != indexPath.row && indexPath.row >= 0) {//从0开始
            self.listTableIndex = indexPath.row;
            [self.listTable reloadData];
            
            //滚动到指定section
//            [self.dinnerTable setContentOffset:[self getContentOffsize:self.listTableIndex] animated:YES];
            
            
            NSIndexPath *dayOne = [NSIndexPath indexPathForRow:0 inSection:self.listTableIndex];
            [self.dinnerTable scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
- (CGPoint)getContentOffsize:(NSInteger)index {
    CGFloat offSize_Head = 0;
    CGFloat offSize_Cell = 0;
    NSInteger cellCount = 0;
    for (int i = 0 ; i < index; i++) {
        offSize_Head += 40;
        
        NSString *key = [self.dinnerArray[i] allKeys].firstObject;
        cellCount += [self.dinnerArray[i][key] count];
    }
    offSize_Cell = 80*cellCount;
    NSLog(@"head: %f, cell: %f", offSize_Head, offSize_Cell);
    CGPoint pointSize = CGPointMake(0, offSize_Head + offSize_Cell);
    return pointSize;
}

//设置headerview与cell一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.dinnerTable) {
        CGFloat sectionHeaderHeight = 50;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//滚动停止时
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == self.dinnerTable) {
//        NSLog(@"table停止滚动 !!! y: %f", self.dinnerTable.contentOffset.y);
//    }
//}

#pragma mark ------ 获取商家信息 ------
//type: 1.基本信息 2.资质信息，3.法定代表人信息，4.合作信息
-(void)getStoreInfo:(NSString *)type {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"id"];
    [params setValue:type         forKey:@"type"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/store/queryStoreById.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求商家'基本/资质/合作'信息返回: %@", responseDict);
        
        if (type.intValue == 1) {//商家基本信息
            if ([responseDict[@"code"] intValue] == 10000) {    //成功
                self.storeInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[@"data"]];
                [self.toPayBtn setTitle:[NSString stringWithFormat:@"%@元起送", self.storeInfo[@"startPrice"]] forState:UIControlStateNormal];
                
                
                //update infos
                self.baseInfoView.stoAddress.text = self.storeInfo[@"areaDetailed"];

                if ([[self.storeInfo[@"kitchenImg"] stringValue] length] != 0) {
                    //更新厨房照片(照片路径以','隔开)
                    self.otherInfoView.imgUrlArr = [NSMutableArray arrayWithArray:[[self.storeInfo[@"kitchenImg"] stringValue] componentsSeparatedByString:@","]];
                    [self.otherInfoView.collectionView reloadData];
                }
            }
            
            [self getStoreZongHeInfos];//获取商家综合评价信息
            
        } else if (type.intValue == 2) {    //商家资质信息
            
            if ([responseDict[@"code"] intValue] == 10000) {    //成功
                self.getLisenceDataFlag = YES;
                
                //更新资质照片
                NSDictionary *dict = responseDict[@"data"];
                [self.otherInfoView.licenseImgV sd_setImageWithURL:[NSURL URLWithString:[dict[@"licenseImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"icon_kong1"]];
            }
            
            [self getStoreInfo:@"4"];//获取商家合作信息
            
        } else {
            [ADLToast hide];
            if ([responseDict[@"code"] intValue] == 10000) {    //成功
                self.getLisenceDataFlag = YES;
                
                //更新商家营业时间label
                NSDictionary *dict = responseDict[@"data"];
                self.otherInfoView.workTimeLab.text = [NSString stringWithFormat:@"周一至周日 %@-%@", dict[@"startTime"], dict[@"endTime"]];
            }
        }
    } failure:^(NSError *error) {
        if (type.intValue == 1) {
            [self getStoreZongHeInfos];//获取商家综合评价信息
        
        } else if (type.intValue == 2) {
            [self getStoreInfo:@"4"];//获取商家合作信息
            
        } else if (type.intValue == 2) {
            if (error.code == -1001) {
                [ADLToast showMessage:@"网络请求超时!" duration:2.0];
            } else{
                [ADLToast hide];
            }
        }
    }];
}

#pragma mark ------ 获取商家综合评价信息 ------
-(void)getStoreZongHeInfos {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"storeId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/evaluate/storeEvaluateInfo.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求商家综合评价信息返回: %@", responseDict);
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            if (![responseDict[@"data"] isEqual:[NSNull null]]) {
                NSLog(@"!nil");
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseDict[@"data"]];
                [dict setValue:self.storeInfo[@"areaDetailed"] forKey:@"areaDetailed"];
                [dict setValue:self.vcTitle                    forKey:@"shopName"];
                
                //刷新view
                [self.baseInfoView updateStoreInfoView:dict];
                [self.commetView   updateCommentView:dict];
            }
        }
        
        [self getStoreMenu];//获取商家菜单
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        [self getStoreMenu];//获取商家菜单
    }];
}

#pragma mark ------ 获取商家菜单 ------
- (void)getStoreMenu {
//    NSLog(@"storeId: %@", self.storeId);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"storeId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/goods/queryStoreMenu.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求商家菜单返回: %@", responseDict);
        
        [ADLToast hide];
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            
            NSArray *dataArr = responseDict[@"data"];
            NSLog(@"品类数量: %zd", (NSInteger)dataArr.count);
            if (dataArr.count != 0) {
                if (self.grayView.hidden) {
                    self.grayView.hidden = NO;
                    self.goodView.hidden = NO;
                }
                
                [self.listArray removeAllObjects];
                [self.intArray removeAllObjects];
                [self.dinnerArray removeAllObjects];
                
                for (NSDictionary *dict in dataArr) {
                    NSMutableDictionary *secDict = [NSMutableDictionary dictionary];
                    [secDict setValue:dict[@"id"] forKey:@"classId"];   //品类id
                    [secDict setValue:dict[@"classCode"] forKey:@"classCode"];//品类编码
                    [secDict setValue:dict[@"className"] forKey:@"className"];//品类名
                    [self.listArray addObject:secDict];
                    
                    NSMutableArray *goodArray = [NSMutableArray array];//菜单数组集合
                    NSArray *goodsList = dict[@"goodsList"];
//                    NSLog(@"菜单数量: %zd", (NSInteger)goodsList.count);
                    for (NSDictionary *good in goodsList) {
//                        NSLog(@"菜色: %@", good);
                        ADLDinnerModel *model = [[ADLDinnerModel alloc] init];
                        model.goodId     = good[@"id"];
                        model.ImgUrl     = [good[@"thumbnailUrl"] stringValue];   //商品缩略图
                        model.dinnerName = good[@"goodsName"];
                        model.soldNumber = good[@"monthlySale"];
                        model.leadString = good[@"nutritional"];
                        model.price      = good[@"minPrice"];
                        model.number     = @"0";
                        model.bigNumber  = @"0";
                        model.midNumber  = @"0";
                        model.litNumber  = @"0";
                        model.skuList    = [NSArray arrayWithArray:good[@"skuList"]];
//                        NSLog(@"skuList.count = %zd", model.skuList.count);
                        
                        [goodArray addObject:model];
                    }
                    
                    [self.intArray addObject:@{dict[@"className"]:goodArray}];
                }
                //刷新数据
                [self.listTable reloadData];
                
                NSArray *arr = [ADLUtils realDeepCopyWithObject:self.intArray];
                self.dinnerArray = [NSMutableArray arrayWithArray:arr];
//                NSLog(@"intarray.count = %zd,  dinnerArray.count = %zd", (NSInteger)self.intArray.count, (NSInteger)self.dinnerArray.count);
                [self.dinnerTable reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        } else{
            [ADLToast hide];
        }
    }];
}

#pragma mark ------ 修改购物车 ------
- (void)updateShoppingCart:(NSString *)skuId Number:(NSString *)number section:(NSInteger)section row:(NSInteger)row flag:(BOOL)flag {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSLog(@"skuId: %@", skuId);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"storeId"];
    [params setValue:skuId        forKey:@"skuId"];
    [params setValue:number       forKey:@"num"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/goodsCar/deleteOrUpdateGoods.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"修改购物车返回: %@", responseDict);
        
        [ADLToast hide];
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            //拿到品类名
            NSString *key = [self.dinnerArray[section] allKeys].firstObject;
            //拿到目标字典
            NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:self.dinnerArray[section]];
            //拿到目标数组
            NSMutableArray *tagArray = [NSMutableArray arrayWithArray:tagDict[key]];
            //拿到目标model
            ADLDinnerModel *model = tagArray[row];
            model.number = number;//改变数量
            
            //替换目标
            [tagArray replaceObjectAtIndex:row withObject:model];
            [tagDict setObject:tagArray forKey:key];
            [self.dinnerArray replaceObjectAtIndex:section withObject:tagDict];
            
            //刷新cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self.dinnerTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            
            
            [self updateGrayViewUI];
//            if (flag) {
                [self updateGoodView];
//            }
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

#pragma mark ------ 清空购物车 ------
- (void)cleanAllGoods {
    NSLog(@"清空购物车!!!");
    //小菊花
    [ADLToast showLoadingMessage:@"请稍后..."];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"storeId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/goodsCar/deleteOrUpdateGoods.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"清空购物车返回: %@", responseDict);
        
        [ADLToast hide];
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            
            [self.dinnerArray removeAllObjects];
            NSArray *arr = [ADLUtils realDeepCopyWithObject:self.intArray];
            self.dinnerArray = [NSMutableArray arrayWithArray:arr];
            [self.dinnerTable reloadData];
            
            [self updateGrayViewUI];
            [self updateGoodView];
            
            
            [self.goodView.itemArray removeAllObjects];
            [self.goodView updateUI];
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

#pragma mark ------------------ #####*** 评论相关接口 ***##### ------------------
#pragma mark ------ 订单评价列表接口 ------
//type:  1所有评价  2好评  3差评  4有图评论
- (void)getOrderCommetsInfo {
    //小菊花
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId           forKey:@"storeId"];
    [params setValue:@(self.cmtTypeIndex)   forKey:@"type"];
    [params setValue:@(self.pageIndex)      forKey:@"page"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//    NSLog(@"请求评价列表参数: %@", params);
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/evaluate/list.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求评价信息列表返回: %@", responseDict);
        
        if ([self.commetView.table.mj_header isRefreshing]) {
            [self.commetView.table.mj_header endRefreshing];
        }
        if ([self.commetView.table.mj_footer isRefreshing]) {
            [self.commetView.table.mj_footer endRefreshing];
        }
                
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            NSArray *dataArr = responseDict[@"data"];
            NSLog(@"评价信息数量: count = %zd", dataArr.count);
            if (dataArr.count != 0) {
                self.getCmtDataFlag = YES;
                
                self.pageIndex += 1;
                for (NSDictionary *dict in dataArr) {
                    
                    //初始化数据模型
                    ADLNYCommetViewModel *model = [[ADLNYCommetViewModel alloc] init];
                    model.userHeadImgUrl = [dict[@"headShot"] stringValue];
                    model.userName       = dict[@"buyerUserName"];
//                    model.cmtDate        = [[ADLTimeOrStamp getTimeFromTimestamp:[dict[@"addDatetime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm:ss"] substringToIndex:10];
                    model.cmtDate        = [ADLTimeOrStamp getTimeFromTimestamp:[dict[@"addDatetime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm:ss"];
                    model.cmtScore       = dict[@"score"];
                    model.userMsg        = [dict[@"evaluateInfo"] stringValue];
                    model.cmtImgUrl      = [dict[@"imgUrl"] stringValue];
                    model.anonymousFlag  = [dict[@"anonymous"] intValue];
//                    NSLog(@"评价分数: %@", dict[@"score"]);
//                    NSLog(@"评价截图imgUrl: %@", dict[@"imgUrl"]);
//                    NSLog(@"商家回复信息数量: %zd", [dict[@"replys"] count]);
                    
//                    if (model.userMsg.length == 0) {//无评价内容
//                        model.userMsgHeight = 26;
//                    } else {
//                        model.userMsgHeight = [self heightForString:model.userMsg andWidth:SCREEN_WIDTH-88 withFontSize:13]-4;
//                    }
                    model.userMsgHeight = (model.userMsg.length == 0)?26:([self heightForString:model.userMsg andWidth:SCREEN_WIDTH-88 withFontSize:13]-4);
                    
//                    if (model.cmtImgUrl.length == 0) {//没有图片
//                        model.cmtImgHeight = 0;
//                    } else {
//                        model.cmtImgHeight = 80;
//                    }
                    model.cmtImgHeight = (model.cmtImgUrl.length == 0)?0:80;
                    
                    //商家回复信息集合
                    if ([dict[@"replys"] count] != 0) {
                        NSString *replyStr = @"";
                        for (NSDictionary *replyDict in dict[@"replys"]) {
                            replyStr = [NSString stringWithFormat:@"%@商家回复:%@\n", replyStr, replyDict[@"content"]];
                        }
                        model.replyMsg = replyStr;
                        model.replyHeight = [self heightForString:replyStr andWidth:SCREEN_WIDTH-88 withFontSize:12.5]-20;
                    } else {
                        model.replyHeight = 0;
                        model.replyMsg = @"";
                    }

                    [self.commetView.dataArray addObject:model];
                }
                //刷新tableview
                [self.commetView.table reloadData];
                
            } else {
                self.commetView.blankLab.hidden = (self.commetView.dataArray.count == 0)?NO:YES;
            }
            
            self.getCmtSize  += [responseDict[@"pageSize"] integerValue];
            self.totalCmtSize = [responseDict[@"total"] integerValue];
            
            self.commetView.table.mj_footer.hidden = (self.getCmtSize >= self.totalCmtSize)?YES:NO;
        } else {
            [ADLToast showMessage:@"获取评价信息失败"];
        }
    } failure:^(NSError *error) {
//        NSLog(@"error ---> %@", error);
        if ([self.commetView.table.mj_header isRefreshing]) {
            [self.commetView.table.mj_header endRefreshing];
        }
        if ([self.commetView.table.mj_footer isRefreshing]) {
            [self.commetView.table.mj_footer endRefreshing];
        }
        
//        if (error.code == -1001) {
//            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
//        } else {
//            [ADLToast hide];
//        }
    }];
}

//根据字串计算高度
- (CGFloat)heightForString:(NSString *)value andWidth:(CGFloat)width withFontSize:(CGFloat)fontSize {
    // 使用UITextView 的 sizeThatFits 方法计算出字符串的高度后再给 UILabel 使用
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
//    NSLog(@"text高度: height = %f", deSize.height);
    return deSize.height;
}

@end
