//
//  ADLShopGuideController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLShopGuideController.h"

@interface ADLShopGuideController()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@end

@implementation ADLShopGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"购物指南"];
    self.topH.constant = NAVIGATION_H+12;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
