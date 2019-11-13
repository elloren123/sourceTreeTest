//
//  ADLAttachView.h
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLAttachView : UIView

/**
 下拉视图，点击外部 index = -1；

 @param frame 下拉视图Frame
 @param titleArr 标题数组
 @param finish 回调
 @return 下拉视图
 */
+ (instancetype)showWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr finish:(void(^)(NSInteger index))finish;

@end

