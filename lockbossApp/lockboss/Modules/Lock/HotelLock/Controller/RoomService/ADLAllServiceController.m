//
//  ADLAllServiceController.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAllServiceController.h"
#import "ADLHomeServiceCell.h"
#import "ADLReservationServiceController.h"
#import "ADLGuestRoomsModel.h"
#import "ADLHotelServiceModel.h"
#import "ADLHomeServiceModel.h"
//#import "ADLSearcFriendsView.h"
//#import "ADLGuestRoomsModel.h"
@interface ADLAllServiceController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak)UICollectionView *serviceView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end
@implementation ADLAllServiceController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-20)/4 , 80);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *serviceView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH ,SCREEN_HEIGHT - NAVIGATION_H) collectionViewLayout:flowLayout];
    //self.flowLayout = flowLayout;
    
    serviceView.backgroundColor = [UIColor whiteColor];
    // 关闭滚动条
    serviceView.showsHorizontalScrollIndicator = NO;
    serviceView.showsVerticalScrollIndicator = NO;
    // 关闭弹簧效果
    serviceView.bounces =YES;
    
    // 1.设置数据源
    serviceView.dataSource = self;
    serviceView.delegate = self;
    [self.view addSubview:serviceView];
    self.serviceView = serviceView;
    // 用class来注册cell"告诉collectionView它所需要的cell如何创建"
    [self.serviceView registerClass:[ADLHomeServiceCell class] forCellWithReuseIdentifier:@"ServiceViewCell"];
    
    
    WS(ws);
    
    self.serviceView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws allServiceData:@""];
    } ];
    [ws allServiceData:@""];
    
    [self addRedNavigationView:ADLString(@"全部服务")];
}


-(void)allServiceData:(NSString *)strID {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"roomId"] = self.model.roomId;
    params[@"serviceId"] = strID;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_getServices parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
    
        [ws.serviceView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            [ws.titleArray removeAllObjects];
            NSArray *array = [ADLHotelServiceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            
            [ws.titleArray addObjectsFromArray:array];
            
        }else {
      
        }
        
        
        
        [ws.serviceView reloadData];
    } failure:^(NSError *error) {
        [ws.serviceView.mj_header endRefreshing];
    
        [ws.titleArray  removeAllObjects];
        [ws.serviceView reloadData];
    }];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
       ADLHomeServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceViewCell" forIndexPath:indexPath];
     cell.model = self.titleArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLReservationServiceController *vc = [[ADLReservationServiceController alloc]init];
  ADLHotelServiceModel *model = self.titleArray[indexPath.row];
    NSMutableDictionary *dict = model.mj_keyValues;
    [dict addEntriesFromDictionary:self.model.mj_keyValues];
    vc.model = [ADLHomeServiceModel mj_objectWithKeyValues:dict];
    [self.navigationController pushViewController:vc animated:YES];
}


-(NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"icon_room_money",@"icon_room_order",@"icon_room_clean",@"icon_room_clean"];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

@end
