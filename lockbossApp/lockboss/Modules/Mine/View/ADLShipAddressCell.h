//
//  ADLShipAddressCell.h
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLShipAddressCell;

@protocol ADLShipAddressCellDelegate <NSObject>

- (void)didClickEditBtn:(ADLShipAddressCell *)cell;

@end

@interface ADLShipAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *defaultLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (nonatomic, weak) id<ADLShipAddressCellDelegate> delegate;
@end


