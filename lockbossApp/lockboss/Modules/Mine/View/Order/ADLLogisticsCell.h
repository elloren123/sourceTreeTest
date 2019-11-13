//
//  ADLLogisticsCell.h
//  lockboss
//
//  Created by adel on 2019/7/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLLogisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *infLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end
