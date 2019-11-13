//
//  ADLBlockChainQuerylogCell.h
//  ADEL-APP
//
//  Created by adel on 2019/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLBlockchainLockModel;
@interface ADLBlockChainQuerylogCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *lockName;
@property (nonatomic ,strong) ADLBlockchainLockModel *model;
@end

NS_ASSUME_NONNULL_END
