//
//  ADLBookingHotelModel.m
//  lockboss
//
//  Created by adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBookingHotelModel.h"

@implementation ADLBookingHotelModel
-(NSMutableArray*)imageArray:(NSString *)image{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (image.length > 0) {
        [array addObject:image];
    }
    
    
    return array;
}
+(NSString *)iconStr:(NSInteger)number{
    
    switch (number) {
        case 1://热水器
            return @"reshuiqi";
            break;
        case 2://吹风机
            return @"chuifengji";
            break;
        case 3://热水壶
            return @"reshuihu";
            break;
        case 4://电话
            return @"dianhua";
            break;
        case 5://房间wifi
            return @"WIFI";
            break;
        case 6://全天热水
            return @"xishu";
            break;
        case 7://电视
            return @"dianshi";
            break;
        case 8://空调
            return @"kongtiao";
            break;
        case 9:
            return @"";
            break;
        case 10:
            return @"";
            break;
        default:
            break;
    }
    return nil;
    //kongtiao
    //mensuo
}
@end
