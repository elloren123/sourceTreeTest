//
//  ADLServiceModel.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADLServiceModel : NSObject

@property (nonatomic, strong) NSString *serviceId;

@property (nonatomic, strong) NSString *serviceName;

@property (nonatomic, assign) NSInteger serviceCount;

@property (nonatomic, assign) double servicePrice;

@property (nonatomic, strong) NSString *serviceNote;

@property (nonatomic, strong) NSMutableArray *noteImageArr;

@property (nonatomic, strong) NSMutableArray *noteImageUrlArr;

@end
