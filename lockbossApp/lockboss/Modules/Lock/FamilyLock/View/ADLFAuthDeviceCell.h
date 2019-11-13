//
//  ADLFAuthDeviceCell.h
//  lockboss
//
//  Created by Adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLSwitch;

@protocol ADLFAuthDeviceCellDelegate <NSObject>

- (void)didClickModifyTimeBtn:(UIButton *)sender;

- (void)didClickSwitch:(ADLSwitch *)sender;

@end

@interface ADLFAuthDeviceCell : UITableViewCell

@property (nonatomic, weak) id<ADLFAuthDeviceCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *lockView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UILabel *modelLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *plab;

@property (nonatomic, strong) ADLSwitch *pswitch;

@end
