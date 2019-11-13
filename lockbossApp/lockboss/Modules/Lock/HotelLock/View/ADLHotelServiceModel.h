//
//  ADLHotelServiceModel.h
//  lockboss
//
//  Created by adel on 2019/10/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLHotelServiceModel : NSObject

//@property (nonatomic ,strong) NSString *charge;//是否收费
//@property (nonatomic ,strong) NSString *chargeAmount;//收费金额
//@property (nonatomic ,strong) NSString *deleteFlag;//服务是否能删除 true代表可以删除，false代表不能删除
//@property (nonatomic ,strong) NSString *des;//描述
//@property (nonatomic ,strong) NSString *imageUrl;
//@property (nonatomic ,strong) NSString *serviceId;//服务id
//@property (nonatomic ,strong) NSString *serviceName;//服务名称
//@property (nonatomic ,strong) NSString *templateId;//模板id
//@property (nonatomic ,strong) NSString *type;//服务类型 1基础、2特色


@property (nonatomic ,strong) NSString *addDatetime;
@property (nonatomic ,strong) NSString *addUser;
@property (nonatomic ,strong) NSString *chargeAmount;
@property (nonatomic ,strong) NSString *code;
@property (nonatomic ,strong) NSString *companyId;
@property (nonatomic ,strong) NSString *deleteStatus;
@property (nonatomic ,strong) NSString *des;
@property (nonatomic ,strong) NSString *discountedChargeAmount;
@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *imageUrl;
//@property (nonatomic ,strong) NSString *initDataStatus;
@property (nonatomic ,strong) NSString *isCharge;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *templateId;
@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) NSString *updateDatetime;
@property (nonatomic ,strong) NSString *updateUser;


@end

NS_ASSUME_NONNULL_END
