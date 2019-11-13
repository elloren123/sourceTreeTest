//
//  ADLDinnerOrderDetailController.m
//  lockboss
//
//  Created by bailun91 on 2019/11/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerOrderDetailController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "ADLAnnotationView.h"
#import "ADLTimeOrStamp.h"
#import <UIImageView+WebCache.h>

@interface ADLDinnerOrderDetailController () <MAMapViewDelegate, AMapNaviRideManagerDelegate>

@property (nonatomic, strong) MAMapView              *mapView;
@property (nonatomic, strong) AMapNaviRideManager    *rideManager;
@property (nonatomic, strong) UIScrollView           *scrollView;
@property (nonatomic,   copy) NSString *storeAddress;     //商家地址经纬度
@property (nonatomic,   copy) NSString *shippingAddress;  //收货地址经纬度

@end

@implementation ADLDinnerOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"订单详情"];
    [self createContentView];
    [self getOrderDetailInfos];
}

- (void)createContentView {
    //初始化数据
    CGFloat mapViewHeight = 0;
    CGFloat orderHeaderHeight = 0;
    CGFloat goodsViewHeight   = 0;
    CGFloat orderinfoViewHeight = 165;
    
    NSString *orderType = self.orderInfos[@"status"];
    if ([orderType intValue] == 2 || [orderType intValue] == 3) {//订单状态2:待处理, 3:配送中
        mapViewHeight = SCREEN_HEIGHT/4;
        [self initMapView];
        orderHeaderHeight = 75;
    }
    
    NSMutableArray *orderGoods = [NSMutableArray arrayWithArray:self.orderInfos[@"orderGoods"]];
    [orderGoods addObject:@{@"goodsName":@"配送费", @"price":self.orderInfos[@"freight"]}];
    
    NSInteger number = orderGoods.count;
    goodsViewHeight = 106+number*30;
    NSLog(@"number = %zd,  orderType = %@", number, orderType);
    
    
    //------ *** ------ scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+mapViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-mapViewHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.contentSize = CGSizeMake(0, orderHeaderHeight+goodsViewHeight+orderinfoViewHeight);//暂时没有配送信息
    
    
    
    //------ *** ------ head view
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, orderHeaderHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:headView];
    
    UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
    headLab.textAlignment = NSTextAlignmentCenter;
    headLab.font = [UIFont systemFontOfSize:16];
    headLab.textColor = [UIColor blackColor];
    headLab.text = @"商家已接单 >";
    [headView addSubview:headLab];
    
    //配送lead信息
    UILabel *leadTxt = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    leadTxt.textAlignment = NSTextAlignmentCenter;
    leadTxt.font = [UIFont systemFontOfSize:13.5];
    leadTxt.textColor = [UIColor grayColor];
    [headView addSubview:leadTxt];
    
    //配送时间
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = [UIFont systemFontOfSize:13.5];
    timeLab.textColor = [UIColor grayColor];
    timeLab.text = [NSString stringWithFormat:@"预计送达: %@", [[ADLTimeOrStamp getTimeFromTimestamp:[self.orderInfos[@"appointmentTime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm:ss"] substringWithRange:NSMakeRange(11, 5)]];
    [headView addSubview:timeLab];
    
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, orderHeaderHeight-3, SCREEN_WIDTH, 3)];
    headLine.backgroundColor = SEPARATOR_COLOR;
    [headView addSubview:headLine];
    
    //更新信息
    if (orderType.intValue == 2) {
        headLab.text = @"订单待处理 >";
        leadTxt.text = @"待商家接单并准备商品, 具体情况请咨询商家";
    } else if (orderType.intValue == 3) {
        headLab.text = @"配送中 >";
        leadTxt.text = @"商家已接单, 商品准备中, 配送进度请咨询商家";
    }
    
    
    
    //------ *** ------ order view
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, orderHeaderHeight, SCREEN_WIDTH, goodsViewHeight)];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderView];
    
    //商家图片
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 3, 44, 44)];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:[self.orderInfos[@"shopImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    [orderView addSubview:iconImg];
    
    //商家名
    UILabel *orderHead = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH/2, 50)];
    orderHead.textAlignment = NSTextAlignmentLeft;
    orderHead.font = [UIFont systemFontOfSize:17];
    orderHead.textColor = [UIColor blackColor];
    orderHead.text = self.orderInfos[@"shopName"];
    [orderView addSubview:orderHead];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 17, 8, 16)];
    nextImg.image = [UIImage imageNamed:@"icon_xiao"];
    [orderView addSubview:nextImg];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [orderView addSubview:line];
    
    
    for (int i = 0 ; i < number; i++) {
        UILabel *goodName = [[UILabel alloc] initWithFrame:CGRectMake(20, 55+i*30, SCREEN_WIDTH/2, 30)];
        goodName.textAlignment = NSTextAlignmentLeft;
        goodName.font = [UIFont systemFontOfSize:14];
        goodName.textColor = [UIColor grayColor];
        goodName.text = [NSString stringWithFormat:@"%@   x%@", orderGoods[i][@"goodsName"], orderGoods[i][@"goodsNum"]];
        [orderView addSubview:goodName];
        
        UILabel *goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5, 55+i*30, SCREEN_WIDTH/5, 30)];
        goodPrice.textAlignment = NSTextAlignmentLeft;
        goodPrice.font = [UIFont systemFontOfSize:14];
        goodPrice.textColor = [UIColor blackColor];
        goodPrice.text = [NSString stringWithFormat:@"￥%.2f", [orderGoods[i][@"price"] floatValue]*[orderGoods[i][@"goodsNum"] floatValue]];
        [orderView addSubview:goodPrice];
        
        if (i == number-1) {
            goodName.text = orderGoods[i][@"goodsName"];//'配送费'字串Label
            goodPrice.text = [NSString stringWithFormat:@"￥%@", self.orderInfos[@"freight"]];//配送费金额Label
        }
    }
    
    for (int i = 0 ; i < 2; i++) {
        UIView *gapline = [[UIView alloc] initWithFrame:CGRectMake(0, 60+number*30+i*43, SCREEN_WIDTH, 3)];
        gapline.backgroundColor = SEPARATOR_COLOR;
        [orderView addSubview:gapline];
    }
    
    
    //------ *** ------ 商品合计view
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 63+number*30, SCREEN_WIDTH, 40)];
    totalView.backgroundColor = [UIColor whiteColor];
    [orderView addSubview:totalView];
    
    
    UILabel *totalTxtLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 40)];
    totalTxtLab.textAlignment = NSTextAlignmentLeft;
    totalTxtLab.font = [UIFont systemFontOfSize:16];
    totalTxtLab.textColor = [UIColor blackColor];
    totalTxtLab.text = @"合计";
    [totalView addSubview:totalTxtLab];
    
    //总金额
    UILabel *totalMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5, 0, SCREEN_WIDTH/5, 40)];
    totalMoneyLab.textAlignment = NSTextAlignmentLeft;
    totalMoneyLab.font = [UIFont systemFontOfSize:16];
    totalMoneyLab.textColor = COLOR_E0212A;
    totalMoneyLab.text = self.orderInfos[@"goodsAmount"];
    [totalView addSubview:totalMoneyLab];
    
    
    
    //------ *** ------ 订单信息view
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, orderHeaderHeight+goodsViewHeight, SCREEN_WIDTH, orderinfoViewHeight)];
    orderInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderInfoView];
    
    //订单信息text
    UILabel *orderText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 40)];
    orderText.textAlignment = NSTextAlignmentLeft;
    orderText.font = [UIFont systemFontOfSize:16];
    orderText.textColor = [UIColor blackColor];
    orderText.text = @"订单信息";
    [orderInfoView addSubview:orderText];
    
    NSString *payType = @"支付宝支付";
    if ([self.orderInfos[@"payType"] intValue] == 2) {
        payType = @"微信支付";
    }
    if (orderType.intValue == 0) {
        payType = @"还未支付";
    }
    NSArray *orderInfo = @[@"订单号", @"下单时间", @"支付方式", @"手机号码"];
    NSArray *orderDetailInfo = @[[self.orderInfos[@"id"] stringValue], [ADLTimeOrStamp getTimeFromTimestamp:[self.orderInfos[@"addDatetime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm"], payType, [self.orderInfos[@"contact"] stringValue]];
    for (int i = 0 ; i < 4; i++) {
        UILabel *leadInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 40+30*i, SCREEN_WIDTH/2, 30)];
        leadInfoLab.textAlignment = NSTextAlignmentLeft;
        leadInfoLab.font = [UIFont systemFontOfSize:14];
        leadInfoLab.textColor = [UIColor grayColor];
        leadInfoLab.text = orderInfo[i];
        [orderInfoView addSubview:leadInfoLab];
        
        
        UILabel *detailInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/5-20, 40+30*i, SCREEN_WIDTH*3/5, 30)];
        detailInfoLab.textAlignment = NSTextAlignmentRight;
        detailInfoLab.font = [UIFont systemFontOfSize:14];
        detailInfoLab.textColor = [UIColor darkGrayColor];
        detailInfoLab.text = orderDetailInfo[i];
        [orderInfoView addSubview:detailInfoLab];
    }
}

- (void)updateMapView {
    //设置地图信息
    if ([self.storeAddress containsString:@","] && [self.shippingAddress containsString:@","]) {
        NSLog(@"位置经纬度格式正确!!!");
        NSArray *locArray = [self.storeAddress componentsSeparatedByString:@","];
        NSArray *endArray = [self.shippingAddress componentsSeparatedByString:@","];
        if (locArray.count >= 2 && endArray.count >= 2) {
            AMapNaviPoint *staPoint = [AMapNaviPoint locationWithLatitude:[locArray[1] floatValue] longitude:[locArray[0] floatValue]];
            AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[endArray[1] floatValue] longitude:[endArray[0] floatValue]];
            
            //路径规划
            [_rideManager calculateRideRouteWithStartPoint:staPoint endPoint:endPoint];
            
            //移除原有的
            [self.mapView removeAnnotations:self.mapView.annotations];
            
            //终点
            MAPointAnnotation *_endAnnotation = [[MAPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = {[endArray[1] floatValue], [endArray[0] floatValue]};
            [_endAnnotation setCoordinate:coordinate];
            _endAnnotation.title = @"end";
            [self.mapView addAnnotation:_endAnnotation];
            
            //起点
            MAPointAnnotation *_beginAnnotation = [[MAPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinatebegin = {[locArray[1] floatValue], [locArray[0] floatValue]};
            [_beginAnnotation setCoordinate:coordinatebegin];
            _beginAnnotation.title = @"start";
            [self.mapView addAnnotation:_beginAnnotation];
            
            //设置地图中心点
            CLLocationCoordinate2D center = {([locArray[1] floatValue]+[endArray[1] floatValue])/2.0, ([locArray[0] floatValue]+[endArray[0] floatValue])/2.0};
            self.mapView.centerCoordinate = center;
        }
    }
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

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager
{
    NSLog(@"计算路径成功 !!!, %zd", rideManager.naviRoute.routeLength);
    AMapNaviRoute *route = rideManager.naviRoute;
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
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:polyline];//添加路径
    [self.mapView showOverlays:@[polyline] animated:YES];//动态显示路径
}
//设置路径样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *lineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        lineRenderer.lineDashType = kMALineDashTypeNone;
        lineRenderer.lineJoinType = kMALineJoinRound;
        lineRenderer.lineCapType = kMALineCapRound;
        lineRenderer.strokeColor = APP_COLOR;
        lineRenderer.lineWidth = 4;
        return lineRenderer;
    }
    return nil;
}
- (void)initMapView {
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT/4)];
    _mapView.delegate = self;
    _mapView.showsCompass = NO; //指北针
    //    _mapView.showsScale = NO;   //比例尺
    [self.view addSubview:_mapView];
    
    
    //路径规划管理对象
    _rideManager = [[AMapNaviRideManager alloc] init];
    [_rideManager setDelegate:self];
}

#pragma mark ------ 获取订单详情 ------
- (void)getOrderDetailInfos {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderInfos[@"id"] forKey:@"orderId"];//订单Id
    
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/detail.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        
        NSLog(@"获取订单详情返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            self.shippingAddress = responseDict[@"data"][@"coordinates"];
            [self getStoreInfo];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        [ADLToast showMessage:@"请求超时!"];
    }];
}

#pragma mark ------ 获取商家基本信息 ------
-(void)getStoreInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderInfos[@"id"] forKey:@"id"];
    [params setValue:@(1)                   forKey:@"type"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/store/queryStoreById.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求商家'基本'信息返回: %@", responseDict);
        
        [ADLToast hide];
        
        if ([responseDict[@"code"] intValue] == 10000) {//成功
            self.storeAddress = responseDict[@"data"][@"nowLocation"];
            [self updateMapView];
        }
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!"];
        }
    }];
}

@end
