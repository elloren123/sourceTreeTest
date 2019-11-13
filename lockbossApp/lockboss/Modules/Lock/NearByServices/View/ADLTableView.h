//
//  ADLTableView.h
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UITableView *table;

//下拉刷新时触发
@property (nonatomic, copy) void(^tableViewHeaderRefreshBlock) (void);

//当tableView滚动到最底部时触发
@property (nonatomic, copy) void(^scrollToBottom) (void);

//切换类型时
@property (nonatomic, copy) void(^didClickbtnBlock) (NSInteger index);

//选择cell时
@property (nonatomic, copy) void(^didSelectedRow) (NSInteger index);

- (void)updateViewInfos ;

@end

NS_ASSUME_NONNULL_END
