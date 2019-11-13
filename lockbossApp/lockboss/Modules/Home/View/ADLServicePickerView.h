//
//  ADLServicePickerView.h
//  lockboss
//
//  Created by adel on 2019/6/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLServicePickerView : UIView

+ (instancetype)showPickerWithFinishBlock:(void(^)(NSString *dateStr, NSInteger year))finishBlock;

@end

