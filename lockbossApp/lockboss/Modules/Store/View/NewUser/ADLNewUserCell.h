//
//  ADLNewUserCell.h
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLNewUserCellDelegate <NSObject>

- (void)didClickLingQuBtn:(UIButton *)sender;

@end

@interface ADLNewUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *monLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (nonatomic, weak) id<ADLNewUserCellDelegate> delegate;
@end
