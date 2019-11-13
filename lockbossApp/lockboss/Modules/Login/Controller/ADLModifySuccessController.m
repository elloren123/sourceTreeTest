//
//  ADLModifySuccessController.m
//  lockboss
//
//  Created by adel on 2019/3/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLModifySuccessController.h"
#import "ADLAccountSecController.h"
#import "ADLLoginController.h"

@interface ADLModifySuccessController ()

@end

@implementation ADLModifySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView:self.titleName];
    
    CGFloat imgS = 70;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imgS)/2, NAVIGATION_H+50, imgS, imgS)];
    imageView.image= [UIImage imageNamed:@"login_success"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 66+imgS+NAVIGATION_H, SCREEN_WIDTH-60, 40)];
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_333333;
    label.text = self.promptStr;
    label.numberOfLines = 2;
    [self.view addSubview:label];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actionBtn.frame = CGRectMake(29, NAVIGATION_H+imgS+160, SCREEN_WIDTH-58, VIEW_HEIGHT);
    actionBtn.backgroundColor = APP_COLOR;
    actionBtn.layer.cornerRadius = CORNER_RADIUS;
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [actionBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionBtn];
}

- (void)clickActionBtn {
    BOOL modify = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ADLAccountSecController class]]) {
            modify = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    if (modify == NO) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ADLLoginController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

@end
