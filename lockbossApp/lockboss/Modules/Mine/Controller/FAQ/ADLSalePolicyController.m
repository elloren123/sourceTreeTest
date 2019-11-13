//
//  ADLSalePolicyController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSalePolicyController.h"

@interface ADLSalePolicyController ()
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@end

@implementation ADLSalePolicyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topH.constant = NAVIGATION_H;
    [self addNavigationView:@"售后政策"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.height.constant = self.lab7.frame.origin.y+self.lab7.frame.size.height+20;
}

@end
