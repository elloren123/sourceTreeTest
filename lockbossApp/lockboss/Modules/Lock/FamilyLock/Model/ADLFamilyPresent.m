//
//  ADLFamilyPresent.m
//  lockboss
//
//  Created by adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilyPresent.h"
#import "ADLNetWorkManager.h"
#import "ADELUrlpath.h"


@implementation ADLFamilyPresent

-(void)sendAFWithCheckinID:(NSString *)checkingInId Success:(Success)success Fial:(Fail)fail{
    if (checkingInId == nil) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_family_getUserDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            
//            [self.scrollView.mj_header endRefreshing];
            
            ADLLog(@"获取到的用户设备信息------ %@",responseDict);
            if ([responseDict[@"code"] integerValue] == 10000) {
                
                [self.dataArray removeAllObjects];
                self.dataArray = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
                NSMutableArray *modelArray = [NSMutableArray array];
                
                if (self.dataArray.count > 0) {
                    //有设备,去除 网关 ,内外机,壁虎233
                    NSArray *deleteDeviceTypeArr = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"233"];
                    for (ADLDeviceModel *model in self.dataArray) {
                        if (![deleteDeviceTypeArr containsObject:model.deviceType]){
                            [modelArray addObject:model];
                        }
                    }
                    if (modelArray.count > 0) {
                        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:FAMILY_DEVICE]; //这里是把用户选中的设备进行了保存,现在取出
                        self.selectModel = modelArray.firstObject;//获取到设备后,把第一个设备设置为当前的操作设备
                        for (ADLDeviceModel *model in modelArray) {
                            if ([model.deviceId isEqualToString:deviceId]) {
                                self.selectModel = model;
                                break;
                            }
                        }
                        //如果之前没有已选择的设备,把第一个设置成默认选中的设备
                        if (![self.selectModel.deviceId isEqualToString:deviceId]) {
                            [ADLUtils saveValue:self.selectModel.deviceId forKey:FAMILY_DEVICE];
                        }
                        
                        //更新界面的设备信息,这里需要修改:更改界面的UI显示,和添加 设备列表的4个设备显示; TODO
//                        [self updateDeviceData];
                        
                    }
                }
            }
        } failure:^(NSError *error) {
//            [self.scrollView.mj_header endRefreshing];
        }];
    }
    
}

#pragma mark - lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

@end
