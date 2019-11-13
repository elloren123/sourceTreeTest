//
//  ADLSchemeDetailController.m
//  lockboss
//
//  Created by adel on 2019/5/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSchemeDetailController.h"
#import "ADLRecorderDetailController.h"
#import "ADLImageListView.h"
#import <YYText.h>

@interface ADLSchemeDetailController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *filerView;
@end

@implementation ADLSchemeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"方案详情"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSString *filerStr = @"尊敬的客户，您好！鉴于您对我们的产品感兴趣，由于智能门锁相对比较专业，建议您联系我们的备案人进行沟通或者上门做专业的指导服务。备案人是指具有一定资质，且通过平台审核的区域代理商。 联系备案人>>";
    UIView *filerView = [[UIView alloc] init];
    filerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    [self.view addSubview:filerView];
    self.filerView = filerView;
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14);
    [closeBtn addTarget:self action:@selector(clickCloseServiceView) forControlEvents:UIControlEventTouchUpInside];
    [filerView addSubview:closeBtn];
    
    YYLabel *filerLab = [[YYLabel alloc] init];
    [filerView addSubview:filerLab];
    
    __weak typeof(self)weakSelf = self;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:filerStr];
    attributeStr.yy_lineSpacing = 7;
    attributeStr.yy_font = [UIFont systemFontOfSize:13];
    attributeStr.yy_color = [UIColor whiteColor];
    [attributeStr yy_setTextHighlightRange:NSMakeRange(filerStr.length-7, 7) color:APP_COLOR backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf clickContactFiler];
    }];
    filerLab.numberOfLines = 0;
    filerLab.attributedText = attributeStr;
    
    CGFloat filerH = [ADLUtils calculateAttributeString:attributeStr rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT)].height;
    filerView.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-50-filerH, SCREEN_WIDTH, 50+filerH);
    filerLab.frame = CGRectMake(12, 40, SCREEN_WIDTH-24, filerH);
    
    [self loadData];
}

#pragma mark ------ 关闭备案人视图 ------
- (void)clickCloseServiceView {
    [UIView animateWithDuration:0.3 animations:^{
        self.filerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.filerView removeFromSuperview];
    }];
}

#pragma mark ------ 联系备案人 ------
- (void)clickContactFiler {
    [self.navigationController pushViewController:[ADLRecorderDetailController new] animated:YES];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [ADLNetWorkManager postWithPath:k_goods_detail_image parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *imgArr = [responseDict[@"data"][@"imgAddress"] componentsSeparatedByString:@","];
            if (imgArr.count > 0) {
                NSMutableArray *urlArr = [[NSMutableArray alloc] init];
                for (NSString *url in imgArr) {
                    if ([url hasPrefix:@"http"]) {
                        [urlArr addObject:url];
                    }
                }
                if (urlArr.count > 0) {
                    ADLImageListView *listView = [ADLImageListView listViewWithContentInserts:UIEdgeInsetsMake(0, 0, 0, 0)];
                    [self.scrollView addSubview:listView];
                    __weak typeof(self)weakSelf = self;
                    listView.imageViewHeightChanged = ^(CGFloat totalHeight) {
                        weakSelf.scrollView.contentSize = CGSizeMake(0, totalHeight);
                    };
                    listView.urlArr = urlArr;
                }
            }
        }
    } failure:nil];
}

@end
