//
//  ADLTopicReportController.m
//  lockboss
//
//  Created by Han on 2019/6/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLTopicReportController.h"
#import "ADLKeyboardMonitor.h"
#import "ADLTextView.h"

@interface ADLTopicReportController ()<ADLTextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *reportContent;
@property (nonatomic, strong) ADLTextView *textView;
@end

@implementation ADLTopicReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"举报"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollView)];
    [scrollView addGestureRecognizer:tap];
    
    UILabel *selLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH-24, 22)];
    selLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    selLab.textColor = COLOR_333333;
    [scrollView addSubview:selLab];
    
    switch (self.reportType) {
        case 1:
            selLab.text = @"请选择举报该群组原因";
            break;
        case 2:
            selLab.text = @"请选择举报该话题原因";
            break;
        case 3:
            selLab.text = @"请选择举报该评论原因";
            break;
        case 4:
            selLab.text = @"请选择举报该回复原因";
            break;
        default:
            selLab.text = @"请选择举报该用户原因";
            break;
    }
    
    NSArray *titleArr = @[@"  广告",@"  政治敏感",@"  包含不适宜公开讨论的内容",@"  涉嫌黄色等违反法规的内容",@"  人身辱骂",@"  其他"];
    NSArray *widArr = @[@"66",@"100",@"210",@"210",@"100",@"66"];
    for (int i = 0; i < 6; i++) {
        UIButton *reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 35+30*i, [widArr[i] floatValue], 30)];
        [reportBtn setImage:[UIImage imageNamed:@"box_normal"] forState:UIControlStateNormal];
        [reportBtn setImage:[UIImage imageNamed:@"box_selected"] forState:UIControlStateSelected];
        reportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [reportBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [reportBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [reportBtn addTarget:self action:@selector(clickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
        reportBtn.tag = i+1;
        [scrollView addSubview:reportBtn];
        [self.dataArr addObject:reportBtn];
    }
    
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 230, SCREEN_WIDTH-24, 22)];
    desLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    desLab.textColor = COLOR_333333;
    desLab.text = @"举报说明";
    [scrollView addSubview:desLab];
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 263, SCREEN_WIDTH-24, 180) limitLength:200];
    textView.delegate = self;
    textView.bgColor = SEPARATOR_COLOR;
    textView.placeholder = @"请输入举报说明（选填）";
    textView.layer.cornerRadius = 5;
    [scrollView addSubview:textView];
    self.textView = textView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, 500, SCREEN_WIDTH-24, 45);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:ADLString(@"submit") forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 589);
    
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

#pragma mark ------ 取消键盘监听 ------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

#pragma mark ------ 开始输入 ------
- (void)textViewDidBeginEdit:(UIView *)textView {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textView];
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

#pragma mark ------ 输入内容改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.reportContent = text;
}

#pragma mark ------ 选择举报原因 ------
- (void)clickReportBtn:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    } else {
        [self.dataArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        sender.selected = YES;
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    NSInteger type = 0;
    for (UIButton *btn in self.dataArr) {
        if (btn.selected) {
            type = btn.tag;
            break;
        }
    }
    if (type == 0) {
        [ADLToast showMessage:@"请选择举报原因"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *reason = [self.reportContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    reason = [reason stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (reason.length > 0) {
        [params setValue:self.reportContent forKey:@"reportContent"];
    }
    [params setValue:self.reportId forKey:@"beReportId"];
    [params setValue:@(self.reportType) forKey:@"reportType"];
    
    if (type == 4) {
        [params setValue:@(5) forKey:@"reportReason"];
    } else if (type == 5) {
        [params setValue:@(4) forKey:@"reportReason"];
    } else {
        [params setValue:@(type) forKey:@"reportReason"];
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_topic_report parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"举报成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 退出键盘 ------
- (void)clickScrollView {
    if (self.textView.editing) {
        [self.view endEditing:YES];
    }
}

@end
