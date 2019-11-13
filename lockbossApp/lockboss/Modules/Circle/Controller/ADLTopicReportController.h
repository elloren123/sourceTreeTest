//
//  ADLTopicReportController.h
//  lockboss
//
//  Created by Han on 2019/6/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLTopicReportController : ADLBaseViewController

@property (nonatomic, strong) NSString *reportId;

///(1群组 2话题 3评论 4回复 5用户)
@property (nonatomic, assign) NSInteger reportType;

@end

