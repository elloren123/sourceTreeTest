//
//  ADLHotelDetailsController.m
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelDetailsController.h"
#import "ADLHotelDetailsHeadView.h"
#import "ADLHotelDetailsTableViewCell.h"
#import "ADLScreeningroomView.h"
#import "HZCalendarViewController.h"
#import "ADLHotelIntroductionController.h"
#import "ADLGuestProfileController.h"
#import "ADLHotelCommentController.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelOrderController.h"
#import "ADLLockerPathController.h"
#import <AMapLocationKit/AMapLocationKit.h>


@interface ADLHotelDetailsController ()<UITableViewDataSource,UITableViewDelegate,ADLHotelDetailsHeadViewDelegate,ADLScreeningroomViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *array;
//@property (nonatomic ,weak)UIView *headView;
@property (nonatomic ,strong)ADLHotelDetailsHeadView *headView;
@property (nonatomic , weak)UIButton *rightImageBtn;
@property (nonatomic ,strong)NSMutableArray *nameArray;
@property (nonatomic ,strong)NSMutableArray *selectArray;
@property (nonatomic ,assign)NSInteger select;//1筛选状态

@property (nonatomic, strong) NSMutableDictionary *lockerDit;
@end

@implementation ADLHotelDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView:self.model.companyName];
  //  self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    ADLHotelDetailsHeadView *headView = [[ADLHotelDetailsHeadView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,350)];
    headView.array = [NSMutableArray arrayWithArray:@[@"全部早餐",@"全部房型"]];
    headView.model = self.model;
    headView.delegate = self;
    self.headView =headView;
    self.tableView.tableHeaderView = headView;

    
    UIButton *rightImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, STATUS_HEIGHT, 80, NAV_H)];
  //  rightImageBtn.backgroundColor = [UIColor redColor];
    rightImageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightImageBtn setTitle:ADLString(@"收藏") forState:UIControlStateNormal];
    [rightImageBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [rightImageBtn setTitle:ADLString(@"已收藏") forState:UIControlStateSelected];
    [rightImageBtn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
    [rightImageBtn setImage:[UIImage imageNamed:@"goods_collect_normal"] forState:UIControlStateNormal];
    [rightImageBtn setImage:[UIImage imageNamed:@"goods_collect_select"] forState:UIControlStateSelected];
   // rightImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [rightImageBtn addTarget:self action:@selector(collectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightImageBtn];
    self.rightImageBtn = rightImageBtn;
    [self HotenRoomData];
    [self demandCollect];
    [self addHotenRecord];
    [self HotenintroduceData];//酒店介绍
        self.select = 0;
    WS(ws);
    self.tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [ws.array  removeAllObjects];
    
        [ws HotenRoomData];
       [ws demandCollect];
        [ws HotenintroduceData];//酒店介绍
    }];
 
}

#pragma mark ------ 酒店介绍-----
- (void)HotenintroduceData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_introduce_company parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.model =  [ADLBookingHotelModel mj_objectWithKeyValues:responseDict[@"data"]];
        self.headView.model = self.model;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [[NSMutableArray alloc]init];
    }
    return _nameArray;
}
-(NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}
-(NSMutableDictionary *)lockerDit {
    
    if (!_lockerDit) {
        _lockerDit = [NSMutableDictionary dictionary];
    }
    return _lockerDit;
}
#pragma mark ------ 添加浏览记录 -----
- (void)addHotenRecord {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_company_add parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
         
        }
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        
    }];
}
#pragma    mark  ----- 点击收藏收藏改酒店 ----
-(void)collectBtn:(UIButton *)Btn {
    
    if (Btn.selected  == YES) {
        return ;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    //WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_favorite_add parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
    
        if ([responseDict[@"code"] integerValue] == 10000) {
     
            if (Btn.selected  == NO) {
                Btn.selected = YES;
            }
         
        }
     
    } failure:^(NSError *error) {
 
    }];
    
}
#pragma    mark  ----- 查询是否收藏改酒店 ----
-(void)demandCollect {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_company_this parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
           [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
          //   ws.rightImageBtn.height = NO;
            ADLBookingHotelModel *mdoel =  [ADLBookingHotelModel mj_objectWithKeyValues:responseDict[@"data"]];
               //"data": "{"has":"int 1收藏，0未收藏"}",
            if (mdoel.has == 0) {
         
            ws.rightImageBtn.selected = NO;
            }else {
            ws.rightImageBtn.selected = YES;
            }
        }
        
    } failure:^(NSError *error) {
       [ws.tableView.mj_header endRefreshing];
    }];
    
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
#pragma mark ------ 查询酒店客房-----
- (void)HotenRoomData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellType_lis parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
         [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.select = 0;
           ws.array =  [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
         
        }
         [ws.tableView reloadData];
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
     
    }];
}
//ADLHotelDetailsHeadViewdDlegate
-(void)htelDetailsHeadView:(ADLHotelDetailsHeadView *)ListsortingView didSelectRowAtIndexPath:(UIButton *)btn {
    
  //酒店详情
    if (btn.tag == 1) {
        ADLHotelIntroductionController *VC= [[ADLHotelIntroductionController alloc]init];
        VC.model = self.model;
        [self.navigationController pushViewController:VC animated:YES];
    }else
            //地址
        if (btn.tag == 2) {
        
            ADLLockerPathController *vc = [[ADLLockerPathController alloc]init];
               [self addresCity:self.model.address];
            vc.lockerDict = self.lockerDit;
            [self.navigationController pushViewController:vc animated:YES];
    }else
        //评论
        if (btn.tag == 3) {
            ADLHotelCommentController *vc = [[ADLHotelCommentController alloc]init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
    }else
          //日历
        if (btn.tag == 4) {
        HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
            
            // self.label.text = [NSString stringWithFormat:@"%@/%@",[goDay toString],[backDay toString]];
            ListsortingView.leave.text =[NSString stringWithFormat:@"入住:%@",[backDay toString]];//入住时间
            ListsortingView.stay.text =[NSString stringWithFormat:@"退房:%@",[goDay toString]];//退房时间
         NSInteger date = [ADLUtils fateDifferenceWithStartTime:[goDay date] endTime:[backDay date]];
            [ListsortingView.numDateBtn setTitle:[NSString stringWithFormat:@"共%d天",date] forState:UIControlStateNormal];
        }];
        vc.showImageIndex = 30;
        vc.isGoBack = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
          //房间筛选
    }else  if (btn.tag == 5) {
        [self.nameArray removeAllObjects];
        for (ADLBookingHotelModel *model in  self.array ) {
            [self.nameArray addObject:model.name];
        }
    ADLScreeningroomView *screeningroomView = [[ADLScreeningroomView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT) navigheight:NAVIGATION_H + 350];
        screeningroomView.deldgate  =self;
        screeningroomView.nameArray = self.nameArray;
    }
}
//            {
//                appointedTime = 1570809600000;
//                headShot = "https://testshop.adellock.com:8442/group1/M00/00/04/rBIA511TzfCADlK9AANsduRFzgA430.img";
//                loginAccount = 18176037960;
//                name = "\U674e\U56db";
//                nickName = 18176037960;
//                nowLocation = "113.93375299213014,22.637169851957346";
//                phone = 18176037960;
//                serviceArtisanInfoId = 1133915050810150912;
//                status = 1;
//                time = "\U9884\U8ba1\U4e0a\U95e8\U65f6\U95f4\Uff1a2019-10-12 00:00";
//                userId = 1128905732213837824;
//                userLocation = "113.952518,22.579947";
//                workStatus = 0;
//            }
-(void)addresCity:(NSString *)str{
    WS(ws);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
         
            [ws.lockerDit setValue:[NSString stringWithFormat:@"%f,%f",firstPlacemark.location.coordinate.longitude,firstPlacemark.location.coordinate.latitude] forKey:@"userLocation"];
            
         // [ws.lockerDit setValue:@"113.933298,22.637097" forKey:@"nowLocation"];
            
           ADLUserModel *model = [ADLUserModel readUserModel];
          NSString *lock = [NSString stringWithFormat:@"%@,%@",model.Longitude,model.Latitude];
            [ws.lockerDit setValue:lock forKey:@"nowLocation"];
            [ws.lockerDit setValue:model.headShot forKey:@"headShot"];
            [ws.lockerDit setValue:model.nickName forKey:@"name"];
//
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}

- (void)screeningroomView :(ADLScreeningroomView *)screeningroomView array:(NSMutableArray *)arrray iphone:(UIButton *)btn{
    self.headView.array = arrray;
    self.select = 1;
    if (arrray.count == 1) {
        [self.selectArray removeAllObjects];
    
            NSString *name = arrray[0];
            if ([name isEqualToString:ADLString(@"全部早餐")]) {
                self.selectArray = self.array.mutableCopy;
               
            } else if ([name isEqualToString:ADLString(@"有早餐")]) {
                for (ADLBookingHotelModel *model in self.array) {
                    if (model.breakfastNum  > 0) {
                        [self.selectArray addObject:model];
                    }
                    
                }
                
            } else if ([name isEqualToString:ADLString(@"无早餐")]) {
                for (ADLBookingHotelModel *model in self.array) {
                    if (model.breakfastNum  == 0) {
                        [self.selectArray addObject:model];
                    }
                    
                }

            } else{
                    if ([name isEqualToString:ADLString(@"全部房型")]) {
                        self.selectArray = self.array.mutableCopy;
                        
                    }else
                    for (ADLBookingHotelModel *model in self.array) {
                    if ([model.name isEqualToString:name]) {
                        [self.selectArray addObject:model];
                    }
                }
               
            }
            

     
    }
    if (arrray.count == 2) {
        [self.selectArray removeAllObjects];
        
    
            NSString *name = arrray[0];
            NSString *nam1 = arrray[1];
            if ([name isEqualToString:ADLString(@"全部早餐")] || [nam1 isEqualToString:ADLString(@"全部客房")]) {
                self.selectArray =  self.array.mutableCopy;
                
            } else if ([name isEqualToString:ADLString(@"有早餐")]) {
                for (ADLBookingHotelModel *model in self.array) {
                    if (model.breakfastNum  > 0) {
                        [self.selectArray addObject:model];
                    }else {
                        if ([model.name isEqualToString:nam1]) {
                            [self.selectArray addObject:model];
                        }
                    }
                    
                }
                
            } else if ([name isEqualToString:ADLString(@"无早餐")]) {
                for (ADLBookingHotelModel *model in self.array) {
                    if (model.breakfastNum  == 0) {
                        [self.selectArray addObject:model];
                    }else {
                        if ([model.name isEqualToString:nam1]) {
                            [self.selectArray addObject:model];
                        }
                    }
                    
                }
                
            }
     
        
    }

    [self.tableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    
    if (self.select == 1) {
          return self.selectArray.count;
    }else {
        return self.array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLHotelDetailsTableViewCell *cell = [ADLHotelDetailsTableViewCell cellWithTableView:tableView];
    WS(ws);
    cell.blockBtn = ^{
        ADLHotelOrderController *vc = [[ADLHotelOrderController alloc]init];
        vc.mode =ws.array[indexPath.row];
        vc.mode.companyName  = ws.model.companyName;
        vc.mode.address  = ws.model.address;
        vc.mode.policyDes = ws.model.policyDes;
        vc.mode.reserveDes = ws.model.reserveDes;
        vc.mode.notes = ws.model.notes;
        [ws.navigationController pushViewController:vc animated:YES];
    };
    if (self.select == 1) {
     cell.model = self.selectArray[indexPath.row];
    }else {
      cell.model = self.array[indexPath.row];
    }
   
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  123;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ADLGuestProfileController *VC= [[ADLGuestProfileController alloc]init];
    VC.model = self.array[indexPath.row];
    if (self.select == 1) {
        VC.model = self.selectArray[indexPath.row];
    }else {
       VC.model = self.array[indexPath.row];
    }
    VC.model.companyName  = self.model.companyName;
    VC.model.address  = self.model.address;
    VC.model.policyDes = self.model.policyDes;
    VC.model.reserveDes = self.model.reserveDes;
    VC.model.notes = self.model.notes;
    [self.navigationController pushViewController:VC animated:YES];
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       // _tableView.bounces = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}

@end
