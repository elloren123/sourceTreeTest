//
//  ADLInvoiceInfController.m
//  lockboss
//
//  Created by adel on 2019/5/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLInvoiceInfController.h"
#import "ADLKeyboardMonitor.h"
#import "ADLAddressPickerView.h"

@interface ADLInvoiceInfController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstH;
@property (weak, nonatomic) IBOutlet UIButton *generalBtn;
@property (weak, nonatomic) IBOutlet UIButton *taxBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondH;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UITextField *dwNameTF;
@property (weak, nonatomic) IBOutlet UITextField *dwNumTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdH;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *companyNumLab;
@property (weak, nonatomic) IBOutlet UILabel *companyAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *companyBankLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;

@property (weak, nonatomic) IBOutlet UITextField *sprNameTF;
@property (weak, nonatomic) IBOutlet UITextField *sprPhoneTF;
@property (weak, nonatomic) IBOutlet UILabel *sprAreaLab;
@property (weak, nonatomic) IBOutlet UITextField *sprAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *fpnrLab;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) NSArray *provinceArr;
@property (nonatomic, strong) NSString *invoiceStr;
@property (nonatomic, strong) NSString *invoiceId;
@end

@implementation ADLInvoiceInfController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOriginalData];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    CGFloat contentSizeH = 650;
    if (SCREEN_HEIGHT-NAVIGATION_H > 650) contentSizeH = SCREEN_HEIGHT-NAVIGATION_H+1;
    self.contentH.constant = contentSizeH;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    [self queryQualification];
}

#pragma mark ------ 普通发票 ------
- (IBAction)clickGeneralBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.firstH.constant = 93;
        self.thirdH.constant = 1;
        CGFloat contentSizeH = 650;
        if (self.personalBtn.selected) {
            self.secondH.constant = 90;
        } else {
            self.secondH.constant = 200;
            contentSizeH = 760;
        }
        [self setButtonColor:sender secondBtn:self.taxBtn contentSizeH:contentSizeH];
    }
}

#pragma mark ------ 增值税专用发票 ------
- (IBAction)clickTaxBtn:(UIButton *)sender {
    if (self.invoiceStr) {
        [ADLToast showMessage:self.invoiceStr];
    } else {
        if (!sender.selected) {
            self.firstH.constant = 126;
            self.secondH.constant = 1;
            self.thirdH.constant = 329;
            [self setButtonColor:sender secondBtn:self.generalBtn contentSizeH:921];
        }
    }
}

#pragma mark ------ 个人 ------
- (IBAction)clickPersonalBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.secondH.constant = 90;
        [self setButtonColor:sender secondBtn:self.companyBtn contentSizeH:650];
    }
}

#pragma mark ------ 单位 ------
- (IBAction)clickCompanyBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.secondH.constant = 200;
        [self setButtonColor:sender secondBtn:self.personalBtn contentSizeH:760];
    }
}

#pragma mark ------ 收票人地区 ------
- (IBAction)clickShouPiaoRenAddressBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    [ADLAddressPickerView showWithArray:self.provinceArr level:4 finish:^(NSString *address, NSString *addressId) {
        self.sprAreaLab.textColor = COLOR_333333;
        self.sprAreaLab.text = address;
    }];
}

#pragma mark ------ 商品明细 ------
- (IBAction)clickGoodsDetailBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.fpnrLab.text = @"发票内容将显示详细商品名称与价格信息";
        [self setButtonColor:sender secondBtn:self.categoryBtn contentSizeH:0];
    }
}

#pragma mark ------ 商品类别 ------
- (IBAction)clickGoodsCategoryBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.fpnrLab.text = @"发票内容将显示本单商品所属类别与价格信息";
        [self setButtonColor:sender secondBtn:self.detailBtn contentSizeH:0];
    }
}

#pragma mark ------ 确定 ------
- (IBAction)clickConfirmBtn:(UIButton *)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    NSMutableString *invoiceStr = [[NSMutableString alloc] init];
    if (self.generalBtn.selected) {
        [invoiceStr appendString:@"普通发票(纸质)"];
        [params setValue:@(0) forKey:@"type"];
        if (self.personalBtn.selected) {
            [params setValue:@(0) forKey:@"title"];
            [invoiceStr appendString:@",个人"];
        } else {
            [invoiceStr appendString:@",单位"];
            [params setValue:@(1) forKey:@"title"];
            NSString *dwNameStr = [self.dwNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (dwNameStr.length == 0) {
                [ADLToast showMessage:@"请填写单位名称"];
                return;
            }
            
            NSString *dwNumStr = [self.dwNumTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (dwNumStr.length == 0) {
                [ADLToast showMessage:@"请填写纳税人识别号"];
                return;
            }
            [params setValue:dwNameStr forKey:@"companyName"];
            [params setValue:dwNumStr forKey:@"taxpayerid"];
        }
    } else {
        [invoiceStr appendString:@"增值税专用发票(纸质),单位"];
        [params setValue:@(1) forKey:@"type"];
        [params setValue:self.companyNameLab.text forKey:@"companyName"];
        [params setValue:self.companyNumLab.text forKey:@"taxpayerid"];
        [params setValue:self.companyAddressLab.text forKey:@"address"];
        [params setValue:self.companyPhoneLab.text forKey:@"phone"];
        [params setValue:self.companyBankLab.text forKey:@"depositBank"];
        [params setValue:self.bankNumLab.text forKey:@"bankAccount"];
    }
    
    if (_sprNameTF.text.length == 0) {
        [ADLToast showMessage:@"请填写收票人姓名"];
        return;
    }
    if (_sprPhoneTF.text.length == 0) {
        [ADLToast showMessage:@"请填写收票人手机"];
        return;
    }
    
    [params setValue:_sprNameTF.text forKey:@"acceptInvoicePeople"];
    [params setValue:_sprPhoneTF.text forKey:@"acceptInvoicePhone"];
    
    if (![_sprAreaLab.text hasPrefix:@"请"]) {
        [params setValue:_sprAreaLab.text forKey:@"inTheArea"];
    }
    NSString *detailStr = [_sprAddressTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (detailStr.length > 0) {
        [params setValue:_sprAddressTF.text forKey:@"detailedAddress"];
    } else {
        [params setValue:@"" forKey:@"detailedAddress"];
    }
    
    if (self.detailBtn.selected) {
        [params setValue:@(0) forKey:@"content"];
        [invoiceStr appendString:@",商品明细"];
    } else {
        [params setValue:@(1) forKey:@"content"];
        [invoiceStr appendString:@",商品类别"];
    }
    
    NSString *path = k_add_invoice;
    if (self.invoiceId.length > 0) {
        path = k_modify_invoice;
        [params setValue:self.invoiceId forKey:@"id"];
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (self.finish) {
                if (self.invoiceId.length > 0) {
                    self.finish(self.invoiceId, invoiceStr);
                } else {
                    self.finish(responseDict[@"data"][@"id"], invoiceStr);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:nil];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textField];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.sprPhoneTF) {
        return [ADLUtils phoneTextField:textField replacementString:string];
    }
    return YES;
}

#pragma mark ------ 初始化 ------
- (void)setOriginalData {
    [self addNavigationView:@"发票信息"];
    self.topMargin.constant = NAVIGATION_H;
    self.confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [self setViewLayer:self.generalBtn color:APP_COLOR];
    [self setViewLayer:self.personalBtn color:APP_COLOR];
    [self setViewLayer:self.detailBtn color:APP_COLOR];
    [self setViewLayer:self.taxBtn color:COLOR_D3D3D3];
    [self setViewLayer:self.companyBtn color:COLOR_D3D3D3];
    [self setViewLayer:self.categoryBtn color:COLOR_D3D3D3];
}

#pragma mark ------ 设置边框 ------
- (void)setViewLayer:(UIView *)vi color:(UIColor *)color {
    vi.layer.cornerRadius = CORNER_RADIUS;
    vi.layer.borderColor = color.CGColor;
    vi.layer.borderWidth = 0.5;
}

#pragma mark ------ 切换按钮设置颜色,ContentSize ------
- (void)setButtonColor:(UIButton *)firstBtn secondBtn:(UIButton *)secondBtn contentSizeH:(CGFloat)contentSizeH {
    firstBtn.selected = YES;
    firstBtn.layer.borderColor = APP_COLOR.CGColor;
    [firstBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    secondBtn.selected = NO;
    secondBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
    [secondBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    if (contentSizeH > 0) {
        if (SCREEN_HEIGHT-NAVIGATION_H > contentSizeH) contentSizeH = SCREEN_HEIGHT-NAVIGATION_H+1;
        self.contentH.constant = contentSizeH;
    }
}

#pragma mark ------ 查询增票资质 ------
- (void)queryQualification {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_qualification parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSInteger status = [responseDict[@"data"][@"status"] integerValue];
                if (status == 0 || status == 2) {
                    self.invoiceStr = @"资质信息审核中，请审核通过后再试！";
                } else if (status == 3) {
                    self.invoiceStr = @"资质信息已驳回，请修改后再试！";
                } else {
                    self.companyNameLab.text = responseDict[@"data"][@"companyName"];
                    self.companyNumLab.text = responseDict[@"data"][@"taxpayerId"];
                    self.companyAddressLab.text = responseDict[@"data"][@"address"];
                    self.companyPhoneLab.text = responseDict[@"data"][@"phone"];
                    self.companyBankLab.text = responseDict[@"data"][@"depositBank"];
                    self.bankNumLab.text = responseDict[@"data"][@"bankAccount"];
                }
            } else {
                self.invoiceStr = @"请到“我的-设置-添加增票资质”中开通与修改增值信息";
            }
            [self queryInvoice];
        }
    } failure:nil];
}

#pragma mark ------ 查询用户发票 ------
- (void)queryInvoice {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_invoice parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self updateInvoiceData:resArr.lastObject];
            }
        }
    } failure:nil];
}

#pragma mark ------ 更新发票信息 ------
- (void)updateInvoiceData:(NSDictionary *)dict {
    self.invoiceId = dict[@"id"];
    if ([dict[@"type"] intValue] == 1 && self.invoiceStr == nil) {
        self.firstH.constant = 126;
        self.secondH.constant = 1;
        self.thirdH.constant = 329;
        [self setButtonColor:self.taxBtn secondBtn:self.generalBtn contentSizeH:921];
    } else {
        if ([dict[@"title"] intValue] == 1) {
            self.secondH.constant = 200;
            self.dwNumTF.text = [dict[@"taxpayerid"] stringValue];
            self.dwNameTF.text = [dict[@"companyName"] stringValue];
            [self setButtonColor:self.companyBtn secondBtn:self.personalBtn contentSizeH:760];
        }
    }
    if ([dict[@"content"] intValue] == 1) {
        self.fpnrLab.text = @"发票内容将显示本单商品所属类别与价格信息";
        [self setButtonColor:self.categoryBtn secondBtn:self.detailBtn contentSizeH:0];
    }
    self.sprNameTF.text = [dict[@"acceptInvoicePeople"] stringValue];
    self.sprPhoneTF.text = [dict[@"acceptInvoicePhone"] stringValue];
    if ([dict[@"inTheArea"] stringValue].length > 0) {
        self.sprAreaLab.text = dict[@"inTheArea"];
        self.sprAreaLab.textColor = COLOR_333333;
    }
    self.sprAddressTF.text = [dict[@"detailedAddress"] stringValue];
}

#pragma mark ------ 隐藏键盘 ------
- (void)hideKeyBoard {
    [self.scrollView endEditing:YES];
}

@end
