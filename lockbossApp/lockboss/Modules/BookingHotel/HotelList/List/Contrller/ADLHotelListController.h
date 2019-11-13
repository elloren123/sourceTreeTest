//
//  ADLHotelListController.h
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface ADLHotelListController : ADLBaseViewController

@property (nonatomic ,strong)NSMutableDictionary *params;
@property (nonatomic ,copy)NSString *navTitle;
@property (nonatomic ,strong)NSDictionary *cityDict;//地名和经纬度

@property (nonatomic ,copy)NSString *searchType;//1模糊搜索  2精确搜索结果 3精品推荐

@property (nonatomic ,strong)NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
