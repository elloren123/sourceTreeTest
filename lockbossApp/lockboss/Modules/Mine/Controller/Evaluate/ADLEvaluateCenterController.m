//
//  ADLEvaluateCenterController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEvaluateCenterController.h"
#import "ADLGoodsEvaluateController.h"
#import "ADLServiceEvaluateController.h"
#import "ADLRecorderEvaluateController.h"
#import "ADLRecorderDetailController.h"
#import "ADLGoodsEvaDetailController.h"
#import "ADLLockerDetailController.h"

#import "ADLPagerView.h"
#import "ADLEvaluateWaitView.h"
#import "ADLEvaluateDoneView.h"
#import "ADLEvaluateRecorderView.h"

@interface ADLEvaluateCenterController ()
@property (nonatomic, strong) ADLEvaluateWaitView *waitView;
@property (nonatomic, strong) ADLEvaluateDoneView *doneView;
@property (nonatomic, strong) ADLEvaluateRecorderView *recorderView;
@end

@implementation ADLEvaluateCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"评价中心"];
    CGFloat fonSzie = FONT_SIZE;
    if (SCREEN_WIDTH < 379) fonSzie = 14;
    if (SCREEN_WIDTH < 329) fonSzie = 13;
    ADLEvaluateWaitView *waitView = [[ADLEvaluateWaitView alloc] init];
    ADLEvaluateDoneView *doneView = [[ADLEvaluateDoneView alloc] init];
    ADLEvaluateRecorderView *recorderView = [[ADLEvaluateRecorderView alloc] init];
    self.waitView = waitView;
    self.doneView = doneView;
    self.recorderView = recorderView;
    
    __weak typeof(self)weakSelf = self;
    waitView.clickGoEvaluate = ^(NSDictionary *dict) {
        if (dict[@"goodsId"]) {
            ADLGoodsEvaluateController *goodsEvaVC = [[ADLGoodsEvaluateController alloc] init];
            goodsEvaVC.imgUrl = dict[@"goodsImg"];
            goodsEvaVC.orderId = dict[@"orderId"];
            goodsEvaVC.skuId = dict[@"skuId"];
            goodsEvaVC.goodsId = dict[@"goodsId"];
            goodsEvaVC.goodsName = dict[@"goodsName"];
            goodsEvaVC.evaluateFinish = ^{
                [weakSelf.waitView updateList];
                [weakSelf.doneView updateList];
            };
            [weakSelf.navigationController pushViewController:goodsEvaVC animated:YES];
        } else {
            ADLServiceEvaluateController *serEvaVC = [[ADLServiceEvaluateController alloc] init];
            serEvaVC.orderId = dict[@"serviceOrderId"];
            serEvaVC.personId = dict[@"serviceUserId"];
            serEvaVC.evaluateFinish = ^{
                [weakSelf.waitView updateList];
                [weakSelf.doneView updateList];
            };
            [weakSelf.navigationController pushViewController:serEvaVC animated:YES];
        }
    };
    
    doneView.clickLookEvaluate = ^(NSMutableDictionary *evaDict) {
        if (evaDict[@"goodsId"]) {
            NSMutableDictionary *evaluateDict = [[NSMutableDictionary alloc] init];
            [evaluateDict setValue:evaDict[@"evaluateId"] forKey:@"id"];
            [evaluateDict setValue:evaDict[@"addUser"] forKey:@"addUser"];
            [evaluateDict setValue:evaDict[@"headShot"] forKey:@"headShot"];
            [evaluateDict setValue:evaDict[@"description"] forKey:@"description"];
            [evaluateDict setValue:evaDict[@"evaluateInfo"] forKey:@"evaluateInfo"];
            [evaluateDict setValue:evaDict[@"goodsName"] forKey:@"skuName"];
            [evaluateDict setValue:evaDict[@"buyerUserid"] forKey:@"buyerUserId"];
            [evaluateDict setValue:evaDict[@"praiseNum"] forKey:@"praiseNum"];
            [evaluateDict setValue:evaDict[@"replyNum"] forKey:@"replyNum"];
            [evaluateDict setValue:evaDict[@"isPraise"] forKey:@"isPraise"];
            NSString *dateStr = [evaDict[@"addDatetime"] componentsSeparatedByString:@" "].firstObject;
            [evaluateDict setValue:dateStr forKey:@"addDatetime"];
            NSArray *imgArr = [evaDict[@"imgUrl"] componentsSeparatedByString:@","];
            if (imgArr.count > 0) {
                [evaluateDict setValue:imgArr forKey:@"imgArr"];
            }
            ADLGoodsEvaDetailController *lookVC = [[ADLGoodsEvaDetailController alloc] init];
            lookVC.evaluateDict = evaluateDict;
            lookVC.finishBlock = ^(NSMutableDictionary *dict) {
                [evaDict setValue:dict[@"isPraise"] forKey:@"isPraise"];
                [evaDict setValue:dict[@"praiseNum"] forKey:@"praiseNum"];
                [evaDict setValue:dict[@"replyNum"] forKey:@"replyNum"];
            };
            [self.navigationController pushViewController:lookVC animated:YES];
        } else {
            ADLLockerDetailController *lockerVC = [[ADLLockerDetailController alloc] init];
            lockerVC.hideSelBtn = YES;
            lockerVC.lockerId = evaDict[@"serviceUserId"];
            [self.navigationController pushViewController:lockerVC animated:YES];
        }
    };
    
    recorderView.clickEvaluateBtn = ^(NSMutableDictionary *dict) {
        ADLRecorderEvaluateController *recEvaVC = [[ADLRecorderEvaluateController alloc] init];
        recEvaVC.serviceId = dict[@"serviceRecordId"];
        recEvaVC.recorderId = dict[@"recordManId"];
        recEvaVC.submitEvaluate = ^{
            [dict setValue:@(1) forKey:@"isEvaluate"];
            [weakSelf.recorderView updateData];
        };
        [weakSelf.navigationController pushViewController:recEvaVC animated:YES];
    };
    
    recorderView.clickDetailBtn = ^(NSDictionary *dict) {
        ADLRecorderDetailController *detailVC = [[ADLRecorderDetailController alloc] init];
        detailVC.recorderId = dict[@"recordManId"];
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    ADLPagerView *pagerView = [ADLPagerView pagerViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) views:@[waitView,doneView,recorderView]];
    [pagerView addTitles:@[@"待评价",@"已评价",@"备案人评价"] titleSize:CGSizeMake(SCREEN_WIDTH, VIEW_HEIGHT) statusH:0 fontSize:fonSzie];
    [pagerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.view addSubview:pagerView];
}

@end
