//
//  ADLHotelOrderModel.m
//  lockboss
//
//  Created by adel on 2019/10/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderModel.h"

@implementation ADLHotelOrderModel
//status;//int 1：正常(完成)、2：取消（取消订单）(完成)，3：退款(完成)，4：待处理，5：待入住，6：售后，7 代付款，8 待分配房间，9支付失败",
// // 0：全部，1：待支付（7 代付款），2：已支付（is_pay = 1：已付款），3：已完成（1：正常(完成)、3：退款(完成)），4：已取消（2：取消（取消订单））
-(NSString *)status:(NSInteger)str{
    
    switch (str) {
        case 1:
             return ADLString(@"完成");
            break;
        case 2:
            return ADLString(@"已取消");
            break;
        case 3:
            return ADLString(@"已退款");
            break;
        case 4://待处理，
            return ADLString(@"已支付");
            break;
        case 5://待入住，
            return ADLString(@"已支付");
            break;
        case 6:
            return ADLString(@"售后");
            break;
        case 7:
            return ADLString(@"待支付");
            break;
        case 8:
            return ADLString(@"已支付");
            break;
        case 9:
            return ADLString(@"支付失败");
            break;
        default:
            break;
    }

    return nil;
}
-(NSArray *)arraystatusType:(NSInteger)index isGrade:(NSInteger)isGrade refundStatus:(NSInteger)refundStatus{
    //status:1.正常(完成)、2：取消（取消订单）(完成)，3：退款(完成)，4：待处理，5：待入住，6：售后，7 代付款，8 待分配房 9支付失败",
    // "isPay": "int 是否付款，0：未付款，1：已付款"
    // 0：全部，1：待支付（7 代付款），2：已支付（is_pay = 1：已付款），3：已完成（1：正常(完成)、3：退款(完成)），4：已取消（2：取消（取消订单））
    //refundStatus;退款状态  1款完成 2退款中 3 拒绝退款 4管理员主动退款
    NSArray *arr;
    if (index == 0) {
      return   arr = @[@"取消",@"去支付"];
    }else    if (index == 1) {
        if (isGrade == 0) {
          return   arr = @[@"删除",@"再次预订",@"去评论"];
        }else {
           return  arr = @[@"删除",@"再次预订"];
        }
    }else  if (index == 2) {
      return   arr = @[@"删除",@"再次预订"];
    }else if (index == 3) {
      return   arr = @[@"删除",@"再次预订"];
    }else if (index == 4) {
        if (refundStatus == 1) {
            return  arr = @[@"退款完成",@"删除"];
        }else
        if (refundStatus == 2) {
            return  arr = @[@"退款中",@"取消"];
        }else
            if (refundStatus == 3) {
                return  arr = @[@"拒绝退款",@"取消"];
            }else {
                return  arr = @[@"处理中"];
            }
    }else if (index == 5) {
        if (refundStatus == 2) {
            return  arr = @[@"退款中"];
        }else
        if (refundStatus == 3) {
             return  arr = @[@"拒绝退款"];
        }else {
            return  arr = @[@"退款"];
        }
      
    }else  if (index == 6) {
        return arr = @[@"删除",@"再次预订",@"去评论"];
    }else  if (index == 7) {
       return  arr = @[@"取消",@"去支付"];
    }else   if (index == 8) {
        if (refundStatus == 2) {
            return  arr = @[@"退款中"];
        }else
            if (refundStatus == 3) {
                return  arr = @[@"拒绝退款"];
            }else {
                return  arr = @[@"退款"];
            }
    }else   if (index == 9) {
        return arr = @[@"删除"];
    }else  if (index == 10) {
        return arr = @[@"取消"];
    }else if (index == 11) {
        return nil;
    }
    
    
    return nil;
}
@end
