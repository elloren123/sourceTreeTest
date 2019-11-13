//
//  ADLMsgDetailCell.h
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLMsgDetailCell;

@protocol ADLMsgDetailCellDelegate <NSObject>

- (void)didClickPullBtn:(ADLMsgDetailCell *)cell;

- (void)didClickCheckBtn:(UIButton *)sender;

@end

@interface ADLMsgDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *pullBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullTextBtn;
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conRight;
@property (nonatomic, weak) id<ADLMsgDetailCellDelegate> delegate;
@end
