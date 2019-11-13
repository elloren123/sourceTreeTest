//
//  ADLAddDevicePromptController.m
//  lockboss
//
//  Created by Adel on 2019/9/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddDevicePromptController.h"
#import "ADLAddFamilyDeviceController.h"

@interface ADLAddDevicePromptController ()

@end

@implementation ADLAddDevicePromptController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:self.titName];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, NAVIGATION_H, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)*0.83)];
    if ([self.titName isEqualToString:ADLString(@"add_gateway")]) {
        imgView.image = [UIImage imageNamed:@"add_gateway"];
    } else {
        imgView.image = [UIImage imageNamed:@"add_lock"];
    }
    [self.view addSubview:imgView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(20, SCREEN_HEIGHT-BOTTOM_H-80, SCREEN_WIDTH-40, VIEW_HEIGHT);
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [nextBtn setTitle:ADLString(@"next_step") forState:UIControlStateNormal];
    nextBtn.backgroundColor = APP_COLOR;
    nextBtn.layer.cornerRadius = CORNER_RADIUS;
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)clickNextBtn {
    ADLAddFamilyDeviceController *addVC = [[ADLAddFamilyDeviceController alloc] init];
    addVC.titName = self.titName;
    [self.navigationController pushViewController:addVC animated:YES];
}

@end
