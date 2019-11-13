//
//  ADLBlockchainpriceModel.h
//  ADEL-APP
//
//  Created by adel on 2019/9/3.
//

#import <Foundation/Foundation.h>

//id;//string 主键id,
//homePeopleNum;//int 家庭初次绑定设备免费赠送使用人数,
//homeNum;//int 家庭初次绑定设备免费赠送数量,
//homeUnit;//int 家庭初次绑定设备免费赠送 赠送单位 1：天，2：周，3：月，4：季，5：年,
//companyPeopleNum;//int 酒店初次绑定设备免费赠送使用人数,
//companyNum;//int 酒店初次绑定设备免费赠送数量,
//companyUnit;//int 酒店初次绑定设备免费赠送 赠送单位 1：天，2：周，3：月，4：季，5：年,
//dayPrice;//float(8,2) 按天购买 原价,
//dayDiscountsPrice;//float(8,2) 按天购买 优惠价,
//dayGiveNum;//int 按天购买 赠送数量,
//dayGiveUnit;//int 按天购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
//weekPrice;//float(8,2) 按周购买 原价,
//weekDiscountsPrice;//float(8,2) 按周购买 优惠价,
//weekGiveNum;//int 按周购买 赠送数量,
//weekGiveUnit;//int 按周购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
//monthPrice;//float(8,2) 按月购买 原价,
//monthDiscountsPrice;//float(8,2) 按月购买 优惠价,
//monthGiveNum;//int 按月购买 赠送数量,
//monthGiveUnit;//int 按月购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
//seasonPrice;//float(8,2) 按季购买 原价,
//seasonDiscountsPrice;//float(8,2) 按季购买 优惠价,
//seasonGiveNum;//int 按季购买 赠送数量,
//seasonGiveUnit;//int 按季购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
//yearPrice;//float(8,2) 按年购买 原价,
//yearDiscountsPrice;//float(8,2) 按年购买 优惠价,
//yearGiveNum;//int 按年购买 赠送数量,
//yearGiveUnit;//int 按年购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
//permanentPrice;//float(8,2) 按永久购买 原价,
//permanentDiscountsPrice;//float(8,2) 按永久购买 优惠价,
//beginDatetime;//long 生效时间 该条规则生效时间，一个公司查询出多条，就使用生效时间内的

@interface ADLBlockchainpriceModel : NSObject
@property (nonatomic, copy) NSString *id;//string 主键id,
@property (nonatomic, assign)NSInteger homePeopleNum;//int 家庭初次绑定设备免费赠送使用人数,
@property (nonatomic, assign)NSInteger homeNum;//int 家庭初次绑定设备免费赠送数量,
@property (nonatomic, assign)NSInteger homeUnit;//int 家庭初次绑定设备免费赠送 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, copy) NSString *companyPeopleNum;//int 酒店初次绑定设备免费赠送使用人数,
@property (nonatomic, assign)NSInteger companyNum;//int 酒店初次绑定设备免费赠送数量,
@property (nonatomic, assign)NSInteger companyUnit;//int 酒店初次绑定设备免费赠送 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat  dayPrice;//float(8,2) 按天购买 原价,
@property (nonatomic, assign)CGFloat  dayDiscountsPrice;//float(8,2) 按天购买 优惠价,
@property (nonatomic, assign)NSInteger dayGiveNum;//int 按天购买 赠送数量,
@property (nonatomic, assign)NSInteger dayGiveUnit;//int 按天购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat weekPrice;//float(8,2) 按周购买 原价,
@property (nonatomic, assign)CGFloat weekDiscountsPrice;//float(8,2) 按周购买 优惠价,
@property (nonatomic, assign)NSInteger weekGiveNum;//int 按周购买 赠送数量,
@property (nonatomic, assign)NSInteger weekGiveUnit;//int 按周购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat monthPrice;//float(8,2) 按月购买 原价,
@property (nonatomic, assign)CGFloat monthDiscountsPrice;//float(8,2) 按月购买 优惠价,
@property (nonatomic, assign)NSInteger monthGiveNum;//int 按月购买 赠送数量,
@property (nonatomic, assign)NSInteger monthGiveUnit;//int 按月购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat seasonPrice;//float(8,2) 按季购买 原价,
@property (nonatomic, assign)CGFloat seasonDiscountsPrice;//float(8,2) 按季购买 优惠价,
@property (nonatomic, assign)NSInteger seasonGiveNum;//int 按季购买 赠送数量,
@property (nonatomic, assign)NSInteger seasonGiveUnit;//int 按季购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat yearPrice;//float(8,2) 按年购买 原价,
@property (nonatomic, assign)CGFloat yearDiscountsPrice;//float(8,2) 按年购买 优惠价,
@property (nonatomic, assign)NSInteger yearGiveNum;//int 按年购买 赠送数量,
@property (nonatomic, assign)NSInteger yearGiveUnit;//int 按年购买 赠送单位 1：天，2：周，3：月，4：季，5：年,
@property (nonatomic, assign)CGFloat permanentPrice;//float(8,2) 按永久购买 原价,
@property (nonatomic, assign)CGFloat permanentDiscountsPrice;//float(8,2) 按永久购买 优惠价,
@property (nonatomic, copy) NSString *beginDatetime;//long 生效时间 该条规则生效时间，一个公司查询出多条，就使用生效时间内的

@end


