//
//  ADLOrderViewController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderViewController.h"
#import "ADLOrderVCAddressView.h"
#import "ADLPayViewController.h"
#import "ADLAddNotesController.h"
#import "ADLEditAddressController.h"
#import "ADLAddressView.h"
#import "ADLTimeOrStamp.h"

#import <UIImageView+WebCache.h>

@interface ADLOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL    didAddAddressFlag;    //添加过收货地址flag
@property (nonatomic, strong) UILabel *addrLbl;       //收货地址label
@property (nonatomic, strong) UILabel *personInfoLbl; //收货人信息label
@property (nonatomic, strong) UILabel *timeLbl;       //收货时间label
@property (nonatomic, strong) UILabel *notesLbl;      //备注信息label
@property (nonatomic, strong) UILabel *toolNumLbl;    //餐具数量label
@property (nonatomic, strong) UILabel *totalMoneyLbl;    //订单总金额label
@property (nonatomic, strong) UIView  *darkView;
@property (nonatomic, strong) ADLAddressView        *addressView;       //收货地址view
@property (nonatomic, strong) ADLOrderVCAddressView *timeSelectView;    //时间选择view
@property (nonatomic, strong) UIView                *toolNumSelectView; //餐具数量选择view
@property (nonatomic, strong) NSArray *titleArr;


@end


@implementation ADLOrderViewController


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)finishedAddOrDeleteAddressAction {
    if (self.addressView.itemArray.count != 0) {
        NSLog(@"有地址!!!");
        self.didAddAddressFlag = YES;
    } else {
        NSLog(@"无地址!!!");
        self.didAddAddressFlag = NO;
    }
}
#pragma mark ------ 添加通知 ------
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedAddOrDeleteAddressAction) name:@"FINISHED_ADD_OR_DELETE_ADDRESS_NOTICATION" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentView];
    [self createDarkView];
    [self addNotifications];
    [self getAddressListData];
}

- (void)createNavigationView {
    NSLog(@"self.itemArr = %@", self.itemArray);
    
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
    titLab.text = @"提交订单";
    [navView addSubview:titLab];
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    NSLog(@"sender.tag = %zd", sender.tag);
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 102:   //提交订单
            if (self.didAddAddressFlag) {
                [self submitBtnAction];
            } else {
                [ADLToast showMessage:@"您还未添加收货地址!" duration:2.0];
            }
            break;
        
        case 201:   //选择地址
            self.darkView.hidden = NO;
            self.addressView.hidden = NO;
            break;
        
        case 202:   //选择时间
            [self.timeSelectView updateViewInfos];
            self.darkView.hidden = NO;
            self.timeSelectView.hidden = NO;
            break;
            
        case 301:   //添加备注信息
            [self addNotesInfoAction];
            break;
            
        case 302:   //选择餐具数量
            self.darkView.hidden = NO;
            self.toolNumSelectView.hidden = NO;
            break;

            
        default:
            break;
    }
}

//跳转'支付'界面
- (void)submitBtnAction {
    ADLPayViewController *vc = [[ADLPayViewController alloc] init];
    vc.stoImgUrl  = self.stoImgUrl;
    vc.storeId    = self.storeId;
    vc.shopName   = self.shopName;
    vc.sendBill   = self.sendBill;
    vc.totalMoney = self.totalMoneyLbl.text;
    vc.orderDict = [NSMutableDictionary dictionaryWithDictionary:[self getOrderInfoDict]];
    vc.storeLocation = self.storeLocation;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableDictionary *)getOrderInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.addressView.itemArray[0]];//收货地址信息
    
    if (![self.notesLbl.text isEqualToString:@"口味, 偏好等要求"]) {
        [dict setValue:self.notesLbl.text forKey:@"userMsg"];//用户备注信息
    }
    //配送时间 (时间戳)
    if ([self.timeLbl.text isEqualToString:@"大约30分钟"]) {
//        [dict setValue:[NSString stringWithFormat:@"%zd", [ADLTimeOrStamp getCurrentTimestamp]+1800] forKey:@"appointmentTime"];//时间戳类型
        
        NSInteger timestamp = [ADLTimeOrStamp getCurrentTimestamp]+1800;
        [dict setValue:[ADLTimeOrStamp getTimeFromTimestamp:timestamp format:@"YYYY-MM-dd HH:mm:ss"] forKey:@"appointmentTime"];//时间string
    } else {
        NSString *timeStr = [ADLTimeOrStamp getCurrentTime:@"YYYY-MM-dd HH:mm"];
        timeStr = [timeStr substringWithRange:NSMakeRange(0, 11)];
        NSLog(@"timeStr = %@", timeStr);
//        NSInteger timestamp = [ADLTimeOrStamp timeSwitchTimestamp:[NSString stringWithFormat:@"%@%@", timeStr, self.timeLbl.text] andFormatter:@"YYYY-MM-dd HH:mm"];
//        [dict setValue:[NSString stringWithFormat:@"%zd", timestamp] forKey:@"appointmentTime"];//时间戳类型
        
        [dict setValue:[NSString stringWithFormat:@"%@%@:00", timeStr, self.timeLbl.text] forKey:@"appointmentTime"];//时间string
    }
    //餐具数量
    if ([self.toolNumLbl.text containsString:@"份"]) {
        [dict setValue:[self.toolNumLbl.text substringWithRange:NSMakeRange(0, 1)] forKey:@"tablewareNum"];
    } else {
        [dict setValue:@"0" forKey:@"tablewareNum"];
    }
    //酒店ID
    [dict setValue:@"" forKey:@"companyId"];
    
    return dict; 
}

//跳转'添加备注'界面
- (void)addNotesInfoAction {
    ADLAddNotesController *vc = [[ADLAddNotesController alloc] init];
    
    __weak typeof(self)WeakSelf = self;
    vc.addNotesInfoBlock = ^(NSString * _Nonnull text, NSMutableArray * _Nonnull markArr) {
        if (text.length != 0 || markArr.count != 0) {
//            NSLog(@"text = %@", text);
            WeakSelf.notesLbl.text = text;
        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createContentView {
    NSInteger number = self.itemArray.count;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-44-BOTTOM_H)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, 360+number*50);
    [self.view addSubview:scrollView];
    
    
    
    
    //------ *** ------ 地址选择区域
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    addressBtn.backgroundColor = [UIColor whiteColor];
    addressBtn.tag = 201;
    [addressBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addressBtn];
    
    UILabel *addrTxt = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 75, 30)];
    addrTxt.textAlignment = NSTextAlignmentLeft;
    addrTxt.font = [UIFont systemFontOfSize:16];
    addrTxt.textColor = [UIColor darkGrayColor];
    addrTxt.text = @"收货地址: ";
    [addressBtn addSubview:addrTxt];
    
    //地址label
    UILabel *addrLab = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, SCREEN_WIDTH-125, 50)];
    addrLab.textAlignment = NSTextAlignmentLeft;
    addrLab.font = [UIFont systemFontOfSize:15];
    addrLab.textColor = [UIColor darkGrayColor];
    addrLab.numberOfLines = 0;
    addrLab.text = @"西丽阳光工业园";
    [addressBtn addSubview:addrLab];
    self.addrLbl = addrLab;
    
    //收货人信息label
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, SCREEN_WIDTH-50, 20)];
    infoLab.textAlignment = NSTextAlignmentLeft;
    infoLab.font = [UIFont systemFontOfSize:13];
    infoLab.textColor = [UIColor lightGrayColor];
    infoLab.text = @"张三 (先生)  13888888888";
    [addressBtn addSubview:infoLab];
    self.personInfoLbl = infoLab;

    UIImageView *netIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 27, 8, 16)];
    netIcon1.image = [UIImage imageNamed:@"icon_xiao"];
    [addressBtn addSubview:netIcon1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 69, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [addressBtn addSubview:line];
    
    
    
    
    
    //------ *** ------ 时间选择区域
    UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 40)];
    timeBtn.backgroundColor = [UIColor whiteColor];
    timeBtn.tag = 202;
    [timeBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:timeBtn];
    
    UILabel *nowLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/3, 40)];
    nowLab.textAlignment = NSTextAlignmentLeft;
    nowLab.font = [UIFont systemFontOfSize:16];
    nowLab.textColor = [UIColor lightGrayColor];
    nowLab.text = @"立即送出";
    [timeBtn addSubview:nowLab];
    
    //收货时间label
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 0, SCREEN_WIDTH/2, 40)];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:16];
    timeLab.textColor = COLOR_E0212A;
    timeLab.text = @"大约30分钟";
    [timeBtn addSubview:timeLab];
    self.timeLbl = timeLab;
    
    UIImageView *netIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 12, 8, 16)];
    netIcon2.image = [UIImage imageNamed:@"icon_xiao"];
    [timeBtn addSubview:netIcon2];
    
    
    
    
    //------ *** ------ 订单区域
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 120+number*50)];
    orderView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:orderView];
    
    UILabel *shopLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    shopLab.textAlignment = NSTextAlignmentLeft;
    shopLab.font = [UIFont systemFontOfSize:16];
    shopLab.textColor = [UIColor blackColor];
    shopLab.text = self.shopName;
    [orderView addSubview:shopLab];
    
    for (int i = 0 ; i < number; i++) {
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 45+50*i, 40, 40)];
//        iconImg.image = [UIImage imageNamed:@"icon_chanpin"];
        [iconImg sd_setImageWithURL:[NSURL URLWithString:[self.itemArray[i] objectForKey:@"goodImg"]] placeholderImage:[UIImage imageNamed:@"icon_kong1"]];
        [orderView addSubview:iconImg];
        
        UILabel *goodName = [[UILabel alloc] initWithFrame:CGRectMake(70, 45+50*i, SCREEN_WIDTH/2, 24)];
        goodName.textAlignment = NSTextAlignmentLeft;
        goodName.font = [UIFont systemFontOfSize:14];
        goodName.textColor = [UIColor blackColor];
        goodName.text = self.itemArray[i][@"goodName"];
        [orderView addSubview:goodName];
        
        UILabel *goodNumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 68+50*i, SCREEN_WIDTH/2, 16)];
        goodNumber.textAlignment = NSTextAlignmentLeft;
        goodNumber.font = [UIFont systemFontOfSize:12];
        goodNumber.textColor = [UIColor grayColor];
        goodNumber.text = [NSString stringWithFormat:@"x%@", self.itemArray[i][@"goodNumber"]];
        [orderView addSubview:goodNumber];
        
        UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3-25, 50+50*i, SCREEN_WIDTH/3, 30)];
        moneyLab.textAlignment = NSTextAlignmentRight;
        moneyLab.font = [UIFont systemFontOfSize:16];
        moneyLab.textColor = [UIColor blackColor];
        moneyLab.text = [NSString stringWithFormat:@"￥%.2f", ([self.itemArray[i][@"goodNumber"] integerValue])*([self.itemArray[i][@"goodPrice"] floatValue])];
        [orderView addSubview:moneyLab];
    }
    
    UILabel *peiSongLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 40+number*50, 100, 40)];
    peiSongLab.textAlignment = NSTextAlignmentLeft;
    peiSongLab.font = [UIFont systemFontOfSize:16];
    peiSongLab.textColor = [UIColor blackColor];
    peiSongLab.text = @"配送费";
    [orderView addSubview:peiSongLab];
    
    UILabel *peiSongFei = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 40+number*50, SCREEN_WIDTH/2, 40)];
    peiSongFei.textAlignment = NSTextAlignmentRight;
    peiSongFei.font = [UIFont systemFontOfSize:16];
    peiSongFei.textColor = [UIColor blackColor];
    peiSongFei.text = [NSString stringWithFormat:@"￥%@", self.sendBill];
    [orderView addSubview:peiSongFei];
    
    //小计总金额label
    UILabel *totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 80+number*50, SCREEN_WIDTH/2, 40)];
    totalMoney.textAlignment = NSTextAlignmentRight;
    totalMoney.font = [UIFont systemFontOfSize:18];
    totalMoney.textColor = COLOR_E0212A;
    totalMoney.text = [NSString stringWithFormat:@"小计: %@", [self getTotalMoney:peiSongFei.text]];
    [orderView addSubview:totalMoney];
    
    
    
    //------ *** ------ 备注信息区域
    UIButton *notesBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 240+number*50, SCREEN_WIDTH, 40)];
    notesBtn.backgroundColor = [UIColor whiteColor];
    notesBtn.tag = 301;
    [notesBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:notesBtn];
    
    UILabel *notesText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 45, 40)];
    notesText.textAlignment = NSTextAlignmentLeft;
    notesText.font = [UIFont systemFontOfSize:15];
    notesText.textColor = [UIColor grayColor];
    notesText.text = @"备注";
    [notesBtn addSubview:notesText];
    
    //备注信息label
    UILabel *noteInfo = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-95, 40)];
    noteInfo.textAlignment = NSTextAlignmentRight;
    noteInfo.font = [UIFont systemFontOfSize:13];
    noteInfo.textColor = [UIColor lightGrayColor];
    noteInfo.text = @"口味, 偏好等要求";
    [notesBtn addSubview:noteInfo];
    self.notesLbl = noteInfo;
    
    UIImageView *netIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 12, 8, 16)];
    netIcon3.image = [UIImage imageNamed:@"icon_xiao"];
    [notesBtn addSubview:netIcon3];
    
    
    
    
    //------ *** ------ 餐具选择区域
    UIButton *toolBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 280+number*50, SCREEN_WIDTH, 40)];
    toolBtn.backgroundColor = [UIColor whiteColor];
    toolBtn.tag = 302;
    [toolBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:toolBtn];
    
    UILabel *toolText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/3, 40)];
    toolText.textAlignment = NSTextAlignmentLeft;
    toolText.font = [UIFont systemFontOfSize:15];
    toolText.textColor = [UIColor grayColor];
    toolText.text = @"餐具数量";
    [toolBtn addSubview:toolText];
    
    //备注信息label
    UILabel *toolInfo = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 0, SCREEN_WIDTH/2, 40)];
    toolInfo.textAlignment = NSTextAlignmentRight;
    toolInfo.font = [UIFont systemFontOfSize:13];
    toolInfo.textColor = [UIColor lightGrayColor];
    toolInfo.text = @"未选择";
    [toolBtn addSubview:toolInfo];
    self.toolNumLbl = toolInfo;
    
    UIImageView *netIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 12, 8, 16)];
    netIcon4.image = [UIImage imageNamed:@"icon_xiao"];
    [toolBtn addSubview:netIcon4];
    
    
    
    
    
    //------ *** ------ 支付方式区域
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 320+number*50, SCREEN_WIDTH, 40)];
    payView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:payView];
    
    UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/3, 40)];
    payType.textAlignment = NSTextAlignmentLeft;
    payType.font = [UIFont systemFontOfSize:15];
    payType.textColor = [UIColor grayColor];
    payType.text = @"支付方式";
    [payView addSubview:payType];
    
    //在线支付label
    UILabel *payInfo = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 0, SCREEN_WIDTH/2, 40)];
    payInfo.textAlignment = NSTextAlignmentRight;
    payInfo.font = [UIFont systemFontOfSize:15];
    payInfo.textColor = [UIColor grayColor];
    payInfo.text = @"在线支付";
    [payView addSubview:payInfo];
    
    
    
    
    
    //------ *** ------ 底部灰色区域
    UIView *grayV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-BOTTOM_H, SCREEN_WIDTH, 44+BOTTOM_H)];
    grayV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [self.view addSubview:grayV];
     
    //订单总金额label
    UILabel *sumMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 44)];
    sumMoneyLab.textAlignment = NSTextAlignmentLeft;
    sumMoneyLab.font = [UIFont systemFontOfSize:18];
    sumMoneyLab.textColor = COLOR_E0212A;
    sumMoneyLab.text = [self getTotalMoney:peiSongFei.text];
    [grayV addSubview:sumMoneyLab];
    self.totalMoneyLbl = sumMoneyLab;
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 0, SCREEN_WIDTH/4, 44)];
    submitBtn.backgroundColor = COLOR_E0212A;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 102;
    [grayV addSubview:submitBtn];
}

- (NSString *)getTotalMoney:(NSString *)added {
    CGFloat total = 0;
    for (NSDictionary *dict in self.itemArray) {
        total += [dict[@"goodPrice"] floatValue]*[dict[@"goodNumber"] integerValue];
    }
    
    NSString *money = [NSString stringWithFormat:@"￥%.2f", total+[[added stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue]];
    return money;
}
#pragma mark ------ darkView 手势识别 ------
- (void)darkViewTapAction {
    self.darkView.hidden = YES;
    
    if (self.addressView.hidden == NO) {
        self.addressView.hidden = YES;
    }
    
    if (self.timeSelectView.hidden == NO) {
        self.timeSelectView.hidden = YES;
    }
    
    if (self.toolNumSelectView.hidden == NO) {
        self.toolNumSelectView.hidden = YES;
    }
}
#pragma mark ------ 跳转编辑地址界面 ------
- (void)addOrCancelBtnAction:(NSInteger)tag Dict:(NSDictionary *)dict {
    if (tag == 101) {//添加地址
        ADLEditAddressController *vc = [[ADLEditAddressController alloc] init];
        vc.addNewAddressFlag = YES;
        [self.navigationController pushViewController:vc animated:YES];
   
    } else if (tag == 102) {//取消
        self.darkView.hidden = YES;
        self.addressView.hidden = YES;
        
    } else {    //修改地址
        ADLEditAddressController *vc = [[ADLEditAddressController alloc] init];
        vc.addNewAddressFlag = NO;
        vc.addrDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)createDarkView {
    self.darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.darkView.backgroundColor = [UIColor blackColor];
    self.darkView.alpha = 0.4;
    [self.view addSubview:self.darkView];
    self.darkView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(darkViewTapAction)];
    [self.darkView addGestureRecognizer:tap];
    
    
    __weak typeof(self)WeakSelf = self;
    
    
    // ------ *** ------收货地址view
    self.addressView = [[ADLAddressView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-380-BOTTOM_H, SCREEN_WIDTH, 380+BOTTOM_H)];
    self.addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addressView];
    self.addressView.hidden = YES;
    self.addressView.itemArray = [NSMutableArray array];    //初始化空间
    
    self.addressView.addressViewBtnClickedBlock = ^(NSInteger tag, NSDictionary * _Nonnull dict) {
        //跳转界面
        [WeakSelf addOrCancelBtnAction:tag Dict:dict];
    };
    
    self.addressView.didSelectedRowBlock = ^(NSDictionary * _Nonnull dict) {
        WeakSelf.darkView.hidden = YES;
        WeakSelf.addressView.hidden = YES;
        
        WeakSelf.addrLbl.text = [NSString stringWithFormat:@"%@%@", dict[@"area"], dict[@"address"]];
        
        if ([dict[@"sex"] intValue] == 2) {
            WeakSelf.personInfoLbl.text = [NSString stringWithFormat:@"%@ (先生)    %@", dict[@"consignee"], dict[@"phone"]];
        } else {
            WeakSelf.personInfoLbl.text = [NSString stringWithFormat:@"%@ (女士)    %@", dict[@"consignee"], dict[@"phone"]];
        }
    };
    
    
    // ------ *** ------餐具选择view
    self.toolNumSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-280-BOTTOM_H, SCREEN_WIDTH, 280+BOTTOM_H)];
    self.toolNumSelectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolNumSelectView];
    self.toolNumSelectView.hidden = YES;
    
    self.titleArr = @[@"无需餐具", @"1份", @"2份", @"3份", @"4份", @"5份", @"取消"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 40;
    [self.toolNumSelectView addSubview:tableView];
    
    
    
    // ------ *** ------送餐时间选择view
    ADLOrderVCAddressView *timeView = [[ADLOrderVCAddressView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-280-BOTTOM_H, SCREEN_WIDTH, 280+BOTTOM_H)];
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.hidden = YES;
    [self.view addSubview:timeView];
    self.timeSelectView = timeView;
    
    timeView.didSelectedRowBlock = ^(NSInteger index, NSString * _Nonnull timeStr) {
        [WeakSelf updateTimeLableInfo:index timeStr:timeStr];
    };
}
- (void)updateTimeLableInfo:(NSInteger)index timeStr:(NSString *)timeStr {
    if (index == 0) {
        self.timeLbl.text = @"大约30分钟";
    } else {
        self.timeLbl.text = timeStr;
    }
    
    self.darkView.hidden = YES;
    self.timeSelectView.hidden = YES;
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (orderCell == nil) {
        orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([orderCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[orderCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.text = self.titleArr[indexPath.row];
    [orderCell.contentView addSubview:titleLab];
    
    if (indexPath.row == 0) {
        titleLab.textColor = COLOR_E0212A;
        titleLab.font = [UIFont systemFontOfSize:15];
    } else if (indexPath.row == 6) {
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:15];
    }

    
    return orderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 6) {
        self.toolNumLbl.text = self.titleArr[indexPath.row];
    }
    
    self.darkView.hidden = YES;
    self.toolNumSelectView.hidden = YES;
}

#pragma mark ------ 获取收货地址列表数据 ------
- (void)getAddressListData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"1" forKey:@"page"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    ///请求数据
    __weak typeof(self)WeakSelf = self;
    
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/address/list.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求收货地址列表返回: %@, 当前线程: %@", responseDict, [NSThread currentThread]);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            NSArray *addrList = responseDict[@"data"];
            if (addrList.count != 0) {
                NSLog(@"有地址数据!!!");
                WeakSelf.didAddAddressFlag = YES;
                WeakSelf.addressView.itemArray = [NSMutableArray arrayWithArray:addrList];
                [WeakSelf.addressView updateViewInfos];
                
                //更新收货地址信息(默认最新的地址)
                NSDictionary *dict = addrList.firstObject;
                WeakSelf.addrLbl.text = [NSString stringWithFormat:@"%@%@", dict[@"area"], dict[@"address"]];
                if ([dict[@"sex"] intValue] == 2) {
                    WeakSelf.personInfoLbl.text = [NSString stringWithFormat:@"%@ (先生)    %@", dict[@"consignee"], dict[@"phone"]];
                } else {
                    WeakSelf.personInfoLbl.text = [NSString stringWithFormat:@"%@ (女士)    %@", dict[@"consignee"], dict[@"phone"]];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        }
    }];
}

@end
