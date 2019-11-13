//
//  ADLCheckInRecordCell.h
//  lockboss
//
//  Created by adel on 2019/8/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLCheckInRecordCellDelegate <NSObject>

- (void)didClickFeedbackBtn:(UIButton *)sender;

- (void)didClickImgView:(UIImageView *)imgView;

- (void)didClickPhoneBtn:(NSString *)phone;

@end

@interface ADLCheckInRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *ruzhuLab;

@property (weak, nonatomic) IBOutlet UILabel *lidianLab;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (nonatomic, weak) id<ADLCheckInRecordCellDelegate> delegate;

@end
