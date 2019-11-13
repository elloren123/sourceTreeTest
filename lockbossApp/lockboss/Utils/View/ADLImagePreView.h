//
//  ADLImagePreView.h
//  lockboss
//
//  Created by adel on 2019/4/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLImagePreView : UIView

/**
 网络图片预览

 @param imageViews 图片视图数组
 @param urlArr 图片地址数组
 @param currentIndex 当前的索引
 @return 网络图片预览器
 */
+ (instancetype)showWithImageViews:(NSArray *)imageViews urlArray:(NSArray *)urlArr currentIndex:(NSInteger)currentIndex;

@end
