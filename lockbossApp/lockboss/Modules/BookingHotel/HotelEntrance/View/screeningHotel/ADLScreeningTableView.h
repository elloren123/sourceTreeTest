//
//  ADLScreeningTableView.h
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADLScreeningTableView;


@protocol ADLScreeningTableViewDelegate <NSObject>

-(void)screeningTableView:(ADLScreeningTableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ADLScreeningTableView : UIView
@property (nonatomic ,copy)NSString *startTime;//入住时间
@property (nonatomic ,copy)NSString *endTime;//离店时间
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *contArray;
@property (nonatomic, weak) id<ADLScreeningTableViewDelegate> delegate;
@property (nonatomic ,copy)void(^blockBtn)(UIButton *btn);
@end

NS_ASSUME_NONNULL_END
