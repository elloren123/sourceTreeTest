//
//  ADLSubmitOrderCell.h
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSubmitOrderCellDelegate <NSObject>

- (void)didClickImgView:(UIImageView *)imgView;

- (void)didClickAttributeBtn:(UIButton *)sender;

- (void)didClickServiceBtn:(UIButton *)sender;

- (void)didClickAddBtn:(UIButton *)sender;

- (void)didClickReduceBtn:(UIButton *)sender;

@end

@interface ADLSubmitOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *attributeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, weak) id<ADLSubmitOrderCellDelegate> delegate;

@end

