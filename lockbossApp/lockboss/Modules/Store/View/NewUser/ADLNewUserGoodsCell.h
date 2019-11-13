//
//  ADLNewUserGoodsCell.h
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLNewUserGoodsCellDelegate <NSObject>

- (void)didClickShoppingCarBtn:(UIButton *)sender;

@end

@interface ADLNewUserGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *monLab;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (nonatomic, weak) id<ADLNewUserGoodsCellDelegate> delegate;
@end
