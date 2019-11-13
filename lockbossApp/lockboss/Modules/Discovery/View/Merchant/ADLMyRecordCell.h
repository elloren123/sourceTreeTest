//
//  ADLMyRecordCell.h
//  lockboss
//
//  Created by adel on 2019/6/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLMyRecordCellDelegate <NSObject>

- (void)didClickActionBtn:(UIButton *)sender;

@end

@interface ADLMyRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (nonatomic, weak) id<ADLMyRecordCellDelegate> delegate;
@end

