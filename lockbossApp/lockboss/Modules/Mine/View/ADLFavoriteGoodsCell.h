//
//  ADLFavoriteGoodsCell.h
//  lockboss
//
//  Created by Han on 2019/5/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLFavoriteGoodsCellDelegate <NSObject>

- (void)didClickShoppingCarBtn:(UIButton *)sender;

- (void)didClickCheckBtn:(UIButton *)sender;

@end

@interface ADLFavoriteGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *collectLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labRight;
@property (nonatomic, weak) id<ADLFavoriteGoodsCellDelegate> delegate;
@end

