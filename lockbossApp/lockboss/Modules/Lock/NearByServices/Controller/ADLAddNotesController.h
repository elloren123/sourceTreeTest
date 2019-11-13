//
//  ADLAddNotesController.h
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLAddNotesController : ADLBaseViewController

@property (nonatomic, copy) void(^addNotesInfoBlock) (NSString *text, NSMutableArray *markArr);

@end

NS_ASSUME_NONNULL_END
