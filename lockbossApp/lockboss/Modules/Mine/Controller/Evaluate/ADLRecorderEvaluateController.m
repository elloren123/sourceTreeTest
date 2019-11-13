//
//  ADLRecorderEvaluateController.m
//  lockboss
//
//  Created by adel on 2019/6/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRecorderEvaluateController.h"
#import "ADLEvaluateStarView.h"

@interface ADLRecorderEvaluateController ()
@property (nonatomic, strong) ADLEvaluateStarView *starView;
@end

@implementation ADLRecorderEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"备案人服务评价"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 162)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    UILabel *otherLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 45)];
    otherLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    otherLab.textColor = COLOR_333333;
    otherLab.text = @"备案人服务评价";
    [bgView addSubview:otherLab];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112, 0, 100, 45)];
    promptLab.font = [UIFont systemFontOfSize:13];
    promptLab.textAlignment = NSTextAlignmentRight;
    promptLab.textColor = COLOR_999999;
    promptLab.text = @"满意请给5星哦";
    [bgView addSubview:promptLab];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    spLine.backgroundColor = SEPARATOR_COLOR;
    [bgView addSubview:spLine];
    
    ADLEvaluateStarView *starView = [[NSBundle mainBundle] loadNibNamed:@"ADLEvaluateStarView" owner:nil options:nil].lastObject;
    starView.frame = CGRectMake(0, 56, SCREEN_WIDTH, 106);
    starView.firstLab.text = @"服务效率";
    starView.secondLab.text = @"服务态度";
    starView.thirdLab.text = @"服务专业度";
    [bgView addSubview:starView];
    self.starView = starView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, 235+NAVIGATION_H, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

#pragma mark ------ 发表评价 ------
- (void)clickSubmitBtn {
    if (self.starView.firstStar == 0) {
        [ADLToast showMessage:@"请选择对服务效率的星评"];
        return;
    }
    if (self.starView.secondStar == 0) {
        [ADLToast showMessage:@"请选择对服务态度的星评"];
        return;
    }
    if (self.starView.thirdStar == 0) {
        [ADLToast showMessage:@"请选择对服务专业度的星评"];
        return;
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.serviceId forKey:@"serviceRecordId"];
    [params setValue:self.recorderId forKey:@"recordId"];
    [params setValue:@(self.starView.firstStar) forKey:@"serviceEfficiency"];
    [params setValue:@(self.starView.secondStar) forKey:@"serviceAttitude"];
    [params setValue:@(self.starView.thirdStar) forKey:@"serviceMajor"];
    [ADLNetWorkManager postWithPath:k_recorder_add_evaluate parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"评价成功"];
            if (self.submitEvaluate) {
                self.submitEvaluate();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
