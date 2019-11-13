//
//  ADLRecorderEvaListCell.h
//  lockboss
//
//  Created by adel on 2019/6/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLRecorderEvaListCellDelegate <NSObject>

- (void)didClickRecorderDetailBtn:(UIButton *)sender;

- (void)didClickRecorderEvaluateBtn:(UIButton *)sender;

@end

@interface ADLRecorderEvaListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (nonatomic, weak) id<ADLRecorderEvaListCellDelegate> delegate;
@end
