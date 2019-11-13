//
//  ADLAllFamilyDeviceController.m
//  lockboss
//
//  Created by adel on 2019/10/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAllFamilyDeviceController.h"

#import "ADLAllFamilyDeviceHeadView.h"

#import "ADLAllFamilyDeviceCell.h"

#import "ADLGlobalDefine.h"

#import "ADLDeviceModel.h"

#import "ADLUtils.h"

#import "ADLLockHomeController.h"

#import "ADLGatewayAddDeviceController.h"

#import "ADLGatewayAddDetailController.h"

#import "ADLHotelUnlockController.h"

#import "ADLJuLiDeviceVController.h"
#import "ADLBlankView.h"

@interface ADLAllFamilyDeviceController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *mainCollectionView;

@property (nonatomic ,strong) NSMutableArray *dataArray;  //模型数据

@property (nonatomic ,strong) NSMutableArray *originalDataArray;//请求的原始数据;

@property (nonatomic ,strong) ADLBlankView *blankView;

@end

@implementation ADLAllFamilyDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:@"智能客房"];
//    CGFloat titleW = [ADLUtils calculateString:@"绑定设备" rectSize:CGSizeMake(MAXFLOAT, 44) fontSize:16].width+14;//计算字体长度
//    if (self.checkingInId ==nil) {
//        UIButton *rightTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-titleW, STATUS_HEIGHT, titleW, NAV_H)];
//        [rightTextBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
//        rightTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        rightTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
//        rightTextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [rightTextBtn setTitle:@"绑定设备" forState:UIControlStateNormal];
//        [rightTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [rightTextBtn addTarget:self action:@selector(bindDeviceClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationView addSubview:rightTextBtn];
//    }
    [self.view addSubview:self.mainCollectionView];
    
    [self.view addSubview:self.blankView];
    self.blankView.hidden = YES;
    [self.view bringSubviewToFront:self.blankView];
    
    WS(ws);
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getDataSource];
    } ];
    
    [self getDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gatewayNameChanged:) name:@"GATEWAY_NAME_CHANGE_NOTICATION" object:nil];
    
}

-(UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H) collectionViewLayout:layout];
        self.mainCollectionView.backgroundColor = [UIColor clearColor];
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [self.mainCollectionView registerClass:[ADLAllFamilyDeviceCell class] forCellWithReuseIdentifier:@"cellId"];
        
        //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
        [self.mainCollectionView registerClass:[ADLAllFamilyDeviceHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        //设置代理
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.dataSource = self;
    }
    return _mainCollectionView;
}

//其实不应该在这  0.0 实现再说
#pragma mark ------ 数据请求 ------
-(NSMutableArray *)dataArr {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}
-(NSMutableArray *)originalDataArray {
    if (!_originalDataArray) {
        _originalDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _originalDataArray;
}

-(void)getDataSource {
    if(self.checkingInId ==nil){
        [self getFamilyAllDevice];
    }else {
        //酒店
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.checkingInId forKey:@"checkingInId"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        __weak typeof(self) weakself = self;
        [ADLNetWorkManager postWithPath:ADEL_getDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            [weakself.mainCollectionView.mj_header endRefreshing];
            if ([responseDict[@"code"] integerValue] == 10000) {
                ADLLog(@" 用户的客房设备 ---------\n 数量: %zd,\n %@", [responseDict[@"data"] count],responseDict[@"data"]);
                NSString *str = responseDict[@"data"];
                if ([str isKindOfClass:[NSNull class]] || [str isEqual:[NSNull null]] || str == nil) {
                    //TODO  添加一个无设备View覆盖
                    self.blankView.hidden = NO;
                    return ;
                }
                 self.blankView.hidden = YES;
                NSMutableArray *allDeviceArr = [NSMutableArray array];
                for (NSDictionary *deviceDic in responseDict[@"data"]) {
                    ADLDeviceModel *model = [[ADLDeviceModel alloc] init];
                    model.deviceName = deviceDic[@"deviceName"];
                    model.name = deviceDic[@"deviceName"];
                    model.battery = [deviceDic[@"battery"] integerValue];
                    model.deviceCode = deviceDic[@"deviceCode"];
                    model.deviceMac = deviceDic[@"deviceMac"];
                    model.id = deviceDic[@"id"];
                    model.deviceId = deviceDic[@"deviceId"];
                    model.isFirstConnection = deviceDic[@"deviceStatus"];
                    model.status = deviceDic[@"status"];
                    model.deviceType = [NSString stringWithFormat:@"%@",deviceDic[@"deviceType"]];
                    [allDeviceArr addObject:model];
                }
                [self.dataArr removeAllObjects];
                [self.originalDataArray removeAllObjects];
                self.originalDataArray = [responseDict[@"data"] mutableCopy];
                
                NSMutableArray *juLiArray = [NSMutableArray array];
                NSMutableArray *gatewayArray = [NSMutableArray array];
                NSMutableArray *otherArray = [NSMutableArray array];
                
                if (allDeviceArr.count > 0) {
                    NSArray *juLiDeviceTypeArr = @[@"30",@"31"];
                    NSArray *deleteDeviceTypeArr = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
                    for (ADLDeviceModel *model in allDeviceArr) {
                        if ([juLiDeviceTypeArr containsObject:model.deviceType]) {
                            [juLiArray addObject:model];
                        } else if ([deleteDeviceTypeArr containsObject:model.deviceType]) {
                            [gatewayArray addObject:model];
                        } else {
                            [otherArray addObject:model];
                        }
                    }
                }
                if (juLiArray.count > 0) {
                    [self.dataArr addObject:juLiArray];
                }
                if(gatewayArray.count > 0){
                    [self.dataArr addObject:gatewayArray];
                }
                if(otherArray.count > 0){
                    [self.dataArr addObject:otherArray];
                }
                [self.mainCollectionView reloadData];
                
            }
        } failure:^(NSError *error) {
            [self.mainCollectionView.mj_header endRefreshing];
        }];
        
    }
    
}

//***********重写家庭的智能客房设备列表************
//请求两个接口,1.ADEL_family_getGatewayDevice --->获取到网关
//2.ADEL_family_getUserDeviceInfo--->获取到子设备
-(void)getFamilyAllDevice{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        __weak typeof(self) weakself = self;
        [ADLNetWorkManager postWithPath:ADEL_family_getGatewayDevice parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            [weakself.mainCollectionView.mj_header endRefreshing];
            ADLLog(@"获取到的用户网关信息------ %@",responseDict);
            
            __strong typeof(self)StrongSelf = weakself;
            [StrongSelf.dataArr removeAllObjects];
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSString *str = responseDict[@"data"];
                if ([str isKindOfClass:[NSNull class]] || [str isEqual:[NSNull null]] || str == nil) {
                    [StrongSelf getChildDevice];
                    return ;
                }else {
                    
                    @synchronized (self) {
                        
                        [StrongSelf.dataArr removeAllObjects];
                        [StrongSelf.originalDataArray removeAllObjects];
                        StrongSelf.originalDataArray = [responseDict[@"data"] mutableCopy];
                        NSArray *gatewayArray = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];//所有网关设备model
                        if(gatewayArray.count >0){
                            [StrongSelf.dataArr addObject:gatewayArray];
                            self.blankView.hidden = YES;
                        }
                        [StrongSelf getChildDevice];
                    }
                }
                
            }else{
                [StrongSelf getChildDevice];
            }
        } failure:^(NSError *error) {
            __strong typeof(self)StrongSelf = weakself;
            [StrongSelf getChildDevice];
        }];

}

-(void)getChildDevice{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getUserDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"获取到的用户 子 设备信息------ %@",responseDict);
        [self.mainCollectionView.mj_header endRefreshing];
       
        if ([responseDict[@"code"] integerValue] == 10000) {
            //                [self.dataArr removeAllObjects];
            
            
            
            NSArray *modelArray = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            //                NSMutableArray *modelArray = [NSMutableArray array];
            
            if (modelArray.count > 0) {
                //                    //有设备,去除 网关 ,内外机,壁虎233
                //                    NSArray *deleteDeviceTypeArr = @[@"233"];
                //                    for (ADLDeviceModel *model in self.dataArr) {
                //                        if (![deleteDeviceTypeArr containsObject:model.deviceType]){
                //                            [modelArray addObject:model];
                //                        }
                //                    }
                //                    if(modelArray.count >0){
//                [self.dataArr insertObject:modelArray atIndex:(self.dataArr.count>0?self.dataArr.count-1:0)];
                //                    }
                [self.dataArr addObject:modelArray];
                
            }
            if(self.dataArr.count == 0){
                self.blankView.hidden = YES;
            }else{
                self.blankView.hidden = NO;
            }
        }
         [self.mainCollectionView reloadData];
        
        
    } failure:^(NSError *error) {
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView reloadData];
    }];
}



#pragma mark ------ 通知 ------
-(void)gatewayNameChanged:(NSNotification *)info{
    [self getDataSource];
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ADLAllFamilyDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.devicemodel = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2, 100);
}

//header的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 40);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//间距通过cell内subView去设置
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
#pragma mark -- 返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ADLAllFamilyDeviceHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        NSString *titName = nil;
        ADLDeviceModel *model =self.dataArr[indexPath.section][indexPath.row];
        NSArray *deleteDeviceTypeArr = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"233"];
        NSArray *juLiDevTypeArr = @[@"30",@"31"];
        if ([deleteDeviceTypeArr containsObject:model.deviceType]) {
            titName = @"网关";
        } else if ([juLiDevTypeArr containsObject:model.deviceType]) {
            titName = @"居里防盗";
        } else {
            titName = @"智能客房";
        }
        
        header.headeLab.text = titName;
        reusableView = header;
    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //分情况,网关 是进入到网关的设置界面;  其他设备是回到设备的操作界面;
    ADLDeviceModel *devModel = self.dataArr[indexPath.section][indexPath.row];
    
    NSArray *juLiDevTypeArr = @[@"30",@"31"];
    NSArray *deleteDeviceTypeArr = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"233"];
    if (([juLiDevTypeArr containsObject:devModel.deviceType])) {
        ADLJuLiDeviceVController *juliVC = [[ADLJuLiDeviceVController alloc] init];
        juliVC.deviceId = devModel.deviceId;
        juliVC.deviceCode = devModel.deviceCode;
        juliVC.deviceType = devModel.deviceType;
        juliVC.deviceName = devModel.deviceName;
        juliVC.deviceStatus = devModel.isFirstConnection;
        juliVC.devArray = self.originalDataArray;
        [self.navigationController pushViewController:juliVC animated:YES];
        
    }else if ([deleteDeviceTypeArr containsObject:devModel.deviceType]) {
        ADLGatewayAddDeviceController *gatewayVC = [[ADLGatewayAddDeviceController alloc] init];
        gatewayVC.gatewayModel = devModel;
        //同时传递网关对应的子设备,减少网络请求;
        gatewayVC.gatewayChildDeviceArray = self.originalDataArray[indexPath.row][@"devices"];
        
        //保存要操作的网关的信息--->userdef
         [ADLUtils saveValue:self.originalDataArray[indexPath.row][@"code"] forKey:@"ADD_CHILD_GATEWAY_CODE"];
         [ADLUtils saveValue:self.originalDataArray[indexPath.row][@"id"] forKey:@"ADD_CHILD_GATEWAY_ID"];
        
        [self.navigationController pushViewController:gatewayVC animated:YES];
    }else {
        if (self.checkingInId == nil) {
            //进入到设备的控制界面,更改页面的操作设备信息;
            [ADLUtils saveValue:devModel.id forKey:FAMILY_DEVICE];
            ADLLockHomeController *homeVC = [[ADLLockHomeController alloc] init];
            [self.navigationController pushViewController:homeVC animated:YES];
        }else {
            [ADLUtils saveValue:devModel.deviceId forKey:HOTEL_DEVICE_SELECT];
            ADLHotelUnlockController *hotelVC = [[ADLHotelUnlockController alloc] init];
            hotelVC.checkingInId = self.checkingInId;
            [self.navigationController pushViewController:hotelVC animated:YES];
        }
        
    }
    
    //    if ([devModel.deviceType isEqualToString:@"21"] || [devModel.deviceType isEqualToString:@"25"]) {
    //        ADLGatewayAddDeviceController *gatewayVC = [[ADLGatewayAddDeviceController alloc] init];
    //        gatewayVC.gatewayModel = devModel;
    //        //同时传递网关对应的子设备,减少网络请求;
    //        gatewayVC.gatewayChildDeviceArray = self.originalDataArray[indexPath.row][@"devices"];
    //        [self.navigationController pushViewController:gatewayVC animated:YES];
    //    }else {
    //        //进入到设备的控制界面,更改页面的操作设备信息;
    //        [ADLUtils saveValue:devModel.id forKey:FAMILY_DEVICE];
    //        ADLLockHomeController *homeVC = [[ADLLockHomeController alloc] init];
    //        [self.navigationController pushViewController:homeVC animated:YES];
    //    }
}

#pragma mark ------ 绑定设备 ------
-(void)bindDeviceClick {
    ADLGatewayAddDetailController *addDeviceDetailVC = [[ADLGatewayAddDetailController alloc] init];
    [self.navigationController pushViewController:addDeviceDetailVC animated:YES];
}

@end
