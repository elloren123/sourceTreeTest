//
//  ADLScreeningableViewCell.h
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ADLScreeningableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel *startTime;
@property (nonatomic ,strong)UILabel *endTime;
@property (nonatomic ,strong)UIButton *locationBtn;
 + (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)titlestr:(NSString *)title content:(NSString *)content;

@property (nonatomic ,copy)void(^changedaddbtnBack)();
@end


