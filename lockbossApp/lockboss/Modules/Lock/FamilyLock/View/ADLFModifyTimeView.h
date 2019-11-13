//
//  ADLFModifyTimeView.h
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLFModifyTimeView : UIView

+ (instancetype)showWithTitle:(NSString *)title finish:(void(^)(NSString *dateStr))finish;

@end
