//
//  ADLWebViewController.m
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLWebViewController.h"
#import <WebKit/WebKit.h>

@interface ADLWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titLab;
@end

@implementation ADLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [navigationView addSubview:backBtn];
    self.backBtn = backBtn;
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(NAV_H, STATUS_HEIGHT, SCREEN_WIDTH-NAV_H-60, NAV_H)];
    titLab.font = [UIFont boldSystemFontOfSize:17];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = COLOR_333333;
    [navigationView addSubview:titLab];
    self.titLab = titLab;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH-50, STATUS_HEIGHT, 50, NAV_H);
    [closeBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:closeBtn];
    closeBtn.hidden = YES;
    self.closeBtn = closeBtn;
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-0.3, SCREEN_WIDTH, 0.3)];
    spView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [navigationView addSubview:spView];
    
    WKWebView *webView = [ADLUtils webViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) scale:YES];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-2, SCREEN_WIDTH, 2)];
    progressView.trackTintColor = [UIColor clearColor];
    progressView.progressTintColor = APP_COLOR;
    [navigationView addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------ 关闭 ------
- (void)clickCloseBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ WKNavigationDelegate ------
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([urlStr hasPrefix:@"https://itunes.apple.com/app"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark ------ KVO监听 ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (progress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:progress animated:YES];
        }
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        self.closeBtn.hidden = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    } else {
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        if (title != nil) self.titLab.text = title;
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
