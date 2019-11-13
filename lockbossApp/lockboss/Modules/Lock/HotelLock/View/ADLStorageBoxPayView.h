//
//  ADLStorageBoxPayView.h
//  lockboss
//
//  Created by adel on 2019/10/24.
//  Copyright © 2019 adel. All rights reserved.
/**
 
 -----储物箱的开箱支付界面------
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLStorageBoxPayView : UIView

+(instancetype)showPayViewWithMessage:(NSDictionary *)payDic finishBlock:(void(^)(NSString *payway))finishBlock;

@end

NS_ASSUME_NONNULL_END
