//
//  ADLFamilyPresent.h
//  lockboss
//
//  Created by adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^Success)(id response);
typedef void (^Fail)(NSError * error);

@protocol DataSourceChangeDelegate <NSObject>

@optional

//用户VC改变--->更新数据源代理
- (void)numChangedWith:(NSString *)num indexPath:(NSIndexPath *)indexPath;

//数据源改变后,更新界面UI
- (void)reloadUI;

@end

@interface ADLFamilyPresent : NSObject<DataSourceChangeDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) ADLDeviceModel *selectModel;//选择的设备model

//请求数据
-(void)sendAFWithCheckinID:(NSString *)checkingInId Success:(Success)success Fial:(Fail)fail;

@end

NS_ASSUME_NONNULL_END
