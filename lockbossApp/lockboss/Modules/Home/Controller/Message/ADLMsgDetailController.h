//
//  ADLMsgDetailController.h
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLMsgDetailController : ADLBaseViewController

@property (nonatomic, strong) NSString *navTitle;

@property (nonatomic, strong) NSString *msgType;

@property (nonatomic, assign) BOOL unread;

@end
