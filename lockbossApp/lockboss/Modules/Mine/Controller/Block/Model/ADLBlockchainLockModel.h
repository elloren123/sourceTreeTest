//
//  ADLBlockchainLockModel.h
//  ADEL-APP
//
//  Created by adel on 2019/9/2.
//

#import <Foundation/Foundation.h>


//"id":"string id",
//"homeId":"string 家庭户主userid",
//"deviceId":"string 设备id",
//"deviceName":"string 设备名称",
//"startDatetime":"long 开始时间",
//"endDatetime":"long 结束时间",
//"permanent":"int 1 永久，0：否"


//"addDatetime":"long 查询时间",
//"terminalCn":"string 酒店名称",
//"startDatetime":"long 权限的开始时间 adel_user_blockchain_query.start_datetime",
//"endDatetime":"long 权限的开始时间 adel_user_blockchain_query.end_datetime",
//"loginAccount":"string 用户的账户，使用redis获取当前操作人的登录帐号"


@interface ADLBlockchainLockModel : NSObject
@property (nonatomic, copy) NSString *id;//密钥id"
@property (nonatomic, copy) NSString *homeId;//string 家庭户主userid",
@property (nonatomic, copy) NSString *deviceId;//设备Id
@property (nonatomic, copy) NSString *deviceName;// 设备名称",
@property (nonatomic, copy) NSString *startDatetime;//开始时间
@property (nonatomic, copy) NSString *endDatetime;//结束时间
@property (nonatomic, copy) NSString *permanent;// 1 永久，0：否"



@property (nonatomic, copy) NSString *userId;// 酒店名称",
@property (nonatomic, copy) NSString *userName;//查询时间",
@property (nonatomic, copy) NSString *openType;//1手机 2卡 3密码 4 指纹 5手动（在房间里面手动开门） 6 组合"
@property (nonatomic, copy) NSString *openWay;// 1 开门类型255:无 1:前室外 2:后室内 3:前室外（常开）  4:钥匙",
@property (nonatomic, copy) NSString *result;//0失败1成功
@property (nonatomic, copy) NSString *block;//区块"
@property (nonatomic, copy) NSString *openDatetime;//开门时间



@property (nonatomic, copy) NSString *terminalCn;// 酒店名称",
@property (nonatomic, copy) NSString *addDatetime;//查询时间",
@property (nonatomic, copy) NSString *loginAccount;//用户的账户，使用redis获取当前操作人的登录帐号"

+(NSString *)getIphoneType;

-(NSString *)openType:(NSString *)openType;
@end

