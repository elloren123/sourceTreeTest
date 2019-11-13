//
//  ADLOrderDetailCell.h
//  lockboss
//
//  Created by adel on 2019/7/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLOrderDetailCellDelegate <NSObject>

- (void)didClickActionBtn:(UIButton *)sender;

@end

@interface ADLOrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *serNameLab;
@property (weak, nonatomic) IBOutlet UILabel *serMoneyLab;
@property (nonatomic, weak) id<ADLOrderDetailCellDelegate> delegate;
@end
