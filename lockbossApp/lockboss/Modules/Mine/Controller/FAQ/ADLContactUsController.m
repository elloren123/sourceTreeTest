//
//  ADLContactUsController.m
//  lockboss
//
//  Created by adel on 2019/4/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLContactUsController.h"
#import <MapKit/MapKit.h>
#import "ADLSheetView.h"

@interface ADLContactUsController ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@end

@implementation ADLContactUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topH.constant = NAVIGATION_H;
    [self addNavigationView:@"联系客服"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[self.lab1,self.lab2,self.lab3,self.lab4];
    for (int i = 0; i < 4; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelGes:)];
        [arr[i] addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressLabelGes:)];
        [arr[i] addGestureRecognizer:longPress];
    }
}

#pragma mark ------ Tap ------
- (void)tapLabelGes:(UITapGestureRecognizer *)tap {
    UILabel *tapLab = (UILabel *)tap.view;
    if ([tapLab.text containsString:@"深圳"]) {
        [self clickAddressLabel];
    } else if ([tapLab.text containsString:@"400"]) {
        NSString *phoneStr = [tapLab.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]];
        [[UIApplication sharedApplication] openURL:callUrl];
    } else {
        NSString *emailStr = [NSString stringWithFormat:@"mailto://%@?subject=售后服务",tapLab.text];
        emailStr = [emailStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailStr]];
    }
}

#pragma mark ------ LongPress ------
- (void)longPressLabelGes:(UILongPressGestureRecognizer *)longPress {
    UILabel *pressLab = (UILabel *)longPress.view;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [pressLab.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [ADLToast showMessage:@"复制成功"];
}

#pragma mark ------ 位置 ------
- (void)clickAddressLabel {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.636284,113.932256);
    NSString *pointName = @"爱迪尔";
    ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:@"导航到爱迪尔"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [sheetView addActionWithTitle:@"百度地图" handler:^{
            [self openMapWithCoordinate:coordinate pointName:pointName type:@"baidu"];
        }];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [sheetView addActionWithTitle:@"高德地图" handler:^{
            [self openMapWithCoordinate:coordinate pointName:pointName type:@"amap"];
        }];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [sheetView addActionWithTitle:@"腾讯地图" handler:^{
            [self openMapWithCoordinate:coordinate pointName:pointName type:@"tencent"];
        }];
    }
    [sheetView addActionWithTitle:@"苹果地图" handler:^{
        [self openMapWithCoordinate:coordinate pointName:pointName type:@"apple"];
    }];
    [sheetView show];
}

#pragma mark ------ 打开地图 ------
- (void)openMapWithCoordinate:(CLLocationCoordinate2D)coordinate pointName:(NSString *)pointName type:(NSString *)type {
    if ([type isEqualToString:@"apple"]) {
        MKMapItem *fromLocation = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placeMark];
        toLocation.name = pointName;
        [MKMapItem openMapsWithItems:@[fromLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
        
    } else if ([type isEqualToString:@"baidu"]) {
        NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",coordinate.latitude,coordinate.longitude,pointName] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    } else if ([type isEqualToString:@"amap"]) {
        NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",coordinate.latitude,coordinate.longitude,pointName] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    } else {
        NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%f,%f&policy=1",pointName,coordinate.latitude,coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

@end
