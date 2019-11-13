//
//  ADLAftersaleProView.m
//  lockboss
//
//  Created by adel on 2019/7/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAfterDetailHeader.h"
#import "ADLGlobalDefine.h"
#import "ADLAttachView.h"
#import "ADLToast.h"

@interface ADLAfterDetailHeader ()<UITextFieldDelegate>

@end

@implementation ADLAfterDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.expTF.delegate = self;
    self.submitBtn.layer.cornerRadius = 3;
    self.submitBtn.layer.borderWidth = 0.5;
    self.submitBtn.layer.borderColor = APP_COLOR.CGColor;
    
    self.expView1.layer.cornerRadius = 3;
    self.expView1.layer.borderWidth = 0.5;
    self.expView1.layer.borderColor = COLOR_D3D3D3.CGColor;
    
    self.expView2.layer.cornerRadius = 3;
    self.expView2.layer.borderWidth = 0.5;
    self.expView2.layer.borderColor = COLOR_D3D3D3.CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectExpCompanyLab)];
    [self.expLab addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *addressPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAddressLab:)];
    [self.addressLab addGestureRecognizer:addressPress];
    
    UILongPressGestureRecognizer *receiverPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReceiverLab:)];
    [self.receiverLab addGestureRecognizer:receiverPress];
    
    UILongPressGestureRecognizer *postPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPostLab:)];
    [self.postLab addGestureRecognizer:postPress];
    
    UILongPressGestureRecognizer *phonePress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPhoneLab:)];
    [self.phoneLab addGestureRecognizer:phonePress];
}

- (void)addProgressViewWithTitles:(NSArray *)titles progress:(NSInteger)progress {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 140, SCREEN_WIDTH-24, 6)];
    bgView.backgroundColor = SEPARATOR_COLOR;
    bgView.layer.cornerRadius = 3;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    NSInteger count = titles.count;
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/count*progress-12, 6)];
    progressView.backgroundColor = [UIColor colorWithRed:28/255.0 green:218/255.0 blue:46/255.0 alpha:1];
    [bgView addSubview:progressView];
    for (int i = 0; i < count; i++) {
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/count*i, 161, SCREEN_WIDTH/count, 15)];
        titLab.font = [UIFont systemFontOfSize:13];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.textColor = COLOR_333333;
        titLab.text = titles[i];
        [self addSubview:titLab];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 135, 16, 16)];
        imgView.center = CGPointMake(titLab.center.x, 143);
        if (progress > i) {
            imgView.image = [UIImage imageNamed:@"aftersale_complete"];
        } else {
            imgView.image = [UIImage imageNamed:@"aftersale_default"];
        }
        [self addSubview:imgView];
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------ 长按收货地址 ------
- (void)longPressAddressLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.addressLab.text;
        [ADLToast showMessage:@"复制成功"];
    }
}

#pragma mark ------ 长按收件人 ------
- (void)longPressReceiverLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.receiverLab.text substringFromIndex:4];
        [ADLToast showMessage:@"复制成功"];
    }
}

#pragma mark ------ 长按邮编 ------
- (void)longPressPostLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.postLab.text substringFromIndex:3];
        [ADLToast showMessage:@"复制成功"];
    }
}

#pragma mark ------ 长按收件人电话 ------
- (void)longPressPhoneLab:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.phoneLab.text substringFromIndex:3];
        [ADLToast showMessage:@"复制成功"];
    }
}

#pragma mark ------ 点击详情 ------
- (IBAction)clickLookProgressDetailBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickProgressDetailBtn)]) {
        [self.delegate didClickProgressDetailBtn];
    }
}

#pragma mark ------ 选择快递公司 ------
- (void)clickSelectExpCompanyLab {
    [self clickSelectExpCompany];
}

- (IBAction)clickSelectExpCompanyBtn:(UIButton *)sender {
    [self clickSelectExpCompany];
}

- (void)clickSelectExpCompany {
    NSInteger count = self.expArr.count;
    if (count > 0) {
        [self endEditing:YES];
        NSMutableArray *titArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.expArr) {
            [titArr addObject:dict[@"name"]];
        }
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect frame = [self.expView1.superview convertRect:self.expView1.frame toView:window];
        [UIView animateWithDuration:0.3 animations:^{
            self.expBtn.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        [ADLAttachView showWithFrame:CGRectMake(97, frame.origin.y+frame.size.height, SCREEN_WIDTH-109, count*44) titleArr:titArr finish:^(NSInteger index) {
            if (index != -1) {
                self.expDict = self.expArr[index];
                self.expLab.textColor = COLOR_333333;
                self.expLab.text = titArr[index];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.expBtn.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (IBAction)clickSubmitExpBtn:(UIButton *)sender {
    if ([self.expLab.text hasPrefix:@"请"]) {
        [ADLToast showMessage:@"请选择快递公司"];
        return;
    }
    NSString *numStr = self.expTF.text;
    numStr = [numStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (numStr.length == 0) {
        [ADLToast showMessage:@"请输入快递单号"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSubmitExpBtn)]) {
        [self.delegate didClickSubmitExpBtn];
    }
}

@end
