//
//  ADLDinnerModel.h
//  lockboss
//
//  Created by bailun91 on 2019/9/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLDinnerModel : NSObject <NSCoding>

//菜品id
@property (nonatomic, copy) NSString *goodId;

//菜品图片url
@property (nonatomic, copy) NSString *ImgUrl;

//菜品名
@property (nonatomic, copy) NSString *dinnerName;

//月售数量
@property (nonatomic, copy) NSString *soldNumber;

//说明
@property (nonatomic, copy) NSString *leadString;

//价格
@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *number;     //总数量
@property (nonatomic, copy) NSString *bigNumber;  //大份数量
@property (nonatomic, copy) NSString *midNumber;  //中等数量
@property (nonatomic, copy) NSString *litNumber;  //小份数量

//sku属性数组
@property (nonatomic, copy) NSArray *skuList;

@end

NS_ASSUME_NONNULL_END
