//
//  ADLBookingHotelModel.h
//  lockboss
//
//  Created by adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>


//address = "\U5e7f\U4e1c\U7701\U6df1\U5733\U5e02\U5b9d\U5b89\U533a\U4f1f\U6cf0\U8def7\U9760\U8fd1\U5929\U6c34\U79d1\U6280\U5de5\U4e1a\U56ed";
//companyId = 1162171214857375744;
//companyName = "\U4e1c\U4e95\U5c97\U9152\U5e97";
//consumptionNum = 0;
//coverUrl = "http://129.204.67.226:80/group1/M00/00/16/CgoABl1_JUWABh95ABbIYX8PmB0834.jpg";
//floorPrice = "0.01";
//grade = 5;
//gradeNum = 1;
//id = null;
//latitude = "22.638895";
//longitude = "113.934077";
//star = 5;
//tags = null;
@interface ADLBookingHotelModel : NSObject
@property (nonatomic ,copy)NSString *id;
@property (nonatomic ,copy)NSString *address;//地址"
@property (nonatomic ,copy)NSString *companyId;//酒店ID
@property (nonatomic ,copy)NSString *companyName;// 酒店名称",
@property (nonatomic ,assign)NSInteger consumptionNum;//消费数量",
@property (nonatomic ,copy)NSString *coverUrl;// 酒店封面图片"
@property (nonatomic ,assign)CGFloat floorPrice;//float 多少钱起
@property (nonatomic ,copy)NSString *grade;//评分",
@property (nonatomic ,copy)NSString *gradeNum;//评论条数
@property (nonatomic ,assign)CGFloat latitude;
@property (nonatomic ,assign)CGFloat longitude;
@property (nonatomic ,copy)NSString *star;//星级",
@property (nonatomic ,copy)NSDictionary *tags;//早餐,游泳池
@property (nonatomic ,strong)NSString *policyDes;//酒店政策
@property (nonatomic ,strong)NSString *reserveDes;//酒店预订说明
@property (nonatomic ,strong)NSString *notes;//酒店注意事项
@property (nonatomic ,strong)NSString *able;//有效，0：失效",
@property (nonatomic ,copy)NSString *roomSellTypeId;// 销售房型id",
@property (nonatomic ,copy)NSString *name;// 房型名称",
@property (nonatomic ,assign)NSInteger moneyType;// 钱币类型",

@property (nonatomic ,assign)CGFloat price;//原价",
@property (nonatomic ,assign)float discountsPrice;//优惠价",
@property (nonatomic ,assign)int guestNum;//入住人数",
@property (nonatomic ,assign)int breakfastNum;// 早餐数量",
@property (nonatomic ,assign)NSInteger network;// 是否有宽带 0：无 1：有免费，2：有收费",
@property (nonatomic ,assign)NSInteger wifi;// 是否有wifi 0：无 1：有免费，2：有收费",
@property (nonatomic ,copy)NSString *applyDay;//适用星期，星期一到星期天：1,2,3,4,5,6,7 ，星期一到星期五：1,2,3,4,5",
@property (nonatomic ,copy)NSString *url1;//房型图片",
@property (nonatomic ,copy)NSString *url2;//"房型图片",
@property (nonatomic ,copy)NSString *url3;//房型图片",
@property (nonatomic ,copy)NSString *url4;// 房型图片",
@property (nonatomic ,copy)NSString *facility;//客房设备",
@property (nonatomic ,copy)NSString *expensePolicyDes;//客房政策
@property (nonatomic ,copy)NSString *des;// 客房介绍",
@property (nonatomic ,assign)int has;//1收藏，0未收藏"


@property (nonatomic ,copy)NSString *addUserName;
@property (nonatomic ,assign)long gradeDatetime;
@property (nonatomic ,copy)NSString *gradeMessages;



@property (nonatomic ,copy)NSString *gradeUrl1;
@property (nonatomic ,copy)NSString *gradeUrl2;
@property (nonatomic ,copy)NSString *gradeUrl3;
@property (nonatomic ,copy)NSString *gradeUrl4;
@property (nonatomic ,copy)NSString *gradeUrl5;
@property (nonatomic ,copy)NSString *gradeUrl6;
@property (nonatomic ,copy)NSString *gradeUrl7;
@property (nonatomic ,copy)NSString *gradeUrl8;
@property (nonatomic ,copy)NSString *gradeUrl9;
@property (nonatomic ,copy)NSString *headShot;
@property (nonatomic ,assign)NSInteger numberImage;//图片数量"
//"url5": "String 房型图片",
//"url6": "String 房型图片",
//"url7": "String 房型图片",
//"url8": "String 房型图片",
//"url9": "String 房型图片"

-(NSMutableArray*)imageArray:(NSString *)image;
+(NSString *)iconStr:(NSInteger)number;
@end


