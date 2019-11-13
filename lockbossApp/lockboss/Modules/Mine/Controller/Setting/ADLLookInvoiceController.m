//
//  ADLLookInvoiceController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLookInvoiceController.h"
@interface ADLLookInvoiceController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@end

@implementation ADLLookInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topH.constant = NAVIGATION_H+20;
    [self addNavigationView:@"增票资质确认书"];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
