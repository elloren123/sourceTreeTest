//
//  ADLServiceModel.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServiceModel.h"

@implementation ADLServiceModel

- (NSMutableArray *)noteImageArr {
    if (_noteImageArr == nil) {
        _noteImageArr = [NSMutableArray array];
    }
    return _noteImageArr;
}

- (NSMutableArray *)noteImageUrlArr {
    if (_noteImageUrlArr == nil) {
        _noteImageUrlArr = [NSMutableArray array];
    }
    return _noteImageUrlArr;
}

@end
