//
//  ADLChainlockrecordCell.h
//  ADEL-APP
//
//  Created by adel on 2019/8/28.
//

#import <UIKit/UIKit.h>

@class ADLBlockchainLockModel;

@interface ADLChainlockrecordCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *lockName;



@property (nonatomic ,strong)ADLBlockchainLockModel *model;
@end


