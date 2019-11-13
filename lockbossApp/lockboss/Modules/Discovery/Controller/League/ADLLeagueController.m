//
//  ADLLeagueController.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLeagueController.h"
#import "ADLApplyLeagueController.h"

#import "ADLCoverCityView.h"
#import "ADLTalkCityView.h"
#import "ADLPagerView.h"

#import <MAMapKit/MAMapKit.h>

@interface ADLLeagueController ()<MAMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *talkArr;
@property (nonatomic, strong) ADLPagerView *pagerView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UIButton *myBtn;
@end

@implementation ADLLeagueController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-20, SCREEN_WIDTH, SCREEN_HEIGHT/2-NAVIGATION_H+40)];
    mapView.showsUserLocation = NO;
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.delegate = self;
    mapView.zoomLevel = 4.1;
    mapView.logoCenter = CGPointMake(100, 10);
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    for (UIGestureRecognizer *ges in mapView.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            [ges requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        }
    }
    
    self.talkArr = [[NSMutableArray alloc] init];
    [self addNavigationView:@"招商加盟"];
    self.myBtn = [self addRightButtonWithTitle:@"我的申请" action:@selector(clickMyApplyBtn)];
    self.myBtn.hidden = YES;
    
    ADLPagerView *pagerView = [ADLPagerView pagerViewWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2) views:@[[ADLCoverCityView new],[ADLTalkCityView new]]];
    [pagerView addTitles:@[@"已覆盖的城市",@"洽谈中的城市"] titleSize:CGSizeMake(SCREEN_WIDTH, VIEW_HEIGHT) statusH:0 fontSize:FONT_SIZE];
    [pagerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.view addSubview:pagerView];
    self.pagerView = pagerView;
    
    UILabel *coverLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112, SCREEN_HEIGHT/2-23-16, 105, 15)];
    coverLab.text = @"蓝旗：已有备案人";
    coverLab.font = [UIFont systemFontOfSize:11];
    coverLab.textColor = COLOR_333333;
    [self.view addSubview:coverLab];
    
    UILabel *talkLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112, SCREEN_HEIGHT/2-21, 105, 15)];
    talkLab.text = @"红旗：备案人洽谈中";
    talkLab.font = [UIFont systemFontOfSize:11];
    talkLab.textColor = COLOR_333333;
    [self.view addSubview:talkLab];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    applyBtn.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [applyBtn setTitle:@"申请备案人" forState:UIControlStateNormal];
    applyBtn.backgroundColor = APP_COLOR;
    [applyBtn addTarget:self action:@selector(clickApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    applyBtn.hidden = YES;
    self.applyBtn = applyBtn;
    
    [self getCityCoordinate];
    [self getLeagueApplyData];
}

#pragma mark ------ MAMapViewDelegate ------
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        }
        if ([annotation.title isEqualToString:@"talk"]) {
            annotationView.image = [UIImage imageNamed:@"map_talk"];
        } else {
            annotationView.image = [UIImage imageNamed:@"map_cover"];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark ------ 我的申请 ------
- (void)clickMyApplyBtn {
    ADLApplyLeagueController *leagueVC = [[ADLApplyLeagueController alloc] init];
    leagueVC.apply = YES;
    [self.navigationController pushViewController:leagueVC animated:YES];
}

#pragma mark ------ 申请备案人 ------
- (void)clickApplyBtn {
    ADLApplyLeagueController *leagueVC = [[ADLApplyLeagueController alloc] init];
    leagueVC.applyAction = ^{
        self.myBtn.hidden = NO;
        self.applyBtn.hidden = YES;
        [self.pagerView updatePagerViewFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        ADLCoverCityView *coverView = self.pagerView.viewsArr.firstObject;
        coverView.tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
        coverView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-VIEW_HEIGHT);
        ADLTalkCityView *talkView = self.pagerView.viewsArr.lastObject;
        talkView.tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
        talkView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-VIEW_HEIGHT);
    };
    leagueVC.apply = NO;
    [self.navigationController pushViewController:leagueVC animated:YES];
}

#pragma mark ------ 获取城市坐标 ------
- (void)getCityCoordinate {
    [ADLNetWorkManager postWithPath:k_league_coordinate parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *coverArr = responseDict[@"data"][@"normal"];
            NSArray *talkArr = responseDict[@"data"][@"audit"];
            if (coverArr.count > 0) {
                for (NSString *coordinateStr in coverArr) {
                    NSArray *spArr = [coordinateStr componentsSeparatedByString:@","];
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                    annotation.coordinate = CLLocationCoordinate2DMake([spArr.lastObject doubleValue], [spArr.firstObject doubleValue]);
                    annotation.title = @"cover";
                    [self.dataArr addObject:annotation];
                }
            }
            if (talkArr.count > 0) {
                for (NSString *coordinateStr in talkArr) {
                    NSArray *spArr = [coordinateStr componentsSeparatedByString:@","];
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                    annotation.coordinate = CLLocationCoordinate2DMake([spArr.lastObject doubleValue], [spArr.firstObject doubleValue]);
                    annotation.title = @"talk";
                    [self.talkArr addObject:annotation];
                }
            }
            [self.mapView addAnnotations:self.dataArr];
            [self.mapView addAnnotations:self.talkArr];
        }
    } failure:nil];
}

#pragma mark ------ 获取备案人申请信息 ------
- (void)getLeagueApplyData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_record_my_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"]) {
                self.myBtn.hidden = NO;
                if ([responseDict[@"data"][@"status"] integerValue] == 3) {
                    [self updateView];
                }
            } else {
                [self updateView];
            }
        }
    } failure:nil];
}

- (void)updateView {
    self.applyBtn.hidden = NO;
    [self.pagerView updatePagerViewFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2-BOTTOM_H-VIEW_HEIGHT)];
    ADLCoverCityView *coverView = self.pagerView.viewsArr.firstObject;
    coverView.tableView.contentInset = UIEdgeInsetsZero;
    coverView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-BOTTOM_H-VIEW_HEIGHT*2);
    ADLTalkCityView *talkView = self.pagerView.viewsArr.lastObject;
    talkView.tableView.contentInset = UIEdgeInsetsZero;
    talkView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-BOTTOM_H-VIEW_HEIGHT*2);
}

@end
