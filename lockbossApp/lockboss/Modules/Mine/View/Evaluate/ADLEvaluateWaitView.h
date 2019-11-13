//
//  ADLEvaluateWaitView.h
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLEvaluateWaitView : UIView

@property (nonatomic, copy) void (^clickGoEvaluate) (NSDictionary *dict);

- (void)updateList;

@end
