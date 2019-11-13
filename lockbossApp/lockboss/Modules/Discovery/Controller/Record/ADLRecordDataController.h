//
//  ADLRecordDataController.h
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

typedef NS_ENUM(NSInteger, ADLRecordType) {
    ADLRecordTypeAdd,
    ADLRecordTypeLook,
    ADLRecordTypeModify,
    ADLRecordTypeReview,
};

@interface ADLRecordDataController : ADLBaseViewController

@property (nonatomic, strong) NSString *projectId;

@property (nonatomic, assign) ADLRecordType type;

@property (nonatomic, copy) void (^modifySuccess) (void);

@end

