//
//  ADLSettleApplyController.m
//  lockboss
//
//  Created by Han on 2019/6/7.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSettleApplyController.h"
#import "ADLKeyboardMonitor.h"
#import "ADLMerchantPayView.h"
#import "ADLSettleDataView.h"
#import "ADLSheetView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface ADLSettleApplyController ()<ADLSettleDataViewDelegate,ADLMerchantPayViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) ADLSettleDataView *settleView;
@property (nonatomic, strong) ADLMerchantPayView *payView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *infImgView;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) NSString *settleId;
@property (nonatomic, assign) double securityMoney;
@property (nonatomic, assign) double platformMoney;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, assign) BOOL getMoney;

@end

@implementation ADLSettleApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.apply) {
        [self addNavigationView:@"我的申请"];
        [self getSettleApplyData];
    } else {
        [self addNavigationView:@"入驻申请"];
        [self addHeadViewWithProgress:1 resubmit:NO];
        [self addSettleViewWithEnable:YES resubmit:NO dict:nil];
    }
}

#pragma mark ------ 添加头部视图 ------
- (void)addHeadViewWithProgress:(NSInteger)progress resubmit:(BOOL)resubmit {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 75)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 20, SCREEN_WIDTH-24, 8)];
    bgView.backgroundColor = SEPARATOR_COLOR;
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds = YES;
    [headView addSubview:bgView];
    
    UIView *progressView = [[UIView alloc] init];
    progressView.backgroundColor = APP_COLOR;
    [bgView addSubview:progressView];
    
    CGFloat labGap = SCREEN_WIDTH/3-100;
    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 60, 18)];
    dataLab.textAlignment = NSTextAlignmentCenter;
    dataLab.font = [UIFont systemFontOfSize:13];
    dataLab.textColor = COLOR_333333;
    dataLab.text = @"提交资料";
    if (resubmit) dataLab.text = @"重新提交";
    [headView addSubview:dataLab];
    
    UIImageView *dataImgView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 16, 16, 16)];
    dataImgView.image = [UIImage imageNamed:@"apply_round_selected"];
    [headView addSubview:dataImgView];
    
    UILabel *reviewLab = [[UILabel alloc] initWithFrame:CGRectMake(80+labGap, 45, 60, 18)];
    reviewLab.textAlignment = NSTextAlignmentCenter;
    reviewLab.font = [UIFont systemFontOfSize:13];
    reviewLab.textColor = COLOR_333333;
    reviewLab.text = @"等待审核";
    [headView addSubview:reviewLab];
    
    UIImageView *reviewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(102+labGap, 16, 16, 16)];
    [headView addSubview:reviewImgView];
    
    UILabel *paymentLab = [[UILabel alloc] initWithFrame:CGRectMake(140+labGap*2, 45, 30, 18)];
    paymentLab.textAlignment = NSTextAlignmentCenter;
    paymentLab.font = [UIFont systemFontOfSize:13];
    paymentLab.textColor = COLOR_333333;
    paymentLab.text = @"缴费";
    [headView addSubview:paymentLab];
    
    UIImageView *paymentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(147+labGap*2, 16, 16, 16)];
    [headView addSubview:paymentImgView];
    
    UILabel *infLab = [[UILabel alloc] initWithFrame:CGRectMake(170+labGap*3, 45, 110, 18)];
    infLab.textAlignment = NSTextAlignmentCenter;
    infLab.font = [UIFont systemFontOfSize:13];
    infLab.textColor = COLOR_333333;
    infLab.text = @"获取商家后台信息";
    [headView addSubview:infLab];
    
    UIImageView *infImgView = [[UIImageView alloc] initWithFrame:CGRectMake(217+labGap*3, 16, 16, 16)];
    [headView addSubview:infImgView];
    
    if (progress == 1) {
        reviewImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        paymentImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        infImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        progressView.frame = CGRectMake(0, 0, labGap/2+68, 8);
    } else if (progress == 2) {
        reviewImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        paymentImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        infImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        progressView.frame = CGRectMake(0, 0, (29+labGap)/2+labGap+106, 8);
    } else if (progress == 3) {
        reviewImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        paymentImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        infImgView.image = [UIImage imageNamed:@"apply_round_normal"];
        progressView.frame = CGRectMake(0, 0, (54+labGap)/2+labGap*2+151, 8);
        self.progressView = progressView;
        self.infImgView = infImgView;
    } else {
        reviewImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        paymentImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        infImgView.image = [UIImage imageNamed:@"apply_round_selected"];
        progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH-24, 8);
    }
}

#pragma mark ------ 添加资料视图 ------
- (void)addSettleViewWithEnable:(BOOL)enable resubmit:(BOOL)resubmit dict:(NSDictionary *)dict {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-83)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, 1926);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    ADLSettleDataView *settleView = [[NSBundle mainBundle] loadNibNamed:@"ADLSettleDataView" owner:nil options:nil].lastObject;
    settleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1926);
    [scrollView addSubview:settleView];
    self.settleView = settleView;
    settleView.delegate = self;
    
    if (resubmit) {
        [settleView.submitBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    }
    
    if (dict) {
        [settleView updateInputViewWithDictionary:dict];
    }
    
    if (enable) {
        [[ADLKeyboardMonitor monitor] setEnable:YES];
    } else {
        [settleView setInputViewUneditable];
    }
    
    if (!resubmit && dict) {
        settleView.settleId = self.settleId;
        settleView.modifyPhoneBtn.hidden = NO;
        settleView.modifyEmailBtn.hidden = NO;
    }
}

#pragma mark ------ 添加入驻成功、账号禁用视图 ------
- (void)addSettleStatusView:(NSInteger)status {
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 90, 80, 80)];
    [successView addSubview:imageView];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 190, SCREEN_WIDTH-34, 30)];
    promptLab.font = [UIFont boldSystemFontOfSize:16];
    promptLab.textAlignment = NSTextAlignmentCenter;
    promptLab.textColor = COLOR_333333;
    [successView addSubview:promptLab];
    
    if (status == 0) {
        imageView.image = [UIImage imageNamed:@"review_success"];
        promptLab.text = @"申请成功";
    } else {
        successView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        imageView.image = [UIImage imageNamed:@"review_fail"];
        promptLab.text = @"您申请的商家入驻已被禁用";
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(12, 260, SCREEN_WIDTH-24, 45);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:confirmBtn];
}

- (void)clickConfirmBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 添加支付视图 ------
- (void)addPayView {
    self.period = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResult:) name:PAY_RESULT_STATUS object:nil];
    ADLMerchantPayView *payView = [[NSBundle mainBundle] loadNibNamed:@"ADLMerchantPayView" owner:nil options:nil].lastObject;
    payView.frame = CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-83);
    payView.delegate = self;
    [self.view addSubview:payView];
    self.payView = payView;
}

#pragma mark ------ 合约期限改变 ------
- (void)contractPeriodDidChanged:(NSInteger)period {
    self.period = period;
    [self calculMoney];
}

#pragma mark ------ 确认支付 ------
- (void)didClickPayBtn:(UIButton *)sender {
    if (self.period == 0) {
        [ADLToast showMessage:@"请输入使用期限"];
        return;
    }
    
    if (self.getMoney) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.settleId forKey:@"merchantId"];
        [params setValue:@(self.period) forKey:@"month"];
        NSString *type = @"2";
        if (self.payView.alipayBtn.selected) {
            type = @"1";
        }
        [params setValue:type forKey:@"paymentId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_settle_pay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                if (responseDict[@"data"][@"orderInfo"]) {
                    if ([type isEqualToString:@"1"]) {
                        [self alipayWithString:responseDict[@"data"][@"orderInfo"]];
                    } else {
                        NSString *orderStr = responseDict[@"data"][@"orderInfo"];
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[orderStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                        [self wechatPayWithDict:dict];
                    }
                } else {
                    [self addPaySuccessView];
                }
                [ADLToast hide];
            }
        } failure:nil];
    } else {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [self getSettleMoney];
    }
}

#pragma mark ------ 计算金额 ------
- (void)calculMoney {
    double totalMoney = self.securityMoney+self.period*self.platformMoney;
    self.payView.platformMoneyLab.text = [NSString stringWithFormat:@"%.2f 元",self.period*self.platformMoney];
    self.payView.totalMoneyLab.text = [NSString stringWithFormat:@"%.2f 元",totalMoney];
    [self.payView.payBtn setTitle:[NSString stringWithFormat:@"确认支付%.2f元",totalMoney] forState:UIControlStateNormal];
}

#pragma mark ------ 微信支付 ------
- (void)wechatPayWithDict:(NSDictionary *)dict {
    if ([WXApi isWXAppInstalled]) {
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [dict objectForKey:@"partnerid"];
        request.prepayId = [dict objectForKey:@"prepayid"];
        request.package = [dict objectForKey:@"package"];
        request.nonceStr = [dict objectForKey:@"noncestr"];
        request.timeStamp = [[dict objectForKey:@"timestamp"] unsignedIntValue];
        request.sign = [dict objectForKey:@"sign"];
        [WXApi sendReq:request completion:nil];
        
    } else {
        NSURL *wechatUrl = [NSURL URLWithString:k_wechat_download_string];
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"你还未安装微信客户端，是否前去下载？" confirmTitle:@"下载" confirmAction:^{
            [[UIApplication sharedApplication] openURL:wechatUrl];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 支付宝支付 ------
- (void)alipayWithString:(NSString *)orderStr {
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"alipay2018052560266007" callback:^(NSDictionary *resultDic) {
        //未安装支付宝网页支付完成回调此方法
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSString *messageStr = @"支付失败";
        if ([resultCodeStr isEqualToString:@"9000"]) messageStr = @"支付成功";
        else if ([resultCodeStr isEqualToString:@"5000"]) messageStr = @"重复请求";
        else if ([resultCodeStr isEqualToString:@"6001"]) messageStr = @"支付已取消";
        else if ([resultCodeStr isEqualToString:@"8000"]) messageStr = @"订单处理中，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6002"]) messageStr = @"网络连接出错，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6004"]) messageStr = @"支付结果未知，请稍后查看订单状态";
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![messageStr isEqualToString:@"支付成功"]) {
                [ADLToast showMessage:messageStr];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_STATUS object:messageStr userInfo:nil];
        });
    }];
}

#pragma mark ------ 处理支付结果 ------
- (void)dealwithPayResult:(NSNotification *)notification {
    NSString *result = notification.object;
    if ([result containsString:@"成功"]) {
        [self addPaySuccessView];
    }
}

#pragma mark ------ 支付成功视图 ------
- (void)addPaySuccessView {
    self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH-24, 8);
    self.infImgView.image = [UIImage imageNamed:@"apply_round_selected"];
    [self.payView removeFromSuperview];
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"您的商家后台信息稍后会发送到您\n绑定的手机号，注意查看~"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7;
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeStr.length)];
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, SCREEN_WIDTH-60, 50)];
    promptLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    promptLab.textColor = COLOR_333333;
    promptLab.numberOfLines = 2;
    promptLab.attributedText = attributeStr;
    promptLab.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:promptLab];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(12, 220, SCREEN_WIDTH-24, 45);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:confirmBtn];
}

#pragma mark ------ 开始编辑 ------
- (void)inputViewDidBeginEditing:(UIView *)inputView {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:inputView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            if (weakSelf.settleView.updateOffset) {
                CGFloat maxOffset = weakSelf.scrollView.contentSize.height-weakSelf.scrollView.frame.size.height;
                if (offsetY > maxOffset && maxOffset > 0) {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, maxOffset) animated:YES];
                } else {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
                }
            }
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

#pragma mark ------ 点击图片 ------
- (void)didClikImageViewWithIndex:(NSInteger)index {
    self.imageIndex = index;
    ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:nil];
    [sheetView addActionWithTitle:ADLString(@"take_photo") handler:^{
        ADLCameraStatus status = [ADLUtils getCameraStatus];
        if (status == ADLCameraStatusDenied) {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
                [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else if (status == ADLCameraStatusAllow) {
            UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
            pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerVc.delegate = self;
            [self presentViewController:pickerVc animated:YES completion:nil];
        } else {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        }
    }];
    [sheetView addActionWithTitle:ADLString(@"select_photo") handler:^{
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.navigationBar.tintColor = [UIColor blackColor];
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    [sheetView show];
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    switch (self.imageIndex) {
        case 0:
            self.settleView.licenseImageUrl = nil;
            self.settleView.licenseImage = image;
            self.settleView.licenseImgView.image = image;
            self.settleView.licenseImgBtn.hidden = NO;
            break;
        case 1:
            self.settleView.idImage1Url = nil;
            self.settleView.idImage1 = image;
            self.settleView.idImgView1.image = image;
            self.settleView.idImgBtn1.hidden = NO;
            self.settleView.idImgView2.hidden = NO;
            break;
        case 2:
            self.settleView.idImage2Url = nil;
            self.settleView.idImage2 = image;
            self.settleView.idImgView2.image = image;
            self.settleView.idImgBtn2.hidden = NO;
            break;
        case 3:
            self.settleView.bankImageUrl = nil;
            self.settleView.bankImage = image;
            self.settleView.bankImgView.image = image;
            self.settleView.bankImgBtn.hidden = NO;
            break;
    }
}

#pragma mark ------ 提交 ------
- (void)didClickSubmitBtn:(NSMutableDictionary *)params {
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    if (self.settleView.licenseImage != nil) {
        NSDictionary *dict1 = @{@"type":@"licenseImgUrl",@"image":self.settleView.licenseImage};
        [imageArr addObject:dict1];
    }
    if (self.settleView.idImage1 != nil) {
        NSDictionary *dict2 = @{@"type":@"documentBefore",@"image":self.settleView.idImage1};
        [imageArr addObject:dict2];
    }
    if (self.settleView.idImage2 != nil) {
        NSDictionary *dict3 = @{@"type":@"documentBack",@"image":self.settleView.idImage2};
        [imageArr addObject:dict3];
    }
    if (self.settleView.bankImage != nil) {
        NSDictionary *dict4 = @{@"type":@"bankLicence",@"image":self.settleView.bankImage};
        [imageArr addObject:dict4];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        for (int i = 0; i < imageArr.count; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%d/%lu)",i+1,imageArr.count]];
            });
            NSDictionary *dict = imageArr[i];
            NSData *data = [ADLUtils compressImageQuality:dict[@"image"] maxLength:IMAGE_MAX_LENGTH];
            [ADLNetWorkManager postImagePath:k_upload_image parameters:nil imageDataArr:@[data] imageName:@"img" autoToast:YES progress:nil success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    dispatch_semaphore_signal(sema);
                    NSArray *imgArr = responseDict[@"data"];
                    [params setValue:imgArr.firstObject[@"imgUrl"] forKey:dict[@"type"]];
                } else {
                    return;
                }
                
            } failure:^(NSError *error) {
                return;
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        [self addMerchantSettleWithDict:params];
    });
}

#pragma mark ------ 添加商家入驻 ------
- (void)addMerchantSettleWithDict:(NSDictionary *)params {
    [ADLNetWorkManager postWithPath:k_settle_add_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ADLToast showMessage:@"提交入驻申请成功"];
                if (self.submitAction) {
                    self.submitAction();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }
    } failure:nil];
}

#pragma mark ------ 获取申请信息 ------
- (void)getSettleApplyData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_settle_my_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"]) {
                NSInteger status = [responseDict[@"data"][@"status"] integerValue];
                if (status == 0) {
                    [self addHeadViewWithProgress:4 resubmit:NO];
                    [self addSettleStatusView:0];
                    
                } else if (status == 1) {
                    self.settleId = responseDict[@"data"][@"id"];
                    self.securityMoney = [responseDict[@"data"][@"waitPayMoney"] doubleValue];
                    [self addHeadViewWithProgress:3 resubmit:NO];
                    [self addPayView];
                    self.getMoney = NO;
                    [self getSettleMoney];
                    
                } else if (status == 2) {
                    self.settleId = responseDict[@"data"][@"id"];
                    [self addHeadViewWithProgress:2 resubmit:NO];
                    [self addSettleViewWithEnable:NO resubmit:NO dict:responseDict[@"data"]];
                    [self addRightButtonWithTitle:@"撤销申请" action:@selector(clickRevocationBtn:)];
                    
                } else if (status == 3) {
                    [self addSettleStatusView:3];
                    
                } else if (status == 5) {
                    [self addHeadViewWithProgress:1 resubmit:YES];
                    [self addSettleViewWithEnable:YES resubmit:YES dict:responseDict[@"data"]];
                    
                } else {
                    
                }
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取费用 ------
- (void)getSettleMoney {
    [ADLNetWorkManager postWithPath:k_settle_tariff parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            self.getMoney = YES;
            NSArray *resArr = responseDict[@"data"];
            self.securityMoney = [resArr.firstObject[@"bond"] doubleValue];
            self.payView.depositLab.text = [NSString stringWithFormat:@"%.2f 元",self.securityMoney];
            self.platformMoney = [resArr.firstObject[@"money"] doubleValue];
            [self calculMoney];
        }
    } failure:nil];
}

#pragma mark ------ 撤销申请 ------
- (void)clickRevocationBtn:(UIButton *)sender {
    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要撤销申请吗？" confirmTitle:nil confirmAction:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.settleId forKey:@"id"];
        [ADLNetWorkManager postWithPath:k_settle_revocation_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"撤销成功"];
                if (self.submitAction) {
                    self.submitAction();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
