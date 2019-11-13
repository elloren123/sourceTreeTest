//
//  ADLCleanViewController.m
//  lockboss
//
//  Created by bailun91 on 2019/10/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCleanViewController.h"
#import "ADLTextView.h"

@interface ADLCleanViewController () <ADLTextViewDelegate>

@property (nonatomic, strong) ADLTextView  *textview;

@end

@implementation ADLCleanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"清洁"];
    [self createContentView];
}
- (void)createContentView {
    // ------ **** ------
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+10, SCREEN_WIDTH/2, 40)];
    txtLab.font = [UIFont systemFontOfSize:15.5];
    txtLab.textAlignment = NSTextAlignmentLeft;
    txtLab.textColor = [UIColor darkGrayColor];
    txtLab.text = @"清洁留言";
    [self.view addSubview:txtLab];
    
    
    
    //输入框
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(15, NAVIGATION_H+50, SCREEN_WIDTH-30, 160) limitLength:0];
    textView.bgColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    textView.delegate = self;
    textView.layer.cornerRadius = 5.0;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
    self.textview = textView;
    
    
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT-100-BOTTOM_H, SCREEN_WIDTH-80, 44)];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.backgroundColor = COLOR_E0212A;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}
- (void)submitBtnAction {
    if (self.textview.text.length == 0) {
        [ADLToast showMessage:@"请留言"];
    } else {
        [self submitCleanRequest];
    }
}


#pragma mark ------ 输入改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.textview.text = text;
}

#pragma mark ------ 清洁留言 ------
- (void)submitCleanRequest {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId      forKey:@"deviceId"];
    [params setValue:self.deviceCode    forKey:@"deviceCode"];
    [params setValue:@(2)               forKey:@"opt"];
    [params setValue:self.textview.text forKey:@"des"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/clear.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"提交清洁请求返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            //界面返回
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
    }];
}

@end
