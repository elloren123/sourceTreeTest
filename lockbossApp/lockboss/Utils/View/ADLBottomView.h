//
//  ADLBottomView.h
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLBottomView : UIView

/**
 底部List视图，点击取消index为-1

 @param titles 标题数组
 @param finish 点击标题回调
 @return 底部List视图
 */
+ (instancetype)showWithTitles:(NSArray *)titles finish:(void(^)(NSInteger index))finish;

@end
