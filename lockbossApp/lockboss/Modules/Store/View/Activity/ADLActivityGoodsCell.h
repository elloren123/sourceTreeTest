//
//  ADLActivityGoodsCell.h
//  lockboss
//
//  Created by adel on 2019/5/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLActivityGoodsCellDelegate <NSObject>

- (void)didClickShoppingCarBtn:(UIButton *)sender;

@end

@interface ADLActivityGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *fullMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (nonatomic, weak) id<ADLActivityGoodsCellDelegate> delegate;
@end

