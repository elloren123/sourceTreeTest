//
//  ADLSearchHoterController.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLSearchHoterController : ADLBaseViewController
@property (nonatomic, assign) BOOL PopView;
@property (nonatomic ,strong)NSDictionary *cityDict;
@property (nonatomic,copy)void(^searchContentBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
