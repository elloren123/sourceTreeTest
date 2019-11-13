//
//  ADLHotelOrderModel.h
//  lockboss
//
//  Created by adel on 2019/10/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLHotelOrderModel : NSObject
@property (nonatomic ,copy)NSString *roomSellOrderId;// 订单id",
@property (nonatomic ,copy)NSString *companyName;//String 酒店名称",
@property (nonatomic ,copy)NSString *coverUrl;//String 酒店封面图片",
@property (nonatomic ,copy)NSString *name;//String 房型名称",
@property (nonatomic ,assign)double startDatetime;//long 入住时间",
@property (nonatomic ,assign)double endDatetime;//long 离开时间",
@property (nonatomic ,assign)int moneyType;//int 钱币类型",
@property (nonatomic ,copy)NSString *payPrice;//float 支付价格",
@property (nonatomic ,copy)NSString *address;//string 地址",
@property (nonatomic ,assign)int status;//int 1：正常(完成)、2：取消（取消订单）(完成)，3：退款(完成)，4：待处理，5：待入住，6：售后，7 代付款，8 待分配房间，9支付失败",
@property (nonatomic ,assign)int isPay;//int 是否付款，0：未付款，1：已付款"
@property (nonatomic ,assign)int refundStatus;//退款状态 1款完成 2退款中 3 拒绝退款 4管理员主动退款
@property (nonatomic ,assign)int isGrade;//1是评论  0否
@property (nonatomic ,assign)long addDatetime;
@property (nonatomic ,copy)NSString *addUser;
@property (nonatomic ,copy)NSString *addUserIdCard;
@property (nonatomic ,copy)NSString *addUserName;
@property (nonatomic ,copy)NSString *addUserPhone;
@property (nonatomic ,copy)NSString *applyDay;
@property (nonatomic ,copy)NSString *areaCode;
@property (nonatomic ,copy)NSString *breakfastNum;
@property (nonatomic ,copy)NSString *buildingId;
@property (nonatomic ,copy)NSString *buildingName;
@property (nonatomic ,copy)NSString *companyId;
@property (nonatomic ,copy)NSString *companyNameCnl;
@property (nonatomic ,copy)NSString *companyNameEn;
@property (nonatomic ,copy)NSString *consumptionNum;
@property (nonatomic ,copy)NSString *deleteStatusAdmin;
@property (nonatomic ,copy)NSString *deleteStatusUser;
@property (nonatomic ,copy)NSString *des;
@property (nonatomic ,copy)NSString *desCn;
@property (nonatomic ,copy)NSString *desEn;
@property (nonatomic ,copy)NSString *discountsPrice;
@property (nonatomic ,copy)NSString *expectCheckinDatetime;
@property (nonatomic ,copy)NSString *facility;
@property (nonatomic ,copy)NSString *floorId;
@property (nonatomic ,copy)NSString *floorName;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *gradeAppendMessages;
@property (nonatomic ,copy)NSString *gradeDatetime;
@property (nonatomic ,copy)NSString *gradeMessages;
@property (nonatomic ,copy)NSString *headShot;
@property (nonatomic ,copy)NSString *id;
@property (nonatomic ,copy)NSString *introduce;
@property (nonatomic ,copy)NSString *introduceCn;
@property (nonatomic ,copy)NSString *introduceEn ;
@property (nonatomic ,copy)NSString *nameCn;
@property (nonatomic ,copy)NSString *nameEn;
@property (nonatomic ,copy)NSString *network ;
@property (nonatomic ,copy)NSString *notes;//注意事项
@property (nonatomic ,copy)NSString *orgTradeId;
@property (nonatomic ,copy)NSString *payTime ;
@property (nonatomic ,copy)NSString *payType;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,copy)NSString *refundAdminDes;//管理员描述
@property (nonatomic ,copy)NSString *refundDes;
@property (nonatomic ,copy)NSString *refundId;
@property (nonatomic ,copy)NSString *refundPrice;
@property (nonatomic ,copy)NSString *refundUrl1;
@property (nonatomic ,copy)NSString *refundUrl2;
@property (nonatomic ,copy)NSString *refundUrl3;
@property (nonatomic ,copy)NSString *roomId;
@property (nonatomic ,copy)NSString *roomName ;
@property (nonatomic ,copy)NSString *roomSellTypeId ;
@property (nonatomic ,copy)NSString *settleAccounts;
@property (nonatomic ,copy)NSString *tbOpenid ;
@property (nonatomic ,copy)NSString *tbTradeId;
@property (nonatomic ,copy)NSString *telephone ;
@property (nonatomic ,copy)NSString *updateDatetime ;
@property (nonatomic ,copy)NSString *updateUser;
@property (nonatomic ,copy)NSString *userId;
@property (nonatomic ,copy)NSString *wxTradeId;

-(NSString *)status:(NSInteger )str;
-(NSArray *)arraystatusType:(NSInteger)index isGrade:(NSInteger)isGrade refundStatus:(NSInteger)refundStatus;
@end

NS_ASSUME_NONNULL_END
