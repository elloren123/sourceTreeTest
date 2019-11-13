//
//  ADLShareView.m
//  lockboss
//
//  Created by Han on 2019/4/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLShareView.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"
#import "ADLApiDefine.h"
#import "ADLAlertView.h"
#import "ADLToast.h"

#import "WXApi.h"
#import <Photos/PHPhotoLibrary.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ADLShareView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *targetStr;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) ADLShareType shareType;
@end

@implementation ADLShareView

#pragma mark ------ 分享视图 ------
+ (instancetype)showWithTitle:(NSString *)title desc:(NSString *)desc imageData:(NSData *)imageData targetStr:(NSString *)targetStr shareType:(ADLShareType)shareType {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title desc:desc imageData:imageData targetStr:targetStr shareType:shareType];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc imageData:(NSData *)imageData targetStr:(NSString *)targetStr shareType:(ADLShareType)shareType {
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.desc = desc;
        self.shareType = shareType;
        self.imageData = imageData;
        self.targetStr = targetStr;
        [self initializationSubViews];
    }
    return self;
}

#pragma mark ------ 初始化视图 ------
- (void)initializationSubViews {
    CGFloat panelH = (BOTTOM_H+192);
    CGFloat labelW = SCREEN_WIDTH/4;
    
    //遮罩
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancle)];
    [coverView addGestureRecognizer:tap];
    
    //分享视图
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, panelH)];
    panelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:panelView];
    self.panelView = panelView;
    
    //分享标题
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 44)];
    titleLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE+1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = COLOR_333333;
    titleLab.text = @"分享到";
    [panelView addSubview:titleLab];
    
    //分割线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [panelView addSubview:line1];
    
    //分享途径
    NSArray *imageArr = @[@"share_wechat",@"share_moment",@"share_qq",@"share_zone"];
    NSArray *titleArr = @[@"微信",@"朋友圈",@"QQ",@"QQ空间"];
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(labelW/2-20+labelW*(i%4), 60, 40, 40)];
        imgView.image = [UIImage imageNamed:imageArr[i]];
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imgView addGestureRecognizer:tap];
        [panelView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i%4)*labelW, 108, labelW, 20)];
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_333333;
        label.text = titleArr[i];
        [panelView addSubview:label];
    }
    
    //分割线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 8)];
    line2.backgroundColor = COLOR_F2F2F2;
    [panelView addSubview:line2];
    
    //取消按钮
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 148, SCREEN_WIDTH, 44)];
    [cancleBtn setTitle:ADLString(@"cancle") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE+1];
    [cancleBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:cancleBtn];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake(0, SCREEN_HEIGHT-panelH, SCREEN_WIDTH, panelH);
    }];
}

#pragma mark ------ 点击图标 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    UIView *tapView = tap.view;
    if (self.shareType != ADLShareTypeText && self.imageData == nil) {
        [ADLToast showMessage:@"当前网络较慢，请稍后..."];
        return;
    }
    [self clickCancle];
    switch (tapView.tag) {
        case 0:
            [self shareToWeChatType:0];
            break;
        case 1:
            [self shareToWeChatType:1];
            break;
        case 2:
            [self shareToQQType:0];
            break;
        case 3:
            [self shareToQQType:1];
            break;
    }
}

#pragma mark ------ 分享到微信好友、朋友圈 ------
- (void)shareToWeChatType:(int)type {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
        if (self.shareType == ADLShareTypeText) {
            request.text = self.desc;
            request.bText = YES;
            
        } else if (self.shareType == ADLShareTypeImage) {
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = self.imageData;
            
            WXMediaMessage *imgMessage = [WXMediaMessage message];
            imgMessage.mediaObject = imageObject;
            request.message = imgMessage;
            request.bText = NO;
        } else {
            WXWebpageObject *webObject = [WXWebpageObject object];
            webObject.webpageUrl = self.targetStr;
            
            WXMediaMessage *webMessage = [WXMediaMessage message];
            webMessage.title = self.title;
            webMessage.description = self.desc;
            webMessage.thumbData = self.imageData;
            webMessage.mediaObject = webObject;
            request.message = webMessage;
            request.bText = NO;
        }
        request.scene = type;
        [WXApi sendReq:request completion:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success) {
                    [ADLToast showMessage:@"分享失败"];
                }
            });
        }];
    } else {
        NSURL *wechatUrl = [NSURL URLWithString:k_wechat_download_string];
        [self showAlertWithMessage:@"你还未安装微信客户端，是否前去下载？" downloadUrl:wechatUrl];
    }
}

#pragma mark ------ 分享到QQ、QQ空间 ------
- (void)shareToQQType:(int)type {
    BOOL result = NO;
    if ([QQApiInterface isQQInstalled] || [QQApiInterface isTIMInstalled]) {
        result = YES;
    }
    if (result) {
        SendMessageToQQReq *request;
        if (self.shareType == ADLShareTypeText) {
            if (type == 0) {
                QQApiTextObject *textObject = [QQApiTextObject objectWithText:self.desc];
                request = [SendMessageToQQReq reqWithContent:textObject];
            } else {
                QQApiImageArrayForQZoneObject *textQzoneObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[] title:self.desc extMap:nil];
                request = [SendMessageToQQReq reqWithContent:textQzoneObj];
            }
        } else if (self.shareType == ADLShareTypeImage) {
            if (type == 0) {
                QQApiImageObject *imgObject = [QQApiImageObject objectWithData:self.imageData previewImageData:self.imageData title:self.title description:self.desc];
                request = [SendMessageToQQReq reqWithContent:imgObject];
            } else {
                QQApiImageArrayForQZoneObject *imgQzoneObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[self.imageData] title:nil extMap:nil];
                request = [SendMessageToQQReq reqWithContent:imgQzoneObj];
            }
        } else {
            QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.targetStr] title:self.title description:self.desc previewImageData:self.imageData];
            request = [SendMessageToQQReq reqWithContent:newsObject];
        }
        
        if (type == 0) {
            [QQApiInterface sendReq:request];
        } else {
            [QQApiInterface SendReqToQZone:request];
        }
    } else {
        NSString *downloadStr = k_qq_download_string;
        if (SCREEN_WIDTH > 500) downloadStr = k_qqipad_download_string;
        [self showAlertWithMessage:@"你还未安装QQ客户端，是否前去下载？" downloadUrl:[NSURL URLWithString:downloadStr]];
    }
}

#pragma mark ------ 取消 ------
- (void)clickCancle {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ 下载弹窗 ------
- (void)showAlertWithMessage:(NSString *)message downloadUrl:(NSURL *)url {
    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:message confirmTitle:@"下载" confirmAction:^{
        [[UIApplication sharedApplication] openURL:url];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

@end
