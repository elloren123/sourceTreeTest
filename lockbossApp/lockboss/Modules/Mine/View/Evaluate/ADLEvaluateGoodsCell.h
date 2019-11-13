//
//  ADLEvaluateGoodsCell.h
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLEvaluateGoodsCellDelegate <NSObject>

- (void)didClickEvaluateBtn:(UIButton *)sender;

@end

@interface ADLEvaluateGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (nonatomic, weak) id<ADLEvaluateGoodsCellDelegate> delegate;

@end


