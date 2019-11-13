//
//  ADLSettleController.m
//  lockboss
//
//  Created by adel on 2019/6/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSettleController.h"
#import "ADLWebViewController.h"
#import "ADLSettleApplyController.h"
#import "ADLGoodsDetailController.h"

@interface ADLSettleController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UIButton *settleBtn;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) NSInteger status;
@end

@implementation ADLSettleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"商家入驻"];
    self.applyBtn = [self addRightButtonWithTitle:@"我的申请" action:@selector(clickMyApplyBtn)];
    self.applyBtn.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.settleBtn.layer.cornerRadius= CORNER_RADIUS;
    self.top.constant = NAVIGATION_H;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBanner)];
    [self.imgView addGestureRecognizer:tap];
    
    [self getBannerData];
    [self getSettleMoney];
    [self getMyApplyStateWithLoading:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(0, self.settleBtn.frame.origin.y+95);
}

#pragma mark ------ 我的申请 ------
- (void)clickMyApplyBtn {
    ADLSettleApplyController *applyVC = [[ADLSettleApplyController alloc] init];
    applyVC.apply = YES;
    applyVC.submitAction = ^{
        [self getMyApplyStateWithLoading:NO];
    };
    [self.navigationController pushViewController:applyVC animated:YES];
}

#pragma mark ------ 马上入驻 ------
- (IBAction)clickBeginSettleBtn:(UIButton *)sender {
    if (self.status == 999 || self.status == 4 || self.status == 5) {
        ADLSettleApplyController *applyVC = [[ADLSettleApplyController alloc] init];
        applyVC.submitAction = ^{
            [self getMyApplyStateWithLoading:NO];
        };
        [self.navigationController pushViewController:applyVC animated:YES];
    } else if (self.status == 3) {
        [ADLAlertView showWithTitle:@"提示" message:@"您申请的商家入驻已被禁用,无法再次申请！" confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
    } else {
        [ADLAlertView showWithTitle:@"提示" message:@"您已经提交过申请了，如需重新提交请先撤回之前的申请，如已支付则不可撤回。" confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
    }
}

#pragma mark ------ 点击Banner ------
- (void)clickBanner {
    if (self.urlStr.length > 0) {
        if ([ADLUtils isPureInt:self.urlStr]) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.goodsId = self.urlStr;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            if ([self.urlStr hasPrefix:@"http"]) {
                ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
                webVC.urlString = self.urlStr;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

#pragma mark ------ 获取Banner ------
- (void)getBannerData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(1) forKey:@"type"];
    [ADLNetWorkManager postWithPath:k_query_banner parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = [responseDict[@"data"] lastObject];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"bannerImgUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
            self.urlStr = [dict[@"linkUrl"] stringValue];
        }
    } failure:nil];
}

#pragma mark ------ 获取费用 ------
- (void)getSettleMoney {
    [ADLNetWorkManager postWithPath:k_settle_tariff parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            self.feeLab.text = [NSString stringWithFormat:@"%@ 元",resArr.firstObject[@"money"]];
            self.moneyLab.text = [NSString stringWithFormat:@"%@",resArr.firstObject[@"bond"]];
            self.pointLab.text = [NSString stringWithFormat:@"%@%%",resArr.firstObject[@"points"]];
        }
    } failure:nil];
}

#pragma mark ------ 查询当前是否有申请 ------
- (void)getMyApplyStateWithLoading:(BOOL)loading {
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_settle_my_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (responseDict[@"data"]) {
                NSInteger status = [responseDict[@"data"][@"status"] integerValue];
                self.status = status;
                if (status == 4) {
                    self.applyBtn.hidden = YES;
                } else {
                    self.applyBtn.hidden = NO;
                }
            } else {
                self.applyBtn.hidden = YES;
                self.status = 999;
            }
        } else {
            self.settleBtn.enabled = NO;
            self.settleBtn.alpha = 0.5;
        }
    } failure:^(NSError *error) {
        self.settleBtn.enabled = NO;
        self.settleBtn.alpha = 0.5;
    }];
}

@end
