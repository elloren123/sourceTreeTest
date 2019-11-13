//
//  ADLAddGatewayController.m
//  lockboss
//
//  Created by adel on 2019/10/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddGatewayController.h"

#import "ADLAddDevicePromptController.h"

@interface ADLAddGatewayController ()

@end

@implementation ADLAddGatewayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:ADLString(@"add_gateway")];
    
    CGFloat viewH = 60;
    
    //因为数据写死,只有一条,直接添加一个view
    UIView *gatewayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, viewH)];
    gatewayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:gatewayView];
    
    UIImageView *gatewayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 36, 36)];
    gatewayImgView.image = [UIImage imageNamed:@"lock_gateway"];
    [gatewayView addSubview:gatewayImgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(SCREEN_WIDTH-NAV_H-60,(viewH-13)/2,80,13);
    label.text = @"壁虎二代";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    [gatewayView addSubview:label];

    UIImageView *rigJiantouImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (viewH-15)/2, 8, 15)];
    rigJiantouImgView.image = [UIImage imageNamed:@"jiantou1"];
    rigJiantouImgView.contentMode = UIViewContentModeScaleAspectFit;
    [gatewayView addSubview:rigJiantouImgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH-0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [gatewayView addSubview:lineView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAddGateway)];
    [gatewayView addGestureRecognizer:tap];
    
}

-(void)goAddGateway{
    ADLAddDevicePromptController *addVC = [[ADLAddDevicePromptController alloc] init];
    addVC.titName = ADLString(@"add_gateway");
    [self.navigationController pushViewController:addVC animated:YES];
}



@end
