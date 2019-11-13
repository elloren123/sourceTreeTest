//
//  ADLLockerPathController.m
//  lockboss
//
//  Created by adel on 2019/7/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLockerPathController.h"
#import "ADLAnnotationView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface ADLLockerPathController ()<MAMapViewDelegate,AMapNaviRideManagerDelegate>
@property (nonatomic, strong) AMapNaviRideManager *rideManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, assign) NSInteger distance;
@end

@implementation ADLLockerPathController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-20, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H+40)];
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.delegate = self;
    mapView.logoCenter = CGPointMake(100, 10);
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    for (UIGestureRecognizer *ges in mapView.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            [ges requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        }
    }
    
    AMapNaviRideManager *rideManager = [[AMapNaviRideManager alloc] init];
    rideManager.delegate = self;
    self.rideManager = rideManager;
    
    NSArray *startArr = [self.lockerDict[@"nowLocation"] componentsSeparatedByString:@","];
    NSArray *endArr = [self.lockerDict[@"userLocation"] componentsSeparatedByString:@","];
    if (startArr.count == 2 && endArr.count == 2) {
        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[startArr.lastObject doubleValue] longitude:[startArr.firstObject doubleValue]];
        AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[endArr.lastObject doubleValue] longitude:[endArr.firstObject doubleValue]];
        [self.rideManager calculateRideRouteWithStartPoint:startPoint endPoint:endPoint];
    } else {
        [ADLToast showMessage:@"锁匠行程获取失败！"];
    }
    
    [self addNavigationView:@"锁匠行程"];
}

#pragma mark ------ MAMapViewDelegate ------
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        ADLAnnotationView *annotationView = (ADLAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
        if (annotationView == nil) {
            annotationView = [[ADLAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
            annotationView.centerOffset = CGPointMake(0, -12);
        }
        if ([annotation.title isEqualToString:@"start"]) {
            annotationView.image = [UIImage imageNamed:@"path_start"];
        } else if ([annotation.title isEqualToString:@"end"]) {
            annotationView.image = [UIImage imageNamed:@"path_end"];
        }
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *lineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        lineRenderer.lineDashType = kMALineDashTypeSquare;
        lineRenderer.lineJoinType = kMALineJoinRound;
        lineRenderer.lineCapType = kMALineCapRound;
        lineRenderer.strokeColor = APP_COLOR;
        lineRenderer.lineWidth = 4;
        return lineRenderer;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    ADLAnnotationView *firstView = (ADLAnnotationView *)views.firstObject;
    ADLAnnotationView *lastView = (ADLAnnotationView *)views.lastObject;
    ADLAnnotationView *startView;
    ADLAnnotationView *endView;
    
    if ([firstView.annotation.title isEqualToString:@"start"]) {
        startView = firstView;
        endView = lastView;
    } else {
        startView = lastView;
        endView = firstView;
    }
    [self.mapView selectAnnotation:startView.annotation animated:YES];
    if (startView.frame.origin.y > endView.frame.origin.y) {
        [self.mapView setRotationDegree:180 animated:YES duration:0.5];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    ADLAnnotationView *annotationView = (ADLAnnotationView *)view;
    [annotationView.imgView sd_setImageWithURL:[NSURL URLWithString:[self.lockerDict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    annotationView.nameLab.text = self.lockerDict[@"name"];
    NSString *disStr = [NSString stringWithFormat:@"距您 %.2fkm",self.distance/1000.0];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:disStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_0083FD range:NSMakeRange(3, disStr.length-3)];
    annotationView.distanceLab.attributedText = attributeStr;
}

#pragma mark ------ AMapNaviRideManagerDelegate ------
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    AMapNaviRoute *route = rideManager.naviRoute;
    self.distance = route.routeLength;
    NSMutableArray *annotationArr = [[NSMutableArray alloc] init];
    
    NSArray *pointArr = route.routeCoordinates;
    NSInteger count = pointArr.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    
    for (int i = 0; i < count; i++) {
        AMapNaviPoint *point = pointArr[i];
        commonPolylineCoords[i].latitude = point.latitude;
        commonPolylineCoords[i].longitude = point.longitude;
        
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        annotation.title = @"";
        [annotationArr addObject:annotation];
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
    [self.mapView addOverlay:polyline];
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = CLLocationCoordinate2DMake(route.routeStartPoint.latitude, route.routeStartPoint.longitude);
    startAnnotation.title = @"start";
    
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.coordinate = CLLocationCoordinate2DMake(route.routeEndPoint.latitude, route.routeEndPoint.longitude);
    endAnnotation.title = @"end";
    
    [self.mapView addAnnotations:@[startAnnotation, endAnnotation]];
    [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake((SCREEN_HEIGHT-NAVIGATION_H)/4.0+36, 80, (SCREEN_HEIGHT-NAVIGATION_H)/4.0+36, 80) animated:NO];
}

- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error {
    [ADLToast showMessage:@"锁匠行程获取失败！"];
}

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error {
    [ADLToast showMessage:@"锁匠行程获取失败！"];
}

@end
