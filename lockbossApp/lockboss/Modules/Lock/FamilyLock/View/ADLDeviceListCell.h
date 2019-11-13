//
//  ADLDeviceListCell.h
//  lockboss
//
//  Created by Adel on 2019/9/17.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLDeviceListCellDelegate <NSObject>

- (void)didClickBindingBtn:(UIButton *)sender;

@end

@interface ADLDeviceListCell : UITableViewCell

@property (nonatomic, weak) id<ADLDeviceListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *modelLab;

@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (weak, nonatomic) IBOutlet UIView *spView;

@end
