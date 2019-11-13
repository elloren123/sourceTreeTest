//
//  ADLNavigationController.m
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNavigationController.h"

@interface ADLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ADLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark ------ 开启侧滑手势 ------
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count < 2) return NO;
    return YES;
}

@end
