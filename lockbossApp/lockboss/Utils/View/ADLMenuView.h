//
//  ADLMenuView.h
//  lockboss
//
//  Created by Han on 2019/8/15.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLMenuView : UIView

+ (instancetype)showWithView:(UIView *)sView
                       items:(NSArray<NSString *> *)itemArr
                      finish:(void (^)(NSInteger index, NSString *title))finish;

+ (instancetype)showWithRect:(CGRect)sRect
                       items:(NSArray<NSString *> *)itemArr
                      finish:(void (^)(NSInteger index, NSString *title))finish;

@end
