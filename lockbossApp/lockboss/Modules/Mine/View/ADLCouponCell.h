//
//  ADLCouponCell.h
//  lockboss
//
//  Created by adel on 2019/5/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLCouponCellDelegate <NSObject>

- (void)didClickLingQuBtn:(UIButton *)sender;

@end

@interface ADLCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *fullMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *lingquBtn;
@property (weak, nonatomic) IBOutlet UIImageView *xrzxImgView;
@property (nonatomic, weak) id<ADLCouponCellDelegate> delegate;
@end
