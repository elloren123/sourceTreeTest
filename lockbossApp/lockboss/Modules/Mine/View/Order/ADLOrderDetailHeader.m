//
//  ADLOrderDetailGoodsHeader.m
//  lockboss
//
//  Created by adel on 2019/7/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderDetailHeader.h"
#import "ADLGlobalDefine.h"
#import <YYText.h>

@implementation ADLOrderDetailHeader

+ (instancetype)headerViewWithStatus:(NSInteger)status lockerDict:(NSDictionary *)lockerDict goods:(BOOL)goods {
    return [[self alloc] initWithStatus:status lockerDict:lockerDict goods:goods];
}

- (instancetype)initWithStatus:(NSInteger)status lockerDict:(NSDictionary *)lockerDict goods:(BOOL)goods {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        redView.backgroundColor = APP_COLOR;
        [self addSubview:redView];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [redView addSubview:imgView];
        
        UILabel *statusLab = [[UILabel alloc] init];
        statusLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        statusLab.textColor = [UIColor whiteColor];
        [redView addSubview:statusLab];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 70, 290, 46)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.text = goods ? @"商品清单" : @"服务清单";
        titLab.textColor = COLOR_333333;
        [self addSubview:titLab];
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 115.5, SCREEN_WIDTH, 0.5)];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self addSubview:spView];
        
        if (status == 1) {
            imgView.frame = CGRectMake(12, 24, 28, 22);
            imgView.image = [UIImage imageNamed:@"order_dfh"];
            statusLab.frame = CGRectMake(50, 0, 100, 70);
            statusLab.text = @"待发货";
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116);
        } else {
            imgView.frame = CGRectMake(12, 24, 22, 22);
            statusLab.frame = CGRectMake(44, 0, 100, 70);
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116);
            if (status == 0) {
                imgView.image = [UIImage imageNamed:@"order_dzf"];
                statusLab.text = @"待支付";
            } else if (status == 2) {
                imgView.image = [UIImage imageNamed:@"order_qx"];
                statusLab.text = @"已取消";
            } else if (status == 3) {
                imgView.image = [UIImage imageNamed:@"order_dsh"];
                statusLab.text = @"待收货";
                [self addLogisticsBtn];
                
            } else if (status == 4) {
                imgView.image = [UIImage imageNamed:@"order_dfw"];
                statusLab.text = @"待服务";
                if (lockerDict.allKeys.count > 0) {
                    titLab.text = @"服务锁匠信息";
                    [self addLockerUnfinishedView:lockerDict goods:goods finish:NO];
                }
            } else {
                imgView.image = [UIImage imageNamed:@"order_wc"];
                statusLab.text = @"已完成";
                if (lockerDict.allKeys.count > 0) {
                    titLab.text = @"服务锁匠信息";
                    [self addLockerUnfinishedView:lockerDict goods:goods finish:YES];
                    [self addLogisticsBtn];
                }
            }
        }
    }
    return self;
}

#pragma mark ------ 添加查看物流按钮 ------
- (void)addLogisticsBtn {
    UIButton *logBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    logBtn1.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 66);
    [logBtn1 setTitle:@"›" forState:UIControlStateNormal];
    logBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [logBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn1.titleLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightThin];
    [logBtn1 addTarget:self action:@selector(clickLookLogisticsInformationBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logBtn1];
    
    UIButton *logBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    logBtn2.frame = CGRectMake(SCREEN_WIDTH-112, 0, 92, 70);
    logBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [logBtn2 setTitle:@"查看物流信息" forState:UIControlStateNormal];
    [logBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logBtn2 addTarget:self action:@selector(clickLookLogisticsInformationBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logBtn2];
}

#pragma mark ------ 添加服务师傅未完成视图 ------
- (void)addLockerUnfinishedView:(NSDictionary *)dict goods:(BOOL)goods finish:(BOOL)finish {
    UILabel *lockerLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 116+16, SCREEN_WIDTH-139, 20)];
    lockerLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    lockerLab.textColor = COLOR_333333;
    lockerLab.text = [NSString stringWithFormat:@"服务锁匠：%@",dict[@"name"]];
    [self addSubview:lockerLab];
    
    if (!finish) {
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH-12, 18)];
        timeLab.font = [UIFont systemFontOfSize:13];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = dict[@"time"];
        timeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:timeLab];
        
        UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-172, 40, 160, 18)];
        promLab.textAlignment = NSTextAlignmentRight;
        promLab.font = [UIFont systemFontOfSize:13];
        promLab.textColor = [UIColor whiteColor];
        promLab.text = @"请耐心等待...";
        [self addSubview:promLab];
        
        UIButton *pathBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        pathBtn1.frame = CGRectMake(SCREEN_WIDTH-20, 116, 20, 48);
        [pathBtn1 setTitle:@"›" forState:UIControlStateNormal];
        pathBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [pathBtn1 setTitleColor:APP_COLOR forState:UIControlStateNormal];
        pathBtn1.titleLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightThin];
        [pathBtn1 addTarget:self action:@selector(clickLookLockerPathBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pathBtn1];
        
        UIButton *pathBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        pathBtn2.frame = CGRectMake(SCREEN_WIDTH-112, 116, 92, 52);
        pathBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [pathBtn2 setTitle:@"查看锁匠行程" forState:UIControlStateNormal];
        [pathBtn2 setTitleColor:APP_COLOR forState:UIControlStateNormal];
        [pathBtn2 addTarget:self action:@selector(clickLookLockerPathBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pathBtn2];
        
    }
    
    YYLabel *contactLab = [[YYLabel alloc] initWithFrame:CGRectMake(12, 116+16+20+16, SCREEN_WIDTH-24, 20)];
    [self addSubview:contactLab];
    NSString *contactStr = [NSString stringWithFormat:@"联系方式：%@",dict[@"phone"]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:contactStr];
    attributeStr.yy_font = [UIFont systemFontOfSize:FONT_SIZE];
    attributeStr.yy_color = COLOR_333333;
    [attributeStr yy_setTextHighlightRange:NSMakeRange(5, contactStr.length-5) color:COLOR_0083FD backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dict[@"phone"]]];
            [[UIApplication sharedApplication] openURL:callUrl];
        });
    }];
    contactLab.attributedText = attributeStr;
    
    UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 116+16+20+16+20+16, SCREEN_WIDTH-24, 20)];
    stateLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    stateLab.textColor = COLOR_333333;
    NSInteger workStatus = [dict[@"workStatus"] integerValue];
    if (workStatus == 0) {
        stateLab.text = @"锁匠状态：工作中";
    } else {
        stateLab.text = @"锁匠状态：休息中";
    }
    [self addSubview:stateLab];
    
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 8)];
    fView.backgroundColor = COLOR_F2F2F2;
    [self addSubview:fView];
    
    UILabel *serLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 248, 100, 46)];
    serLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    serLab.textColor = COLOR_333333;
    serLab.text = goods ? @"商品清单" : @"服务清单";
    [self addSubview:serLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 293.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:lineView];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 294);
}

#pragma mark ------ 查看锁匠行程 ------
- (void)clickLookLockerPathBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLookLockerPathBtn)]) {
        [self.delegate didClickLookLockerPathBtn];
    }
}

#pragma mark ------ 查看物流信息 ------
- (void)clickLookLogisticsInformationBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLookLogisticsInformationBtn)]) {
        [self.delegate didClickLookLogisticsInformationBtn];
    }
}

@end
