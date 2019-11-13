//
//  ADLStorageBoxPayView.m
//  lockboss
//
//  Created by adel on 2019/10/24.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLStorageBoxPayView.h"
#import "ADLLinelabel.h"
@interface ADLStorageBoxPayView ()

@property (nonatomic, copy) void (^finishBlock) (NSString *payway);
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic ,strong) NSDictionary *payDic;//储物箱的支付信息
@property (nonatomic ,copy) NSString *selPayWay;//1微信，2支付宝，3其它

@end

@implementation ADLStorageBoxPayView

+(instancetype)showPayViewWithMessage:(NSDictionary *)payDic finishBlock:(void (^)(NSString * _Nonnull))finishBlock {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds Message:payDic finishBlock:finishBlock];
}

-(instancetype)initWithFrame:(CGRect)frame Message:(NSDictionary *)payDic finishBlock:(void (^)(NSString * _Nonnull))finishBlock{
    if (self = [super initWithFrame:frame]) {
        self.finishBlock = finishBlock;
        self.payDic = payDic;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *coverView = [[UIView alloc] initWithFrame:window.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
        [coverView addGestureRecognizer:tap];
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2, SCREEN_HEIGHT, 330, 400)];
        panelView.backgroundColor = [UIColor whiteColor];
        panelView.layer.cornerRadius = 5;
        panelView.clipsToBounds = YES;
        [self addSubview:panelView];
        self.panelView = panelView;
        
        //********UI子控件********
        UILabel *titLab = [self createLabelFrame:CGRectMake(28, 23, 330-28-10, 14) font:14 text:@"购买储物箱需使用权限" texeColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]];
        [panelView addSubview:titLab];
        
        UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(31, 68, 90, 95)];
        moneyView.backgroundColor = [UIColor colorWithRed:255/255.0 green:216/255.0 blue:1/255.0 alpha:1.0];
        moneyView.layer.cornerRadius = 5;
        [panelView addSubview:moneyView];
        UILabel *moneyTitLab = [self createLabelFrame:CGRectMake(0, 11, 90, 14) font:14 text:@"住宿期内" texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        moneyTitLab.textAlignment = NSTextAlignmentCenter;
        [moneyView addSubview:moneyTitLab];
        
        NSString *priceString = @"";
        if (self.payDic&&[self.payDic objectForKey:@"box_price"]) {
            priceString = [NSString stringWithFormat:@"￥%@",[self.payDic objectForKey:@"box_price"]];
        }
        UILabel *moneyNumLab = [self createLabelFrame:CGRectMake(0, 42, 90, 16) font:20 text:priceString texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        moneyNumLab.font = [UIFont boldSystemFontOfSize:20];
        moneyNumLab.textColor = UIColorFromRGB(0xDA2F2D);
        moneyNumLab.textAlignment = NSTextAlignmentCenter;
        [moneyView addSubview:moneyNumLab];
        
        //原价20
        NSString *original_price = [NSString stringWithFormat:@"原价:%@",[self.payDic objectForKey:@"box_original_price"]];
        CGFloat titleW = [ADLUtils calculateString:original_price rectSize:CGSizeMake(MAXFLOAT, 14) fontSize:10].width;
        ADLLinelabel *lineLab = [[ADLLinelabel alloc] initWithFrame:CGRectMake((90-titleW-10)/2, 73, titleW+10, 14)];
        lineLab.font = [UIFont systemFontOfSize:10];
        lineLab.text = original_price;
        lineLab.textColor = COLOR_333333;
        lineLab.textAlignment = NSTextAlignmentCenter;
        [moneyView addSubview:lineLab];
        
        UILabel *paywayTit = [self createLabelFrame:CGRectMake(28, 199, 330-28-10, 14) font:14 text:@"选择支付方式" texeColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]];
        [panelView addSubview:paywayTit];
        
        UIButton *zfbBtn = [self createButtonFrame:CGRectMake(31, 229, 100, 38) imageName:@"icon_boxpay_zfb" title:nil titleColor:nil font:0 target:self action:@selector(payWayChoice:)];
        zfbBtn.tag = 1000;
        zfbBtn.layer.borderColor = UIColorFromRGB(0x009FE8).CGColor;
        zfbBtn.layer.borderWidth = 0.5;
        [panelView addSubview:zfbBtn];
        self.selPayWay = @"2";//默认选中支付宝 ?? TODO
        UIButton *wxBtn = [self createButtonFrame:CGRectMake(161, 229, 100, 38) imageName:@"icon_boxpay_wx" title:nil titleColor:nil font:0 target:self action:@selector(payWayChoice:)];
        wxBtn.tag = 2000;
        wxBtn.layer.borderColor = COLOR_CCCCCC.CGColor;
        wxBtn.layer.borderWidth = 0.5;
        [panelView addSubview:wxBtn];
        
        UIButton *payBtn = [self createButtonFrame:CGRectMake(65, 328, 200, 36) imageName:nil title:@"支付" titleColor:[UIColor whiteColor] font:12 target:self action:@selector(goPayMoney)];
        payBtn.backgroundColor = UIColorFromRGB(0xDA2F2D);
        payBtn.layer.cornerRadius = 3.8;
        [panelView addSubview:payBtn];
        //********UI子控件********
        
        
        [window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.5;
            panelView.frame = CGRectMake((SCREEN_WIDTH-330)/2, (SCREEN_HEIGHT-400)/2, 330, 400);
        }];
        
    }
    return self;
}

#pragma mark ------ 支付方式 ------
-(void)payWayChoice:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if (tag == 1000) {//支付宝
        sender.layer.borderColor = UIColorFromRGB(0x009FE8).CGColor;
        UIButton *wxBtn = [self.panelView viewWithTag:2000];
        wxBtn.layer.borderColor = COLOR_CCCCCC.CGColor;
        self.selPayWay = @"2";
    }else {
        sender.layer.borderColor = UIColorFromRGB(0x009FE8).CGColor;
        UIButton *zfbBtn = [self.panelView viewWithTag:1000];
        zfbBtn.layer.borderColor = COLOR_CCCCCC.CGColor;
        self.selPayWay = @"1";
    }
}
//支付
-(void)goPayMoney {
    if(self.finishBlock){
        self.finishBlock(self.selPayWay);
    }
    [self clickClose];
}

#pragma mark ------ b关闭 ------
- (void)clickClose {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = CGRectMake((SCREEN_WIDTH-330)/2, SCREEN_HEIGHT, 330, 400);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
