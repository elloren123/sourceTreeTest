//
//  ADLFAQController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLFAQController.h"
#import "ADLSalePolicyController.h"
#import "ADLInvoiceApplyController.h"
#import "ADLShopGuideController.h"
#import "ADLContactUsController.h"

@interface ADLFAQController ()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@end
@implementation ADLFAQController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"常见问题"];
    self.topH.constant = NAVIGATION_H;
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFirstView)];
    [self.firstView addGestureRecognizer:firstTap];
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSecondView)];
    [self.secondView addGestureRecognizer:secondTap];
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickThirdView)];
    [self.thirdView addGestureRecognizer:thirdTap];
    UITapGestureRecognizer *fourthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFourthView)];
    [self.fourthView addGestureRecognizer:fourthTap];
}

#pragma mark ------ 售后政策 ------
- (void)clickFirstView {
    [self.navigationController pushViewController:[ADLSalePolicyController new] animated:YES];
}

#pragma mark ------ 发票申请 ------
- (void)clickSecondView {
    [self.navigationController pushViewController:[ADLInvoiceApplyController new] animated:YES];
}

#pragma mark ------ 购物指南 ------
- (void)clickThirdView {
    [self.navigationController pushViewController:[ADLShopGuideController new] animated:YES];
}

#pragma mark ------ 联系客服 ------
- (void)clickFourthView {
    [self.navigationController pushViewController:[ADLContactUsController new] animated:YES];
}

@end
