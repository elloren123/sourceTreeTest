//
//  ADLPwdKeyboardView.h
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLPwdKeyboardView : UIView

+ (instancetype)keyboardView;

@property (nonatomic, copy) void (^clickAction) (NSInteger num);

@end
