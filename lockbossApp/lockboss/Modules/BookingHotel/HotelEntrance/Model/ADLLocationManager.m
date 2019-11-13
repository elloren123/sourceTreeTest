//
//  ADLLocationManager.m
//  lockboss
//
//  Created by adel on 2019/10/30.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ADLUserModel.h"

@interface ADLLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ADLLocationManager

+(ADLLocationManager *)sharedInstance{
    static ADLLocationManager *instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - private method
-(void)autoLocate{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许锁老大使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];

    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks[0];
        
        NSLog(@"Longitude = %f", place.location.coordinate.longitude);
        NSLog(@"Latitude = %f", place.location.coordinate.latitude);

       // [ADLUseodel sharedModel].read =@"";
        //NSString *str =   [ADLUserModel sharedModel].userId;
         ADLUserModel *model = [ADLUserModel readUserModel];
          model.Longitude = [NSString stringWithFormat:@"%f",place.location.coordinate.longitude];
          model.Latitude =  [NSString stringWithFormat:@"%f",place.location.coordinate.latitude];
          model.city = place.locality;
          [ADLUserModel saveUserModel:model];
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didGotLocation:)]) {
            [self.delegate locationManager:self didGotLocation:place.locality];
        }
    }];
}

@end
