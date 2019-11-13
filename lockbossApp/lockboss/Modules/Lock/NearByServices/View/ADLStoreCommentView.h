//
//  ADLStoreCommentView.h
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLStoreCommentView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel       *ZHScoreLab;    //综合得分label
@property (nonatomic, strong) UILabel       *WSScoreLab;    //卫生得分label
@property (nonatomic, strong) UIImageView   *wsStarImg1;
@property (nonatomic, strong) UIImageView   *wsStarImg2;
@property (nonatomic, strong) UIImageView   *wsStarImg3;
@property (nonatomic, strong) UIImageView   *wsStarImg4;
@property (nonatomic, strong) UIImageView   *wsStarImg5;
@property (nonatomic, strong) UILabel       *KWScoreLab;    //口味得分label
@property (nonatomic, strong) UIImageView   *kwStarImg1;
@property (nonatomic, strong) UIImageView   *kwStarImg2;
@property (nonatomic, strong) UIImageView   *kwStarImg3;
@property (nonatomic, strong) UIImageView   *kwStarImg4;
@property (nonatomic, strong) UIImageView   *kwStarImg5;
@property (nonatomic, strong) UILabel       *PSScoreLab;    //配送得分label
@property (nonatomic, strong) UITableView   *table;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel       *blankLab;

//选择条目时
@property (nonatomic, copy) void(^didSelectedSegmentedControl) (NSInteger index);
@property (nonatomic, copy) void(^tableViewHeaderRefreshBlock) (void);
@property (nonatomic, copy) void(^tableViewFooterRefreshBlock) (void);

- (void)updateCommentView:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
