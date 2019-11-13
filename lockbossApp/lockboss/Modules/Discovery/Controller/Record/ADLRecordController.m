//
//  ADLRecordController.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLRecordController.h"
#import "ADLWebViewController.h"
#import "ADLMyRecordController.h"
#import "ADLRecordDataController.h"
#import "ADLGoodsDetailController.h"

@interface ADLRecordController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTop;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) NSInteger status;
@end

@implementation ADLRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"备案区"];
    [self addRightButtonWithTitle:@"我的备案" action:@selector(clickMyRecordBtn)];
    
    self.recordBtn.layer.cornerRadius = CORNER_RADIUS;
    self.scrollTop.constant = NAVIGATION_H;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBanner)];
    [self.imgView addGestureRecognizer:tap];
    
    [self getBannerData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(0, self.recordBtn.frame.origin.y+120);
}

#pragma mark ------ 我的备案 ------
- (void)clickMyRecordBtn {
    ADLMyRecordController *myVC = [[ADLMyRecordController alloc] init];
    [self.navigationController pushViewController:myVC animated:YES];
}

#pragma mark ------ 立即备案 ------
- (IBAction)clickRightNowRecordBtn:(UIButton *)sender {
    if (self.checkBtn.selected) {
        ADLRecordDataController *dataVC = [[ADLRecordDataController alloc] init];
        dataVC.type = ADLRecordTypeAdd;
        [self.navigationController pushViewController:dataVC animated:YES];
    } else {
        [ADLToast showMessage:@"请阅读并同意《备案协议》"];
    }
}

#pragma mark ------ 备案协议 ------
- (IBAction)clickRecordProtocolBtn:(UIButton *)sender {
    
}

#pragma mark ------ 选中协议 ------
- (IBAction)clickCheckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
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
    [params setValue:@(0) forKey:@"type"];
    [ADLNetWorkManager postWithPath:k_query_banner parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = [responseDict[@"data"] lastObject];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"bannerImgUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
            self.urlStr = [dict[@"linkUrl"] stringValue];
        }
    } failure:nil];
}

@end
