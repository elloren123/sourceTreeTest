//
//  ADLSelectCityController.h
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSelectCityController : ADLBaseViewController

@property (nonatomic, copy) void (^selectedCity) (NSDictionary *cityDict);
@property (nonatomic, copy) void (^addresBlock) (NSMutableDictionary *addresDict);
//Longitude
//Latitude
//areaName
@end
