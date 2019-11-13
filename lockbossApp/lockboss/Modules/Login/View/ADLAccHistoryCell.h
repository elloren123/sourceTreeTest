//
//  ADLAccHistoryCell.h
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLAccHistoryCellDelegate <NSObject>

- (void)didClickDeleteBtn:(UIButton *)sender;

@end

@interface ADLAccHistoryCell : UITableViewCell

@property (nonatomic, weak) id<ADLAccHistoryCellDelegate> delegate;

@property (nonatomic, strong) UILabel *accountLab;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIView *spView;

@end
