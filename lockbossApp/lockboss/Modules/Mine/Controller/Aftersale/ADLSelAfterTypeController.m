//
//  ADLSelAfterTypeController.m
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelAfterTypeController.h"
#import "ADLSubmitAfterController.h"

@interface ADLSelAfterTypeController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exchangeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repairH;

@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ADLSelAfterTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"选择售后类型"];
    self.top.constant = NAVIGATION_H+8;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    self.nameLab.text = self.dataDict[@"goodsName"];
    NSString *descStr = [NSString stringWithFormat:@"单价：¥%.2f    购买数量：%@",[self.dataDict[@"price"] doubleValue],self.dataDict[@"goodsNum"]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:descStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(0, 3)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:[descStr rangeOfString:@"购买数量："]];
    self.descLab.attributedText = attributeStr;
    self.maxCount = [self.dataDict[@"goodsNum"] integerValue];
    if (self.maxCount == 1) {
        [self.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    }
    
    if (self.startRange == 2) {
        self.returnH.constant = 0;
    }
    if (self.startRange == 3) {
        self.returnH.constant = 0;
        self.exchangeH.constant = 0;
    }
}

#pragma mark ------ 减少 ------
- (IBAction)clickReduceBtn:(UIButton *)sender {
    int count = [self.numLab.text intValue]-1;
    if (count > 0) {
        self.numLab.text = [NSString stringWithFormat:@"%d",count];
        if (count == 1) {
            [self.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [self.reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
    }
}

#pragma mark ------ 增加 ------
- (IBAction)clickAddBtn:(UIButton *)sender {
    int count = [self.numLab.text intValue]+1;
    if (count < self.maxCount+1) {
        self.numLab.text = [NSString stringWithFormat:@"%d",count];
        if (count == self.maxCount) {
            [self.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [self.addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
    }
}

//售后类型{0=退货,1=换货,2=维修}
#pragma mark ------ 退货 ------
- (IBAction)clickReturnGoodsBtn:(UIButton *)sender {
    [self pushControllerWithType:0];
}

#pragma mark ------ 换货 ------
- (IBAction)clickExchangeGoodsBtn:(UIButton *)sender {
    [self pushControllerWithType:1];
}

#pragma mark ------ 维修 ------
- (IBAction)clickRepairGoodsBtn:(UIButton *)sender {
    [self pushControllerWithType:2];
}

#pragma mark ------ 跳转 ------
- (void)pushControllerWithType:(NSInteger)type {
    [self.dataDict setValue:@(type) forKey:@"aftersaleType"];
    [self.dataDict setValue:self.numLab.text forKey:@"aftersaleCount"];
    ADLSubmitAfterController *submitVC = [[ADLSubmitAfterController alloc] init];
    submitVC.dataDict = self.dataDict;
    submitVC.orderVC = self.orderVC;
    [self.navigationController pushViewController:submitVC animated:YES];
}

- (void)dealloc {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
