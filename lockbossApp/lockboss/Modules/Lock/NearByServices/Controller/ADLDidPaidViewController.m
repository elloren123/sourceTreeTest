//
//  ADLDidPaidViewController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDidPaidViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "ADLAnnotationView.h"
#import "ADLTimeOrStamp.h"
#import <UIImageView+WebCache.h>

@interface ADLDidPaidViewController () <MAMapViewDelegate, AMapNaviRideManagerDelegate>

@property (nonatomic, strong) MAMapView              *mapView;
@property (nonatomic, strong) AMapNaviRideManager    *rideManager;
@property (nonatomic, strong) UIScrollView           *scrollView;

@end

@implementation ADLDidPaidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self initMapView];
    [self createScrollView];
    [self getOrderdetailInfos];
}

- (void)createNavigationView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"支付完成";
    [navView addSubview:titLab];
}
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;

            
        default:
            break;
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
- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT*3/4-NAVIGATION_H)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    __weak typeof(self)WeakSelf = self;
    scrollView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新 !!!");
        [WeakSelf getOrderdetailInfos];
    }];
}
- (void)createContentView:(NSDictionary *)dict {
    NSLog(@"商家地址: %@", self.storeLocation);
    NSLog(@"订单地址: %@", dict[@"coordinates"]);
    
    //初始化数据
    NSMutableArray *orderGoods = [NSMutableArray arrayWithArray:dict[@"orderGoods"]];
    [orderGoods addObject:@{@"goodsName":@"配送费", @"price":dict[@"freight"]}];
    
    NSInteger number = orderGoods.count;
    NSLog(@"number = %zd,  orderGoods = %@", number, orderGoods);
    
    
    
    self.scrollView.contentSize = CGSizeMake(0, 342+number*30);//暂时没有配送信息
    
    
    
    //------ *** ------ head view
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.layer.cornerRadius = 3;
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
    leadTxt.text = @"由商家配送, 商品准备中, 配送进度请咨询商家";
    [headView addSubview:leadTxt];

    //配送时间
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = [UIFont systemFontOfSize:13.5];
    timeLab.textColor = [UIColor grayColor];
    timeLab.text = [NSString stringWithFormat:@"预计送达: %@", [[ADLTimeOrStamp getTimeFromTimestamp:[dict[@"delivery"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm:ss"] substringWithRange:NSMakeRange(11, 5)]];
    [headView addSubview:timeLab];
    
    
    
    
    //------ *** ------ order view
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 83, SCREEN_WIDTH, number*30+50)];
    orderView.backgroundColor = [UIColor whiteColor];
    orderView.layer.cornerRadius = 3;
    [self.scrollView addSubview:orderView];
    
    //商家图片
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:self.stoImgUrl] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    [orderView addSubview:iconImg];
    
    //商家名
    UILabel *orderHead = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH/2, 50)];
    orderHead.textAlignment = NSTextAlignmentLeft;
    orderHead.font = [UIFont systemFontOfSize:16];
    orderHead.textColor = [UIColor blackColor];
    orderHead.text = self.shopName;
    [orderView addSubview:orderHead];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 17, 8, 16)];
    nextImg.image = [UIImage imageNamed:@"icon_xiao"];
    [orderView addSubview:nextImg];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [orderView addSubview:line];
    
    
    for (int i = 0 ; i < number; i++) {
        UILabel *goodName = [[UILabel alloc] initWithFrame:CGRectMake(20, 50+i*30, SCREEN_WIDTH/2, 30)];
        goodName.textAlignment = NSTextAlignmentLeft;
        goodName.font = [UIFont systemFontOfSize:14];
        goodName.textColor = [UIColor grayColor];
        goodName.text = [NSString stringWithFormat:@"%@  X%@", orderGoods[i][@"goodsName"], orderGoods[i][@"goodsNum"]];
        [orderView addSubview:goodName];
        
        UILabel *goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5, 50+i*30, SCREEN_WIDTH/5, 30)];
        goodPrice.textAlignment = NSTextAlignmentLeft;
        goodPrice.font = [UIFont systemFontOfSize:14];
        goodPrice.textColor = [UIColor blackColor];
        goodPrice.text = [NSString stringWithFormat:@"￥%zd", [orderGoods[i][@"price"] integerValue]*[orderGoods[i][@"goodsNum"] integerValue]];
        [orderView addSubview:goodPrice];
        
        if (i == number-1) {
            goodName.text = orderGoods[i][@"goodsName"];//'配送费'字串Label
            goodPrice.text = [NSString stringWithFormat:@"￥%@", dict[@"freight"]];//配送费金额Label
        }
    }
    
    
    
    //------ *** ------ 商品合计view
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 136+number*30, SCREEN_WIDTH, 40)];
    totalView.backgroundColor = [UIColor whiteColor];
    totalView.layer.cornerRadius = 3;
    [self.scrollView addSubview:totalView];
    
    
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
    totalMoneyLab.text = dict[@"goodsAmount"];
    [totalView addSubview:totalMoneyLab];
    
    
    
    //------ *** ------ 订单信息view
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 179+number*30, SCREEN_WIDTH, 160)];
    orderInfoView.backgroundColor = [UIColor whiteColor];
    orderInfoView.layer.cornerRadius = 3;
    [self.scrollView addSubview:orderInfoView];
    
    //订单信息text
    UILabel *orderText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 40)];
    orderText.textAlignment = NSTextAlignmentLeft;
    orderText.font = [UIFont systemFontOfSize:16];
    orderText.textColor = [UIColor blackColor];
    orderText.text = @"订单信息";
    [orderInfoView addSubview:orderText];
    
    NSString *payType = @"支付宝支付";
    if ([dict[@"payType"] intValue] == 2) {
        payType = @"微信支付";
    }
    NSArray *orderInfo = @[@"订单号", @"下单时间", @"支付方式", @"手机号码"];
    NSArray *orderDetailInfo = @[self.orderId, [ADLTimeOrStamp getTimeFromTimestamp:[dict[@"addDatetime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm"], payType, dict[@"contact"]];
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
    
    
    
    //------ *** ------ 配送信息view
/*    UIView *sendInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 342+number*30, SCREEN_WIDTH, 160)];
    sendInfoView.backgroundColor = [UIColor whiteColor];
    sendInfoView.layer.cornerRadius = 3;
    [self.scrollView addSubview:sendInfoView];
    
    //配送信息text
    UILabel *sendText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 40)];
    sendText.textAlignment = NSTextAlignmentLeft;
    sendText.font = [UIFont systemFontOfSize:16];
    sendText.textColor = [UIColor blackColor];
    sendText.text = @"配送信息";
    [sendInfoView addSubview:sendText];
    
    
    NSArray *sendInfo = @[@"配送骑手", @"配送时间", @"配送地址", @"骑手号码"];
    NSArray *DetailSendInfo = @[@"张三", @"立即配送(预计30分钟到达)", @"深圳西丽南岗工业区", @"13888888888"];
    for (int i = 0 ; i < 4; i++) {
        UILabel *sendLeadLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 40+30*i, SCREEN_WIDTH/2, 30)];
        sendLeadLab.textAlignment = NSTextAlignmentLeft;
        sendLeadLab.font = [UIFont systemFontOfSize:14];
        sendLeadLab.textColor = [UIColor grayColor];
        sendLeadLab.text = sendInfo[i];
        [sendInfoView addSubview:sendLeadLab];
        
        
        UILabel *detailSendLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/5-20, 40+30*i, SCREEN_WIDTH*3/5, 30)];
        detailSendLab.textAlignment = NSTextAlignmentRight;
        detailSendLab.font = [UIFont systemFontOfSize:14];
        detailSendLab.textColor = [UIColor darkGrayColor];
        detailSendLab.text = DetailSendInfo[i];
        [sendInfoView addSubview:detailSendLab];
    }*/
    
    
    //设置地图信息
    if ([self.storeLocation containsString:@","] && [dict[@"coordinates"] containsString:@","]) {
        NSLog(@"位置经纬度格式正确!!!");
        NSArray *locArray = [self.storeLocation componentsSeparatedByString:@","];
        NSArray *endArray = [dict[@"coordinates"] componentsSeparatedByString:@","];
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

#pragma mark ------ 获取订单详情 ------
- (void)getOrderdetailInfos {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderId forKey:@"orderId"];//订单Id
    
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/detail.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        
        NSLog(@"获取订单详情返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            for (UIView *view in self.scrollView.subviews) {
                [view removeFromSuperview];//移除所有view
            }
            
            [self createContentView:responseDict[@"data"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        
        [ADLToast showMessage:@"请求超时!"];
    }];
}

@end
