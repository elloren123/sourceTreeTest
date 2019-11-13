//
//  ADLAfterSaleListCell.h
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLAfterSaleListCellDelegate <NSObject>

- (void)didClickApplyAfterSaleBtn:(UIButton *)sender;

@end

@interface ADLAfterSaleListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, weak) id<ADLAfterSaleListCellDelegate> delegate;
@end
