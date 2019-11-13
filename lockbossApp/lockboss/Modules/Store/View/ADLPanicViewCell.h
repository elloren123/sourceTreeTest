//
//  ADLPanicViewCell.h
//  lockboss
//
//  Created by adel on 2019/4/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLPanicViewCell;

@protocol ADLPanicViewCellDelegate <NSObject>

- (void)clickPanicPurchaseBtn:(UIButton *)sender cell:(ADLPanicViewCell *)cell;

@end

@interface ADLPanicViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsLab;
@property (weak, nonatomic) IBOutlet UILabel *nowMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UIButton *panicBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgW;
@property (nonatomic, weak) id<ADLPanicViewCellDelegate> delegate;
@end
