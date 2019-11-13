//
//  ADLSelectedGoodsView.h
//  lockboss
//
//  Created by bailun91 on 2019/9/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLSelectedGoodsView : UIView

@property (nonatomic, strong) NSMutableArray *itemArray;
//点击'清空'按钮时触发
@property (nonatomic, copy) void(^didCleanAllBlock) (NSInteger index);

//当item数量发生改变时触发block(flag: yes表示增加, no表示删除)
@property (nonatomic, copy) void(^goodNumChangedBlock) (NSString *goodName, BOOL flag);

- (void)updateUI ;

- (void)updateTableView:(NSInteger)row flag:(BOOL)flag ;

@end

NS_ASSUME_NONNULL_END
