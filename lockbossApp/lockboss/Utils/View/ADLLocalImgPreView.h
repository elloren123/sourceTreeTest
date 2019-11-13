//
//  ADLLocalImgPreView.h
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLLocalImgPreView : UIView

/**
 本地图片预览

 @param imageViews 图片视图数组
 @param currentIndex 当前的索引
 @return 本地图片预览器
 */
+ (instancetype)showWithImageViews:(NSArray *)imageViews currentIndex:(NSInteger)currentIndex;

@end
