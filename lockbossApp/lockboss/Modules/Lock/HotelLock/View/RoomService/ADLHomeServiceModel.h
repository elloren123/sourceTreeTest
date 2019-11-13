//
//  ADLHomeServiceModel.h
//  lockboss
//
//  Created by adel on 2019/11/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ADLHomeServiceModel : NSObject
@property (nonatomic, copy) NSString * checkingInId;//入住id
@property (nonatomic, assign) NSInteger deviceStatus;// 设备状态  //1在线
@property (nonatomic, copy) NSString * deviceCode;//设备编码
@property (nonatomic, copy) NSString * gatewayCode;//网关编码
@property (nonatomic, copy) NSString * devicePassword;//设备密码
@property (nonatomic, copy) NSString * passwordId;// 密码ID
@property (nonatomic, copy) NSString * deviceType;//设备类型 类型22代表网关锁 ,21是壁虎
@property (nonatomic, copy) NSString * serviceOrderId;//服务订单id
@property (nonatomic, copy) NSString * roomId;//客房id
@property (nonatomic, copy) NSString * roomName;// 客房名称
@property (nonatomic, copy) NSString *deviceName;//设备名称
@property (nonatomic, copy) NSString *deviceId;//设备ID
@property (nonatomic, copy) NSString * floorId;//楼层id
@property (nonatomic, copy) NSString * floorName;//楼层名称
@property (nonatomic, copy) NSString * buildingId;//楼栋id
@property (nonatomic, copy) NSString * buildingName;//楼栋名称
@property (nonatomic, assign) CGFloat chargeAmount;//收费金额
@property (nonatomic, assign) NSInteger  isCharge;//类型   1收费，2免费
@property (nonatomic, copy) NSString * serviceId;//服务ID
@property (nonatomic, copy) NSString * serviceName;//服务名称
@property (nonatomic, assign) NSInteger  type;//类型   1基础，2特色
@property (nonatomic, assign) NSInteger status;//  |状态 1 正常， 2 待处理， 3 进行中， 4 已完成， 5已撤销 |6催单  7驳回
@property (nonatomic, copy) NSString * des;//我的描述
@property (nonatomic, copy) NSString * isPay;//0：未付款，1：已付款"
@property (nonatomic, copy) NSString * headShotUrl;//图片
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * id;//
@property (nonatomic, copy) NSString * addDatetime;//添加时间
@property (nonatomic, strong) NSString *startDatetime;// 开始时间
@property (nonatomic, copy) NSString * endDatetime;//退房s时间
@property (nonatomic, copy) NSString * updateDatetime;//更新时间
@property (nonatomic, assign) NSInteger isRead;//是否已度
@property (nonatomic, assign) NSInteger isUrge;//是否催单
@property (nonatomic, copy) NSString * serviceDes;//服务描述
@property (nonatomic, copy) NSString * refundDes;//驳回原因
@property (nonatomic, copy) NSString * openGroup;//1开启组合
@property (nonatomic, copy) NSString * openStatus;//1常开
@property (nonatomic, assign) NSInteger  securityLevel;//1总统 2副总统 3部长安全等级 4局长安全等级 5州长安全等级
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat desHeight;
@property (nonatomic, assign) CGFloat refundDesHeigh;//驳回原因


@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic, copy) NSString *jurisdiction;
@property (nonatomic, copy) NSString *battery;
@property (nonatomic, copy) NSString *isFirstConnection;

@property (nonatomic, copy) NSString *addUser;
@property (nonatomic, copy) NSString *discountedChargeAmount;//折扣金额
@property (nonatomic, copy) NSString *templateId;//1退房 2 续费 3换房
@property (nonatomic, copy) NSString *moneyType;//钱币类型
@property (nonatomic, copy) NSString *price;//原价"
@property (nonatomic, copy) NSString *discountsPrice;//优惠价
@property (nonatomic, copy) NSString *guestNum;//入住人数
@property (nonatomic, copy) NSString *breakfastNum;//早餐数量
@property (nonatomic, copy) NSString *network;//是否有宽带 0：无 1：有免费，2：有收费",
@property (nonatomic, copy) NSString *wifi;//是否有wifi 0：无 1：有免费，2：有收费",
@property (nonatomic, copy) NSString *applyDay;//适用星期，星期一到星期天：1,2,3,4,5,6,7 ，星期一到星期五：1,2,3,4,5",
@property (nonatomic, copy) NSString *companyId;// 公司id",
@property (nonatomic, copy) NSString *roomTypeId;//线下房型id"
@property (nonatomic, assign) CGFloat roomTypePrice;// 线下房型价格"
@property (nonatomic, copy)NSString *roomSellTypeId;//线上
@property (nonatomic, copy)NSString *roomTypeName;//房型名称
@end
