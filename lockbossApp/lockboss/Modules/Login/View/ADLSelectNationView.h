//
//  ADLSelectPhoneView.h
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectNationView : UIView

///全屏
+ (instancetype)showWithFinish:(void (^)(NSDictionary *dict))finish;

///非全屏
+ (instancetype)showWithFrame:(CGRect)frame finish:(void (^)(NSDictionary *dict))finish;

@end
