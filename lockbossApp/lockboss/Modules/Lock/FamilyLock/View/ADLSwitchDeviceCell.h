//
//  ADLSwitchDeviceCell.h
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSwitchDeviceCellDelegate <NSObject>

- (void)didClickLockBtn:(UIButton *)sender;

@end

@interface ADLSwitchDeviceCell : UITableViewCell

@property (nonatomic, weak) id<ADLSwitchDeviceCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIImageView *shareView;

@property (weak, nonatomic) IBOutlet UIImageView *lockView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

@end
