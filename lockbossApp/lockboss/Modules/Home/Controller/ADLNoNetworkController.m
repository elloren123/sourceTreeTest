//
//  ADLNoNetworkController.m
//  lockboss
//
//  Created by adel on 2019/3/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNoNetworkController.h"

@interface ADLNoNetworkController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@end

@implementation ADLNoNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = NAVIGATION_H+20;
    [self addNavigationView:@"未能连接到互联网"];
}

@end
