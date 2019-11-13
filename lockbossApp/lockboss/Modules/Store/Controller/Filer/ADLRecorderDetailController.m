//
//  ADLRecorderDetailController.m
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRecorderDetailController.h"
#import "ADLSelectCityController.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "ADLRecorderDetailView.h"
#import "ADLImagePreView.h"
#import "ADLBlankView.h"

@interface ADLRecorderDetailController ()<AMapLocationManagerDelegate,ADLRecorderDetailViewDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) ADLRecorderDetailView *detailView;
@property (nonatomic, strong) NSMutableDictionary *recorderDict;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, assign) BOOL denied;

@end

@implementation ADLRecorderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if (self.recorderId.length > 0) {
        [self addNavigationView:@"备案人详情"];
        [self getRecorderDetailData];
    } else {
        [self addNavigationView:@"备案人"];
        self.denied = YES;
        
        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cityBtn.frame = CGRectMake(SCREEN_WIDTH-80, STATUS_HEIGHT, 80, NAV_H);
        [cityBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cityBtn addTarget:self action:@selector(clickSelectCityBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:cityBtn];
        self.cityBtn = cityBtn;
        
        AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.locatingWithReGeocode = YES;
        self.locationManager = locationManager;
        
        //定位权限状态
        ADLLocationStatus locationStatus = [ADLUtils getLocationStatus];
        if (locationStatus == ADLLocationStatusDenied) {
            [cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
            [ADLAlertView showWithTitle:@"无法定位" message:@"你尚未开启定位权限，请手动选择城市!" confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        } else if (locationStatus == ADLLocationStatusAllow) {
            self.denied = NO;
            [cityBtn setTitle:@"定位中..." forState:UIControlStateNormal];
            [locationManager startUpdatingLocation];
        } else {
            [cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
            [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"定位服务不可用，请手动选择城市!" confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        }
        
        self.cityArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.dataArr) {
            NSArray *areaArr = dict[@"areaTemps"];
            if (areaArr.count > 0) {
                [self.cityArr addObjectsFromArray:areaArr];
            } else {
                [self.cityArr addObject:dict];
            }
        }
    }
}

#pragma mark ------ 定位权限改变 ------
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied && self.denied == NO) {
        [self.cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
        [ADLToast showMessage:@"定位失败，请手动选择城市!"];
    }
}

#pragma mark ------ 定位失败 ------
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    [ADLToast showMessage:@"定位失败，请手动选择城市!"];
    [self.cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
}

#pragma mark ------ 定位成功 ------
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    if (reGeocode.city) {
        [self.locationManager stopUpdatingLocation];
        BOOL result = NO;
        for (NSDictionary *dict in self.cityArr) {
            if ([dict[@"areaName"] isEqualToString:reGeocode.city]) {
                CGFloat cityBtnW = [ADLUtils calculateString:dict[@"areaName"] rectSize:CGSizeMake(SCREEN_WIDTH/2-53, NAV_H) fontSize:14].width+20;
                self.cityBtn.frame = CGRectMake(SCREEN_WIDTH-cityBtnW, STATUS_HEIGHT, cityBtnW, NAV_H);
                [self.cityBtn setTitle:dict[@"areaName"] forState:UIControlStateNormal];
                result = YES;
                [self getRecorderDataWithAreaId:[dict[@"areaId"] stringValue]];
                break;
            }
        }
        if (result == NO) {
            [self.cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
            [ADLToast showMessage:@"请选择城市"];
        }
    }
}

#pragma mark ------ 拨打电话 ------
- (void)didClickContactPhoneBtn {
    NSString *phone = self.recorderDict[@"companyPhone"];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    [[UIApplication sharedApplication] openURL:phoneUrl];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.recorderDict[@"id"] forKey:@"recordId"];
    [ADLNetWorkManager postWithPath:k_recorder_phone_call parameters:params autoToast:NO success:nil failure:nil];
}

#pragma mark ------ 公司简介 ------
- (void)didClickCompanyAbstractBtn {
    NSString *imgUrl = self.recorderDict[@"companyAbstract"];
    if (imgUrl) {
        [ADLImagePreView showWithImageViews:nil urlArray:@[imgUrl] currentIndex:0];
    }
}

#pragma mark ------ 选择城市 ------
- (void)clickSelectCityBtn {
    if ([self.cityBtn.titleLabel.text isEqualToString:@"定位中..."]) {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"是否要取消定位？" confirmTitle:nil confirmAction:^{
            if ([self.cityBtn.titleLabel.text isEqualToString:@"定位中..."]) {
                [self.locationManager stopUpdatingLocation];
                [self.cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
            }
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    } else {
        ADLSelectCityController *cityVC = [[ADLSelectCityController alloc] init];
        cityVC.selectedCity = ^(NSDictionary *cityDict) {
            CGFloat cityBtnW = [ADLUtils calculateString:cityDict[@"areaName"] rectSize:CGSizeMake(SCREEN_WIDTH/2-53, NAV_H) fontSize:14].width+20;
            self.cityBtn.frame = CGRectMake(SCREEN_WIDTH-cityBtnW, STATUS_HEIGHT, cityBtnW, NAV_H);
            [self.cityBtn setTitle:cityDict[@"areaName"] forState:UIControlStateNormal];
            [self getRecorderDataWithAreaId:[cityDict[@"areaId"] stringValue]];
        };
        [self.navigationController pushViewController:cityVC animated:YES];
    }
}

#pragma mark ------ 获取备案人数据 ------
- (void)getRecorderDataWithAreaId:(NSString *)areaId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:areaId forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_recorder_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count == 0) {
                if ([self.detailView isDescendantOfView:self.view]) {
                    [self.detailView removeFromSuperview];
                    [self.view addSubview:self.blankView];
                }
            } else {
                if (![self.detailView isDescendantOfView:self.view]) {
                    [self.blankView removeFromSuperview];
                    [self.view addSubview:self.detailView];
                }
                NSMutableDictionary *dict = resArr.firstObject;
                NSString *location = [ADLUtils queryAddressWithDataArr:self.dataArr areaId:[dict[@"area"] stringValue]].address;
                [dict setValue:location forKey:@"location"];
                [self.detailView updateContentWithDict:dict];
                self.recorderDict = dict;
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取备案人详情 ------
- (void)getRecorderDetailData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.recorderId forKey:@"recordManId"];
    [ADLNetWorkManager postWithPath:k_query_recorder_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.view addSubview:self.detailView];
            NSMutableDictionary *dict = responseDict[@"data"];
            NSString *location = [ADLUtils queryAddressWithDataArr:self.dataArr areaId:[dict[@"area"] stringValue]].address;
            [dict setValue:location forKey:@"location"];
            [self.detailView updateContentWithDict:dict];
            self.recorderDict = dict;
        }
    } failure:nil];
}

#pragma mark ------ detailView ------
- (ADLRecorderDetailView *)detailView {
    if (_detailView == nil) {
        _detailView = [[NSBundle mainBundle] loadNibNamed:@"ADLRecorderDetailView" owner:nil options:nil].lastObject;
        _detailView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        _detailView.delegate = self;
    }
    return _detailView;
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 300) imageName:nil prompt:@"该地区暂无备案人" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
