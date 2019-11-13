//
//  ADLGuestRoomsModel.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/6/15.
//

#import <Foundation/Foundation.h>


@interface ADLGuestRoomsModel : NSObject<NSCoding>
//                         |参数名            |    参数类型    |    描述                     |
@property (nonatomic, strong) NSString *checkingInId;//入住id
@property (nonatomic, strong) NSString *hotelId;//入住id
@property (nonatomic, strong) NSString *roomId;// 客房id
@property (nonatomic, strong) NSString *roomName;// 客房名称
@property (nonatomic, strong) NSString *roomTypName;
@property (nonatomic, strong) NSString *startDatetime;// 开始时间
@property (nonatomic, strong) NSString *endDatetime;// 结束时间
@property (nonatomic, strong) NSString *customerServicePhone;//客服电话
@property (nonatomic, strong) NSString *roomType;//  客房类型
@property (nonatomic, strong) NSString *longitudes;// 经度
@property (nonatomic, strong) NSString *latitudes;//  纬度
@property (nonatomic, strong) NSString *name;//  酒店名称
@property (nonatomic, strong) NSString *adress;// 酒店地址
@property (nonatomic, strong) NSString *url;//  酒店图片
@property (nonatomic, strong) NSString *qrcode;//  433 开锁code
@property (nonatomic, strong) NSString *deviceQuantity;// 房间设备数量
@property (nonatomic, strong) NSString *bluetoothName;//  433 蓝牙名称
@property (nonatomic, strong) NSString *bluetoothKey;//  433 蓝牙key
@property (nonatomic, strong) NSString *is433;//  标记是否是433数据
@property (nonatomic, strong) NSString *version;//former =http://adelshop.com newest=http://adelcloud.com标记是否切请求头
@property (nonatomic ,strong) NSString *isBox;//客房的box是否支付过,0未支付,1支付了
@property (nonatomic , strong) NSString *roomTypeName;
@end
