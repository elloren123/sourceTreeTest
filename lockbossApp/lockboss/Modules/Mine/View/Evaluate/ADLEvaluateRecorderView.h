//
//  ADLEvaluateRecorderView.h
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLEvaluateRecorderView : UIView

- (void)updateData;

@property (nonatomic, copy) void (^clickDetailBtn) (NSDictionary *dict);

@property (nonatomic, copy) void (^clickEvaluateBtn) (NSMutableDictionary *dict);

@end
