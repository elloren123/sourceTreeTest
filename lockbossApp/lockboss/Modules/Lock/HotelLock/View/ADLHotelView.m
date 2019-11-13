//
//  ADLHotelView.m
//  lockboss
//
//  Created by Adel on 2019/8/27.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelView.h"

#import "ADLBannerView.h"

#import "ADLNetWorkManager.h"

#import "ADELUrlpath.h"

#import "ADLDeviceModel.h"

#import "ADLHotelServiceModel.h"

#import <UIImageView+WebCache.h>

#import "ADLGuestRoomsModel.h"

#import "ADLguestRoomsCell.h"

#import "ADLSwitchHotelView.h"//酒店选择View

#import "ADLToast.h"

#import "ADLApiDefine.h"

@interface ADLHotelView ()<UIScrollViewDelegate,UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic ,strong) ADLBannerView *bannerView;

@property (nonatomic ,strong) UIImageView *bannnerPlaceHoldImgView;//banner的背景图片覆盖

@property (nonatomic ,strong) UIView *onBannerView;//写死的界面,后台没有对应的数据

@property (nonatomic ,strong) UIView *deviceView;//设备

@property (nonatomic ,strong) UIView *serviceView;//服务

@property (nonatomic ,strong) NSMutableArray *allRoomArray;//用户入住的所有的房间数据;可能同时入住多个酒店,多间房

@property (nonatomic ,strong) NSMutableArray *roomDeviceArray;//客房的设备

@property (nonatomic ,strong) NSMutableArray *roomServiceArray;//客房的服务

@property (nonatomic ,strong) UITableView *allRoomsTableView;

@property (nonatomic ,strong) ADLGuestRoomsModel *selectHotelModel;//保存的是当前获取数据使用的酒店客房信息


@end

@implementation ADLHotelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    //头部有偏移后的MJ刷新
    __weak typeof(self)weakSelf = self;
    MJRefreshNormalHeader *ref_hader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBannerData];
        [weakSelf getUserHotelMessage];
    }];
    ref_hader.ignoredScrollViewContentInsetTop = -NAVIGATION_H;
    self.scrollView.mj_header = ref_hader;
    
    ADLBannerView *bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_WIDTH*0.58) position:ADLPagePositionRight style:ADLPageStyleFlat];
    bannerView.bottomMargin = ceilf(SCREEN_HEIGHT*80/667)+16;
    [self.scrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    bannerView.clickBanner = ^(NSString *str) {
        if ([weakSelf.delegate respondsToSelector:@selector(bannelImgClickWith:)]) {
            [weakSelf.delegate bannelImgClickWith:str];
        }
    };
    
    [self.scrollView addSubview:self.bannnerPlaceHoldImgView];
    self.bannnerPlaceHoldImgView.hidden = YES;
    
    [self getBannerData];
    
    [self.scrollView addSubview:self.onBannerView];
    [self.onBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bannerView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*88/667));
    }];
    
    UIView *deviceV = [self fourDerviceItemViewWith:1];
    [self.scrollView addSubview:deviceV];
    self.deviceView = deviceV;
    
    UIView *serviceV = [self fourDerviceItemViewWith:2];
    [self.scrollView addSubview:serviceV];
    self.serviceView = serviceV;
    
    [deviceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.onBannerView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*120/667));
    }];
    
    [serviceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(deviceV.mas_bottom).offset(8);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*120/667));
    }];
    
    [self getUserHotelMessage];
    
    [self.scrollView addSubview:self.allRoomsTableView];
    
    [self.allRoomsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceV.mas_bottom).offset(8);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
        make.height.mas_equalTo(150);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goGetRoomMessageAgain) name:@"BOX_PAY_SUCCESS" object:nil];
    
}
#pragma mark ------ 盒子支付后更新数据 ------
-(void)goGetRoomMessageAgain{
    ADLLog(@"支付成功后,更新数据");
    [self getUserHotelMessage];
}

#pragma mark ------ banner上的View ------
-(UIView *)onBannerView {
    if (!_onBannerView) {
        _onBannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*90/667)];
        UIView *leftView = [self smallBannerViewWithImg:@"icon_hotel_food" title:@"美食" detail:@"江上往来人,\n但爱鲈鱼美。"];
        UITapGestureRecognizer *leftVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTapAction)];
        [leftView addGestureRecognizer:leftVTap];
        
        
        UIView *rightView = [self smallBannerViewWithImg:@"icon_hotel_techan" title:@"特产" detail:@"一骑红尘妃子笑,\n无人知是荔枝来。"];
        UITapGestureRecognizer *rightVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTapAction)];
        [rightView addGestureRecognizer:rightVTap];
        
        [_onBannerView addSubview:leftView];
        [_onBannerView addSubview:rightView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-8);
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(ceilf((SCREEN_WIDTH-15)/2));
            make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*80/667));
        }];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-8);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(ceilf((SCREEN_WIDTH-15)/2));
            make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*80/667));
        }];
    }
    return _onBannerView;
}
-(UIView *)smallBannerViewWithImg:(NSString *)imgName title:(NSString *)tit detail:(NSString *)detail{
    UIView *smView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-15)/2, SCREEN_HEIGHT*80/667)];
    smView.backgroundColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] colorWithAlphaComponent:0.8];
    smView.layer.shadowColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:0.43].CGColor;
    smView.layer.shadowOffset = CGSizeMake(0,4);
    smView.layer.shadowOpacity = 1;
    smView.layer.shadowRadius = 7;
    smView.layer.cornerRadius = 10;
    
    UIImageView *himgView = [[UIImageView alloc] init];
    himgView.image = [UIImage imageNamed:imgName];
    himgView.contentMode = UIViewContentModeScaleAspectFit;
    [smView addSubview:himgView];
    
    UILabel *titLab = [self createLabelFrame:CGRectZero font:16 text:tit texeColor:COLOR_333333];
    titLab.font = [UIFont boldSystemFontOfSize:16];
    [smView addSubview:titLab];
    UILabel *detailLab = [self createLabelFrame:CGRectZero font:12 text:detail texeColor:COLOR_333333];
    detailLab.numberOfLines = 2;
    [smView addSubview:detailLab];
    
    [himgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(smView.mas_centerY).offset(0);
        make.left.mas_equalTo(smView.mas_left).offset(ceilf(SCREEN_WIDTH*10/375));
        make.width.mas_equalTo(ceilf(SCREEN_WIDTH*35/375));
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*27/667));
    }];
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(smView.mas_top).offset(ceilf(SCREEN_HEIGHT*10/667));
        make.left.mas_equalTo(smView.mas_left).offset(ceilf(SCREEN_WIDTH*55/375));
        make.right.mas_equalTo(smView.mas_right).offset(-10);
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*20/667));
    }];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titLab.mas_bottom).offset(0);
        make.left.mas_equalTo(smView.mas_left).offset(ceilf(SCREEN_WIDTH*55/375));
        make.right.mas_equalTo(smView.mas_right).offset(-2);
        make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*50/667));
    }];
    
    return smView;
}
- (void)leftViewTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannelImgClickWith:)]) {
        NSString *addressString = [self.selectHotelModel.adress stringByReplacingOccurrencesOfString:@"|" withString:@""];
        [self.delegate bannelImgClickWith:[NSString stringWithFormat:@"0+%@", addressString]];
    }
}
- (void)rightViewTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannelImgClickWith:)]) {
        NSString *addressString = [self.selectHotelModel.adress stringByReplacingOccurrencesOfString:@"|" withString:@""];
        [self.delegate bannelImgClickWith:[NSString stringWithFormat:@"1+%@", addressString]];
    }
}

-(UIImageView *)bannnerPlaceHoldImgView {
    if (!_bannnerPlaceHoldImgView) {
        _bannnerPlaceHoldImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_WIDTH*220/375)];
        _bannnerPlaceHoldImgView.image = [UIImage imageNamed:@"icon_hotel_banner_1"];
        _bannnerPlaceHoldImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bannnerPlaceHoldImgView;
}


#pragma mark ------ 获取轮播数据 ------
-(void)getBannerData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:k_hotel_banner] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count == 0) {
                self.bannnerPlaceHoldImgView.hidden = NO;
            } else {
                self.bannnerPlaceHoldImgView.hidden = YES;
            }
            [self.bannerView updateBanner:resArr imgKey:nil urlKey:nil];
        }
    } failure:^(NSError *error) {
        self.bannnerPlaceHoldImgView.hidden = NO;
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

#pragma mark ------ 酒店设备\酒店服务 ------
-(void)getUserHotelMessage {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_getRoomInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLLog(@" 用户的客房查询 ---------  /n %@",responseDict[@"data"]);
            //为的是拿到酒店名称和对应的房间的ID,好获取房间的设备列表
            if(responseDict[@"data"]){
                
                NSDictionary *userHotelRoomMesDic = (NSDictionary *)[responseDict[@"data"] firstObject];
                
                UILabel *hotellab = [self.deviceView viewWithTag:111];
                
                hotellab.text = userHotelRoomMesDic[@"name"];
                
                [self.allRoomArray removeAllObjects];
                
                self.allRoomArray =  [ADLGuestRoomsModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
                
                if (!self.selectHotelModel) {
                    self.selectHotelModel = [self.allRoomArray firstObject];
                }
                
                [self saveSelectHotelModel];
                
                [self doSometingreloadTableView];
                
                //*********************************433的判断**********************************
                /**
                 如果是433的房间,则不请求房间设备信息,就一个设备;也没有服务项,直接隐藏
                 */
                NSString *is433 = userHotelRoomMesDic[@"is433"];
                if ([is433 isEqualToString:@"1"]) {
                    //直接用客房信息更改设备列表,就一个设备
                    [self setFTTDeviceShow];
                    [self hiddenServiceUI];
                    
                }else {
                    [self getUserRoomDeviceWithID:self.selectHotelModel.checkingInId];
                    [self getUserRoomSevciceWithID:self.selectHotelModel.roomId];
                }
                
            }
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
    
}

#pragma mark ------ 已支付的储物箱保存,神坑后台的逻辑 ------
//用储物箱的ID做key存储
-(void)saveBoxPayRecordWith:(NSArray *)deviceArr{
    if ([self.selectHotelModel.isBox isEqualToString:@"1"]) {
        for (ADLDeviceModel *model in deviceArr) {
            if ([model.deviceType isEqualToString:@"51"]) {
                [ADLUtils saveValue:@"1" forKey:model.deviceId];
            }
        }
    }
}

#pragma mark ------ 存储选中酒店model ------
-(void)saveSelectHotelModel{
    NSData *selectHotelModelData = [NSKeyedArchiver archivedDataWithRootObject:self.selectHotelModel];
    [ADLUtils saveValue:selectHotelModelData forKey:HOTEL_SEL_ROOM_MESSAGE];//存入选择的酒店的model
}

#pragma mark ------ 更新tableview布局,因为现在只有一个房间显示了,可以不更新 ------
-(void)doSometingreloadTableView {
    //让scrollView被子视图撑开;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.allRoomsTableView.mas_bottom).offset(20);
    }];
    [self.allRoomsTableView reloadData];
}
#pragma mark ------ 酒店的设备列表 ------
-(void)getUserRoomDeviceWithID:(NSString *)checkingInId{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:checkingInId forKey:@"checkingInId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_getDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableArray *allDeviceArr = [NSMutableArray array];
            ADLLog(@"酒店的设备列表== ------\n %@",responseDict[@"data"]);
            allDeviceArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            [self.roomDeviceArray removeAllObjects];
            if (allDeviceArr.count>0) {
                NSArray *deleteDeviceTypeArr = @[@"21",@"233",@"t20",@"t80"];
                for (ADLDeviceModel *model in allDeviceArr) {
                    if (![deleteDeviceTypeArr containsObject:model.deviceType]) {
                        [self.roomDeviceArray addObject:model];
                        
                    }
                }
            }
            //添加一个轮询遍历酒店中是否有储物箱,是否付款,进行保存
            [self saveBoxPayRecordWith:self.roomDeviceArray];
            [self updataDeviceData];
            
        }else{
            [self.deviceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}
#pragma mark ------ 酒店的服务列表 ------
-(void)getUserRoomSevciceWithID:(NSString *)roomID{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:roomID forKey:@"roomId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_getServices parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLLog(@"服务 === %@",responseDict[@"data"]);
            [self.roomServiceArray removeAllObjects];
            self.roomServiceArray = [[ADLHotelServiceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]] mutableCopy];
            [self updataServiceData];
            
        }
    } failure:^(NSError *error) {
        if ([self.scrollView.mj_header isRefreshing]) {
            [self.scrollView.mj_header endRefreshing];
        }
    }];
}

-(void)updataDeviceData {
    NSArray *show_deviceArr = [NSArray array];//最多四个
    if (self.roomDeviceArray.count>4) {
        show_deviceArr = [self.roomDeviceArray subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        show_deviceArr = [self.roomDeviceArray copy];
    }
    if(show_deviceArr.count == 0){
        [self.deviceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        return;
    }else{
        [self.deviceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ceilf(SCREEN_HEIGHT*120/667));
        }];
    }
    
    for (int i = 0; i < 4; i++) {
        UIView *payView = [self.deviceView viewWithTag:i+9999];
        payView.hidden = YES;
        UIImageView *imgView = [self.deviceView viewWithTag:i+100];
        UILabel *titLab = [self.deviceView viewWithTag:i+1000];
        if(i<show_deviceArr.count){
            ADLDeviceModel *bottom_model = show_deviceArr[i];
            if ([bottom_model.deviceType isEqualToString:@"51"]) {
                payView.hidden = NO;
            }
            imgView.image = [ADLUtils lockImageWithType:bottom_model.deviceType];
            imgView.userInteractionEnabled = YES;
            titLab.text =  bottom_model.deviceName;
        }else{
            imgView.image = [UIImage imageNamed:@""];
            imgView.userInteractionEnabled = NO;
            titLab.text = @"";
        }
    }
    
}
-(void)updataServiceData {
    NSArray *show_ServiceArr = [NSArray array];//最多四个
    if (self.roomServiceArray.count>4) {
        show_ServiceArr = [self.roomServiceArray subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        show_ServiceArr = [self.roomServiceArray copy];
    }
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [self.serviceView viewWithTag:i+100];
        UILabel *titLab = [self.serviceView viewWithTag:i+1000];
        if (i<show_ServiceArr.count) {
            ADLHotelServiceModel *model = show_ServiceArr[i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"unlock_mcard"]];
            imgView.userInteractionEnabled = YES;
            titLab.text = model.name;
        }else {
            imgView.image = [UIImage imageNamed:@""];
            imgView.userInteractionEnabled = NO;
            titLab.text = @"";
        }
        
    }
}


-(UIView *)fourDerviceItemViewWith:(NSInteger)index{
    //index ==1 设备  ==2,服务
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, ceilf(SCREEN_HEIGHT*120/667))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    
    UILabel *bg_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, ceilf(SCREEN_HEIGHT*30/667))];
    bg_title.text = index == 1? @"酒店":@"酒店服务";
    bg_title.font = [UIFont systemFontOfSize:12];
    bg_title.textColor = COLOR_333333;
    bg_title.tag = 111;
    [bgView addSubview:bg_title];
    
    UIButton *bg_moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bg_moreBtn.frame = CGRectMake(SCREEN_WIDTH-60-18, 0, 60, ceilf(SCREEN_HEIGHT*30/667));
    [bg_moreBtn setTitle:@"更多" forState:UIControlStateNormal];//TODO  没有英文
    [bg_moreBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [bg_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    bg_moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (index == 1) {
        [bg_moreBtn addTarget:self action:@selector(clickMoreDevice:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [bg_moreBtn addTarget:self action:@selector(clickMoreService:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    bg_moreBtn.tag = 222;
    [bgView addSubview:bg_moreBtn];
    
    CGFloat imgW = bgView.size.width/4-10;//(间隙为5,图片太大了,没办法)
    CGFloat imgH = SCREEN_HEIGHT*46/667;
    CGFloat titW = imgW;
    CGFloat titH = 14;
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%4*(imgW+10) +5, ceilf(SCREEN_HEIGHT*40/667), imgW, imgH)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = i+100;
        [bgView addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        if (index == 1) {
            [tap addTarget:self action:@selector(clickDeviceItem:)];
        }else {
            [tap addTarget:self action:@selector(clickServiceItem:)];
        }
        [imgView addGestureRecognizer:tap];
        
        UIView *payV = [self payView];
        [bgView addSubview:payV];
        payV.hidden = YES;
        payV.tag = 9999+i;
        payV.frame = CGRectMake(ceilf(i%4*(imgW+10)+5+imgW-28),ceilf(SCREEN_HEIGHT*40/667-7),28,14);
        [bgView bringSubviewToFront:payV];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(i%4*(titW+10)+5, ceilf(SCREEN_HEIGHT*50/667)+imgH, titW, titH)];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.font = [UIFont systemFontOfSize:12];
        titLab.textColor = COLOR_333333;
        titLab.tag = i+1000;
        [bgView addSubview:titLab];
    }
    return bgView;
}
#pragma mark ------ 付费 item view ------
-(UIView *)payView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
    view.layer.cornerRadius = 7;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0].CGColor;
    UILabel *lab = [view createLabelFrame:view.frame font:9 text:@"付费" texeColor:[UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0]];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}


#pragma mark ------ 交互事件 ------
//更多设备
-(void)clickMoreDevice:(UIButton *)send{
    //如果是433,没有更多
    NSString *is433 = self.selectHotelModel.is433;
    if ([is433 isEqualToString:@"1"]) {
        //直接用客房信息更改设备列表,就一个设备
        [ADLToast showMessage:@"没有更多的设备了!" duration:2];
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreHotelRoomsDeivicesWithcheckingInId:)]) {
            [self.delegate moreHotelRoomsDeivicesWithcheckingInId:self.selectHotelModel.checkingInId];
        }
    }
}

//更多服务
-(void)clickMoreService:(UIButton *)send{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreHotelRoomsServicesWithcheckingInId:)]) {
        [self.delegate moreHotelRoomsServicesWithcheckingInId:self.selectHotelModel];
    }
}
//点击服务
-(void)clickServiceItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    ADLHotelServiceModel *serviceModel = self.roomServiceArray[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceClickWith:guestRoomsModel:)]) {
        [self.delegate serviceClickWith:serviceModel guestRoomsModel:self.selectHotelModel];
    }
    
}
//点击设备
-(void)clickDeviceItem:(UITapGestureRecognizer *)tap {
    NSString *is433 = self.selectHotelModel.is433;
    if ([is433 isEqualToString:@"1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deviceFTTClick)]) {
            [self.delegate deviceFTTClick];
        }
    }else {
        NSInteger index = tap.view.tag - 100;
        ADLDeviceModel *deviceModel = self.roomDeviceArray[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(deviceClickWith:checkID:)]) {
            [self.delegate deviceClickWith:deviceModel checkID:self.selectHotelModel.checkingInId];
        }
    }
}

#pragma mark ------ tableView ------
//q之前做的是显示用户所有的酒店入住信息,现在 是改成当前选择的那个酒店显示,只有一个了
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;//self.allRoomArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLguestRoomsCell* cell = [ADLguestRoomsCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.selectHotelModel;//self.allRoomArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(UITableView *)allRoomsTableView {
    if (!_allRoomsTableView) {
        _allRoomsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1920) style:UITableViewStylePlain];
        _allRoomsTableView.delegate = self;
        _allRoomsTableView.dataSource = self;
        _allRoomsTableView.layer.cornerRadius = 10;
        _allRoomsTableView.backgroundColor = [UIColor whiteColor];
        _allRoomsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return  _allRoomsTableView;
}

#pragma mark ------ 数据初始化 ------
-(NSMutableArray *)allRoomArray {
    if (!_allRoomArray) {
        _allRoomArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _allRoomArray;
}

-(NSMutableArray *)roomDeviceArray {
    if (!_roomDeviceArray) {
        _roomDeviceArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _roomDeviceArray;
}
-(NSMutableArray *)roomServiceArray {
    if (!_roomServiceArray) {
        _roomServiceArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _roomServiceArray;
}

#pragma mark ------ 切换酒店 ------
-(void)selectHotel {
    [ADLSwitchHotelView showWithSelectHotelMessage:self.selectHotelModel allHotelMeesage:self.allRoomArray finish:^(ADLGuestRoomsModel * _Nonnull model) {
        self.selectHotelModel = model;
        [self saveSelectHotelModel];
        NSString *is433 = model.is433;
        if ([is433 isEqualToString:@"1"]) {
            //直接用客房信息更改设备列表,就一个设备
            [self setFTTDeviceShow];
            [self hiddenServiceUI];
        }else {
            //更新UI
            [self showServiceUI];
            [self getUserRoomDeviceWithID:model.checkingInId];
            [self getUserRoomSevciceWithID:model.roomId];
            [self.allRoomsTableView reloadData];
        }
    }];
}

#pragma mark ------ 433 系列处理 ------

//处理433(FTT)列表展示
-(void)setFTTDeviceShow{
    for (int i = 0; i < 4; i++) {
        UIView *payView = [self.deviceView viewWithTag:i+9999];
        payView.hidden = YES;
        UIImageView *imgView = [self.deviceView viewWithTag:i+100];
        UILabel *titLab = [self.deviceView viewWithTag:i+1000];
        if(i==0){
            imgView.image = [UIImage imageNamed:@"lock_other"];
            imgView.userInteractionEnabled = YES;
            titLab.text =  self.selectHotelModel.bluetoothName.length> 0?self.selectHotelModel.bluetoothName:@"网络锁";
        }else{
            imgView.image = [UIImage imageNamed:@""];
            imgView.userInteractionEnabled = NO;
            titLab.text = @"";
        }
    }
}

-(void)hiddenServiceUI {
    //隐藏service
    self.serviceView.hidden = YES;
    //更新 tableview布局
    [self.allRoomsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceView.mas_bottom).offset(8);
    }];
}

-(void)showServiceUI {
    self.serviceView.hidden = NO;
    [self.allRoomsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.serviceView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
    }];
}

@end
