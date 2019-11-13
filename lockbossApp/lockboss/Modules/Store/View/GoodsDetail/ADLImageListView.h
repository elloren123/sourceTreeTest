//
//  ADLImageListView.h
//  lockboss
//
//  Created by adel on 2019/7/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLImageListView : UIView

+ (instancetype)listViewWithContentInserts:(UIEdgeInsets)contentInserts;

- (instancetype)initWithContentInserts:(UIEdgeInsets)contentInserts;

@property (nonatomic, copy) void (^imageViewHeightChanged) (CGFloat totalHeight);

///设置Url之前一定要先设置回调Block，不然会出现图片加载完成了block还没初始化，导致不能回调
@property (nonatomic, strong) NSArray *urlArr;

@end

