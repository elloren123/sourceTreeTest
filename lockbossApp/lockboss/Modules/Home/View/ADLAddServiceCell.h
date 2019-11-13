//
//  ADLAddServiceCell.h
//  lockboss
//
//  Created by Han on 2019/6/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLAddServiceCellDelegate <NSObject>

- (void)didClickMarkBtn:(UIButton *)sender;

- (void)didClickAddBtn:(UIButton *)sender count:(NSInteger)count;

- (void)didClickReduceBtn:(UIButton *)sender count:(NSInteger)count;

@end

@interface ADLAddServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (nonatomic, weak) id<ADLAddServiceCellDelegate> delegate;

@end

