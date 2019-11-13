//
//  ADLReviewCell.h
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLReviewCellDelegate <NSObject>

- (void)didClickImageView:(UIImageView *)imageView;

- (void)didClickAgreeBtn:(UIButton *)sender;

- (void)didClickIgnoreBtn:(UIButton *)sender;

@end

@interface ADLReviewCell : UITableViewCell
@property (nonatomic, weak) id<ADLReviewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ignoreBtn;
@end

