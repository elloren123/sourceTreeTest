//
//  ADLOrderListCell.h
//  lockboss
//
//  Created by adel on 2019/6/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLOrderListCellDelegate <NSObject>

- (void)didClickStatusBtn:(UIButton *)sender;

- (void)didClickScrollView:(UIButton *)sender;

@end

@interface ADLOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *attributeLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (nonatomic, weak) id<ADLOrderListCellDelegate> delegate;
- (void)updateImageViewWithUrlArr:(NSArray *)urlArr;
@end

