//
//  ADLSelectCityController.m
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectCityController.h"
#import "ADLSearchCityResultView.h"
#import "ADLSearchAnimateView.h"
#import "ADLSingleTextCell.h"

#import <AMapLocationKit/AMapLocationKit.h>

@interface ADLSelectCityController ()<ADLSearchAnimateViewDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) ADLSearchCityResultView *resultView;
@property (nonatomic, strong) ADLSearchAnimateView *searchView;
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *cityDict;
@property (nonatomic, strong) UIButton *cityBtn;

@property (nonatomic,strong)NSMutableDictionary *dict;
@end

@implementation ADLSelectCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"选择城市"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ADLSearchAnimateView *searchView = [ADLSearchAnimateView searchAnimateViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 50) placeholder:@"搜索城市" verticalMargin:8 instant:YES];
    searchView.delegate = self;
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    UIButton *cityBtn = [[UIButton alloc] init];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cityBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    cityBtn.backgroundColor = COLOR_F2F2F2;
    cityBtn.layer.cornerRadius = CORNER_RADIUS;
    [cityBtn addTarget:self action:@selector(clickCityBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    self.cityBtn = cityBtn;
    
    self.cityArr = [[NSMutableArray alloc] init];
    self.indexArr = [[NSMutableArray alloc] init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dict in self.dataArr) {
        [self.indexArr addObject:dict[@"index"]];
        [self.cityArr addObjectsFromArray:dict[@"city"]];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+ROW_HEIGHT+50, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-ROW_HEIGHT-50)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionIndexColor = APP_COLOR;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.locatingWithReGeocode = YES;
    self.locationManager = locationManager;
    
    //定位权限状态
    CGFloat titW = 0;
    ADLLocationStatus locationStatus = [ADLUtils getLocationStatus];
    if (locationStatus == ADLLocationStatusAllow) {
        cityBtn.enabled = NO;
        titW = [ADLUtils calculateString:ADLString(@"positioning") rectSize:CGSizeMake(200, 20) fontSize:14].width+26;
        [cityBtn setTitle:ADLString(@"positioning") forState:UIControlStateNormal];
        [locationManager startUpdatingLocation];
    } else {
        titW = [ADLUtils calculateString:ADLString(@"location_failed_pp") rectSize:CGSizeMake(200, 20) fontSize:14].width+26;
        [cityBtn setTitle:ADLString(@"location_failed_pp") forState:UIControlStateNormal];
    }
    cityBtn.frame = CGRectMake(12, NAVIGATION_H+57, titW, ROW_HEIGHT-14);
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *secArr = self.dataArr[section][@"city"];
    return secArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    headerView.backgroundColor = COLOR_F2F2F2;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 24)];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = COLOR_333333;
    titleLab.text = self.indexArr[section];
    [headerView addSubview:titleLab];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.leftMargin = 12;
    }
    cell.titLab.text = self.dataArr[indexPath.section][@"city"][indexPath.row][@"areaName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCity) {
        self.selectedCity(self.dataArr[indexPath.section][@"city"][indexPath.row]);
    }
    

    NSString *oreillyAddress = self.dataArr[indexPath.section][@"city"][indexPath.row][@"areaName"]; ;
    [self addresCity:oreillyAddress];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 点击定位 ------
- (void)clickCityBtn {
    if ([self.cityBtn.titleLabel.text isEqualToString:ADLString(@"location_failed_pp")]) {
        ADLLocationStatus locationStatus = [ADLUtils getLocationStatus];
        if (locationStatus == ADLLocationStatusDenied) {
            [ADLAlertView showWithTitle:@"无法定位" message:@"你尚未开启定位权限，是否前去开启？" confirmTitle:nil confirmAction:^{
                [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else if (locationStatus == ADLLocationStatusAllow) {
            CGFloat titW = [ADLUtils calculateString:ADLString(@"positioning") rectSize:CGSizeMake(200, 20) fontSize:14].width+26;
            [self.cityBtn setTitle:ADLString(@"positioning") forState:UIControlStateNormal];
            CGRect frame = self.cityBtn.frame;
            frame.size.width = titW;
            self.cityBtn.frame = frame;
            self.cityBtn.enabled = NO;
            [self.locationManager startUpdatingLocation];
        } else {
            [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"定位服务不可用，请手动选择城市!" confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        }
    } else {
        if (self.selectedCity) {
            self.selectedCity(self.cityDict);
        }
        

        NSString *oreillyAddress =self.cityDict[@"areaName"];
         [self addresCity:oreillyAddress];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------ 定位失败 ------
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    CGFloat titW = [ADLUtils calculateString:ADLString(@"location_failed_pp") rectSize:CGSizeMake(200, 20) fontSize:14].width+26;
    [self.cityBtn setTitle:ADLString(@"location_failed_pp") forState:UIControlStateNormal];
    CGRect frame = self.cityBtn.frame;
    frame.size.width = titW;
    self.cityBtn.frame = frame;
    self.cityBtn.enabled = YES;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark ------ 定位成功 ------
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    if (reGeocode.city) {
        [self.locationManager stopUpdatingLocation];
        CGFloat titW = [ADLUtils calculateString:reGeocode.city rectSize:CGSizeMake(200, 20) fontSize:14].width+26;
        [self.cityBtn setTitle:reGeocode.city forState:UIControlStateNormal];
        CGRect frame = self.cityBtn.frame;
        frame.size.width = titW;
        self.cityBtn.frame = frame;
        self.cityBtn.enabled = YES;
        
        BOOL contain = NO;
        for (NSDictionary *dict in self.cityArr) {
            if ([dict[@"areaName"] isEqualToString:reGeocode.city]) {
                contain = YES;
                self.cityDict = dict;
                break;
            }
        }
        if (contain == NO) {
            self.cityDict = @{@"areaName":reGeocode.city, @"areaId":@""};
        }
    }
}

#pragma mark ------ 取消搜索 ------
- (void)didClickCancleButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.resultView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-50);
    } completion:^(BOOL finished) {
        [self.resultView resetDataArray];
        [self.resultView removeFromSuperview];
    }];
}

#pragma mark ------ 开始搜索 ------
- (void)textFieldDidBeginEdit:(UITextField *)textField {
    if (![self.resultView isDescendantOfView:self.view]) {
        textField.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:self.resultView];
        [UIView animateWithDuration:0.3 animations:^{
            self.resultView.frame = CGRectMake(0, NAVIGATION_H+50, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-50);
        }];
    }
}

#pragma mark ------ 点击搜索完成 ------
- (void)didClickSearchDoneButton:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark ------ 文字改变 ------
- (void)textFieldTextDidChanged:(NSString *)text {
    if ([text containsString:@" "]) {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (text.length > 0) {
        NSMutableArray *resultArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.cityArr) {
            if ([[dict[@"areaName"] stringValue] containsString:text]) {
                [resultArr addObject:dict];
            }
        }
        [self.resultView updateDataArray:resultArr];
    } else {
        [self.resultView resetDataArray];
    }
}

#pragma mark ------ 搜索结果视图 ------
- (ADLSearchCityResultView *)resultView {
    if (_resultView == nil) {
        _resultView = [[ADLSearchCityResultView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-50)];
        __weak typeof(self)weakSelf = self;
        _resultView.clickCity = ^(NSDictionary *dict) {
            if (weakSelf.selectedCity) {
                weakSelf.selectedCity(dict);
            }
        
            NSString *oreillyAddress =dict[@"areaName"];
            [weakSelf addresCity:oreillyAddress];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _resultView.willBeginDragging = ^{
            if ([weakSelf.searchView editing]) {
                [weakSelf.searchView endEditing];
            }
        };
    }
    return _resultView;
}
-(NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc]init];
    }
    return _dict;
}
-(void)addresCity:(NSString *)str{
    WS(ws);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            [ws.dict setValue:str forKey:@"areaName"];
            [ws.dict setValue:[NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.longitude] forKey:@"Longitude"];
            [ws.dict setValue:[NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.latitude] forKey:@"Latitude"];
            ws.addresBlock(ws.dict);
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
 
}
@end
