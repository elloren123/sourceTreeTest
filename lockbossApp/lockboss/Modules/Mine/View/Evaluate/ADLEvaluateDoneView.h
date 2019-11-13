//
//  ADLEvaluateDoneView.h
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLEvaluateDoneView : UIView

@property (nonatomic, copy) void (^clickLookEvaluate) (NSMutableDictionary *evaDict);

- (void)updateList;

@end
