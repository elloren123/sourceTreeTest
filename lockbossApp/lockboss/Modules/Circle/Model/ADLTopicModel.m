//
//  ADLTopicModel.m
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTopicModel.h"

@implementation ADLTopicModel

- (NSMutableArray *)replys {
    if (_replys == nil) {
        _replys = [NSMutableArray array];
    }
    return _replys;
}

- (NSMutableArray *)cellHArr {
    if (_cellHArr == nil) {
        _cellHArr = [[NSMutableArray alloc] init];
    }
    return _cellHArr;
}

@end
