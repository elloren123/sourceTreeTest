//
//  ADLInvoiceApplyController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLInvoiceApplyController.h"

@interface ADLInvoiceApplyController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTop;
@end

@implementation ADLInvoiceApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"发票申请"];
    self.scrollTop.constant = NAVIGATION_H;
}

@end
