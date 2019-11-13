//
//  ADLTopicDetailController.h
//  lockboss
//
//  Created by adel on 2019/6/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLTopicDetailController : ADLBaseViewController

@property (nonatomic, assign) BOOL praise;

@property (nonatomic, strong) NSString *topicId;

@property (nonatomic, strong) NSString *circleId;

@property (nonatomic, strong) NSString *publisherId;

@property (nonatomic, copy) void (^finish) (NSDictionary *dict);

@end
