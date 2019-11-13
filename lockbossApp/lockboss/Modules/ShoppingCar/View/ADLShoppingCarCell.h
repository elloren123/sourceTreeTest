//
//  ADLShoppingCarCell.h
//  lockboss
//
//  Created by adel on 2019/5/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLShoppingCarCellDelegate <NSObject>

- (void)didClickCheckBtn:(UIButton *)sender;

- (void)didClickAttributeBtn:(UIButton *)sender;

- (void)didClickServiceBtn:(UIButton *)sender;

- (void)didClickAddBtn:(UIButton *)sender count:(NSInteger)count;

- (void)didClickReduceBtn:(UIButton *)sender count:(NSInteger)count;

@end


@interface ADLShoppingCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *attributeLab;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (nonatomic, weak) id<ADLShoppingCarCellDelegate> delegate;
@end
