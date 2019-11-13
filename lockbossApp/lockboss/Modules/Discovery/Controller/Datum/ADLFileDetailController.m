//
//  ADLFileDetailController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLFileDetailController.h"
#import <AVKit/AVPlayerViewController.h>
#import <WebKit/WebKit.h>

@interface ADLFileDetailController ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ADLFileDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:self.fileName];
    [self getData];
}

#pragma mark ------ 获取数据 ------
- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.fileId forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_datum_file_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSString *urlStr = [[responseDict[@"data"] firstObject] stringValue];
            if ([urlStr containsString:@"mp4"] || [urlStr containsString:@"mov"] || [urlStr containsString:@"3gp"] || [urlStr containsString:@"m4v"]) {
                NSString *filename = [NSString stringWithFormat:@"%@.%@",[ADLUtils md5Encrypt:urlStr lower:YES],[urlStr componentsSeparatedByString:@"."].lastObject];
                NSString *filePath = [ADLUtils filePathWithName:filename permanent:NO];
                AVPlayer *player;
                if (filePath) {
                    player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
                } else {
                    player = [AVPlayer playerWithURL:[NSURL URLWithString:urlStr]];
                    self.downloadTask = [ADLNetWorkManager downloadFilePath:urlStr progress:nil success:nil failure:nil];
                }
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
                playerVC.view.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_WIDTH*0.56);
                playerVC.player = player;
                [self addChildViewController:playerVC];
                [self.view addSubview:playerVC.view];
            } else {
                UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-2, SCREEN_WIDTH, 2)];
                progressView.trackTintColor = [UIColor clearColor];
                progressView.progressTintColor = APP_COLOR;
                [self.navigationView addSubview:progressView];
                self.progressView = progressView;
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
                WKWebView *webView = [ADLUtils webViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) scale:YES];
                [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
                webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
                [webView loadRequest:request];
                [self.view addSubview:webView];
                self.webView = webView;
            }
        }
    } failure:nil];
}

#pragma mark ------ KVO监听 ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    if (progress == 1) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    } else {
        self.progressView.hidden = NO;
        [self.progressView setProgress:progress animated:YES];
    }
}

#pragma mark ------ 销毁 ------
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self.downloadTask cancel];
    }
}

@end
