//
//  ADLGoodsEvaModel.m
//  lockboss
//
//  Created by adel on 2019/7/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsEvaModel.h"

@implementation ADLGoodsEvaModel

- (NSMutableArray *)sReplyArr {
    if (_sReplyArr == nil) {
        _sReplyArr = [[NSMutableArray alloc] init];
    }
    return _sReplyArr;
}

- (NSMutableArray *)sReplyHArr {
    if (_sReplyHArr == nil) {
        _sReplyHArr = [[NSMutableArray alloc] init];
    }
    return _sReplyHArr;
}

@end
