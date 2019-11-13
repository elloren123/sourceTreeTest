//
//  ADLAddressView.h    //地址view
//  lockboss
//
//  Created by bailun91 on 2019/10/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLAddressView : UIView

@property (nonatomic, strong) NSMutableArray *itemArray;

//点击按钮时
@property (nonatomic, copy) void(^addressViewBtnClickedBlock) (NSInteger tag, NSDictionary *dict);
//选择cell时
@property (nonatomic, copy) void(^didSelectedRowBlock) (NSDictionary *dict);

- (void)updateViewInfos ;

@end

NS_ASSUME_NONNULL_END
