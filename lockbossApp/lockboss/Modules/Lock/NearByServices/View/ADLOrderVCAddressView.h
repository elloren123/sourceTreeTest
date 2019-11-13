//
//  ADLOrderVCAddressView.h  //时间选择view
//  lockboss
//
//  Created by bailun91 on 2019/9/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLOrderVCAddressView : UIView

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, assign) NSInteger focusIndex;

//选择条目时
@property (nonatomic, copy) void(^didSelectedRowBlock) (NSInteger index, NSString *timeStr);

- (void)updateViewInfos;

@end

NS_ASSUME_NONNULL_END
