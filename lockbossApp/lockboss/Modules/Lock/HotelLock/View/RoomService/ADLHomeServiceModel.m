//
//  ADLHomeServiceModel.m
//  lockboss
//
//  Created by adel on 2019/11/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHomeServiceModel.h"
@implementation ADLHomeServiceModel
{
    CGFloat _cellHeight;
    CGFloat _desHeight;
}

-(CGFloat)cellHeight {
    if (!_cellHeight) {
        CGSize  maxSize = CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT);
        CGFloat textH = [[NSString stringWithFormat:@"%@:%@",ADLString(@"我的描述"),self.serviceDes] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size.height;
        _cellHeight =textH;
    }
    return _cellHeight;
}


-(CGFloat)desHeight {
    if (!_desHeight) {
        CGSize  maxSize = CGSizeMake(SCREEN_WIDTH-62, MAXFLOAT);
        CGFloat textH;
        if (self.des.length == 0) {
            textH = 0;
        }else {
            textH = [[NSString stringWithFormat:@"%@:%@",ADLString(@"服务描述"),self.des] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size.height;
        }
        
        _desHeight =textH;
    }
    return _desHeight;
}

-(CGFloat)refundDesHeigh {
    if (!_refundDesHeigh) {
        CGSize  maxSize = CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT);
        CGFloat textH;
        if (self.des.length == 0) {
            textH = 0;
        }else {
            textH = [[NSString stringWithFormat:@"%@:%@",ADLString(@"已驳回"),self.refundDes] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size.height;
        }
        
        _refundDesHeigh =textH;
    }
    return _refundDesHeigh;
}



@end
