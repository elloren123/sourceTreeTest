//
//  ADLSheetView.h
//  lockboss
//
//  Created by Han on 2019/4/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSheetView : UIView

+ (instancetype)sheetViewWithTitle:(NSString *)title;

- (void)addActionWithTitle:(NSString *)title handler:(void (^)(void))handler;

- (void)show;

@end
