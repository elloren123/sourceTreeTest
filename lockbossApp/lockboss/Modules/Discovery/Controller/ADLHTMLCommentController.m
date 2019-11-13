//
//  ADLHTMLCommentController.m
//  lockboss
//
//  Created by adel on 2019/5/5.
//  Copyright  2019年 adel. All rights reserved.
//

#import "ADLHTMLCommentController.h"
#import "ADLWebViewController.h"

#import <WebKit/WebKit.h>
#import "ADLImagePreView.h"
#import "ADLMorCommHead.h"
#import "ADLMorCommentCell.h"
#import "ADLCommentView.h"
#import "ADLBlankView.h"

@interface ADLHTMLCommentController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource,ADLMorCommentCellDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) ADLMorCommHead *comHeadView;
@property (nonatomic, strong) ADLCommentView *commentView;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSArray *imageArr;
@end

@implementation ADLHTMLCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self addNavigationView:@"早报详情"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-2, SCREEN_WIDTH, 2)];
    progressView.trackTintColor = [UIColor clearColor];
    progressView.progressTintColor = APP_COLOR;
    [self.navigationView addSubview:progressView];
    self.progressView = progressView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getCommentData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.pageSize = 10;
    self.rowHArr = [[NSMutableArray alloc] init];
    
    [self getPageData];
}

#pragma mark ------ 获取图片 ------
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *jsGetImages =
    @"function getImages() {\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for (var i = 0; i < objs.length; i++) {\
    imgScr = imgScr + objs[i].src + '+';\
    objs[i].onclick = function() {\
    document.location = this.src;\
    };\
    };\
    return imgScr;\
    };";
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *imageStr = [result stringValue];
        if (imageStr.length > 1) {
            imageStr = [imageStr substringToIndex:imageStr.length-1];
            self.imageArr = [imageStr componentsSeparatedByString:@"+"];
        }
    }];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        CGFloat webViewH = [result floatValue];
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewH+94);
        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewH);
        self.comHeadView.frame = CGRectMake(0, webViewH, SCREEN_WIDTH, 94);
        self.tableView.tableHeaderView = self.headerView;
        
        if (self.dataArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        [self.tableView reloadData];
    }];
    [ADLToast hide];
}

#pragma mark ------ 跳转链接 ------
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([self.imageArr containsObject:urlStr]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSInteger index = [self.imageArr indexOfObject:urlStr];
        [ADLImagePreView showWithImageViews:nil urlArray:self.imageArr currentIndex:index];
    } else {
        if ([urlStr hasPrefix:@"https://itunes.apple.com/app"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        } else if ([urlStr hasPrefix:@"http"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
            webVC.urlString = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if ([urlStr hasPrefix:@"//"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
            webVC.urlString = [NSString stringWithFormat:@"https:%@",urlStr];
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
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

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMorCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MorCommentCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMorCommentCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dict[@"userImgUrl"]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.nickLab.text = dict[@"userName"];
    cell.commentLab.text = dict[@"evaluateContent"];
    cell.likeLab.text = [NSString stringWithFormat:@"%d",[dict[@"praiseNum"] intValue]];
    cell.likeBtn.selected = [dict[@"isPraise"] boolValue];
    return cell;
}

#pragma mark ------ 点赞 ------
- (void)clickLikeBtn:(UIButton *)sender {
    if ([ADLUserModel sharedModel].login) {
        if (sender.selected) {
            [ADLToast showMessage:@"您已经点赞过了"];
        } else {
            sender.enabled = NO;
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:self.contentId forKey:@"id"];
            [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
            
            [ADLNetWorkManager postWithPath:k_morning_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                sender.enabled = YES;
                if ([responseDict[@"code"] integerValue] == 10000) {
                    sender.selected = YES;
                    self.comHeadView.likeLab.text = [NSString stringWithFormat:@"%d",[self.comHeadView.likeLab.text intValue]+1];
                }
            } failure:^(NSError *error) {
                sender.enabled = YES;
            }];
        }
    } else {
        __weak typeof(self)weakSelf = self;
        [self pushLoginViewControllerHideTabbar:NO success:^{
            [weakSelf getPageData];
        }];
    }
}

#pragma mark ------ 写留言 ------
- (void)clickWriteBtn {
    if ([ADLUserModel sharedModel].login) {
        [self.commentView beginEditing];
    } else {
        __weak typeof(self)weakSelf = self;
        [self pushLoginViewControllerHideTabbar:NO success:^{
            [weakSelf getPageData];
        }];
    }
}

#pragma mark ------ 点击头像 ------
- (void)didClickIconImageView:(UIImageView *)imageView {
    ADLMorCommentCell *cell = (ADLMorCommentCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.dataArr[indexPath.row][@"userImgUrl"] stringValue].length > 2) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[self.dataArr[indexPath.row][@"userImgUrl"]] currentIndex:0];
    }
}

#pragma mark ------ 评论点赞 ------
- (void)didClickLikeButton:(UIButton *)sender {
    if ([ADLUserModel sharedModel].login) {
        if (sender.selected) {
            [ADLToast showMessage:@"您已经点赞过了"];
        } else {
            sender.enabled = NO;
            ADLMorCommentCell *cell = (ADLMorCommentCell *)sender.superview.superview;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableDictionary *dict = self.dataArr[indexPath.row];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:dict[@"id"] forKey:@"evaluateId"];
            [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
            [ADLNetWorkManager postWithPath:k_morning_comment_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                sender.enabled = YES;
                if ([responseDict[@"code"] integerValue] == 10000) {
                    [dict setValue:@(1) forKey:@"isPraise"];
                    cell.likeLab.text = [NSString stringWithFormat:@"%d",[dict[@"praiseNum"] intValue]+1];
                    cell.likeBtn.selected = YES;
                }
            } failure:^(NSError *error) {
                sender.enabled = YES;
            }];
        }
    } else {
        __weak typeof(self)weakSelf = self;
        [self pushLoginViewControllerHideTabbar:NO success:^{
            [weakSelf getPageData];
        }];
    }
}

#pragma mark ------ 获取早报详情 ------
- (void)getPageData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.contentId forKey:@"id"];
    if ([ADLUserModel sharedModel].login) {
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    }
    [ADLNetWorkManager postWithPath:k_morning_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.comHeadView.readLab.text = [NSString stringWithFormat:@"%@ 阅读",responseDict[@"data"][@"readNum"]];
            self.comHeadView.likeBtn.selected = [responseDict[@"data"][@"isPraise"] boolValue];
            self.comHeadView.likeLab.text = [NSString stringWithFormat:@"%d",[responseDict[@"data"][@"praiseNum"] intValue]];
            
            NSArray *commentArr = responseDict[@"data"][@"evaluateInfo"][@"rows"];
            if (commentArr.count > 0) {
                [self.dataArr addObjectsFromArray:commentArr];
                for (NSMutableDictionary *dict in commentArr) {
                    CGFloat comH = [ADLUtils calculateString:dict[@"evaluateContent"] rectSize:CGSizeMake(SCREEN_WIDTH-78, MAXFLOAT) fontSize:14].height+51;
                    [self.rowHArr addObject:@(comH)];
                }
            }
            self.offset = self.dataArr.count;
            
            NSString *htmlStr = responseDict[@"data"][@"content"];
            htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<h1" withString:@"<h2"];
            htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</h1>" withString:@"</h2>"];
            NSScanner *scanner = [NSScanner scannerWithString:htmlStr];
            NSString *text = nil;
            while ([scanner isAtEnd] == NO) {
                [scanner scanUpToString:@"<a" intoString:nil];
                [scanner scanUpToString:@"</a>" intoString:&text];
                if ([text containsString:@"href=\"\""]) {
                    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@</a>",text] withString:@""];
                }
            }
            [self.webView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:nil];
}

#pragma mark ------ 获取评论数据 ------
- (void)getCommentData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.contentId forKey:@"morningPaperId"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [ADLNetWorkManager postWithPath:k_morning_comment parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
                [self.rowHArr removeAllObjects];
            }
            
            NSArray *commentArr = responseDict[@"data"][@"rows"];
            if (commentArr.count > 0) {
                [self.dataArr addObjectsFromArray:commentArr];
                for (NSMutableDictionary *dict in commentArr) {
                    CGFloat comH = [ADLUtils calculateString:dict[@"evaluateContent"] rectSize:CGSizeMake(SCREEN_WIDTH-78, MAXFLOAT) fontSize:14].height+51;
                    [self.rowHArr addObject:@(comH)];
                }
            }
            if (commentArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ 初始化HeaderView ------
- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    
    WKWebView *webView = [ADLUtils webViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10) scale:NO];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.navigationDelegate = self;
    webView.scrollView.scrollEnabled = NO;
    [headerView addSubview:webView];
    self.webView = webView;
    
    ADLMorCommHead *comHeadView = [[NSBundle mainBundle] loadNibNamed:@"ADLMorCommHead" owner:nil options:nil].lastObject;
    [comHeadView.writeBtn addTarget:self action:@selector(clickWriteBtn) forControlEvents:UIControlEventTouchUpInside];
    [comHeadView.likeBtn addTarget:self action:@selector(clickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:comHeadView];
    self.comHeadView = comHeadView;
}

#pragma mark ------ 评论框 ------
- (ADLCommentView *)commentView {
    if (_commentView == nil) {
        _commentView = [ADLCommentView commentViewWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        [self.view addSubview:_commentView];
        __weak typeof(self)weakSelf = self;
        _commentView.clickSendBtn = ^(UIButton * _Nonnull sender, NSString * _Nonnull content) {
            if ([ADLUtils hasEmoji:content]) {
                [ADLToast showMessage:@"请不要输入表情和特殊符号"];
            } else {
                [ADLToast showLoadingMessage:ADLString(@"loading")];
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
                [params setValue:weakSelf.contentId forKey:@"morningPaperId"];
                [params setValue:content forKey:@"evaluateContent"];
                
                [ADLNetWorkManager postWithPath:k_morning_add_comment parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        [ADLToast showMessage:@"评论成功"];
                        weakSelf.offset = 0;
                        [weakSelf getCommentData];
                    }
                } failure:nil];
            }
        };
    }
    return _commentView;
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260) imageName:@"blank_reply" prompt:@"暂无留言" backgroundColor:nil];
        _blankView.topMargin = 52;
    }
    return _blankView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
